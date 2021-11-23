unit AreaContent;

interface

uses
  lal_connection, ZDataset, TMEnums, Generics.Collections, Data.Db, Game, Group,
  System.SysUtils, System.Classes;

type
  TDisplayListPos = (dlpTop,dlpMiddle,dlpBottom);

  IAreaContentDisplay = interface
    ['{3709CF26-E5F2-4A81-AB48-A226A6CB159F}']
    function GetPaintMethod: TProc<TCollectionItem>;
    procedure SetPaintMethod(Value: TProc<TCollectionItem>);
    property PaintMethod: TProc<TCollectionItem> read GetPaintMethod write SetPaintMethod;
  end;

  TAreaContentDisplay = class(TInterfacedObject, IAreaContentDisplay)
  private
    FPaintMethod: TProc<TCollectionItem>;
    function GetPaintMethod: TProc<TCollectionItem>;
    procedure SetPaintMethod(Value: TProc<TCollectionItem>);
  public
    property PaintMethod: TProc<TCollectionItem> read GetPaintMethod write SetPaintMethod;
  end;

  IAreaContentDisplayFactory = interface
    ['{A1B50A01-6353-4536-9ACF-0416E542EBAE}']
    function CreateAreaGameContentDisplay: IAreaContentDisplay;
    function CreateAreaGroupContentDisplay: IAreaContentDisplay;
  end;

  TAreaContentDisplayFactory = class(TInterfacedObject, IAreaContentDisplayFactory)
  public
    function CreateAreaGameContentDisplay: IAreaContentDisplay;
    function CreateAreaGroupContentDisplay: IAreaContentDisplay;
  end;

  IAreaContent = interface
    ['{F73A2164-4584-437A-BEF4-0D8B8D180228}']
    function GetSerialContent: integer;
    function GetContentType: TAreaContentType;
    function GetObject: TObject;
    function GetTournamentSerial: integer;
    function GetCatgeorySerial: integer;
    function GetCategory: string;
    function GetContentStartTime: string;
    function GetPlayAreaNumber: integer;
    function GetAreaContentDisplay: IAreaContentDisplay;
    procedure SetAreaContentDisplay(Value: IAreaContentDisplay);

    function GetDisplayTopLeft: string;
    function GetDisplayTopMiddel: string;
    function GetDisplayTopRight: string;
    function GetDisplayLeft(const dlp: TDisplayListPos): string;
    function GetDisplayMiddleMiddle: string;
    function GetDisplayRight(const dlp: TDisplayListPos): string;
    function GetLevel: string;

    property SerialContent: integer read GetSerialContent;
    property ContentType: TAreaContentType read GetContentType;
    property AsObject: TObject read GetObject;
    property TournamentSerial: integer read GetTournamentSerial;
    property CategorySerial: integer read GetCatgeorySerial;
    property Category: string read GetCategory;
    property ContentStartTime: string read GetContentStartTime;
    property PlayAreaNumber: integer read GetPlayAreaNumber;

    property Display: IAreaContentDisplay read GetAreaContentDisplay write SetAreaContentDisplay;

    property DisplayTopLeft: string read GetDisplayTopLeft;
    property DisplayLeft[const dlp: TDisplayListPos]: string read GetDisplayLeft;
    property DisplayTopMiddle: string read GetDisplayTopMiddel;
    property DisplayMiddleMiddle: string read GetDisplayMiddleMiddle;
    property DisplayTopRight: string read GetDisplayTopRight;
    property DisplayRight[const dlp: TDisplayListPos]: string read GetDisplayRight;
    property Level: string read GetLevel;
  end;

  TAreaContent = class(TInterfacedObject, IAreaContent)
  private
    FSerialContent: integer;
    FContentType: TAreaContentType;
    FContentDisplay: IAreaContentDisplay;
    FContent: TObject;
    pvCnx: TLalConnection;
    pvQuerys: TObjectDictionary<string,TZReadOnlyQuery>;
    function GetContentType: TAreaContentType;
    function TryGetField(const query, fieldname: string; var Field: TField): boolean;
    function GetFieldAsInteger(const query, fieldname: string): integer;
    function GetFieldAsString(const query, fieldname: string): string;
    function GetSerialContent: integer;
    function GetTournamentSerial: integer;
    function GetCatgeorySerial: integer;
    function GetCategory: string;

    procedure SetContent(const Value: TObject);
    function GetAreaContentDisplay: IAreaContentDisplay;
    procedure SetAreaContentDisplay(Value: IAreaContentDisplay);

    function GetDisplayTopMiddel: string;
    function GetDisplayTopRight: string;
    function GetLevel: string; virtual;

    function GetDisplayLeft(const dlp: TDisplayListPos): string; virtual;
    function GetDisplayRight(const dlp: TDisplayListPos): string; virtual;
    function GetDisplayTopLeft: string; virtual;
    function GetDisplayMiddleMiddle: string; virtual;
    property DisplayTopLeft: string read GetDisplayTopLeft;
    property DisplayLeft[const dlp: TDisplayListPos]: string read GetDisplayLeft;
    property DisplayMiddleMiddle: string read GetDisplayMiddleMiddle;
    property DisplayTopMiddle: string read GetDisplayTopMiddel;
    property DisplayTopRight: string read GetDisplayTopRight;
    property DisplayRight[const dlp: TDisplayListPos]: string read GetDisplayRight;
    property Level: string read GetLevel;

  protected
    procedure CreateQuerys; virtual;
    function CreateQuery: TZReadOnlyQuery;
    function GetObject: TObject; virtual;
    function GetContent: TObject; virtual;
    function GetQuery(const QueryName: string): TZReadOnlyQuery;
    function GetContentStartTime: string; virtual;
    function GetPlayAreaNumber: integer; virtual;

    property Querys: TObjectDictionary<string,TZReadOnlyQuery> read pvQuerys;

  public
    constructor Create(cnx: TLalConnection; ContentType: TAreaContentType; SerialContent: integer); virtual;
    destructor Destroy; override;
    property ContentType: TAreaContentType read GetContentType;
    property Content: TObject read GetContent write SetContent;
    property SerialContent: integer read GetSerialContent;
    property AsObject: TObject read GetObject;
    property TournamentSerial: integer read GetTournamentSerial;
    property CategorySerial: integer read GetCatgeorySerial;
    property Category: string read GetCategory;
    property ContentStartTime: string read GetContentStartTime;
    property PlayAreaNumber: integer read GetPlayAreaNumber;
    property Display: IAreaContentDisplay read GetAreaContentDisplay write SetAreaContentDisplay;
  end;

  TGameContent = class(TAreaContent)
  private
    FGame: TGame;
    procedure SetGame(const Value: TGame);
  protected
    function GetContentStartTime: string; override;
    function GetPlayAreaNumber: integer; override;
    function GetDisplayTopLeft: string; override;
    function GetDisplayMiddleMiddle: string; override;
    function GetDisplayLeft(const dlp: TDisplayListPos): string; override;
    function GetDisplayRight(const dlp: TDisplayListPos): string; override;
    function GetLevel: string; override;
  public
    property Game: TGame read FGame write SetGame;
    property DisplayTopLeft;
    property DisplayMiddleMiddle;
    property DisplayLeft;
    property DisplayRight;
    property Level;
    property DisplayTopMiddle;
    property DisplayTopRight;
  end;

  TGroupContent = class(TAreaContent)
  private
    FGroupe: TGroup;
    procedure SetGroupe(const Value: TGroup);
  protected
    function GetContentStartTime: string; override;
    function GetPlayAreaNumber: integer; override;
    function GetDisplayTopLeft: string; override;
    function GetLevel: string; override;
    function GetDisplayLeft(const dlp: TDisplayListPos): string; override;
    function GetDisplayRight(const dlp: TDisplayListPos): string; override;
  public
    property Groupe: TGroup read FGroupe write SetGroupe;
    property Level;
    property DisplayLeft;
    property DisplayRight;
    property DisplayTopMiddle;
    property DisplayTopRight;
  end;

