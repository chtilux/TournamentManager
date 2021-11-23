unit tabloWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, ZDataset, Vcl.DBCtrls, System.Actions,
  Vcl.ActnList, Vcl.Menus, lal_connection;

type
  TtabloW = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    tabloGrid: TDBGrid;
    tabloSource: TDataSource;
    tableauLabel: TStaticText;
    DBNavigator1: TDBNavigator;
    ActionList1: TActionList;
    swapAction: TAction;
    Panel2: TPanel;
    sourcePanel: TPanel;
    swapPanel: TPanel;
    swap1: TEdit;
    swap2: TEdit;
    excelButton: TButton;
    Button1: TButton;
    joueursSource: TDataSource;
    placeAction: TAction;
    Panel4: TPanel;
    StaticText1: TStaticText;
    joueursNav: TDBNavigator;
    joueursGrid: TDBGrid;
    Splitter1: TSplitter;
    Panel5: TPanel;
    StaticText2: TStaticText;
    DBNavigator2: TDBNavigator;
    clubsGrid: TDBGrid;
    clubsSource: TDataSource;
    fontSizeBox: TComboBox;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    Intervertir1: TMenuItem;
    Placer1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure tabloGridCellClick(Column: TColumn);
    procedure tabloGridDrawColumnCell(Sender: TObject; const {$ifdef VER330 or higher}[Ref]{$endif} Rect: TRect;
      DataCol: Integer; Column: TColumn; AState: TGridDrawState);
    procedure excelButtonClick(Sender: TObject);
    procedure swapActionExecute(Sender: TObject);
    procedure placeActionExecute(Sender: TObject);
    procedure tabloGridTitleClick(Column: TColumn);
    procedure tabloGridKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure fontSizeBoxChange(Sender: TObject);
  private
    { Déclarations privées }
    _stabylo,
    _stabval: string;
    _taille,
    _participants,
    _sertab,
    _nbrtds,
    _sertrn: integer;
    _clubs: TZReadOnlyQuery;
    pvCnx: TLalConnection;

    procedure dbGridColumns(grid: TDBGrid);
    procedure swap(swap1, swap2: string);
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent; cnx: TLalConnection; sertab: integer; tableau: string; taille, participants, tetesdeserie: integer); reintroduce; overload;
  end;

implementation

{$R *.dfm}

uses
  lal_dbUtils, Math, u_pro_excel, Contnrs, System.UITypes, tmUtils15;

{ TtabloW }

constructor TtabloW.Create(AOwner: TComponent; cnx: TLalConnection; sertab: integer; tableau: string; taille,
  participants, tetesdeserie: integer);
begin
  _sertab := sertab;
  _taille := taille;
  _participants := participants;
  _nbrtds := tetesdeserie;
  pvCnx := cnx;
  inherited Create(AOwner);
  tableauLabel.Caption := Format('%s [%d]) : %d/%d (%d)',[tableau,sertab,participants,taille,tetesdeserie]);
  _clubs := getROQuery(pvCnx, Self);
  _clubs.SQL.Add('select sertrn from categories where sercat = :sercat');
  _clubs.ParamByName('sercat').AsInteger := _sertab;
  _clubs.Open;
  _sertrn := _clubs.Fields[0].AsInteger;
  _clubs.Close;
  _clubs.SQL.Clear;
  _clubs.SQL.Add('select count( * ) joueurs,libclb'
                +' from tablo'
                +' where sertab = :sertab'
                +'   and coalesce(serjou,0) > 0'
                +' group by 2'
                +' order by 1 desc');
  _clubs.ParamByName('sertab').AsInteger := sertab;
  _clubs.Open;
  clubsSource.DataSet := _clubs;

//  fontSizeBox.ItemIndex := fontSizeBox.Items.IndexOf(getSettingsValue('fontSizeBox','10'));
  fontSizeBox.ItemIndex := fontSizeBox.Items.IndexOf(glSettings.Read('settings.tablo','fontSizeBox','pardc1','10'));
  if fontSizeBox.ItemIndex <> -1 then
    Font.Size := StrToInt(fontSizeBox.Items[fontSizeBox.ItemIndex])
  else
    Font.Size := 10;
