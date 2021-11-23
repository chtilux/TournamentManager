unit lal_ZQuerysManager;

interface

uses
  lal_ZObject, lal_connection, ZDataset, ZAbstractRODataset, Generics.Collections,
  Data.Db, lal_sequence;

type
  TZQueryType = (zqReadOnly, zqWritable);

  TZQuerysManager = class(TLalZObject)
  private
    FQueryType: TZQueryType;
    FQuerys: TObjectDictionary<string,TDataset>;
    FSequence: TLalSequence;
  protected
  public
    constructor Create(cnx: TLalConnection; QueryType: TZQueryType); reintroduce; overload;
    destructor Destroy; override;
    property Querys: TObjectDictionary<string,TDataset> read FQuerys;
    property Sequence: TLalSequence read FSequence;
  end;

  TZQueryManager = class(TZQuerysManager)
  protected
  public
    function GetQuery(const Name: string): TZQuery; overload;
    function GetQuery(const Name: string; var Query: TZQuery): boolean; overload;
    function CreateQuery(const Name, SQL: string): TZQuery;
  end;

  TZROQueryManager = class(TZQuerysManager)
  protected
  public
    function GetQuery(const Name: string): TZReadOnlyQuery; overload;
    function GetQuery(const Name: string; var Query: TZReadOnlyQuery): boolean; overload;
    function CreateQuery(const Name, SQL: string; const Prepare: boolean = False): TZReadOnlyQuery;
    function CreateTempQuery: TZReadOnlyQuery;
  end;

  TZQueryManagerFactory = class(TLalZObject)
  public
    function GetZQueryManager: TZQueryManager;
    function GetZROQueryManager: TZROQueryManager;
  end;

implementation

uses
  System.SysUtils;

{ TZQuerysManager }

constructor TZQuerysManager.Create(cnx: TLalConnection; QueryType: TZQueryType);
begin
  inherited Create(cnx);
  FQueryType := QueryType;
  FQuerys := TObjectDictionary<string,TDataset>.Create([doOwnsValues]);
  FSequence := TLalSequence.Create(nil, Cnx);
end;

destructor TZQuerysManager.Destroy;
begin
  FSequence.Free;
  FQuerys.Free;
  inherited;
end;

{ TZQueryManager }

function TZQueryManager.CreateQuery(const Name, SQL: string): TZQuery;
var
  z: TZQuery;
begin
  z := GetQuery(Name);
  if Assigned(z) then
    raise Exception.CreateFmt('%s ZQuery already exists !', [Name]);
  Result := TZQuery.Create(nil);
  Result.Connection := Cnx.get;
  Result.SQL.Add(SQL);
  FQuerys.Add(Name,Result);
end;

function TZQueryManager.GetQuery(const Name: string): TZQuery;
var
  z: TDataset;
begin
  Result := nil;
  if FQuerys.TryGetValue(Name, z) then
    Result := TZQuery(z);
end;

function TZQueryManager.GetQuery(const Name: string;
  var Query: TZQuery): boolean;
begin
  Query := GetQuery(Name);
  Result := Assigned(Query);
end;

{ TZROQueryManager }

function TZROQueryManager.CreateQuery(const Name, SQL: string; const Prepare: boolean): TZReadOnlyQuery;
var
  z: TZReadOnlyQuery;
begin
  z := GetQuery(Name);
  if Assigned(z) then
    raise Exception.CreateFmt('%s ZReadOnlyQuery already exists !', [Name]);
  Result := TZReadOnlyQuery.Create(nil);
  Result.Connection := Cnx.get;
  Result.SQL.Add(SQL);
  if Prepare then
    Result.Prepare;
  try
    FQuerys.Add(Name,Result);
  except
    Result.Free;
    Result := nil;
  end;
end;

function TZROQueryManager.GetQuery(const Name: string): TZReadOnlyQuery;
var
  z: TDataset;
begin
  Result := nil;
  if FQuerys.TryGetValue(Name, z) then
    Result := TZReadOnlyQuery(z);
end;

function TZROQueryManager.CreateTempQuery: TZReadOnlyQuery;
begin
  Result := TZReadOnlyQuery.Create(nil);
  Result.Connection := Cnx.get;
end;

function TZROQueryManager.GetQuery(const Name: string;
  var Query: TZReadOnlyQuery): boolean;
begin
  Query := GetQuery(Name);
  Result := Assigned(Query);
end;

{ TZQueryManagerFactory }

function TZQueryManagerFactory.GetZQueryManager: TZQueryManager;
begin
  Result := TZQueryManager.Create(Cnx, zqWritable);
end;

function TZQueryManagerFactory.GetZROQueryManager: TZROQueryManager;
begin
  Result := TZROQueryManager.Create(Cnx, zqReadOnly);
end;

end.

