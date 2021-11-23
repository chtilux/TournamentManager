unit tmUtils;

interface

uses
  Classes, lal_connection, ZConnection, System.Contnrs, System.Types,
  lal_sequence, ZDataset, DB, dataWindow, Generics.Collections, Graphics;

//type
//  TTournoi = class(TPersistent)
//  private
//    FSerTrn: integer;
//  public
//    procedure Assign(Source: TPersistent); override;
//    property sertrn: integer read FSerTrn write FSerTrn;
//  end;
//
//  TLevel = smallint;
//  TCategory = class(TTournoi)
//  private
//    Fsercat: integer;
//    Fhandicap: boolean;
//    Fcodcat: string;
//    Fnumset: smallint;
//    Fsimple: boolean;
//    Fheudeb: string;
//    FNumInsc,
//    FPlayedGames,
//    FRemainingGames,
//    FLevel: smallint;
//    FLevels: smallint;
//    procedure Setsercat(const Value: integer);
//    procedure Setcodcat(const Value: string);
//    procedure Sethandicap(const Value: boolean);
//    procedure Setheudeb(const Value: string);
//    procedure Setnumset(const Value: smallint);
//    procedure Setsimple(const Value: boolean);
//
//  public
//    procedure Assign(Source: TPersistent); override;
//    property sercat: integer read Fsercat write Setsercat;
//    property codcat: string read Fcodcat write Setcodcat;
//    property heudeb: string read Fheudeb write Setheudeb;
//    property simple: boolean read Fsimple write Setsimple;
//    property handicap: boolean read Fhandicap write Sethandicap;
//    property numset: smallint read Fnumset write Setnumset;
//    property numinsc: smallint read FNumInsc write FNumInsc;
//    property playedGames: smallint read FPlayedGames write FPlayedGames;
//    property remainingGames: smallint read FRemainingGames write FRemainingGames;
//    property level: smallint read FLevel write FLevel;
//    property levels: smallint read FLevels write FLevels;
//  end;
//
//  TCategoryHelper = class helper for TCategory
//    function levelAsString: string;
//  end;
//
//  TCategoryList = class(TList<TCategory>)
//  public
//    class function getCategorysObject: TCategory;
//  end;



//  TPingTable = class(TPersistent)
//  private
//    FNumber: smallint;
//    FStatut: TStatutTable;
//  public
//    procedure Assign(Source: TPersistent); override;
//    property number: smallint read FNumber write FNumber;
//    property statut: TStatutTable read FStatut write FStatut;
//  end;
//
//  TJoueur = class(TPersistent)
//  public
//    nom,
//    club,
//    classement: string;
//    handicap: smallint;
//    procedure Assign(Source: TPersistent); override;
//  end;
//  TJoueurs = array[1..2] of TJoueur;
//  TPingMatch = class(TPersistent)
//  private
//    FLevel: smallint;
//    FJoueurs: TJoueurs;
//    FSermtc: integer;
//    FScore: string;
//    FCateg: TCategory;
//    FEndTime: string;
//    FStatutMatch: TStatutMatch;
//    FBeginTime: string;
//    FTable: TPingTable;
//    FMagic: integer;
//    FToTableNumber: integer;
//    FLoser: string;
//    FRefresh: boolean;
//    FWinner: string;
//    function getJoueur(const index: integer): TJoueur;
//    procedure SetJoueur(const index: integer; const Value: TJoueur);
//  public
//    constructor Create;
//    destructor Destroy; override;
//    procedure Assign(Source: TPersistent); override;
//    //function asString: string;
//    property table: TPingTable read FTable write FTable;
//    property sermtc: integer read FSermtc write FSermtc;
//    property categ: TCategory read FCateg write FCateg;
//    property level: smallint read FLevel write FLevel;
//    property beginTime: string read FBeginTime write FBeginTime;
//    property endTime: string read FEndTime write FEndTime;
//    property joueurs[const index: integer]: TJoueur read getJoueur write SetJoueur; default;
//    property score: string read FScore write FScore;
//    property status: TStatutMatch read FStatutMatch write FStatutMatch default smInactif;
//    property toTableNumber: integer read FToTableNumber write FToTableNumber;
//    property magic: integer read FMagic write FMagic;
//    property Loser: string read FLoser write FLoser;
//    property Winner: string read FWinner write FWinner;
//    property refresh: boolean read FRefresh write FRefresh default True;
//  end;

{: set local variable _Cnx }
//procedure setDatabaseLocalConnection(const Value: TLalConnection);

implementation

uses
  SysUtils, lal_dbUtils, dateUtils, Dialogs, Controls, System.UITypes,
  Math, Forms, u_pro_excel, Winapi.Windows, match, excel_tlb, u_pro_strings;

type

  TInscStatut = (isElimine,isQualifie,isWO);
  TWOResult = (woNull,woPerdu,woGagne);
  TScoreMethod = (smGames,smSets);

  TStatutMatch = (smInactif,smEnCours,smTermine);
  TStatutCategorie = (scInactive,scPreparee,scTablo,scMatch,scEnCours,scTerminee);
  TStatutTable = (ttInactive,ttLibre,ttOccupee);
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

var
  lcCnx: TLalConnection;

const
  clInscStatut: array[TInscStatut] of TColor = (clSilver,clYellow,$00DDBBFF);

procedure setDatabaseLocalConnection(const Value: TLalConnection);
begin
  lcCnx := Value;
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

//procedure getInterval(itv: TStrings; bornes: TPoint; hautBas,seqcls,taille: smallint; const sertab: integer);
//var
//  z: TZReadOnlyQuery;
//begin
//  itv.Clear;
//  z := getROQuery(lcCnx);
//  try
//    z.SQL.Add('select serblo,numtds,numrow from tablo'
//             +' where numrow between :bas and :haut'
//             +'   and numtds between :low and :high'
//             +'   and sertab = :sertab'
//             +' order by numrow');
//    z.ParamByName('sertab').AsInteger := sertab;
//    if hautBas = 0 then
//    begin
//      z.ParamByName('bas').AsInteger := 1;
//      z.ParamByName('haut').AsInteger := taille div 2;
//    end
//    else
//    begin
//      z.ParamByName('bas').AsInteger := Succ(taille div 2);
//      z.ParamByName('haut').AsInteger := taille;
//    end;
//    z.Open;
//    while not z.Eof do
//    begin
//      itv.Add(z.FieldByName('numrow').AsString);
//      z.Next;
//      Application.ProcessMessages;
//    end;
//    z.Close;
//  finally
//    z.Free;
//  end;
//end;

//procedure deleteTournament(const sertrn: integer);
//var
//  z: TZReadOnlyQuery;
//begin
//  z := getROQuery(lcCnx);
//  try
//    Screen.Cursor := crSQLWait;
//    lcCnx.startTransaction;
//    try
//      z.SQL.Clear;
//      z.SQL.Add(Format('delete from %s where sertrn = %d',['categories',sertrn]));
//      z.ExecSQL;
//      z.SQL.Clear;
//      z.SQL.Add(Format('delete from %s where sertrn = %d',['classements',sertrn]));
//      z.ExecSQL;
//      z.SQL.Clear;
//      z.SQL.Add(Format('delete from %s where sertrn = %d',['insc',sertrn]));
//      z.ExecSQL;
//      z.SQL.Clear;
//      z.SQL.Add(Format('delete from %s where sertrn = %d',['match',sertrn]));
//      z.ExecSQL;
//      z.SQL.Clear;
//      z.SQL.Add(Format('delete from %s where sertrn = %d',['prptab',sertrn]));
//      z.ExecSQL;
//      z.SQL.Clear;
//      z.SQL.Add(Format('delete from %s where sertrn = %d',['tableau',sertrn]));
//      z.ExecSQL;
//      z.SQL.Clear;
//      z.SQL.Add(Format('delete from %s where sertrn = %d',['tablo',sertrn]));
//      z.ExecSQL;
//      z.SQL.Clear;
//      z.SQL.Add(Format('delete from %s where sertrn = %d',['tournoi',sertrn]));
//      z.ExecSQL;
//      lcCnx.commit;
//    except
//      lcCnx.rollback;
//      raise;
//    end;
//  finally
//    z.Free;
//    Screen.Cursor := crDefault;
//  end;
//end;

