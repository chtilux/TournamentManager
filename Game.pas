unit Game;

interface

uses
  lal_connection, ZDataset, Data.Db, TMEnums, System.Classes, Winapi.Windows;

type
  TPingSet = Record
    score: array[1..2] of smallint;
    isOk: boolean;
  end;

  TGame = class;

  TGameResult = Record
    games: array[1..7] of TPingSet;
    score: array[1..2] of smallint;
    points: array[1..2] of smallint;
    withScoreDetail: boolean;
    isOk: boolean;
    isWO: boolean;
    game: TGame;
    function asString: string;
    function asPoints: string;
  end;

  TGame = class(TObject)
  private
    pvCnx: TLalConnection;
    pvGr: TGameResult;
    pvMtc: TZQuery;
    pvJou,
    pvHdc: TZReadOnlyQuery;
    pvSetsToWin: byte;
    pvHandicap: boolean;
//    pvStaCat: TCategorysStatus;
    FPrioPAN: smallint;

    function getPlayAreaNumber: smallint;
    function getSerjo1: integer;
    function getSerjo2: integer;
    procedure handicapGetText(Sender: TField; var Text: string; DisplayText: boolean);
    procedure playerGetText(Sender: TField; var Text: string; DisplayText: boolean);
    function analyzeSets(score: string): Boolean;
    function analyzeGames(score: string): boolean;
    procedure clearDetails;
    function getWinnerName: string;
    function getLoserName: string;
    procedure updateInsc(const serjou: integer; const status: TRegistrationStatus);
    function getWinner: integer;
    function getWinnerIndex: integer;
    function GetLoserIndex: integer;
    procedure edit;
    function getDataset: TDataset;
    procedure setPlayAreaNumber(const Value: smallint);
    function getUmpireName: string;
    function getCategory: string;
    function getGameNumber: integer;
    function getBeginTime: string;
    function getEndTime: string;
    function getPlayer1Name: string;
    function getPlayer2Name: string;
    function getPlayer1Club: string;
    function getPlayer2Club: string;
    function getPlayer1Rank: string;
    function getPlayer2Rank: string;
    function getLevel: string;
    function getSermtc: integer;
    function getSertab: integer;
    function getSerTrn: integer;
    function GetFirstRoundMode: TFirstRoundMode;
  public
    constructor Create(AOwner: TComponent; cnx: TLalConnection; const sermtc: integer); reintroduce; overload;
    destructor Destroy; override;
    procedure clear;
    procedure clearScores;
    function setWO(joueur: integer; wo: TWOResult): string;
    procedure resetWO;
    function WriteBYE: boolean;
    function write: boolean;
    function WriteKO: boolean;
    function WriteQualification: boolean;
    function analyzeScore(score: string; method: TScoreMethod): boolean;
    function getSerProchain: integer;
    function getNextGame: string;
    function getHandicap(const cl1, cl2: string): TPoint;
    property serjo1: integer read getSerjo1;
    property serjo2: integer read getSerjo2;
    property Winner: integer read GetWinner;
    property WinnerIndex: integer read getWinnerIndex;
    property SetsToWin: byte read pvSetsToWin;
    property gameResult: TGameResult read pvGr;
    property WinnerName: string read getWinnerName;
    property LoserName: string read getLoserName;
    property UmpireName: string read getUmpireName;
    property Dataset: TDataset read getDataset;
    property playAreaNumber: smallint read getPlayAreaNumber write setPlayAreaNumber;
    property prioPAN: smallint read FPrioPAN;
    property category: string read getCategory;
    property gameNumber: integer read getGameNumber;
    property beginTime: string read getBeginTime;
    property endTime: string read getEndTime;
    property Player1Name: string read getPlayer1Name;
    property Player2Name: string read getPlayer2Name;
    property Player1Club: string read getPlayer1Club;
    property Player2Club: string read getPlayer2Club;
    property Player1Rank: string read getPlayer1Rank;
    property Player2Rank: string read getPlayer2Rank;
    property level: string read getLevel;
    property sermtc: integer read getSermtc;
    property sertab: integer read getSertab;
    property sertrn: integer read getSerTrn;
    property Phase: TFirstRoundMode read GetFirstRoundMode;
  end;

implementation

uses
  u_pro_strings, System.SysUtils, lal_dbUtils, tmUtils15, Spring.Collections,
  Vcl.Dialogs, System.UITypes, Category;

{ TGameResult }

function TGameResult.asPoints: string;
var
  s: string;
  i,j: integer;
begin
  Result := '';
  if Assigned(game) then
  begin
    j := game.WinnerIndex;
    for i := 1 to 7 do
    begin
      if games[i].isOk then
      begin
        case j of
          1 : begin
            if games[i].score[1] > games[i].score[2] then
              s := Format('%s,%d',[s,games[i].score[2]])
            else
              s := Format('%s,-%d',[s,games[i].score[1]])
          end;
          2 : begin
            if games[i].score[2] > games[i].score[1] then
              s := Format('%s,%d',[s,games[i].score[1]])
            else
              s := Format('%s,-%d',[s,games[i].score[2]])
          end;
        end;
      end
      else
        Break;
    end;
    Delete(s,1,1);
    Result := s;
    if Result = '' then
      Result := Format('%d-%d',[score[1],score[2]]);
  end
  else
    Result := asString;
end;

function TGameResult.asString: string;
var
  s: string;
  i: integer;
begin
  Result := '';
  for i := 1 to 7 do
  begin
    if games[i].isOk then
      s := Format('%s,%d-%d',[s,games[i].score[1],games[i].score[2]]);
  end;
  Delete(s,1,1);
  Result := s;
  if Result = '' then
    Result := Format('%d-%d',[score[1],score[2]]);
end;

{ TGame }

