unit match;

interface

uses
  Classes, lal_connection, ZConnection, System.Contnrs, System.Types,
  ZDataset, DB, tmUtils15, TMEnums;

type
  TMatchFoo = class;

  TGame = Record
    score: array[1..2] of smallint;
    isOk: boolean;
  end;

  TGameResult = Record
    games: array[1..7] of TGame;
    score: array[1..2] of smallint;
    withScoreDetail: boolean;
    isOk: boolean;
    match: TMatchFoo;
    function asString: string;
    function asPoints: string;
  end;

  TMatchTermine = procedure(match: TMatchFoo) of object;
  TMatchFoo = class(TComponent)
  private
    _gr: TGameResult;
    pvCnx: TLalConnection;
    _mtc: TZQuery;
    _jou,
    _hdc: TZReadOnlyQuery;
    _setsGagnants: byte;
    _handicap: boolean;
    _stacat: TCategorysStatus;
    FMatchTermine: TMatchTermine;
    FMatchTermineMessage: boolean;
    function getSertab: integer;
    function getProchain: string;
    function getNumtbl: string;
    function getSerjo1: integer;
    function getSerjo2: integer;
    procedure handicapGetText(Sender: TField; var Text: string; DisplayText: boolean);
    procedure nomjouGetText(Sender: TField; var Text: string; DisplayText: boolean);
    function analyzeSets(score: string): Boolean;
    function analyzeGames(score: string): boolean;
    procedure clearDetails;
    procedure setNumTbl(const Value: string);
    function getNomVainqueur: string;
    function getNomPerdant: string;
    procedure updateInsc(const serjou: integer; const statut: TRegistrationStatus);
    function getVainqueur: integer;
    function getVainqueurIndex: integer;
    procedure setAsUmpire(const nomjou: string; const numtbl: smallint);
    procedure setTableStatus(const numtbl: smallint; const sermtc: integer; const statuT: TPlayAreaStatus);
  public
    constructor Create(AOwner: TComponent; cnx: TLalConnection; const sermtc: integer); reintroduce; overload;
    destructor Destroy; override;
    procedure clear;
    procedure clearScores;
    function setWO(joueur: integer; wo: TWOResult): string;
    procedure resetWO;
    procedure editDataset;
    function writeBYE: boolean;
    function write: boolean;
    function analyzeScore(score: string; method: TScoreMethod): boolean;
    function getSerProchain: integer;
    function getHandicap(const cl1, cl2: string): TPoint;
    property Dataset: TZQuery read _mtc;
    property numtbl: string read getNumtbl write setNumTbl;
    property serjo1: integer read getSerjo1;
    property serjo2: integer read getSerjo2;
    property prochain: string read getProchain;
    property sertab: integer read getSertab;
    property gameResult: TGameResult read _gr write _gr;
    property setsGagnants: byte read _setsGagnants;
    property nomVainqueur: string read getNomVainqueur;
    property nomPerdant: string read getNomPerdant;
    property stacat: TCategorysStatus read _stacat;
    property vainqueur: integer read getVainqueur;
    property vainqueurIndex: integer read getVainqueurIndex;
    property matchTermine: TMatchTermine read FMatchTermine write FMatchTermine;
    property matchTermineMessage: boolean read FMatchTermineMessage write FMatchTermineMessage default True;
  end;

implementation

uses
  SysUtils, Math, Forms, lal_dbUtils;

function isDigit(const c: char): boolean;
const
  numbers: TSysCharSet = ['0','1','2','3','4','5','6','7','8','9'];
begin
  Result := CharInSet(c,numbers);
end;

{ TGameResult }

function TGameResult.asPoints: string;
var
  s: string;
  i,j: integer;
begin
  Result := '';
  if Assigned(match) then
  begin
    j := match.vainqueurIndex;
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

{ TMatch }