//function generateMatches(const sercat: integer): boolean;
//  function getHandicap(hdc: TZReadOnlyQuery; const cl1, cl2: string): TPoint;
//  begin
//    FillChar(Result,sizeof(TPoint),0);
//    if assigned(hdc) then
//    begin
//      if cl1 >= cl2 then
//      begin
//        hdc.ParamByName('cl1').AsString := cl1;
//        hdc.ParamByName('cl2').AsString := cl2;
//      end
//      else
//      begin
//        hdc.ParamByName('cl2').AsString := cl1;
//        hdc.ParamByName('cl1').AsString := cl2;
//      end;
//      hdc.Open;
//      if cl1 >= cl2 then
//      begin
//        Result.X := hdc.FieldByName('hdc').AsInteger;
//        Result.Y := 0;
//      end
//      else
//      begin
//        Result.Y := hdc.FieldByName('hdc').AsInteger;
//        Result.x := 0;
//      end;
//      hdc.Close;
//    end;
//  end;
//var
//  contnr: TObjectList;
//  tablo,
//  ins,
//  w,
//  hdc,
//  x: TZReadOnlyQuery;
//  i,level,numseq,sertrn,j,prochain: integer;
//  codcls: string;
//  hdcp: TPoint;
//  rm: TRoundingMode;
//begin
//  Result := False;
//  rm := GetRoundMode;
//  contnr := TObjectList.Create(False);
//  try
//    tablo := getROQuery(lcCnx, contnr);
//    tablo.SQL.Add('select count( * ) from match where sertab = :sertab');
//    tablo.ParamByName('sertab').AsInteger := sercat;
//    tablo.Open;
//    if tablo.Fields[0].AsInteger > 0 then
//    begin
//      if MessageDlg('Les matchs du tableau ont déjà été générés. Faut-il recommencer ?',
//                    mtConfirmation, [mbYes,mbNo], 0) = mrNo then
//      begin
//        tablo.Close;
//        Exit;
//      end
//      else
//      begin
//        tablo.SQL.Clear;
//        tablo.SQL.Add('delete from match where sertab = :sertab');
//        tablo.ParamByName('sertab').AsInteger := sercat;
//        tablo.ExecSQL;
//      end;
//    end;
//
//    tablo.SQL.Clear;
//    tablo.SQL.Add('select sertrn from categories where sercat = :sercat');
//    tablo.ParamByName('sercat').AsInteger := sercat;
//    tablo.Open;
//    sertrn := tablo.Fields[0].AsInteger;
//    tablo.Close;
//    tablo.SQL.Clear;
//    tablo.SQL.Add('select serjou,numrow,codcls'
//                 +' from tablo'
//                 +' where sertab = :sertab'
//                 +' order by numrow');
//    tablo.ParamByName('sertab').AsInteger := sercat;
//
//    ins := getROQuery(lcCnx, contnr);
//    ins.SQL.Add('insert into match (sermtc,sertab,level,numseq,nummtc'
//               +'  ,serjo1,serjo2,handi1,handi2,stamtc,sertrn,prochain)'
//               +' values (:sermtc,:sertab,:level,:numseq,:nummtc'
//               +'  ,:serjo1,:serjo2,:handi1,:handi2,:stamtc,:sertrn,:prochain)');
//    ins.Prepare;
//    ins.ParamByName('sertab').AsInteger := sercat;
//    ins.ParamByName('level').AsInteger  := 1;
//    ins.ParamByName('stamtc').AsString := '0';
//    ins.ParamByName('sertrn').AsInteger := sertrn;
//
//    w := getROQuery(lcCnx, contnr);
//    w.SQL.Add('select codcat,simple,handicap,numset,catage'
//               +' from categories'
//               +' where sercat = :sercat');
//    w.ParamByName('sercat').AsInteger := sercat;
//    w.Open;
//    if w.FieldByName('handicap').AsString = '1' then
//    begin
//      hdc := getROQuery(lcCnx,contnr);
//      hdc.SQL.Add('select hdc from handicap where cl1 = :cl1 and cl2 = :cl2');
//      hdc.Prepare;
//    end
//    else
//      hdc := nil;
//    w.Close;
//
//    tablo.Open;
//    numseq := 0;
//    level := 1;
//    prochain := 0;
//    setRoundMode(rmUp);
//    { les matchs du premier tour sont générés (level 1) }
//    while not tablo.Eof do
//    begin
//      Inc(numseq);
//      ins.ParamByName('sermtc').AsInteger := _seq.SerialByName('categorie');
//      ins.ParamByName('numseq').AsInteger := numseq;
//      ins.ParamByName('nummtc').AsString := Format('%d.%.3d',[level,numseq]);
//      ins.ParamByName('serjo1').AsInteger := tablo.FieldByName('serjou').AsInteger;
//      Inc(prochain);
//      if prochain = 3 then
//        prochain := 1;
//      j := Round(numseq / 2);
//      if j = 0 then
//        j := 1;
//      ins.ParamByName('prochain').AsString := Format('%d.%.3d/%d',[Succ(level),j,prochain]);
//      codcls := tablo.FieldByName('codcls').AsString;
//      tablo.Next;
//      ins.ParamByName('serjo2').AsInteger := tablo.FieldByName('serjou').AsInteger;
//      hdcp := getHandicap(hdc,codcls,tablo.FieldByName('codcls').AsString);
//      ins.ParamByName('handi1').AsInteger := hdcp.X;
//      ins.ParamByName('handi2').AsInteger := hdcp.Y;
//      ins.ExecSQL;
//      tablo.Next;
//      Application.ProcessMessages;
//    end;
//    tablo.Close;
//
//    tablo.SQL.Clear;
//    tablo.SQL.Add('select sermtc,numseq,serjo1,serjo2'
//                 +' from match'
//                 +' where sertab = :sertab'
//                 +'   and level = :level'
//                 +' order by prochain,numseq');
//    tablo.Prepare;
//    tablo.ParamByName('sertab').AsInteger := sercat;
//
//    x := getROQuery(lcCnx,contnr);
//    x.SQL.Add('select codcls from tablo where sertab = :sertab'
//             +'   and serjou = :serjou');
//    x.Prepare;
//    w.SQL.Clear;
//    w.SQL.Add('select count( * ) from match'
//             +' where sertab = :sertab'
//             +'   and level = :level');
//    w.Prepare;
//    w.ParamByName('sertab').AsInteger := sercat;
//    w.ParamByName('level').AsInteger := level;
//    w.Open;
//    ins.ParamByName('sertab').AsInteger := sercat;
//    ins.ParamByName('handi1').Clear;
//    ins.ParamByName('handi2').Clear;
//    ins.ParamByName('stamtc').AsInteger := 0;
//    ins.ParamByName('sertrn').AsInteger := sertrn;
//    if w.Fields[0].AsInteger > 0 then
//    begin
//      repeat
//        Inc(level);
//        { create matches for level }
//        tablo.ParamByName('level').AsInteger := Pred(level);
//        tablo.Open;
//        ins.ParamByName('level').AsInteger := level;
//        ins.ParamByName('serjo1').AsInteger := 0;
//        ins.ParamByName('serjo2').AsInteger := 0;
//        numseq := 0;
//        prochain := 0;
//        while not tablo.Eof do
//        begin
//          Inc(numseq);
//          ins.ParamByName('sermtc').AsInteger := _seq.SerialByName('categorie');
//          ins.ParamByName('numseq').AsInteger := numseq;
//          ins.ParamByName('nummtc').AsString := Format('%d.%.3d',[level,numseq]);
//          Inc(prochain);
//          if prochain = 3 then
//            prochain := 1;
//          j := Round(numseq / 2);
//          if j = 0 then j := 1;
//          if tablo.RecordCount > 2 then
//            ins.ParamByName('prochain').AsString := Format('%d.%.3d/%d',[Succ(level),j,prochain])
//          else
//            ins.ParamByName('prochain').Clear;
//          { second joueur du prochain match }
//          tablo.Next;
//          ins.ExecSQL;
//          tablo.Next;
//          Application.ProcessMessages;
//        end;
//        tablo.Close;
//        {==========================}
//        w.Close;
//        w.ParamByName('level').AsInteger := level;
//        w.Open;
//        Application.ProcessMessages;
//      until w.Fields[0].AsInteger = 1;
//    end;
//    Result := True;
//  finally
//    SetRoundMode(rm);
//    for i := 0 to Pred(contnr.Count) do
//      TZReadOnlyQuery(contnr[i]).Free;
//    contnr.Free;
//  end;
//end;

