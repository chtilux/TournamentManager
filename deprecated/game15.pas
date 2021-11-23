unit game15;

interface

uses
  lal_connection, Messages, Classes,ZDataset, ZAbstractRODataset,
  DB, System.Types;

type

  TPingSet = Record
    score: array[1..2] of smallint;
    isOk: boolean;
  end;

  TGameResult = Record
    games: array[1..7] of TPingSet;
    score: array[1..2] of smallint;
    withScoreDetail: boolean;
    isOk: boolean;
    function asString: string;
    function asPoints: string;
  end;


  TGame = class(TPersistent)
  private
    pvCnx: TLalConnection;
    pvSermtc: integer;
    pvGame: TZReadOnlyQuery;
    pvGR: TGameResult;
    function getPlayAreaNumber: smallint;
    procedure setPlayAreaNumber(const Value: smallint);
    function getDataset: TDataset;
    function getLoserName: string;
    function getWinnerName: string;
    procedure openDataset;
  public
    constructor Create(cnx: TLalConnection; const sermtc: integer);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure beginGame(const areaNumber: smallint);
    function endGame(const score: string): boolean;
    function setWO(joueur: integer; wo: TWOResult): string;
    property playAreaNumber: smallint read getPlayAreaNumber write setPlayAreaNumber;
    property Dataset: TDataset read getDataset;
    property WinnerName: string read getWinnerName;
    property LoserName: string read getLoserName;
    property GameResult: TGameResult read pvGR;
  end;

implementation

uses
  SysUtils, lal_dbUtils;

{ TGame }

procedure TGame.Assign(Source: TPersistent);
begin
  if Source is TGame then
  begin
    pvSermtc := TGame(Source).pvSermtc;
  end
  else
    inherited;
end;

constructor TGame.Create(cnx: TLalConnection; const sermtc: integer);
begin
  inherited Create;
  pvCnx := cnx;
  pvSermtc := sermtc;
  pvGame := TZReadOnlyQuery.Create(nil);
  pvGame.SQL.Add('SELECT sermtc,sertab,level,numseq,nummtc,datmtc,heure'
                +'   ,serjo1,serjo2,handi1,handi2,score,vainqueur,perdant'
                +'   ,numtbl,prochain,stamtc,sertrn,games,woj1,woj2,modifie'
                +'   ,(SELECT nomjou FROM joueur a WHERE a.serjou = m.serjo1) nomjo1'
                +'   ,(SELECT nomjou FROM joueur a WHERE a.serjou = m.serjo2) nomjo2'
                +'   ,(SELECT nomjou FROM joueur a WHERE a.serjou = m.vainqueur) winnerName'
                +'   ,(SELECT nomjou FROM joueur a WHERE a.serjou = m.perdant) loserName'
                +'   ,(SELECT umpire FROM umpires u WHERE u.SERTRN = m.sertrn AND u.NUMTBL = m.NUMTBL ) umpireName'
                +' FROM match m'
                +' WHERE sermtc = :sermtc');
  pvGame.Params[0].AsInteger := sermtc;
end;

destructor TGame.Destroy;
begin
  pvGame.Free;
  inherited;
end;

function TGame.endGame(const score: string): boolean;
begin
  Result := False;
  { analyze score }
  { validate score }
  { set winner / loser }
  { set state }
end;

function TGame.getDataset: TDataset;
begin
  Result := TDataset(pvGame);
end;

function TGame.getLoserName: string;
begin
  openDataset;
  Result := Dataset.FieldByName('loserName').AsString;
end;

function TGame.getPlayAreaNumber: smallint;
begin
  openDataset;
  Result := Dataset.FieldByName('numtbl').AsInteger;
end;

function TGame.getWinnerName: string;
begin
  openDataset;
  Result := Dataset.FieldByName('winnerName').AsString;
end;

procedure TGame.openDataset;
begin
  if not pvGame.Active then pvGame.Open;
end;

procedure TGame.setPlayAreaNumber(const Value: smallint);
begin

end;

function TGame.setWO(joueur: integer; wo: TWOResult): string;
begin

end;

procedure TGame.beginGame(const areaNumber: smallint);
begin
  with getROQuery(pvCnx) do
  begin
    try
      SQL.Add('update match'
             +' set stamtc = ' + Ord(gsInProgress).ToString
             +'    ,numtbl = ' + areaNumber.ToString
             +' where sermtc = ' + pvSermtc.ToString);
        ExecSQL;
        SQL.Clear;
    finally
      Free;
    end;
  end;
end;

{ TGameResult }

function TGameResult.asPoints: string;
begin

end;

function TGameResult.asString: string;
begin

end;

end.
