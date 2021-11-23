unit manualDrawWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, lal_connection, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.ComCtrls, ZAbstractRODataset, ZDataset,
  Vcl.StdCtrls, Vcl.Buttons;

type
  TmanualDrawW = class(TForm)
    workspacePanel: TPanel;
    Panel3: TPanel;
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel4: TPanel;
    drawGrid: TDBGrid;
    Panel5: TPanel;
    prpGrid: TDBGrid;
    drawSource: TDataSource;
    prpSource: TDataSource;
    fontSizeEdit: TEdit;
    fontSizeUD: TUpDown;
    highlightCheckbox: TCheckBox;
    applyButton: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure prpGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; AState: TGridDrawState);
    procedure drawGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; AState: TGridDrawState);
    procedure prpGridCellClick(Column: TColumn);
    procedure prpSourceDataChange(Sender: TObject; Field: TField);
    procedure fontSizeUDChanging(Sender: TObject; var AllowChange: Boolean);
    procedure prpGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure prpGridDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure drawGridDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure drawGridDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure highlightCheckboxClick(Sender: TObject);
    procedure applyButtonClick(Sender: TObject);
  private
    { Déclarations privées }
    pvCnx: TLalConnection;
    pvSertab,
    pvSize: integer;
    pvPrp,
    pvDraw,
    pvUpdDraw,
    pvUpdPrp,
    pvSelPrp,
    pvSelClb: TZReadOnlyQuery;
    pvTempTable: string;
    pvIsDirty: boolean;

    function createTempTable: string;
    procedure fillTable(const numrec: integer);
    procedure tds(const tds,size: integer);
    procedure bye(const numbye: integer);
    procedure write;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent; cnx: TlalConnection; const sertab: integer); reintroduce; overload;
  end;

implementation

{$R *.dfm}

uses
  lal_dbUtils, Contnrs, Math, tmUtils15, u_pro_strings, lal_sequence,
  System.UITypes, TMEnums;

var
 lcCnx: TLalConnection;
 lcLibClb: string;
 lcNumcell: integer;

{ TForm1 }

constructor TmanualDrawW.Create(AOwner: TComponent; cnx: TlalConnection;
  const sertab: integer);
begin
  inherited Create(AOwner);
  pvCnx := cnx;
  lcCnx := pvCnx;
  pvSertab := sertab;

  { work table }
  pvTempTable := createTempTable;

  pvPrp := TZReadOnlyQuery.Create(Self);
  pvPrp.Connection := pvCnx.get;
  pvPrp.SQL.Add('SELECT p.serjou,p.serptn,p.nomjou,p.libclb,p.codcls,p.classement,p.vrbrgl,p.numtds,p.serblo'
               +'  ,(SELECT count(*) FROM prptab x WHERE x.SERTAB = p.sertab AND x.CODCLB = p.codclb)||codclb numclb'
               +'  ,(SELECT count(*) FROM prptab x WHERE x.SERTAB = p.sertab AND x.serjou = 0) numbye'
               +'  ,t.taille size, t.nbrtds'
               +'  ,p.serprp,p.licence,p.codclb,p.seqcls,p.sertrn'
               +' FROM prptab p'
               +'   INNER JOIN tableau t ON p.sertab = t.sertab'
               +' WHERE p.sertab = ' + pvSertab.ToString
               +'   and serjou > 0'
               +' ORDER BY numclb desc,p.codcls,p.vrbrgl');
  prpSource.DataSet := pvPrp;

  pvDraw := TZReadOnlyQuery.Create(Self);
  pvDraw.Connection := pvCnx.get;
  pvDraw.SQL.Add('select *'
               +' from ' + pvTempTable
               +' order by numrow');
  drawSource.DataSet := pvDraw;

  pvUpdDraw := TZReadOnlyQuery.Create(Self);
  pvUpdDraw.Connection := pvCnx.get;
  pvUpdDraw.SQL.Add('UPDATE ' + pvTempTable
                   +' SET serjou = :serjou'
                   +'    ,licence = :licence'
                   +'    ,nomjou = :nomjou'
                   +'    ,codclb = :codclb'
                   +'    ,libclb = :libclb'
                   +'    ,codcls = :codcls'
                   +'    ,vrbrgl = :vrbrgl'
                   +'    ,sertab = :serprp'   // use this column for write update
                   +' WHERE numtds = :numtds');
  pvUpdDraw.Prepare;

  pvUpdPrp := TZReadOnlyQuery.Create(Self);
  pvUpdPrp.Connection := pvCnx.get;
  pvUpdPrp.SQL.Add('UPDATE prptab SET'
                  +' serblo = -1'
                  +' WHERE serprp = :serprp');
  pvUpdPrp.Prepare;

  pvSelPrp := TZReadOnlyQuery.Create(Self);
  pvSelPrp.Connection := pvCnx.get;
  pvSelPrp.SQL.Add('SELECT * FROM prptab'
                  +' WHERE sertab = ' + sertab.ToString
                  +'   AND numtds = :numtds');
  pvSelPrp.Prepare;

  pvSelClb := TZReadOnlyQuery.Create(Self);
  pvSelClb.Connection := lcCnx.get;
  pvSelClb.SQL.Add('SELECT COUNT(*) FROM ' + pvTempTable
                  +' WHERE numrow BETWEEN :low AND :high'
                  +'   AND UPPER(libclb) = :libclb');
  pvSelClb.Prepare;
  pvIsDirty := False;
  applyButton.Enabled := False;