end;

procedure TtabloW.FormDestroy(Sender: TObject);
begin
  //setSettingsValue('FontSizeBox',IntToStr(Font.Size));
  glSettings.Write('settings.tablo','fontSizeBox','pardc1',FontSizeBox.Text);
end;

procedure TtabloW.FormShow(Sender: TObject);
begin
  dbGridColumns(tabloGrid);
  dbGridColumns(joueursGrid);
end;

procedure TtabloW.dbGridColumns(grid: TDBGrid);
begin
  if grid = tabloGrid then
  begin
    with grid.Columns.Add do
    begin
      FieldName := 'numtds';
      Alignment := taCenter;
      ReadOnly := True;
      Title.Caption := 'tds';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'nomjou';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'joueur';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'libclb';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'club';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'codcls';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'class.';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'vrbrgl';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'ranglëscht';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'numrow';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'row';
      Title.Alignment := taCenter;
    end;
  end
  else
  if grid = joueursGrid then
  begin
    with grid.Columns.Add do
    begin
      FieldName := 'nomjou';
      ReadOnly := True;
      Title.Caption := 'nom';
      Title.Alignment := taCenter;
      Width := 100;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'libclb';
      ReadOnly := True;
      Title.Caption := 'club';
      Title.Alignment := taCenter;
      Width := 100;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'codcls';
      ReadOnly := True;
      Title.Caption := 'cls.';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'vrbrgl';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'ranglëscht';
      Title.Alignment := taCenter;
    end;
  end;
end;

type
  TSwap = record
	 serblo: integer;
	 sertab: integer;
	 serjou: integer;
	 licence
	,nomjou
	,codclb
	,libclb
	,codcls: string;
	 vrbrgl
	,numtds
	,numrow: integer;
  end;
procedure TtabloW.swap(swap1, swap2: string);
var
  x: TZReadOnlyQuery;
  s1,s2: TSwap;
  swp1,swp2: integer;