//procedure tablo2excel(const sertab: integer; const score,complet: boolean);
//var
//  xls,
//  wkb,
//  sht: variant;
//  z: TZReadOnlyQuery;
//  row,taille: integer;
//  template,
//  ext,j1,j2: string;
//begin
//  z := getROQuery(lcCnx);
//  try
//    z.SQL.Add('select a.dattrn,a.organisateur,a.libelle,b.codcat'
//             +'  ,c.taille,c.nbrjou'
//             +' from tournoi a, categories b, tableau c'
//             +' where a.sertrn = b.sertrn'
//             +'   and b.sercat = c.sertab'
//             +'   and c.sertab = :sertab');
//    z.ParamByName('sertab').AsInteger := sertab;
//    z.Open;
//    taille := z.FieldByName('taille').AsInteger;
//    template := getSettingsValue('excelTemplate');
//    ext := ExtractFileExt(template);
//    row := Pos('xxx',template,1);
//    template := Copy(template,1,Pred(row));
//    template := template + z.FieldByName('taille').AsString+ext;
//    if not fileExists(template) then
//      createExcelWorkbook(xls,wkb,sht,True,Format('c:\ping\docs\modèles\modTableau%d.xltx',[taille]))
//    else
//      createExcelWorkbook(xls,wkb,sht,True,template);
//
//    { onglet tableau du fichier excel }
//    sht := wkb.Worksheets['tableau'];
//    sht.Select;
//    sht.Cells[1,2] := FormatDateTime('dddd dd mmmm yyyy', z.FieldByName('dattrn').AsDateTime);
//    sht.Cells[2,2] := z.FieldByName('libelle').AsString;
//    sht.Cells[3,2] := z.FieldByName('codcat').AsString;
//    sht.Cells[4,2] := Format('%d participants',[z.FieldByName('nbrjou').AsInteger]);
//    z.Close;
//    z.SQL.Clear;
//    z.SQL.Add('SELECT codcls,count(*) FROM tablo WHERE sertab = :sertab'
//             +' AND serjou > 0 GROUP BY 1 ORDER BY 1');
//    z.ParamByName('sertab').AsInteger := sertab;
//    z.Open;
//    sht.Cells[5,1] := 'dont';
//    sht.cells[5,2] := Format('%d %s',[z.Fields[1].AsInteger,z.Fields[0].AsString]);
//    z.Close;
//
//    { positions }
//    sht := wkb.Worksheets['position'];
//    sht.Select;
//    row := 2;
//    z.SQL.Clear;
//    z.SQL.Add('select serblo,sertab,serjou,licence,nomjou,codclb,libclb,codcls,numtds,numrow,sertrn'
//             +' from tablo'
//             +' where sertab = :sertab'
//             +'   and coalesce(serjou,0) > 0'
//             +' order by numtds');
//    z.ParamByName('sertab').AsInteger := sertab;
//    z.Open;
//    while not z.Eof  do
//    begin
//      Inc(row);
//      if z.FieldByName('nomjou').AsString <> 'BYE' then
//      begin
//        sht.Cells[row,3] := z.FieldByName('libclb').AsString;
//        sht.Cells[row,4] := z.FieldByName('licence').AsString;
//        sht.Cells[row,5] := z.FieldByName('nomjou').AsString;
//        sht.Cells[row,6] := z.FieldByName('codcls').AsString;
//        sht.Cells[row,8] := z.FieldByName('numrow').AsString;
//      end;
//      z.Next;
//      Application.ProcessMessages;
//    end;
//
//    { exempts du 1er tour }
//    sht := wkb.Worksheets['tablo'];
//    sht.Select;
//    row := 4;
//    repeat
//      j1 := sht.Cells[Pred(row),2];
//      j2 := sht.Cells[Succ(row),2];
//      if (j1<>'') and (j2='') then
//        sht.Cells[row,3] := 'w'
//      else if (j1='') and (j2<>'') then
//        sht.Cells[Succ(row),3] := 'w';
//      Inc(row,4);
//    until (row > Succ(taille*2));
//
//    z.Close;
//    z.SQL.Clear;
//    z.SQL.Add('select COUNT( * ) from match'
//             +' where sertab = :sertab'
//             +'   and stamtc = :stamtc');
//    z.ParamByName('sertab').AsInteger := sertab;
//    z.ParamByName('stamtc').Value := smTermine;
//    z.Open;
//    matchs2excel(sertab,wkb,score,complet);
//    z.Close;
//  finally
//    z.Free;
//  end;
//end;
//
//procedure matchs2excel(const sertab: integer; const book: Variant; const score,complet: boolean);
//var
//  z: TZReadOnlyQuery;
//  row,col,level,numseq,sertrn: integer;
//  sht,rng: Variant;
//  dir,filename: string;
//begin
//  z := getROQuery(lcCnx);
//  try
//    z.SQL.Add('select sertrn from tableau where sertab = :sertab');
//    z.Params[0].AsInteger := sertab;
//    z.Open;
//    sertrn := z.Fields[0].AsInteger;
//    z.Close;
//    z.SQL.Clear;
//    z.SQL.Add('select nummtc'
//             +'  ,(select licence from tablo x where x.sertab = a.sertab and x.serjou = a.serjo1) "lic 1"'
//             +'  ,(select licence from tablo x where x.sertab = a.sertab and x.serjou = a.serjo2) "lic 2"'
//             +'  ,(select nomjou from tablo x where x.sertab = a.sertab and x.serjou = a.serjo1) "joueur 1"'
//             +'  ,(select nomjou from tablo x where x.sertab = a.sertab and x.serjou = a.serjo2) "joueur 2"'
//             +'  ,(select codcls from tablo x where x.sertab = a.sertab and x.serjou = a.serjo1) "cls 1"'
//             +'  ,(select codcls from tablo x where x.sertab = a.sertab and x.serjou = a.serjo2) "cls 2"'
//             +'  ,(select libclb from tablo x where x.sertab = a.sertab and x.serjou = a.serjo1) "club 1"'
//             +'  ,(select libclb from tablo x where x.sertab = a.sertab and x.serjou = a.serjo2) "club 2"'
//             +'  ,score,games'
//             +' from match a, tablo b'
//             +' where a.sertab = b.sertab'
//             +'   and a.sertab =:sertab'
//             +'   and a.vainqueur = b.serjou'
//             +'   and a.perdant > 0'
//             +' order by nummtc');
//    z.ParamByName('sertab').AsInteger := sertab;
//    z.Open;
//    if not z.IsEmpty then
//    begin
//      if complet then
//      begin
//        { liste des matchs }
//        row := 1;
//        sht := book.Worksheets.Add;
//        sht.Name := 'Matchs';
//        sht.Select;
//        sht.Cells[row,1] := 'Match n°';
//        sht.Cells[row,2] := 'Joueur 1';
//        sht.Cells[row,3] := 'Joueur 2';
//        sht.Cells[row,4] := 'Score';
//        sht.Cells[row,5] := 'Sets';
//        while not z.Eof do
//        begin
//          Inc(row);
//          sht.Cells[row,1] := Format('''%s',[z.FieldByName('nummtc').AsString]);
//          if not complet then
//          begin
//            sht.Cells[row,2] := z.FieldByName('joueur 1').AsString;
//            sht.Cells[row,3] := z.FieldByName('joueur 2').AsString;
//          end
//          else
//          begin
//            sht.Cells[row,2] := Format('%s - %s - %s - %s',[z.FieldByName('lic 1').AsString,z.FieldByName('joueur 1').AsString,z.FieldByName('cls 1').AsString,z.FieldByName('club 1').AsString]);
//            sht.Cells[row,3] := Format('%s - %s - %s - %s',[z.FieldByName('lic 2').AsString,z.FieldByName('joueur 2').AsString,z.FieldByName('cls 2').AsString,z.FieldByName('club 2').AsString]);
//          end;
//          sht.Cells[row,4] := Format('''%s',[z.FieldByName('score').AsString]);
//          sht.Cells[row,5] := Format('''%s',[z.FieldByName('games').AsString]);
//          z.Next;
//          Application.ProcessMessages;
//        end;
//        rng := sht.Range[Format('A1:E%d',[row])];
//        makeTableau(sht,rng,'matchs');
//        autoSizeWorksheetColumns(sht);
//      end;
//      { inscription des scores dans le tablo }
//      sht := book.Worksheets['tablo'];
//      sht.Select;
//      row := 1;
//      col := 1;
//      z.SQL.Clear;
//
//      z.SQL.Add('select level,numseq,score,games'
//               +'   ,licence,nomjou,codcls,libclb,serjo1,serjo2'
//               +' from match a, tablo b'
//               +' where a.sertab = b.sertab'
//               +'   and a.sertab = :sertab'
//               +'   and a.vainqueur = b.serjou'
//               +' order by nummtc');
//      z.parambyname('sertab').asinteger := sertab;
//      z.Open;
//      while not z.Eof do
//      begin
//        level := z.FieldByName('level').AsInteger;
//        numseq := z.FieldByName('numseq').AsInteger;
//        col := 2 * Pred(level) + 4;
//        //2+(POWER(2;Q$1))+1+($P2-1)*POWER(2;Q$1+1)
//        row := Trunc(2 + (Power(2,level))+1+Pred(numseq)*Power(2,Succ(level)));
//
//        if not complet then
//          sht.Cells[Pred(row), col] := z.FieldByName('nomjou').AsString
//        else
//          sht.Cells[Pred(row), col] := Format('%s - %s - %s - %s',[z.FieldByName('licence').AsString,z.FieldByName('nomjou').AsString,z.FieldByName('codcls').AsString,z.FieldByName('libclb').AsString]);
//
//        if score then
//        begin
//          if z.FieldByName('score').AsString <> 'WO' then
//          begin
//            if z.FieldByName('games').AsString <> '' then
//              sht.Cells[row, col] := Format('''%s',[z.FieldByName('games').AsString])
//            else
//              sht.Cells[row, col] := Format('''%s',[z.FieldByName('score').AsString]);
//          end
//          else
//          begin
//            sht.Cells[row, col] := Format('''%s',[z.FieldByName('score').AsString]);
//            rng := sht.Cells[row, col];
//            rng.Interior.Color := clLime;
//          end;
//        end;
//        z.Next;
//        Application.ProcessMessages;
//      end;
//    end;
//    z.Close;
//
//    { 4 premiers dans l'onglet tableau }
//    if complet or True then
//    begin
//      sht := book.Worksheets['tableau'];
//      sht.Select;
//      { le tableau est en C6, la place de premier en C7 }
//      row := 7;
//      col := 3;
//      z.SQL.Clear;
//      z.SQL.Add('select vainqueur from match where sertab = :sertab'
//               +'  and prochain is null');
//      z.ParamByName('sertab').AsInteger := sertab;
//      z.Open;
//      if not z.IsEmpty then
//      begin
//        z.Close;
//        z.SQL.Clear;
//        { premier }
////        z.SQL.Add('select licence||''-''||nomjou||'' [''||codcls||''] ''||libclb'
//        z.SQL.Add('select nomjou||'', ''||codcls||'', ''||libclb'
//                 +'   ,level'
//                 +' from match a, tablo b'
//                 +' where a.sertab = :sertab'
//                 +'   and a.level = (select max(level) from match x where x.sertab = a.sertab)'
//                 +'   and a.sertab = b.sertab'
//                 +'   and a.vainqueur = b.serjou');
//        z.ParamByName('sertab').AsInteger := sertab;
//        z.Open;
//        level := z.FieldByName('level').AsInteger;
//        sht.Cells[row,col] := z.Fields[0].AsString;
//        z.Close;
//        z.SQL.Clear;
//        { deuxième }
//        z.SQL.Add('select nomjou||'', ''||codcls||'', ''||libclb'
//                 +' from match a, tablo b'
//                 +' where a.sertab = :sertab'
//                 +'   and a.level = :level'
//                 +'   and a.sertab = b.sertab'
//                 +'   and a.perdant = b.serjou');
//        z.ParamByName('sertab').AsInteger := sertab;
//        z.ParamByName('level').AsInteger := level;
//        z.Open;
//        Inc(row);
//        sht.Cells[row,col] := z.Fields[0].AsString;
//        z.Close;
//        { troisièmes }
//        z.SQL.Clear;
//        z.SQL.Add('select nomjou||'', ''||codcls||'', ''||libclb'
//                 +' from match a, tablo b'
//                 +' where a.sertab = :sertab'
//                 +'   and a.level = :level'
//                 +'   and a.sertab = b.sertab'
//                 +'   and a.perdant = b.serjou');
//        z.ParamByName('sertab').AsInteger := sertab;
//        z.ParamByName('level').AsInteger := Pred(level);
//        z.Open;
//        while not z.Eof do
//        begin
//          Inc(row);
//          sht.Cells[row,col] := z.Fields[0].AsString;
//          z.Next;
//        end;
//        z.Close;
//      end;
//
//      sht := book.Worksheets['tablo'];
//      sht.Select;
//      if z.Active then
//        z.Close;
//      z.SQL.Clear;
//      z.SQL.Add('select codcat from categories where sercat = ' + IntToStr(sertab));
//      z.Open;
//      dir := Format('%s\%s', [ExcludeTrailingPathDelimiter(getSettingsValue('export','c:\work\export')),getExportDirectory(sertrn)]);
//      ForceDirectories(dir);
//      filename := Format('%s',[FindAndReplaceAll(z.Fields[0].AsString,'/','-')]);
//      { sauvegarde du fichier excel }
//
//      book.SaveAs(Format('%s\%s.xlsx',[ExcludeTrailingPathDelimiter(dir),filename]), AddToMRU:=True);
//      { export du tablo en pdf }
//      asPDF(sht,Format('%s\%s.pdf',[ExcludeTrailingPathDelimiter(dir),filename]));
//      z.Close;
//
//    end;
//  finally
//    z.Free;
//  end;
//end;
//
//procedure results2doc(const sertrn: integer);
//var
//  dir,filename: string;
//  w,z,y,cats: TZReadOnlyQuery;
//  xls,wkb,sht: variant;
//  row,col,numcat,arow: integer;
//const
//  colonne: array[0..1] of integer = (8,2);
//begin
//  z := getROQuery(lcCnx);
//  try
//    dir := Format('%s\%s', [ExcludeTrailingPathDelimiter(getSettingsValue('export','c:\work\export')),getExportDirectory(sertrn)]);
//    ForceDirectories(dir);
//    filename := Format('%s\results',[dir]);
//    createExcelWorkbook(xls,wkb,sht,True,getSettingsValue('resultsTemplate','c:\ping\docs\modèles\modResults.xltx'));
//    z.SQL.Add('select dattrn,organisateur,libelle from tournoi where sertrn = :sertrn');
//    z.Params[0].AsInteger := sertrn;
//    z.Open;
//    row := 1;
//    sht.Cells[row,01] := z.FieldByName('libelle').AsString;
//    Inc(row);
//    sht.Cells[row,01] := Format('%s - %s',[z.FieldByName('dattrn').AsString,z.FieldByName('organisateur').AsString]);
//    z.Close;
//    cats := getROQuery(lcCnx);
//    try
//      cats.SQL.Add('select a.sercat,numseq,codcat, count(*) presents'
//                  +' from categories a, insc b'
//                  +' where a.sertrn = :sertrn'
//                  +'   and a.sertrn = b.sertrn'
//                  +'   and a.sercat = b.sercat'
//                  +'   and b.statut < :statut'
//                  +' group by 1,2,3'
//                  +' order by 2,3');
//      y := getROQuery(lcCnx);
//      try
//        y.SQL.Add('select nomjou,codcls,libclb'
//                 +' from tablo'
//                 +' where sertab = :sertab'
//                 +'   and serjou = :serjou');
//        y.Prepare;
//
//        w := getROQuery(lcCnx);
//        try
//          w.SQL.Add('select first 3 codcls,count( * )'
//                   +' from insc a, tablo b'
//                   +' where a.sercat = b.sertab'
//                   +'   and a.sercat = :sercat'
//                   +'   and a.serjou = b.serjou'
//                   +'   and b.codcls in (select codcls from classements x'
//                   +'                     where a.sercat = x.sercat)'
//                   +'   and statut < :statut'
//                   +' group by 1'
//                   +' order by 1');
//          w.Prepare;
//          w.ParamByName('statut').Value := isWO;
//
//          cats.ParamByName('sertrn').AsInteger := sertrn;
//          cats.ParamByName('statut').Value := isWO;
//          cats.Open;
//          numcat := 0;
//          Inc(row,2);
//          while not cats.Eof do
//          begin
//            Inc(numcat);
//            col := colonne[numcat mod 2];
//            sht.Cells[row,col] := Format('%s (%d présents)',[cats.FieldByName('codcat').AsString,cats.FieldByName('presents').AsInteger]);
//            z.sql.clear;
//            z.sql.add('select handicap,catage from categories'
//                     +' where sercat = :sercat');
//            z.Params[0].AsInteger := cats.FieldByName('sercat').AsInteger;
//            z.Open;
//            if (z.Fields[0].AsInteger = 0) and (z.Fields[1].AsInteger = 0) then
//            begin
//              w.ParamByName('sercat').AsInteger := z.Params[0].AsInteger;
//              w.Open;
//              while not w.Eof do
//              begin
//                Inc(col);
//                sht.Cells[row,col] := w.Fields[1].AsInteger;
//                w.Next;
//                Application.ProcessMessages;
//              end;
//              w.Close;
//            end;
//            z.Close;
//            col := colonne[numcat mod 2];
//            arow := row;
//            Inc(arow,2);
//            z.SQL.Clear;
//            z.SQL.Add('select first 1 vainqueur,perdant'
//                     +' from match a'
//                     +' where sertab = :sertab'
//                     +' order by nummtc desc');
//            z.ParamByName('sertab').AsInteger := cats.FieldByName('sercat').AsInteger;
//            z.Open;
//            y.ParamByName('sertab').AsInteger := z.ParamByName('sertab').AsInteger;
//            y.ParamByName('serjou').AsInteger := z.FieldByName('vainqueur').AsInteger;
//            y.Open;
//            sht.Cells[arow,col] := Format('%s, %s, %s',[y.FieldByName('nomjou').AsString,y.FieldByName('codcls').AsString,y.FieldByName('libclb').AsString]);
//            y.Close;
//            Inc(arow);
//            y.ParamByName('serjou').AsInteger := z.FieldByName('perdant').AsInteger;
//            y.Open;
//            sht.Cells[arow,col] := Format('%s, %s, %s',[y.FieldByName('nomjou').AsString,y.FieldByName('codcls').AsString,y.FieldByName('libclb').AsString]);
//            y.Close;
//            z.Close;
//            z.SQL.Clear;
//            z.SQL.Add('select first 2 skip 1 perdant'
//                     +' from match a'
//                     +' where sertab = :sertab'
//                     +' order by nummtc desc');
//            z.ParamByName('sertab').AsInteger := cats.FieldByName('sercat').AsInteger;
//            z.Open;
//            while not z.Eof do
//            begin
//              Inc(arow);
//              y.ParamByName('serjou').AsInteger := z.FieldByName('perdant').AsInteger;
//              y.Open;
//              sht.Cells[arow,col] := Format('%s, %s, %s',[y.FieldByName('nomjou').AsString,y.FieldByName('codcls').AsString,y.FieldByName('libclb').AsString]);
//              y.Close;
//              z.Next;
//              Application.ProcessMessages;
//            end;
//            if (numcat mod 2) = 0 then
//              Inc(row,7);
//            cats.Next;
//            Application.ProcessMessages;
//          end;
//          cats.Close;
//        finally
//          w.Free;
//        end;
//      finally
//        y.Free;
//      end;
//    finally
//      cats.Free;
//    end;
//  finally
//    z.Free;
//  end;
//  wkb.SaveAs(Format('%s.xlsx',[filename]), AddToMRU:=True);
//  { export du tablo en pdf }
//  asPDF(sht,Format('%s.pdf',[filename]));
//end;
//
//procedure asPDF(const sheet: Variant; const filename: string);
//begin
//  try
//    sheet.ExportAsFixedFormat(xlTypePDF,filename);
//  except
//  end;
//end;