end;

function TmanualDrawW.createTempTable: string;
begin
  Result := Copy(Format('temp_%d', [GetTickCount]),1,16);
  cloneAsTempTable(pvCnx,'tablo',Result);
end;

procedure TmanualDrawW.drawGridDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if (Source = prpGrid) and (Assigned(prpGrid.SelectedField)) then
  begin
    if pvDraw.FieldByName('nomjou').AsString = '' then
    begin
      pvUpdDraw.ParamByName('serjou').Value := pvPrp.FieldByName('serjou').Value;
      pvUpdDraw.ParamByName('licence').Value:= pvPrp.FieldByName('licence').Value;
      pvUpdDraw.ParamByName('nomjou').Value := pvPrp.FieldByName('nomjou').Value;
      pvUpdDraw.ParamByName('codclb').Value := pvPrp.FieldByName('codclb').Value;
      pvUpdDraw.ParamByName('libclb').Value := pvPrp.FieldByName('libclb').Value;
      pvUpdDraw.ParamByName('codcls').Value := pvPrp.FieldByName('codcls').Value;
      pvUpdDraw.ParamByName('vrbrgl').Value := pvPrp.FieldByName('vrbrgl').Value;
      pvUpdDraw.ParamByName('numrow').Value := pvDraw.FieldByName('numrow').Value;
      pvUpdDraw.ParamByName('serprp').Value := pvPrp.FieldByName('serprp').Value;   // for write update
      pvUpdPrp.ParamByName('serprp').Value := pvPrp.FieldByName('serprp').AsInteger;
      pvCnx.startTransaction;
      try
        pvUpdDRaw.ExecSQL;
        pvUpdPrp.ExecSQL;
        pvCnx.commit;
        pvIsDirty := True;
        applyButton.Enabled := True;
        pvPrp.Refresh;
        pvDraw.Refresh;
      except
        pvCnx.rollback;
        raise;
      end;
    end;
  end;
end;

type
  TMyDBG = class(TDBGrid);
procedure TmanualDrawW.drawGridDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  dg: TDBGrid;
  gc: TGridCoord;
  cr: integer;
begin
  dg := Sender as TDBGrid;
  gc := dg.MouseCoord(X,Y);
  with dg.DataSource.DataSet do
  begin
    DisableControls;
    cr := TMyDBG(Sender).Row;
    MoveBy(gc.Y-cr);
    Accept := FieldByName('nomjou').AsString = '';
    StatusBar1.Panels[0].Text := FieldByName('numrow').AsString;
    EnableControls;
  end;
end;

procedure TmanualDrawW.drawGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; AState: TGridDrawState);
var
  pi: TPingItem;
  low,high,cur,nc: integer;
  up,dw: smallint;
const
  cl: array[TPingItem] of TColor = ($00CCDDFF,$00CCBBCC,$00CCEECC,$00FFFFEE,$00FFAACC
                                   ,$00FFFFCC,$00FFBBDD,$00FFEEEE,$00FFAACC,$00FFFFCC
                                   ,$00FFBBDD,$00FFEEEE,$00CCDDFF,$00CCBBCC,$00CCEECC
                                   ,$00FFFFEE,$00FFAACC,$00FFFFCC,$00FFBBDD,$00FFEEEE
                                   ,$00CCDDFF,$00CCBBCC,$00CCEECC,$00FFFFEE,$00FFAACC
                                   ,$00FFFFCC,$00FFFFCC);