function TGame.analyzeGames(score: string): boolean;
var
  numset,joueur,pt1,pt2: byte;
  points: integer;
  s: string;
begin
  numset := 0;
  joueur := 2;
  s := '';
  while Length(score) > 0 do
  begin
    // 11.4,2.11, 11.0,12.10  -> 35-25
    if isDigit(score[1]) then
    begin
      s := s+score[1];
    end
    else
    begin
      if TryStrToInt(s,points) then
      begin
        Inc(joueur);
        if joueur = 3 then
        begin
          joueur := 1;
          Inc(numset);
        end;
        pvGr.games[numset].score[joueur] := points;
        pvGr.points[joueur] := pvGr.points[joueur] + points;

        { mise à jour du score }
        if joueur = 2 then
        begin
          { contrôle de validité }
           pt1 := pvGr.games[numset].score[1];
           pt2 := pvGr.games[numset].score[2];
           pvGr.games[numset].isOk := (((pt1 >= 11) and (pt2 <= pt1-2))or((pt2 >= 11) and (pt1 <= pt2-2)));
          if (pvGr.games[numset].isOk) then
          begin
            if  (pt1 > pt2) then
              Inc(pvGr.score[1])
            else
              Inc(pvGr.score[2]);
          end
          else
          begin
            s := '';
            Break;
          end;
        end;

        s := '';
      end;
    end;
    Delete(score,1,1);
  end;
  if Length(s) > 0 then
  begin
    if TryStrToInt(s,points) then
    begin
      Inc(joueur);
      if joueur = 3 then
      begin
        joueur := 1;
        Inc(numset);
      end;
      pvGr.games[numset].score[joueur] := points;
      pvGr.points[joueur] := pvGr.points[joueur] + points;
      { contrôle de validité }
       pt1 := pvGr.games[numset].score[1];
       pt2 := pvGr.games[numset].score[2];
       pvGr.games[numset].isOk := (((pt1 >= 11) and (pt2 <= pt1-2))or((pt2 >= 11) and (pt1 <= pt2-2)));
      if (pvGr.games[numset].isOk) then
      begin
        if  (pt1 > pt2) then
          Inc(pvGr.score[1])
        else
          Inc(pvGr.score[2]);
      end;
    end;
  end;
  pvGr.isOk := ((pvGr.score[1] >= 0) and (pvGr.score[2] >= 0)) and
              ((pvGr.score[1] = SetsToWin) or (pvGr.score[2] = SetsToWin)) and
              ((pvGr.score[1] + pvGr.score[2]) <= (SetsToWin + pred(SetsToWin)));
  pvGr.withScoreDetail := True;
  if pvGr.isOk then
  begin
    { update _mtc }
    Edit;
    pvMtc.FieldByName('score').AsString := Format('%d-%d',[pvGr.score[1],pvGr.score[2]]);
    if pvGr.score[1] = SetsToWin then
    begin
      pvMtc.FieldByName('vainqueur').AsInteger := pvMtc.FieldByName('serjo1').AsInteger;
      pvMtc.FieldByName('perdant').AsInteger := pvMtc.FieldByName('serjo2').AsInteger;
    end
    else
    begin
      pvMtc.FieldByName('vainqueur').AsInteger := pvMtc.FieldByName('serjo2').AsInteger;
      pvMtc.FieldByName('perdant').AsInteger := pvMtc.FieldByName('serjo1').AsInteger;
    end;
    pvMtc.FieldByName('stamtc').Value := gsOver;
    pvMtc.FieldByName('games').AsString := pvGr.asString;
  end;
  Result := pvGr.isOk;
end;

function TGame.analyzeScore(score: string; method: TScoreMethod): boolean;
begin
  Result := False;
  clearScores;
  case method of
    smGames: Result := analyzeGames(score);
    smSets:  Result := analyzeSets(score);
  end;
end;

function TGame.analyzeSets(score: string): Boolean;
var
  s: string;
  points,ix: integer;
begin
  clearDetails;
  ix := 0;
  while Length(score) > 0 do
  begin
    if isDigit(score[1]) then
      s := s+score[1]
    else
    begin
      if TryStrToInt(s,points) then
      begin
        Inc(ix);
        if ix <= 2 then
        begin
          pvGr.score[ix] := points;
          s := '';
        end
        else
          Break;
      end;
    end;
    Delete(score,1,1);
  end;
  if Length(s) > 0 then
  begin
    if TryStrToInt(s,points) then
    begin
      Inc(ix);
      if ix <= 2 then
        pvGr.score[ix] := points;
    end;
  end;
  pvGr.isOk := ((pvGr.score[1] >= 0) and (pvGr.score[2] >= 0)) and
              ((pvGr.score[1] = SetsToWin) or (pvGr.score[2] = SetsToWin)) and
              ((pvGr.score[1] + pvGr.score[2]) <= (SetsToWin + pred(SetsToWin)));
  pvGr.withScoreDetail := False;
  if pvGr.isOk then
  begin
    { update _mtc }
    edit;
    pvMtc.FieldByName('score').AsString := Format('%d-%d',[pvGr.score[1],pvGr.score[2]]);
    if pvGr.score[1] = SetsToWin then
    begin
      pvMtc.FieldByName('vainqueur').AsInteger := pvMtc.FieldByName('serjo1').AsInteger;
      pvMtc.FieldByName('perdant').AsInteger := pvMtc.FieldByName('serjo2').AsInteger;
    end
    else
    begin
      pvMtc.FieldByName('vainqueur').AsInteger := pvMtc.FieldByName('serjo2').AsInteger;
      pvMtc.FieldByName('perdant').AsInteger := pvMtc.FieldByName('serjo1').AsInteger;
    end;
    pvMtc.FieldByName('stamtc').Value := gsOver;
  end;
  Result := pvGr.isOk;
end;