begin
  swp1 := 0;
  swp2 := 0;
  TryStrToInt(swap1,swp1);
  if swp1 = 0 then Exit;
  TryStrToInt(swap2,swp2);
  if swp2 = 0 then Exit;

  x := getROQuery(pvCnx);
  try
    x.SQL.Add('select * from tablo where numtds = :numtds and sertab = :sertab');
    x.Prepare;
    x.ParamByName('numtds').AsString := swap1;
    x.ParamByName('sertab').AsInteger := _sertab;
    x.Open;
    if x.FieldByName('serjou').AsInteger = 0 then
      Exit;
    s1.serblo := x.FieldByName('serblo').AsInteger;
    s1.sertab := x.FieldByName('sertab').AsInteger;
    s1.serjou := x.FieldByName('serjou').AsInteger;
    s1.licence := x.FieldByName('licence').AsString;
    s1.nomjou := x.FieldByName('nomjou').AsString;
    s1.codclb := x.FieldByName('codclb').AsString;
    s1.libclb := x.FieldByName('libclb').AsString;
    s1.codcls := x.FieldByName('codcls').AsString;
    s1.numtds := x.FieldByName('numtds').AsInteger;
    s1.numrow := x.FieldByName('numrow').AsInteger;
    x.Close;
    x.ParamByName('numtds').AsString := swap2;
    x.Open;
    if x.FieldByName('serjou').AsInteger = 0 then
      Exit;
    s2.serblo := x.FieldByName('serblo').AsInteger;
    s2.sertab := x.FieldByName('sertab').AsInteger;
    s2.serjou := x.FieldByName('serjou').AsInteger;
    s2.licence := x.FieldByName('licence').AsString;
    s2.nomjou := x.FieldByName('nomjou').AsString;
    s2.codclb := x.FieldByName('codclb').AsString;
    s2.libclb := x.FieldByName('libclb').AsString;
    s2.codcls := x.FieldByName('codcls').AsString;
    s2.numtds := x.FieldByName('numtds').AsInteger;
    s2.numrow := x.FieldByName('numrow').AsInteger;
    x.Close;
    x.SQL.Clear;
    x.SQL.Add('update tablo'
             +' set serjou = :serjou'
             +'    ,licence = :licence'
             +'    ,nomjou = :nomjou'
             +'    ,codclb = :codclb'
             +'    ,libclb = :libclb'
             +'    ,codcls = :codcls'
             +' where numtds = :numtds'
             +'   and numrow = :numrow'
             +'   and sertab = :sertab');
    x.Prepare;
    x.ParamByName('serjou').AsInteger := s2.serjou;
    x.ParamByName('licence').AsString := s2.licence;
    x.ParamByName('nomjou').AsString := s2.nomjou;
    x.ParamByName('codclb').AsString := s2.codclb;
    x.ParamByName('libclb').AsString := s2.libclb;
    x.ParamByName('codcls').AsString := s2.codcls;
    x.ParamByName('numtds').AsInteger := s1.numtds;
    x.ParamByName('numrow').AsInteger := s1.numrow;
    x.ParamByName('sertab').AsInteger := s2.sertab;
    x.ExecSQL;
    x.ParamByName('serjou').AsInteger := s1.serjou;
    x.ParamByName('licence').AsString := s1.licence;
    x.ParamByName('nomjou').AsString := s1.nomjou;
    x.ParamByName('codclb').AsString := s1.codclb;
    x.ParamByName('libclb').AsString := s1.libclb;
    x.ParamByName('codcls').AsString := s1.codcls;
    x.ParamByName('numtds').AsInteger := s2.numtds;
    x.ParamByName('numrow').AsInteger := s2.numrow;
    x.ExecSQL;
  finally
    x.Free;
  end;
  tabloSource.DataSet.Refresh;
end;

procedure TtabloW.tabloGridCellClick(Column: TColumn);
begin
  _stabylo := '';
  if (Column.FieldName = 'CODCLS') or (Column.FieldName = 'LIBCLB') then
  begin
    _stabylo := Column.FieldName;
    _stabval := Column.Grid.DataSource.DataSet.FieldByName(Column.FieldName).AsString;
    tabloGrid.Repaint;
  end;
end;

procedure TtabloW.tabloGridDrawColumnCell(Sender: TObject;
  const [Ref] Rect: TRect; DataCol: Integer; Column: TColumn;
  AState: TGridDrawState);
const
//  cl: array[boolean] of TColor = (clWhite, clSilver);
  cl: array[boolean] of TPingItem = (piPair,piOdd);
begin
  inherited;
  if TDBGrid(Sender).DataSource.DataSet.IsEmpty then
    Exit;
//  data := TDBGrid(Sender).DataSource.DataSet;
  with TDBGrid(Sender),TDBGrid(Sender).Canvas,TDBGrid(Sender).DataSource.DataSet do
  begin
    Brush.Color := clWhite;
    { Changer de couleur toutes les 2 cellules }
    if FindField('numrow') <> nil then
      Brush.Color := getItemsColor(cl[Odd(Trunc((FieldByName('numrow').AsInteger / 2)+0.5))]);
    { position libre non occupée }
    if (FieldByName('numtds').AsInteger <= _participants) and (FieldByName('serjou').AsInteger = 0) then
      Brush.Color := getItemsColor(piTDS);
    { highlight tête de série }
    if FieldByName('numtds').AsInteger <= _nbrtds then
    begin
      //Brush.Color := clYellow;
      Font.Style := [fsBold];
    end;
    { highlight classement ou club }
    if _stabylo <> '' then
    begin
      if (FieldByName(_stabylo).AsString = _stabval) then
        Brush.Color := getItemsColor(piStabylo);
    end;

    { position illégale }
    if (FieldByName('numtds').AsInteger > _participants) and (FieldByName('serjou').AsInteger > 0) then
      Brush.Color := getItemsColor(piError);

    if gdSelected in AState then begin
      Canvas.Brush.Color := getItemsColor(piHighlight);
      Canvas.Font.Color := getItemsColor(piHighLightText);
    end;
    DefaultDrawColumnCell(Rect,DataCol,Column,AState);
  end;