//function isDigit(const c: char): boolean;
//const
//  numbers: TSysCharSet = ['0','1','2','3','4','5','6','7','8','9'];
//begin
//  Result := CharInSet(c,numbers);
//end;

//procedure addTempTable(const tableName: string);
//var
//  z: TZReadOnlyQuery;
//begin
//  z := getROQuery(lcCnx);
//  try
//    if not tableExists(lcCnx,'tempTables') then
//    begin
//      z.SQL.Add('create table tempTables ('
//               +'  tableName varchar(16) not null'
//               +' ,primary key(tableName))');
//      z.ExecSQL;
//      z.SQL.Clear;
//    end;
//    z.SQL.Add('insert into tempTables (tableName) values (:tableName)');
//    z.Params[0].AsString := tableName;
//    z.ExecSQL;
//  finally
//    z.Free;
//  end;
//end;
//
//procedure dropTempTables;
//var
//  z: TZReadOnlyQuery;
//begin
//  z := getROQuery(lcCnx);
//  try
//    if tableExists(lcCnx,'tempTables') then
//    begin
//      lcCnx.startTransaction;
//      try
//        Screen.Cursor := crSQLWait;
//        z.SQL.Add('select tableName from tempTables');
//        z.Open;
//        while not z.Eof do
//        begin
//          dropTable(lcCnx, z.Fields[0].AsString);
//          z.Next;
//        end;
//        z.Close;
//        z.SQL.Clear;
//        z.SQL.Add('delete from tempTables where 1=1');
//        z.ExecSQL;
//        lcCnx.commit;
//      except
//        lcCnx.rollback;
//      end;
//    end;
//  finally
//    Screen.Cursor := crDefault;
//    z.Free;
//  end;
//end;

