unit category;

interface

uses
  lal_ZObject, lal_connection, lal_ZQuerysManager, TMEnums, ZDataset,
  ZAbstractRODataset;

type
  TCategory = class(TLalZObject)
  private
    FSerial: integer;
    FQueryManager: TZROQueryManager;
    FSQL: string;
    FTempQuery: TZReadOnlyQuery;
    FCategory: TZReadOnlyQuery;

    procedure SetSerial(const Value: integer);
    procedure SetSQL(const Value: string);
    procedure SetTempQuery(const Value: TZReadOnlyQuery);
    function GetCategoryQuery: TZReadOnlyQuery;

  protected
    const
      cs_tableName = 'categories';
      cs_read_category = 'read_category';
      cs_insert_category = 'insert_category';
      cs_updateStatus = 'updateStatus';

    procedure CreateQuerys; virtual;

    procedure SetStatus(const phase: TFirstRoundMode; status: TCategorysStatus);

    property QueryManager: TZROQueryManager read FQueryManager;
    property SQL: string read FSQL write SetSQL;
    property TempQuery: TZReadOnlyQuery read FTempQuery write SetTempQuery;

  public
    constructor Create(cnx: TLalConnection; const sercat: integer); reintroduce; overload;
    destructor Destroy; override;
    property Serial: integer read FSerial write SetSerial;
  end;

  TQualificationGroup = class(TCategory)
  private
    procedure CreateDraw;

  protected
    const
      cs_AreGroupsInProgress = 'AreGroupsInProgress';

    procedure CreateQuerys; override;
  public
    function CheckQualificationPhaseIsOver: boolean;
    {: returns draw serial }
    procedure ChangeQualificationGroupPhaseToKO;
  end;

implementation

uses
  lal_dbUtils, System.SysUtils, tmUtils15;

{ TCategory }

constructor TCategory.Create(cnx: TLalConnection; const sercat: integer);
var
  pvFactory: TZQueryManagerFactory;
begin
  inherited Create(cnx);
  pvFactory := TZQueryManagerFactory.Create(Cnx);
  try
    FQueryManager := pvFactory.GetZROQueryManager;
  finally
    pvFactory.Free;
  end;
  CreateQuerys;
  Serial := sercat;
end;

procedure TCategory.CreateQuerys;
begin
  SQL := Format('SELECT sercat,sertrn,saison,codcat,heudeb,simple,handicap'
               +'      ,numset,catage,stacat,numseq,first_round_mode'
               +'      ,phase,parent'
               +' FROM %s'
               +' WHERE sercat = :sercat',[cs_tableName]);
  FCategory := QueryManager.CreateQuery(cs_read_category,SQL,True);

  SQL := Format('UPDATE %s SET phase = :phase'
               +'             ,stacat = :stacat'
               +' WHERE sercat = :sercat',[cs_tableName]);
  QueryManager.CreateQuery(cs_updateStatus,SQL,True);

  SQL := GetInsertQuery(Cnx, cs_tableName);
  QueryManager.CreateQuery(cs_insert_category, SQL, True);
end;

destructor TCategory.Destroy;
begin
  FQueryManager.Free;
  inherited;
end;

function TCategory.GetCategoryQuery: TZReadOnlyQuery;
begin
  Result := FCategory;
end;

procedure TCategory.SetSerial(const Value: integer);
var
  z: TZReadOnlyQuery;
begin
  if FSerial <> Value then
  begin
    z := GetCategoryQuery;
    z.Active := False;
    z.ParamByName('sercat').AsInteger := Value;
    z.Open;
    FSerial := Value;
  end;
end;

procedure TCategory.SetSQL(const Value: string);
begin
  FSQL := Value;
end;

procedure TCategory.SetStatus(const phase: TFirstRoundMode; status: TCategorysStatus);
begin
  if QueryManager.GetQuery(cs_updateStatus, FTempQuery) then
  begin
    TempQuery.ParamByName('phase').AsInteger := Ord(phase);
    TempQuery.ParamByName('stacat').AsInteger := Ord(status);
    TempQuery.ParamByName('sercat').AsInteger := Serial;
    TempQuery.ExecSQL;
  end;
end;

procedure TCategory.SetTempQuery(const Value: TZReadOnlyQuery);
begin
  FTempQuery := Value;
end;

{ TQualificationGroup }

procedure TQualificationGroup.CreateQuerys;
begin
  inherited;
  SQL := 'SELECT COUNT(*) FROM groupe'
        +' WHERE sercat = :sercat'
        +'   AND stagrp <> :stagrp';
  QueryManager.CreateQuery(cs_AreGroupsInProgress,SQL,True);
end;

function TQualificationGroup.CheckQualificationPhaseIsOver: boolean;
var
  z: TZReadOnlyQuery;