procedure TGame.clear;
begin
  clearScores;
  clearDetails;
  edit;
  pvMtc.FieldByName('vainqueur').Clear;
  pvMtc.FieldByName('perdant').Clear;
  pvMtc.FieldByName('woj1').Value := woNull;
  pvMtc.FieldByName('woj2').Value := woNull;
  pvMtc.FieldByName('games').Clear;
  pvMtc.FieldByName('modifie').Clear;
  pvMtc.FieldByName('stamtc').Value := gsInactive;
end;

procedure TGame.clearDetails;
var
  i: Integer;
begin
  for i := 1 to 7 do
  begin
    pvGr.games[i].score[1] := 0;
    pvGr.games[i].score[2] := 0;
    pvGr.games[i].isOk     := False;
  end;
end;

procedure TGame.clearScores;
begin
  clearDetails;
  pvGr.score[1] := 0;
  pvGr.score[2] := 0;
  pvGr.isOk := False;
  pvGr.isWO := False;
  pvGr.points[1] := 0;
  pvGr.points[2] := 0;
end;

constructor TGame.Create(AOwner: TComponent; cnx: TLalConnection;
  const sermtc: integer);
var
  i: integer;
begin
  inherited Create;
  pvCnx := cnx;
  pvGr.game := Self;
  pvMtc := getQuery(pvCnx);
  pvMtc.SQL.Add('SELECT a.sermtc,a.numseq,nummtc,serjo1,serjo2,handi1,handi2,score'
               +'  ,a.vainqueur,a.perdant,prochain,stamtc,a.sertab,COALESCE(a.numtbl,0) numtbl'
               +'  ,a.level,woj1,woj2,games,modifie,a.sertrn,g.codcat,a.heure'
               +'  ,(SELECT nomjou FROM joueur j WHERE j.serjou = a.vainqueur) winnerName'
               +'  ,(SELECT nomjou FROM joueur j WHERE j.serjou = a.perdant) loserName'
               +'  ,(SELECT nomjou FROM joueur j WHERE j.serjou = a.serjo1) player1Name'
               +'  ,(SELECT nomjou FROM joueur j WHERE j.serjou = a.serjo2) player2Name'
               +'  ,(SELECT umpire FROM umpires u WHERE u.SERTRN = a.sertrn AND u.NUMTBL = a.NUMTBL ) umpireName'
               +'  ,(SELECT MAX(x.level) FROM match x WHERE x.sertab = a.sertab) maxLevel'
               +'  ,b.nomjou nomjo1,b.libclb libcl1,b.codcls codcl1'
               +'  ,c.nomjou nomjo2,c.libclb libcl2,c.codcls codcl2'
               +'  ,g.phase,mg.sergrp'
               +' FROM match a LEFT OUTER JOIN tablo b ON a.sertab = b.sertab and a.serjo1 = b.serjou'
               +'              LEFT OUTER JOIN tablo c ON a.sertab = c.sertab and a.serjo2 = c.serjou'
               +'              LEFT JOIN categories g ON g.sercat = a.sertab'
               +'              LEFT JOIN match_groupe mg ON mg.sermtc = a.sermtc'
               +' WHERE a.sermtc = :sermtc');
  pvMtc.FieldDefs.Update;
  for i := 0 to Pred(pvMtc.FieldDefs.Count) do
    pvMtc.FieldDefs[i].CreateField(nil);
  pvMtc.FieldByName('handi1').OnGetText := handicapGetText;
  pvMtc.FieldByName('handi2').OnGetText := handicapGetText;
  pvMtc.FieldByName('nomjo1').OnGetText := playerGetText;
  pvMtc.FieldByName('nomjo2').OnGetText := playerGetText;
  pvMtc.ParamByName('sermtc').AsInteger := sermtc;
  pvMtc.Open;
  FPrioPAN := pvMtc.FieldByName('numtbl').AsInteger;

  pvJou := getROQuery(pvCnx);
  pvJou.SQL.Add('select numset,handicap from categories where sercat = ' + pvMtc.FieldByName('sertab').AsString);
  pvJou.Open;
  pvSetsToWin := pvJou.FieldByname('numset').AsInteger;
  pvHandicap := pvJou.FieldByName('handicap').AsString = '1';
  pvJou.Close;
  pvJou.SQL.Clear;
  pvJou.SQL.Add('select serjou,nomjou,codcls from joueur where serjou = :serjou');
  pvJou.Prepare;

  pvHdc := getROQuery(pvCnx);
  pvHdc.SQL.Add('select hdc from handicap where cl1 = :cl1 and cl2 = :cl2');
  pvHdc.Prepare;
end;

destructor TGame.Destroy;
begin
  pvJou.Free;
  pvHdc.Free;
  pvMtc.Free;
  inherited;
end;

procedure TGame.edit;
begin
  if not(pvMtc.State in dsEditModes) then
    pvMtc.Edit;
end;

function TGame.getBeginTime: string;
begin
  Result := pvMtc.FieldByName('heure').AsString;
end;

function TGame.getCategory: string;
begin
  Result := pvMtc.FieldByName('codcat').AsString;
end;

function TGame.getDataset: TDataset;
begin
  Result := TDataset(pvMtc);
end;

function TGame.getEndTime: string;
begin
  Result := FormatDateTime('hh:nn', pvMtc.FieldByName('modifie').AsDateTime);
end;

function TGame.GetFirstRoundMode: TFirstRoundMode;
begin
  Result := TFirstRoundMode(pvMtc.FieldByName('phase').AsInteger);
end;

function TGame.getGameNumber: integer;
begin
  Result := pvMtc.FieldByName('sermtc').AsInteger;
end;