//function checkDoublons(const sertrn: integer): TStrings;
//  function getLicence(const lic1,lic2: string): string;
//  begin
//    if lic1 > lic2 then
//      Result := lic2+'-'+lic1
//    else
//      Result := lic1+'-'+lic2;
//  end;
//var
//  categories,
//  tablo,
//  sel,
//  ins: TZReadOnlyQuery;
//  freeList: TObjectList;
//  serjo1,
//  serjo2: integer;
//  licence,
//  lic1,
//  lic2: string;
//  numrow: integer;
//begin
//  Result := TStringList.Create;
//  if not tableExists(lcCnx,'doublons') then
//  begin
//    with getROQuery(lcCnx) do
//    begin
//      try
//        SQL.Add('CREATE TABLE doublons ('
//               +'   licence varchar(13) NOT NULL'
//               +'  ,serjo1 integer'
//               +'  ,serjo2 integer'
//               +'  ,tablo varchar(20)'
//               +'  ,primary key(licence,tablo))');
//        ExecSQL;
//      finally
//        Free;
//      end;
//    end;
//  end;
//  emptyTable(lcCnx,'doublons');
//
//  FreeList := TObjectList.Create;
//  try
//    categories := getROQuery(lcCnx,freeList);
//    categories.SQL.Add('select sercat,codcat from categories'
//                      +' where sertrn = ' + IntToStr(sertrn));
//
//    tablo := getROQuery(lcCnx,freeList);
//    tablo.SQL.Add('select coalesce(serjou,0)serjou,licence,numrow'
//                 +' from tablo'
//                 +' where sertrn = ' + IntToStr(sertrn)
//                 +'   and sertab = :sercat'
//                 +' order by numrow');
//    tablo.Prepare;
//
//    sel := getROQuery(lcCnx,freeList);
//    sel.SQL.Add('select count( * ) from doublons'
//               +' where licence = :licence');
//    sel.Prepare;
//
//    ins := getROQuery(lcCnx,freeList);
//    ins.SQL.Add('insert into doublons (licence,serjo1,serjo2,tablo)'
//               +' values (:licence,:serjo1,:serjo2,:tablo)');
//    ins.Prepare;
//
//    serjo1 := 0;
//    serjo2 := 0;
//    licence := '';
//    lic1 := '';
//    lic2 := '';
//    categories.Open;
//    while not categories.Eof do
//    begin
//      tablo.ParamByName('sercat').AsInteger := categories.FieldByName('sercat').AsInteger;
//      tablo.Open;
//
//      numrow := 2;
//      while not tablo.Eof do
//      begin
//        if numrow = 2 then
//        begin
//          numrow := 0;
//          serjo1 := 0;
//          serjo2 := 0;
//          licence := '';
//          lic1 := '';
//          lic2 := '';
//        end;
//        Inc(numrow);
//        if numrow = 1 then
//        begin
//          serjo1 := tablo.FieldByName('serjou').AsInteger;
//          lic1   := tablo.FieldByName('licence').AsString;
//        end
//        else
//        if numrow = 2 then
//        begin
//          serjo2 := tablo.FieldByName('serjou').AsInteger;
//          lic2   := tablo.FieldByName('licence').AsString;
//        end;
//        if numrow = 2 then
//        begin
//          if (serjo1 > 0) and (serjo2 > 0) then
//          begin
//            licence := getLicence(lic1,lic2);
//            ins.ParamByName('licence').AsString := licence;
//            ins.ParamByName('serjo1').AsInteger := serjo1;
//            ins.ParamByName('serjo2').AsInteger := serjo2;
//            ins.ParamByName('tablo').AsString   := categories.FieldByName('codcat').AsString;
//            ins.ExecSQL;
//
//            sel.ParamByName('licence').AsString := licence;
//            sel.Open;
//            if sel.Fields[0].AsInteger > 1 then
//              Result.Add(Format('%s : %s',[ins.ParamByName('tablo').AsString,licence]));
//            sel.Close;
//
//          end;
//        end;
//        tablo.Next;
//        Application.ProcessMessages;
//      end;
//
//      tablo.Close;
//      categories.Next;
//      Application.ProcessMessages;
//    end;
//    categories.Close;
//  finally
//    FreeList.Free;
//  end;
//end;