begin
  if TDBGrid(Sender).DataSource.DataSet.Eof = True then
    Exit;
  with TDBGrid(Sender),TDBGrid(Sender).Canvas,TDBGrid(Sender).DataSource.DataSet do
  begin
    {: colore les intervals en fonction du nombre de joueurs du club }
    if highlightCheckbox.Checked and (lcNumcell >= 2) then
    begin
      { limites de l'interval }
      cur := FieldByName('numrow').AsInteger div lcNumcell;
      if (FieldByName('numrow').AsInteger mod lcNumcell = 0) and (cur > 0) then
        Dec(cur);
      low := Succ(cur * lcNumcell);
      high := Succ(cur) * lcNumCell;
      pi := TPingItem(cur);
      StatusBar1.Panels[1].Text := Format('numrow=%d, cur=%d, low=%d, high=%d',[FieldByName('numrow').AsInteger,cur,low,high]);
      pvSelClb.ParamByName('low').AsInteger := low;
      pvSelClb.ParamByName('high').AsInteger := High;
      pvSelClb.ParamByName('libclb').AsString := lcLibClb;
      pvSelClb.Open;
      { si aucun joueur du club dans l'intervalle }
      if pvSelClb.Fields[0].AsInteger = 0 then
        Brush.Color := cl[pi]
      else
        Brush.Color := getItemsColor(piPlayArea);
      pvSelClb.Close;

      {: partage des joueurs d'un club dans les 2 demi-tableaux }
      pvSelClb.ParamByName('low').AsInteger := 1;
      pvSelClb.ParamByName('high').AsInteger := pvSize div 2;
      pvSelClb.Open;
      up := pvSelClb.Fields[0].AsInteger;
      pvSelClb.Close;
      pvSelClb.ParamByName('low').AsInteger := Succ(pvSize div 2);
      pvSelClb.ParamByName('high').AsInteger := pvSize;
      pvSelClb.Open;
      dw := pvSelClb.Fields[0].AsInteger;
      pvSelClb.Close;
//      pi := piUnknown;
      if (up > dw) and (FieldByName('numrow').AsInteger <= (pvSize div 2)) then
//        pi := Succ(piPlayArea)
        Brush.Color := clGray
      else if (dw > up) and (FieldByName('numrow').AsInteger > (pvSize div 2)) then
//        pi := Pred(piPlayArea);
        Brush.Color := clGray;
//      if pi > piUnknown  then
//        Brush.Color := cl[pi];
    end
    else
    begin
      { limites de l'interval }
      nc := 4;
      cur := FieldByName('numrow').AsInteger div nc;
      if (FieldByName('numrow').AsInteger mod nc = 0) and (cur > 0) then
        Dec(cur);
      low := Succ(cur * nc);
      high := Succ(cur) * nc;
      pi := TPingItem(cur);
      Brush.Color := cl[pi];
      StatusBar1.Panels[1].Text := Format('numrow=%d, cur=%d, low=%d, high=%d',[FieldByName('numrow').AsInteger,cur,low,high]);
    end;

    DefaultDrawColumnCell(Rect,DataCol,Column,AState);
  end;
end;

procedure TmanualDrawW.prpGridDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := False;
end;

procedure TmanualDrawW.prpGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
  if TDBGrid(Sender).DataSource.DataSet.Eof then
    Exit;
  with TDBGrid(Sender),TDBGrid(Sender).Canvas,TDBGrid(Sender).DataSource.DataSet do
  begin
    if FieldByName('serblo').AsInteger = -1 then
      Brush.Color := getItemsColor(piStabylo);
    if (Column.FieldName.ToUpper = 'LIBCLB') and (lcLibClb <> '') and (lcLibClb = Column.Field.AsString.ToUpper) then
    begin
      Brush.Color := getItemsColor(piClub);
      if FieldByName('serblo').AsInteger = -1 then
        Brush.Color := getItemsColor(piPlayArea);
    end;

    DefaultDrawColumnCell(Rect,DataCol,Column,AState);
  end;
end;

procedure TmanualDrawW.prpGridMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (ssLeft in Shift) and (pvPrp.Active) and not(pvPrp.IsEmpty)
    and (pvPrp.FieldByName('serblo').IsNull) and not(TDBGrid(Sender).Dragging) then
    TDBGrid(Sender).BeginDrag(False,5);
end;

procedure TmanualDrawW.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  write;
end;

procedure TmanualDrawW.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if pvIsDirty then
  begin
    with getROQuery(pvCnx) do
    begin
      try
        SQL.Add('SELECT COUNT(*) FROM prptab'
               +' WHERE sertab = ' + pvSertab.ToString
               +'   AND serblo = -1');
        Open;
        if Fields[0].AsInteger > 0 then
          CanClose := MessageDlg('Tous les participants de la grille de droite n''ont pas été placés'
                               + ' dans la grille de gauche ! Fermer quand même ? (Le travail'
                               + ' sera perdu)',mtConfirmation,[mbYes,mbNo],0) = mrYes;

      finally
        Free;
      end;
    end;
  end;
  pvIsDirty := CanClose = False;
end;

procedure TmanualDrawW.FormDestroy(Sender: TObject);
begin
  pvPrp.Close;
  pvDraw.Close;
end;

procedure TmanualDrawW.FormShow(Sender: TObject);
begin
  pvPrp.Open;
  pvSize := pvPrp.FieldByName('size').AsInteger;
  pvCnx.startTransaction;
  try
    pvSize := pvSize;
    fillTable(pvSize);
    tds(pvPrp.FieldByName('nbrtds').AsInteger,pvSize);
    bye(pvPrp.FieldByName('numbye').AsInteger);
    pvCnx.commit;
    pvUpdDraw.SQL.Clear;
    pvUpdDraw.SQL.Add('UPDATE ' + pvTempTable
                     +' SET serjou = :serjou'
                     +'    ,licence = :licence'
                     +'    ,nomjou = :nomjou'
                     +'    ,codclb = :codclb'
                     +'    ,libclb = :libclb'
                     +'    ,codcls = :codcls'
                     +'    ,vrbrgl = :vrbrgl'
                     +'    ,sertab = :serprp'   // use this column for write update
                     +' WHERE numrow = :numrow');
    pvUpdDraw.Prepare;

    pvPrp.Refresh;
  except
    pvCnx.rollback;
    raise;
  end;
  pvDraw.Open;
  with drawGrid.Columns do
  begin
    BeginUpdate;
    try
      with Add do begin FieldName := 'sertab'; Width := 60; end;
      with Add do begin FieldName := 'numrow'; Width := 60; end;
      with Add do begin FieldName := 'numtds'; Width := 60; end;
      with Add do begin FieldName := 'nomjou'; Width := 120; end;
      with Add do begin FieldName := 'libclb'; Width := 120; end;
      with Add do begin FieldName := 'codcls'; Width := 60; end;
    finally
      EndUpdate;
    end;
  end;
  with prpGrid.Columns do
  begin
    BeginUpdate;
    try
      with Add do begin FieldName := 'nomjou'; Width := 120; end;
      with Add do begin FieldName := 'libclb'; Width := 120; end;
      with Add do begin FieldName := 'serprp'; Width := 60; end;
      with Add do begin FieldName := 'codcls'; Width := 60; end;
      with Add do begin FieldName := 'vrbrgl'; Width := 60; end;
      with Add do begin FieldName := 'numtds'; Width := 60; end;
      with Add do begin FieldName := 'serblo'; Width := 60; end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TmanualDrawW.highlightCheckboxClick(Sender: TObject);
begin
  drawGrid.Repaint;
end;

procedure TmanualDrawW.prpGridCellClick(Column: TColumn);
begin
  if not(Column.Field.IsNull) and (Column.FieldName.ToLower = 'libclb') then
  begin
    lcLibClb := Column.Field.AsString.ToUpper;
    StatusBar1.Panels[3].Text := lcLibClb;
    drawGrid.Refresh;
    prpGrid.Refresh;
  end;
end;

procedure TmanualDrawW.prpSourceDataChange(Sender: TObject; Field: TField);
var
  numclb: string;
  c: string;
  i: integer;
begin
  if Field = nil then
  begin
    if lcLibClb <> TDataSource(Sender).DataSet.FieldByName('libclb').AsString.ToUpper then
    begin
      { calcul de la taille de l'intervalle }
      numclb := TDataSource(Sender).DataSet.FieldByName('numclb').AsString;
      while Length(numclb) > 0 do
      begin
        c := numclb[numclb.Length];
        if not isInteger(c) then
          Delete(numclb,numclb.Length,1)
        else
          Break;
      end;

      lcNumcell := Succ(pvSize div numclb.ToInteger);
      i := 1;
      while i < lcNumCell do
        i := i * 2;
      if i > 1 then
        lcNumcell := i div 2
      else
        lcNumcell := i;
    end;

    lcLibClb := TDataSource(Sender).DataSet.FieldByName('libclb').AsString.ToUpper;
    drawGrid.Refresh;
    prpGrid.Refresh;
    StatusBar1.Panels[3].Text := lcLibClb;
    StatusBar1.Panels[2].Text := 'Interval = ' + lcNumcell.ToString;
  end;
end;

type
  TCell = class(TObject)
    private
      _numtds,
      _numrow: integer;
      _busy: boolean;
    public
      constructor Create; reintroduce; overload;
      constructor Create(index,position: integer); reintroduce; overload;
      function asString: string;
      property numtds: integer read _numtds write _numtds default 0;
      property busy: boolean read _busy write _busy default False;
      property numrow: integer read _numrow write _numrow default 0;
  end;

  TInterval = record
    deb,
    fin: integer;
  end;

  TTablo = class(TObjectList)
    taille: integer;
    procedure build(taille: integer);
    function getByRow(const numrow: integer): TCell;
    function getByTDS(const tds: integer): TCell;
  end;

procedure TmanualDrawW.fillTable(const numrec: integer);
var
  i: integer;
  tablo: TTablo;
begin
  tablo := TTablo.Create(True);
  try
    { création du canvas vide }
    for i := 1 to numrec do tablo.Add(TCell.Create(i,0));
    { prépare la liste de cellules }
    tablo.build(numrec);
    with getROQuery(pvCnx) do
    begin
      try
        SQL.Add('INSERT INTO ' + pvTempTable
               +' (serblo,sertab,numrow,numtds,sertrn)'
               +' VALUES (0,0,:numrow,:numtds,0)');
        Prepare;
        for i := 1 to numrec do
        begin
          Params[0].AsInteger := i;
          Params[1].AsInteger := tablo.getByRow(i).numtds;
          ExecSQL;
        end;
      finally
        Free;
      end;
    end;
  finally
    tablo.Free;
  end;
end;

procedure TmanualDrawW.fontSizeUDChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  drawGrid.Font.Size := fontSizeUD.Position;
  prpGrid.Font.Size := fontSizeUD.Position;
  drawGrid.Refresh;
  prpGrid.Refresh;
end;

procedure TmanualDrawW.tds(const tds,size: integer);
var
  i: Integer;
begin
  for i := 1 to tds do
  begin
    pvSelPrp.ParamByName('numtds').AsInteger := i;
    pvSelPrp.Open;
    try
      pvUpdDraw.ParamByName('serjou').AsString := pvSelPrp.FieldByName('serjou').AsString;
      pvUpdDraw.ParamByName('licence').AsString:= pvSelPrp.FieldByName('licence').AsString;
      pvUpdDraw.ParamByName('nomjou').AsString := pvSelPrp.FieldByName('nomjou').AsString;
      pvUpdDraw.ParamByName('codclb').AsString := pvSelPrp.FieldByName('codclb').AsString;
      pvUpdDraw.ParamByName('libclb').AsString := pvSelPrp.FieldByName('libclb').AsString;
      pvUpdDraw.ParamByName('codcls').AsString := pvSelPrp.FieldByName('codcls').AsString;
      pvUpdDraw.ParamByName('vrbrgl').AsString := pvSelPrp.FieldByName('vrbrgl').AsString;
      pvUpdDraw.ParamByName('numtds').AsString := pvSelPrp.FieldByName('numtds').AsString;
      pvUpdDraw.ParamByName('serprp').AsInteger:= pvSelPrp.FieldByName('serprp').AsInteger;
      pvUpdDraw.ExecSQL;
      pvUpdPrp.ParamByName('serprp').AsInteger := pvSelPrp.FieldByName('serprp').AsInteger;
      pvUpdPrp.ExecSQL;
    finally
      pvSelPrp.Close;
    end;
  end;
end;

procedure TmanualDrawW.write;
var
  z: TZReadOnlyQuery;
begin
  if pvIsDirty then
  begin
    with getROQuery(pvCnx) do
    begin
      try
        SQL.Add('INSERT INTO tablo (serblo,sertab,serjou,licence,nomjou,codclb'
               +'  ,libclb,codcls,vrbrgl,numtds,numrow,sertrn)'
               +' VALUES (:serblo,:sertab,:serjou,:licence,:nomjou,:codclb'
               +'  ,:libclb,:codcls,:vrbrgl,:numtds,:numrow,:sertrn)');
        Prepare;
        ParamByName('sertab').AsInteger := pvSertab;
        ParamByName('sertrn').AsInteger := pvPrp.FieldByName('sertrn').AsInteger;
        pvCnx.startTransaction;
        try
          drawGrid.OnDrawColumnCell := nil;
          try
            with TLalSequence.Create(Self, pvCnx) do
            begin
              SequenceName := 'CATEGORIE';
              pvDraw.First;
              z := TZReadOnlyQuery.Create(Self);
              z.Connection := pvCnx.get;
              z.SQL.Add('UPDATE prptab SET serblo = :serblo'
                       +' WHERE serprp = :serprp');
              z.Prepare;
              while not pvDraw.Eof do
              begin
                ParamByName('serblo').AsInteger := get;
                ParamByName('serjou').Value := pvDraw.FieldByName('serjou').Value;
                ParamByName('licence').Value := pvDraw.FieldByName('licence').Value;
                ParamByName('nomjou').Value := pvDraw.FieldByName('nomjou').Value;
                ParamByName('codclb').Value := pvDraw.FieldByName('codclb').Value;
                ParamByName('libclb').Value := pvDraw.FieldByName('libclb').Value;
                ParamByName('codcls').Value := pvDraw.FieldByName('codcls').Value;
                ParamByName('vrbrgl').Value := pvDraw.FieldByName('vrbrgl').Value;
                ParamByName('numtds').Value := pvDraw.FieldByName('numtds').Value;
                ParamByName('numrow').Value := pvDraw.FieldByName('numrow').Value;
                z.ParamByName('serblo').AsInteger := ParamByName('serblo').AsInteger;
                z.ParamByName('serprp').AsInteger := pvDraw.FieldByName('sertab').AsInteger;  // we used this field for serprp
                ExecSQL;
                z.ExecSQL;
                pvDraw.Next;
                Application.ProcessMessages;
              end;
            end;
            updateCategoryStatut(pvSertab, csDraw);
            pvCnx.commit;
            pvIsDirty := False;
            broadcastMessage(wm_categChanged,pvSertab,0);
          finally
            drawGrid.OnDrawColumnCell := drawGridDrawColumnCell;
          end;
        except
          pvCnx.rollback;
          raise;
        end;
      finally
        Free;
      end;
    end;
  end
  else
  begin
    with getROQuery(pvCnx) do
    begin
      try
        SQL.Add('UPDATE prptab SET serblo = NULL'
               +' where sertab = ' + pvSertab.ToString);
        ExecSQL;
      finally
        Free;
      end;
    end;
  end;
end;

procedure TmanualDrawW.applyButtonClick(Sender: TObject);
begin
  Write;
  OnClose := nil;
  ModalResult := mrOk;
end;

procedure TmanualDrawW.bye(const numbye: integer);
var
  i: integer;
begin
  for i := pvSize downto Succ(pvSize-numbye) do
  begin
    pvSelPrp.ParamByName('numtds').AsInteger := i;
    pvSelPrp.Open;
    try
      pvUpdDraw.ParamByName('serjou').Clear;
      pvUpdDraw.ParamByName('licence').Clear;
      pvUpdDraw.ParamByName('nomjou').AsString := 'BYE';
      pvUpdDraw.ParamByName('codclb').Clear;
      pvUpdDraw.ParamByName('libclb').Clear;
      pvUpdDraw.ParamByName('codcls').Clear;
      pvUpdDraw.ParamByName('vrbrgl').Clear;
      pvUpdDraw.ParamByName('numtds').AsInteger := i;
      pvUpdDraw.ParamByName('serprp').AsInteger := pvSelPrp.FieldByName('serprp').AsInteger;
      pvUpdDraw.ExecSQL;
      pvUpdPrp.ParamByName('serprp').AsInteger := pvSelPrp.FieldByName('serprp').AsInteger;
      pvUpdPrp.ExecSQL;
    finally
      pvSelPrp.Close;
    end;
  end;
end;

{ TCell }

constructor TCell.Create;
begin
  _numtds := 0;
  _numrow := 0;
  _busy := False;
end;

function TCell.asString: string;
const
  bool: array[boolean] of string = ('false','true');
begin
  Result := Format('numrow=%d, numtds=%d, isBusy=%s',[_numrow,_numtds,bool[_busy]]);
end;

constructor TCell.Create(index, position: integer);
begin
  Create;
  Self._numtds := index;
  Self._numrow := position;
end;

function getCell(tablo: TTablo; const position: integer): TCell;
begin
  Result := TCell(tablo[Pred(position)]);
end;

procedure getInterval(itv: TStrings; bornes: TPoint; hautBas,seqcls,taille: smallint; const sertab: integer);
var
  z: TZReadOnlyQuery;
begin
  itv.Clear;
  z := getROQuery(lcCnx);
  try
    z.SQL.Add('select serblo,numtds,numrow from tablo'
             +' where numrow between :bas and :haut'
             +'   and numtds between :low and :high'
             +'   and sertab = :sertab'
             +' order by numrow');
    z.ParamByName('sertab').AsInteger := sertab;
    if hautBas = 0 then
    begin
      z.ParamByName('bas').AsInteger := 1;
      z.ParamByName('haut').AsInteger := taille div 2;
    end
    else
    begin
      z.ParamByName('bas').AsInteger := Succ(taille div 2);
      z.ParamByName('haut').AsInteger := taille;
    end;
    z.Open;
    while not z.Eof do
    begin
      itv.Add(z.FieldByName('numrow').AsString);
      z.Next;
      Application.ProcessMessages;
    end;
    z.Close;
  finally
    z.Free;
  end;
end;

{ TTablo }

procedure TTablo.build(taille: integer);
var
  passe,
  taillesoustablo,
  nbjoueursaplacer,
  joueur,joueurs,
  index,
  position,
  controlsum: integer;
  c,d: TCell;
  hbCount: smallint;
begin
  position := 0;

  { on force le premier élément à 1-1 }
  TCell(Items[0]).numrow := 1;
  hbCount := 0;
  { tant que le nombre de joueurs à placer est inférieur à la taille du tableau }
  passe := 0;
  taillesoustablo := taille div Trunc(power(2,passe));
  while taillesoustablo >= 2 do
  begin
    Inc(passe);
    { traiter la passe }
    nbjoueursaplacer := trunc(power(2,passe));
    joueurs := nbjoueursaplacer - position;
    controlsum := Succ(nbjoueursaplacer);
    for joueur := 1 to joueurs do
    begin
      { position du joueur à placer }
      Inc(position);
      { on récupère l'objet associé }
      c := getByRow(position);
      { normalement, il ne devrait pas être placé, sauf le n°1 qui est fixé à l'index 1 }
      if (c = nil) then
      begin
        d := getByRow((nbjoueursaplacer+1)-position);
        Assert(d <> nil, Format('La position %d n''est pas définie',[Pred(position)]));

        if hbCount = 0 then
          index := d.numtds + taillesoustablo - 1
        else
          index := d.numtds - taillesoustablo + 1;

        c := TCell(Items[Pred(index)]);
        c.numrow := position;

        Assert(c.numrow+d.numrow=controlsum,Format('La somme de controle %d n''est pas correcte (%d+%d)',[controlsum,c.numrow,d.numrow]));

        Inc(hbCount);
        if hbCount = 2 then
          hbCount := 0;
      end;
    end;
    { calculer la condition de sortie de la boucle }
    taillesoustablo := taille div Trunc(power(2,passe));
    Self.taille := Count;
  end;
end;

function TTablo.getByRow(const numrow: integer): TCell;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Pred(Count) do
    if TCell(Items[i]).numrow = numrow then
    begin
      Result := TCell(Items[i]);
      Break;
    end;
end;

function TTablo.getByTDS(const tds: integer): TCell;
begin
  Result := TCell(Items[Pred(tds)]);
end;

end.