function TMatchFoo.analyzeSets(score: string): Boolean;
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
          _gr.score[ix] := points;
          s := '';
        end
        else
          Break;
      end;
    end;
    Delete(score,1,1);
    Application.ProcessMessages;
  end;
  if Length(s) > 0 then
  begin
    if TryStrToInt(s,points) then
    begin
      Inc(ix);
      if ix <= 2 then
        _gr.score[ix] := points;
    end;
  end;
  _gr.isOk := ((_gr.score[1] >= 0) and (_gr.score[2] >= 0)) and
              ((_gr.score[1] = setsGagnants) or (_gr.score[2] = setsGagnants)) and
              ((_gr.score[1] + _gr.score[2]) <= (setsGagnants + pred(setsGagnants)));
  _gr.withScoreDetail := False;
  if _gr.isOk then
  begin
    { update _mtc }
    editDataset;
    Dataset.FieldByName('score').AsString := Format('%d-%d',[_gr.score[1],_gr.score[2]]);
    if _gr.score[1] = setsGagnants then
    begin
      Dataset.FieldByName('vainqueur').AsInteger := Dataset.FieldByName('serjo1').AsInteger;
      Dataset.FieldByName('perdant').AsInteger := Dataset.FieldByName('serjo2').AsInteger;
    end
    else
    begin
      Dataset.FieldByName('vainqueur').AsInteger := Dataset.FieldByName('serjo2').AsInteger;
      Dataset.FieldByName('perdant').AsInteger := Dataset.FieldByName('serjo1').AsInteger;
    end;
    Dataset.FieldByName('stamtc').Value := gsOver;
  end;
  Result := _gr.isOk;
end;

procedure TMatchFoo.clear;
begin
  clearScores;
  clearDetails;
  editDataset;
  Dataset.FieldByName('vainqueur').Clear;
  Dataset.FieldByName('perdant').Clear;
  Dataset.FieldByName('woj1').Value := woNull;
  Dataset.FieldByName('woj2').Value := woNull;
  Dataset.FieldByName('games').Clear;
  Dataset.FieldByName('modifie').Clear;
  Dataset.FieldByName('stamtc').Value := gsInactive;
end;

procedure TMatchFoo.clearDetails;
var
  i: Integer;
begin
  for i := 1 to 7 do
  begin
    _gr.games[i].score[1] := 0;
    _gr.games[i].score[2] := 0;
    _gr.games[i].isOk     := False;
  end;
end;

procedure TMatchFoo.clearScores;
begin
  clearDetails;
  _gr.score[1] := 0;
  _gr.score[2] := 0;
  _gr.isOk := False;

end;

function TMatchFoo.analyzeGames(score: string): boolean;
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
    // 11.4,2.11, 11.0,12.10
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
        _gr.games[numset].score[joueur] := points;

        { mise à jour du score }
        if joueur = 2 then
        begin
          { contrôle de validité }
           pt1 := _gr.games[numset].score[1];
           pt2 := _gr.games[numset].score[2];
           _gr.games[numset].isOk := (((pt1 >= 11) and (pt2 <= pt1-2))or((pt2 >= 11) and (pt1 <= pt2-2)));
          if (_gr.games[numset].isOk) then
          begin
            if  (pt1 > pt2) then
              Inc(_gr.score[1])
            else
              Inc(_gr.score[2]);
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
    Application.ProcessMessages;
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
      _gr.games[numset].score[joueur] := points;
      { contrôle de validité }
       pt1 := _gr.games[numset].score[1];
       pt2 := _gr.games[numset].score[2];
       _gr.games[numset].isOk := (((pt1 >= 11) and (pt2 <= pt1-2))or((pt2 >= 11) and (pt1 <= pt2-2)));
      if (_gr.games[numset].isOk) then
      begin
        if  (pt1 > pt2) then
          Inc(_gr.score[1])
        else
          Inc(_gr.score[2]);
      end;
    end;
  end;
  _gr.isOk := ((_gr.score[1] >= 0) and (_gr.score[2] >= 0)) and
              ((_gr.score[1] = setsGagnants) or (_gr.score[2] = setsGagnants)) and
              ((_gr.score[1] + _gr.score[2]) <= (setsGagnants + pred(setsGagnants)));
  _gr.withScoreDetail := True;
  if _gr.isOk then
  begin
    { update _mtc }
    editDataset;
    Dataset.FieldByName('score').AsString := Format('%d-%d',[_gr.score[1],_gr.score[2]]);
    if _gr.score[1] = setsGagnants then
    begin
      Dataset.FieldByName('vainqueur').AsInteger := Dataset.FieldByName('serjo1').AsInteger;
      Dataset.FieldByName('perdant').AsInteger := Dataset.FieldByName('serjo2').AsInteger;
    end
    else
    begin
      Dataset.FieldByName('vainqueur').AsInteger := Dataset.FieldByName('serjo2').AsInteger;
      Dataset.FieldByName('perdant').AsInteger := Dataset.FieldByName('serjo1').AsInteger;
    end;
    Dataset.FieldByName('stamtc').Value := gsOver;
    Dataset.FieldByName('games').AsString := _gr.asString;
  end;
  Result := _gr.isOk;