//procedure displayDoublons(f: TDataW);
//begin
//  f.data.SQL.Add('select licence,count( * ) from doublons'
//                +' group by 1'
//                +' having count( * ) > 1');
//  f.data.open;
//  f.ShowModal;
//end;

//procedure updateCategoryStatut(const sercat: integer; const stacat: TStatutCategorie);
//begin
//  with getROQuery(lcCnx) do
//  begin
//    try
//      SQL.Add('update categories set stacat = :stacat where sercat = :sercat');
//      Params[0].Value := stacat;
//      Params[1].AsInteger := sercat;
//      ExecSQL;
//    finally
//      Free;
//    end;
//  end;
//end;
//
//function getCategorysObject(const sercat: integer): TCategory;
//begin
//  Result := TCategoryList.getCategorysObject;
//  with getROQuery(lcCnx) do
//  begin
//    try
//      SQL.Add('select sertrn,sercat,codcat,heudeb,simple,handicap,numset'
//             +' from categories'
//             +' where sercat = ' + sercat.ToString);
////           +'   and stacat = ' + Ord(scEnCours).ToString
////           +' order by heudeb,codcat');
//      Open;
//      with Result do
//      begin
//        sertrn := Fields[0].AsInteger;
//        sercat := Fields[1].AsInteger;
//        codcat := Fields[2].AsString;
//        heudeb := Fields[3].AsString;
//        simple := Fields[4].AsString = '1';
//        handicap := Fields[5].AsString = '1';
//        numset := Fields[6].AsInteger;
//      end;
//      Close;
//      SQL.Clear;
//      SQL.Add('select max(level) from match where sertab = ' + sercat.ToString);
//      Open;
//      Result.levels := Fields[0].AsInteger;
//      Close;
//    finally
//      Free;
//    end;
//  end;
//end;
//
//function getCategorysRemainingMatchs(const sercat: integer): integer;
//begin
//  with getROQuery(lcCnx) do
//  begin
//    try
//      SQL.Add('select count(*) from match where'
//             +'  sertab = ' + sercat.ToString
//             +'  and score is null'
//             +'  and score <> ''BYE''');
//      Open;
//      Result := Fields[0].AsInteger;
//      Close;
//    finally
//      Free;
//    end;
//  end;
//end;
//
//function getCategorysPlayedMatchs(const sercat: integer): integer;
//begin
//  with getROQuery(lcCnx) do
//  begin
//    try
//      SQL.Add('select count(*) from match where'
//             +'  sertab = ' + sercat.ToString
//             +'  and score is not null'
//             +'  and score <> ''BYE''');
//      Open;
//      Result := Fields[0].AsInteger;
//      Close;
//    finally
//      Free;
//    end;
//  end;
//end;
//
//function getCategorysRemainingMatchsQuery(const sercat: integer): TZReadOnlyQuery;
//begin
//  Result := getROQuery(lcCnx);
//  with Result do
//  begin
//    SQL.Add('select a.level,a.numseq,a.nummtc,a.sermtc,a.serjo1,a.serjo2,a.stamtc,a.numtbl'
//           +'  ,b.nomjou nomjo1'
//           +'  ,c.nomjou nomjo2'
//           +'  ,a.sertab'
//           +' from match a left outer join tablo b on a.sertab = b.sertab and a.serjo1 = b.serjou'
//           +'              left outer join tablo c on a.sertab = c.sertab and a.serjo2 = c.serjou'
//           +' where a.sertab = ' + sercat.ToString
//           +'   and a.serjo1 > 0'
//           +'   and a.serjo2 > 0'
//           +'   and a.stamtc < ' + Ord(smTermine).ToString
//           +' order by 1,2');
//  end;
//end;
//
//procedure initUmpiresTable(const sertrn: integer);
//var
//  numtbl: smallint;
//  i: integer;
//begin
//  with getROQuery(lcCnx) do
//  begin
//    try
//      SQL.Add('select count(*) from match where sertrn = ' + sertrn.ToString);
//      Open;
//      if Fields[0].AsInteger = 0 then
//      begin
//        Close;
//        SQL.Clear;
//        SQL.Add('select numtbl from tournoi where sertrn = ' + sertrn.ToString);
//        Open;
//        numtbl := Fields[0].AsInteger;
//        Close;
//        SQL.Clear;
//        SQL.Add('delete from umpires where 1=1');
//        ExecSQL;
//        SQL.Clear;
//        SQL.Add('insert into umpires (numtbl,umpire,statbl,sermtc,prvmtc) values (:numtbl,null,:statbl,0,0)');
//        Prepare;
//        Params[2].Value := ttLibre;
//        for i := 1 to numtbl do
//        begin
//          Params[0].AsInteger := i;
//          ExecSQL;
//        end;
//      end;
//    finally
//      Free;
//    end;
//  end;
//end;
//
//procedure setAsUmpire(const nomjou: string; const numtbl: smallint);
//begin
//  with getROQuery(lcCnx) do
//  begin
//    try
//      SQL.Add('update umpires'
//             +' set umpire = ' + nomjou.QuotedString
//             +' where numtbl = ' + numtbl.ToString);
//      ExecSQL;
//    finally
//      Free;
//    end;
//  end;
//end;
//
//function getJoueurQuery: TZReadOnlyQuery;
//begin
//  Result := getROQuery(lcCnx);
//  with Result do
//  begin
//    SQL.Add('select count(*) from match a, categories b'
//           +' where a.sertab = b.sercat'
//           +'   and a.sertrn = :sertrn'
//           +'   and (serjo1 = :serjou or serjo2 = :serjou)'
//           +'   and sermtc <> :sermtc'
//           +'   and b.stacat = ' + Ord(scEnCours).ToString);
//    Prepare;
//  end;
//end;
//
//function getJoueurOccupeQuery: TZReadOnlyQuery;
//begin
//  Result := getROQuery(lcCnx);
//  Result.SQL.Add('select numtbl'
//                +' ,(select nomjou from joueur where serjou = :serjou) nomjou'
//                +' from match a inner join categories b'
//                +'                on a.sertab = b.sercat'
//                +' where a.sertrn = :sertrn'
//                +'   and a.stamtc = ' + Ord(smEnCours).ToString
//                +'   and b.stacat = ' + Ord(scEnCours).ToString
//                +'   and a.score is null'
//                +'   and(a.serjo1 = :serjou or serjo2 = :serjou)');
//  Result.Prepare;
//end;
//
//function getUmpiresQuery: TZReadOnlyQuery;
//begin
//  Result := getROQuery(lcCnx);
//  with Result do
//  begin
//    SQL.Add('select count(*) from umpires where umpire = :nomjou');
//    Prepare;
//  end;
//end;
//
//function getUmpiresName(const numtbl: smallint): string;
//begin
//  Result := '';
//  with getROQuery(lcCnx) do
//  begin
//    try
//      SQL.Add('select umpire from umpires where numtbl = ' + numtbl.ToString());
//      Open;
//      if not Eof then
//        Result := Fields[0].AsString;
//      Close;
//    finally
//      Free;
//    end;
//  end;
//end;
//
//procedure setTableStatus(const numtbl: smallint; const sermtc: integer; const statuT: TStatutTable);
//begin
//  with getROQuery(lcCnx) do
//  begin
//    try
//      SQL.Add('update umpires set statbl = ' + Ord(statuT).ToString
//             +'   ,sermtc = ' + sermtc.ToString
//             +' where numtbl = ' + numtbl.ToString);
//      ExecSQL;
//    finally
//      Free;
//    end;
//  end;
//end;
//
//procedure beginMatch(const sermtc: integer; const numtbl: smallint);
//begin
//  with getROQuery(lcCnx) do
//  begin
//    try
//      SQL.Add('update match'
//             +' set numtbl = ' + numtbl.ToString
//             +'    ,stamtc = ' + Ord(smEnCours).ToString
//             +'    ,modifie = current_timestamp'
//             +'    ,heure = ' + QuotedStr(FormatDateTime('hh:nn',Now))
//             +' where sermtc = ' + sermtc.ToString);
//      lcCnx.startTransaction;
//      try
//        ExecSQL;
//        setTableStatus(numtbl,sermtc,ttOccupee);
//        lcCnx.commit;
//      except
//        lcCnx.rollback;
//        raise;
//      end;
//    finally
//      Free;
//    end;
//  end;
//end;