implementation

uses
  lal_dbUtils, ZAbstractRODataset, tmUtils15;

const
  csCateg = 'category';
  csGame  = 'game';
  csSertrn = 'sertrn';
  csSercat = 'sercat';
  csCodcat = 'codcat';

{ TAreaContent }

constructor TAreaContent.Create(cnx: TLalConnection; ContentType: TAreaContentType; SerialContent: integer);
begin
  inherited Create;
  pvCnx := cnx;
  FContentType := ContentType;
  FSerialContent := SerialContent;
  pvQuerys := TObjectDictionary<string,TZReadOnlyQuery>.Create([doOwnsValues]);
  CreateQuerys;
end;

function TAreaContent.CreateQuery: TZReadOnlyQuery;
begin
  Result := TZReadOnlyQuery.Create(nil);
  Result.Connection := pvCnx.get;
end;

procedure TAreaContent.CreateQuerys;
var
  z: TZReadOnlyQuery;
begin
  z := CreateQuery;
  case FContentType of
    actKo:    begin
                z.SQL.Add('SELECT * FROM categories WHERE sercat = (SELECT sertab FROM match WHERE sermtc = :serial)');
              end;
    actGroup: begin
                z.SQL.Add('SELECT * FROM categories WHERE sercat = (SELECT sercat FROM groupe WHERE sergrp = :serial)');
              end;
  end;
  z.Params[0].AsInteger := SerialContent;
  z.Open;
  pvQuerys.Add(csCateg,z);