function TGame.getHandicap(const cl1, cl2: string): TPoint;
begin
  Result.X := 0; Result.Y := 0;
  if cl1 >= cl2 then
  begin
    pvHdc.ParamByName('cl1').AsString := cl1;
    pvHdc.ParamByName('cl2').AsString := cl2;
  end
  else
  begin
    pvHdc.ParamByName('cl2').AsString := cl1;
    pvHdc.ParamByName('cl1').AsString := cl2;
  end;
  pvHdc.Open;
  if cl1 >= cl2 then
  begin
    Result.X := pvHdc.FieldByName('hdc').AsInteger;
    Result.Y := 0;
  end
  else
  begin
    Result.Y := pvHdc.FieldByName('hdc').AsInteger;
    Result.x := 0;
  end;
  pvHdc.Close;
end;

function TGame.getLevel: string;
begin
  Result := '';
  if pvMtc.FieldByName('level').AsInteger = pvMtc.FieldByName('maxLevel').AsInteger then
    Result := 'FINALE'
  else if pvMtc.FieldByName('level').AsInteger = Pred(pvMtc.FieldByName('maxLevel').AsInteger) then
    Result := '1/2 FINALE';
end;

function TGame.GetLoserIndex: integer;
begin
  if serjo1 = Winner then
    Result := 2
  else
    Result := 1;
end;

function TGame.getLoserName: string;
begin
  pvJou.Close;
  pvJou.ParamByName('serjou').AsInteger := pvMtc.FieldByName('perdant').AsInteger;
  pvJou.Open;
  Result := pvJou.FieldByName('nomjou').AsString;
  pvJou.Close;
//  Result := pvMtc.FieldByName('LoserName').AsString;
end;

function TGame.getNextGame: string;
begin
  Result := pvMtc.FieldByName('prochain').AsString;
end;

function TGame.getPlayAreaNumber: smallint;
begin
  Result := pvMtc.FieldByName('numtbl').AsInteger;
end;

function TGame.getPlayer1Club: string;
begin
  Result := pvMtc.FieldByName('libcl1').AsString;
end;

function TGame.getPlayer1Name: string;
begin
  Result := pvMtc.FieldByName('player1Name').AsString;
end;

function TGame.getPlayer1Rank: string;
begin
  Result := pvMtc.FieldByName('codcl1').AsString;
end;

function TGame.getPlayer2Club: string;
begin
  Result := pvMtc.FieldByName('libcl2').AsString;
end;

function TGame.getPlayer2Name: string;
begin
  Result := pvMtc.FieldByName('player2Name').AsString;
end;

function TGame.getPlayer2Rank: string;
begin
  Result := pvMtc.FieldByName('codcl2').AsString;
end;

//function TGame.getProchain: string;
//begin
//  Result := pvMtc.FieldByName('prochain').AsString;
//end;

function TGame.getSerjo1: integer;
begin
  Result := pvMtc.FieldByName('serjo1').AsInteger;
end;

function TGame.getSerjo2: integer;
begin
  Result := pvMtc.FieldByName('serjo2').AsInteger;
end;

function TGame.getSermtc: integer;
begin
  Result := pvMtc.FieldByName('sermtc').AsInteger;
end;

function TGame.getSerProchain: integer;
var
  prochain: string;
  level: integer;
  numseq: integer;
  z: TZReadOnlyQuery;
begin
  Result := 0;
  if Self.getNextGame = '' then
    Exit;
  prochain := Self.getNextGame;
  level := StrToInt(Copy(prochain,1,1));
  delete(prochain,1,2);
  numseq := StrToInt(Copy(prochain,1,3));
  delete(prochain,1,4);
  z := getROQuery(pvCnx);
  try
    z.SQL.Add('select sermtc'
             +' from match'
             +' where sertab = :sertab'
             +'   and level = :level'
             +'   and numseq = :numseq');
    z.ParamByName('sertab').AsInteger := pvMtc.FieldByName('sertab').AsInteger;
    z.ParamByName('level').AsInteger := level;
    z.ParamByName('numseq').AsInteger := numseq;
    z.Open;
    Result := z.Fields[0].AsInteger;
    z.Close;
  finally
    z.Free;
  end;
end;

function TGame.getSertab: integer;
begin
  Result := pvMtc.FieldByName('sertab').AsInteger;
end;

function TGame.getSerTrn: integer;
begin
  Result := pvMtc.FieldByName('sertrn').AsInteger;
end;

function TGame.getUmpireName: string;
begin
  Result := pvMtc.FieldByName('UmpireName').AsString;
end;

function TGame.getWinner: integer;
begin
  Result := pvMtc.FieldByName('vainqueur').AsInteger;
end;

function TGame.getWinnerIndex: integer;
begin
  if serjo1 = Winner then
    Result := 1
  else
    Result := 2;
end;

function TGame.getWinnerName: string;
begin
  pvJou.Close;
  pvJou.ParamByName('serjou').AsInteger := pvMtc.FieldByName('vainqueur').AsInteger;
  pvJou.Open;
  Result := pvJou.FieldByName('nomjou').AsString;
  pvJou.Close;
//  Result := pvMtc.FieldByName('winnerName').AsString;
end;

procedure TGame.handicapGetText(Sender: TField; var Text: string;
  DisplayText: boolean);
begin
  if Sender.AsInteger > 0 then
    Text := Format('+%d', [Sender.AsInteger]);
end;

procedure TGame.playerGetText(Sender: TField; var Text: string;
  DisplayText: boolean);
begin
  if Sender = Sender.DataSet.FieldByName('nomjo1') then
    Text := Format('%s - %s (%d)', [Sender.AsString,Sender.DataSet.FieldByName('libcl1').AsString,Sender.DataSet.FieldByName('serjo1').AsInteger])
  else if Sender = Sender.DataSet.FieldByName('nomjo2') then
    Text := Format('%s - %s (%d)', [Sender.AsString,Sender.DataSet.FieldByName('libcl2').AsString,Sender.DataSet.FieldByName('serjo2').AsInteger])
