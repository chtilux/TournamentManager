unit tmUtils15;

interface

uses
  Graphics, lal_connection, Messages, Vcl.Controls, Classes,
  Vcl.ExtCtrls, ZDataset, ZAbstractRODataset, DB, System.Types, SysUtils,
  lal_settings, dataWindow, lal_seek, ZConnection, TMEnums, Tournament, Arena,
  PlayArea;

type

  TTournamentSettings = class(TSettings)
  private
    const
      cs_cledic = 'cledic';
      cs_coddic = 'coddic';
      cs_libdic = 'libdic';
      cs_pardc1 = 'pardc1';
      cs_pardc2 = 'pardc2';
      cs_pardc3 = 'pardc3';
      cs_pardc4 = 'pardc4';
      cs_pardc5 = 'pardc5';
      cs_pardc6 = 'pardc6';
      cs_pardc7 = 'pardc7';
      cs_pardc8 = 'pardc8';
      cs_pardc9 = 'pardc9';
      cs_settings = 'settings';
      cs_rules = 'rules';
      cs_bestOf = 'bestOf';
      cs_pointsOfASet = 'pointsOfASet';
      cs_exportComplet = 'exportComplet';
      cs_exportScore = 'exportScore';
      cs_firstRoundMode = 'TFirstRoundMode';

    function GetSeekCodeFirstRoundMode: string;
    procedure BuildPathSettings(var Value: string; const Name, Path: string;
      const Query: TZReadOnlyQuery);
    procedure BuildTemplateFilenameSettings(var Value: string; const Name,
      Filename: string; const Query: TZReadOnlyQuery);
    function GetDrawTemplate: string;
    function GetGroupTemplate: string;

    var
      pvWorkingDirectory: string;
      pvTournamentsDirectory: string;
      pvExportDirectory: string;
      pvTemplatesDirectory: string;
      pvFLTTResultsDocument: string;
      pvDrawTemplate: string;
      pvQualificationGroupTemplate: string;
      FSeekConfigs: TStrings;
      FTextValues: TStrings;

    function getWorkingDirectory: string;
    procedure SetWorkingDirectory(const Value: string);
    function getTournamentsDirectory: string;
    procedure SetTournamentsDirectory(const Value: string);
    function getExportDirectory: string;
    procedure SetExportDirectory(const Value: string);
    function GetExportsTo: string;
    function getTemplatesDirectory: string;
    procedure SetTemplatesDirectory(const Value: string);
    function getFLTTResultsDocument: string;
    procedure SetFLTTResultsDocument(const Value: string);
    function getFLTTResultsTemplate: string;
    procedure SetFirstRoundMode(const Value: TFirstRoundMode);
    function GetFirstRoundMode: TFirstRoundMode;
    function GetSeekCodeSaison: string;
    function GetSeekCodeCategoryStatus: string;
    function GetSeekCodeClub: string;

  protected
    procedure DoRead; override;
    procedure DoWrite; override;

  public
    constructor Create(cnx: TLalConnection; TextValues: TStrings); reintroduce; overload;
    destructor Destroy; override;
    property WorkingDirectory: string read getWorkingDirectory write SetWorkingDirectory;
    property TournamentsDirectory: string read getTournamentsDirectory write SetTournamentsDirectory;
    property ExportDirectory: string read getExportDirectory write SetExportDirectory;
    property TemplatesDirectory: string read getTemplatesDirectory write SetTemplatesDirectory;
    property FLTTResultsDocument: string read getFLTTResultsDocument write SetFLTTResultsDocument;
    property DrawTemplate: string read GetDrawTemplate;
    property GroupTemplate: string read GetGroupTemplate;
    property ExportsTo: string read GetExportsTo;
    property FLTTResultsTemplate: string read getFLTTResultsTemplate;
    property SeekConfigs: TStrings read FSeekConfigs;
    property FirstRoundMode: TFirstRoundMode read GetFirstRoundMode write SetFirstRoundMode;
    property SeekCodeSaison: string read GetSeekCodeSaison;
    property SeekCodeClub: string read GetSeekCodeClub;
    property SeekCodeCategoryStatus: string read GetSeekCodeCategoryStatus;
    property SeekCodeFirstRoundMode: string read GetSeekCodeFirstRoundMode;
    procedure SaveToFile(const Filename: TFilename);
  end;

  TPlayerStatus = class(TObject)
  private
    FEnCours: string;
    FNom: string;
    FClub: string;
    FColor: TColor;
    FTableaux: TStrings;
    pvCnx: TLalConnection;
    pvJoueur,
    pvTableaux,
    pvEnCours: TZReadOnlyQuery;
    FAvailableColor: TColor;
    FIsUmpireColor: TColor;
    FIsPlayingColor: TColor;
    FJoueur: integer;
    FTournoi: integer;
    procedure SetAvailableColor(const Value: TColor);
    procedure SetIsPlayingColor(const Value: TColor);
    procedure SetIsUmpireColor(const Value: TColor);
  public
    constructor Create(cnx: TLalConnection); virtual;
    destructor Destroy; override;
    property Nom: string read FNom;
    property Club: string read FClub;
    property Tableaux: TStrings read FTableaux;
    property EnCours: string read FEnCours;
    property StatusColor: TColor read FColor default clWindow;
    property AvailableColor: TColor read FAvailableColor write SetAvailableColor default clGreen;
    property IsPlayingColor: TColor read FIsPlayingColor write SetIsPlayingColor default clRed;
    property IsUmpireColor: TColor read FIsUmpireColor write SetIsUmpireColor default clMaroon;
    property Connection: TLalConnection read pvCnx;
    property Joueur: integer read FJoueur;
    property Tournoi: integer read FTournoi;
    function Read(const joueur, tournoi: integer): boolean;
  end;

  TPingItem = (piUnknown,piWinner,piLoser,piUmpire,piInProgress,piOver,
               piAvailable,piBusy,piInactive,piArena,piPlayArea,piQualified,
               piDisqualified,piWO,piPrepared,piDraw,piGenerated,piPair,piOdd,
               piClub,piHighlight,piHighLightText,piTDS,piStabylo,piError,
               piGameTable,piGroup);