end;

destructor TAreaContent.Destroy;
begin
  pvQuerys.Free;
  inherited;
end;

function TAreaContent.GetContent: TObject;
begin
  case FContentType of
    actKo   :  Result := FContent as TGame;
    actGroup: Result := FContent as TGroup;
    else
      Result := FContent;
  end;
end;

function TAreaContent.GetContentStartTime: string;
begin

end;

function TAreaContent.GetContentType: TAreaContentType;
begin
  Result := FContentType;
end;

//function TAreaContent.GetDisplayBottomMiddle: string;
//begin
//
//end;

function TAreaContent.GetDisplayLeft(const dlp: TDisplayListPos): string;
begin

end;

function TAreaContent.GetDisplayMiddleMiddle: string;
begin

end;

function TAreaContent.GetDisplayRight(const dlp: TDisplayListPos): string;
begin

end;

function TAreaContent.GetDisplayTopLeft: string;
begin
  Result := Category;
end;

function TAreaContent.GetDisplayTopMiddel: string;
begin
  Result := SerialContent.ToString;
end;

function TAreaContent.GetDisplayTopRight: string;
begin
  Result := ContentStartTime;
end;

function TAreaContent.GetFieldAsInteger(const query,
  fieldname: string): integer;
var
  f: TField;
begin
  Result := 0;
  if TryGetField(query,fieldname,f) then
    Result := f.AsInteger;
end;

function TAreaContent.GetFieldAsString(const query, fieldname: string): string;
var
  f: TField;
begin
  if TryGetField(query,fieldname,f) then
    Result := f.AsString;
end;

function TAreaContent.GetLevel: string;
begin

end;

function TAreaContent.TryGetField(const query, fieldname: string;
  var Field: TField): boolean;
var
  z: TZReadOnlyQuery;
begin
  Result := False;
  if pvQuerys.TryGetValue(query, z) then
  begin
    Field := z.FindField(fieldname);
    Result := Assigned(Field);
  end;
end;

function TAreaContent.GetObject: TObject;
begin
  case FContentType of
    actKo: Result    := Self as TGameContent;
    actGroup: Result := Self as TGroupContent;
    else
      Result := Self as TAreaContent;
  end;
end;

function TAreaContent.GetPlayAreaNumber: integer;
begin
  Result := 0;
end;

function TAreaContent.GetQuery(const QueryName: string): TZReadOnlyQuery;
begin
  Result := pvQuerys.Items[QueryName];
end;

function TAreaContent.GetSerialContent: integer;
begin
  Result := FSerialContent;
end;

function TAreaContent.GetTournamentSerial: integer;
begin
  Result := GetFieldAsInteger(csCateg, csSertrn);
end;

procedure TAreaContent.SetAreaContentDisplay(Value: IAreaContentDisplay);
begin
  FContentDisplay := Value;
end;

procedure TAreaContent.SetContent(const Value: TObject);
begin
  FContent := Value;
end;