end;

procedure TGame.resetWO;
begin
  clear;
end;

procedure TGame.setPlayAreaNumber(const Value: smallint);
begin
  edit;
  if not pvMtc.FieldByName('numtbl').ReadOnly then
   pvMtc.FieldByName('numtbl').AsInteger := Value;
end;

function TGame.setWO(joueur: integer; wo: TWOResult): string;
begin
  Result := '';
  clearScores;
  edit;
  pvGr.score[joueur] := 0;
  pvMtc.FieldByName(Format('woj%d',[joueur])).Value := wo;
  pvMtc.FieldByName('perdant').AsInteger := pvMtc.FieldByName(Format('serjo%d',[joueur])).AsInteger;
  if joueur = 1 then
    Inc(joueur) else Dec(joueur);
  pvGr.score[joueur] := 0;
  pvMtc.FieldByName('vainqueur').AsInteger := pvMtc.FieldByName(Format('serjo%d',[joueur])).AsInteger;
  pvMtc.FieldByName(Format('woj%d',[joueur])).Value := woWin;
  pvMtc.FieldByName('stamtc').Value := gsOver;
  pvGr.isOk := True;
  pvJou.ParamByName('serjou').AsInteger := pvMtc.FieldByName(Format('serjo%d',[joueur])).AsInteger;
  pvJou.Open;
  Result := pvJou.FieldByName('nomjou').AsString;
  pvJou.Close;

  pvMtc.FieldByName('score').AsString := 'WO';
  pvGr.isWO := True;
end;

procedure TGame.updateInsc(const serjou: integer; const status: TRegistrationStatus);
var
  serinsc: integer;
begin
  with getROQuery(pvCnx) do
  begin
    try
      SQL.Add('select serinsc from insc where serjou = :serjou and sercat = :sercat');
      ParamByName('serjou').AsInteger := serjou;
      ParamByName('sercat').AsInteger := pvMtc.FieldByName('sertab').AsInteger;
      Open;
      serinsc := Fields[0].AsInteger;
      Close;
      SQL.Clear;
      SQL.Add('update insc set statut = :statut where serinsc = :serinsc');
      ParamByName('statut').Value := status;
      ParamByName('serinsc').AsInteger := serinsc;
      ExecSQL;
    finally
      Free;
    end;
  end;
end;

function TGame.write: boolean;
begin
  if Phase = frKO then
    Result := WriteKO
  else
    Result := WriteQualification;
end;

function TGame.WriteKO: boolean;
var
  i,j: integer;
  z: TZReadOnlyQuery;
  hdc: TPoint;
  cl1,cl2: string;
label
  write;
begin
  Result := False;
  { si 2 joueurs, on vérifie si le score est ok }
  if (serjo1 > 0) and (serjo2 > 0) then
  begin
    if pvGr.isOk then
    begin
      Edit;
      pvMtc.FieldByName('modifie').Value := Now;
      goto write;
    end
    else
    begin
      if (Trim(pvMtc.FieldByName('numtbl').AsString) <> '') then
      begin
        with getROQuery(pvCnx) do
        begin
          pvCnx.startTransaction;
          try
            SQL.Clear;
            SQL.Add('UPDATE match SET numtbl = :numtbl'
                   +'  ,stamtc = :stamtc'
                   +'  ,modifie = CURRENT_TIMESTAMP'
                   +' WHERE sermtc = :sermtc');
            ParamByName('numtbl').AsString := Trim(pvMtc.FieldByName('numtbl').AsString);
            ParamByName('stamtc').Value := gsInProgress;
            ParamByName('sermtc').AsInteger := pvMtc.FieldByName('sermtc').AsInteger;
            ExecSQL;
            SQL.Clear;
            SQL.Add('UPDATE umpires SET sermtc = :sermtc'
                   +' ,statbl = :statbl'
                   +' WHERE sertrn = :sertrn'
                   +'   AND numtbl = :numtbl');
            ParamByName('sermtc').AsInteger := pvMtc.FieldByName('sermtc').AsInteger;
            ParamByName('statbl').AsInteger := Ord(pasBusy);
            ParamByName('sertrn').AsInteger := pvMtc.FieldByName('sertrn').AsInteger;
            ParamByName('numtbl').AsInteger := pvMtc.FieldByName('numtbl').AsInteger;
            ExecSQL;
            pvCnx.commit;
            Result := True;
          except
            pvCnx.rollback;
            raise;
          end;
          Exit;
        end;
      end;
    end;
  end
  { sinon si 1 seul joueur, on valide automatiquement }
  else
  if ((serjo1 > 0) and (serjo2 = 0)) or ((serjo2 > 0) and (serjo1 = 0)) then
  begin
    writeBYE;
    goto write;
  end
  else
  { les 2 joueurs sont absents !!! }
  begin
    clear;
    edit;
    pvMtc.FieldByName('stamtc').Value := gsOver;
    goto write;
  end;