end;

procedure TtabloW.tabloGridKeyPress(Sender: TObject; var Key: Char);
const
  cs: TSysCharset = ['s','S'];
begin
  if CharInSet(Key,cs) then
  begin
    Key := #0;
    if swapAction.Enabled then
      swapActionExecute(Sender);
  end;
end;

procedure TtabloW.tabloGridTitleClick(Column: TColumn);
begin
  orderByColumn(TZQuery(tabloGrid.DataSource.DataSet),Column,'ASC');
end;

procedure TtabloW.excelButtonClick(Sender: TObject);
begin
  Draw2Excel(_sertab, False, False);
  MessageDlg('export Excel terminé',mtInformation,[mbOk],0);
  Close;
end;

procedure TtabloW.fontSizeBoxChange(Sender: TObject);
begin
  font.Size := StrToIntDef(fontSizeBox.Text,10);
end;

procedure TtabloW.swapActionExecute(Sender: TObject);
var
  swp: TStrings;
  i: Integer;
  swp1,swp2: string;
begin
  swp1 := '';
  swp2 := '';
  if tabloGrid.SelectedRows.Count = 2 then
  begin
    swp := TStringList.Create;
    try
      for i := 0 to tabloGrid.SelectedRows.Count-1 do
      begin
//        tabloGrid.DataSource.DataSet.GotoBookmark(Pointer(tabloGrid.SelectedRows[i]));
        tabloGrid.DataSource.DataSet.GotoBookmark(tabloGrid.SelectedRows[i]);
        swp.Add(tabloGrid.DataSource.DataSet.FieldByName('numtds').AsString);
      end;
      swp1 := swp[0];
      swp2 := swp[1];
    finally
      swp.Free;
    end;
  end
  else if (Trim(swap1.Text) <> '') and (Trim(swap2.Text) <> '') then
  begin
    swp1 := Trim(swap1.Text);
    swp2 := Trim(swap2.Text);
  end;
  swap(swp1,swp2);
end;

procedure TtabloW.placeActionExecute(Sender: TObject);
begin
  with getROQuery(pvCnx) do
  begin
    try
      SQL.Add('update tablo set'
             +'    serjou = :serjou'
             +'   ,licence = :licence'
             +'   ,nomjou = :nomjou'
             +'   ,codclb = :codclb'
             +'   ,libclb = :libclb'
             +'   ,codcls = :codcls'
             +' where serblo = :serblo');
      ParamByName('serjou').AsInteger := joueursSource.DataSet.FieldByName('serjou').AsInteger;
      ParamByName('licence').AsString := joueursSource.DataSet.FieldByName('licence').AsString;
      ParamByName('nomjou').AsString := joueursSource.DataSet.FieldByName('nomjou').AsString;
      ParamByName('codclb').AsString := joueursSource.DataSet.FieldByName('codclb').AsString;
      ParamByName('libclb').AsString := joueursSource.DataSet.FieldByName('libclb').AsString;
      ParamByName('codcls').AsString := joueursSource.DataSet.FieldByName('codcls').AsString;
      ParamByName('serblo').AsInteger := tabloSource.DataSet.FieldByName('serblo').AsInteger;
      ExecSQL;
      SQL.Clear;
      SQL.Add('update prptab set serblo = :serblo where serprp = :serprp');
      ParamByName('serblo').AsInteger := tabloSource.DataSet.FieldByName('serblo').AsInteger;
      ParamByName('serprp').AsInteger := joueursSource.DataSet.FieldByName('serprp').AsInteger;
      ExecSQL;
      joueursSource.DataSet.Refresh;
      tabloSource.DataSet.Refresh;
    finally
      Free;
    end;
  end;
end;

end.