end;

function TMatchFoo.analyzeScore(score: string; method: TScoreMethod): boolean;
begin
  Result := False;
  clearScores;
  case method of
    smGames: Result := analyzeGames(score);
    smSets:  Result := analyzeSets(score);
  end;
end;

constructor TMatchFoo.Create(AOwner: TComponent; cnx: TLalConnection; const sermtc: integer);
var
  i: integer;
begin
  inherited Create(AOwner);
  _gr.match := Self;
  pvCnx := cnx;
  _mtc := getQuery(pvCnx, Self);
  _mtc.SQL.Add('select sermtc,numseq,nummtc,serjo1,serjo2,handi1,handi2,score'
              +'  ,vainqueur,perdant,prochain,stamtc,a.sertab,a.numtbl,a.level'
              +'  ,woj1,woj2,games,modifie'
              +'  ,b.nomjou nomjo1,b.libclb libcl1,b.codcls codcl1'
              +'  ,c.nomjou nomjo2,c.libclb libcl2,c.codcls codcl2'
              +' from match a left outer join tablo b on a.sertab = b.sertab and a.serjo1 = b.serjou'
              +'              left outer join tablo c on a.sertab = c.sertab and a.serjo2 = c.serjou'
              +' where a.sermtc = :sermtc');
  _mtc.FieldDefs.Update;
  for i := 0 to Pred(_mtc.FieldDefs.Count) do
    _mtc.FieldDefs[i].CreateField(Self);
  _mtc.FieldByName('handi1').OnGetText := handicapGetText;
  _mtc.FieldByName('handi2').OnGetText := handicapGetText;
  _mtc.FieldByName('nomjo1').OnGetText := nomjouGetText;
  _mtc.FieldByName('nomjo2').OnGetText := nomjouGetText;
  _mtc.ParamByName('sermtc').AsInteger := sermtc;
  _mtc.Open;

  _jou := getROQuery(pvCnx, Self);
  _jou.SQL.Add('select numset,handicap from categories where sercat = ' + _mtc.FieldByName('sertab').AsString);
  _jou.Open;
  _setsGagnants := _jou.FieldByname('numset').AsInteger;
  _handicap := _jou.FieldByName('handicap').AsString = '1';
  _jou.Close;
  _jou.SQL.Clear;
  _jou.SQL.Add('select serjou,nomjou,codcls from joueur where serjou = :serjou');
  _jou.Prepare;

  _hdc := getROQuery(pvCnx,Self);
  _hdc.SQL.Add('select hdc from handicap where cl1 = :cl1 and cl2 = :cl2');
  _hdc.Prepare;
//  FMatchTermineMessage := True;
//  try
//    if Assigned(ArenaViewW) and (ArenaViewW.Visible) then
//      FMatchTermine := ArenaViewW.matchTermine;
//  except
//    FMatchTermine := nil;
//  end;
end;

destructor TMatchFoo.Destroy;
begin
  inherited;
end;

procedure TMatchFoo.editDataset;
begin
  if not(Dataset.State in dsEditModes) then
    Dataset.Edit;