//procedure endMatch(const sermtc: integer; const numtbl: smallint);
//begin
//  with getROQuery(lcCnx) do
//  begin
//    try
//      SQL.Add('update match'
//             +' set stamtc = ' + Ord(smTermine).ToString
//             +'    ,modifie = current_timestamp'
//             +' where sermtc = ' + sermtc.ToString);
//      ExecSQL;
//      savePreviousMatch(numtbl,sermtc);
//      setTableStatus(numtbl,0,ttLibre);
//    finally
//      Free;
//    end;
//  end;
//end;

//procedure setTableNumber(const sermtc: integer; const numtbl: smallint);
//begin
//  with getROQuery(lcCnx) do
//  begin
//    try
//      SQL.Add('update match'
//             +' set numtbl = ' + numtbl.ToString
//             +'    ,modifie = current_timestamp'
//             +' where sermtc = ' + sermtc.ToString);
//      ExecSQL;
//      setTableStatus(numtbl,sermtc,ttOccupee);
//      //setTableMatchNumber(numtbl,sermtc);
//    finally
//      Free;
//    end;
//  end;
//end;

//procedure setTableMatchNumber(const numtbl,sermtc: integer);
//begin
//  with getROQuery(lcCnx) do
//  begin
//    try
//      SQL.Add('update umpires set sermtc = ' + sermtc.ToString
//             +' where numtbl = ' + numtbl.ToString);
//      ExecSQL;
//    finally
//      Free;
//    end;
//  end;
//end;

//procedure setMatchStatus(const sermtc: integer; const statut: TStatutMatch);
//var
//  sertrn,
//  serjo1,
//  serjo2: integer;
//begin
//  with getROQuery(lcCnx) do
//  begin
//    try
//      { on vérifie que l'un des 2 joueurs n'est pas déjà entrain de jouer ! }
//      SQL.Add('select sertrn,serjo1,serjo2 from match where sermtc = ' + sermtc.ToString);
//      Open;
//      sertrn := Fields[0].AsInteger;
//      serjo1 := Fields[1].AsInteger;
//      serjo2 := Fields[2].AsInteger;
//      Close;
//      SQL.Clear;
//      SQL.Add('select count(*) from match where sertrn = ' + sertrn.ToString
//             +' and stamtc = ' + Ord(smEnCours).ToString
//             +' and (serjo1 = ' + serjo1.ToString
//             +'      or'
//             +'      serjo2 = ' + serjo1.ToString+')');
//      Open;
//      if Fields[0].AsInteger > 0 then
//        raise Exception.Create('Le joueur 1 est déjà entrain de jouer !');
//      Close;
//      SQL.Clear;
//      SQL.Add('select count(*) from match where sertrn = ' + sertrn.ToString
//             +' and stamtc = ' + Ord(smEnCours).ToString
//             +' and (serjo1 = ' + serjo2.ToString
//             +'      or'
//             +'      serjo2 = ' + serjo2.ToString+')');
//      Open;
//      if Fields[0].AsInteger > 0 then
//        raise Exception.Create('Le joueur 2 est déjà entrain de jouer !');
//      Close;
//      SQL.Clear;
//      SQL.Add('select umpire,numtbl'
//             +' from umpires a inner join joueur b on a.umpire = b.nomjou'
//             +' where b.serjou = ' + serjo1.ToString);
//      Open;
//      if not IsEmpty then
//        raise Exception.CreateFmt('%s est arbitre table %d',[Fields[0].AsString,Fields[1].AsInteger]);
//      Close;
//      SQL.Clear;
//      SQL.Add('select umpire,numtbl'
//             +' from umpires a inner join joueur b on a.umpire = b.nomjou'
//             +' where b.serjou = ' + serjo2.ToString);
////      SQL.Add('select umpire,numtbl from umpires where umpire = ' + serjo2.ToString);
//      Open;
//      if not IsEmpty then
//        raise Exception.CreateFmt('%s est arbitre table %d',[Fields[0].AsString,Fields[1].AsInteger]);
//      Close;
//      SQL.Clear;
//      SQL.Add('update match'
//             +' set stamtc = ' + Ord(statut).ToString
//             +'    ,modifie = current_timestamp'
//             +' where sermtc = ' + sermtc.ToString);
//      ExecSQL;
//    finally
//      Free;
//    end;
//  end;
//end;
//
//procedure savePreviousMatch(const numtbl: smallint; const sermtc: integer);
//begin
//  with getROQuery(lcCnx) do
//  begin
//    try
//      SQL.Add('update umpires'
//             +' set prvmtc = ' + sermtc.ToString
//             +'    ,sermtc = 0'
//             +' where numtbl = ' + numtbl.ToString);
//      ExecSQL;
//    finally
//      Free;
//    end;
//  end;
//end;
//
//function getFreeTableNumberQuery: TZReadOnlyQuery;
//begin
//  Result := getROQuery(lcCnx);
//  with Result do
//  begin
//    SQL.Add('select count(*) from umpires'
//           +' where statbl = ' + Ord(ttLibre).ToString);
//  end;
//end;
//
//{: retrieves the current level }
//function getLevelQuery: TZReadOnlyQuery;
//begin
//  Result := getROQuery(lcCnx);
//  with Result do
//  begin
//    SQL.Add('select first 1 level,count(*) from match'
//           +' where sertab = :sertab'
//           +'   and score is null'
//           +' group by 1'
//           +' order by 1');
//    Prepare;
//  end;
//end;
//
//{: create an TPingMatch table with data }
//function getPingMatchObject(const sermtc: integer): TPingMatch;
//var
//  z: TZReadOnlyQuery;
//begin
//  Result := TPingMatch.Create;
//  with getROQuery(lcCnx) do
//  begin
//    try
//      SQL.Add('SELECT m.sermtc,sertab,level,nummtc,datmtc,heure,serjo1,serjo2'
//             +'      ,handi1,handi2,m.numtbl,modifie,stamtc,score'
//             +'      ,vainqueur,perdant'
//             +'      ,j1.nomjou AS nomJoueur1,cb1.libclb AS clubJoueur1,j1.codcls AS classementJoueur1,j1.vrbrgl AS rglJoueur1'
//             +'      ,j2.nomjou AS nomJoueur2,cb2.libclb AS clubJoueur2,j2.codcls AS classementJoueur2,j2.vrbrgl AS rglJoueur2'
//             +'      ,ctg.codcat,ctg.heudeb'
//             +' FROM match m'
//             +'   LEFT JOIN joueur j1 ON m.serjo1 = j1.serjou'
//             +'   LEFT JOIN club cb1 ON j1.codclb = cb1.codclb'
//             +'   LEFT JOIN joueur j2 ON m.serjo2 = j2.serjou'
//             +'   LEFT JOIN club cb2 ON j2.codclb = cb2.codclb'
//             +'   INNER JOIN categories ctg ON m.sertab = ctg.sercat'
//             +' WHERE m.sermtc = ' + sermtc.ToString);
//      Open;
//      if not Eof then
//      begin
//        Result.sermtc := FieldByName('sermtc').AsInteger;
//        Result.categ := TCategory.Create;
//        Result.categ.codcat := FieldByname('codcat').AsString;
//        Result.categ.heudeb := FieldByName('heudeb').AsString;
//        Result.level := FieldByName('level').AsInteger;
//        Result[1].nom := FieldByName('nomJoueur1').AsString;
//        Result[1].club := FieldByName('clubJoueur1').AsString;
//        Result[1].classement := FieldByName('classementJoueur1').AsString;
//        Result[1].handicap := FieldByName('handi1').AsInteger;
//        Result[2].nom := FieldByName('nomJoueur2').AsString;
//        Result[2].club := FieldByName('clubJoueur2').AsString;
//        Result[2].classement := FieldByName('classementJoueur2').AsString;
//        Result[2].handicap := FieldByName('handi2').AsInteger;
//        Result.score := FieldByName('score').AsString;
//        Result.status := TStatutMatch(FieldByName('stamtc').Value);
//        Result.beginTime := FieldByName('heure').AsString;
//        z := getROQuery(lcCnx);
//        try
//          z.SQL.Add('SELECT nomjou FROM joueur WHERE serjou = :serjou');
//          z.Prepare;
//          if not(FieldByname('vainqueur').IsNull) and (FieldByName('vainqueur').AsInteger > 0) then
//          begin
//            z.Params[0].AsInteger := FieldByName('vainqueur').AsInteger;
//            z.Open;
//            Result.Winner := z.Fields[0].AsString;
//            z.Close;
//          end;
//          if not(FieldByname('perdant').IsNull) and (FieldByName('perdant').AsInteger > 0) then
//          begin
//            z.Params[0].AsInteger := FieldByName('perdant').AsInteger;
//            z.Open;
//            Result.Loser := z.Fields[0].AsString;
//            z.Close;
//          end;
//        finally
//          z.Free;
//        end;
//      end;
//      Close;
//    finally
//      Free;
//    end;
//  end;
//end;
//
//procedure setPingMatchObjectData(match: TPingMatch);
//var
//  m: TPingMatch;
//  sermtc: integer;
//begin
//  sermtc := match.sermtc;
//  m := getPingMatchObject(sermtc);
//  try
//    match.Assign(m);
//    match.sermtc := sermtc;
//  finally
//    m.Free;
//  end;
//end;
//
//function getWinnerLoser(const sermtc: integer): TStrings;
//begin
//  Result := TStringList.Create;
//  with getROQuery(lcCnx) do
//  begin
//    try
//      SQL.Add('SELECT b.nomjou winner'
//             +'      ,c.nomjou loser'
//             +' FROM match a INNER JOIN joueur b ON a.vainqueur = b.serjou'
//             +'              INNER JOIN joueur c ON a.perdant = c.serjou'
//             +' WHERE a.sermtc = ' + sermtc.ToString());
//      Open;
//      if not Eof then
//      begin
//        Result.Add(Fields[0].AsString);
//        Result.Add(Fields[1].AsString);
//      end;
//      Close;
//    finally
//      Free;
//    end;
//  end;
//end;
//
{ TCategory }