begin
  z := QueryManager.GetQuery(cs_AreGroupsInProgress);
  Result := Assigned(z);
  if Result then
  begin
    if z.Active then
      z.Close;
    z.ParamByName('sercat').AsInteger := Serial;
    z.ParamByName('stagrp').AsInteger := Ord(qgsOver);
    z.Open;
    Result := z.Fields[0].AsInteger = 0;
    z.Close;
  end;
end;

procedure TQualificationGroup.ChangeQualificationGroupPhaseToKO;
begin
  if CheckQualificationPhaseIsOver then
    CreateDraw;
end;

procedure TQualificationGroup.CreateDraw;
var
  NewSerial,
  NumberOfPlayers,
  DrawSize: integer;
  x, z, ins: TZReadOnlyQuery;
  sql: string;
  numseq: integer;
begin
  { set the phase and stacat of the current category }
  SetStatus(frQualification, csOver);
  { create a new category with the current one as parent }
  z := QueryManager.CreateTempQuery;
  try
    z.SQL.Add('SELECT COUNT(*) FROM prptab'
             +' WHERE sertab = :sercat'
             +'   AND is_qualified = :is_qualified');
    z.Params[0].AsInteger := Serial;
    z.Params[1].AsInteger := Ord(rsQualified);
    z.Open;
    NumberOfPlayers := z.Fields[0].AsInteger;
    DrawSize := getTailleTableau(NumberOfPlayers);
    z.Close;
    z.SQL.Clear;

    sql := GetInsertQuery(Cnx, 'tableau');
    z.SQL.Add(sql);
    Cnx.startTransaction;
    try
      NewSerial := QueryManager.Sequence.SerialByName('INSCRIPTION');
      GetCategoryQuery.Refresh;
      z.ParamByName('sertab').AsInteger := NewSerial;
      z.ParamByName('taille').AsInteger := DrawSize;
      z.ParamByName('nbrjou').AsInteger := NumberOfPlayers;
      z.ParamByName('nbrtds').AsInteger := 0;
      z.ParamByName('sertrn').AsInteger := GetCategoryQuery.FieldByName('sertrn').AsInteger;
      z.ParamByName('nbrgrp').AsInteger := 0;
      z.ExecSQL;

      ins := QueryManager.GetQuery(cs_insert_category);
      BuildParamsFromTable(ins.Params, GetCategoryQuery);
      ins.ParamByName('sercat').AsInteger := NewSerial;
      ins.ParamByName('stacat').AsInteger := Ord(csInactive);
      ins.ParamByName('phase').AsInteger := Ord(frKO);
      ins.ParamByName('parent').AsInteger := Serial;
      ins.ExecSQL;

      z.SQL.Clear;
      sql := GetInsertQuery(Cnx, 'prptab');
      z.SQL.Add(sql);
      z.Prepare;
      x := QueryManager.CreateTempQuery;
      try
        x.SQL.Add('SELECT * FROM prptab'
                 +' WHERE sertab = :sertab'
                 +'   AND is_qualified = :is_qualified'
                 +' ORDER BY vrbrgl');
        x.Params[0].AsInteger := Serial;
        x.Params[1].AsInteger := Ord(rsQualified);
        x.Open;
        numseq := 0;
        while not x.Eof do
        begin
          Inc(numseq);
          BuildParamsFromTable(z.Params, x);
          z.ParamByName('serprp').AsInteger := QueryManager.Sequence.SerialByName('CATEGORIE');
          z.ParamByName('sertab').AsInteger := NewSerial;
          z.ParamByName('sergrp').Clear;
          z.ParamByName('numtds').AsInteger := numseq;
          z.ExecSQL;
          x.Next;
        end;
        x.Close;
      finally
        x.Free;
      end;

      { on termine le tableau avec BYE }
      z.ParamByName('serjou').AsInteger := 0;
      z.ParamByName('serptn').AsInteger := 0;
      z.ParamByName('licence').AsString := '';
      z.ParamByName('nomjou').AsString := 'BYE';
      z.ParamByName('codclb').AsString := '';
      z.ParamByName('libclb').AsString := '';
      z.ParamByName('codcls').AsString := '';
      z.ParamByName('classement').AsString := '';
      z.ParamByName('vrbrgl').AsInteger := 9999;
      z.ParamByName('seqcls').AsInteger := 9999;
      while numseq < DrawSize do
      begin
        Inc(numseq);
        z.ParamByName('serprp').AsInteger := QueryManager.Sequence.SerialByName('CATEGORIE');
        z.ParamByName('numtds').AsInteger := numseq;
        z.ExecSQL;
      end;
      Cnx.commit;
      Serial := NewSerial;
      SetStatus(frKO, csPrepared);
    except
      Cnx.rollback;
      raise;
    end;
  finally
    z.Free;
  end;
end;

end.