end;

function TMatchFoo.getNomPerdant: string;
begin
  _jou.Close;
  _jou.ParamByName('serjou').AsInteger := Dataset.FieldByName('perdant').AsInteger;
  _jou.Open;
  Result := _jou.FieldByName('nomjou').AsString;
  _jou.Close;
end;

function TMatchFoo.getNomVainqueur: string;
begin
  _jou.Close;
  _jou.ParamByName('serjou').AsInteger := Dataset.FieldByName('vainqueur').AsInteger;
  _jou.Open;
  Result := _jou.FieldByName('nomjou').AsString;
  _jou.Close;
end;

function TMatchFoo.getNumtbl: string;
begin
  Result := _mtc.FieldByName('numtbl').AsString;
end;

function TMatchFoo.getProchain: string;
begin
  Result := _mtc.FieldByName('prochain').AsString;
end;

function TMatchFoo.getSerjo1: integer;
begin
  Result := _mtc.FieldByName('serjo1').AsInteger;
end;

function TMatchFoo.getSerjo2: integer;
begin
  Result := _mtc.FieldByName('serjo2').AsInteger;
end;

function TMatchFoo.getSertab: integer;
begin
  Result := _mtc.FieldByName('sertab').AsInteger;
end;

function TMatchFoo.getVainqueur: integer;
begin
  Result := Dataset.FieldByName('vainqueur').AsInteger;
end;

function TMatchFoo.getVainqueurIndex: integer;
begin
  if serjo1 = vainqueur then
    Result := 1
  else
    Result := 2;
end;

function TMatchFoo.getSerProchain: integer;
var
  prochain: string;
  level: integer;
  numseq: integer;
  z: TZReadOnlyQuery;
begin
  Result := 0;
  if Self.prochain = '' then
    Exit;
  prochain := Self.prochain;
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
    z.ParamByName('sertab').AsInteger := sertab;
    z.ParamByName('level').AsInteger := level;
    z.ParamByName('numseq').AsInteger := numseq;
    z.Open;
    Result := z.Fields[0].AsInteger;
    z.Close;
  finally
    z.Free;
  end;
end;

procedure TMatchFoo.handicapGetText(Sender: TField; var Text: string;
  DisplayText: boolean);
begin
  if Sender.AsInteger > 0 then
    Text := Format('+%d', [Sender.AsInteger]);
end;

procedure TMatchFoo.nomjouGetText(Sender: TField; var Text: string;
  DisplayText: boolean);
begin
  if Sender = Sender.DataSet.FieldByName('nomjo1') then
    Text := Format('%s - %s (%d)', [Sender.AsString,Sender.DataSet.FieldByName('libcl1').AsString,Sender.DataSet.FieldByName('serjo1').AsInteger])
  else if Sender = Sender.DataSet.FieldByName('nomjo2') then
    Text := Format('%s - %s (%d)', [Sender.AsString,Sender.DataSet.FieldByName('libcl2').AsString,Sender.DataSet.FieldByName('serjo2').AsInteger])
end;

procedure TMatchFoo.resetWO;
begin
  clear;
end;

function TMatchFoo.getHandicap(const cl1, cl2: string): TPoint;
begin
  Result.X := 0; Result.Y := 0;
  if cl1 >= cl2 then
  begin
    _hdc.ParamByName('cl1').AsString := cl1;
    _hdc.ParamByName('cl2').AsString := cl2;
  end
  else
  begin
    _hdc.ParamByName('cl2').AsString := cl1;
    _hdc.ParamByName('cl1').AsString := cl2;
  end;
  _hdc.Open;
  if cl1 >= cl2 then
  begin
    Result.X := _hdc.FieldByName('hdc').AsInteger;
    Result.Y := 0;
  end
  else
  begin
    Result.Y := _hdc.FieldByName('hdc').AsInteger;
    Result.x := 0;
  end;
  _hdc.Close;
end;