write:
  z := getROQuery(pvCnx);
  try
    z.SQL.Add('UPDATE match'
             +'   SET score = :score'
             +'      ,vainqueur = :vainqueur'
             +'      ,perdant = :perdant'
             +'      ,numtbl = :numtbl'
             +'      ,stamtc = :stamtc'
             +'      ,games = :games'
             +'      ,woj1 = :woj1'
             +'      ,woj2 = :woj2'
             +'      ,modifie = CURRENT_TIMESTAMP'
             +' WHERE sermtc = :sermtc');
    for i := 0 to Pred(z.Params.Count) do
      if pvMtc.FindField(z.Params[i].Name) <> nil then
        z.Params[i].Value := pvMtc.FieldByName(z.Params[i].Name).Value;
    z.ParamByName('games').AsString := pvGr.asString;
    pvCnx.startTransaction;
    try
      z.ExecSQL;
      if (serjo1 > 0) and (serjo2 > 0) and (pvGr.isOk) then
      begin
        { write match result, update umpires table, send message }
        endGame(pvMtc.FieldByName('sertrn').AsInteger,
                pvMtc.FieldByName('sermtc').AsInteger,
                pvMtc.FieldByName('vainqueur').AsInteger,
                pvMtc.FieldByName('perdant').AsInteger,
                pvMtc.FieldByName('numtbl').AsInteger,
                getLoserName);
      end;
        { c'est le lancement de la categorie dans la fenêtre arena qui modifie
          le statut de la categorie en scEnCours }
      updateInsc(pvMtc.FieldByName('vainqueur').AsInteger,rsQualified);
      if (pvMtc.FieldByName('score').AsString <> 'WO') or (pvMtc.FieldByName('level').AsInteger > 2) then
        updateInsc(pvMtc.FieldByName('perdant').AsInteger,rsDisqualified)
      else
        updateInsc(pvMtc.FieldByName('perdant').AsInteger,rsWO);
      { maj du prochain match }
      i := getSerProchain;
      if i > 0 then
      begin
        z.SQL.Clear;
        if not pvMtc.Active then
          Exit;
        cl1 := pvMtc.FieldByName('prochain').AsString;
        j := Length(cl1);
        j := StrToInt(Copy(cl1,j,1));
        z.SQL.Add('update match'
                 +Format('   set serjo%d = :serjou',[j])
                 +' where sermtc = :sermtc');
        z.ParamByName('serjou').AsInteger := pvMtc.FieldByName('vainqueur').AsInteger;
        z.ParamByName('sermtc').AsInteger := i;
        z.ExecSQL;
        { si tableau handicap et 2 joueurs présents, maj handi1 et handi2 }
        if pvHandicap then
        begin
          z.SQL.Clear;
          z.SQL.Add('select serjo1,serjo2 from match where sermtc = :sermtc');
          z.ParamByName('sermtc').AsInteger := i;
          z.Open;
          if (z.FieldByName('serjo1').AsInteger > 0) and (z.FieldByName('serjo2').AsInteger > 0) then
          begin
            hdc.X := z.FieldByName('serjo1').AsInteger;
            hdc.Y := z.FieldByName('serjo2').AsInteger;
            z.Close;
            z.SQL.Clear;
            z.SQL.Add('select codcls from joueur where serjou = :serjou');
            z.Prepare;
            z.ParamByName('serjou').AsInteger := hdc.X;
            z.Open;
            cl1 := z.FieldByName('codcls').AsString;
            z.Close;
            z.ParamByName('serjou').AsInteger := hdc.Y;
            z.Open;
            cl2 := z.FieldByName('codcls').AsString;
          end;
          if z.Active then z.Close;
          hdc := getHandicap(cl1,cl2);
          if (hdc.X > 0) or (hdc.Y > 0) then
          begin
            if z.Active then z.Close;
            z.SQL.Clear;
            z.SQL.Add('update match set handi1 = :hdc1, handi2 = :hdc2'
                     +' where sermtc = :sermtc');
            z.ParamByName('hdc1').Value := hdc.X;
            z.ParamByName('hdc2').Value := hdc.Y;
            z.ParamByName('sermtc').Value := i;
            z.ExecSQL;
          end;
        end;
      end;
      pvCnx.commit;
      CheckAndSetCategorieStatusAfterUpdate(pvMtc.FieldByName('sertab').AsInteger);
      if (serjo1 > 0) and (serjo2 > 0) and (pvGr.isOk) then
      begin
//        broadcastMessage(wm_gameIsOver,pvMtc.FieldByName('sertab').AsInteger,pvMtc.FieldByName('sermtc').AsInteger);
        broadcastMessage(wm_endGame,pvMtc.FieldByName('sermtc').AsInteger,pvMtc.FieldByName('numtbl').AsInteger);
      end;
    except
      pvCnx.rollback;
      raise;
    end;
    Result := True;
  finally
    z.Free;
  end;
end;

function TGame.WriteQualification: boolean;
var
  z: TZReadOnlyQuery;
  i: integer;
  p: TParam;
  f: TField;
  vainqueur,
  perdant,
  games,points: integer;
  winner: IList<integer>;
begin
  Result := False;
  pvCnx.startTransaction;
  try
    { vérifications }
    if (serjo1 > 0) and (serjo2 > 0) and not(pvGr.isOk) then
    begin
      pvCnx.rollback;
      Exit;
    end;

    z := getROQuery(pvCnx);
    try
      { validation du simple }
      z.SQL.Add('UPDATE match'
               +'   SET score = :score'
               +'      ,vainqueur = :vainqueur'
               +'      ,perdant = :perdant'
               +'      ,stamtc = :stamtc'
               +'      ,games = :games'
               +'      ,woj1 = :woj1'
               +'      ,woj2 = :woj2'
               +'      ,modifie = CURRENT_TIMESTAMP'
               +' WHERE sermtc = :sermtc');

      for i := 0 to Pred(z.Params.Count) do
      begin
        f := pvMtc.FindField(z.Params[i].Name);
        if f <> nil then
        begin
          p := z.Params.FindParam(f.FieldName);
          if Assigned(p) then
            p.Value := f.Value;
        end;
      end;
      z.ParamByName('games').AsString := pvGr.asString;
      { modifier le statut du match }
      z.ParamByName('stamtc').AsInteger := Ord(gsOver);
      z.ExecSQL;

      { inscriptions des résultats des joueurs }
      z.SQL.Clear;
      z.SQL.Add('INSERT INTO groupe_result (sergrp,serjou,seradv,winner,games,points,sercat,sertrn)'
               +' VALUES (:sergrp,:serjou,:seradv,:winner,:games,:points,:sercat,:sertrn)');
      z.Prepare;
      z.ParamByName('sergrp').AsInteger := pvMtc.FieldByName('sergrp').AsInteger;
      z.ParamByName('sercat').AsInteger := sertab;
      z.ParamByName('sertrn').AsInteger := sertrn;
      { vainqueur }
      z.ParamByName('serjou').AsInteger := pvMtc.FieldByName('vainqueur').AsInteger;
      z.ParamByName('seradv').AsInteger := pvMtc.FieldByName('perdant').AsInteger;
      z.ParamByName('winner').AsInteger := 1;
      z.ParamByName('games').AsInteger  := pvGr.score[getWinnerIndex] - pvGr.score[GetLoserIndex];
      z.ParamByName('points').AsInteger := pvGr.points[getWinnerIndex] - pvGr.points[GetLoserIndex];
      z.ExecSQL;
      { perdant }
      z.ParamByName('serjou').AsInteger := pvMtc.FieldByName('perdant').AsInteger;
      z.ParamByName('seradv').AsInteger := pvMtc.FieldByName('vainqueur').AsInteger;
      z.ParamByName('winner').AsInteger := 0;
      z.ParamByName('games').AsInteger  := pvGr.score[GetLoserIndex] - pvGr.score[getWinnerIndex];
      z.ParamByName('points').AsInteger := pvGr.points[GetLoserIndex] - pvGr.points[getWinnerIndex];
      z.ExecSQL;

