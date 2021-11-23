unit SeedsWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.DBCtrls, Vcl.ExtCtrls, ZDataset, lal_connection;

type
  TSeedsW = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    nav: TDBNavigator;
    grid: TDBGrid;
    dts: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure gridKeyPress(Sender: TObject; var Key: Char);
    procedure gridTitleClick(Column: TColumn);
  private
    { Déclarations privées }
    _numtds: byte;
    _sertab: integer;
    _codcls: string;
    _temp: string;
    _z: TZQuery;
    pvCnx: TLalConnection;
    function createTempTable: string;
    procedure getData;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent; cnx: TLalConnection; const sertab: integer; const codcls: string; const numtds: byte); reintroduce; overload;
    property tempTableName: string read _temp;
  end;

implementation

{$R *.dfm}

uses
  lal_dbUtils;

{ TtdsW }

constructor TSeedsW.Create(AOwner: TComponent; cnx: TLalConnection; const sertab: integer;
  const codcls: string; const numtds: byte);
begin
  _numtds := numtds;
  _sertab := sertab;
  _codcls := codcls;
  pvCnx := cnx;
  inherited Create(AOwner);
  _temp := createTempTable;
  _z := getQuery(pvCnx, Self);
  if _temp <> '' then
    _z.SQL.Add(Format('select * from %s order by points desc,newtds,numtds,vrbrgl',[_temp]));
  dts.DataSet := _z;
end;

function TSeedsW.createTempTable: string;
begin
  Result := Format('zzz%d',[_sertab]);
  if not tableExists(pvCnx,Result) then
  begin
    cloneAsTempTable(pvCnx,'prptab',Result);
    with getROQuery(pvCnx) do
    begin
      try
        sql.Add(Format('alter table %s',[Result])
                      +' add newtds integer');
        ExecSQL;
        sql.Clear;
        sql.Add(Format('alter table %s',[Result])
                      +' add points integer');
        ExecSQL;
      finally
        Free;
      end;
    end;
  end
  else
    emptyTable(pvCnx,Result);
end;

procedure TSeedsW.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if _temp <> '' then
  begin
    if _z.State in dsEditModes then
      _z.Post;
    _z.Close;
  end;
end;

procedure TSeedsW.FormShow(Sender: TObject);
begin
  getData;
  _z.Open;
  with grid.Columns.Add do
  begin
    FieldName := 'numtds';
    Alignment := taCenter;
    ReadOnly := False;
    Title.Caption := 'numtds';
    Title.Alignment := taCenter;
  end;
  with grid.Columns.Add do
  begin
    FieldName := 'newtds';
    Alignment := taCenter;
    ReadOnly := False;
    Title.Caption := 'newtds';
    Title.Alignment := taCenter;
  end;
  with grid.Columns.Add do
  begin
    FieldName := 'points';
    Alignment := taLeftJustify;
    ReadOnly := False;
    Title.Caption := 'points';
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
    Width := 100;
    Title.Caption := 'club';
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
    FieldName := 'codcls';
    Alignment := taLeftJustify;
    ReadOnly := True;
    Title.Caption := 'class.';
    Title.Alignment := taCenter;
  end;
  with grid.Columns.Add do
  begin
    FieldName := 'licence';
    Alignment := taLeftJustify;
    ReadOnly := True;
    Title.Caption := 'licence';
    Title.Alignment := taCenter;
  end;
end;

procedure TSeedsW.getData;
begin
  with getROQuery(pvCnx) do
  begin
    try
      SQL.Add(Format('INSERT INTO %s',[_temp])
                    +' SELECT serprp,sertab,sertrn,serjou,serptn,licence,nomjou'
                    +'       ,codclb,libclb,seqcls,a.codcls,classement,vrbrgl'
                    +'       ,numtds,serblo,sergrp,is_qualified'
                    // The next 2 fields (newtds,points) are runtime added
                    +'       ,numtds,NULL'
                    +' FROM prptab a INNER JOIN classement b'
                    +'   ON a.codcls = b.codcls'
                    +' WHERE sertab = :sertab'
                    +'   AND (a.codcls <= :codcls OR b.selcls = ''A'')'
                    +'   AND COALESCE(serjou,0) > 0');
      ParamByName('sertab').AsInteger := _sertab;
      ParamByName('codcls').AsString := _codcls;
      ExecSQL;
      SQL.Clear;
      SQL.Add(Format('update %s',[_temp])
                    +'  set newtds = 9999'
                    +Format(' where newtds > %d', [_numtds]));
      ExecSQL;
    finally
      Free;
    end;
  end;
end;

procedure TSeedsW.gridKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = '.' then
  begin
    Key := #0;
    _z.Edit;
    _z.FieldByName('points').AsInteger := _z.FieldByName('points').AsInteger + 1;
  end;
end;

procedure TSeedsW.gridTitleClick(Column: TColumn);
begin
  orderByColumn(TZQuery(dts.DataSet),Column,'ASC');
end;

end.
