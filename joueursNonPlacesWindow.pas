unit joueursNonPlacesWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, System.Actions, Vcl.ActnList, Vcl.Menus,
  lal_connection, ZAbstractRODataset, ZDataset;

type
  TjoueursNonPlacesW = class(TForm)
    joueursSource: TDataSource;
    Panel1: TPanel;
    Panel2: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    joueursGrid: TDBGrid;
    positionsGrid: TDBGrid;
    positionsSource: TDataSource;
    Splitter1: TSplitter;
    ActionList1: TActionList;
    placeAction: TAction;
    PopupMenu1: TPopupMenu;
    Placer1: TMenuItem;
    procedure positionsGridDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure positionsGridCellClick(Column: TColumn);
    procedure placeActionExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
    _stabylo,
    _stabval: string;
    pvCnx: TLalConnection;
    pvSertab: integer;
    procedure locateJNP;
  public
    { Déclarations publiques }
    nbrjou: integer;
    constructor Create(AOwner: TComponent; cnx: TlalConnection; const sertab: integer); reintroduce; overload;
  end;

implementation

{$R *.dfm}

uses
  lal_dbUtils, tmUtils15;

constructor TjoueursNonPlacesW.Create(AOwner: TComponent; cnx: TlalConnection;
  const sertab: integer);
begin
  inherited Create(AOwner);
  pvCnx := cnx;
  pvSertab := sertab;
end;

procedure TjoueursNonPlacesW.FormShow(Sender: TObject);
begin
  locateJNP;
end;

procedure TjoueursNonPlacesW.locateJNP;
var
  z: TZReadOnlyQuery;
begin
  z := getROQuery(pvCnx);
  try
    z.SQL.Add('select min(numtds) from tablo'
             +' where sertab = :sertab'
             +'   and numtds < :nbrjou'
             +'   and coalesce(serjou,0) = 0');
    z.Params[0].AsInteger := pvSertab;
    z.Params[1].AsInteger := nbrjou;
    z.Open;
    positionsSource.DataSet.Locate('numtds',z.Fields[0].Value,[]);
    z.Close;
  finally
    z.Free;
  end;
end;

procedure TjoueursNonPlacesW.placeActionExecute(Sender: TObject);
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
      ParamByName('serblo').AsInteger := positionsSource.DataSet.FieldByName('serblo').AsInteger;
      ExecSQL;
      SQL.Clear;
      SQL.Add('update prptab set serblo = :serblo where serprp = :serprp');
      ParamByName('serblo').AsInteger := positionsSource.DataSet.FieldByName('serblo').AsInteger;
      ParamByName('serprp').AsInteger := joueursSource.DataSet.FieldByName('serprp').AsInteger;
      ExecSQL;
      joueursSource.DataSet.Refresh;
      positionsSource.DataSet.Refresh;
      if joueursSource.DataSet.IsEmpty then
        Self.Close
      else
        locateJNP;
    finally
      Free;
    end;
  end;
end;

procedure TjoueursNonPlacesW.positionsGridCellClick(Column: TColumn);
begin
  if (Column.FieldName = 'CODCLS') or (Column.FieldName = 'LIBCLB') then
  begin
    _stabylo := Column.FieldName;
    _stabval := Column.Grid.DataSource.DataSet.FieldByName(Column.FieldName).AsString;
    Caption := Format('%s = %s',[_stabylo,_stabval]);
    positionsGrid.Repaint;
  end
  else
    Caption := '';
end;

procedure TjoueursNonPlacesW.positionsGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  with positionsGrid,positionsGrid.Canvas do
  begin
    Brush.Color := getItemsColor(piOdd);
    { Changer de couleur toutes les 2 cellules }
    if DataSource.DataSet.FindField('numrow') <> nil then
      Brush.Color := getGridRowColor(clOdd[Odd(Trunc((DataSource.DataSet.FieldByName('numrow').AsInteger / 2)+0.5))]);
    if _stabylo <> '' then
    begin
      if (DataSource.DataSet.FieldByName(_stabylo).AsString = _stabval) then
        Brush.Color := getItemsColor(piStabylo)
    end;
    if (DataSource.DataSet.FieldByName('numtds').AsInteger <= nbrjou) and (DataSource.DataSet.FieldByName('nomjou').AsString = 'BYE') then
    begin
      Canvas.Font.Style := [fsBold];
      Canvas.Brush.Color := getItemsColor(piTDS);
    end (*
    else if (DataSource.DataSet.FieldByName('numtds').AsInteger > nbrjou) then
    begin
      Canvas.Brush.Color := getItemsColor(piError);
    end*);

  end;
  positionsGrid.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

end.