//{ validation du groupe }
      z.SQL.Clear;
      z.SQL.Add('SELECT COUNT(*) FROM match mtc'
               +'   INNER JOIN match_groupe mg ON mg.sermtc = mtc.sermtc'
               +' WHERE mg.sergrp = :sergrp'
               +'   AND mtc.stamtc <> :stamtc');
      z.Params[0].AsInteger := pvMtc.FieldByName('sergrp').AsInteger;
      z.Params[1].AsInteger := Ord(gsOver);
      z.Open;
      if z.Fields[0].AsInteger = 0 then
      begin
        { tous les matchs du groupe sont terminés }
        z.Close;
        { qualifier le vainqueur }
        vainqueur := 0;
        z.SQL.Clear;
        z.SQL.Add('SELECT serjou, COUNT(*)'
                 +' FROM groupe_result'
                 +' WHERE sergrp = :sergrp'
                 +'   AND winner = 1'
                 +' GROUP BY 1'
                 +' HAVING COUNT(*) = 2');
        z.Params[0].AsInteger := pvMtc.FieldByName('sergrp').AsInteger;
        z.Open;
        { cas le plus simple, 1 seul vainqueur avec 2 victoires }
        if not z.Eof then
        begin
          { qualifier le vainqueur }
          vainqueur := z.Fields[0].AsInteger;
          z.SQL.Clear;
          z.SQL.Add('UPDATE prptab'
                   +' SET is_qualified = :is_qualified'
                   +' WHERE sergrp = :sergrp'
                   +'   AND serjou = :serjou');
          z.Params[0].AsInteger := Ord(rsQualified);
          z.Params[1].AsInteger := pvMtc.FieldByName('sergrp').AsInteger;
          z.Params[2].AsInteger := vainqueur;
          z.ExecSQL;
          { l'arbitre est le perdant du match entre les 2 autres }
          z.SQL.Clear;
          z.SQL.Add('SELECT serjou FROM groupe_result'
                   +' WHERE sergrp = :sergrp'
                   +'   AND (serjou <> :vainqueur AND seradv <> :vainqueur)'
                   +'   AND winner = 0');
          z.Params[0].AsInteger := pvMtc.FieldByName('sergrp').AsInteger;
          z.Params[1].AsInteger := vainqueur;
          z.Open;
          perdant := z.Fields[0].AsInteger;
          z.Close;
          z.SQL.Clear;
          z.SQL.Add('UPDATE umpires ump'
                   +'   SET ump.serump = :serjou'
                   +'      ,ump.umpire = (SELECT jou.nomjou FROM joueur jou WHERE jou.serjou = :perdant)'
                   +'      ,ump.statbl = :statbl'
                   +'      ,ump.prvmtc = sermtc'
                   +'      ,ump.sermtc = NULL'
                   +' WHERE ump.sertrn = :sertrn'
                   +'   AND ump.numtbl = :numtbl');
          z.Params[0].AsInteger := perdant;
          z.Params[1].AsInteger := perdant;
          z.Params[2].AsInteger := Ord(pasAvailable);
          z.Params[3].AsInteger := sertrn;
          z.Params[4].AsInteger := pvMtc.FieldByName('numtbl').AsInteger;
          z.ExecSQL;
        end
        else
        begin
          z.Close;
          z.SQL.Clear;
          z.SQL.Add('SELECT serjou'
//                   +'      ,SUM(winner) AS wins'
                   +'      ,SUM(games) AS games'
                   +'      ,SUM(points) AS points'
                   +' FROM groupe_result'
                   +' WHERE sergrp = :sergrp'
                   +' GROUP BY 1'
                   +' HAVING SUM(winner) = 1'
                   +' ORDER BY 2 DESC, 3 DESC');
          z.Params[0].AsInteger := pvMtc.FieldByName('sergrp').AsInteger;
          z.Open;
          games := -999;
          { décompte sur les sets }
          perdant := 0;
          winner := TCollections.CreateList<integer>;
          while not z.Eof do
          begin
            if z.Fields[1].AsInteger > games then
            begin
              games := z.Fields[1].AsInteger;
              winner.Clear;
              winner.Add(z.Fields[0].AsInteger);
            end
            else if z.Fields[1].AsInteger = games then
            begin
              winner.Add(z.Fields[0].AsInteger);
            end
            else
            begin
              z.Last;
              perdant := z.Fields[0].AsInteger;
              Break;
            end;
            z.Next;
          end;
          z.Close;
          if perdant > 0 then
          begin
            z.SQL.Clear;
            z.SQL.Add('UPDATE umpires ump'
                     +'   SET ump.serump = :serjou'
                     +'      ,ump.umpire = (SELECT jou.nomjou FROM joueur jou WHERE jou.serjou = :perdant)'
                     +'      ,ump.statbl = :statbl'
                     +'      ,ump.prvmtc = sermtc'
                     +'      ,ump.sermtc = NULL'
                     +' WHERE ump.sertrn = :sertrn'
                     +'   AND ump.numtbl = :numtbl');
            z.Params[0].AsInteger := perdant;
            z.Params[1].AsInteger := perdant;
            z.Params[2].AsInteger := Ord(pasAvailable);
            z.Params[3].AsInteger := sertrn;
            z.Params[4].AsInteger := pvMtc.FieldByName('numtbl').AsInteger;
            z.ExecSQL;
          end;

          { décompte sur les points }
          if winner.Count > 1 then
          begin
            winner.Clear;
            z.SQL.Clear;
            z.SQL.Add('SELECT serjou'
  //                   +'      ,SUM(winner) AS wins'
//                     +'      ,SUM(gr.games) AS games'
                     +'      ,SUM(points) AS points'
                     +' FROM groupe_result'
                     +' WHERE sergrp = :sergrp'
                     +' GROUP BY 1'
                     +' HAVING SUM(winner) = 1'
                     +'   AND SUM(games) = :games'
                     +' ORDER BY 2 DESC');
            z.Params[0].AsInteger := pvMtc.FieldByName('sergrp').AsInteger;
            z.Params[1].AsInteger := games;
            z.Open;
            points := -999;
            while not z.Eof do
            begin
              if z.Fields[1].AsInteger > points then
              begin
                points := z.Fields[1].AsInteger;
                winner.Clear;
                winner.Add(z.Fields[0].AsInteger);
              end
              else if z.Fields[1].AsInteger = points then
              begin
                winner.Add(z.Fields[0].AsInteger);
              end
              else
                Break;
              z.Next;
            end;
          end;
          z.Close;
          if winner.Count = 1 then
          begin
            z.SQL.Clear;
            z.SQL.Add('UPDATE prptab'
                     +' SET is_qualified = :is_qualified'
                     +' WHERE sergrp = :sergrp'
                     +'   AND serjou = :serjou');
            z.Params[0].AsInteger := Ord(rsQualified);
            z.Params[1].AsInteger := pvMtc.FieldByName('sergrp').AsInteger;
            z.Params[2].AsInteger := winner[0];
            z.ExecSQL;
          end
          else
          begin
            { égalité parfaite ??? }
            MessageDlg('Une égalité parfaite sur les matchs gagnés, les sets et les points a été calculée !'
                      +#13#10
                      +'Il faut qualifier le vainqueur et valider l''arbitre manuellement', mtWarning, [mbOk], 0);
          end;
        end;

        z.SQL.Clear;
        z.SQL.Add('UPDATE groupe'
                 +' SET stagrp = :stagrp'
                 +'    ,winner = :vainqueur'
                 +'    ,umpire = :perdant'
                 +' WHERE sergrp = :sergrp');
        z.Params[0].AsInteger := Ord(qgsOver);
        z.Params[1].AsInteger := vainqueur;
        z.Params[2].AsInteger := perdant;
        z.Params[3].AsInteger := pvMtc.FieldByName('sergrp').AsInteger;
        z.ExecSQL;
        broadcastMessage(wm_qualificationGroupRefresh, pvMtc.FieldByName('sergrp').AsInteger, 0);

        { y a-t-il encore des groupes en cours ? }
        with TQualificationGroup.Create(pvCnx, sertab) do
        begin
          try
            ChangeQualificationGroupPhaseToKO;
            if sertab <> Serial then
               broadcastMessage(wm_CategoryPhaseChanged, sertab, Serial);
          finally
            Free;
          end;
        end;
//        z.SQL.Clear;
//        z.SQL.Add('SELECT COUNT(*) FROM groupe'
//                 +' WHERE sercat = :sercat'
//                 +'   AND stagrp <> :stagrp');
//        z.Params[0].AsInteger := sertab;
//        z.Params[1].AsInteger := Ord(qgsOver);
//        z.Open;
//        if z.Fields[0].AsInteger = 0 then
//        begin
//          { tous les groupes sont terminés, passer la catégorie en phase KO }
//          z.Close;
//          z.SQL.Clear;
//          z.SQL.Add('UPDATE categories SET phase = :phase'
//                   +'                    ,stacat = :stacat'
//                   +' WHERE sercat = :sercat');
//          z.Params[0].AsInteger := Ord(frKO);
//          z.Params[1].AsInteger := Ord(csInactive);
//          z.Params[2].AsInteger := sertab;
//          z.ExecSQL;
//        end;
      end;  { tous les matchs du groupe sont terminés }

      if z.Active then z.Close;
    finally
      z.Free;
    end;

    if pvCnx.get.InTransaction then
      pvCnx.Commit;

    Result := True;
  except
    pvCnx.rollback;
    raise;
  end;
end;

function TGame.WriteBYE: boolean;
begin
  edit;
  if (serjo1 > 0) and (serjo2 = 0) then
    pvMtc.FieldByName('vainqueur').AsInteger := serjo1
  else
    pvMtc.FieldByName('vainqueur').AsInteger := serjo2;
  pvMtc.FieldByName('perdant').Clear;
  pvMtc.FieldByName('score').Value := 'BYE';
  pvMtc.FieldByName('games').Clear;
  pvMtc.FieldByName('stamtc').Value := gsOver;
  Result := True;
end;

end.