//procedure TCategory.Assign(Source: TPersistent);
//begin
//  if Source is TCategory then
//  begin
//    with Source as TCategory do
//    begin
//      Self.sertrn := sertrn;
//      Self.Fsercat := sercat;
//      Self.Fhandicap := handicap;
//      Self.Fcodcat := codcat;
//      Self.Fnumset := numset;
//      Self.Fsimple := simple;
//      Self.Fheudeb := heudeb;
//      Self.FNumInsc := numinsc;
//      Self.FPlayedGames := playedGames;
//      Self.FRemainingGames := remainingGames;
//      Self.FLevel := level;
//      Self.FLevels := levels;
//    end;
//  end
//  else
//    inherited;
//end;
//
//procedure TCategory.Setcodcat(const Value: string);
//begin
//  Fcodcat := Value;
//end;
//
//procedure TCategory.Sethandicap(const Value: boolean);
//begin
//  Fhandicap := Value;
//end;
//
//procedure TCategory.Setheudeb(const Value: string);
//begin
//  Fheudeb := Value;
//end;
//
//procedure TCategory.Setnumset(const Value: smallint);
//begin
//  Fnumset := Value;
//end;
//
//procedure TCategory.Setsercat(const Value: integer);
//begin
//  Fsercat := Value;
//end;
//
//procedure TCategory.Setsimple(const Value: boolean);
//begin
//  Fsimple := Value;
//end;
//
//{ TCategoryList }
//
//class function TCategoryList.getCategorysObject: TCategory;
//begin
//  Result := TCategory.Create;
//end;
//
//{ TCategoryHelper }
//
//function TCategoryHelper.levelAsString: string;
//begin
//  if level <= levels-3 then
//    Result := level.ToString
//  else if level = levels-2 then
//    Result := '1/4 Finale'
//  else if level = levels-1 then
//    Result := '1/2 Finale'
//  else if level = levels then
//    Result := 'Finale';
//end;

{ TPingMatch }

//procedure TPingMatch.Assign(Source: TPersistent);
//var
//  src: TPingMatch;
//begin
//  if Source is TPingMatch then
//  begin
//    src := TPingMatch(Source);
//    FLevel := src.level;
//    if Assigned(src.joueurs[1]) then
//      FJoueurs[1].Assign(src.joueurs[1]);
//    if Assigned(src.joueurs[2]) then
//      FJoueurs[2].Assign(src.joueurs[2]);
//    FScore := src.score;
//    if Assigned(src.categ) then
//      FCateg.Assign(src.categ);
//    FEndTime := src.endTime;
//    FStatutMatch := src.status;
//    FBeginTime := src.beginTime;
//    if Assigned(src.table) then
//      FTable.Assign(src.table);
//    FToTableNumber := src.toTableNumber;
//    FLoser := src.Loser;
//    FWinner := src.Winner;
//    FRefresh := src.refresh;
//    FSermtc := src.sermtc;
//  end
//  else
//    inherited;
//end;

//function TPingMatch.asString: string;
//begin
//  if Assigned(table) then
//  begin
//    Result := Format('Table %s : %s -> %s / %s - Arbitre : %s début %s fin %s',[table.number.ToString,
//                                                                                categ.codcat,
//                                                                                joueurs[1].nom,
//                                                                                joueurs[2].nom,
//                                                                                getUmpiresName(table.number),
//                                                                                beginTime,
//                                                                                endTime]);
//  end
//  else
//    Result := Format('Table -- : %s -> %s / %s - début %s fin %s',[categ.codcat,
//                                                                                joueurs[1].nom,
//                                                                                joueurs[2].nom,
//                                                                                beginTime,
//                                                                                endTime]);
//end;

//constructor TPingMatch.Create;
//begin
//  FMagic := 0;
//  FJoueurs[1] := TJoueur.Create;
//  FJoueurs[2] := TJoueur.Create;
//  FStatutMatch := smInactif;
//  FRefresh := True;
//end;
//
//destructor TPingMatch.Destroy;
//begin
//  FJoueurs[1].Free;
//  FJoueurs[2].Free;
//  inherited;
//end;
//
//function TPingMatch.getJoueur(const index: integer): TJoueur;
//begin
//  Result := FJoueurs[index];
//end;
//
//procedure TPingMatch.SetJoueur(const index: integer; const Value: TJoueur);
//begin
//  FJoueurs[index] := Value;
//end;

//{ TJoueur }
//
//procedure TJoueur.Assign(Source: TPersistent);
//begin
//  if Source is TJoueur then
//  begin
//    nom := TJoueur(Source).nom;
//    club := TJoueur(Source).club;
//    classement := TJoueur(Source).classement;
//    handicap := TJoueur(Source).handicap;
//  end
//  else
//    inherited;
//end;

//{ TTournoi }
//
//procedure TTournoi.Assign(Source: TPersistent);
//begin
//  if Source is TTournoi then
//  begin
//    FSerTrn := TTournoi(Source).sertrn;
//  end
//  else
//    inherited;
//end;

//{ TPingTable }
//
//procedure TPingTable.Assign(Source: TPersistent);
//begin
//  if Source is TPingTable then
//  begin
//    FNumber := TPingTable(Source).number;
//    FStatut := TPingTable(Source).statut;
//  end
//  else
//    inherited;
//end;

end.