{: broadcast a message in every screen form }
procedure broadcastMessage(const msg, wparam, lparam: integer);
{: set local variable lcCnx }
procedure setDatabaseLocalConnection(const Value: TLalConnection);
{: initialize array colors }
procedure initColorsArray;
{: retrieves item's color }
function getItemsColor(const Value: TPingItem): TColor;
{: retrieves color for registration }
function getRegistrationColor(const Value: TRegistrationStatus): TColor;
{: retrieves color for game }
function getGameColor(const Value: TGameStatus): TColor;
{: retrieves color for group status }
function GetGroupStatusColor(const Value: TQualificationGroupStatus): TColor;
{: retrieves color for category }
function getCategoryColor(const Value: TCategorysStatus): TColor;
{: retrieves pair/odd row color }
function getGridRowColor(const Value: TPingItem): TColor;
{: retrieves item's description male or female }
function getItemDesc(const Value: TPingItem; male: boolean): string;
{: retrieves category's status description male or female }
function getCategorysDesc(const Value: TCategorysStatus): string;
{: retrieves registration's status description }
function getRegistrationsDesc(const Value: TRegistrationStatus): string;
{: retrieves game's status description }
function getGamesDesc(const Value: TGameStatus): string;
{: retrieves play area's status description }
function getPlayAreasDesc(const Value: TPlayAreaStatus): string;
{: retrieves play area's color }
function getPlayAreasColor(const Value: TPlayAreaStatus): TColor;
{: retrieves umpire's color }
function getUmpiresColor(const Value: TPlayAreaStatus): TColor;
{: retrieves arena layout }
function getArenaLayout(trn: TTournament): TArenaLayout;
{: set umpire }
procedure setAsUmpire(const sertrn, serjou: integer; const nomjou: string; const numtbl: smallint);
{: set play area status }
procedure setPlayAreaStatus(const numtbl: smallint; status: TPlayAreaStatus);
{: set the category's status }
procedure updateCategoryStatut(const sercat: integer; const Value: TCategorysStatus);
{: set game InProgress }
procedure beginGame(const sertrn,sermtc: integer; const numtbl: smallint);
{: end a game }
procedure endGame(const sertrn,sermtc,serWinner,serLoser: integer; const numtbl: smallint; const loserName: string);
{: begins a qualification's group }
procedure BeginQualificationGroup(const sertrn, sergrp: integer; const numtbl: smallint);
{: cancels an inProgress Game }
procedure cancelGame(const sermtc: integer);
{: }
procedure TogglePhase(const sercat: integer; Fieldname: string);
{: }
procedure QualifySeeds(const sercat: integer);
{: }
function CreateQualificationGroup(const sercat, sertrn,
  numgrp: integer): integer;
{: }
function InsertIntoQualificationGroup(const sergrp, serjou,
  sercat, sertrn: integer): integer;
{:}
procedure UpdateQualificationGroupStatus(const sergrp: integer; const status: TQualificationGroupStatus);
{: creates results excel document for FLTT }
function createResultsFLTTDocument(const sertrn: integer): string;
{: exports draw on excel file }
procedure Draw2Excel(const sertab: integer; const score,complet: boolean; const Path: TFilename = '');
{: get single seek object }
function globalSeek: TLalSeek; overload;
{: get single seek object }
function globalSeek(cnx: TZConnection): TLalSeek; overload;

function getExportDirectory(const sertrn: integer): string;
function getCurrentSaison: integer;
function getDefValue(const tablename, colname: string; defValue: string): string;
function getCatage(const datann: TDateTime; saison: smallint): string;
function getCodClb(const libclb: string): string;
function getLibClb(const codclb: string): string;
function getTailleTableau(participants: integer): integer;
function genGames(const sercat: integer): boolean;
procedure deleteTournament(const sertrn: integer);
function isDigit(const c: char): boolean;
function checkDoublons(const sertrn: integer): TStrings;
procedure displayDoublons(f: TDataW);
procedure initUmpiresTable(const sertrn: integer);
function buildExportDirectory(const sertrn: integer): string;
procedure CheckAndSetCategorieStatusAfterUpdate(const sercat: integer);
procedure UpdateCategorysStatus(const sercat: integer; status: TCategorysStatus; phase: TFirstRoundMode);
function makeVersion(const version: double): boolean;

const
  wm_colorsChanged = wm_app + 1;
  wm_gameIsOver = wm_app + 2;
  wm_categChanged = wm_app + 3;
  wm_gameInfo = wm_app + 4;
  wm_umpiresRefresh = wm_app + 5;
  wm_noPlayAreaAvailable = wm_app + 6;
  wm_playerIsBusy = wm_app + 7;
  wm_playerIsUmpire = wm_app + 8;
  wm_gameCatchResult = wm_app + 9;
  wm_highLightPlayer = wm_app + 10;
  wm_playAreaRefresh = wm_app + 11;
  wm_beginGame = wm_app + 12;
  wm_endGame = wm_app + 13;
  wm_displayDraw = wm_app + 14;
  wm_gameCanceled = wm_app + 15;
  wm_playerStatus = wm_app + 16;
  wm_qualificationGroupRefresh = wm_app + 17;
  wm_CategoryPhaseChanged = wm_app + 18;
  wm_refreshArenaDisplay = wm_app + 19;

  cs_code_club_seek_code = 'code_club';
  cs_code_classement_seek_code = 'code_classement';
  cs_saison_seek_code = 'saison';
  cs_statut_categorie_seek_code = 'statut_categorie';
  cs_statut_game = 'statut_manche';
  cs_statut_play_area = 'statut_aire_jeu';
  cs_statut_registration = 'statut_registration';
  cs_first_round_mode = 'first_round_mode';
  cs_game_is_over = 'game_is_over';

  clOdd: array[boolean] of TPingItem = (piPair,piOdd);

var
  glSettings: TTournamentSettings;
  glSettingsValues: TStrings;
  glCreateGroupGamesProc: TProc<integer>;
  glPaintPlayAreaGameContent,
  glPaintPlayAreaGroupContent: TProc<TCollectionItem>;
  pvCheckCategStatusSelCategData,
  pvCheckCategStatusSelPrpTabCount,
  pvCheckCategStatusSelGamesCount,
  pvCheckCategStatusSelGamesStatusCount,
  pvCheckCategStatusSelTabloCount,
  pvUpdateCategorysStatusQuery,
  pvCheckCategStatusSelGroupGamesCount,
  pvCheckCategStatusSelGroupCount: TZReadOnlyQuery;

implementation

uses
  lal_dbUtils, TypInfo, Windows, Forms, DateUtils, u_pro_excel, excel_tlb, Math,
  u_pro_strings, Dialogs, Contnrs, lal_sequence, UITypes, lal_utils, AreaContent,
  Spring.Collections;

var
  lcCnx: TLalConnection;
  lcGetColorQuery: TZReadOnlyQuery;
  lcSetColorQuery: TZReadOnlyQuery;
  lcColorsArray: array[TPingItem] of TColor;
  lcPi: TPingItem;
  lcSeek: TLalSeek;

function stringToPingItem(const Value: string): TPingItem; forward;
function pingItemToString(const Value: TPingItem): string; forward;
procedure initColorQuery; forward;
{: exports games on excel file }
procedure Games2Excel(const sertab: integer; const book: Variant; const score,complet: boolean; const Phase: TFirstRoundMode; const Path: TFilename = ''); forward;
function GetExportFilename(const Path, Filename: TFilename; const Phase: TFirstRoundMode): TFilename; forward;

const
  piDefaultColor: TColor = clWindow;
  categoryStatus: array[TCategorysStatus] of TPingItem = (piInactive,piPrepared,piGroup,piDraw,piInProgress,piOver);
  registrationStatus: array[TRegistrationStatus] of TPingItem = (piDisqualified,piQualified,piWO);
  gameStatus: array[TGameStatus] of TPingItem = (piAvailable,piInProgress,piOver);
  playAreaStatus: array[TPlayAreaStatus] of TPingItem = (piInactive,piAvailable,piBusy);
//  TQualificationGroupStatus = (qgsInactive, qgsValidated, qgsGamesAreCreated, qgsInProgress, qgsOver);
  qualificationGroupStatus: array[TQualificationGroupStatus] of TPingItem = (piInactive,
              piAvailable,piDraw,piInProgress,piOver);
  pia: array[TPingItem] of string = ('unknown','winner','loser','umpire',
                                     'in progress','over','available',
                                     'busy','inactive','Arena','play area',
                                     'qualified','disqualified','WO',
                                     'prepared','draw','generated','pair','odd',
                                     'club','highlight','hilightText','TDS'
                                    ,'stabylo','error','gameTable','group');
  pis: array[TPingItem] of string = ('inconnu','vainqueur','perdant','arbitre',
                                     'en cours','terminé','disponible',
                                     'occupé','inactif','Arena','aire de jeu',
                                     'qualifié','disqualifié','WO',
                                     'preparé','tableau','généré','pair','impair'
                                    ,'club','sélection','texte sélectionné'
                                    ,'tête de série','stabylo','ERREUR','table de jeu'
                                    ,'groupe');
  pif: array[TPingItem] of string = ('inconnue','vainqueur','perdant','arbitre',
                                     'en cours','terminée','disponible',
                                     'occupée','inactive','Arena','aire de jeu',
                                     'qualifiée','disqualifiée','WO',
                                     'preparée','tableau','générée','paire','impaire'
                                    ,'club','sélection','texte sélectionné'
                                    ,'tête de série','stabylo','ERREUR','table de jeu'
                                    ,'groupe');

function stringToPingItem(const Value: string): TPingItem;
begin
  try
    Result := TPingItem(getEnumValue(TypeInfo(TPingItem),Value));
  except
    Result := piUnknown;
  end;
end;

function pingItemToString(const Value: TPingItem): string;
begin
  Result := pia[Value];
end;

procedure setDatabaseLocalConnection(const Value: TLalConnection);
begin
  lcCnx := Value;
end;

function getColorSetting(const Value: string): TColor;
begin
  Result := piDefaultColor;
  initColorQuery;
  with lcGetColorQuery do
  begin
    ParamByName('coddic').AsString := Value;
    Open;
    try
      if not Eof then
        Result := StringToColor(Fields[0].AsString);
    finally
      Close;
    end;
  end;
end;


{: used by initColorsArray, TODO : use dictionnary object }
procedure setColorSetting(const Value: string; color: TColor);
var
  cl: string;
begin
  initColorQuery;
  try
    cl := ColorToString(color);
  except
    cl := ColorToString(piDefaultColor);
  end;
  with lcSetColorQuery do
  begin
    ParamByName('item').AsString := Value;
    ParamByName('color').AsString := cl;
    ExecSQL;
  end;
end;

procedure initColorQuery;
begin
  if not Assigned(lcGetColorQuery) then
  begin
    lcGetColorQuery := getROQuery(lcCnx);
    lcGetColorQuery.SQL.Add('SELECT pardc1 AS color'
                           +' FROM dictionnaire'
                           +' WHERE cledic = ''colors'''
                           +'   and coddic = :item');
    lcGetColorQuery.Prepare;
  end;
  if not Assigned(lcSetColorQuery) then
  begin
    lcSetColorQuery := getROQuery(lcCnx);
    lcSetColorQuery.SQL.Add('UPDATE OR INSERT INTO dictionnaire'
                           +' (cledic,coddic,pardc1)'
                           +' VALUES'
                           +' (''colors'',:item,:color)');
    lcSetColorQuery.Prepare;
  end;
end;

procedure initColorsArray;
var
  lcPi: TPingItem;
begin
  initColorQuery;
  for lcPi := Low(lcColorsArray) to High(lcColorsArray) do
  begin
    lcGetColorQuery.ParamByName('item').AsString := pingItemToString(lcPi);
    lcGetColorQuery.Open;
    try
      if not lcGetColorQuery.Eof then
        lcColorsArray[lcPi] := StringToColor(lcGetColorQuery.Fields[0].AsString)
      else
        setColorSetting(lcGetColorQuery.ParamByName('item').AsString,piDefaultColor);
    finally
      lcGetColorQuery.Close;
    end;
  end;
end;

function getItemsColor(const Value: TPingItem): TColor;
begin
  Result := lcColorsArray[Value];
end;

function getRegistrationColor(const Value: TRegistrationStatus): TColor;
begin
  Result := lcColorsArray[registrationStatus[Value]];
end;

function getGameColor(const Value: TGameStatus): TColor;
begin
  Result := lcColorsArray[gameStatus[Value]];
end;

function GetGroupStatusColor(const Value: TQualificationGroupStatus): TColor;
begin
  Result := lcColorsArray[qualificationGroupStatus[Value]];
end;

function getCategoryColor(const Value: TCategorysStatus): TColor;
begin
  Result := lcColorsArray[categoryStatus[Value]];
end;

function getGridRowColor(const Value: TPingItem): TColor;
begin
  Result := lcColorsArray[Value];
end;

function getItemDesc(const Value: TPingItem; male: boolean): string;
begin
  if male then
    Result := pis[Value]
  else
    Result := pif[Value];
end;

function getCategorysDesc(const Value: TCategorysStatus): string;
begin
  Result := getItemDesc(categoryStatus[Value], False);
end;

function getRegistrationsDesc(const Value: TRegistrationStatus): string;
begin
  Result := getItemDesc(registrationStatus[Value], False);
end;

function getGamesDesc(const Value: TGameStatus): string;
begin
  Result := getItemDesc(gameStatus[Value], True);
end;

function getGamesColor(const Value: TGameStatus): TColor;
begin
  Result := getGamesColor(Value);
end;

function getPlayAreasDesc(const Value: TPlayAreaStatus): string;
begin
  Result := getItemDesc(playAreaStatus[Value], False);
end;

function getPlayAreasColor(const Value: TPlayAreaStatus): TColor;
begin
  Result := getItemsColor(playAreaStatus[Value]);
end;

function getUmpiresColor(const Value: TPlayAreaStatus): TColor;
begin
  Result := getItemsColor(playAreaStatus[Value]);
end;

function getArenaLayout(trn: TTournament): TArenaLayout;
begin
  Result := nil;
end;

procedure setAsUmpire(const sertrn, serjou: integer; const nomjou: string; const numtbl: smallint);
begin
  with getROQuery(lcCnx) do
  begin
    try
      SQL.Add('UPDATE umpires'
             +' SET umpire = :umpire'
             +'    ,serump = :serump'
             +' WHERE numtbl = :numtbl'
             +'   AND sertrn = :sertrn');
      Params[0].AsString := nomjou;
      Params[1].AsInteger := serjou;
      Params[2].AsInteger := numtbl;
      Params[3].AsInteger := sertrn;
      ExecSQL;
    finally
      Free;
    end;
  end;
end;

procedure setPlayAreaStatus(const numtbl: smallint; status: TPlayAreaStatus);
begin
  with getROQuery(lcCnx) do
  begin
    try
      SQL.Add('update umpires'
             +' set statbl = ' + Ord(status).ToString
             +' where numtbl = ' + numtbl.ToString);
      ExecSQL;
      broadcastMessage(wm_playAreaRefresh,numtbl,Ord(status));
    finally
      Free;
    end;
  end;
end;

procedure updateCategoryStatut(const sercat: integer; const Value: TCategorysStatus);
begin
  with getROQuery(lcCnx) do
  begin
    try
      SQL.Add('update categories set stacat = :stacat where sercat = :sercat');
      Params[0].Value := Value;
      Params[1].AsInteger := sercat;
      ExecSQL;
    finally
      Free;
    end;
  end;
  BroadcastMessage(wm_categChanged,sercat,Ord(Value));
end;

procedure beginGame(const sertrn,sermtc: integer; const numtbl: smallint);
begin
  with getROQuery(lcCnx) do
  begin
    try
      lcCnx.startTransaction;
      try
        SQL.Add('update match'
               +' set stamtc = ' + Ord(gsInProgress).ToString
               +'    ,numtbl = ' + numtbl.ToString
               +'    ,heure  = ' + FormatDateTime('hh:nn',Now).QuotedString
               +' where sermtc = ' + sermtc.ToString);
        ExecSQL;
        SQL.Clear;
        SQL.Add('update umpires'
               +' set statbl = ' + Ord(pasBusy).ToString
               +'    ,sermtc = ' + sermtc.ToString
               +' where numtbl = ' + numtbl.ToString
               +'   and sertrn = ' + sertrn.ToString);
        ExecSQL;
        lcCnx.commit;
        broadcastMessage(wm_beginGame,sermtc,numtbl);
        SQL.Clear;
        SQL.Add('SELECT sertab FROM match WHERE sermtc = :sermtc');
        Params[0].AsInteger := sermtc;
        Open;
        CheckAndSetCategorieStatusAfterUpdate(Fields[0].AsInteger);
        Close;
      except
        lcCnx.rollback;
        raise;
      end;
    finally
      Free;
    end;
  end;
end;

procedure endGame(const sertrn,sermtc,serWinner,serLoser: integer; const numtbl: smallint; const loserName: string);
begin
  with getROQuery(lcCnx) do
  begin
    try
      SQL.Add('update umpires'
             +' set statbl = ' + Ord(pasAvailable).ToString
             +'    ,sermtc = 0'
             +'    ,prvmtc = ' + sermtc.ToString
             +'    ,serump = ' + serLoser.ToString
             +'    ,umpire = ' + loserName.QuotedString
             +' where numtbl = ' + numtbl.ToString
             +'   and sertrn = ' + sertrn.ToString);
      ExecSQL;
    finally
      Free;
    end;
  end;
end;

procedure BeginQualificationGroup(const sertrn, sergrp: integer; const numtbl: smallint);
begin
  with getROQuery(lcCnx) do
  begin
    try
      lcCnx.startTransaction;
      try
        { Matchs du groupe à encours }
        SQL.Add('UPDATE match'
               +' SET heure = :heure'
               +'    ,numtbl = :numtbl'
               +'    ,stamtc = :stamtc'
               +'    ,modifie = CURRENT_TIMESTAMP'
               +' WHERE sermtc IN (SELECT sermtc FROM match_groupe WHERE sergrp = :sergrp)');
        Params[0].asString := FormatDateTime('hh:nn', Time);
        Params[1].AsInteger := numtbl;
        Params[2].AsInteger := Ord(gsInProgress);
        Params[3].AsInteger := sergrp;
        ExecSQL;

        { Play area }
        SQL.Clear;
        SQL.Add('UPDATE umpires'
               +' SET statbl = :statbl'
               +'    ,sermtc = :sergrp'
               +'    ,serump = NULL'
               +'    ,umpire = :umpire'
               +' WHERE numtbl = :numtbl'
               +'   AND sertrn = :sertrn');
        Params[0].AsInteger := Ord(pasBusy);
        Params[1].AsInteger := sergrp;
        Params[2].AsString  := 'QUALIFICATION';
        Params[3].AsInteger := numtbl;
        Params[4].AsInteger := sertrn;
        ExecSQL;

        { Groupe }
        SQL.Clear;
        SQL.Add('UPDATE groupe'
               +' SET heure = :heure'
               +'    ,stagrp = :stagrp'
               +' WHERE sergrp = :sergrp');
        Params[0].asString := FormatDateTime('hh:nn', Time);
        Params[1].AsInteger := Ord(qgsInProgress);
        Params[2].AsInteger := sergrp;
        ExecSQL;

        lcCnx.commit;
      except
        lcCnx.rollback;
        raise;
      end;
    finally
      Free;
    end;
  end;
end;

{ TSetResult }

procedure cancelGame(const sermtc: integer);
var
  lcSertab,
  lcNumtbl,
  lcSertrn: integer;
begin
  with getROQuery(lcCnx) do
  begin
    try
      SQL.Add('SELECT sertrn,numtbl,sertab FROM match WHERE sermtc = ' + sermtc.ToString);
      Open;
      lcSertrn := Fields[0].AsInteger;
      lcNumtbl := Fields[1].AsInteger;
      lcSertab := Fields[2].AsInteger;
      Close;
      SQL.Clear;
      SQL.Add('UPDATE match SET'
             +'  heure = NULL'
             +' ,score = NULL'
             +' ,vainqueur = NULL'
             +' ,perdant = NULL'
             +' ,numtbl = NULL'
             +' ,stamtc = ' + Ord(gsInactive).ToString
             +' ,games = NULL'
             +' ,woj1 = 0'
             +' ,woj2 = 0'
             +' ,modifie = NULL'
             +' WHERE sermtc = ' + sermtc.ToString);
      lcCnx.startTransaction;
      try
        ExecSQL;
        SQL.Clear;
        SQL.Add('update umpires'
               +' set statbl = ' + Ord(pasAvailable).ToString
               +'    ,sermtc = 0'
               +' where numtbl = ' + lcNumtbl.ToString
               +'   and sertrn = ' + lcSertrn.ToString);
        ExecSQL;
        lcCnx.commit;
      except
        lcCnx.rollback;
        raise;
      end;
    finally
      Free;
    end;
  end;
  broadcastMessage(wm_gameCanceled,sermtc,lcSertab);
end;

procedure TogglePhase(const sercat: integer; Fieldname: string);
var
  phase: TFirstRoundMode;
begin
  with getROQuery(lcCnx) do
  begin
    try
      SQL.Add('SELECT ' + Fieldname +' FROM categories WHERE sercat = ' + sercat.ToString);
      Open;
      phase := TFirstRoundMode(Fields[0].AsInteger);
      Close;
      SQL.Clear;
      SQL.Add('UPDATE categories SET ' + Fieldname + ' = :phase WHERE sercat = :sercat');
      Params[1].AsInteger := sercat;
      case phase of
        frKO: phase := frQualification;
        frQualification: phase := frKO;
      end;
      Params[0].AsInteger := Ord(phase);
      ExecSQL;
      if (Fieldname = 'first_round_mode') and (phase = frKO) then
      begin
        SQL.Clear;
        SQL.Add('UPDATE categories SET phase = ' + Ord(frKO).ToString
               +' WHERE sercat = ' + sercat.ToString);
        ExecSQL;
      end;

    finally
      Free;
    end;
  end;
end;

procedure QualifySeeds(const sercat: integer);
var
  nbrgrp,min,max: integer;
  z: TZReadOnlyQuery;
begin
  z := getROQuery(lcCnx);
  try
    z.SQL.Add('SELECT taille,nbrjou FROM tableau WHERE sertab = :sercat');
    z.Params[0].AsInteger := sercat;
    z.Open;
    { déterminer le nombre de groupes de 3 }
    nbrgrp := z.FieldByName('nbrjou').AsInteger div 3;
    { passer à non-qualifié les joueurs des groupes hors tds }
    min := Succ(z.FieldByName('nbrjou').AsInteger - nbrgrp*3);
    max := z.FieldByName('taille').AsInteger;
    z.Close;
    z.SQL.Clear;
    z.SQL.Add('UPDATE tableau SET nbrgrp = :nbrgrp WHERE sertab = :sercat');
    z.Params[0].AsInteger := nbrgrp;
    z.Params[1].AsInteger := sercat;
    z.ExecSQL;
    z.SQL.Clear;
    z.SQL.Add('UPDATE prptab SET is_qualified = :is_qualified'
             +' WHERE sertab = :sercat'
             +'   AND numtds BETWEEN :min AND :max');
    z.Params[0].AsInteger := ord(rsDisqualified);
    z.Params[1].AsInteger := sercat;
    z.Params[2].AsInteger := min;
    z.Params[3].AsInteger := max;
    z.ExecSQL;
  finally
    z.Free;
  end;
end;

function CreateQualificationGroup(const sercat, sertrn,
  numgrp: integer): integer;
var
  z: TZReadOnlyQuery;
  seq: TLalSequence;
begin
  seq := nil;
  z := getROQuery(lcCnx);
  try
    z.SQL.Add('SELECT sergrp FROM groupe'
             +' WHERE sercat = :sercat'
             +'   AND numgrp = :numgrp');
    z.Params[0].AsInteger := sercat;
    z.Params[1].AsInteger := numgrp;
    z.Open;
    if (z.Fields[0].IsNull) or (z.Fields[0].AsInteger = 0) then
    begin
      z.Close;
      z.SQL.Clear;
      z.SQL.Add('INSERT INTO groupe (sergrp,sercat,numgrp,stagrp,sertrn)'
               +' VALUES (:sergrp,:sercat,:numgrp,:stagrp,:sertrn)');
      seq := TLalSequence.Create(nil, lcCnx);
      z.Params[0].AsInteger := Seq.SerialByName('CATEGORIE');
      z.Params[1].AsInteger := sercat;
      z.Params[2].AsInteger := numgrp;
      z.Params[3].AsInteger := Ord(qgsInactive);
      z.Params[4].AsInteger := sertrn;
      z.ExecSQL;
      Result := z.Params[0].AsInteger;
    end
    else
    begin
      Result := z.Fields[0].AsInteger;
      z.Close;
    end;
  finally
    z.Free;
    seq.Free;
  end;
end;

function InsertIntoQualificationGroup(const sergrp, serjou,
  sercat, sertrn: integer): integer;
var
  z: TZReadOnlyQuery;
begin
  Result := 1;
  z := getROQuery(lcCnx);
  try
    z.SQL.Add('SELECT MAX(numseq) FROM compo_groupe'
             +' WHERE sergrp = :sergrp');
    z.Params[0].AsInteger := sergrp;
    z.Open;
    if not(z.Eof) and (z.Fields[0].AsInteger > 0) then
      Result := Succ(z.Fields[0].AsInteger);
    z.Close;
    z.SQL.Clear;
    z.SQL.Add('INSERT INTO compo_groupe (sergrp,numseq,serjou,sercat,sertrn)'
             +' VALUES (:sergrp,:numseq,:serjou,:sercat,:sertrn)');
    z.Params[0].AsInteger := sergrp;
    z.Params[1].AsInteger := Result;
    z.Params[2].AsInteger := serjou;
    z.Params[3].AsInteger := sercat;
    z.Params[4].AsInteger := sertrn;
    z.ExecSQL;
    z.SQL.Clear;
    z.SQL.Add('UPDATE prptab SET sergrp = :sergrp'
             +' WHERE sertab = :sercat'
             +'   AND serjou = :serjou');
    z.Params[0].AsInteger := sergrp;
    z.Params[1].AsInteger := sercat;
    z.Params[2].AsInteger := serjou;
    z.ExecSQL;
  finally
    z.Free;
  end;
end;

procedure UpdateQualificationGroupStatus(const sergrp: integer; const status: TQualificationGroupStatus);
var
  z: TZReadOnlyQuery;
begin
  z := getROQuery(lcCnx);
  try
    z.SQL.Add('UPDATE groupe SET stagrp = :stagrp'
             +' WHERE sergrp = :sergrp');
    z.Params[0].AsInteger := Ord(status);
    z.Params[1].AsInteger := sergrp;
    z.ExecSQL;
  finally
    z.Free;
  end;
end;

procedure broadcastMessage(const msg, wparam, lparam: integer);
var
  i: integer;
begin
  for i := 0 to Screen.FormCount - 1 do
    Screen.Forms[i].Perform(msg,wparam,lparam);
end;

{ TTournamentSettings }

const
  tsSettings: string = 'settings';
  tsWorkingDirectory: string = 'workingDirectory';
  tsTournamentsDirectory: string = 'tournamentsDirectory';
  tsExportDirectory: string = 'exportDirectory';
  tsTemplatesDirectory: string = 'templatesDirectory';
  tsFLTTResultsDocument: string = 'FLTTResultsDocument';
  tsDrawTemplate: string = 'DrawTemplate';
  tsPardic1: string = 'pardc1';
  tsSeekConfigs: string = 'SeekControls';

constructor TTournamentSettings.Create(cnx: TLalConnection; TextValues: TStrings);
begin
  inherited Create(cnx);
  FSeekConfigs := TStringList.Create;
  FTextValues := TStringList.Create;
  FTextValues.AddStrings(TextValues);
end;

destructor TTournamentSettings.Destroy;
begin
  FTextValues.Free;
  FSeekConfigs.Free;
  inherited;
end;

procedure TTournamentSettings.DoRead;
var
  z: TZReadOnlyQuery;
begin
  FSeekConfigs.Clear;
  z := TZReadOnlyQuery.Create(nil);
  with z do
  begin
    try
      Connection := Self.Connection;
      SQL.Add('SELECT coddic,pardc1'
             +' FROM dictionnaire'
             +' WHERE cledic = :cledic'
             +' ORDER BY coddic');
      Params[0].AsString := tsSeekConfigs;
      Open;
      while not Eof do
      begin
        FSeekConfigs.Values[FieldByName('coddic').AsString] := FieldByName('pardc1').AsString;
        Next;
      end;
      Close;

      SQL.Clear;
      SQL.Add('SELECT pardc1'
             +' FROM dictionnaire'
             +' WHERE cledic = :cledic'
             +'   AND coddic = :coddic');
      Prepare;
      Params[0].AsString := cs_settings;

      BuildPathSettings(pvWorkingDirectory, 'WorkingDirectory', Format('%s\PING',[ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))]), z);
      BuildPathSettings(pvTournamentsDirectory, 'TournamentsDirectory', Format('%s\Tournois',[pvWorkingDirectory]), z);
      BuildPathSettings(pvTemplatesDirectory, 'TemplatesDirectory', Format('%s\Templates',[pvWorkingDirectory]), z);
      BuildTemplateFilenameSettings(pvFLTTResultsDocument, 'FLTTResultsDocument', 'modResults.xltx', z);
      BuildTemplateFilenameSettings(pvDrawTemplate, 'DrawTemplate', 'Draw_%d.xltx', z);
      BuildTemplateFilenameSettings(pvQualificationGroupTemplate, 'QualificationGroupTemplate', 'Group_%d.xltm', z);
    finally
      Free;
    end;
  end;
end;

procedure TTournamentSettings.BuildPathSettings(var Value: string; const Name, Path: string; const Query: TZReadOnlyQuery);
begin
  Value := FTextValues.Values[Name];      // lire le paramètres du fichier texte
  if Value = '' then
  begin
    { lire du dictionnaire }
    Query.Params[1].AsString := Name;
    Query.Open;
    try
      if not Query.Eof then
        Value := Query.Fields[0].AsString
      else
        Value := Path;
    finally
      Query.Close;
    end;
  end;

  Value := ExcludeTrailingPathDelimiter(Value);
  ForceDirectories(Value);
  FTextValues.Values[Name] := Value;
  Write(cs_settings, Name, 'pardc1', Value);
end;

procedure TTournamentSettings.BuildTemplateFilenameSettings(var Value: string; const Name, Filename: string; const Query: TZReadOnlyQuery);
begin
  Value := FTextValues.Values[Name];      // lire le paramètres du fichier texte
  if Value = '' then
  begin
    { lire du dictionnaire }
    Query.Params[1].AsString := Name;
    Query.Open;
    try
      if not Query.Eof then
        Value := Query.Fields[0].AsString
      else
        Value := Filename;  // valeur par défaut
    finally
      Query.Close;
    end;
  end;

  FTextValues.Values[Name] := Value;
  Write(cs_settings, Name, 'pardc1', Value);
end;

procedure TTournamentSettings.DoWrite;
var
  i: integer;
begin
  with TZReadOnlyQuery.Create(nil) do
  begin
    try
      Connection := Self.Connection;
      SQL.Add('UPDATE OR INSERT INTO dictionnaire (cledic,coddic,pardc1)'
             +' VALUES (:cledic,:coddic,:pardc1)');
      Prepare;
      Params[0].AsString := tsSeekConfigs;
      for i := 0 to FSeekConfigs.Count-1 do
      begin
        Params[1].AsString := FSeekConfigs.Names[i];
        Params[2].AsString := FSeekConfigs.ValueFromIndex[i];
        ExecSQL;
      end;

      Params[0].AsString := cs_settings;
      for i := 0 to FTextValues.Count-1 do
      begin
        Params[1].AsString := FTextValues.Names[i];
        Params[2].AsString := FTextValues.ValueFromIndex[i];
        try ExecSQL; except end;
      end;
    finally
      Free;
    end;
  end;
end;

function TTournamentSettings.GetDrawTemplate: string;
begin
  Result := pvDrawTemplate;
end;

function TTournamentSettings.getExportDirectory: string;
begin
  Result := ExcludeTrailingPathDelimiter(pvExportDirectory);
end;

function TTournamentSettings.GetExportsTo: string;
begin
  Result := Format('%s\%s\%s',[WorkingDirectory,TournamentsDirectory,ExportDirectory]);
end;

function TTournamentSettings.GetFirstRoundMode: TFirstRoundMode;
var
  def: string;
  value: integer;
begin
  def := TEnum.AsString<TFirstRoundMode>(frKO);
  value := TEnum.AsInteger<TFirstRoundMode>(TFirstRoundMode(getEnumValue(TypeInfo(TFirstRoundMode), Read(cs_settings,cs_firstRoundMode,cs_pardc1,def))));
  Result := TFirstRoundMode(value);
end;

function TTournamentSettings.getFLTTResultsDocument: string;
begin
  Result := pvFLTTResultsDocument;
end;

function TTournamentSettings.getFLTTResultsTemplate: string;
begin
  Result := Format('%s\%s\%s', [WorkingDirectory,TemplatesDirectory,FLTTResultsDocument]);
end;

function TTournamentSettings.GetGroupTemplate: string;
begin
  Result := pvQualificationGroupTemplate;
end;

function TTournamentSettings.GetSeekCodeCategoryStatus: string;
begin
  Result := GetEnumerationName(TypeInfo(TCategorysStatus));
end;

function TTournamentSettings.GetSeekCodeClub: string;
begin
  Result := SeekConfigs.Values[cs_code_club_seek_code];
end;

function TTournamentSettings.GetSeekCodeFirstRoundMode: string;
begin
  Result := GetEnumerationName(TypeInfo(TFirstRoundMode));
end;

function TTournamentSettings.GetSeekCodeSaison: string;
begin
  Result := SeekConfigs.Values[cs_saison_seek_code];
end;

function TTournamentSettings.getTemplatesDirectory: string;
begin
  Result := ExcludeTrailingPathDelimiter(pvTemplatesDirectory);
end;

function TTournamentSettings.getTournamentsDirectory: string;
begin
  Result := ExcludeTrailingPathDelimiter(pvTournamentsDirectory);
end;

function TTournamentSettings.getWorkingDirectory: string;
begin
  Result := ExcludeTrailingPathDelimiter(pvWorkingDirectory);
end;

procedure TTournamentSettings.SaveToFile(const Filename: TFilename);
begin
  FTextValues.SaveToFile(Filename);
end;

procedure TTournamentSettings.SetExportDirectory(const Value: string);
begin
  pvExportDirectory := ExcludeTrailingPathDelimiter(Value);
end;

procedure TTournamentSettings.SetFirstRoundMode(const Value: TFirstRoundMode);
begin
  Write(cs_settings,cs_firstRoundMode,cs_pardc1,GetEnumerationNameFromValue(TypeInfo(TFirstRoundMode),Ord(Value)));
end;

procedure TTournamentSettings.SetFLTTResultsDocument(const Value: string);
begin
  pvFLTTResultsDocument := ExtractFileName(Value);
end;

procedure TTournamentSettings.SetTemplatesDirectory(const Value: string);
begin
  pvTemplatesDirectory := ExcludeTrailingPathDelimiter(Value);
end;

procedure TTournamentSettings.SetTournamentsDirectory(const Value: string);
begin
  pvTournamentsDirectory := ExcludeTrailingPathDelimiter(Value);
end;

procedure TTournamentSettings.SetWorkingDirectory(const Value: string);
begin
  pvWorkingDirectory := ExcludeTrailingPathDelimiter(Value);
end;

function buildExportDirectory(const sertrn: integer): string;
var
  expdir: string;
  sr: TSearchRec;
  st: TSystemTime;
begin
  with getROQuery(lcCnx) do
  begin
    try
      SQL.Add('SELECT codclb,expcol,saison'
               +' FROM tournoi'
               +' WHERE sertrn = ' + sertrn.ToString);
      Open;
      expdir := FieldByName('expcol').AsString;
      if (expdir = '') then
      begin
        if (FieldByName('codclb').AsString = '') then
          expdir := FieldByName('codclb').AsString
        else
          expdir := 'EXP';
      end;
      {: read the files in directory.
         If one is today
           created then return this
         else
           create new one
      }
      glSettings.Read;
      Result := Format('%s\%s',[glSettings.ExportsTo,expdir]);
      if SysUtils.FindFirst(Result+'\*',faDirectory, sr) = 0 then
      begin
        try
          repeat
            if (sr.Attr and faDirectory) = 0 then
              Continue;
            if (sr.Name = '.') or (sr.Name = '..') then
              Continue;
            FileTimeToSystemTime(sr.FindData.ftCreationTime, st);

            if IsToday(EncodeDate(st.wYear,st.wMonth,st.wDay)) then
            begin
              Result := Format('%s\%s\%s',[glSettings.ExportsTo,expdir,sr.Name]);
              Break;
            end;
          until SysUtils.FindNext(sr) <> 0;
        finally
          SysUtils.FindClose(sr);
        end;
      end;

      if Result = Format('%s\%s',[glSettings.ExportsTo,expdir]) then
      begin
        Result := Format('%s\%s\%d',[glSettings.ExportsTo,expdir,FieldByName('saison').AsInteger]);
        ForceDirectories(Result);
      end;

      Close;
    finally
      Free;
    end;
  end;
end;

function createResultsFLTTDocument(const sertrn: integer): string;
var
  dir,filename,expdir: string;
  w,z,y,cats: TZReadOnlyQuery;
  xls,wkb,sht: variant;
  row,col,numcat,arow: integer;
const
  colonne: array[0..1] of integer = (8,2);
begin
  z := getROQuery(lcCnx);
  try
    Screen.Cursor := crHourglass;
    z.SQL.Add('SELECT codclb,expcol,saison'
             +' FROM tournoi'
             +' WHERE sertrn = ' + sertrn.ToString);
    z.Open;
    dir := buildExportDirectory(sertrn);
    if not DirectoryExists(dir) then
    begin
      expdir := z.FieldByName('expcol').AsString;
      if (expdir = '') then
      begin
        if (z.FieldByName('codclb').AsString = '') then
          expdir := z.FieldByName('codclb').AsString
        else
          expdir := 'EXP';
      end;

      glSettings.Read;
      dir := Format('%s\%s\%d', [glSettings.GetExportsTo,expdir,z.Fields[2].AsInteger]);
      row := 0;
      while DirectoryExists(dir) do
      begin
        Inc(row);
        dir := Format('%s\%s\%d(%.2d)', [glSettings.GetExportsTo,expdir,z.Fields[2].AsInteger,row]);
      end;
      ForceDirectories(dir);
    end;
    filename := Format('%s\%d',[dir,z.Fields[2].AsInteger]);
    z.Close;
    z.SQL.Clear;
    createExcelWorkbook(xls,wkb,sht,True,glSettings.FLTTResultsTemplate);
    z.SQL.Add('select dattrn,organisateur,libelle from tournoi where sertrn = :sertrn');
    z.Params[0].AsInteger := sertrn;
    z.Open;
    row := 1;
    sht.Cells[row,01] := z.FieldByName('libelle').AsString;
    Inc(row);
    sht.Cells[row,01] := Format('%s - %s',[z.FieldByName('dattrn').AsString,z.FieldByName('organisateur').AsString]);
    z.Close;
    cats := getROQuery(lcCnx);
    try
      cats.SQL.Add('select a.sercat,numseq,codcat, count(*) presents'
                  +' from categories a, insc b'
                  +' where a.sertrn = :sertrn'
                  +'   and a.sertrn = b.sertrn'
                  +'   and a.sercat = b.sercat'
                  +'   and b.statut < :statut'
                  +' group by 1,2,3'
                  +' order by 2,3');
      y := getROQuery(lcCnx);
      try
        y.SQL.Add('select nomjou,codcls,libclb'
                 +' from tablo'
                 +' where sertab = :sertab'
                 +'   and serjou = :serjou');
        y.Prepare;

        w := getROQuery(lcCnx);
        try
          w.SQL.Add('select first 3 codcls,count( * )'
                   +' from insc a, tablo b'
                   +' where a.sercat = b.sertab'
                   +'   and a.sercat = :sercat'
                   +'   and a.serjou = b.serjou'
                   +'   and b.codcls in (select codcls from classements x'
                   +'                     where a.sercat = x.sercat)'
                   +'   and statut < :statut'
                   +' group by 1'
                   +' order by 1');
          w.Prepare;
          w.ParamByName('statut').Value := rsWO;

          cats.ParamByName('sertrn').AsInteger := sertrn;
          cats.ParamByName('statut').Value := rsWO;
          cats.Open;
          numcat := 0;
          Inc(row,2);
          while not cats.Eof do
          begin
            Inc(numcat);
            col := colonne[numcat mod 2];
            sht.Cells[row,col] := Format('%s (%d présents)',[cats.FieldByName('codcat').AsString,cats.FieldByName('presents').AsInteger]);
            z.sql.clear;
            z.sql.add('select handicap,catage from categories'
                     +' where sercat = :sercat');
            z.Params[0].AsInteger := cats.FieldByName('sercat').AsInteger;
            z.Open;
            if (z.Fields[0].AsInteger = 0) and (z.Fields[1].AsInteger = 0) then
            begin
              w.ParamByName('sercat').AsInteger := z.Params[0].AsInteger;
              w.Open;
              while not w.Eof do
              begin
                Inc(col);
                sht.Cells[row,col] := w.Fields[1].AsInteger;
                w.Next;
                Application.ProcessMessages;
              end;
              w.Close;
            end;
            z.Close;
            col := colonne[numcat mod 2];
            arow := row;
            Inc(arow,2);
            z.SQL.Clear;
            z.SQL.Add('select first 1 vainqueur,perdant'
                     +' from match a'
                     +' where sertab = :sertab'
                     +' order by nummtc desc');
            z.ParamByName('sertab').AsInteger := cats.FieldByName('sercat').AsInteger;
            z.Open;
            y.ParamByName('sertab').AsInteger := z.ParamByName('sertab').AsInteger;
            y.ParamByName('serjou').AsInteger := z.FieldByName('vainqueur').AsInteger;
            y.Open;
            sht.Cells[arow,col] := Format('%s, %s, %s',[y.FieldByName('nomjou').AsString,y.FieldByName('codcls').AsString,y.FieldByName('libclb').AsString]);
            y.Close;
            Inc(arow);
            y.ParamByName('serjou').AsInteger := z.FieldByName('perdant').AsInteger;
            y.Open;
            sht.Cells[arow,col] := Format('%s, %s, %s',[y.FieldByName('nomjou').AsString,y.FieldByName('codcls').AsString,y.FieldByName('libclb').AsString]);
            y.Close;
            z.Close;
            z.SQL.Clear;
            z.SQL.Add('select first 2 skip 1 perdant'
                     +' from match a'
                     +' where sertab = :sertab'
                     +' order by nummtc desc');
            z.ParamByName('sertab').AsInteger := cats.FieldByName('sercat').AsInteger;
            z.Open;
            while not z.Eof do
            begin
              Inc(arow);
              y.ParamByName('serjou').AsInteger := z.FieldByName('perdant').AsInteger;
              y.Open;
              sht.Cells[arow,col] := Format('%s, %s, %s',[y.FieldByName('nomjou').AsString,y.FieldByName('codcls').AsString,y.FieldByName('libclb').AsString]);
              y.Close;
              z.Next;
              Application.ProcessMessages;
            end;
            if (numcat mod 2) = 0 then
              Inc(row,7);
            cats.Next;
            Application.ProcessMessages;
          end;
          cats.Close;
        finally
          w.Free;
        end;
      finally
        y.Free;
      end;
    finally
      cats.Free;
    end;
  finally
    z.Free;
    Screen.Cursor := crDefault;
  end;
  wkb.SaveAs(Format('%s.xlsx',[filename]), AddToMRU:=True);
  { export du tablo en pdf }
  sht.ExportAsFixedFormat(xlTypePDF,filename);
end;

procedure Draw2Excel(const sertab: integer; const score,complet: boolean; const Path: TFilename);
var
  xls,
  wkb,
  sht,
  PageSetup: variant;
  z: TZReadOnlyQuery;
  row,taille: integer;
  template,
  j1,j2: string;
  ExportFileName: TFileName;
  i: Integer;
  phase: TFirstRoundMode;
begin
  z := getROQuery(lcCnx);
  try
    Screen.Cursor := crHourglass;
    z.SQL.Add('SELECT a.dattrn,a.organisateur,a.libelle,b.codcat,b.phase,c.nbrjou'
//             +'  ,c.taille,c.nbrjou'
             +'      ,CASE b.phase'
             +'         WHEN 0 THEN c.taille'
             +'         WHEN 1 THEN ROUND(c.nbrjou/3, 0)'
             +'       END taille'
             +' FROM tournoi a, categories b, tableau c'
             +' WHERE a.sertrn = b.sertrn'
             +'   AND b.sercat = c.sertab'
             +'   AND c.sertab = :sertab');
    z.ParamByName('sertab').AsInteger := sertab;
    z.Open;
    taille := z.FieldByName('taille').AsInteger;
    phase := z.FieldByName('phase').Value;
    glSettings.Read;

    case phase of
      frKO:            template := Format(glSettings.DrawTemplate,[taille]);
      frQualification: template := Format(glSettings.GroupTemplate, [3]);
    end;
    template := Format('%s\%s', [glsettings.TemplatesDirectory, template]);

    createExcelWorkbook(xls,wkb,sht,True,template);

    { onglet tableau du fichier excel }
    sht := wkb.Worksheets['tableau'];
    sht.Select;
    sht.Cells[1,2] := FormatDateTime('dddd dd mmmm yyyy', z.FieldByName('dattrn').AsDateTime);
    sht.Cells[2,2] := z.FieldByName('libelle').AsString;
    sht.Cells[3,2] := z.FieldByName('codcat').AsString;
    sht.Cells[4,2] := Format('%d participants',[z.FieldByName('nbrjou').AsInteger]);

    { phase de tableau qualification directe }
    if z.FieldByName('phase').value = frKO then
    begin
      z.Close;
      z.SQL.Clear;
      z.SQL.Add('SELECT codcls,count(*) FROM tablo WHERE sertab = :sertab'
               +' AND serjou > 0 GROUP BY 1 ORDER BY 1');
      z.ParamByName('sertab').AsInteger := sertab;
      z.Open;
      sht.Cells[5,1] := 'dont';
      sht.cells[5,2] := Format('%d %s',[z.Fields[1].AsInteger,z.Fields[0].AsString]);
      z.Close;

      { positions }
      sht := wkb.Worksheets['position'];
      sht.Select;
      row := 2;
      z.SQL.Clear;
      z.SQL.Add('select serblo,sertab,serjou,licence,nomjou,codclb,libclb,codcls,numtds,numrow,sertrn'
               +' from tablo'
               +' where sertab = :sertab'
               +'   and coalesce(serjou,0) > 0'
               +' order by numtds');
      z.ParamByName('sertab').AsInteger := sertab;
      z.Open;
      while not z.Eof  do
      begin
        Inc(row);
        if z.FieldByName('nomjou').AsString <> 'BYE' then
        begin
          sht.Cells[row,3] := z.FieldByName('libclb').AsString;
          sht.Cells[row,4] := z.FieldByName('licence').AsString;
          sht.Cells[row,5] := z.FieldByName('nomjou').AsString;
          sht.Cells[row,6] := z.FieldByName('codcls').AsString;
          sht.Cells[row,8] := z.FieldByName('numrow').AsString;
        end;
        z.Next;
        Application.ProcessMessages;
      end;

      { exempts du 1er tour }
      sht := wkb.Worksheets['tablo'];
      sht.Select;
      row := 4;
      repeat
        j1 := sht.Cells[Pred(row),2];
        j2 := sht.Cells[Succ(row),2];
        if (j1<>'') and (j2='') then
          sht.Cells[row,3] := 'w'
        else if (j1='') and (j2<>'') then
          sht.Cells[Succ(row),3] := 'w';
        Inc(row,4);
      until (row > Succ(taille*2));

      z.Close;
      z.SQL.Clear;
      z.SQL.Add('select COUNT( * ) from match'
               +' where sertab = :sertab'
               +'   and stamtc = :stamtc');
      z.ParamByName('sertab').AsInteger := sertab;
      z.ParamByName('stamtc').Value := gsOver;
      z.Open;
      Games2excel(sertab,wkb,score,complet,phase,Path);
      z.Close;
    end
    else
    { phase de groupe }
    begin
      { positions }
      sht := wkb.Worksheets['position'];
      sht.Select;
      row := 2;

      if z.Active then z.Close;
      z.SQL.Clear;
      z.SQL.Add('SELECT grp.sergrp,grp.numgrp,cmp.numseq'
               +'      ,jou.licence,jou.nomjou,jou.codclb,clb.libclb,jou.codcls'
               +' FROM groupe grp'
               +'   LEFT JOIN compo_groupe cmp ON grp.sergrp = cmp.sergrp'
               +'   LEFT JOIN joueur jou ON cmp.serjou = jou.serjou'
               +'   LEFT JOIN club clb ON clb.codclb = jou.codclb'
               +' WHERE grp.sercat = :sercat'
               +' ORDER BY grp.numgrp,cmp.numseq');
      z.Params[0].AsInteger := sertab;
      z.Open;
      try
        while not z.Eof do
        begin
          Inc(row);
          if z.FieldByName('nomjou').AsString <> 'BYE' then
          begin
            sht.Cells[row,4] := z.FieldByName('libclb').AsString;
            sht.Cells[row,5] := z.FieldByName('licence').AsString;
            sht.Cells[row,6] := z.FieldByName('nomjou').AsString;
            sht.Cells[row,7] := z.FieldByName('codcls').AsString;
            sht.Cells[row,8] := z.FieldByName('numgrp').AsInteger;
            sht.cells[row,9] := z.FieldByName('numseq').AsInteger;
          end;
          z.Next;
          Application.ProcessMessages;
        end;
      finally
        z.Close;
      end;
      z.SQL.Clear;
      z.SQL.Add('SELECT codcat FROM categories WHERE sercat = ' + IntToStr(sertab));
      z.Open;
      ExportFileName := GetExportFilename(Path, z.Fields[0].AsString,phase);
      wkb.SaveAs(ExportFilename{, FileFormat:=xlOpenXMLWorkbookMacroEnabled}, AddToMRU:=True);
      z.Close;

      {sht.ExportAsFixedFormat(xlTypePDF,ChangeFileExt(ExportFileName,'.pdf'));}
      { export from sheet POULE1 to sheet POULE_taille }
      xls.PrintCommunication := False;
      for i := 1 to wkb.Worksheets.Count do
      begin
        PageSetup := wkb.Worksheets[i].PageSetup;
        PageSetup.FitToPagesWide := 1;
        PageSetup.FitToPagesTall := 1;
      end;
      xls.PrintCommunication := True;
      wkb.ExportAsFixedFormat(xlTypePDF,ChangeFileExt(ExportFileName,'.pdf'), From:=4, To:=4+taille-1);

    end;
  finally
    z.Free;
    Screen.Cursor := crDefault;
  end;
end;

procedure Games2Excel(const sertab: integer; const book: Variant; const score,complet: boolean; const Phase: TFirstRoundMode; const Path: TFilename);
var
  z: TZReadOnlyQuery;
  row,col,level,numseq,sertrn: integer;
  sht,rng: Variant;
  dir{,expdir,filename}: string;
  ExportFileName: TFileName;
//  FileIndex: integer;
begin
  z := getROQuery(lcCnx);
  try
    z.SQL.Add('select sertrn from tableau where sertab = :sertab');
    z.Params[0].AsInteger := sertab;
    z.Open;
    sertrn := z.Fields[0].AsInteger;
    z.Close;
    z.SQL.Clear;
    z.SQL.Add('select nummtc'
             +'  ,(select licence from tablo x where x.sertab = a.sertab and x.serjou = a.serjo1) "lic 1"'
             +'  ,(select licence from tablo x where x.sertab = a.sertab and x.serjou = a.serjo2) "lic 2"'
             +'  ,(select nomjou from tablo x where x.sertab = a.sertab and x.serjou = a.serjo1) "joueur 1"'
             +'  ,(select nomjou from tablo x where x.sertab = a.sertab and x.serjou = a.serjo2) "joueur 2"'
             +'  ,(select codcls from tablo x where x.sertab = a.sertab and x.serjou = a.serjo1) "cls 1"'
             +'  ,(select codcls from tablo x where x.sertab = a.sertab and x.serjou = a.serjo2) "cls 2"'
             +'  ,(select libclb from tablo x where x.sertab = a.sertab and x.serjou = a.serjo1) "club 1"'
             +'  ,(select libclb from tablo x where x.sertab = a.sertab and x.serjou = a.serjo2) "club 2"'
             +'  ,score,games'
             +' from match a, tablo b'
             +' where a.sertab = b.sertab'
             +'   and a.sertab =:sertab'
             +'   and a.vainqueur = b.serjou'
             +'   and a.perdant > 0'
             +' order by nummtc');
    z.ParamByName('sertab').AsInteger := sertab;
    z.Open;
    if not z.IsEmpty then
    begin
      if complet then
      begin
        { liste des matchs }
        row := 1;
        sht := book.Worksheets.Add;
        sht.Name := 'Matchs';
        sht.Select;
        sht.Cells[row,1] := 'Match n°';
        sht.Cells[row,2] := 'Joueur 1';
        sht.Cells[row,3] := 'Joueur 2';
        sht.Cells[row,4] := 'Score';
        sht.Cells[row,5] := 'Sets';
        while not z.Eof do
        begin
          Inc(row);
          sht.Cells[row,1] := Format('''%s',[z.FieldByName('nummtc').AsString]);
          if not complet then
          begin
            sht.Cells[row,2] := z.FieldByName('joueur 1').AsString;
            sht.Cells[row,3] := z.FieldByName('joueur 2').AsString;
          end
          else
          begin
            sht.Cells[row,2] := Format('%s - %s - %s - %s',[z.FieldByName('lic 1').AsString,z.FieldByName('joueur 1').AsString,z.FieldByName('cls 1').AsString,z.FieldByName('club 1').AsString]);
            sht.Cells[row,3] := Format('%s - %s - %s - %s',[z.FieldByName('lic 2').AsString,z.FieldByName('joueur 2').AsString,z.FieldByName('cls 2').AsString,z.FieldByName('club 2').AsString]);
          end;
          sht.Cells[row,4] := Format('''%s',[z.FieldByName('score').AsString]);
          sht.Cells[row,5] := Format('''%s',[z.FieldByName('games').AsString]);
          z.Next;
          Application.ProcessMessages;
        end;
        rng := sht.Range[Format('A1:E%d',[row])];
        makeTableau(sht,rng,'matchs');
        autoSizeWorksheetColumns(sht);
      end;
      { inscription des scores dans le tablo }
      sht := book.Worksheets['tablo'];
      sht.Select;
      row := 1;
      col := 1;
      z.SQL.Clear;

      z.SQL.Add('select level,numseq,score,games'
               +'   ,licence,nomjou,codcls,libclb,serjo1,serjo2'
               +' from match a, tablo b'
               +' where a.sertab = b.sertab'
               +'   and a.sertab = :sertab'
               +'   and a.vainqueur = b.serjou'
               +' order by nummtc');
      z.parambyname('sertab').asinteger := sertab;
      z.Open;
      while not z.Eof do
      begin
        level := z.FieldByName('level').AsInteger;
        numseq := z.FieldByName('numseq').AsInteger;
        col := 2 * Pred(level) + 4;
        //2+(POWER(2;Q$1))+1+($P2-1)*POWER(2;Q$1+1)
        row := Trunc(2 + (Power(2,level))+1+Pred(numseq)*Power(2,Succ(level)));

        if not complet then
          sht.Cells[Pred(row), col] := z.FieldByName('nomjou').AsString
        else
          sht.Cells[Pred(row), col] := Format('%s - %s - %s - %s',[z.FieldByName('licence').AsString,z.FieldByName('nomjou').AsString,z.FieldByName('codcls').AsString,z.FieldByName('libclb').AsString]);

        if score then
        begin
          if z.FieldByName('score').AsString <> 'WO' then
          begin
            if z.FieldByName('games').AsString <> '' then
              sht.Cells[row, col] := Format('''%s',[z.FieldByName('games').AsString])
            else
              sht.Cells[row, col] := Format('''%s',[z.FieldByName('score').AsString]);
          end
          else
          begin
            sht.Cells[row, col] := Format('''%s',[z.FieldByName('score').AsString]);
            rng := sht.Cells[row, col];
            rng.Interior.Color := clLime;
          end;
        end;
        z.Next;
        Application.ProcessMessages;
      end;
    end;
    z.Close;

    { 4 premiers dans l'onglet tableau }
    if complet or True then
    begin
      sht := book.Worksheets['tableau'];
      sht.Select;
      { le tableau est en C6, la place de premier en C7 }
      row := 7;
      col := 3;
      z.SQL.Clear;
      z.SQL.Add('select vainqueur from match where sertab = :sertab'
               +'  and prochain is null');
      z.ParamByName('sertab').AsInteger := sertab;
      z.Open;
      if not z.IsEmpty then
      begin
        z.Close;
        z.SQL.Clear;
        { premier }
        z.SQL.Add('select nomjou||'', ''||codcls||'', ''||libclb'
                 +'   ,level'
                 +' from match a, tablo b'
                 +' where a.sertab = :sertab'
                 +'   and a.level = (select max(level) from match x where x.sertab = a.sertab)'
                 +'   and a.sertab = b.sertab'
                 +'   and a.vainqueur = b.serjou');
        z.ParamByName('sertab').AsInteger := sertab;
        z.Open;
        level := z.FieldByName('level').AsInteger;
        sht.Cells[row,col] := z.Fields[0].AsString;
        z.Close;
        z.SQL.Clear;
        { deuxième }
        z.SQL.Add('select nomjou||'', ''||codcls||'', ''||libclb'
                 +' from match a, tablo b'
                 +' where a.sertab = :sertab'
                 +'   and a.level = :level'
                 +'   and a.sertab = b.sertab'
                 +'   and a.perdant = b.serjou');
        z.ParamByName('sertab').AsInteger := sertab;
        z.ParamByName('level').AsInteger := level;
        z.Open;
        Inc(row);
        sht.Cells[row,col] := z.Fields[0].AsString;
        z.Close;
        { troisièmes }
        z.SQL.Clear;
        z.SQL.Add('select nomjou||'', ''||codcls||'', ''||libclb'
                 +' from match a, tablo b'
                 +' where a.sertab = :sertab'
                 +'   and a.level = :level'
                 +'   and a.sertab = b.sertab'
                 +'   and a.perdant = b.serjou');
        z.ParamByName('sertab').AsInteger := sertab;
        z.ParamByName('level').AsInteger := Pred(level);
        z.Open;
        while not z.Eof do
        begin
          Inc(row);
          sht.Cells[row,col] := z.Fields[0].AsString;
          z.Next;
        end;
        z.Close;
      end;

      sht := book.Worksheets['tablo'];
      sht.Select;
      if z.Active then
        z.Close;

      z.SQL.Clear;
      z.SQL.Add('SELECT codclb,expcol,saison'
               +' FROM tournoi'
               +' WHERE sertrn = ' + sertrn.ToString);
      z.Open;

      if Path <> '' then
      begin
        dir := Path;
//        FileIndex := 0;
//        dir := buildExportDirectory(sertrn);
//        if not DirectoryExists(dir) then
//        begin
//          expdir := z.FieldByName('expcol').AsString;
//          if (expdir = '') then
//          begin
//            if (z.FieldByName('codclb').AsString = '') then
//              expdir := z.FieldByName('codclb').AsString
//            else
//              expdir := 'EXP';
//          end;
//          glSettings.Read;
//          dir := Format('%s\%s\%d', [glSettings.GetExportsTo,expdir,z.Fields[2].AsInteger]);
//          row := 0;
//          while DirectoryExists(dir) do
//          begin
//            Inc(row);
//            dir := Format('%s\%s\%d(%.2d)', [glSettings.GetExportsTo,expdir,z.Fields[2].AsInteger,row]);
//          end;
//          ForceDirectories(dir);
//          z.Close;
//        end;
        z.SQL.Clear;
        z.SQL.Add('SELECT codcat FROM categories WHERE sercat = ' + IntToStr(sertab));
        z.Open;
//        filename := Format('%s\%s',[dir, z.Fields[0].AsString]);
//        filename := Format('%s',[FindAndReplaceAll(filename,'/','-')]);
//        { sauvegarde du fichier excel }
//        expdir := Format('%s_%.3d.xlsx',[filename, FileIndex]);
//        while FileExists(expdir) do
//        begin
//          Inc(FileIndex);
//          expdir := Format('%s_%.3d.xlsx',[filename, FileIndex]);
//        end;
//
        ExportFileName := GetExportFilename(dir, z.Fields[0].AsString,phase);
        Book.SaveAs(ExportFilename, AddToMRU:=True);
//        book.SaveAs(expdir, AddToMRU:=True);
        z.Close;

        { export du tablo en pdf }
        sht.ExportAsFixedFormat(xlTypePDF,ChangeFileExt(ExportFileName,'.pdf'));
      end;

    end;
  finally
    z.Free;
  end;
end;

function GetExportFilename(const Path, Filename: TFilename; const Phase: TFirstRoundMode): TFilename;
var
  FileIndex: integer;
  Temp: TFilename;
const
  frm: array[TFirstRoundMode] of string = ('Draw','Groups');
begin
  FileIndex := 0;
  Result := FindAndReplaceAll(Format('%s\%s_%s',[Path, Filename, frm[Phase]]),'/','-');
  Temp := Format('%s_%.3d.xlsx',[Result, FileIndex]);
  while FileExists(Temp) do
  begin
    Inc(FileIndex);
    Temp := Format('%s_%.3d.xlsx',[Result, FileIndex]);
  end;
  Result := Temp;
end;

//procedure readConfigurationFile(const filename: string);
//begin
//  if FileExists(filename) then
//  begin
//    _settings.Clear;
//    _settings.LoadFromFile(filename);
//  end;
//end;
//
//procedure writeConfigurationFile(const filename: string);
//begin
//  _settings.SaveToFile(filename);
//end;
//
//function getSettingsValue(const key: string; const default: string = ''): string;
//begin
//  Result := glSettings.Read('settings',key,'pardc1');
//  if Result = '' then
//    Result := default;
//end;
//
//procedure setSettingsValue(const key, value: string);
//begin
//  glSettings.Write('settings',key,'pardc1',Value);
//end;
//
function getExportDirectory(const sertrn: integer): string;
var
  z: TZReadOnlyQuery;
begin
  z := getROQuery(lcCnx);
  try
    z.SQL.Add('select expcol from tournoi'
             +' where sertrn = :sertrn');
    z.ParamByName('sertrn').AsInteger := sertrn;
    z.Open;
    Result := z.Fields[0].AsString;
    z.Close;
    if Length(Result) = 0 then
      Result := 'DEFAULT';
  finally
    z.Free;
  end;
end;

function getCurrentSaison: integer;
begin
  Result := 0;
  with getROQuery(lcCnx) do
  begin
    try
      SQL.Add('select max(saison) saison from saison where active = ' + QuotedStr('1'));
      Open;
      if not IsEmpty then
        Result := Fields[0].AsInteger;
      Close;
    finally
      Free;
    end;
  end;
end;

function getDefValue(const tablename, colname: string; defValue: string): string;
begin
  Result := defValue;
  with getROQuery(lcCnx) do
  begin
    try
      SQL.Add('select defvalue from defvalues'
             +' where tablename = :tablename'
             +'   and colname = :colname');
      Prepare;
      ParamByName('tablename').AsString := tablename;
      ParamByName('colname').AsString := colname;
      Open;
      if not IsEmpty then
        Result := Fields[0].AsString
      else
      begin
        Close;
        SQL.Clear;
        SQL.Add('insert into defvalues (tablename,colname,defvalue)'
               +Format(' values (%s,%s,%s)',[QuotedStr(tablename),QuotedStr(colname),QuotedStr(defValue)]));
        try ExecSQL; except end;
      end;
      Close;
    finally
      Free;
    end;
  end;
end;

function getCatage(const datann: TDateTime; saison: smallint): string;
begin
  with getROQuery(lcCnx) do
  begin
    try
      SQL.Add('select catage from catage where saison = :saison'
             +'  and coalesce(inferieur,0) <= :annee'
             +'  and coalesce(superieur,9999) >= :annee');
      ParamByName('saison').AsInteger := saison;
      ParamByName('annee').AsInteger  := YearOf(datann);
      Open;
      Result := Fields[0].AsString;
    finally
      Free;
    end;
  end;
end;

function getCodClb(const libclb: string): string;
begin
  Result := 'XXX';
  with getROQuery(lcCnx) do
  begin
    try
      SQL.Add('select codclb from club where libclb = :libclb');
      ParamByName('libclb').AsString := libclb;
      Open;
      if not IsEmpty then
        Result := Fields[0].AsString
      else
      begin
       { nouveau club, on demande un code club inexistant et on insère dans la base de données }
        while True do
        begin
          Result := Uppercase(InputBox('Club', Format('Quel est le code du club %s ?',[libclb]), Result));
          if (MessageDlg(Format('Confirmez-vous %s pour %s',[Result,libclb]), mtConfirmation, [mbYes,mbNo],0) = mrYes) then
          begin
            Close;
            SQL.Clear;
            SQL.Add('select libclb from club where codclb = :codclb');
            Params[0].AsString := Result;
            Open;
            if IsEmpty then
              Break
            else
            begin
              MessageDlg(Format('Le code %s est le code de club %s !',[Result,Fields[0].AsString]), mtError, [mbOk],0);
              Close;
            end;
          end;
        end;
        if Active then Close;
        SQL.Clear;
        SQL.Add('insert into club(codclb,libclb) values (:codclb,:libclb)');
        Params[0].AsString := Result;
        Params[1].AsString := libclb;
        ExecSQL;
      end;
    finally
      Free;
    end;
  end;
end;

function getLibClb(const codclb: string): string;
var
  z: TZReadOnlyQuery;
begin
  Result := 'XXX';
  z := getROQuery(lcCnx);
  try
    z.SQL.Add('select libclb from club where codclb = :codclb');
    z.Params[0].AsString := codclb;
    z.Open;
    if not z.IsEmpty then
      Result := z.Fields[0].AsString
    else
    begin
      while True do
      begin
        Result := InputBox('Club', Format('Quel est le nom du club %s ?',[codclb]), Result);
        if (MessageDlg(Format('Confirmez-vous %s pour %s',[Result,codclb]), mtConfirmation, [mbYes,mbNo],0) = mrYes) then
        begin
          z.Close;
          z.SQL.Clear;
          z.SQL.Add('select codclb from club where libclb = :nomclb');
          z.Params[0].AsString := Result;
          z.Open;
          if z.IsEmpty then
          begin
            z.Close;
            z.SQL.Clear;
            z.SQL.Add('insert into club (codclb,libclb) values (:codclb,:nomclb)');
            z.Params[0].AsString := codclb;
            z.Params[1].AsString := Result;
            z.ExecSQL;
            Break;
          end
          else
          begin
            MessageDlg(Format('%s est le nom du club dont le code est %s !',[Result,z.Fields[0].AsString]), mtError, [mbOk],0);
            z.Close;
          end;
        end;
      end;
    end;
  finally
    z.Free;
  end;
end;

function getTailleTableau(participants: integer): integer;
var
  passe: extended;
  exposant: integer;
begin
  Result := 0;
  if participants>0 then
  begin
     passe := 0;
     exposant := 0;
     while passe < participants do
     begin
       passe := power(2,exposant);
       Inc(exposant);
     end;
     Result := Trunc(passe);
     if Result = 8 then
       Result := 16;
  end;
end;

function genGames(const sercat: integer): boolean;
  function getHandicap(hdc: TZReadOnlyQuery; const cl1, cl2: string): TPoint;
  begin
    FillChar(Result,sizeof(TPoint),0);
    if assigned(hdc) then
    begin
      if cl1 >= cl2 then
      begin
        hdc.ParamByName('cl1').AsString := cl1;
        hdc.ParamByName('cl2').AsString := cl2;
      end
      else
      begin
        hdc.ParamByName('cl2').AsString := cl1;
        hdc.ParamByName('cl1').AsString := cl2;
      end;
      hdc.Open;
      if cl1 >= cl2 then
      begin
        Result.X := hdc.FieldByName('hdc').AsInteger;
        Result.Y := 0;
      end
      else
      begin
        Result.Y := hdc.FieldByName('hdc').AsInteger;
        Result.x := 0;
      end;
      hdc.Close;
    end;
  end;
var
  contnr: TObjectList;
  tablo,
  ins,
  w,
  hdc,
  x: TZReadOnlyQuery;
  i,level,numseq,sertrn,j,prochain: integer;
  codcls: string;
  hdcp: TPoint;
  rm: TRoundingMode;
  seq: TLalSequence;
begin
  Result := False;
  seq := nil;
  rm := GetRoundMode;
  contnr := TObjectList.Create(False);
  try
    seq := TLalSequence.Create(nil, lcCnx);
    tablo := getROQuery(lcCnx, contnr);
    tablo.SQL.Add('select count( * ) from match where sertab = :sertab');
    tablo.ParamByName('sertab').AsInteger := sercat;
    tablo.Open;
    if tablo.Fields[0].AsInteger > 0 then
    begin
      if MessageDlg('Les matchs du tableau ont déjà été générés. Faut-il recommencer ?',
                    mtConfirmation, [mbYes,mbNo], 0) = mrNo then
      begin
        tablo.Close;
        Exit;
      end
      else
      begin
        tablo.SQL.Clear;
        tablo.SQL.Add('delete from match where sertab = :sertab');
        tablo.ParamByName('sertab').AsInteger := sercat;
        tablo.ExecSQL;
      end;
    end;

    tablo.SQL.Clear;
    tablo.SQL.Add('select sertrn from categories where sercat = :sercat');
    tablo.ParamByName('sercat').AsInteger := sercat;
    tablo.Open;
    sertrn := tablo.Fields[0].AsInteger;
    tablo.Close;
    tablo.SQL.Clear;
    tablo.SQL.Add('select serjou,numrow,codcls'
                 +' from tablo'
                 +' where sertab = :sertab'
                 +' order by numrow');
    tablo.ParamByName('sertab').AsInteger := sercat;

    ins := getROQuery(lcCnx, contnr);
    ins.SQL.Add('insert into match (sermtc,sertab,level,numseq,nummtc'
               +'  ,serjo1,serjo2,handi1,handi2,stamtc,sertrn,prochain)'
               +' values (:sermtc,:sertab,:level,:numseq,:nummtc'
               +'  ,:serjo1,:serjo2,:handi1,:handi2,:stamtc,:sertrn,:prochain)');
    ins.Prepare;
    ins.ParamByName('sertab').AsInteger := sercat;
    ins.ParamByName('level').AsInteger  := 1;
    ins.ParamByName('stamtc').AsString := '0';
    ins.ParamByName('sertrn').AsInteger := sertrn;

    w := getROQuery(lcCnx, contnr);
    w.SQL.Add('select codcat,simple,handicap,numset,catage'
               +' from categories'
               +' where sercat = :sercat');
    w.ParamByName('sercat').AsInteger := sercat;
    w.Open;
    if w.FieldByName('handicap').AsString = '1' then
    begin
      hdc := getROQuery(lcCnx,contnr);
      hdc.SQL.Add('select hdc from handicap where cl1 = :cl1 and cl2 = :cl2');
      hdc.Prepare;
    end
    else
      hdc := nil;
    w.Close;

    tablo.Open;
    numseq := 0;
    level := 1;
    prochain := 0;
    setRoundMode(rmUp);
    { les matchs du premier tour sont générés (level 1) }
    while not tablo.Eof do
    begin
      Inc(numseq);
      ins.ParamByName('sermtc').AsInteger := seq.SerialByName('categorie');
      ins.ParamByName('numseq').AsInteger := numseq;
      ins.ParamByName('nummtc').AsString := Format('%d.%.3d',[level,numseq]);
      ins.ParamByName('serjo1').AsInteger := tablo.FieldByName('serjou').AsInteger;
      Inc(prochain);
      if prochain = 3 then
        prochain := 1;
      j := Round(numseq / 2);
      if j = 0 then
        j := 1;
      ins.ParamByName('prochain').AsString := Format('%d.%.3d/%d',[Succ(level),j,prochain]);
      codcls := tablo.FieldByName('codcls').AsString;
      tablo.Next;
      ins.ParamByName('serjo2').AsInteger := tablo.FieldByName('serjou').AsInteger;
      hdcp := getHandicap(hdc,codcls,tablo.FieldByName('codcls').AsString);
      ins.ParamByName('handi1').AsInteger := hdcp.X;
      ins.ParamByName('handi2').AsInteger := hdcp.Y;
      ins.ExecSQL;
      tablo.Next;
      Application.ProcessMessages;
    end;
    tablo.Close;

    tablo.SQL.Clear;
    tablo.SQL.Add('select sermtc,numseq,serjo1,serjo2'
                 +' from match'
                 +' where sertab = :sertab'
                 +'   and level = :level'
                 +' order by prochain,numseq');
    tablo.Prepare;
    tablo.ParamByName('sertab').AsInteger := sercat;

    x := getROQuery(lcCnx,contnr);
    x.SQL.Add('select codcls from tablo where sertab = :sertab'
             +'   and serjou = :serjou');
    x.Prepare;
    w.SQL.Clear;
    w.SQL.Add('select count( * ) from match'
             +' where sertab = :sertab'
             +'   and level = :level');
    w.Prepare;
    w.ParamByName('sertab').AsInteger := sercat;
    w.ParamByName('level').AsInteger := level;
    w.Open;
    ins.ParamByName('sertab').AsInteger := sercat;
    ins.ParamByName('handi1').Clear;
    ins.ParamByName('handi2').Clear;
    ins.ParamByName('stamtc').AsInteger := 0;
    ins.ParamByName('sertrn').AsInteger := sertrn;
    if w.Fields[0].AsInteger > 0 then
    begin
      repeat
        Inc(level);
        { create matches for level }
        tablo.ParamByName('level').AsInteger := Pred(level);
        tablo.Open;
        ins.ParamByName('level').AsInteger := level;
        ins.ParamByName('serjo1').AsInteger := 0;
        ins.ParamByName('serjo2').AsInteger := 0;
        numseq := 0;
        prochain := 0;
        while not tablo.Eof do
        begin
          Inc(numseq);
          ins.ParamByName('sermtc').AsInteger := seq.SerialByName('categorie');
          ins.ParamByName('numseq').AsInteger := numseq;
          ins.ParamByName('nummtc').AsString := Format('%d.%.3d',[level,numseq]);
          Inc(prochain);
          if prochain = 3 then
            prochain := 1;
          j := Round(numseq / 2);
          if j = 0 then j := 1;
          if tablo.RecordCount > 2 then
            ins.ParamByName('prochain').AsString := Format('%d.%.3d/%d',[Succ(level),j,prochain])
          else
            ins.ParamByName('prochain').Clear;
          { second joueur du prochain match }
          tablo.Next;
          ins.ExecSQL;
          tablo.Next;
          Application.ProcessMessages;
        end;
        tablo.Close;
        {==========================}
        w.Close;
        w.ParamByName('level').AsInteger := level;
        w.Open;
        Application.ProcessMessages;
      until w.Fields[0].AsInteger = 1;
    end;
    Result := True;
  finally
    SetRoundMode(rm);
    for i := 0 to Pred(contnr.Count) do
      TZReadOnlyQuery(contnr[i]).Free;
    contnr.Free;
    if Assigned(seq) then
      seq.Free;
  end;
end;

procedure CreateGroupGames(const sergrp: integer);
begin

end;

procedure deleteTournament(const sertrn: integer);
var
  z: TZReadOnlyQuery;
begin
  z := getROQuery(lcCnx);
  try
    Screen.Cursor := crSQLWait;
    lcCnx.startTransaction;
    try
//      Deleted by trigger on table match
//      z.SQL.Clear;
//      z.SQL.Add(Format('delete from %s where sertrn = %d',['match_groupe',sertrn]));
//      z.ExecSQL;
//      z.SQL.Clear;
      z.SQL.Add(Format('delete from %s where sertrn = %d',['compo_groupe',sertrn]));
      z.ExecSQL;
      z.SQL.Clear;
      z.SQL.Add(Format('delete from %s where sertrn = %d',['match_groupe',sertrn]));
      z.ExecSQL;
      z.SQL.Clear;
      z.SQL.Add(Format('delete from %s where sertrn = %d',['groupe',sertrn]));
      z.ExecSQL;
      z.SQL.Clear;
      z.SQL.Add(Format('delete from %s where sertrn = %d',['groupe_result',sertrn]));
      z.ExecSQL;
      z.SQL.Clear;
      z.SQL.Add(Format('delete from %s where sertrn = %d',['insc',sertrn]));
      z.ExecSQL;
      z.SQL.Clear;
      z.SQL.Add(Format('delete from %s where sertrn = %d',['classements',sertrn]));
      z.ExecSQL;
      z.SQL.Clear;
      z.SQL.Add(Format('delete from %s where sertrn = %d',['categories',sertrn]));
      z.ExecSQL;
      z.SQL.Clear;
      z.SQL.Add(Format('delete from %s where sertrn = %d',['match',sertrn]));
      z.ExecSQL;
      z.SQL.Clear;
      z.SQL.Add(Format('delete from %s where sertrn = %d',['prptab',sertrn]));
      z.ExecSQL;
      z.SQL.Clear;
      z.SQL.Add(Format('delete from %s where sertrn = %d',['tablo',sertrn]));
      z.ExecSQL;
      z.SQL.Clear;
      z.SQL.Add(Format('delete from %s where sertrn = %d',['tableau',sertrn]));
      z.ExecSQL;
      z.SQL.Clear;
      z.SQL.Add(Format('delete from %s where sertrn = %d',['umpires',sertrn]));
      z.ExecSQL;
      z.SQL.Clear;
      z.SQL.Add(Format('delete from %s where sertrn = %d',['tournoi',sertrn]));
      z.ExecSQL;
      { TODO : Delete all the records by trigger on table tournoi }
      lcCnx.commit;
    except
      lcCnx.rollback;
      raise;
    end;
  finally
    z.Free;
    Screen.Cursor := crDefault;
  end;
end;

function isDigit(const c: char): boolean;
const
  numbers: TSysCharSet = ['0','1','2','3','4','5','6','7','8','9'];
begin
  Result := CharInSet(c,numbers);
end;

function checkDoublons(const sertrn: integer): TStrings;
  function getLicence(const lic1,lic2: string): string;
  begin
    if lic1 > lic2 then
      Result := lic2+'-'+lic1
    else
      Result := lic1+'-'+lic2;
  end;
var
  categories,
  tablo,
  sel,
  ins: TZReadOnlyQuery;
  freeList: TObjectList;
  serjo1,
  serjo2: integer;
  licence,
  lic1,
  lic2: string;
  numrow: integer;
begin
  Result := TStringList.Create;
  if not tableExists(lcCnx,'doublons') then
  begin
    with getROQuery(lcCnx) do
    begin
      try
        SQL.Add('CREATE TABLE doublons ('
               +'   licence varchar(13) NOT NULL'
               +'  ,serjo1 integer'
               +'  ,serjo2 integer'
               +'  ,tablo varchar(20)'
               +'  ,primary key(licence,tablo))');
        ExecSQL;
      finally
        Free;
      end;
    end;
  end;
  emptyTable(lcCnx,'doublons');

  FreeList := TObjectList.Create;
  try
    categories := getROQuery(lcCnx,freeList);
    categories.SQL.Add('select sercat,codcat from categories'
                      +' where sertrn = ' + IntToStr(sertrn));

    tablo := getROQuery(lcCnx,freeList);
    tablo.SQL.Add('select coalesce(serjou,0)serjou,licence,numrow'
                 +' from tablo'
                 +' where sertrn = ' + IntToStr(sertrn)
                 +'   and sertab = :sercat'
                 +' order by numrow');
    tablo.Prepare;

    sel := getROQuery(lcCnx,freeList);
    sel.SQL.Add('select count( * ) from doublons'
               +' where licence = :licence');
    sel.Prepare;

    ins := getROQuery(lcCnx,freeList);
    ins.SQL.Add('insert into doublons (licence,serjo1,serjo2,tablo)'
               +' values (:licence,:serjo1,:serjo2,:tablo)');
    ins.Prepare;

    serjo1 := 0;
    serjo2 := 0;
    licence := '';
    lic1 := '';
    lic2 := '';
    categories.Open;
    while not categories.Eof do
    begin
      tablo.ParamByName('sercat').AsInteger := categories.FieldByName('sercat').AsInteger;
      tablo.Open;

      numrow := 2;
      while not tablo.Eof do
      begin
        if numrow = 2 then
        begin
          numrow := 0;
          serjo1 := 0;
          serjo2 := 0;
          licence := '';
          lic1 := '';
          lic2 := '';
        end;
        Inc(numrow);
        if numrow = 1 then
        begin
          serjo1 := tablo.FieldByName('serjou').AsInteger;
          lic1   := tablo.FieldByName('licence').AsString;
        end
        else
        if numrow = 2 then
        begin
          serjo2 := tablo.FieldByName('serjou').AsInteger;
          lic2   := tablo.FieldByName('licence').AsString;
        end;
        if numrow = 2 then
        begin
          if (serjo1 > 0) and (serjo2 > 0) then
          begin
            licence := getLicence(lic1,lic2);
            ins.ParamByName('licence').AsString := licence;
            ins.ParamByName('serjo1').AsInteger := serjo1;
            ins.ParamByName('serjo2').AsInteger := serjo2;
            ins.ParamByName('tablo').AsString   := categories.FieldByName('codcat').AsString;
            ins.ExecSQL;

            sel.ParamByName('licence').AsString := licence;
            sel.Open;
            if sel.Fields[0].AsInteger > 1 then
              Result.Add(Format('%s : %s',[ins.ParamByName('tablo').AsString,licence]));
            sel.Close;

          end;
        end;
        tablo.Next;
        Application.ProcessMessages;
      end;

      tablo.Close;
      categories.Next;
      Application.ProcessMessages;
    end;
    categories.Close;
  finally
    FreeList.Free;
  end;
end;

procedure displayDoublons(f: TDataW);
begin
  f.data.SQL.Add('select licence,count( * ) from doublons'
                +' group by 1'
                +' having count( * ) > 1');
  f.data.open;
  f.ShowModal;
end;

procedure initUmpiresTable(const sertrn: integer);
var
  numtbl: smallint;
  i: integer;
begin
  with getROQuery(lcCnx) do
  begin
    try
      SQL.Add('SELECT COUNT(*) FROM match WHERE sertrn = ' + sertrn.ToString);
      Open;
      if Fields[0].AsInteger = 0 then
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT numtbl FROM tournoi WHERE sertrn = ' + sertrn.ToString);
        Open;
        numtbl := Fields[0].AsInteger;
        Close;
        SQL.Clear;
        SQL.Add('DELETE FROM umpires WHERE 1=1');
        ExecSQL;
        SQL.Clear;
        SQL.Add('INSERT INTO umpires (sertrn,numtbl,umpire,statbl,sermtc,prvmtc) VALUES (:serttrn,:numtbl,null,:statbl,0,0)');
        Prepare;
        Params[0].AsInteger := sertrn;
        Params[2].AsInteger := Ord(pasAvailable);
        for i := 1 to numtbl do
        begin
          Params[1].AsInteger := i;
          ExecSQL;
        end;
      end;
    finally
      Free;
    end;
  end;
end;

{ TPlayerStatus }

constructor TPlayerStatus.Create(cnx: TLalConnection);
begin
  pvCnx := cnx;
  inherited Create;
  FTableaux := TStringList.Create;
  pvJoueur := getROQuery(pvCnx);
  pvJoueur.SQL.Add('  SELECT licence,libclb,nomjou,codcls'
                  +'   FROM joueur j'
                  +'        LEFT JOIN club c ON j.codclb = c.codclb'
                  +'   WHERE serjou = :serjou');
  pvJoueur.Prepare;

  pvTableaux := getROQuery(pvCnx);
  pvTableaux.SQL.Add('SELECT c.heudeb,c.codcat,c.stacat,i.statut'
                    +'      ,t.numtds,t.numrow'
                    +' FROM insc i'
                    +'      LEFT JOIN categories c ON i.sercat = c.sercat'
                    +'      LEFT JOIN tablo t ON i.sercat = t.sertab'
                    +'                       AND i.serjou = t.serjou'
                    +' WHERE i.serjou = :serjou'
                    +'   AND i.sertrn = :sertrn'
                    +' ORDER BY 1,2');
  pvTableaux.Prepare;

  pvEnCours := getROQuery(pvCnx);
  pvEnCours.SQL.Add('SELECT umpire || '' est arbitre table ''|| numtbl AS display,0 AS status'
                   +' FROM umpires'
                   +' WHERE sertrn = :sertrn'
                   +'   AND serump = :serjou'
                   +' UNION '
                   +'SELECT j.NOMJOU || '' joue table '' || NUMTBL || '' catégorie '' || c.codcat,1'
                   +' FROM match m INNER JOIN joueur j ON j.serjou = :serjou'
                   +'              INNER JOIN categories c ON c.sercat = m.sertab'
                   +' WHERE m.sertrn = :sertrn'
                   +'   AND (m.serjo1 = :serjou OR m.serjo2 = :serjou)'
                   +'   AND m.stamtc = ' + IntToStr(Ord(gsInProgress)));
  pvEnCours.Prepare;
  FEnCours := '';
  FNom := '';
  FClub := '';
  FAvailableColor := clGreen;
  FIsPlayingColor := clRed;
  FIsUmpireColor := clMaroon;
  FColor := clWindow;
end;

destructor TPlayerStatus.Destroy;
begin
  FTableaux.Free;
  pvJoueur.Free;
  pvTableaux.Free;
  pvEnCours.Free;
  inherited;
end;

function TPlayerStatus.Read(const joueur, tournoi: integer): boolean;
begin
  Result := False;
  FJoueur := joueur;
  FTournoi := tournoi;
  pvJoueur.ParamByName('serjou').AsInteger := joueur;
  pvJoueur.Open;
  try
    FNom := pvJoueur.FieldByName('nomjou').AsString;
    FClub := pvJoueur.FieldByName('libclb').AsString;
  finally
    pvJoueur.Close;
  end;

  FTableaux.Clear;
  pvTableaux.ParamByName('serjou').AsInteger := joueur;
  pvTableaux.ParamByName('sertrn').AsInteger := tournoi;
  pvTableaux.Open;
  try
    while not pvTableaux.Eof do
    begin
      FTableaux.AddObject(Format('%s (%s : %s) %s TDS=%d pos.=%d',[pvTableaux.FieldByName('codcat').AsString,
                                                                   pvTableaux.FieldByName('heudeb').AsString,
                                                                   pis[categoryStatus[TCategorysStatus(pvTableaux.FieldByName('stacat').AsInteger)]],
                                                                   pis[registrationStatus[TRegistrationStatus(pvTableaux.FieldByName('statut').AsInteger)]],
                                                                   pvTableaux.FieldByName('numtds').AsInteger,
                                                                   pvTableaux.FieldByName('numrow').AsInteger]),Pointer(pvTableaux.FieldByName('statut').AsInteger));
      pvTableaux.Next;
    end;
  finally
    pvTableaux.Close;
  end;

  pvEnCours.ParamByName('serjou').AsInteger := joueur;
  pvEnCours.ParamByName('sertrn').AsInteger := tournoi;
  pvEnCours.Open;
  try
    FEnCours := pvEnCours.Fields[0].AsString;
    if pvEnCours.Eof then
    begin
      FEnCours := Format('%s est disponible.',[FNom]);
      FColor := AvailableColor;
    end
    else
    begin
      case pvEnCours.Fields[1].AsInteger of
        0 : FColor := IsUmpireColor;
        1 : FColor := IsPlayingColor;
      end;
    end;
  finally
    pvEnCours.Close;
  end;
end;

procedure TPlayerStatus.SetAvailableColor(const Value: TColor);
begin
  FAvailableColor := Value;
end;

procedure TPlayerStatus.SetIsPlayingColor(const Value: TColor);
begin
  FIsPlayingColor := Value;
end;

procedure TPlayerStatus.SetIsUmpireColor(const Value: TColor);
begin
  FIsUmpireColor := Value;
end;

function globalSeek: TLalSeek;
begin
  if not Assigned(lcSeek) then
    lcSeek := TLalSeek.Create(Application);
  Result := lcSeek;
end;

function globalSeek(cnx: TZConnection): TLalSeek; overload;
begin
  if not Assigned(lcSeek) then
    lcSeek := TLalSeek.Create(Application);
  lcSeek.Connection := cnx;
  Result := lcSeek;
end;

procedure CheckAndSetCategorieStatusPrepareQuerys;
begin
  if not Assigned(pvCheckCategStatusSelCategData) then
  begin
    pvCheckCategStatusSelCategData := getROQuery(lcCnx);
    pvCheckCategStatusSelCategData.SQL.Add('SELECT first_round_mode,stacat,phase'
                                          +' FROM categories'
                                          +' WHERE sercat = :sercat');
    pvCheckCategStatusSelCategData.Prepare;

    pvCheckCategStatusSelPrpTabCount := getROQuery(lcCnx);
    pvCheckCategStatusSelPrpTabCount.SQL.Add('SELECT COUNT(*)'
                                            +' FROM prptab'
                                            +' WHERE sertab = :sercat');
    pvCheckCategStatusSelPrpTabCount.Prepare;

    pvCheckCategStatusSelGamesCount := getROQuery(lcCnx);
    pvCheckCategStatusSelGamesCount.SQL.Add('SELECT COUNT(*)'
                                          +' FROM match'
                                          +' WHERE sertab = :sercat');
    pvCheckCategStatusSelGamesCount.Prepare;

    pvCheckCategStatusSelGamesStatusCount := getROQuery(lcCnx);
    pvCheckCategStatusSelGamesStatusCount.SQL.Add('SELECT COUNT(*)'
                                                 +' FROM match'
                                                 +' WHERE sertab = :sercat'
                                                 +'   AND stamtc = :stamtc');
    pvCheckCategStatusSelGamesStatusCount.Prepare;

    pvCheckCategStatusSelTabloCount := getROQuery(lcCnx);
    pvCheckCategStatusSelTabloCount.SQL.Add('SELECT COUNT(*)'
                                           +' FROM tablo'
                                           +' WHERE sertab = :sercat');
    pvCheckCategStatusSelTabloCount.Prepare;

    pvCheckCategStatusSelGroupGamesCount := getROQuery(lcCnx);
    pvCheckCategStatusSelGroupGamesCount.SQL.Add('SELECT COUNT(*)'
                                                +' FROM match_groupe'
                                                +' WHERE sercat = :sercat');
    pvCheckCategStatusSelGroupGamesCount.Prepare;

    pvCheckCategStatusSelGroupCount := getROQuery(lcCnx);
    pvCheckCategStatusSelGroupCount.SQL.Add('SELECT COUNT(*)'
                                           +' FROM groupe'
                                           +' WHERE sercat = :sercat');
    pvCheckCategStatusSelGroupCount.Prepare;

  end;
end;

procedure CheckAndSetCategorysStatus_KO_Mode(const sercat: integer; var stacat: TCategorysStatus; var phase: TFirstRoundMode);
var
  nbrGames: integer;
  newph: TFirstRoundMode;
  newcat: TCategorysStatus;
begin
//  CheckAndSetCategorieStatusPrepareQuerys;
    if not pvCheckCategStatusSelCategData.Eof then
    begin
      newcat := stacat;
      newph := phase;
      // KO mode can only be in KO phase
      pvCheckCategStatusSelPrpTabCount.Params[0].AsInteger := sercat;
      pvCheckCategStatusSelPrpTabCount.Open;
      { aucun record préparés, donc inactive }
      if pvCheckCategStatusSelPrpTabCount.Fields[0].AsInteger = 0 then
        newcat := csInactive
      else
      begin
        pvCheckCategStatusSelGamesCount.Params[0].AsInteger := sercat;
        pvCheckCategStatusSelGamesCount.Open;
        { les matchs ont été générés }
        if pvCheckCategStatusSelGamesCount.Fields[0].AsInteger > 0 then
        begin
          nbrGames := pvCheckCategStatusSelGamesCount.Fields[0].AsInteger;
          pvCheckCategStatusSelGamesStatusCount.Params[0].AsInteger := sercat;
          pvCheckCategStatusSelGamesStatusCount.Params[1].AsInteger := Ord(gsOver);
          pvCheckCategStatusSelGamesStatusCount.Open;
          if pvCheckCategStatusSelGamesStatusCount.Fields[0].AsInteger = nbrGames then
            newcat := csOver
          else
          begin
            pvCheckCategStatusSelGamesStatusCount.Close;
            pvCheckCategStatusSelGamesStatusCount.Params[1].AsInteger := Ord(gsInProgress);
            pvCheckCategStatusSelGamesStatusCount.Open;
            if pvCheckCategStatusSelGamesStatusCount.Fields[0].AsInteger > 0 then
              newcat := csInProgress;
          end;
        end
        else
        begin
          pvCheckCategStatusSelTabloCount.Params[0].AsInteger := sercat;
          pvCheckCategStatusSelTabloCount.Open;
          { le tableau est préparé }
          if pvCheckCategStatusSelTabloCount.Fields[0].AsInteger > 0 then
            newcat := csDraw
          else
            newcat := csPrepared;
        end;
      end;

    { si la phase ou le statut ont changé }
    if (newph <> phase) or (newcat <> stacat) then
    begin
      phase := newph;
      stacat := newcat;
    end;
  end;
end;

//procedure CheckAndSetCategorysStatus_Qualification_Mode(const sercat: integer; var stacat: TCategorysStatus; var phase: TFirstRoundMode);
//var
//  newcat: TCategorysStatus;
//  newph: TFirstRoundMode;
//  nbrGames: integer;
//begin
////  TCategorysStatus = (csInactive,csPrepared,csGroup,csDraw,csInProgress,csOver);
////  TQualificationGroupStatus = (qgsInactive, qgsValidated, qgsGamesAreCreated, qgsInProgress, qgsOver);
//
//  if not pvCheckCategStatusSelCategData.Eof then
//  begin
//    newcat := stacat;
//    newph := phase;
//    pvCheckCategStatusSelPrpTabCount.Params[0].AsInteger := sercat;
//    pvCheckCategStatusSelPrpTabCount.Open;
//    { aucun record préparés, donc inactive }
//    if pvCheckCategStatusSelPrpTabCount.Fields[0].AsInteger = 0 then
//      newcat := csInactive
//    else
//    begin
//      pvCheckCategStatusSelGroupCount.Params[0].AsInteger := sercat;
//      pvCheckCategStatusSelGroupCount.Open;
//
//      pvCheckCategStatusSelGroupGamesCount.Params[0].AsInteger := sercat;
//      pvCheckCategStatusSelGroupGamesCount.Open;
//      { les matchs des groupes sont-ils générés }
//
//      if (pvCheckCategStatusSelGroupGamesCount.Fields[0].AsInteger > 0) then
//      begin
//        newcat := csGroup;
//        { TODO : Se baser sur le statut de la table groupe }
//
//        { tous les matchs des groupes sont-ils générés }
//        if pvCheckCategStatusSelGroupGamesCount.Fields[0].AsInteger = (pvCheckCategStatusSelGroupCount.Fields[0].AsInteger * 3) then
//          newcat := csDraw;
//        { maintenant un match est-il en-cours ? }
//        pvCheckCategStatusSelGamesStatusCount.ParamByName('sercat').AsInteger := sercat;
//        pvCheckCategStatusSelGamesStatusCount.ParamByName('stamtc').AsInteger := Ord(gsInProgress);
//        pvCheckCategStatusSelGamesStatusCount.Open;
//        if pvCheckCategStatusSelGamesStatusCount.Fields[0].AsInteger > 0 then
//          newcat := csInProgress;
//        pvCheckCategStatusSelGamesStatusCount.Close;
//        { est-ce que tous les matchs des groupes sont terminés }
//        pvCheckCategStatusSelGamesStatusCount.ParamByName('stamtc').AsInteger := Ord(gsOver);
//        pvCheckCategStatusSelGamesStatusCount.Open;
//        if pvCheckCategStatusSelGamesStatusCount.Fields[0].AsInteger = (pvCheckCategStatusSelGroupCount.Fields[0].AsInteger * 3) then
//          newcat := csOver;
//        { si csOver, basculer en phase KO }
//        if newcat = csOver then
//        begin
//          newcat := csInactive;
//          newph := frKO;
//        end;
//      end
//      else
//      begin
//        newcat := csPrepared;
//      end;
//    end;
//  end;
//  { si la phase ou le statut ont changé }
//  if (newph <> phase) or (newcat <> stacat) then
//  begin
//    phase := newph;
//    stacat := newcat;
//  end;
//end;

procedure CheckAndSetCategorysStatus_Qualification_Mode_BasedOnGroups(const sercat: integer; var stacat: TCategorysStatus; var phase: TFirstRoundMode);
var
  newcat: TCategorysStatus;
  newph: TFirstRoundMode;
begin
//  TCategorysStatus = (csInactive,csPrepared,csGroup,csDraw,csInProgress,csOver);
//  TQualificationGroupStatus = (qgsInactive, qgsValidated, qgsGamesAreCreated, qgsInProgress, qgsOver);
  newcat := stacat;
  newph := phase;
  if not pvCheckCategStatusSelCategData.Eof then
  begin
    { si prptab(sercat) = 0 then csInactive }
    pvCheckCategStatusSelPrpTabCount.Params[0].AsInteger := sercat;
    pvCheckCategStatusSelPrpTabCount.Open;
    { aucun record préparés, donc inactive }
    if pvCheckCategStatusSelPrpTabCount.Fields[0].AsInteger = 0 then
      newcat := csInactive
    { sinon csPrepared }
    else
      newcat := csPrepared;

    { si groupe.count > 0 then csGroup }
    pvCheckCategStatusSelGroupCount.Params[0].AsInteger := sercat;
    pvCheckCategStatusSelGroupCount.Open;
    if pvCheckCategStatusSelGroupCount.Fields[0].AsInteger > 0 then
    begin
      newcat := csGroup;

      { si match.count > groupe.count*3 then csDraw }
      pvCheckCategStatusSelGroupGamesCount.Params[0].AsInteger := sercat;
      pvCheckCategStatusSelGroupGamesCount.Open;
      if (pvCheckCategStatusSelGroupGamesCount.Fields[0].AsInteger = pvCheckCategStatusSelGroupCount.Fields[0].AsInteger*3) and (newcat <> csInProgress) then
        newcat := csDraw;

      { csInprogress is set by Tarena15W.runCateg }

      { si csInProgress and match.count.IsOver = match.count then csOver }
      pvCheckCategStatusSelGamesStatusCount.ParamByName('sercat').AsInteger := sercat;
      pvCheckCategStatusSelGamesStatusCount.ParamByName('stamtc').AsInteger := Ord(gsOver);
      pvCheckCategStatusSelGamesStatusCount.Open;
      if pvCheckCategStatusSelGamesStatusCount.Fields[0].AsInteger = (pvCheckCategStatusSelGroupCount.Fields[0].AsInteger * 3) then
        newcat := csOver;
      { si csOver, basculer en phase KO }
      if newcat = csOver then
      begin
        newcat := csInactive;
        newph := frKO;
      end;
    end;
  end;
  { si la phase ou le statut ont changé }
  if (newph <> phase) or (newcat <> stacat) then
  begin
    phase := newph;
    stacat := newcat;
  end;
end;

procedure CheckAndSetCategorieStatusAfterUpdate(const sercat: integer);
var
  mode: TFirstRoundMode;
  phase,
  newph: TFirstRoundMode;
  stacat,
  newcat: TCategorysStatus;
begin
  CheckAndSetCategorieStatusPrepareQuerys;
  pvCheckCategStatusSelCategData.Params[0].AsInteger := sercat;
  pvCheckCategStatusSelCategData.Open;
  try
    if not pvCheckCategStatusSelCategData.Eof then
    begin
      stacat := TCategorysStatus(pvCheckCategStatusSelCategData.FieldByName('stacat').AsInteger);
      newcat := stacat;
      mode := TFirstRoundMode(pvCheckCategStatusSelCategData.FieldByName('first_round_mode').AsInteger);
      phase := TFirstRoundMode(pvCheckCategStatusSelCategData.FieldByName('phase').AsInteger);
      newph := phase;

      case mode of
        frKO: begin
          CheckAndSetCategorysStatus_KO_Mode(sercat,newcat,newph);
        end;

        frQualification: begin
          case phase of
            frKO: CheckAndSetCategorysStatus_KO_Mode(sercat,newcat,newph);
            frQualification: CheckAndSetCategorysStatus_Qualification_Mode_BasedOnGroups(sercat,newcat,newph);
          end;
        end;
      end;

      { si la phase ou le statut ont changé }
      if (newph <> phase) or (newcat <> stacat) then
      begin
        updateCategorysStatus(sercat,newcat,newph);
      end;
    end;
  finally
    pvCheckCategStatusSelCategData.Close;
    pvCheckCategStatusSelPrpTabCount.Close;
    pvCheckCategStatusSelGamesCount.Close;
    pvCheckCategStatusSelGamesStatusCount.Close;
    pvCheckCategStatusSelTabloCount.Close;
    pvCheckCategStatusSelGroupCount.Close;
    pvCheckCategStatusSelGroupGamesCount.Close;
  end;
end;

procedure UpdateCategorysStatus(const sercat: integer; status: TCategorysStatus; phase: TFirstRoundMode);
begin
  if not Assigned(pvUpdateCategorysStatusQuery) then
  begin
    pvUpdateCategorysStatusQuery := getROQuery(lcCnx);
    pvUpdateCategorysStatusQuery.SQL.Add('UPDATE categories SET stacat = :stacat'
                                        +'     ,phase = :phase'
                                        +' WHERE sercat = :sercat');
    pvUpdateCategorysStatusQuery.Prepare;
  end;
  pvUpdateCategorysStatusQuery.Params[0].AsInteger := Ord(status);
  pvUpdateCategorysStatusQuery.Params[1].AsInteger := Ord(phase);
  pvUpdateCategorysStatusQuery.Params[2].AsInteger := sercat;
  pvUpdateCategorysStatusQuery.ExecSQL;
  broadcastMessage(wm_categChanged,sercat,Ord(status));
end;

function makeVersion(const version: double): boolean;
begin
  Result := False;
end;

initialization
  lcGetColorQuery := nil;
  lcSetColorQuery := nil;
  for lcPi := Low(lcColorsArray) to High(lcColorsArray) do
    lcColorsArray[lcPi] := piDefaultColor;
  lcSeek := nil;
  pvCheckCategStatusSelCategData := nil;
  pvCheckCategStatusSelPrpTabCount := nil;
  pvCheckCategStatusSelGamesCount := nil;
  pvCheckCategStatusSelGamesStatusCount := nil;
  pvCheckCategStatusSelTabloCount := nil;
  pvUpdateCategorysStatusQuery := nil;
  pvCheckCategStatusSelGroupGamesCount := nil;
  pvCheckCategStatusSelGroupCount := nil;
  glSettingsValues := TStringList.Create;

  glCreateGroupGamesProc := procedure(sergrp: integer)
    var
      contnr: TObjectList;
      grp,sel,insm,insmg: TZReadOnlyQuery;
      seq: TLalSequence;
      nummtc,
      sermtc: integer;

      function AddGame(const j1,j2: integer): integer;
      begin
        Result := nummtc;
        sel.Params[1].AsInteger := j1;
        sel.Open;
        if not sel.Eof then
        begin
          insm.ParamByName('serjo1').AsInteger := sel.FieldByName('serjou').AsInteger;
          sel.Close;
          sel.Params[1].AsInteger := j2;
          sel.Open;
          if not sel.Eof then
          begin
            insm.ParamByName('serjo2').AsInteger := sel.FieldByName('serjou').AsInteger;
            sel.Close;
            sermtc := seq.GetNextValue;
            insm.ParamByName('sermtc').AsInteger := sermtc;
            insm.ParamByName('numseq').AsInteger := grp.FieldByName('numgrp').AsInteger * 100 + Succ(Result);
            insm.ParamByName('nummtc').AsString := Format('%d.%.3d',[0,insm.ParamByName('numseq').AsInteger]);
            insm.ExecSQL;
            insmg.ParamByName('sermtc').AsInteger := sermtc;
            insmg.ExecSQL;
            Inc(Result);
          end;
        end;
      end;
    begin
      contnr := TObjectList.Create;
      try
        grp := getROQuery(lcCnx, contnr);
        grp.SQL.Add('SELECT sergrp,sercat,numgrp,sertrn'
                   +' FROM groupe'
                   +' WHERE sergrp = :sergrp');

        sel := getROQuery(lcCnx, contnr);
        sel.SQL.Add('SELECT cpg.numseq,cpg.sergrp,cpg.serjou'
                   +'      ,jou.nomjou,jou.codcls,jou.vrbrgl'
                   +'      ,clb.libclb'
                   +' FROM compo_groupe cpg'
                   +'  INNER JOIN joueur jou ON cpg.serjou = jou.serjou'
                   +'  INNER JOIN club clb ON jou.codclb = clb.codclb'
                   +' WHERE cpg.sergrp = :sergrp'
                   +'   AND cpg.numseq = :numseq');
        sel.Prepare;

        insm := getROQuery(lcCnx, contnr);
        insm.SQL.Add('INSERT INTO match (sermtc,sertab,level,numseq,nummtc'
                    +'  ,serjo1,serjo2,stamtc,sertrn)'
                    +' VALUES (:sermtc,:sertab,:level,:numseq,:nummtc'
                    +'  ,:serjo1,:serjo2,:stamtc,:sertrn)');
        insm.Prepare;

        insmg := getROQuery(lcCnx, contnr);
        insmg.SQL.Add('INSERT INTO match_groupe (sermtc,sergrp,sercat,sertrn)'
                     +' VALUES (:sermtc,:sergrp,:sercat,:sertrn)');
        insmg.Prepare;

        seq := TLalSequence.Create(nil, lcCnx);
        seq.SequenceName := 'CATEGORIE';

        grp.Params[0].AsInteger := sergrp;
        grp.Open;
        if not grp.Eof then
        begin
          lcCnx.startTransaction;
          try
            sel.Params[0].AsInteger := sergrp;

            insm.ParamByName('sertab').AsInteger := grp.FieldByName('sercat').AsInteger;
            insm.ParamByName('level').AsInteger  := 0;
            insm.ParamByName('stamtc').AsInteger := Ord(gsInactive);
            insm.ParamByName('sertrn').AsInteger := grp.FieldByName('sertrn').AsInteger;

            insmg.ParamByName('sergrp').AsInteger := sergrp;
            insmg.ParamByName('sercat').AsInteger := insm.ParamByName('sertab').AsInteger;
            insmg.ParamByName('sertrn').AsInteger := insm.ParamByName('sertrn').AsInteger;

            { les rencontres des groupes de 3 sont 1-3, 2-3, 1-2 }
            nummtc := 0;
            nummtc := AddGame(1,3);
            nummtc := AddGame(2,3);
            nummtc := AddGame(1,2);

            if nummtc < 3 then
              raise Exception.CreateFmt('Seulement %d matchs sur 3 ont été générés !',[nummtc]);
            lcCnx.commit;

            { update of categorie.stacat }
            UpdateQualificationGroupStatus(sergrp, qgsGamesAreCreated);
            CheckAndSetCategorieStatusAfterUpdate(grp.FieldByName('sercat').AsInteger);
          except
            lcCnx.rollback;
            raise;
          end;
        end;
        grp.Close;
      finally
        seq.Free;
        contnr.Free;
      end;
    end;

  glPaintPlayAreaGameContent := procedure(item: TCollectionItem)
    var
      cc: TControlCanvas;
      R,tr,jr: TRect;
      pname: string;
      t1,t2: TTime;
      h,n: word;
      area: TPlayArea;
    const
      yOffset: integer = 8;
    begin
      area := TPlayArea(item);
      cc := TControlCanvas.Create;
      try
        cc.Control := area.Panel;
        R := area.Panel.ClientRect;
        with cc do
        begin
          Brush.Color := getPlayAreasColor(area.Status);
          FillRect(R);

          {: table area draw }
          Brush.Color := getItemsColor(piGameTable);
          {: table limits (2.74m x 1.525m = ratio 1.7967 }
          tr.Height := (R.Height div 4) * 3;
          tr.Width := Trunc(tr.Height * 1.7967);
          tr.SetLocation(R.Left + ((R.Width - tr.Width) div 2),
                         R.Top + ((R.Height - tr.Height) div 2)+yOffset);
          R := tr;
          Rectangle(R);

          {: white border }
          Pen.Color := clWhite;
          Pen.Width := 2;
          MoveTo(R.Left,R.Top);
          LineTo(R.Right,R.Top);
          LineTo(R.Right,R.Bottom);
          LineTo(R.Left,R.Bottom);
          LineTo(R.Left,R.Top);
          {: thin white line in the middle }
          Pen.Width := 1;
          MoveTo(R.Left,R.Top + (R.Height div 2));
          LineTo(R.Right,R.Top + (R.Height div 2));
          {: net }
          InflateRect(R,0,10);
          Pen.Color := clBlack;
          MoveTo(R.Left + (R.Width div 2), R.Top);
          LineTo(R.Left + (R.Width div 2), R.Bottom);
          {: category }
          if Assigned(area.Content) {and (Content.ContentType = actKo) }then
          begin
    //        with (Content.AsObject as TAreaContent) do
    //        begin
              SetBkMode(Handle,TRANSPARENT);
              Font.Size := 10;
              Font.Color := getItemsColor(piHighlight);
              Font.Style := [fsBold];
    //          TextOut(3,3,game.category);
              TextOut(3,3,area.Content.DisplayTopLeft);
              {: match number }
              SetTextAlign(Handle,TA_LEFT);
              Font.Style := [];
    //          TextOut(R.Left + (R.Width div 2) +3, 3, game.gameNumber.ToString);
              TextOut(R.Left + (R.Width div 2) +3, 3, area.Content.DisplayTopMiddle);

              {: start time }
              SetBkMode(Handle, OPAQUE);
              Brush.Color := getItemsColor(piHighLight);
              Font.Color  := getItemsColor(piHighLightText);
              if area.Content.DisplayTopRight <> '' then
              begin
                h := StrToIntDef(Copy(area.Content.DisplayTopRight,1,2),0);
                n := StrToIntDef(Copy(area.Content.DisplayTopRight,4,2),0);
                if h+n > 0 then
                begin
                  t1 := EncodeTime(h,n,0,0);
                  t2 := Time;
                  n := MinutesBetween(t1,t2);
                  if n > 30 then
                  begin
                    Brush.Color := getItemsColor(piError);
                    Font.Color  := clYellow;
                  end;
                end;
              end;
              SetTextAlign(Handle, TA_RIGHT);
              Font.Style := [fsBold];
    //          TextOut(FPanel.Width-3, 3, game.beginTime);
              TextOut(area.Panel.Width-3, 3, area.Content.DisplayTopRight);

              {: main umpire }
              SetBkMode(Handle,TRANSPARENT);
              //Brush.Color := getItemsColor(piGameTable);
              Font.Color := getItemsColor(piUmpire);
              SetTextAlign(Handle, TA_CENTER);
              TextOut(area.Panel.Width div 2,25,area.Content.DisplayMiddleMiddle);
              {: assistant umpire }
      //        TextOut(FPanel.Width div 2,FPanel.Height - 25,'ASSISTANT UMPIRE');
              {: player A / team A }
              SetBkMode(Handle, TRANSPARENT);
        //      SetBkMode(Handle, OPAQUE);
              Font.Color := clBlack;
              Font.Style := [fsBold];
              jr.Height := area.Panel.Height div 2;
              jr.Width := (area.Panel.Width div 8) * 4;
              jr.SetLocation(5, (area.Panel.Height div 3));
    //          pname := Format('%s'+#13#10+'%s'+#13#10+'%s', [game.Player1Name,game.Player1Club,game.Player1Rank]);
              pname := area.Content.DisplayLeft[dlpTop];
              SetTextAlign(Handle, TA_LEFT);
              DrawText(Handle,PChar(pname),Length(pname),jr,dt_left or DT_VCENTER or DT_WORDBREAK);
              {: player B / team B }
              jr.SetLocation(area.Panel.Width - jr.Width - 5, (area.Panel.Height div 3));
    //          pname := Format('%s'+#13#10+'%s'+#13#10+'%s', [game.Player2Name,game.Player2Club,game.Player2Rank]);
              pname := area.Content.DisplayRight[dlpTop];
              DrawText(Handle,PChar(pname),Length(pname),jr,dt_right or DT_VCENTER or DT_WORDBREAK);
              {: score }
              {: end time }
              {: level }
    //          pname := game.level;
              if area.Content.Level <> '' then
              begin
                Brush.Color := clYellow;
                Font.Color := clRed;
                Font.Size := 12;
                Font.Style := [fsBold];
                SetBkMode(Handle, OPAQUE);
                SetTextAlign(Handle, TA_CENTER);
                TextOut(area.Panel.Width div 2,area.Panel.Height - 25, area.Content.Level);
              end;

    //        end;
            {: play area number }
            SetBkMode(Handle,OPAQUE);
            Brush.Color := clCream;
            Ellipse((area.Panel.Width div 2) - 12, ((area.Panel.Height div 2) - 12) +yOffset,
                    (area.Panel.Width div 2) + 12, ((area.Panel.Height div 2) + 12) +yOffset);
            Font.Color := getItemsColor(piArena);
            Font.Size := 12;
            Font.Style := [fsBold];
            SetBkMode(Handle,TRANSPARENT);
            SetTextAlign(Handle, TA_CENTER);
            TextOut(area.Panel.Width div 2,
                    ((area.Panel.Height - TextHeight('W')) div 2)+yOffset,
                    area.Content.PlayAreaNumber.ToString);
          end;
        end;
      finally
        cc.Free;
      end;
    end;
  glPaintPlayAreaGroupContent := glPaintPlayAreaGameContent;

finalization
  lcGetColorQuery.Free;
  lcSetColorQuery.Free;
  pvCheckCategStatusSelCategData.Free;
  pvCheckCategStatusSelPrpTabCount.Free;
  pvCheckCategStatusSelGamesCount.Free;
  pvCheckCategStatusSelGamesStatusCount.Free;
  pvCheckCategStatusSelTabloCount.Free;
  pvUpdateCategorysStatusQuery.Free;
  pvCheckCategStatusSelGroupGamesCount.Free;
  pvCheckCategStatusSelGroupCount.Free;
  glSettingsValues.Free;
end.