procedure TMatchFoo.setAsUmpire(const nomjou: string; const numtbl: smallint);
begin
  with getROQuery(pvCnx) do
  begin
    try
      SQL.Add('update umpires'
             +' set umpire = ' + nomjou.QuotedString
             +' where numtbl = ' + numtbl.ToString);
      ExecSQL;
    finally
      Free;
    end;
  end;
end;

procedure TMatchFoo.setNumTbl(const Value: string);
begin
  editDataset;
  Dataset.FieldByName('numtbl').AsString := Value;
end;

procedure TMatchFoo.setTableStatus(const numtbl: smallint; const sermtc: integer;
  const statuT: TPlayAreaStatus);
begin
  with getROQuery(pvCnx) do
  begin
    try
      SQL.Add('update umpires set statbl = ' + Ord(statuT).ToString
             +'   ,sermtc = ' + sermtc.ToString
             +' where numtbl = ' + numtbl.ToString);
      ExecSQL;
    finally
      Free;
    end;
  end;
end;

function TMatchFoo.setWO(joueur: integer; wo: TWOResult): string;
const
  statut: array[boolean] of TRegistrationStatus = (rsDisqualified,rsWO);
begin
  Result := '';
  clearScores;
  editDataset;
  _gr.score[joueur] := 0;
  Dataset.FieldByName(Format('woj%d',[joueur])).Value := wo;
  Dataset.FieldByName('perdant').AsInteger := Dataset.FieldByName(Format('serjo%d',[joueur])).AsInteger;
  if joueur = 1 then
    Inc(joueur) else Dec(joueur);
  _gr.score[joueur] := 0;
  Dataset.FieldByName('vainqueur').AsInteger := Dataset.FieldByName(Format('serjo%d',[joueur])).AsInteger;
  Dataset.FieldByName(Format('woj%d',[joueur])).Value := woWin;
  Dataset.FieldByName('stamtc').Value := gsOver;
  _gr.isOk := True;
  _jou.ParamByName('serjou').AsInteger := _mtc.FieldByName(Format('serjo%d',[joueur])).AsInteger;
  _jou.Open;
  Result := _jou.FieldByName('nomjou').AsString;
  _jou.Close;
  Dataset.FieldByName('score').AsString := 'WO';
end;

procedure TMatchFoo.updateInsc(const serjou: integer; const statut: TRegistrationStatus);
var
  serinsc: integer;
begin
  with getROQuery(pvCnx) do
  begin
    try
      SQL.Add('select serinsc from insc where serjou = :serjou and sercat = :sercat');
      ParamByName('serjou').AsInteger := serjou;
      ParamByName('sercat').AsInteger := sertab;
      Open;
      serinsc := Fields[0].AsInteger;
      Close;
      SQL.Clear;
      SQL.Add('update insc set statut = :statut where serinsc = :serinsc');
      ParamByName('statut').Value := statut;
      ParamByName('serinsc').AsInteger := serinsc;
      ExecSQL;
    finally
      Free;
    end;
  end;
end;

function TMatchFoo.write: boolean;
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
    if _gr.isOk then
    begin
      editDataset;
      Dataset.FieldByName('modifie').Value := Now;
      goto write;
    end
    else
    begin
      if Trim(Dataset.FieldByName('numtbl').AsString) <> '' then
      begin
        with getROQuery(pvCnx) do
        begin
          SQL.Add('update match set numtbl = :numtbl'
                 +'  ,stamtc = :stamtc'
                 +' where sermtc = :sermtc');
          ParamByName('numtbl').AsString := Trim(Dataset.FieldByName('numtbl').AsString);
          ParamByName('stamtc').Value := gsInProgress;
          ParamByName('sermtc').AsInteger := Dataset.FieldByName('sermtc').AsInteger;
          ExecSQL;
          Result := True;
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
    editDataset;
    Dataset.FieldByName('stamtc').Value := gsOver;
    goto write;
  end;