function TAreaContent.GetCatgeorySerial: integer;
begin
  Result := GetFieldAsInteger(csCateg, csSercat);
end;

function TAreaContent.GetAreaContentDisplay: IAreaContentDisplay;
begin
  Result := FContentDisplay;
end;

function TAreaContent.GetCategory: string;
begin
  Result := GetFieldAsString(csCateg, csCodcat);
end;

{ TGameContent }

function TGameContent.GetContentStartTime: string;
begin
  Result := (AsObject as TGameContent).Game.beginTime;
end;

function TGameContent.GetDisplayLeft(const dlp: TDisplayListPos): string;
var
  game: TGame;
begin
  game := (AsObject as TGameContent).Game;
  Result := Format('%s'+#13#10+'%s'+#13#10+'%s', [game.Player1Name,game.Player1Club,game.Player1Rank]);
end;

function TGameContent.GetDisplayMiddleMiddle: string;
begin
  Result := (AsObject as TGameContent).Game.UmpireName;
end;

function TGameContent.GetDisplayRight(const dlp: TDisplayListPos): string;
var
  game: TGame;
begin
  game := (AsObject as TGameContent).Game;
  Result := Format('%s'+#13#10+'%s'+#13#10+'%s', [game.Player2Name,game.Player2Club,game.Player2Rank]);
end;

function TGameContent.GetDisplayTopLeft: string;
begin
  Result := GetCategory;
end;

function TGameContent.GetLevel: string;
begin
  Result := (AsObject as TGameContent).Game.level;
end;

function TGameContent.GetPlayAreaNumber: integer;
begin
  Result := (AsObject as TGameContent).Game.playAreaNumber;
end;

procedure TGameContent.SetGame(const Value: TGame);
begin
  FGame := Value;
end;

{ TGroupContent }

function TGroupContent.GetContentStartTime: string;
begin
  Result := (AsObject as TGroupContent).Groupe.Heure;
end;

function TGroupContent.GetDisplayLeft(const dlp: TDisplayListPos): string;
begin
  Result := Format('GROUPE N°%d',[(AsObject as TGroupContent).Groupe.GroupNumber]);
end;

function TGroupContent.GetDisplayRight(const dlp: TDisplayListPos): string;
var
  lst: TStrings;
  {$ifdef VER260}
  i: integer;
  {$endif}
begin
  Result := '';
  lst := (AsObject as TGroupContent).Groupe.PlayersList;
  try
    {$ifdef ver330 or higher}
    var i: integer;
    {$endif}
    { boucle commence à 1 pour éviter le crlf en début de string }
    for i := 1 to Pred(lst.Count) do
      Result := Format('%s'+#13#10+'%s',[Result,lst[i]]);
    if Length(Result) > 0 then
      Result := lst[0]+Result;
  finally
    lst.Free;
  end;
end;

function TGroupContent.GetDisplayTopLeft: string;
begin
  Result := GetCategory;
end;

function TGroupContent.GetLevel: string;
begin
  Result := 'QUALIFICATION';
end;

function TGroupContent.GetPlayAreaNumber: integer;
begin
  Result := (AsObject as TGroupContent).Groupe.PlayAreaNumber;
end;

procedure TGroupContent.SetGroupe(const Value: TGroup);
begin
  FGroupe := Value;
end;

{ TAreaContentDisplayFactory }

function TAreaContentDisplayFactory.CreateAreaGameContentDisplay: IAreaContentDisplay;
begin
  Result := TAreaContentDisplay.Create;
  Result.PaintMethod := tmUtils15.glPaintPlayAreaGameContent;
end;

function TAreaContentDisplayFactory.CreateAreaGroupContentDisplay: IAreaContentDisplay;
begin
  Result := TAreaContentDisplay.Create;
  Result.PaintMethod := tmUtils15.glPaintPlayAreaGroupContent;
end;

{ TAreaContentDisplay }

function TAreaContentDisplay.GetPaintMethod: TProc<TCollectionItem>;
begin
  Result := FPaintMethod;
end;

procedure TAreaContentDisplay.SetPaintMethod(Value: TProc<TCollectionItem>);
begin
  FPaintMethod := Value;
end;

end.