write:
  z := getROQuery(pvCnx);
  try
    z.SQL.Add('update match'
             +'   set score = :score'
             +'      ,vainqueur = :vainqueur'
             +'      ,perdant = :perdant'
             +'      ,numtbl = :numtbl'
             +'      ,stamtc = :stamtc'
             +'      ,games = :games'
             +'      ,woj1 = :woj1'
             +'      ,woj2 = :woj2'
             +'      ,modifie = :modifie'
             +' where sermtc = :sermtc');
    for i := 0 to Pred(z.Params.Count) do
      if Dataset.FindField(z.Params[i].Name) <> nil then
        z.Params[i].Value := Dataset.FieldByName(z.Params[i].Name).Value;
    z.ParamByName('games').AsString := _gr.asString;
    pvCnx.startTransaction;
    try
      z.ExecSQL;
      if (serjo1 > 0) and (serjo2 > 0) and (_gr.isOk) then
      begin
        setAsUmpire(nomPerdant,Dataset.FieldByName('numtbl').AsInteger);
        setTableStatus(Dataset.FieldByName('numtbl').AsInteger, 0, pasAvailable);
      end;
        { c'est le lancement de la categorie dans la fenêtre arena qui modifie
          le statut de la categorie en scEnCours }
//      if _stacat <> scEnCours then
//      begin
//        _stacat := scEnCours;
//        if z.Active then
//          z.Close;
//        z.SQL.Clear;
//        z.SQL.Add('update categories set stacat = :stacat'
//                 +' where sercat = :sercat');
//        z.ParamByName('stacat').Value := _stacat;
//        z.ParamByName('sercat').AsInteger := sertab;
//        z.ExecSQL;
//      end;

      updateInsc(Dataset.FieldByName('vainqueur').AsInteger,rsQualified);
      if (Dataset.FieldByName('score').AsString <> 'WO') or (Dataset.FieldByName('level').AsInteger > 2) then
        updateInsc(Dataset.FieldByName('perdant').AsInteger,rsDisqualified)
      else
        updateInsc(Dataset.FieldByName('perdant').AsInteger,rsWO);
//      updateInsc(Dataset.FieldByName('vainqueur').AsInteger,isQualifie);
//      updateInsc(Dataset.FieldByName('perdant').AsInteger,isElimine);
      { maj du prochain match }
      i := getSerProchain;
      if i > 0 then
      begin
        z.SQL.Clear;
        if not _mtc.Active then
          Exit;
        cl1 := _mtc.FieldByName('prochain').AsString;
        j := Length(cl1);
        j := StrToInt(Copy(cl1,j,1));
        z.SQL.Add('update match'
                 +Format('   set serjo%d = :serjou',[j])
                 +' where sermtc = :sermtc');
        z.ParamByName('serjou').AsInteger := Dataset.FieldByName('vainqueur').AsInteger;
        z.ParamByName('sermtc').AsInteger := i;
        z.ExecSQL;
        { si tableau handicap et 2 joueurs présents, maj handi1 et handi2 }
        if _handicap then
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
      end
      else
      begin
        // la finale a été jouée, maj du statut de la catégorie
        if z.Active then
          z.Close;
        z.SQL.Clear;
        z.SQL.Add('update categories set stacat = :stacat'
                 +' where sercat = :sercat');
        z.ParamByName('stacat').Value := csOver;
        z.ParamByName('sercat').AsInteger := sertab;
        z.ExecSQL;
        _stacat := csOver;
      end;
      pvCnx.commit;

      if matchTermineMessage and Assigned(FMatchTermine) then FMatchTermine(Self);
    except
      pvCnx.rollback;
      raise;
    end;
    Result := True;
  finally
    z.Free;
  end;
end;

function TMatchFoo.writeBYE: boolean;
begin
  editDataset;
  if (serjo1 > 0) and (serjo2 = 0) then
    Dataset.FieldByName('vainqueur').AsInteger := serjo1
  else
    Dataset.FieldByName('vainqueur').AsInteger := serjo2;
  Dataset.FieldByName('perdant').Clear;
  Dataset.FieldByName('score').Value := 'BYE';
  Dataset.FieldByName('games').Clear;
  Dataset.FieldByName('stamtc').Value := gsOver;
  Result := True;
end;

end.
