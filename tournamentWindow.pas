unit tournamentWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, childWindow, Vcl.StdCtrls, Vcl.ExtCtrls, ZDataset,DB,
  Vcl.Mask, Vcl.DBCtrls, Vcl.ComCtrls, lal_sequence, Vcl.Grids, Vcl.DBGrids,
  System.Actions, Vcl.ActnList, mainWindow, Vcl.Menus, Vcl.DBCGrids,
  Vcl.Buttons, ZAbstractRODataset,tmUtils15, lal_connection, Contnrs, lal_seek,
  groupPanel, TMEnums;

type
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

  TSens = (ssCroissant,ssDecroissant);

  TOpenMode = (omCreate,omLoad);
  TtournamentW = class(TchildW)
    tournamentSource: TDataSource;
    Label1: TLabel;
    sertrn: TDBEdit;
    saison: TDBEdit;
    Label2: TLabel;
    Label3: TLabel;
    dattrn: TDBEdit;
    organisateur: TDBEdit;
    Label4: TLabel;
    Label5: TLabel;
    libelle: TDBEdit;
    Label6: TLabel;
    maxcat: TDBEdit;
    pg: TPageControl;
    catSheet: TTabSheet;
    catSource: TDataSource;
    Panel1: TPanel;
    Panel2: TPanel;
    DBNavigator1: TDBNavigator;
    catGrid: TDBGrid;
    clscatSource: TDataSource;
    tournamentNav: TDBNavigator;
    importButton: TButton;
    inscSheet: TTabSheet;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    inscGrid: TDBGrid;
    inscSource: TDataSource;
    joueursSheet: TTabSheet;
    Panel7: TPanel;
    Panel8: TPanel;
    joueursGrid: TDBGrid;
    joueursSource: TDataSource;
    ClubsSheet: TTabSheet;
    Panel9: TPanel;
    Panel10: TPanel;
    clubsGrid: TDBGrid;
    clubsSource: TDataSource;
    DisplayCategoryButton: TButton;
    ActionsList: TActionList;
    tabSheet: TTabSheet;
    Panel11: TPanel;
    Panel12: TPanel;
    Splitter1: TSplitter;
    Panel13: TPanel;
    Panel14: TPanel;
    tabSource: TDataSource;
    prpSource: TDataSource;
    prpGrid: TDBGrid;
    PrepareAction: TAction;
    prpclbSource: TDataSource;
    Splitter2: TSplitter;
    PreparationPanel: TPanel;
    autoDrawAction: TAction;
    tabloSource: TDataSource;
    Memo1: TMemo;
    Splitter3: TSplitter;
    addAPlayerAction: TAction;
    DBNavigator4: TDBNavigator;
    DBNavigator5: TDBNavigator;
    DBNavigator6: TDBNavigator;
    Label11: TLabel;
    codcls: TDBEdit;
    Button2: TButton;
    ResetAction: TAction;
    GenerateDrawGamesAction: TAction;
    excelAction: TAction;
    Panel16: TPanel;
    prpclbGrid: TDBGrid;
    Panel17: TPanel;
    Label7: TLabel;
    sertab: TDBText;
    Label8: TLabel;
    nbrjou: TDBText;
    Label9: TLabel;
    nbrtds: TDBText;
    taille: TDBText;
    Label10: TLabel;
    prpButton: TButton;
    autoDrawButton: TButton;
    aleatoireBox: TCheckBox;
    AddAPlayerButton: TButton;
    Button5: TButton;
    GenerateGamesButton: TButton;
    Button7: TButton;
    Splitter4: TSplitter;
    Splitter5: TSplitter;
    Panel18: TPanel;
    Panel19: TPanel;
    Panel20: TPanel;
    DBNavigator7: TDBNavigator;
    codcat: TDBText;
    Panel3: TPanel;
    clsGrid: TDBGrid;
    Panel21: TPanel;
    DBNavigator2: TDBNavigator;
    clsCatageButton: TButton;
    orderByAction: TAction;
    resetGridMenu: TPopupMenu;
    Resetorderby1: TMenuItem;
    joueurs: TDBText;
    GamesSheet: TTabSheet;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    Label12: TLabel;
    levelBox: TComboBox;
    leftMatchPanel: TPanel;
    midMatchPanel: TPanel;
    rightMatchPanel: TPanel;
    mtclv1Source: TDataSource;
    leftMatchGrid: TDBCtrlGrid;
    DBText1: TDBText;
    DBText2: TDBText;
    DBText3: TDBText;
    DBText4: TDBText;
    mtclv2Source: TDataSource;
    midMatchGrid: TDBCtrlGrid;
    rightMatchGrid: TDBCtrlGrid;
    mtclv3Source: TDataSource;
    DBText13: TDBText;
    DBText14: TDBText;
    DBText7: TDBText;
    DBText8: TDBText;
    DBText9: TDBText;
    DBText10: TDBText;
    DBText11: TDBText;
    DBText12: TDBText;
    DBText17: TDBText;
    DBText18: TDBText;
    DBText19: TDBText;
    DBText20: TDBText;
    DBText21: TDBText;
    DBText22: TDBText;
    DBText25: TDBText;
    checkMatchesAction: TAction;
    DBText5: TDBText;
    DBText6: TDBText;
    DBText15: TDBText;
    byeButton: TBitBtn;
    DBText16: TDBText;
    saisieButton: TBitBtn;
    ouverts: TCheckBox;
    DBText23: TDBText;
    sercat: TDBText;
    DBText27: TDBText;
    DBText28: TDBText;
    DBText29: TDBText;
    BitBtn1: TBitBtn;
    umpiresAction: TAction;
    ziedelenAction: TAction;
    importAction: TAction;
    DBText24: TDBText;
    DBText26: TDBText;
    DBText30: TDBText;
    DBText31: TDBText;
    DBText32: TDBText;
    SeedAction: TAction;
    Button9: TButton;
    Button10: TButton;
    completCheck: TCheckBox;
    score: TCheckBox;
    eliminateAction: TAction;
    inscGridMenu: TPopupMenu;
    disqualifyMenu: TMenuItem;
    BitBtn2: TBitBtn;
    inscAction: TAction;
    editMatchAction: TAction;
    CtrlGridMenu: TPopupMenu;
    Editer1: TMenuItem;
    Label13: TLabel;
    inscSearch: TEdit;
    Label14: TLabel;
    joueurSearch: TEdit;
    Label15: TLabel;
    expcol: TDBEdit;
    resultsAction: TAction;
    Button11: TButton;
    internetAction: TAction;
    Button12: TButton;
    checkDoublonsButton: TButton;
    checkDoublonsAction: TAction;
    BitBtn3: TBitBtn;
    arenaAction: TAction;
    Label16: TLabel;
    numtbl: TDBEdit;
    requalifyMenu: TMenuItem;
    BitBtn4: TBitBtn;
    codclb: TDBEdit;
    SpeedButton1: TSpeedButton;
    manualDrawAction: TAction;
    ManuelDrawButton: TButton;
    SetCategStatutAction: TAction;
    categPopup: TPopupMenu;
    SetCategStatusMenu: TMenuItem;
    SeekConfigAction: TAction;
    SeekConfigureMenu: TPopupMenu;
    SeekconfigMenu: TMenuItem;
    SelectSeekCodClbAction: TAction;
    SelectSeekMenu: TMenuItem;
    SelectSeekSaisonAction: TAction;
    SelectSeekCategAction: TAction;
    Modifierlestatut1: TMenuItem;
    Label17: TLabel;
    firstRoundModeTournoi: TDBEdit;
    SelectFirstRoundModeAction: TAction;
    GroupsButton: TButton;
    SetGroupsAction: TAction;
    PreparationPageControl: TPageControl;
    DrawSheet: TTabSheet;
    GroupsSheet: TTabSheet;
    tabloGrid: TDBGrid;
    groupsPanel: TPanel;
    GroupsScrollBox: TScrollBox;
    SetPhaseAction: TAction;
    Modifierlaphase1: TMenuItem;
    GenerateGroupGamesAction: TAction;
    DisplayTableauAction: TAction;
    DBText33: TDBText;
    DBText34: TDBText;
    SetFirstRoundModeAction: TAction;
    Modifierlemode1ertour1: TMenuItem;
    N1: TMenuItem;
    Swap2PlayersAction: TAction;
    Swap2PlayersButton: TButton;
    PrepareForKOPhaseAction: TAction;
    PrepareforKOphaseMenu: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure clsCatageButtonClick(Sender: TObject);
    procedure pgChanging(Sender: TObject; var AllowChange: Boolean);
    procedure pgChange(Sender: TObject);
    procedure catGridTitleClick(Column: TColumn);
    procedure PrepareActionExecute(Sender: TObject);
    procedure prpGridCellClick(Column: TColumn);
    procedure prpGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; AState: TGridDrawState);
    procedure prpclbGridCellClick(Column: TColumn);
    procedure autoDrawActionExecute(Sender: TObject);
    procedure tabloGridDblClick(Sender: TObject);
    procedure addAPlayerActionExecute(Sender: TObject);
    procedure ResetActionExecute(Sender: TObject);
    procedure Memo1DblClick(Sender: TObject);
    procedure GenerateDrawGamesActionExecute(Sender: TObject);
    procedure excelActionExecute(Sender: TObject);
    procedure catGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure tabloGridTitleClick(Column: TColumn);
    procedure orderByActionExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure catSourceDataChange(Sender: TObject; Field: TField);
    procedure levelBoxChange(Sender: TObject);
    procedure GamesSheetResize(Sender: TObject);
    procedure checkMatchesActionExecute(Sender: TObject);
    procedure leftMatchGridDblClick(Sender: TObject);
    procedure leftMatchGridKeyPress(Sender: TObject; var Key: Char);
    procedure byeButtonClick(Sender: TObject);
    procedure ouvertsClick(Sender: TObject);
    procedure leftMatchGridPaintPanel(DBCtrlGrid: TDBCtrlGrid; Index: Integer);
    procedure umpiresActionExecute(Sender: TObject);
    procedure ziedelenActionExecute(Sender: TObject);
    procedure importActionExecute(Sender: TObject);
    procedure SeedActionExecute(Sender: TObject);
    procedure eliminateActionExecute(Sender: TObject);
    procedure DBText2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DBText3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure inscGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure inscActionExecute(Sender: TObject);
    procedure editMatchActionExecute(Sender: TObject);
    procedure inscSearchChange(Sender: TObject);
    procedure joueurSearchChange(Sender: TObject);
    procedure catGridKeyPress(Sender: TObject; var Key: Char);
    procedure resultsActionExecute(Sender: TObject);
    procedure internetActionExecute(Sender: TObject);
    procedure checkDoublonsActionExecute(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure requalifyMenuClick(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure tournamentSourceDataChange(Sender: TObject; Field: TField);
    procedure codclbKeyPress(Sender: TObject; var Key: Char);
    procedure tournamentNavClick(Sender: TObject; Button: TNavigateBtn);
    procedure SpeedButton1Click(Sender: TObject);
    procedure manualDrawActionExecute(Sender: TObject);
    procedure ActionsListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure codclbEnter(Sender: TObject);
    procedure codclbKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SetCategStatutActionExecute(Sender: TObject);
    procedure inscGridDblClick(Sender: TObject);
    procedure SeekConfigActionExecute(Sender: TObject);
    procedure SelectSeekCodClbActionExecute(Sender: TObject);
    procedure saisonEnter(Sender: TObject);
    procedure SelectSeekSaisonActionExecute(Sender: TObject);
    procedure saisonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SelectSeekCategActionExecute(Sender: TObject);
    procedure catGridEnter(Sender: TObject);
    procedure firstRoundModeTournoiEnter(Sender: TObject);
    procedure SelectFirstRoundModeActionExecute(Sender: TObject);
    procedure firstRoundModeTournoiKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SetGroupsActionExecute(Sender: TObject);
    procedure catGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure inscGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure joueursGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure clubsGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure joueursGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure clubsGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure SetPhaseActionExecute(Sender: TObject);
    procedure catGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GenerateGroupGamesActionExecute(Sender: TObject);
    procedure DisplayCategoryButtonClick(Sender: TObject);
    procedure DisplayTableauActionExecute(Sender: TObject);
    procedure catGridDblClick(Sender: TObject);
    procedure SetFirstRoundModeActionExecute(Sender: TObject);
    procedure Swap2PlayersActionExecute(Sender: TObject);
    procedure PrepareForKOPhaseActionExecute(Sender: TObject);
  private
    { Déclarations privées }
    _openMode: TOpenMode;
    _sertrn: integer;
    _tournament,
    _cat,
    _clscat,
    _insc,
    _clubs,
    _joueurs,
    _tab,
    _prp,
    _prpclb,
    _tablo,
    _mtclv1,
    _mtclv2,
    _mtclv3 : TZQuery;
    _xls,
    _wkb,
    _sht: variant;
    _stabylo,
    _stabval: string;
    _debug: TStrings;
    _loading: boolean;
    pvCnx: TLalConnection;
    pvSeq: TLalSequence;
    pvSeek: TLalSeek;
    pvStagrp: TZReadOnlyQuery;

    function  CreeGroupeQualification(const sercat,sertrn,numgrp: integer): integer;
    function  editMatch(const sermtc: integer): boolean;
    function CreateGroupPanel(const sergrp: integer): TGroupPanel;
    function InsereJoueurDansGroupeQualification(const sergrp,serjou,sercat,sertrn: integer): integer;
    function SelectSeek(var seek_code: string): boolean;
    procedure ActivateTabSheet(PageControl: TPageControl; Sheet: TTabSheet);
    procedure afterCancel(Dataset: TDataset);
    procedure afterPost(Dataset: TDataset);
    procedure arenaView;
    procedure beforeDelete(Dataset: TDataset);
    procedure beforeInsert(Dataset: TDataset);
    procedure build(tablo: TTablo; aleatoire: boolean);
    procedure BuildGroups(const sercat: integer);
    procedure CalculeNumeroGroupe(var numgrp: integer; const nbrgrp: integer; var sens: TSens);
    procedure checkMatchesLevel(const sertab: integer; const level: integer);
    procedure ClearGroups;
    function GetQualificationsGroupStatusCount(const sercat: integer; const qgs: TQualificationGroupStatus): integer;
    procedure closeDatasets;
    procedure colorsChanged(var Message: TMessage); message wm_colorsChanged;
    procedure ComposeGroupes(const sercat: integer);
    procedure CreateGroupPanels(const sercat: integer);
    procedure dbGridColumns(grid: TDBGrid);
    procedure debug(const text: string);
    procedure DisplayGroups(const sercat: integer);
    procedure RefreshGroups;
    procedure DisplayTableau;
    procedure doImportation;
    procedure doublonDataChange(Sender: TObject; Field: TField);
    procedure FirstRoundModeGetText(Sender: TField; var Text: string; DisplayText: boolean);
    procedure GenerateTabValues(sertab: integer);
    procedure handicapGetText(Sender: TField; var Text: string; DisplayText: boolean);
    procedure importation;
    procedure joueursGetText(Sender: TField; var Text: string; DisplayText: boolean);
    procedure matchModifieGetText(Sender: TField; var Text: string; DisplayText: boolean);
    procedure newRecord(Dataset: TDataset);
    procedure nilArenaView;
    procedure nummtcGetText(Sender: TField; var Text: string; DisplayText: boolean);
    procedure numtblGetText(Sender: TField; var Text: string; DisplayText: boolean);
    procedure onCategChange(var Message: TMessage); message wm_categChanged;
    procedure openImportationDocument(const filename: string);
    procedure openMatches;
    procedure PhaseGetText(Sender: TField; var Text: string; DisplayText: boolean);
    procedure PositionneGroupPanel(gp: TGroupPanel; const nbrgrp: integer);
    procedure QualifieTDS(const sercat: integer);
    procedure SetGenerateGamesButtonAction;
//    procedure _stacat(const sercat: integer; const stacat: TCategorysStatus);
    procedure updateTableau(sertab: integer);
    procedure updateTDS(const sertab: integer; const tempTableName: string);
    procedure writeDatasets;

    procedure categoryStatutGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure registrationStatusGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure ExecuteDisplayTableauAction;

    procedure QualificationGroupRefresh(var Message: TMessage); message wm_qualificationGroupRefresh;
    function PrepareExportDirectories(const sertrn: integer;
      const organisateur: string): TFilename;

  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent; cnx: TLalConnection; sertrn: integer); reintroduce; overload;
  end;

implementation

{$R *.dfm}

uses
  lal_dbUtils, tournamentsWindow, DateUtils, clscatageWindow, Math, lal_utils,
  System.UITypes, u_pro_excel, tabloWindow, SeekConfigsWindow,
  joueursNonPlacesWindow, addAPlayerWindow, matchWindow, saisieWindow,
  umpiresWindow, inscJoueur, internetWindow, dataWindow, PlayerPathWindow,
  TypInfo, arena15Window, dataGridWindow, getTableNumberDialog,
  manualDrawWindow, SeedsWindow, Swap2PlayersWindow, Tournament, Game, Category;

var
  saisie: TsaisieW;
  insc: TinscJouW;
  FDoublons: TDataW;

procedure TtournamentW.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  writeDatasets;
  closeDatasets;
  inherited;
end;

procedure TtournamentW.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  _debug := TStringList.Create;
  _sertrn := -1;
  pvSeq := TLalSequence.Create(Self, pvCnx);

  _tournament := getQuery(pvCnx, Self);
  _tournament.SQL.Add('SELECT sertrn,saison,dattrn,codclb,organisateur,libelle,maxcat,codcls,expcol,numtbl,first_round_mode'
                     +' ,(SELECT coalesce(COUNT( * ),0) FROM insc WHERE sertrn = :sertrn) inscriptions'
                     +' ,first_round_mode mode'
                     +' FROM tournoi'
                     +' WHERE sertrn = :sertrn');
  _tournament.Prepare;
  _tournament.OnNewRecord := newRecord;
  _tournament.AfterCancel := afterCancel;
  _tournament.FieldDefs.Update;
  for i := 0 to Pred(_tournament.FieldDefs.Count) do
    _tournament.FieldDefs[i].CreateField(Self);
  _tournament.FieldByName('first_round_mode').OnGetText := FirstRoundModeGetText;

  _cat := getQuery(pvCnx, Self);
  _cat.SQL.Add('SELECT sercat,sertrn,saison,codcat,heudeb,simple,handicap,numset'
              +'      ,catage,stacat,numseq,first_round_mode,phase,parent'
              +' ,(SELECT COUNT(*) FROM insc a WHERE a.sercat = b.sercat) participants'
              +' ,(SELECT COUNT( * ) FROM match a WHERE a.sertab = b.sercat and'
              +'       ((a.serjo1 > 0 and a.serjo2 > 0 and a.level = 1 and a.stamtc = 0)'
              +'         or (a.level > 1 and stamtc = 0))) a_jouer'
              +' FROM categories b'
              +' WHERE sertrn = :sertrn'
              +' ORDER BY heudeb');
  _cat.Prepare;
  _cat.OnNewRecord := newRecord;
  _cat.AfterPost := afterPost;
  catSource.DataSet := _cat;

  _clscat := getQuery(pvCnx, Self);
  _clscat.SQL.Add('SELECT sercat,codcls'
                 +'   ,(SELECT COUNT( * ) FROM tablo b WHERE sertab = :sercat'
                 +'        and serjou > 0'
                 +'        and a.codcls = b.codcls) joueurs'
                 +' FROM classements a'
                 +' WHERE sercat = :sercat'
                 +' order by 2');
  _clscat.Prepare;
  _clscat.OnNewRecord := newRecord;
  _clscat.DataSource := catSource;
  clscatSource.Dataset := _clscat;

  _insc := getQuery(pvCnx, Self);
  { 02.12.2021 : réécrit pour firebird 4.0 }
  _insc.SQL.Add('SELECT'
               +' 	 j1.LICENCE ,j1.NOMJOU ,j1.CODCLS ,c1.NUMSEQ +coalesce(c2.NUMSEQ,0) seqcls,j1.TOPCLS ,j1.TOPDEM ,a.DATINSC ,j1.CODCLB,cb1.LIBCLB'
               +' 	,j2.LICENCE ,j2.NOMJOU ,j2.CODCLS ,COALESCE(c2.NUMSEQ,0) +c1.NUMSEQ seqcls,j2.TOPCLS ,j2.TOPDEM ,a.DATINSC ,j2.CODCLB,cb2.LIBCLB libclbptn'
               +'   ,j1.VRBRGL + coalesce(j2.VRBRGL,0) vrbrgl,a.SERINSC ,j1.SERJOU ,a.STATUT'
               +' 	FROM insc a'
               +' 		LEFT JOIN JOUEUR j1 ON a.SERJOU = j1.SERJOU'
               +' 			LEFT JOIN CLASSEMENT c1 ON c1.CODCLS =  j1.CODCLS'
               +' 			LEFT JOIN club cb1 ON cb1.CODCLB = j1.CODCLB'
               +' 		LEFT JOIN joueur j2 ON a.SERPTN = j2.SERJOU'
               +' 			LEFT JOIN CLASSEMENT c2 ON c2.CODCLS =  j2.CODCLS'
               +' 			LEFT JOIN club cb2 ON cb2.CODCLB = j2.CODCLB'
               +' WHERE a.SERTRN = :sertrn');

//  _insc.SQL.Add('SELECT  b.licence,b.nomjou,b.codcls,d.numseq+coalesce(e.numseq,0)seqcls,b.topcls,b.topdem,a.datinsc,b.codclb,k.libclb'
//               +'       ,c.licence licptn,c.nomjou nomptn,c.codcls clsptn,c.codclb clbptn,q.libclb libclbptn'
//               +'       ,b.vrbrgl+coalesce(c.vrbrgl,0)vrbrgl,a.serinsc,b.serjou,a.statut'
//               +' FROM insc a LEFT OUTER JOIN joueur c ON (a.serptn = c.SERJOU AND c.saison = :saison)'
//               +'     ,joueur b,classement d LEFT OUTER JOIN classement e ON c.codcls = e.codcls'
//               +'     ,club k LEFT OUTER JOIN club q ON c.codclb = q.CODCLB'
//               +' WHERE a.sertrn = :sertrn'
//               +'   and a.sercat = :sercat'
//               +'   and a.serjou = b.serjou'
//               +'   and b.codcls = d.codcls'
//               +'   and b.codclb = k.codclb'
//               +'   and b.saison = :saison'
//               +' order by seqcls,vrbrgl');
  _insc.Prepare;
  _insc.DataSource := catSource;
  _insc.BeforeDelete := beforeDelete;
  inscSource.DataSet := _insc;

  _joueurs := getQuery(pvCnx, Self);
  _joueurs.SQL.Add('SELECT a.licence,a.nomjou,a.codcls,d.codcat,a.topcls,a.topdem,a.vrbrgl'
               +'      ,b.datinsc,a.codclb,c.libclb, a.serjou'
               +' FROM insc b, joueur a, club c, categories d'
               +' WHERE b.sertrn = :sertrn'
               +'   and a.serjou = b.serjou'
               +'   and a.codclb = c.codclb'
               +'   and a.saison = :saison'
               +'   and b.sercat = d.sercat'
               +' order by a.nomjou,d.codcat');
  _joueurs.DataSource := tournamentSource;
  joueursSource.DataSet := _joueurs;

  _clubs := getQuery(pvCnx, Self);
  _clubs.SQL.Add('SELECT a.codclb,c.libclb,a.licence,a.nomjou,a.codcls,d.codcat'
               +'      ,a.topcls,a.topdem,a.vrbrgl'
               +'      ,b.datinsc'
               +' FROM insc b, joueur a, club c, categories d'
               +' WHERE b.sertrn = :sertrn'
               +'   and a.serjou = b.serjou'
               +'   and a.codclb = c.codclb'
               +'   and a.saison = :saison'
               +'   and b.sercat = d.sercat'
               +' order by a.codclb,a.nomjou,d.codcat');
  _clubs.DataSource := tournamentSource;
  clubsSource.DataSet := _clubs;

  _tab := getQuery(pvCnx, Self);
  _tab.SQL.Add('SELECT sertab,taille,nbrjou,nbrtds,sertrn,nbrgrp'
             +' FROM tableau'
             +' WHERE sertab = :sertab');
  _tab.Prepare;
  tabSource.DataSet := _tab;

  _prp := getQuery(pvCnx, Self);
  _prp.SQL.Add('SELECT serprp,sertab,sertrn,serjou,serptn,licence,nomjou,codclb'
              +'      ,libclb,seqcls,codcls,classement,vrbrgl,numtds,serblo'
              +'      ,sergrp,is_qualified'
              +' FROM prptab'
              +' WHERE sertab = :sertab'
              +' ORDER BY numtds,vrbrgl');
  _prp.Prepare;
  _prp.DataSource := tabSource;
  _prp.BeforeInsert := beforeInsert;
  prpSource.DataSet := _prp;

  _prpclb := getQuery(pvCnx, Self);
  _prpclb.SQL.Add('SELECT c.codclb,c.libclb,COUNT(*) participants'
                 +' FROM insc a, joueur b, club c'
                 +' WHERE a.serjou = b.serjou'
                 +'   and b.codclb = c.codclb'
                 +'   and a.sercat = :sertab'
                 +' group by 1,2'
                 +' order by 3 desc');
  _prpclb.Prepare;
  _prpclb.DataSource := tabSource;
  prpclbSource.DataSet := _prpclb;

  _tablo := getQuery(pvCnx, Self);
  _tablo.SQL.Add('SELECT serblo,sertab,serjou,licence,nomjou,codclb,libclb,codcls,vrbrgl,numtds,numrow,sertrn'
                +' FROM tablo'
                +' WHERE sertab = :sertab'
                +' order by numrow');
  _tablo.Prepare;
  _tablo.DataSource := tabSource;
  tabloSource.DataSet := _tablo;

  _mtclv1 := getQuery(pvCnx, Self);
  _mtclv1.SQL.Add('SELECT sermtc,numseq,nummtc,serjo1,serjo2,handi1,handi2,score'
                 +'  ,vainqueur,perdant,prochain,stamtc,a.sertab,a.games'
                 +'  ,a.modifie,a.numtbl'
                 +'  ,b.nomjou nomjo1,b.libclb libcl1,b.codcls codcl1'
                 +'  ,c.nomjou nomjo2,c.libclb libcl2,c.codcls codcl2'
                 +' FROM match a left outer join tablo b ON a.sertab = b.sertab and a.serjo1 = b.serjou'
                 +'              left outer join tablo c ON a.sertab = c.sertab and a.serjo2 = c.serjou'
                 +' WHERE a.sertab = :sertab'
                 +'   and a.level = :level'
                 +' order by a.numseq');
  _mtclv1.Prepare;
  _mtclv1.FieldDefs.Update;
  for i := 0 to Pred(_mtclv1.FieldDefs.Count) do
    _mtclv1.FieldDefs[i].CreateField(Self);
  _mtclv1.FieldByName('handi1').OnGetText := handicapGetText;
  _mtclv1.FieldByName('handi2').OnGetText := handicapGetText;
  _mtclv1.FieldByName('nummtc').OnGetText := nummtcGetText;
  _mtclv1.FieldByName('modifie').OnGetText := matchModifieGetText;
  _mtclv1.FieldByName('numtbl').OnGetText := numtblGetText;
  _mtclv1.BeforeInsert := beforeInsert;
  mtclv1Source.DataSet := _mtclv1;

  _mtclv2 := getQuery(pvCnx, Self);
  _mtclv2.SQL.Add(_mtclv1.SQL.Text);
  _mtclv2.Prepare;
  _mtclv2.FieldDefs.Update;
  for i := 0 to Pred(_mtclv2.FieldDefs.Count) do
    _mtclv2.FieldDefs[i].CreateField(Self);
  _mtclv2.FieldByName('handi1').OnGetText := handicapGetText;
  _mtclv2.FieldByName('handi2').OnGetText := handicapGetText;
  _mtclv2.FieldByName('nummtc').OnGetText := nummtcGetText;
  _mtclv2.BeforeInsert := beforeInsert;
  _mtclv2.FieldByName('modifie').OnGetText := matchModifieGetText;
  _mtclv2.FieldByName('numtbl').OnGetText := numtblGetText;
  mtclv2Source.DataSet := _mtclv2;

  _mtclv3 := getQuery(pvCnx, Self);
  _mtclv3.SQL.Add(_mtclv1.SQL.Text);
  _mtclv3.Prepare;
  _mtclv3.FieldDefs.Update;
  for i := 0 to Pred(_mtclv3.FieldDefs.Count) do
    _mtclv3.FieldDefs[i].CreateField(Self);
  _mtclv3.FieldByName('handi1').OnGetText := handicapGetText;
  _mtclv3.FieldByName('handi2').OnGetText := handicapGetText;
  _mtclv3.FieldByName('nummtc').OnGetText := nummtcGetText;
  _mtclv3.FieldByName('modifie').OnGetText := matchModifieGetText;
  _mtclv3.FieldByName('numtbl').OnGetText := numtblGetText;
  _mtclv3.BeforeInsert := beforeInsert;
  mtclv3Source.DataSet := _mtclv3;

  pvStagrp := getROQuery(pvCnx, Self);
  pvStaGrp.SQL.Add('SELECT COUNT(*) FROM groupe'
                  +' WHERE sercat = :sercat'
                  +'   AND stagrp = :stagrp');
  pvStagrp.Prepare;

  pvSeek := TLalSeek.Create(Self);
  pvSeek.Connection := pvCnx.get;
  pvSeek.SeekKey := VK_F3;
end;

procedure TtournamentW.FormDestroy(Sender: TObject);
const
  checked: array[boolean] of string = ('0','1');
begin
  _debug.Free;
  glSettings.Write('settings','exportScore','pardc1',checked[score.Checked]);
  glSettings.write('settings','exportComplet','pardc1',checked[completCheck.Checked]);
  glSettings.Write;
  inherited;
end;

procedure TtournamentW.FormShow(Sender: TObject);
begin
  inherited;
  _loading := True;
  bottomPanel.Visible := False;
  _tournament.ParamByName('sertrn').AsInteger := _sertrn;
  _tournament.Open;
  tournamentSource.DataSet := _tournament;
  _tournament.FieldByName('inscriptions').OnGetText := joueursGetText;
  _cat.DataSource := tournamentSource;
  _cat.Open;
  _cat.FieldByName('stacat').OnGetText := categoryStatutGetText;
  _cat.FieldByName('phase').OnGetText := PhaseGetText;
  _cat.FieldByName('first_round_mode').OnGetText := FirstRoundModeGetText;
  dbGridColumns(catGrid);
  _clscat.Open;
  dbGridColumns(inscGrid);
  dbGridColumns(joueursGrid);
  dbGridColumns(clubsGrid);
  dbGridColumns(prpGrid);
  dbGridColumns(prpclbGrid);
  dbGridColumns(tabloGrid);
  pg.ActivePage := catSheet;
  leftMatchGrid.RowCount := 8;
  midMatchGrid.RowCount := 8;
  rightMatchGrid.RowCount := 8;

  score.Checked := glSettings.Read('settings','exportScore','pardc1','1') = '1';
  completCheck.Checked := glSettings.Read('settings','exportComplet','pardc1','0') = '1';

  if _openMode = omCreate then
  begin
    with getROQuery(pvCnx) do
    begin
      try
        SQL.Add('INSERT INTO tournoi (sertrn,saison,dattrn,organisateur,libelle,maxcat,codcls,codclb,expcol,first_round_mode)'
               +' VALUES '
               +'(:sertrn,:saison,:dattrn,:organisateur,:libelle,:maxcat,:codcls,:codclb,:codclb,:first_round_mode)');

        pvSeek.Seek_Code := glSettings.SeekCodeClub;

        if pvSeek.Seek then
        begin
          ParamByName('codclb').AsString := pvSeek.Returns.Values['CODCLB'];
          ParamByName('organisateur').AsString := pvSeek.Returns.Values['LIBCLB'];
        end
        else
        begin
          ParamByName('codclb').AsString := '???';
          ParamByName('organisateur').AsString := 'Nom de l''organisation';
        end;

        _sertrn := pvSeq.SerialByName('TOURNOI');
        ParamByName('sertrn').AsInteger := _sertrn;
        ParamByName('saison').AsInteger := getCurrentSaison;
        ParamByName('dattrn').AsDateTime := Today;
        ParamByName('libelle').AsString := 'Nom de l''évènement';
        ParamByName('maxcat').AsString := getDefValue('tournoi','maxcat','3');
        ParamByName('codcls').AsString := getDefValue('tournoi','codcls','topdem');
        ParamByName('first_round_mode').AsString := getDefValue('tournoi','first_round_mode',Ord(frQualification).ToString);
        ExecSQL;

        _tournament.Close;
        _tournament.ParamByName('sertrn').AsInteger := _sertrn;
        _tournament.Open;
        _tournament.FieldByName('inscriptions').OnGetText := joueursGetText;
      finally
        Free;
      end;
    end;
  end
  else
  begin
    if _sertrn = -1 then
    begin
      _tournament.Close;
      { choose an existing tournament }
      with TtournamentsW.Create(nil,pvCnx.get) do
      begin
        try
          _sertrn := -1;
          if ShowModal = mrOk then
          begin
            if not dataSource.DataSet.IsEmpty then
              _sertrn := dataSource.DataSet.FieldByName('sertrn').AsInteger;
          end;
        finally
          Free;
        end;
      end;
      if _sertrn > -1 then
      begin
        _tournament.ParamByName('sertrn').AsInteger := _sertrn;
        _tournament.Open;
        _tournament.FieldByName('inscriptions').OnGetText := joueursGetText;
      end;
    end;
  end;


  if _tournament.Active and not _tournament.IsEmpty then
  begin
    Caption := libelle.Field.AsString;
    WindowState := wsMaximized;
    if not catGrid.DataSource.DataSet.IsEmpty then
      catGrid.SetFocus
    else
      importButton.SetFocus;
    getTableNumberDlg := TgetTableNumberDlg.Create(Self, pvCnx, sertrn.Field.AsInteger);
    glSettings.Read;
  end
  else
    Close;

  //arenaView;

  internetAction.Enabled := True;

  _loading := False;
end;

procedure TtournamentW.handicapGetText(Sender: TField; var Text: string;
  DisplayText: boolean);
begin
  if Sender.AsInteger > 0 then
    Text := Format('+%d', [Sender.AsInteger]);
end;

procedure TtournamentW.importActionExecute(Sender: TObject);
var
  _import: boolean;
begin
  inherited;
  { on controle si il existe au moins 1 enregistrement de joueur. Si oui, demande
    de confirmation, sinon importation directe }
  with getROQuery(pvCnx) do
  begin
    try
      SQL.Add('SELECT COUNT(*) FROM insc WHERE sercat in '
             +' (SELECT sercat FROM categories WHERE sertrn = ' + IntToStr(_sertrn) + ')');
      Open;
      _import := Fields[0].AsInteger = 0;
      if not _import then
        _import := (MessageDlg('Voulez-vous réimporter les inscriptions ?',mtConfirmation,[mbYes,mbNo],0) = mrYes);
      if _import then
        importation;
    finally
      Free;
    end;
  end;
end;

procedure TtournamentW.importation;
  function getImportFilename: string;
  begin
    Result := '';
    with TOpenDialog.Create(Self) do
    begin
      try
        Filter := 'Excel files (*.xlsx)|*.xlsx|Excel files (*.xls)|*.xls|CSV Files (*.csv)|*.csv|All Files (*.*)|*.*';
        FilterIndex := 1;
        if Execute then
          Result := Filename;
      finally
        Free;
      end;
    end;
  end;
var
  filename: string;
begin
  filename := getImportFilename;
  if FileExists(filename) then
  begin
    openImportationDocument(filename);
    Screen.Cursor := crSQLWait;
    try
      doImportation;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TtournamentW.inscActionExecute(Sender: TObject);
begin
  inherited;
  if not Assigned(insc) then
    insc := TinscJouW.Create(Self, pvCnx, _sertrn);
  insc.Show;
end;

procedure TtournamentW.inscGridDblClick(Sender: TObject);
begin
  inherited;
  with TPlayerPathW.Create(Self,pvCnx,TDBGrid(Sender).DataSource.DataSet.FieldByName('serjou').AsInteger,tournamentSource.DataSet.FieldByName('sertrn').AsInteger) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TtournamentW.inscGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
const
  cl: array[TRegistrationStatus] of TColor = (clSilver,clCream,$00DDBBFF);
  cs: array[TRegistrationStatus] of TPingItem = (piDisqualified,piQualified,piWO);
begin
  inherited;
  with inscGrid.Canvas do
  begin
    if not inscGrid.DataSource.DataSet.IsEmpty then
      Brush.Color := getRegistrationColor(TRegistrationStatus(inscGrid.DataSource.DataSet.FieldByName('statut').Value));
//    if (gdSelected in State) or (gdRowSelected in State) then
//      Font.Style := [fsBold];
    dbgrid_highlight_current(TDBGrid(sender),Rect,DataCol,Column,State);
  end;
  TDBGrid(sender).DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TtournamentW.inscGridMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  dbgrid_mousemove(TDBGrid(Sender),Shift,X,Y);
end;

procedure TtournamentW.inscSearchChange(Sender: TObject);
begin
  inherited;
  if (Trim(inscSearch.Text) <> '') and (Length(Trim(inscSearch.Text))>2) then
  begin
    if not _insc.Locate('nomjou',Trim(inscSearch.Text),[loCaseInsensitive]) then
    begin
      with getROQuery(pvCnx) do
      begin
        try
          SQL.Add('SELECT serinsc'
                 +' FROM insc a, joueur b'
                 +' WHERE a.serjou = b.serjou'
                 +'   and a.sercat = :sercat'
                 +'   and b.nomjou like ' + QuotedStr(Trim(inscSearch.Text)+'%')
                 +' order by nomjou');
          ParamByname('sercat').AsInteger := _cat.FieldByName('sercat').AsInteger;
          Open;
          if not IsEmpty then
          begin
            mainW.sb.Panels[0].Text := Fields[0].AsString;
            if _insc.Locate('serinsc',Fields[0].AsInteger,[]) then
              ;
          end;
          Close;
        finally
          Free;
        end;
      end;
    end;
  end;
end;

procedure TtournamentW.internetActionExecute(Sender: TObject);
begin
  inherited;
  with TinternetW.Create(Self, _sertrn) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TtournamentW.joueurSearchChange(Sender: TObject);
begin
  inherited;
  if (Trim(joueurSearch.Text) <> '') and (Length(Trim(joueurSearch.Text))>2) then
  begin
    if not _insc.Locate('nomjou',Trim(joueurSearch.Text),[loCaseInsensitive]) then
    begin
      with getROQuery(pvCnx) do
      begin
        try
          SQL.Add('SELECT b.serjou'
                 +' FROM insc a, joueur b'
                 +' WHERE a.serjou = b.serjou'
                 +'   and a.sertrn = :sertrn'
                 +'   and b.nomjou like ' + QuotedStr(Trim(joueurSearch.Text)+'%')
                 +' order by nomjou');
          ParamByname('sertrn').AsInteger := _sertrn;
          Open;
          if not IsEmpty then
          begin
            mainW.sb.Panels[0].Text := Fields[0].AsString;
            if joueursSource.Dataset.Locate('serjou',Fields[0].AsInteger,[]) then
              ;
          end;
          Close;
        finally
          Free;
        end;
      end;
    end;
  end;
end;

procedure TtournamentW.joueursGetText(Sender: TField; var Text: string;
  DisplayText: boolean);
begin
  DisplayText := Sender.AsString <> '0';
  if DisplayText then
    Text := Format('%d inscriptions',[Sender.AsInteger]);
end;

procedure TtournamentW.joueursGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
  dbgrid_highlight_current(TDBGrid(sender),Rect,DataCol,Column,State);
  TDBGrid(sender).DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TtournamentW.joueursGridMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  dbgrid_mousemove(TDBGrid(Sender),Shift,X,Y);
end;

type
  TFoo = class(TDBGrid);
procedure TtournamentW.leftMatchGridDblClick(Sender: TObject);
begin
  inherited;
  if TDBCtrlGrid(Sender).DataSource.DataSet.FieldByName('stamtc').Value < gsOver then
  begin
    if editMatch(TDBCtrlGrid(Sender).DataSource.DataSet.FieldByName('sermtc').AsInteger) then
      TDBCtrlGrid(Sender).DataSource.DataSet.Refresh;
  end;
end;

procedure TtournamentW.leftMatchGridKeyPress(Sender: TObject; var Key: Char);
var
  m: TGame;
  sermtc: integer;
  refresh: boolean;
  dts: TDatasource;
begin
  inherited;
  sermtc := 0;
  refresh := False;
  if (Key = '.') and (TDBCtrlGrid(Sender).DataSource.DataSet.FieldByName('stamtc').Value < gsOver) then
  begin
    sermtc := TDBCtrlGrid(Sender).DataSource.DataSet.FieldByName('sermtc').AsInteger;
    refresh := editMatch(sermtc);
  end
  else
  if ((Key = 'w') or (Key = 'W')) and (TDBCtrlGrid(Sender).DataSource.DataSet.FieldByName('stamtc').Value < gsOver) then
  begin
    sermtc := TDBCtrlGrid(Sender).DataSource.DataSet.FieldByName('sermtc').AsInteger;
    m := TGame.Create(Self,pvCnx,sermtc);
    try
      refresh := m.write;
    finally
      m.Free;
    end;
  end;
  if (sermtc > 0) and refresh then
  begin
    dts := TDBCtrlGrid(Sender).DataSource;
    dts.DataSet.Refresh;
    dts.DataSet.Locate('sermtc',sermtc,[]);
    dts.DataSet.Next;
    if dts = mtclv1Source then
      mtclv2Source.DataSet.Refresh
    else if dts = mtclv2Source then
      mtclv3Source.DataSet.Refresh;
  end;
end;

procedure TtournamentW.leftMatchGridPaintPanel(DBCtrlGrid: TDBCtrlGrid;
  Index: Integer);
begin
  inherited;
  with DBCtrlGrid, Canvas, DataSource.DataSet do
  begin
    if not IsEmpty then
    begin
      Brush.Color := getGameColor(TGameStatus(FieldByName('stamtc').AsInteger));
      FillRect(ClipRect);
    end;
  end;
end;

procedure TtournamentW.levelBoxChange(Sender: TObject);
begin
  inherited;
  openMatches;
end;

procedure TtournamentW.manualDrawActionExecute(Sender: TObject);
begin
  inherited;
//  {: set draw manual }
  with TmanualDrawW.Create(Self,pvCnx,sertab.Field.AsInteger) do
  begin
    try
      if ShowModal = mrOk then
        ExecuteDisplayTableauAction;
    finally
      Free;
    end;
  end;
end;

procedure TtournamentW.GenerateDrawGamesActionExecute(Sender: TObject);
var
  z: TZReadOnlyQuery;
begin
  inherited;
  z := getROQuery(pvCnx);
  try
    z.SQL.Add('SELECT COUNT( * ) FROM prptab WHERE sertab = :sertab');
    z.ParamByName('sertab').AsInteger := sertab.Field.AsInteger;
    z.Open;
    if z.Fields[0].AsInteger = 0 then
    begin
      z.Close;
      MessageDlg('Il faut tout d''abord préparer le tableau !', mtWarning, [mbOk], 0);
      Exit;
    end;
    z.Close;
    z.SQL.Clear;
    z.SQL.Add('SELECT COUNT( * ) FROM tablo WHERE sertab = :sertab');
    z.ParamByName('sertab').AsInteger := sertab.Field.AsInteger;
    z.Open;
    if z.Fields[0].AsInteger = 0 then
    begin
      z.Close;
      MessageDlg('Il faut tout d''abord préparer le tablo !', mtWarning, [mbOk], 0);
      Exit;
    end;
    z.Close;
    pvCnx.startTransaction;
    try
      initUmpiresTable(sertrn.Field.AsInteger);
      if genGames(sertab.Field.AsInteger) then
      begin
        pvCnx.commit;
        MessageDlg(Format('Les matchs du tableau %s (%d) sont générés.',[codcat.Field.AsString,sertab.Field.AsInteger]), mtInformation, [mbOk], 0);
        { maj de categories.stacat }
//        stacat(sertab.Field.AsInteger,csDraw);
        CheckAndSetCategorieStatusAfterUpdate(sertab.Field.AsInteger);
        //catSource.DataSet.Refresh;
        catSource.DataSet.Locate('sercat',sertab.Field.Value,[]);
      end
      else
        pvCnx.rollback;
    except
      pvCnx.rollback;
      raise;
    end;
  finally
    z.Free;
  end;
end;

procedure TtournamentW.GenerateGroupGamesActionExecute(Sender: TObject);
begin
  inherited;
  ShowMessage('generate group games');
end;

procedure TtournamentW.GamesSheetResize(Sender: TObject);
begin
  inherited;
  leftMatchPanel.Width := TPanel(Sender).ClientWidth div 3;
  midMatchPanel.Width := leftMatchPanel.Width;
end;

procedure TtournamentW.matchModifieGetText(Sender: TField; var Text: string;
  DisplayText: boolean);
begin
  DisplayText := not Sender.IsNull;
  if DisplayText then
    Text := FormatDateTime('hh:nn',Sender.AsDateTime);
end;

procedure TtournamentW.Memo1DblClick(Sender: TObject);
begin
  inherited;
  memo1.SelectAll;
  memo1.CopyToClipboard;
end;

procedure TtournamentW.newRecord(Dataset: TDataset);
begin
  if Dataset = _cat then
  begin
    with Dataset do
    begin
      FieldByName('sercat').AsInteger := pvSeq.SerialByName('CATEGORIE');
      FieldByName('sertrn').AsInteger := _tournament.FieldByName('sertrn').AsInteger;
      FieldByName('saison').AsInteger := _tournament.FieldByName('saison').AsInteger;
      FieldByName('simple').AsString := getDefValue('categories','simple','1');
      FieldByName('handicap').AsString := getDefValue('categories','handicap','0');
      FieldByName('numset').AsString := getDefValue('categories','numset','3');
      FieldByName('catage').AsString := getDefValue('categories','catage','0');
      FieldByName('first_round_mode').AsInteger := _tournament.FieldByName('first_round_mode').AsInteger;
      FieldByName('phase').AsInteger := _tournament.FieldByName('mode').AsInteger;
    end;
  end
  else if Dataset = _clscat then
  begin
    with Dataset do
    begin
      FieldByName('sercat').AsInteger := _cat.FieldByName('sercat').AsInteger;
    end;
  end
  (*   Les valeurs par défaut sont ajoutées dans le OnShow de la fiche
  else if Dataset = _tournament then
  begin
    with Dataset do
    begin
      FieldByName('codcls').ASString := 'topdem';
    end;
  end;
  *)
end;

procedure TtournamentW.nilArenaView;
begin
  try
    if Assigned(glArena15W) then
      FreeAndNil(glArena15W);
  except
  end;
end;

procedure TtournamentW.FirstRoundModeGetText(Sender: TField; var Text: string; DisplayText: boolean);
begin
  if not Sender.IsNull then
    Text := Format('%s [%s]',[Sender.AsString,GetEnumName(TypeInfo(TFirstRoundMode), Sender.AsInteger)]);
end;

procedure TtournamentW.nummtcGetText(Sender: TField; var Text: string;
  DisplayText: boolean);
begin
  if not Sender.IsNull then
    Text := Format('%s [%d]',[Sender.AsString,Sender.DataSet.FieldByName('sermtc').AsInteger]);
end;

procedure TtournamentW.numtblGetText(Sender: TField; var Text: string;
  DisplayText: boolean);
begin
  DisplayText := Sender.AsString <> '';
  if DisplayText then
    Text := Format('Table %s',[Sender.AsString]);
end;

procedure TtournamentW.onCategChange(var Message: TMessage);
begin
  catGrid.DataSource.DataSet.Refresh;
end;

procedure TtournamentW.openImportationDocument(const filename: string);
begin
  openExcelWorkbook(_xls,_wkb,filename);
  _sht := _wkb.ActiveSheet;
end;

procedure TtournamentW.openMatches;
begin
  if _mtclv1.Active then _mtclv1.Close;
  if _mtclv2.Active then _mtclv2.Close;
  if _mtclv3.Active then _mtclv3.Close;
  _mtclv1.ParamByName('sertab').AsInteger := catSource.DataSet.FieldByName('sercat').AsInteger;
  _mtclv1.ParamByName('level').AsString := levelBox.Text;
  _mtclv1.Open;
  _mtclv2.ParamByName('sertab').AsInteger := catSource.DataSet.FieldByName('sercat').AsInteger;
  _mtclv2.ParamByName('level').AsInteger := Succ(_mtclv1.ParamByName('level').AsInteger);
  _mtclv2.Open;
  _mtclv3.ParamByName('sertab').AsInteger := catSource.DataSet.FieldByName('sercat').AsInteger;
  _mtclv3.ParamByName('level').AsInteger := Succ(_mtclv2.ParamByName('level').AsInteger);
  _mtclv3.Open;
end;

procedure TtournamentW.orderByActionExecute(Sender: TObject);
var
  sql: string;
  i: integer;
  ctl: TControl;
  grd: TDBGrid;
  q: TZQuery;
begin
  inherited;
  ctl := Screen.ActiveControl;
  if ctl is TDBGrid then
  begin
    grd := TDBGrid(ctl);
    q := TZQuery(grd.DataSource.DataSet);
    q.DisableControls;
    try
      sql := q.SQL.Text;
      i := Pos('order by', sql);
      if i > 0 then
      begin
        Delete(sql,i, Length(sql)-i+1);
        if grd = tabloGrid then
          sql := sql + 'order by numrow'
        else
        if grd = prpGrid then
          sql := sql + 'order by numtds,vrbrgl';
        q.Close;
        q.SQL.Clear;
        q.SQL.Add(sql);
        if q.Params.FindParam('sertab') <> nil then
          q.ParamByName('sertab').AsInteger := sertab.Field.AsInteger;
        q.Open;
      end;
    finally
      q.EnableControls;
    end;
  end;
end;

procedure TtournamentW.ouvertsClick(Sender: TObject);
begin
  inherited;
  _mtclv1.DisableControls;
  try
    _mtclv1.Filtered := ouverts.Checked;
    if _mtclv1.Filtered then
      _mtclv1.Filter := 'stamtc < 2'
    else
      _mtclv1.Filter := '';
  finally
    _mtclv1.EnableControls;
  end;
end;

procedure TtournamentW.pgChange(Sender: TObject);
const
  cs_cat: integer = 0;
  cs_insc: integer = 1;
  cs_joueurs: integer = 2;
  cs_clubs: integer = 3;
  cs_tabs: integer = 4;
  cs_games: integer = 5;
begin
  inherited;

  case pg.ActivePageIndex of
    0: begin

    end;
    1: begin
      _insc.Open;
      _insc.FieldByName('statut').OnGetText := registrationStatusGetText;
    end;
    2: begin
      _joueurs.Open;
    end;
    3: begin
      _clubs.Open;
    end;
    4: begin
      DisplayTableau;
    end;
    5: begin
      levelBox.Items.BeginUpdate;
      levelBox.Items.Clear;
      if not(catSource.DataSet.Eof)  then
      begin
        with getROQuery(pvCnx) do
        begin
          try
            SQL.Add('SELECT distinct level FROM match WHERE sertab = :sertab'
                   +' order by level');
            Params[0].AsInteger := catSource.DataSet.FieldByName('sercat').AsInteger;
            Open;
            while not Eof do
            begin
              levelBox.Items.Add(Fields[0].AsString);
              Next;
            end;
            Close;
          finally
            Free;
          end;
        end;
      end;
      levelBox.Items.EndUpdate;
      if levelBox.Items.Count > 0 then
      begin
        levelBox.ItemIndex := 0;
        openMatches;
        leftMatchGrid.SetFocus;
      end;
    end;
  end;
end;

procedure TtournamentW.pgChanging(Sender: TObject; var AllowChange: Boolean);
begin
  inherited;
  if _insc.Active then
    _insc.Close
  else if _joueurs.Active then
    _joueurs.Close
  else if _mtclv1.Active then
  begin
    _mtclv3.Close;
    _mtclv2.Close;
    _mtclv1.Close;
  end;
end;

//procedure TtournamentW._stacat(const sercat: integer; const stacat: TCategorysStatus);
//begin
//  updateCategoryStatut(sercat,stacat);
//end;

procedure TtournamentW.writeDatasets;
begin
  if _tournament.state in dsEditModes then
    _tournament.Post;
end;

procedure TtournamentW.ziedelenActionExecute(Sender: TObject);
begin
  inherited;
  if not Assigned(saisie) then
    saisie := TsaisieW.Create(Self, pvCnx, _sertrn);
  saisie.Show;
end;

constructor TtournamentW.Create(AOwner: TComponent; cnx: TLalConnection; sertrn: integer);
begin
  _loading := False;
  pvCnx := cnx;
  inherited Create(AOwner);
  if sertrn = 0 then
    _openMode := omCreate
  else
    _openMode := omLoad;
  _sertrn := sertrn;
end;

procedure TtournamentW.ExecuteDisplayTableauAction;
begin
  if DisplayTableauAction.Enabled then
    DisplayTableauAction.Execute;
end;

procedure TtournamentW.afterCancel(Dataset: TDataset);
begin
end;

procedure TtournamentW.afterPost(Dataset: TDataset);
var
  i: integer;
  s: string;
  cls: string;
begin
  if Dataset = _cat then
  begin
    { on regarde si c'est une catégorie simple, pas handicap, et enfin si c'est une
      catégorie classement, pas d'âge }
    if (Dataset.FieldByName('simple').AsString = '1') and
       (Dataset.FieldByName('handicap').AsString = '0') and
       (Dataset.FieldByName('catage').AsString = '0') then
    begin
      with getROQuery(pvCnx) do
      begin
        try
          pvCnx.startTransaction;
          try
            cls := Dataset.FieldByName('codcat').AsString;
            while (Pos('-',cls,1)>0) or (Length(cls)>0) do
            begin
              i := Pos('-',cls,1);
              if i > 0 then
                s := Copy(cls,1,Pred(i))
              else
                s := Trim(cls);
              sql.Clear;
              sql.Add('SELECT COUNT( * ) FROM classements'
                     +' WHERE sercat = :sercat'
                     +'   and codcls = :codcls');
              Params[0].AsInteger := catSource.DataSet.FieldByName('sercat').AsInteger;
              Params[1].AsString := s;
              Open;
              if Fields[0].AsInteger = 0 then
              begin
                Close;
                sql.Clear;
                sql.Add('INSERT INTO classements (sercat,codcls,sertrn)'
                       +' VALUES (:sercat,:codcls,:sertrn)');
                Params[0].AsInteger := catSource.DataSet.FieldByName('sercat').AsInteger;
                Params[1].AsString := s;
                Params[2].AsInteger := _sertrn;
                ExecSQL;
              end
              else
                Close;
              if i > 0 then
                System.Delete(cls,1,i)
              else
                cls := '';
            end;
            pvCnx.commit;
          except
            pvCnx.rollback;
            raise;
          end;
          _clscat.Refresh;
          if Active then
            Close;
        finally
          Free;
        end;
      end;
    end
    { open handicap, on ajoute tous les classements }
    else if (Dataset.FieldByName('simple').AsString = '1') and
       (Dataset.FieldByName('handicap').AsString = '1') and
       (Dataset.FieldByName('catage').AsString = '0') then
    begin
      with getROQuery(pvCnx) do
      begin
        try
          SQL.Add('delete FROM classements WHERE sertrn = :sertrn'
                 +' and sercat = :sercat');
          Params[0].AsInteger := _sertrn;
          Params[1].AsInteger := catSource.DataSet.FieldByName('sercat').AsInteger;
          pvCnx.startTransaction;
          try
            ExecSQL;
            SQL.Clear;
            SQL.Add('INSERT INTO classements (sercat,codcls,sertrn)'
                   +Format(' SELECT %d, codcls, %d FROM classement WHERE catage = 0',[catSource.DataSet.FieldByName('sercat').AsInteger,_sertrn]));
            ExecSQL;
            pvCnx.commit;
            _clscat.Refresh;
          except
            pvCnx.rollback;
            raise;
          end;
        finally
          Free;
        end;
      end;
    end;
  end;
end;

procedure TtournamentW.beforeInsert(Dataset: TDataset);
begin
  Abort;
end;

procedure TtournamentW.BitBtn3Click(Sender: TObject);
var
  z: TZReadOnlyQuery;
begin
  inherited;
  z := getROQuery(pvCnx);
  try
    z.SQL.Add('SELECT d.LIBCLB,a.CODCAT,COUNT(*)'
             +' FROM '
             +' CATEGORIES a, insc b, joueur c, club d'
             +' WHERE'#13#10
             +' a.sertrn = ' + tournamentSource.DataSet.FieldByName('sertrn').AsString
             +' AND a.SERCAT = b.SERCAT'#13#10
             +' AND b.SERJOU = c.SERJOU'#13#10
             +' AND c.CODCLB = d.CODCLB'#13#10
             +' GROUP BY 1,2'#13#10
             +' ORDER BY 1,2');
    z.Open;
    datasetToExcel(z,True);
    z.Close;
    z.SQL.Clear;
    z.SQL.Add('SELECT d.LIBCLB,COUNT(*)'
             +' FROM '
             +' CATEGORIES a, insc b, joueur c, club d'
             +' WHERE'#13#10
             +' a.sertrn = ' + tournamentSource.DataSet.FieldByName('sertrn').AsString
             +' AND a.SERCAT = b.SERCAT'#13#10
             +' AND b.SERJOU = c.SERJOU'#13#10
             +' AND c.CODCLB = d.CODCLB'#13#10
             +' GROUP BY 1'#13#10
             +' ORDER BY 1');
    z.Open;
    datasetToExcel(z,True);
    z.Close;
    z.SQL.Clear;
    z.SQL.Add('SELECT d.LIBCLB,a.CODCAT,c.nomjou'
             +' FROM '
             +' CATEGORIES a, insc b, joueur c, club d'
             +' WHERE'#13#10
             +' a.sertrn = ' + tournamentSource.DataSet.FieldByName('sertrn').AsString
             +' AND a.SERCAT = b.SERCAT'#13#10
             +' AND b.SERJOU = c.SERJOU'#13#10
             +' AND c.CODCLB = d.CODCLB'#13#10
             +' ORDER BY 1,2,3');
    z.Open;
    datasetToExcel(z,True);
    z.Close;
  finally
    z.Free;
  end;
end;

procedure TtournamentW.BitBtn4Click(Sender: TObject);
var
  z: TZReadOnlyQuery;
  i: integer;
begin
  inherited;
  Screen.Cursor := crHourglass;
  try
    with getROQuery(pvCnx) do
    begin
      try
        SQL.Add('SELECT COUNT(*) FROM umpires'
               +' WHERE sertrn = ' + Self.sertrn.Field.AsString);
        Open;
        if Fields[0].AsInteger <> Self.numtbl.Field.AsInteger then
        begin
          {: new tournament, create umpires entries }
          if Fields[0].AsInteger = 0 then
          begin
            Close;
            SQL.Clear;
            SQL.Add(Format('INSERT INTO umpires (sertrn,numtbl,statbl)'
                          +' VALUES (%d,:numtbl,%d)',[Self.sertrn.Field.AsInteger,Ord(pasAvailable)]));
            Prepare;
            pvCnx.startTransaction;
            try
              for i := 1 to Self.numtbl.Field.AsInteger do
              begin
                Params[0].AsInteger := i;
                ExecSQL;
              end;
              pvCnx.commit;
            except
              pvCnx.rollback;
              raise;
            end;
          end
          else
          begin
            {: insert or delete umpires entries }
            Close;
            SQL.Clear;
            pvCnx.startTransaction;
            try
              SQL.Add('DELETE FROM umpires'
                     +' WHERE sertrn = ' + Self.sertrn.Field.AsString
                     +'   AND numtbl > ' + Self.numtbl.Field.AsString);
              ExecSQL;
              SQL.Clear;
              SQL.Add('SELECT COUNT(*) FROM umpires'
                     +' WHERE sertrn = ' + Self.sertrn.Field.AsString
                     +'   AND numtbl = :numtbl');
              Prepare;
              z := getROQuery(pvCnx);
              z.SQL.Add(Format('INSERT INTO umpires (sertrn,numtbl,statbl)'
                              +' VALUES (%d,:numtbl,%d',[Self.sertrn.Field.AsInteger,Ord(pasAvailable)]));
              z.Prepare;
              for i := 1 to Self.numtbl.Field.AsInteger do
              begin
                ParamByName('numtbl').AsInteger := i;
                Open;
                try
                  if Fields[0].AsInteger = 0 then
                  begin
                    z.Params[0].AsInteger := i;
                    z.ExecSQL;
                  end;
                finally
                  Close;
                end;
              end;
              pvCnx.commit;
            except
              pvCnx.rollback;
              raise;
            end;
          end;
        end;
      finally
        Free;
      end;
    end;

    arenaView;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TtournamentW.beforeDelete(Dataset: TDataset);
var
  z: TZReadOnlyQuery;
  sercat: integer;
begin
  z := getROQuery(pvCnx);
  try
    if Dataset = _insc then
    begin
      { on ne peut supprimer une inscription que si le tableau n'a pas encore été préparé }
      z.SQL.Clear;
      z.SQL.Add('SELECT COUNT( * ) FROM prptab WHERE sertab = ' + catSource.DataSet.FieldByName('sercat').AsString);
               //+' and serjou = ' + _insc.FieldByName('serjou').AsString);
      z.Open;
      if z.Fields[0].AsInteger = 0 then
      begin
        z.Close;
        z.SQL.Clear;
        z.SQL.Add('delete FROM insc WHERE serinsc = ' + _insc.FieldByName('serinsc').AsString);
        z.ExecSQL;
         { Mettre à jour la table tableau (taille,nbrjou,nbrtds) }
        sercat := catSource.DataSet.FieldByName('sercat').AsInteger;
        updateTableau(sercat);
        _insc.Refresh;
        _cat.Refresh;
        _cat.Locate('sercat',sercat,[]);
        if tabSource.DataSet.Active then tabSource.DataSet.Refresh;
      end
      else
      begin
        MessageDlg('Le tableau ' + catSource.DataSet.FieldByName('codcat').AsString
                  +' est déjà préparé. Suppression du joueur impossible !'
                   ,mtWarning, [mbOk], 0);
      end;
      if z.Active then
        z.Close;
      Abort;
    end;
  finally
    z.Free;
  end;
end;

procedure TtournamentW.categoryStatutGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if not Sender.DataSet.Eof then
  begin
    try
      Text := Format('%s (%d)',[getCategorysDesc(TCategorysStatus(Sender.AsInteger)),Sender.AsInteger]);
    except
      Text := Format('%s (%d)',[getEnumName(TypeInfo(TCategorysStatus),Sender.AsInteger),Sender.AsInteger]);
    end;
  end;
end;

procedure TtournamentW.catGridDblClick(Sender: TObject);
begin
  inherited;
  ExecuteDisplayTableauAction
end;

procedure TtournamentW.catGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  if catGrid.DataSource.DataSet.Eof then
    Exit;
  with catGrid.Canvas do
  begin
    if not catGrid.DataSource.DataSet.IsEmpty then
      Brush.Color := getCategoryColor(TCategorysStatus(catGrid.DataSource.DataSet.FieldByName('stacat').AsInteger));
    dbgrid_highlight_current(TDBGrid(sender),Rect,DataCol,Column,State);
  end;
  catGrid.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TtournamentW.catGridEnter(Sender: TObject);
begin
  inherited;
  pvSeek.Seek_Code := glSettings.SeekCodeCategoryStatus;
end;

procedure TtournamentW.catGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
  begin
    Key := 0;
    ExecuteDisplayTableauAction;
  end;
end;

procedure TtournamentW.catGridKeyPress(Sender: TObject; var Key: Char);
const
  keys: TSysCharSet = ['m','M','t','T'];
begin
  inherited;
  if CharInSet(Key,keys) then
  begin
    if ((key = 'm') or (Key = 'M')) then
    begin
      pg.ActivePage := GamesSheet;
      pgChange(Sender);
    end
    else
    if ((key = 't') or (Key = 'T')) then
      ActivateTabSheet(pg, tabSheet);
    Key := #0;
  end;
end;

procedure TtournamentW.catGridMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  //dbgrid_mousemove(TDBGrid(Sender),Shift,X,Y);
end;

procedure TtournamentW.catGridTitleClick(Column: TColumn);
begin
  orderByColumn(TZQuery(Column.Grid.DataSource.DataSet),Column,'ASC');
end;

procedure TtournamentW.catSourceDataChange(Sender: TObject; Field: TField);
var
  x: TZReadOnlyQuery;
  hdc: boolean;
  taille: integer;
begin
  inherited;

  x := getROQuery(pvCnx);
  try
    if Field = _cat.FieldByName('handicap') then
    begin
      hdc := Field.AsString = '1';
      x.SQL.Add('SELECT taille FROM tableau WHERE sertab = :sertab');
      x.ParamByName('sertab').AsInteger := catSource.DataSet.FieldByName('sercat').AsInteger;
      x.Open;
      taille := x.Fields[0].AsInteger;
      x.Close;
      x.SQL.Clear;

      x.SQL.Add('update tableau'
               +' set nbrtds = :nbrtds'
               +' WHERE sertab = :sertab');
      x.ParamByName('sertab').AsInteger := catSource.DataSet.FieldByName('sercat').AsInteger;
      if not hdc then
        x.ParamByName('nbrtds').AsInteger := taille div 8
      else
        x.ParamByName('nbrtds').AsInteger := 0;
      x.ExecSQL;
    end;
  finally
    x.Free;
  end;
end;

procedure TtournamentW.checkDoublonsActionExecute(Sender: TObject);
var
  doublons: TStringList;
begin
  inherited;
  Screen.Cursor := crSQLWait;
  doublons := nil;
  try
    try
      doublons := TStringList(checkDoublons(tournamentSource.DataSet.FieldByName('sertrn').AsInteger));
      if doublons.Count > 0 then
      begin
        FDoublons := TdataW.Create(Self);
        try
          FDoublons.dataSource.OnDataChange := Self.doublonDataChange;
          displayDoublons(FDoublons);
        finally
          FDoublons.Free;
        end;
      end;
    finally
      if Assigned(doublons) then
        doublons.Free;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TtournamentW.checkMatchesActionExecute(Sender: TObject);
begin
  inherited;
  checkMatchesLevel(sertab.Field.AsInteger, _mtclv1.ParamByName('level').AsInteger);
end;

procedure TtournamentW.closeDatasets;
begin
  _clscat.Close;
  _cat.Close;
  _tournament.Close;
end;

procedure TtournamentW.clsCatageButtonClick(Sender: TObject);
var
  lvi: TListItem;
  i: integer;
  s,cls: string;
begin
  inherited;
  with TclscatageW.Create(Self, pvCnx, _cat.FieldByName('catage').AsString) do
  begin
    try
      _clscat.First;
      if not _clscat.IsEmpty then
      begin
        while not(_clscat.Eof) do
        begin
          lvi := lv.FindCaption(0,_clscat.FieldByName('codcls').AsString,False,True,False);
          if lvi <> nil then
          begin
            lvi.Checked := True;
            lvi.Selected := True;
            lvi.MakeVisible(True);
          end;
          _clscat.Next;
        end;
      end
      else
      begin
        { on essaye de trouver les classemenst de la catégorie }
        s := _cat.FieldByName('codcat').AsString;
        while Length(s) > 0 do
        begin
          i := Pos('-',s);
          if i > 0 then
          begin
            cls := Copy(s,1,Pred(i));
            lvi := lv.FindCaption(0,cls,False,True,False);
            if lvi <> nil then
            begin
              lvi.Checked := True;
              lvi.Selected := True;
              lvi.MakeVisible(True);
            end;
            Delete(s,1,i);
          end
          else
          begin
            lvi := lv.FindCaption(0,s,False,True,False);
            if lvi <> nil then
            begin
              lvi.Checked := True;
              lvi.Selected := True;
              lvi.MakeVisible(True);
            end;
            s := '';
          end;
        end;
      end;
      if ShowModal = mrOk then
      begin
        with getROQuery(pvCnx) do
        begin
          try
            SQL.Add('DELETE FROM classements WHERE sercat = ' + _cat.FieldByName('sercat').AsString);
            ExecSQL;
            SQL.Clear;
            SQL.Add('INSERT INTO classements(sercat,codcls,sertrn)'
                  +' VALUES (:sercat,:codcls,:sertrn)');
            Prepare;
            Params[0].AsInteger := _cat.FieldByName('sercat').AsInteger;
            Params[2].AsInteger := _sertrn;
            for i := 0 to lv.Items.Count-1 do
            begin
              if lv.Items[i].Checked then
              begin
                Params[1].AsString := lv.Items[i].Caption;
                ExecSQL;
              end;
            end;
          finally
            Free;
          end;
        end;
        _clscat.Refresh;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TtournamentW.clubsGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
  dbgrid_highlight_current(TDBGrid(sender),Rect,DataCol,Column,State);
  TDBGrid(sender).DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TtournamentW.clubsGridMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  dbgrid_mousemove(TDBGrid(Sender),Shift,X,Y);
end;

procedure TtournamentW.codclbEnter(Sender: TObject);
begin
  inherited;
  pvSeek.Seek_Code := glSettings.SeekCodeClub;
  SelectSeekMenu.OnClick := SelectSeekCodClbActionExecute;
end;

procedure TtournamentW.codclbKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = pvSeek.SeekKey then
  begin
    Key := 0;
    if pvSeek.Seek then
    begin
      TDBEdit(Sender).DataSource.DataSet.Edit;
      TDBEdit(Sender).Field.AsString := pvSeek.Returns.Values['CODCLB'];
      organisateur.Field.AsString := pvSeek.Returns.Values['LIBCLB'];
    end;
  end;
end;

procedure TtournamentW.codclbKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL,0,0);
  end;
end;

procedure TtournamentW.colorsChanged(var Message: TMessage);
var
  i: integer;
begin
  for i := 0 to ComponentCount-1 do
    if (Components[i] is TCustomDBGrid) or
       (Components[i] is TDBCtrlGrid) then
      (Components[i] as TWinControl).Refresh;
end;

procedure TtournamentW.dbGridColumns(grid: TDBGrid);
begin
  grid.Columns.Clear;
  if grid = catGrid then
  begin
    with grid.Columns.Add do
    begin
      FieldName := 'sercat';
      Alignment := taCenter;
      ReadOnly := True;
      Title.Caption := 'sérial';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'codcat';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'catégorie';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'numseq';
      Alignment := taCenter;
      ReadOnly := False;
      Title.Caption := 'ordre';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'first_round_mode';
      Alignment := taLeftJustify;
      ReadOnly  := False;
      Title.Caption := 'Mode 1er tour';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'heudeb';
      Alignment := taCenter;
      ReadOnly := False;
      Title.Caption := 'début';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'simple';
      Alignment := taCenter;
      ReadOnly := False;
      Title.Caption := 'simple/double';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'handicap';
      Alignment := taCenter;
      ReadOnly := False;
      Title.Caption := 'handicap';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'numset';
      Alignment := taCenter;
      ReadOnly := False;
      Title.Caption := 'sets gagnants';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'catage';
      Alignment := taCenter;
      ReadOnly := False;
      Title.Caption := 'cat.d''âge';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'participants';
      Alignment := taCenter;
      ReadOnly := True;
      Title.Caption := 'participants';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'a_jouer';
      Alignment := taCenter;
      ReadOnly := True;
      Title.Caption := 'à jouer';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'phase';
      Alignment := taCenter;
      ReadOnly := True;
      Width := 120;
      Title.Caption := 'phase';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'stacat';
      Alignment := taCenter;
      Width := 100;
      ReadOnly := True;
      Title.Caption := 'statut';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'parent';
      Alignment := taCenter;
      Width := 100;
      ReadOnly := True;
      Title.Caption := 'qualification';
      Title.Alignment := taCenter;
    end;
  end
  else if grid = inscGrid then
  begin
    with grid.Columns.Add do
    begin
      FieldName := 'statut';
      Alignment := taCenter;
      ReadOnly := True;
      Width := 120;
      Title.Caption := 'statut';
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
      Title.Caption := 'club';
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
      FieldName := 'seqcls';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'class.';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'topcls';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'top.class.';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'topdem';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'class.saison';
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
      FieldName := 'licptn';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'lic.ptn.';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'nomptn';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'partenaire';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'libclbptn';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'club';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'clsptn';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'class.';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'seqcls';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'class.';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'datinsc';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'inscription';
      Title.Alignment := taCenter;
    end;
  end
  else if grid = joueursGrid then
  begin
    with grid.Columns.Add do
    begin
      FieldName := 'licence';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'licence';
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
      Title.Caption := 'club';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'codcat';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'catégorie';
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
      FieldName := 'topcls';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'top.class.';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'topdem';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'class.saison';
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
      FieldName := 'datinsc';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'inscription';
      Title.Alignment := taCenter;
    end;
  end
  else if grid = clubsGrid then
  begin
    with grid.Columns.Add do
    begin
      FieldName := 'codclb';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'club';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'libclb';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'club';
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
      Title.Caption := 'club';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'codcat';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'catégorie';
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
      FieldName := 'topcls';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'top.class.';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'topdem';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'class.saison';
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
      FieldName := 'datinsc';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'inscription';
      Title.Alignment := taCenter;
    end;
  end
  else if grid = prpGrid then
  begin
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
      FieldName := 'vrbrgl';
      Alignment := taLeftJustify;
      ReadOnly := False;
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
      FieldName := 'sergrp';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Width := 100;
      Title.Caption := 'groupe';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'is_qualified';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Width := 100;
      Title.Caption := 'qualifié';
      Title.Alignment := taCenter;
    end;
  end
  else if grid = prpclbGrid then
  begin
    with grid.Columns.Add do
    begin
      FieldName := 'participants';
      Alignment := taCenter;
      ReadOnly := True;
      Title.Caption := 'participant';
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
  end
  else if grid = tabloGrid then
  begin
    with grid.Columns.Add do
    begin
      FieldName := 'numtds';
      Alignment := taCenter;
      ReadOnly := True;
      Title.Caption := 'numtds';
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
      Title.Caption := 'club';
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
      FieldName := 'numrow';
      Alignment := taLeftJustify;
      ReadOnly := True;
      Title.Caption := 'numrow';
      Title.Alignment := taCenter;
    end;
  end;
end;

procedure TtournamentW.DBText2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  mainW.sb.Panels[0].Text := TDBText(Sender).Field.DataSet.FieldByName('serjo1').AsString;
end;

procedure TtournamentW.DBText3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  mainW.sb.Panels[0].Text := TDBText(Sender).Field.DataSet.FieldByName('serjo2').AsString;
end;

procedure TtournamentW.debug(const text: string);
begin
(*
//    memo1.Lines.Add(text);
  _debug.BeginUpdate;
  _debug.Add(text);
  _debug.EndUpdate;
*)
end;

procedure TtournamentW.ResetActionExecute(Sender: TObject);
var
  sertab: integer;
begin
  inherited;
  with getROQuery(pvCnx) do
  begin
    try
      pvCnx.startTransaction;
      try
        sertab := Self.sertab.Field.AsInteger;
        SQL.Add('delete FROM tablo WHERE sertab = ' + IntToStr(sertab));
        ExecSQL;
        SQL.Clear;
        SQL.Add('delete FROM prptab WHERE sertab = ' + IntToStr(sertab));
        ExecSQL;
//        deleteted by trigger on table match before delete
//        SQL.Clear;
//        SQL.Add('delete FROM match_groupe WHERE sercat = ' + IntToStr(sertab));
//        ExecSQL;
        SQL.Clear;
        SQL.Add('delete FROM match WHERE sertab = ' + IntToStr(sertab));
        ExecSQL;
        SQL.Clear;
        SQL.Add('delete FROM groupe_result WHERE sercat = ' + IntToStr(sertab));
        ExecSQL;
        SQL.Clear;
        SQL.Add('delete FROM groupe WHERE sercat = ' + IntToStr(sertab));
        ExecSQL;
        SQL.Clear;
        SQL.Add('delete FROM compo_groupe WHERE sercat = ' + IntToStr(sertab));
        ExecSQL;
        CheckAndSetCategorieStatusAfterUpdate(sertab);
//        _stacat(sertab,csInactive);
        pvCnx.commit;
        _tablo.Refresh;
        _prp.Refresh;
        //_cat.Refresh;
        _cat.Locate('sercat',sertab,[]);
        _prp.Locate('sertab',sertab,[]);
        ClearGroups;
      except
        pvCnx.rollback;
        raise;
      end;
    finally
      Free;
    end;
  end;
end;

(*
  algo d'importation

    créer les clubs (C:code club, K:club partenaire)
    créer les joueurs (E:licence, L:licence partenaire)
    créer les inscriptions
      si licence partenaire et R:confirmé
        si !inscription partenaire
          inscrire partenaire
*)
procedure TtournamentW.doImportation;
const
  col_datinsc =   'A';  // date d'inscription
  col_categ  =    'B';  // catégorie du tableau
  col_codclb =    'C';  // code club
  col_nomclb =    'D';  // nom club
  col_codspi =    'E';  // licence joueur
  col_nomspi =    'F';  // nom joueur
  col_codcls =    'G';  // classement actuel
  col_topcls =    'H';  // top classement saison
  col_topdem =    'I';  // top classement demi-saison
  col_vrbrgl =    'J';  // ranglëscht
  col_datnss =    'K';  // date de naissance
  col_codclbptn = 'L';  // club partenaire
  col_codptn =    'M';  // licence partenaire
  col_nomptn =    'N';  // nom partenaire
  col_clsptn =    'O';  // classement actuel partenaire
  col_topptn =    'P';  // top classement saison partenaire
  col_demptn =    'Q';  // top classement demi-saison partenaire
  col_rglptn =    'R';  // ranglëscht partenaire
  col_cnfptn =    'S';  // confirmation partenaire
  col_datnssptn = 'T';  // date de naissance partenaire
  col_avj1   =    'U';  // avertissement joueur 1
  col_avj2   =    'V';  // avertissement joueur 2
  {
[import]
numcol=22
col01=datinsc
col03=categ
col04=codclb
col05=nomclb
col06=codspi
col07=nomspi
col08=codcls
col09=topcls
col10=topdem
col11=vrbrgl
col12=datnss
col13=codclbptn
col14=codptn
col15=nomptn
col16=clsptn
col17=topptn
col18=demptn
col19=rglptn
col20=cnfptn
col21=datnssptn
col22=avj1
col23=avj2  }
var
  row: integer;
  datinsc,
  codclb,
  datnss,
  codcat,
  licence,
  codptn: string;
  z,x,w,
  clb,
  insclb,
  jou,
  insjou,
  updjou,
  cat,
  inscat,
  insc: TZReadOnlyQuery;
  i: Integer;
begin
  insclb := nil;
  jou := nil;
  insjou := nil;
  updjou := nil;
  z := nil;
  cat := nil;
  inscat := nil;
  insc := nil;
  w := nil;
  clb := getROQuery(pvCnx);
  try
    w := getROQuery(pvCnx);

    clb.SQL.Add('SELECT libclb FROM club WHERE codclb = :codclb');
    clb.Prepare;

    insclb := getROQuery(pvCnx);
    insclb.SQL.Add('INSERT INTO club (codclb,libclb) VALUES (:codclb,:libclb)');
    insclb.Prepare;

    jou := getROQuery(pvCnx);
    jou.SQL.Add('SELECT serjou,saison,licence,codclb,nomjou,codcls,topcls,topdem,datann,catage,vrbrgl'
               +' FROM joueur'
               +' WHERE licence = :licence'
               +'   and saison = ' + _tournament.FieldByName('saison').AsString);
    jou.Prepare;

    updjou := getROQuery(pvCnx);
    updjou.SQL.Add('update joueur'
                  +' set codclb = :codclb'
                  +'    ,nomjou = :nomjou'
                  +'    ,codcls = :codcls'
                  +'    ,topcls = :topcls'
                  +'    ,topdem = :topdem'
                  +'    ,datann = :datann'
                  +'    ,catage = :catage'
                  +'    ,vrbrgl = :vrbrgl'
                  +' WHERE serjou = :serjou and licence = :licence and saison = :saison');
    updjou.Prepare;

    insjou := getROQuery(pvCnx);
    insjou.SQL.Add('INSERT INTO joueur (serjou,saison,licence,codclb,nomjou,codcls,topcls,topdem,datann,catage,vrbrgl)'
                  +' VALUES '
                  +'(:serjou,:saison,:licence,:codclb,:nomjou,:codcls,:topcls,:topdem,:datann,:catage,:vrbrgl)');
    insjou.Prepare;

    z := getROQuery(pvCnx);

    { joueurs et clubs }
    { parcourir chaque ligne du fichier excel. La cellule A:row ne doit pas être vide }
    row := 2;
    datinsc := _sht.Cells[row, col_datinsc];
    datinsc := Trim(datinsc);
    while (datinsc <> '') do
    begin
      jou.ParamByName('licence').AsString := Trim(_sht.Cells[row,col_codspi]);
      jou.Open;
      try
        x := updjou;
        if jou.IsEmpty then
          x := insjou;
        for i := 0 to x.Params.Count-1 do x.Params[i].Clear;

        if not jou.IsEmpty then
          x.ParamByName('serjou').AsInteger := jou.FieldByName('serjou').AsInteger
        else
          x.ParamByName('serjou').AsInteger := pvSeq.SerialByName('JOUEUR');

        x.ParamByName('saison').AsInteger := _tournament.FieldByName('saison').AsInteger;
        x.ParamByName('licence').AsString := Trim(_sht.Cells[row,col_codspi]);
        x.ParamByName('codclb').AsString := Trim(_sht.Cells[row,col_codclb]);
        x.ParamByName('nomjou').AsString := Trim(_sht.Cells[row,col_nomspi]);
        x.ParamByName('codcls').AsString := Trim(_sht.Cells[row,col_codcls]);
        x.ParamByName('topcls').AsString := Trim(_sht.Cells[row,col_topcls]);
        x.ParamByName('topdem').AsString := Trim(_sht.Cells[row,col_topdem]);
        x.ParamByName('datann').AsDateTime := StrToDate(Trim(_sht.Cells[row,col_datnss]));
        x.ParamByName('catage').AsString := getCatage(x.ParamByName('datann').AsDateTime,_tournament.FieldByName('saison').AsInteger);
        x.ParamByName('vrbrgl').AsString := Trim(_sht.Cells[row,col_vrbrgl]);
        x.ExecSQL;
      finally
        jou.Close;
      end;

      { mise à jour de la table des clubs }
      z.SQL.Clear;
      z.SQL.Add('update club set libclb = :libclb WHERE codclb = :codclb');
      z.Prepare;

      clb.ParamByName('codclb').AsString := Trim(_sht.Cells[row,col_codclb]);
      clb.Open;
      { si le club n'existe pas, on l'ajoute à la table }
      if clb.IsEmpty then
      begin
        insclb.ParamByName('codclb').AsString := clb.ParamByName('codclb').AsString;
        insclb.ParamByName('libclb').AsString := Trim(_sht.Cells[row,col_nomclb]);
        insclb.ExecSQL;
      end
      else
      { sinon mise-à-jour du libellé }
      begin
        z.ParamByName('codclb').AsString := clb.ParamByName('codclb').AsString;
        z.ParamByName('libclb').AsString := Trim(_sht.Cells[row,col_nomclb]);
        z.ExecSQL;
      end;
      clb.Close;

      { partenaire }
      datinsc := _sht.Cells[row, col_codptn];
      datinsc := Trim(datinsc);
      if datinsc <> '' then
      begin
        jou.ParamByName('licence').AsString := datinsc;
        jou.Open;
        try
          x := updjou;
          if jou.IsEmpty then
            x := insjou;
          for i := 0 to x.Params.Count-1 do x.Params[i].Clear;
          if not jou.IsEmpty then
            x.ParamByName('serjou').AsInteger := jou.FieldByName('serjou').AsInteger
          else
            x.ParamByName('serjou').AsInteger := pvSeq.SerialByName('JOUEUR');
          x.ParamByName('saison').AsInteger := _tournament.FieldByName('saison').AsInteger;
          x.ParamByName('licence').AsString := datinsc;
          codclb := Trim(_sht.Cells[row,col_codclbptn]);
          getLibClb(codclb);  // pour ajouter le club si pas dans la table des clubs
          x.ParamByName('codclb').AsString := codclb;
          x.ParamByName('nomjou').AsString := Trim(_sht.Cells[row,col_nomptn]);
          x.ParamByName('codcls').AsString := Trim(_sht.Cells[row,col_clsptn]);
          x.ParamByName('topcls').AsString := Trim(_sht.Cells[row,col_topptn]);
          x.ParamByName('topdem').AsString := Trim(_sht.Cells[row,col_demptn]);
          datnss := Trim(_sht.Cells[row,col_datnssptn]);
          if datnss <> '' then
          begin
            x.ParamByName('datann').AsString := datnss;
            x.ParamByName('catage').AsString := getCatage(x.ParamByName('datann').AsDateTime,_tournament.FieldByName('saison').AsInteger);
          end;
          x.ParamByName('vrbrgl').AsString := Trim(_sht.Cells[row,col_rglptn]);
          x.ExecSQL;
        finally
          jou.Close;
        end;

        z.SQL.Clear;
        z.SQL.Add('UPDATE club SET libclb = :libclb WHERE codclb = :codclb');
        z.Prepare;
      end;

      { lecture de la prochaine ligne }
      Inc(row);
      datinsc := _sht.Cells[row, col_datinsc];
      datinsc := Trim(datinsc);
    end;

    { suppression des données existantes }
    z.SQL.Clear;
    z.SQL.Add(Format('DELETE FROM %s WHERE sertrn = %d', ['categories',_sertrn]));
    z.ExecSQL;

    Z.SQL.Clear;
    z.SQL.Add(Format('DELETE FROM %s WHERE sertrn = %d', ['classements',_sertrn]));
    z.ExecSQL;

    Z.SQL.Clear;
    z.SQL.Add(Format('DELETE FROM %s WHERE sertrn = %d', ['insc',_sertrn]));
    z.ExecSQL;

    Z.SQL.Clear;
    z.SQL.Add(Format('DELETE FROM %s WHERE sertrn = %d', ['tableau',_sertrn]));
    z.ExecSQL;

    z.SQL.Clear;
    z.SQL.Add(Format('DELETE FROM %s WHERE sertrn = %d', ['match_groupe',_sertrn]));
    z.ExecSQL;

    Z.SQL.Clear;
    z.SQL.Add(Format('DELETE FROM %s WHERE sertrn = %d', ['match',_sertrn]));
    z.ExecSQL;

    Z.SQL.Clear;
    z.SQL.Add(Format('DELETE FROM %s WHERE sertrn = %d', ['prptab',_sertrn]));
    z.ExecSQL;

    Z.SQL.Clear;
    z.SQL.Add(Format('DELETE FROM %s WHERE sertrn = %d', ['tablo',_sertrn]));
    z.ExecSQL;

    z.SQL.Clear;
    z.SQL.Add(Format('DELETE FROM %s WHERE sertrn = %d', ['compo_groupe',_sertrn]));
    z.ExecSQL;

    z.SQL.Clear;
    z.SQL.Add(Format('DELETE FROM %s WHERE sertrn = %d', ['groupe_result',_sertrn]));
    z.ExecSQL;

    z.SQL.Clear;
    z.SQL.Add(Format('DELETE FROM %s WHERE sertrn = %d', ['groupe',_sertrn]));
    z.ExecSQL;

    z.SQL.Clear;
    z.SQL.Add(Format('DELETE FROM %s WHERE sertrn = %d', ['umpires',_sertrn]));
    z.ExecSQL;

    { inscriptions }
    cat := getROQuery(pvCnx);
    cat.SQL.Add('SELECT sercat,simple FROM categories WHERE codcat = :codcat'
               +' and sertrn = :sertrn');
    cat.Prepare;
    cat.ParamByName('sertrn').AsInteger := _sertrn;

    inscat := getROQuery(pvCnx);
    inscat.SQL.Add('INSERT INTO categories (sercat,sertrn,saison,codcat,heudeb'
                  +'                       ,simple,handicap,numset,catage,stacat'
                  +'                       ,first_round_mode,parent,phase)'
                  +' VALUES '
                  +Format('(:sercat,%d,%d,:codcat,%s,:simple,%s,3,%s,0,%d,0,%s)',[_tournament.FieldByName('sertrn').AsInteger,_tournament.FieldByName('saison').AsInteger,QuotedStr('08:00'),QuotedStr('0'),QuotedStr('0'),_tournament.FieldByName('first_round_mode').AsInteger,_tournament.FieldByName('mode').AsString]));
    insc := getROQuery(pvCnx);
    insc.SQL.Add('INSERT INTO insc (serinsc,sercat,datinsc,simple,serjou,serptn,statut,sertrn)'
                +' VALUES '
                +'(:serinsc,:sercat,:datinsc,:simple,:serjou,:serptn,:statut,:sertrn)');
    insc.Prepare;
    insc.ParamByName('sertrn').AsInteger := _sertrn;

    { parcourir chaque ligne du fichier excel. La cellule A:row ne doit pas être vide }
    row := 2;
    datinsc := _sht.Cells[row, col_datinsc];
    datinsc := Trim(datinsc);
    while (datinsc <> '') do
    begin
      { simple ou double }
      codptn := _sht.Cells[row,col_codptn];
      codptn := Trim(codptn);
      codcat := Trim(_sht.Cells[row,col_categ]);
      if codcat <> '' then
      begin
        cat.ParamByName('codcat').AsString := codcat;
        cat.Open;
        if cat.IsEmpty then
        begin
          inscat.ParamByName('sercat').AsInteger := pvSeq.SerialByName('INSCRIPTION');
          inscat.ParamByName('codcat').AsString := codcat;
          if codptn = '' then
            inscat.ParamByName('simple').AsString := '1'
          else
            inscat.ParamByName('simple').AsString := '0';
          inscat.ExecSQL;
          cat.Close;
          cat.Open;
        end
        else
        { contrôle de la catégorie. Si c'est un tableau de doubles et que le premier
          record est incomplet (pas de partenaire déclaré), alors la catégorie va être
          classifiée comme simple. Il faut donc contrôler à chaque fois. }
        begin
          if (cat.FieldByName('simple').AsString = '1') and (codptn <> '') then
          begin
            w.SQL.Clear;
            w.SQL.Add('update categories set simple = 0 WHERE sercat = :sercat');
            w.ParamByName('sercat').AsInteger := _tournament.FieldByName('sertrn').AsInteger;
            w.ExecSQL;
          end;
        end;
        licence := Trim(_sht.Cells[row,col_codspi]);
        jou.ParamByName('licence').AsString := licence;
        jou.Open;
        try
          if not jou.IsEmpty then
          begin
            insc.ParamByName('serinsc').AsInteger := pvSeq.SerialByName('INSCRIPTION');
            insc.ParamByName('sercat').AsInteger := cat.FieldByName('sercat').AsInteger;
            insc.ParamByName('datinsc').AsString := Copy(datinsc,1,16);
            insc.ParamByName('simple').AsString := '1';
            insc.ParamByName('serjou').AsInteger := jou.FieldByName('serjou').AsInteger;
            insc.ParamByName('statut').AsString := '1';
            jou.Close;
            codptn := _sht.Cells[row,col_codptn];
            codptn := Trim(codptn);
            if codptn <> '' then
            begin
              insc.ParamByName('simple').AsString := '0';
              jou.ParamByName('licence').AsString := codptn;
              jou.Open;
              if not jou.IsEmpty then
              begin
                insc.ParamByName('serptn').AsInteger := jou.FieldByName('serjou').AsInteger;
              end;
            end;
            insc.ExecSQL;
          end;
        finally
          if jou.Active then jou.Close;
        end;
      end;
      cat.Close;
      { lecture de la prochaine ligne }
      Inc(row);
      datinsc := _sht.Cells[row, col_datinsc];
      datinsc := Trim(datinsc);
    end;
  finally
    freeROQuerys([clb,insclb,jou,insjou,updjou,z,cat,inscat,insc,w]);
  end;
  _cat.Refresh;
end;

type
  TLicences = array[1..2] of string;
procedure TtournamentW.doublonDataChange(Sender: TObject; Field: TField);
  function licences(licence: string): TLicences;
  var
    i: integer;
  begin
    i := Pos('-',licence);
    Result[1] := Copy(licence,1,Pred(i));
    Result[2] := Copy(licence,Succ(i),Length(licence)-i);
  end;
var
  L: TLicences;
  s1,s2,s3: string;
begin
  if Field = nil then
  begin
    L := licences(FDoublons.data.FieldByName('licence').AsString);
    with getROQuery(pvCnx) do
    begin
      try
        SQL.Add('SELECT distinct nomjou,codcls FROM joueur a, insc b'
               +' WHERE a.serjou = b.serjou'
               +'   and b.sertrn = :sertrn'
               +'   and licence = :licence');
        Prepare;
        Params[0].AsInteger := Self.sertrn.Field.AsInteger;
        Params[1].AsString := L[1];
        Open;
        s1 := Format('%s(%s)',[Fields[0].AsString,Fields[1].AsString]);
        Close;
        Params[1].AsString := L[2];
        Open;
        s2 := Format('%s(%s)',[Fields[0].AsString,Fields[1].AsString]);
        Close;
        SQL.Clear;
        SQL.Add('SELECT distinct c.codcat'
                +' FROM joueur a, insc b, categories c, joueur d, insc e'
                +' WHERE a.serjou = b.serjou'
                +'   and b.sertrn = :sertrn'
                +'   and a.licence = :lic1'
                +'   and b.sercat = c.sercat'
                +'   and d.serjou = e.serjou'
                +'   and e.sertrn = b.sertrn'
                +'   and c.sercat = e.sercat'
                +'   and d.licence = :lic2');
        Params[0].AsInteger := Self.sertrn.Field.AsInteger;
        Params[1].AsString := L[1];
        Params[2].AsString := L[2];
        Open;
        while not Eof do
        begin
          s3 := s3 + ',' + Fields[0].AsString;
          Next;
        end;
        System.Delete(s3,1,1);
      finally
        Free;
      end;
    end;
    FDoublons.SB.Panels[0].Text := s1+ ' - ' + s2 + ' -> ' + s3 ;
  end;
end;

function TtournamentW.editMatch(const sermtc: integer): boolean;
var
  mtc: Game.TGame;
begin
  Result := False;
  if sermtc = 0 then Exit;
  mtc := Game.TGame.Create(Self,pvCnx,sermtc);
  try
    with TmatchW.Create(Self,pvCnx, mtc) do
    begin
      try
        Result := ShowModal = mrOk;
      finally
        Free;
      end;
    end;
  finally
    mtc.Free;
  end;
end;

procedure TtournamentW.editMatchActionExecute(Sender: TObject);
var
  data: TDataset;
begin
  inherited;
  if ActiveControl is TDBCtrlGrid then
  begin
    data := TDBCtrlGrid(ActiveControl).DataSource.DataSet;
    if editMatch(data.FieldByName('sermtc').AsInteger) then
      data.Refresh;
  end;
end;

procedure TtournamentW.eliminateActionExecute(Sender: TObject);
begin
  inherited;
  with getROQuery(pvCnx) do
  begin
    try
      SQL.Add('update insc set statut = :statut WHERE serinsc = :serinsc');
      ParamByName('statut').Value := rsDisqualified;
      ParamByName('serinsc').AsInteger := _insc.FieldByName('serinsc').AsInteger;
      ExecSQL;
      _insc.Refresh;
    finally
      Free;
    end;
  end;
end;

procedure TtournamentW.excelActionExecute(Sender: TObject);
begin
  inherited;
  Draw2Excel(sertab.Field.AsInteger, score.Checked, completCheck.Checked, PrepareExportDirectories(sertrn.Field.AsInteger, organisateur.Field.AsString));
  MessageDlg('export Excel terminé',mtInformation,[mbOk],0);
end;

function TtournamentW.PrepareExportDirectories(const sertrn: integer; const organisateur: string): TFilename;
var
  expdir: TFilename;
begin
  Result := glSettings.ExportDirectory;
  expdir := Format('%s\%d\%.5d - %s',[glSettings.TournamentsDirectory, saison.Field.AsInteger, sertrn, organisateur]);
  ForceDirectories(expdir);
  if DirectoryExists(expdir) then
    Result := expdir;
end;

procedure TtournamentW.firstRoundModeTournoiEnter(Sender: TObject);
begin
  inherited;
  pvSeek.Seek_Code := glSettings.SeekConfigs.Values[glSettings.SeekCodeFirstRoundMode];
  SelectSeekMenu.OnClick := SelectFirstRoundModeActionExecute;
end;

procedure TtournamentW.firstRoundModeTournoiKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = pvSeek.SeekKey then
  begin
    Key := 0;
    if pvSeek.Seek then
    begin
      TDBEdit(Sender).DataSource.DataSet.Edit;
      TDBEdit(Sender).Field.AsString := pvSeek.Returns.Values['pardc1'];
    end;
  end;
end;

procedure TtournamentW.GenerateTabValues(sertab: integer);
var
  z: TZReadOnlyQuery;
begin
  z := nil;
  try
    z := getROQuery(pvCnx);
    if _tab.Active then
      _tab.Close;
    _tab.ParamByName('sertab').AsInteger := sertab;
    _tab.Open;
    if (_tab.IsEmpty) or ((_cat.FieldByName('phase').AsInteger = Ord(frQualification)) and (_tab.FieldByName('nbrgrp').AsInteger = 0)) then
    begin
      z.SQL.Clear;
      z.SQL.Add('INSERT INTO tableau (sertab,taille,nbrjou,nbrtds,sertrn,nbrgrp)'
               +' VALUES (:sertab,:taille,:nbrjou,:nbrtds,:sertrn,0)');
      z.ParamByName('sertab').AsInteger := sertab;
      z.ParamByName('nbrjou').AsInteger := _cat.FieldByName('participants').AsInteger;
      z.ParamByName('sertrn').AsInteger := _sertrn;
      z.ParamByName('taille').AsInteger := getTailleTableau(_cat.FieldByName('participants').AsInteger);
      z.ParamByName('nbrtds').AsInteger := z.ParamByName('taille').AsInteger div 8;
      z.ExecSQL;
      _tab.Refresh;
//      _tab.Close;
//      _tab.ParamByName('sertab').AsInteger := sertab;
//      _tab.Open;
    end;
  finally
    freeROQuerys([z]);
  end;
end;

procedure TtournamentW.prpclbGridCellClick(Column: TColumn);
begin
  inherited;
  if (Column.FieldName = 'LIBCLB') then
  begin
    _stabylo := Column.FieldName;
    _stabval := Column.Grid.DataSource.DataSet.FieldByName(Column.FieldName).AsString;
    prpGrid.Repaint;
    tabloGrid.Repaint;
  end;
end;

procedure TtournamentW.prpGridCellClick(Column: TColumn);
begin
  inherited;
  if (Column.FieldName = 'CODCLS') or (Column.FieldName = 'LIBCLB') then
  begin
    _stabylo := Column.FieldName;
    _stabval := Column.Grid.DataSource.DataSet.FieldByName(Column.FieldName).AsString;
    Column.Grid.Repaint;
  end;
end;

procedure TtournamentW.prpGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  AState: TGridDrawState);
var
  f: TField;
begin
  inherited;
  if TDBGrid(Sender).DataSource.DataSet.Eof then
    Exit;
  with TDBGrid(Sender),TDBGrid(Sender).Canvas,TDBGrid(Sender).DataSource.DataSet do
  begin
    Brush.Color := getItemsColor(piUnknown);
    { Changer de couleur toutes les 2 cellules }
    if FindField('numrow') <> nil then
      Brush.Color := getGridRowColor(clOdd[Odd(Trunc((FieldByName('numrow').AsInteger / 2)+0.5))]);
    { highlight tête de série }
    f := FindField('numseq');
    if f = nil then
      f := FindField('numtds');
    if (f <> nil) and (f.AsInteger <= _tab.FieldByName('nbrtds').AsInteger) then
      Font.Style := [fsBold];
    f := FindField('is_qualified');
    if (f <> nil) and (f.AsInteger = Ord(rsQualified)) then
      Brush.Color := getItemsColor(piQualified);
    { highlight classement ou club }
    if _stabylo <> '' then
    begin
      if (FieldByName(_stabylo).AsString = _stabval) then
        Brush.Color := getItemsColor(piClub);
    end;
    if gdSelected in AState then begin
      Brush.Color := getItemsColor(piHighlight);
      Font.Color := getItemsColor(piHighLightText);
    end;
    DefaultDrawColumnCell(Rect,DataCol,Column,AState);
  end;
end;

procedure TtournamentW.registrationStatusGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if not Sender.DataSet.Eof then
  begin
    try
      Text := Format('%s (%d)',[getRegistrationsDesc(TRegistrationStatus(Sender.AsInteger)),Sender.AsInteger]);
    except
      Text := Format('%s (%d)',[getEnumName(TypeInfo(TRegistrationStatus),Sender.AsInteger),Sender.AsInteger]);
    end;
  end;
end;

procedure TtournamentW.requalifyMenuClick(Sender: TObject);
begin
  inherited;
  with getROQuery(pvCnx) do
  begin
    try
      SQL.Add('update insc set statut = :statut WHERE serinsc = :serinsc');
      ParamByName('statut').Value := rsQualified;
      ParamByName('serinsc').AsInteger := _insc.FieldByName('serinsc').AsInteger;
      ExecSQL;
      _insc.Refresh;
    finally
      Free;
    end;
  end;
end;

procedure TtournamentW.resultsActionExecute(Sender: TObject);
begin
  inherited;
  screen.Cursor := crHourglass;
  try
    tmUtils15.createResultsFLTTDocument(_sertrn);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TtournamentW.saisonEnter(Sender: TObject);
begin
  inherited;
  pvSeek.Seek_Code := glSettings.SeekCodeSaison;
  SelectSeekMenu.OnClick := SelectSeekSaisonActionExecute;
end;

procedure TtournamentW.saisonKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = pvSeek.SeekKey then
  begin
    Key := 0;
    if pvSeek.Seek then
    begin
      TDBEdit(Sender).DataSource.DataSet.Edit;
      TDBEdit(Sender).Field.AsString := pvSeek.Returns.Values['SAISON'];
    end;
  end;
end;

procedure TtournamentW.SeekConfigActionExecute(Sender: TObject);
begin
  inherited;
  pvSeek.configure;
end;

procedure TtournamentW.SelectFirstRoundModeActionExecute(Sender: TObject);
var
  code: string;
begin
  inherited;
  code := glSettings.SeekConfigs.Values[glSettings.SeekCodeFirstRoundMode];
  if SelectSeek(code) then
  begin
    glSettings.SeekConfigs.Values[glSettings.SeekCodeFirstRoundMode] := code;
    pvSeek.Seek_Code := code;
  end;
end;

function TtournamentW.SelectSeek(var seek_code: string): boolean;
begin
  with TSeekConfigsW.Create(Self,pvCnx.get) do
  begin
    try
      data.Locate('seek_code',seek_code,[loCaseInsensitive]);
      Result := ShowModal = mrOk;
      if Result then
      begin
        seek_code := data.FieldByName('seek_code').AsString;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TtournamentW.SelectSeekCategActionExecute(Sender: TObject);
var
  code: string;
begin
  inherited;
  code := glSettings.SeekCodeCategoryStatus;
  if SelectSeek(code) then
  begin
    glSettings.SeekConfigs.Values[glSettings.SeekCodeCategoryStatus] := code;
    pvSeek.Seek_Code := code;
  end;
end;

procedure TtournamentW.SelectSeekCodClbActionExecute(Sender: TObject);
var
  code: string;
begin
  inherited;
  code := glSettings.SeekCodeClub;
  if SelectSeek(code) then
  begin
    glSettings.SeekConfigs.Values[cs_code_club_seek_code] := code;
    pvSeek.Seek_Code := code;
  end;
end;

procedure TtournamentW.SelectSeekSaisonActionExecute(Sender: TObject);
var
  code: string;
begin
  inherited;
  code := glSettings.SeekCodeSaison;
  if SelectSeek(code) then
  begin
    glSettings.SeekConfigs.Values[cs_saison_seek_code] := code;
    pvSeek.Seek_Code := code;
  end;
end;

procedure TtournamentW.SetCategStatutActionExecute(Sender: TObject);
begin
  inherited;
  if (pvSeek.Seek) then
  begin
    catGrid.DataSource.DataSet.Edit;
    catGrid.DataSource.DataSet.FieldByName('stacat').AsInteger := GetEnumValue(TypeInfo(TCategorysStatus), pvSeek.Returns.Values['coddic']);
  end;
end;

procedure TtournamentW.SetFirstRoundModeActionExecute(Sender: TObject);
begin
  inherited;
  TogglePhase(catSource.Dataset.FieldByName('sercat').AsInteger,'first_round_mode');
  catSource.DataSet.Refresh;
end;

procedure TtournamentW.SetPhaseActionExecute(Sender: TObject);
begin
  inherited;
  TogglePhase(catSource.Dataset.FieldByName('sercat').AsInteger,'phase');
  catSource.DataSet.Refresh;
end;

procedure TtournamentW.SetGenerateGamesButtonAction;
begin
  if _cat.FieldByName('phase').AsInteger = Ord(frKO) then
  begin
    GenerateGamesButton.Action := GenerateDrawGamesAction;
  end
  else if _cat.FieldByName('phase').AsInteger = Ord(frQualification) then
  begin
    GenerateGamesButton.Action := GenerateGroupGamesAction;
  end;
end;

procedure TtournamentW.SetGroupsActionExecute(Sender: TObject);
begin
  inherited;
  BuildGroups(tabSource.DataSet.FieldByName('sertab').AsInteger);
end;

procedure TtournamentW.BuildGroups(const sercat: integer);
var
  cursor: TCursor;
begin
  cursor := Screen.Cursor;
  try
    pvCnx.startTransaction;
    try
      Screen.Cursor := crSQLWait;
      QualifieTDS(sercat);
      ComposeGroupes(sercat);
      pvCnx.commit;
      CheckAndSetCategorieStatusAfterUpdate(sercat);
//      _stacat(sercat,csGroup);
      prpSource.DataSet.Refresh;
      catSource.DataSet.Refresh;
      catSource.DataSet.Locate('sercat',sercat,[]);
      DisplayGroups(sercat);
    except
      pvCnx.rollback;
      raise;
    end;
  finally
    Screen.Cursor := cursor;
  end;
end;

procedure TtournamentW.QualificationGroupRefresh(var Message: TMessage);
var
  i: Integer;
begin
  for i := 0 to GroupsScrollBox.ControlCount-1 do
    if GroupsScrollBox.Controls[i] is TGroupPanel then
      if TGroupPanel(GroupsScrollBox.Controls[i]).Sergrp = Message.WParam then
        TGroupPanel(GroupsScrollBox.Controls[i]).Refresh;
end;

procedure TtournamentW.QualifieTDS(const sercat: integer);
//var
//  nbrgrp,min,max: integer;
//  z: TZReadOnlyQuery;
begin
  QualifySeeds(sercat);
//  z := getROQuery(pvCnx);
//  try
//    z.SQL.Add('SELECT taille,nbrjou FROM tableau WHERE sertab = :sercat');
//    z.Params[0].AsInteger := sercat;
//    z.Open;
//    { déterminer le nombre de groupes de 3 }
//    nbrgrp := z.FieldByName('nbrjou').AsInteger div 3;
//    { passer à non-qualifié les joueurs des groupes hors tds }
//    min := Succ(z.FieldByName('nbrjou').AsInteger - nbrgrp*3);
//    max := z.FieldByName('taille').AsInteger;
//    z.Close;
//    z.SQL.Clear;
//    z.SQL.Add('UPDATE tableau SET nbrgrp = :nbrgrp WHERE sertab = :sercat');
//    z.Params[0].AsInteger := nbrgrp;
//    z.Params[1].AsInteger := sercat;
//    z.ExecSQL;
//    z.SQL.Clear;
//    z.SQL.Add('UPDATE prptab SET is_qualified = :is_qualified'
//             +' WHERE sertab = :sercat'
//             +'   AND numtds BETWEEN :min AND :max');
//    z.Params[0].AsInteger := ord(rsDisqualified);
//    z.Params[1].AsInteger := sercat;
//    z.Params[2].AsInteger := min;
//    z.Params[3].AsInteger := max;
//    z.ExecSQL;
//  finally
//    z.Free;
//  end;
end;

procedure TtournamentW.ComposeGroupes(const sercat: integer);
var
  sel{,z}: TZReadOnlyQuery;
  sertrn,
  nbrgrp, numgrp,
  sergrp: integer;
  sens: TSens;
begin
  sel := nil;
  try
    nbrgrp := _tab.FieldByName('nbrgrp').AsInteger;
    sertrn := _tab.FieldByName('sertrn').AsInteger;

    sel := getROQuery(pvCnx);
    sel.SQL.Add('SELECT numtds,serjou,licence,nomjou,codclb,libclb,classement FROM prptab'
               +' WHERE sertab = :sercat'
               +'   AND is_qualified = :is_qualified'
               +'   AND serjou > 0'
               +' ORDER BY numtds');
    sel.Params[0].AsInteger := sercat;
    sel.Params[1].AsInteger := Ord(rsDisqualified);
    sel.Open;
    numgrp := 0;
    sens := ssCroissant;
    while not sel.Eof do
    begin
      CalculeNumeroGroupe(numgrp,nbrgrp,sens);
      sergrp := CreeGroupeQualification(sercat,sertrn,numgrp);
      InsereJoueurDansGroupeQualification(sergrp,sel.FieldByName('serjou').AsInteger,sercat,sertrn);
      sel.Next;
      Application.ProcessMessages;
    end;
    sel.Close;
  finally
    sel.Free;
//    z.Free;
  end;
end;

procedure TtournamentW.CalculeNumeroGroupe(var numgrp: integer;
  const nbrgrp: integer; var sens: TSens);
begin
  case sens of
    ssCroissant: begin
      Inc(numgrp);
      if numgrp > nbrgrp then
      begin
        Dec(numgrp);
        sens := ssDecroissant;
      end;
    end;
    ssDecroissant: begin
      Dec(numgrp);
      if numgrp = 0 then
      begin
        Inc(numgrp);
        sens := ssCroissant;
      end;
    end;
  end;
end;

function TtournamentW.CreeGroupeQualification(const sercat, sertrn,
  numgrp: integer): integer;
//var
//  z: TZReadOnlyQuery;
begin
  Result := CreateQualificationGroup(sercat,sertrn,numgrp);
//  z := getROQuery(pvCnx);
//  try
//    z.SQL.Add('SELECT sergrp FROM groupe'
//             +' WHERE sercat = :sercat'
//             +'   AND numgrp = :numgrp');
//    z.Params[0].AsInteger := sercat;
//    z.Params[1].AsInteger := numgrp;
//    z.Open;
//    if (z.Fields[0].IsNull) or (z.Fields[0].AsInteger = 0) then
//    begin
//      z.Close;
//      z.SQL.Clear;
//      z.SQL.Add('INSERT INTO groupe (sergrp,sercat,numgrp,stagrp,sertrn)'
//               +' VALUES (:sergrp,:sercat,:numgrp,:stagrp,:sertrn)');
//      z.Params[0].AsInteger := pvSeq.SerialByName('SEQ_SERGRP');
//      z.Params[1].AsInteger := sercat;
//      z.Params[2].AsInteger := numgrp;
//      z.Params[3].AsInteger := Ord(gsInactive);
//      z.Params[4].AsInteger := sertrn;
//      z.ExecSQL;
//      Result := z.Params[0].AsInteger;
//    end
//    else
//    begin
//      Result := z.Fields[0].AsInteger;
//      z.Close;
//    end;
//  finally
//    z.Free;
//  end;
end;

function TtournamentW.InsereJoueurDansGroupeQualification(const sergrp, serjou,
  sercat, sertrn: integer): integer;
//var
//  z: TZReadOnlyQuery;
begin
  Result := InsertIntoQualificationGroup(sergrp,serjou,sercat,sertrn);
//  Result := 1;
//  z := getROQuery(pvCnx);
//  try
//    z.SQL.Add('SELECT MAX(numseq) FROM compo_groupe'
//             +' WHERE sergrp = :sergrp');
//    z.Params[0].AsInteger := sergrp;
//    z.Open;
//    if not(z.Eof) and (z.Fields[0].AsInteger > 0) then
//      Result := Succ(z.Fields[0].AsInteger);
//    z.Close;
//    z.SQL.Clear;
//    z.SQL.Add('INSERT INTO compo_groupe (sergrp,numseq,serjou,sercat,sertrn)'
//             +' VALUES (:sergrp,:numseq,:serjou,:sercat,:sertrn)');
//    z.Params[0].AsInteger := sergrp;
//    z.Params[1].AsInteger := Result;
//    z.Params[2].AsInteger := serjou;
//    z.Params[3].AsInteger := sercat;
//    z.Params[4].AsInteger := sertrn;
//    z.ExecSQL;
//    z.SQL.Clear;
//    z.SQL.Add('UPDATE prptab SET sergrp = :sergrp'
//             +' WHERE sertab = :sercat'
//             +'   AND serjou = :serjou');
//    z.Params[0].AsInteger := sergrp;
//    z.Params[1].AsInteger := sercat;
//    z.Params[2].AsInteger := serjou;
//    z.ExecSQL;
//  finally
//    z.Free;
//  end;
end;

procedure TtournamentW.DisplayCategoryButtonClick(Sender: TObject);
begin
  inherited;
  ActivateTabSheet(pg, tabSheet);
end;

procedure TtournamentW.DisplayGroups(const sercat: integer);
begin
  ClearGroups;
  CreateGroupPanels(sercat);
  ActivateTabSheet(PreparationPageControl, GroupsSheet);
end;

procedure TtournamentW.DisplayTableau;
begin
  ActivateTabSheet(pg, tabSheet);
  GenerateTabValues(_cat.FieldByName('sercat').AsInteger);
  if not _insc.Active then _insc.Open;
  if not _prp.Active then _prp.Open;
  if not _prpclb.Active then _prpclb.Open;
  if not _tablo.Active then _tablo.Open;
  aleatoireBox.Checked := catSource.DataSet.Active and
                          not(catSource.DataSet.Eof) and
                          (catSource.DataSet.FieldByName('handicap').AsInteger = 1);
  if (catSource.DataSet.FieldByName('first_round_mode').AsInteger = Ord(frQualification)) and
     (catSource.DataSet.FieldByName('phase').AsInteger = Ord(frQualification)) then
    DisplayGroups(catSource.DataSet.FieldByName('sercat').AsInteger)
  else
  begin
    ClearGroups;
    ActivateTabSheet(PreparationPageControl, DrawSheet);
  end;
  SetGenerateGamesButtonAction;
end;

procedure TtournamentW.DisplayTableauActionExecute(Sender: TObject);
begin
  inherited;
  DisplayTableau;
end;

procedure TtournamentW.ClearGroups;
begin
  while GroupsScrollBox.ControlCount > 0 do
  begin
    GroupsScrollBox.Controls[0].Free;
  end;
end;

procedure TtournamentW.CreateGroupPanels(const sercat: integer);
var
  z: TZReadOnlyQuery;
  nbrgrp: integer;
  gp: TGroupPanel;
begin
  z := getROQuery(pvCnx);
  try
    GroupsScrollBox.Visible := False;
    z.SQL.Add('SELECT nbrgrp,sertrn FROM tableau WHERE sertab = :sercat');
    z.Params[0].AsInteger := sercat;
    z.Open;
    nbrgrp := z.Fields[0].AsInteger;
    z.Close;
    z.SQL.Clear;
    z.SQL.Add('SELECT sergrp,numgrp'
             +' FROM groupe'
             +' WHERE sercat = :sercat'
             +' ORDER BY numgrp DESC');
    z.Params[0].AsInteger := sercat;
    z.Open;
    while not z.Eof do
    begin
      gp := CreateGroupPanel(z.FieldByName('sergrp').AsInteger);
      PositionneGroupPanel(gp, nbrgrp);
      z.Next;
      Application.ProcessMessages;
    end;
    z.Close;
  finally
    GroupsScrollBox.Visible := True;
    z.Free;
  end;
end;

function TtournamentW.CreateGroupPanel(const sergrp: integer): TGroupPanel;
begin
  Result := TGroupPanel.Create(Self, pvCnx, sergrp);
  Result.Parent := GroupsScrollBox;
  Result.CreateGamesProc := tmUtils15.glCreateGroupGamesProc;
end;

procedure TtournamentW.PhaseGetText(Sender: TField; var Text: string;
  DisplayText: boolean);
begin
  if not Sender.IsNull then
    Text := Format('%s [%s]',[Sender.AsString,GetEnumName(TypeInfo(TFirstRoundMode), Sender.AsInteger)]);
end;

procedure TtournamentW.PositionneGroupPanel(gp: TGroupPanel; const nbrgrp: integer);
begin
  gp.Width := (Self.groupsPanel.ClientWidth - Pred(nbrgrp)) div nbrgrp;
  gp.Refresh;
end;

procedure TtournamentW.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  openMatches;
end;

procedure TtournamentW.Swap2PlayersActionExecute(Sender: TObject);
var
  swp: TSwap2PlayersW;
begin
  inherited;
  swp := TSwap2PlayersW.Create(Self, pvCnx, catSource.DataSet.FieldByName('sercat').AsInteger);
  try
    if swp.ShowModal = mrOk then
    begin
      RefreshGroups;
    end;
  finally
    swp.Free;
  end;
end;

procedure TtournamentW.RefreshGroups;
var
  i: integer;
begin
  for i := 0 to GroupsScrollBox.ControlCount-1 do
    TGroupPanel(GroupsScrollBox.Controls[i]).Refresh;
end;

procedure TtournamentW.PrepareActionExecute(Sender: TObject);
var
  z,x: TZReadOnlyQuery;
  numseq: smallint;
  serjou,
  serptn: integer;
  sertab: integer;
label
  close;
begin
  z := nil;
  x := getROQuery(pvCnx);
  try
    sertab := _tab.FieldByName('sertab').AsInteger;
    z := getROQuery(pvCnx);
    z.SQL.Add('SELECT COUNT(*) FROM prptab WHERE sertab = :sertab');
    z.ParamByName('sertab').AsInteger := sertab;
    z.Open;
    if z.Fields[0].AsInteger = 0 then
    begin
      pvCnx.startTransaction;
      try
        z.Close;
        z.SQL.Clear;
        z.SQL.Add('INSERT INTO prptab (sertab,serprp,serjou,serptn,licence,nomjou'
                  +'  ,seqcls,codclb,libclb,codcls,classement,vrbrgl,numtds,sertrn)'
                 +' VALUES '
                 +'(:sertab,:serprp,:serjou,:serptn,:licence,:nomjou,:seqcls'
                 +'   ,:codclb,:libclb,:codcls,:classement,:vrbrgl,:numtds,:sertrn)');
        z.Prepare;
        z.ParamByName('sertab').AsInteger := sertab;
        z.ParamByName('sertrn').AsInteger := _tab.FieldByName('sertrn').AsInteger;

//        x.SQL.Add('SELECT  b.serjou,b.licence,b.nomjou,b.codcls,d.numseq+coalesce(e.numseq,0)seqcls,b.topcls,b.topdem,b.vrbrgl ranglescht,a.datinsc,b.codclb,k.libclb'
//                 +'       ,coalesce(c.serjou,0) serptn,c.licence licptn,c.nomjou nomptn,c.codcls clsptn,c.codclb clbptn,q.libclb libclbptn'
//                 +'       ,b.vrbrgl+coalesce(c.vrbrgl,0)vrbrgl'
//                 +' FROM insc a LEFT OUTER JOIN joueur c ON (a.serptn = c.SERJOU AND c.saison = :saison)'
//                 +'     ,joueur b,classement d LEFT OUTER JOIN classement e ON c.codcls = e.codcls'
//                 +'     ,club k LEFT OUTER JOIN club q ON c.codclb = q.CODCLB'
//                 +' WHERE a.sercat = :sercat'
//                 +'   and a.serjou = b.serjou'
//                 +'   and b.codcls = d.codcls'
//                 +'   and b.codclb = k.codclb'
//                 +'   and b.saison = :saison'
//                 //+'   and a.statut = ' + IntToStr(Ord(isQualifie))
//                 +' order by seqcls,vrbrgl,codcls,ranglescht');
        x.SQL.Add('SELECT'
                     +' 	 j1.LICENCE ,j1.NOMJOU ,j1.CODCLS ,c1.NUMSEQ +coalesce(c2.NUMSEQ,0) seqcls,j1.TOPCLS ,j1.TOPDEM ,a.DATINSC ,j1.CODCLB,cb1.LIBCLB,j1.vrbrgl ranglescht'
                     +' 	,COALESCE(j2.serjou,0) serptn,j2.LICENCE licptn,j2.NOMJOU nomptn,j2.CODCLS clsptn,j2.CODCLB clbptn,cb2.LIBCLB libclbptn'
                     +'   ,j1.VRBRGL + coalesce(j2.VRBRGL,0) vrbrgl,a.SERINSC ,j1.SERJOU ,a.STATUT'
                     +' 	FROM insc a'
                     +' 		LEFT JOIN JOUEUR j1 ON a.SERJOU = j1.SERJOU'
                     +' 			LEFT JOIN CLASSEMENT c1 ON c1.CODCLS =  j1.CODCLS'
                     +' 			LEFT JOIN club cb1 ON cb1.CODCLB = j1.CODCLB'
                     +' 		LEFT JOIN joueur j2 ON a.SERPTN = j2.SERJOU'
                     +' 			LEFT JOIN CLASSEMENT c2 ON c2.CODCLS =  j2.CODCLS'
                     +' 			LEFT JOIN club cb2 ON cb2.CODCLB = j2.CODCLB'
                     +' WHERE a.sercat = :sercat'
                     +' ORDER BY seqcls,vrbrgl,codcls,ranglescht');

        x.DataSource := catSource;
        Screen.Cursor := crSQLWait;
        numseq := 0;
        serjou := 0;
        serptn := 0;
        x.Open;
        while not x.Eof do
        begin
          if (x.FieldByName('serptn').AsInteger = serjou) and (x.FieldByName('serjou').AsInteger = serptn) then
          begin
            x.Next;
            Continue;
          end;
          Inc(numseq);
          z.ParamByName('serprp').AsInteger := pvSeq.SerialByName('categorie');
          z.ParamByName('serjou').AsInteger := x.FieldByName('serjou').AsInteger;
          z.ParamByName('serptn').AsInteger := x.FieldByName('serptn').AsInteger;
          z.ParamByName('licence').AsString := x.FieldByName('licence').AsString;
          z.ParamByName('nomjou').AsString := x.FieldByName('nomjou').AsString;
          z.ParamByName('codclb').AsString := x.FieldByName('codclb').AsString;
          z.ParamByName('libclb').AsString := x.FieldByName('libclb').AsString;
          z.ParamByName('classement').AsString := x.FieldByName('codcls').AsString;
          z.ParamByName('seqcls').AsInteger := x.FieldByName('seqcls').AsInteger;
          z.ParamByName('codcls').AsString := x.FieldByName('codcls').AsString;
          z.ParamByName('vrbrgl').AsInteger := x.FieldByName('vrbrgl').AsInteger;
          z.ParamByName('numtds').AsInteger := numseq;
          if _cat.FieldByName('simple').AsInteger = 0 then
          begin
            z.ParamByName('licence').AsString := Format('%s-%s',[x.FieldByName('licence').AsString,x.FieldByName('licptn').AsString]);
            z.ParamByName('nomjou').AsString := Format('%s-%s',[x.FieldByName('nomjou').AsString,x.FieldByName('nomptn').AsString]);
            { le code club est celui du joueur le mieux classé }
            //z.ParamByName('codclb').AsString := Format('%s-%s',[x.FieldByName('codclb').AsString,x.FieldByName('clbptn').AsString]);
            z.ParamByName('libclb').AsString := Format('%s-%s',[x.FieldByName('libclb').AsString,x.FieldByName('libclbptn').AsString]);
            z.ParamByName('codcls').AsString := Format('%s-%s',[x.FieldByName('codcls').AsString,x.FieldByName('clsptn').AsString]);
          end;
          z.ExecSQL;
          serjou := x.FieldByName('serjou').AsInteger;
          serptn := x.FieldByName('serptn').AsInteger;
          x.Next;
          Application.ProcessMessages;
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
        while numseq < _tab.FieldByName('taille').AsInteger do
        begin
          Inc(numseq);
          z.ParamByName('serprp').AsInteger := pvSeq.SerialByName('categorie');
          z.ParamByName('numtds').AsInteger := numseq;
          z.ExecSQL;
        end;
        { maj de categories.stacat }
        CheckAndSetCategorieStatusAfterUpdate(sertab);
//        stacat(sertab,csPrepared);
        pvCnx.commit;
        //catSource.DataSet.Refresh;
        catSource.DataSet.Locate('sercat',sertab,[]);
      except
        pvCnx.rollback;
        raise;
      end;
    end
    else    // export excel pour têtes de série
    begin
      if MessageDlg('Voulez-vous exporter la liste des participants sur excel ?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then
      begin
        if x.Active then
          x.Close;
        x.SQL.Clear;
        x.SQL.Add('SELECT min(codcls) FROM classements WHERE sercat = :sertab');
        x.ParamByName('sertab').AsInteger := sertab;
        x.Open;

        if z.Active then
          z.Close;
        z.SQL.Clear;
        z.SQL.Add('SELECT  b.nomjou,b.codcls,d.numseq+coalesce(e.numseq,0)seqcls,k.libclb'
                 +'       ,b.vrbrgl+coalesce(c.vrbrgl,0)vrbrgl'
                 +' FROM insc a LEFT OUTER JOIN joueur c ON (a.serptn = c.SERJOU AND c.saison = :saison)'
                 +'     ,joueur b,classement d LEFT OUTER JOIN classement e ON c.codcls = e.codcls'
                 +'     ,club k LEFT OUTER JOIN club q ON c.codclb = q.CODCLB'
                 +' WHERE a.sercat = :sercat'
                 +'   and a.serjou = b.serjou'
                 +'   and b.codcls = d.codcls'
                 +'   and b.codclb = k.codclb'
                 +'   and b.saison = :saison');
        if not(x.IsEmpty) and (catSource.DataSet.FieldByName('handicap').AsInteger = 0) then
          z.SQL.Add('   and b.codcls = ' + QuotedStr(x.Fields[0].AsString)
                   +' order by nomjou')
        else
          z.sql.add(' order by seqcls,vrbrgl,codcls');
        x.Close;
        z.DataSource := catSource;
        z.Open;
        if z.IsEmpty then
          goto close;
        datasetToExcel(z,True);
        goto close;
      end;
close:
      if z.Active then
        z.Close;
    end;
  finally
    screen.Cursor := crDefault;
    freeROQuerys([z,x]);
  end;
  _prp.Refresh;
end;

procedure TtournamentW.autoDrawActionExecute(Sender: TObject);
var
  tablo: TTablo;
  i,j: integer;
  z: TZReadOnlyQuery;
begin
  inherited;
  z := getROQuery(pvCnx);
  try
    z.SQL.Add('SELECT COUNT(*) FROM tablo WHERE sertab = :sertab');
    z.ParamByName('sertab').AsInteger := sertab.Field.AsInteger;
    z.Open;
    if (z.Fields[0].AsInteger > 0) and (catSource.DataSet.FieldByName('first_round_mode').AsInteger = Ord(frKO)) then
    begin
      if MessageDlg('Voulez-vous réinitialiser le tableau ?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then
      begin
        z.Close;
        z.SQL.Clear;
        z.SQL.Add('delete FROM tablo WHERE sertab = ' + sertab.Field.AsString);
        pvCnx.startTransaction;
        try
          z.ExecSQL;
          z.SQL.Clear;
          z.SQL.Add('delete FROM groupe WHERE sercat = ' + sertab.Field.AsString);
          z.ExecSQL;
          z.SQL.Clear;
          z.SQL.Add('update prptab set serblo = null'
                   +' WHERE sertab = ' + sertab.Field.AsString);
          z.ExecSQL;
          pvCnx.commit;
          CheckAndSetCategorieStatusAfterUpdate(sertab.Field.AsInteger);
        except
          pvCnx.rollback;
          raise;
        end;
      end;
    end;
  finally
    z.Free;
  end;

  tablo := TTablo.Create(False);
  try
    Screen.Cursor := crSQLWait;
    try
      { création du canvas vide }
      for i := 1 to _tab.FieldByName('taille').AsInteger do
        begin
          j := tablo.Add(TCell.Create(i,0));
          TCell(tablo[j]).busy := (i > nbrjou.Field.AsInteger);
        end;
      { prépare la liste de cellules }
      tablo.build(_tab.FieldByName('taille').AsInteger);
      { peuple la liste de cellules }
      build(tablo, aleatoireBox.Checked);
    finally
      Screen.Cursor := crDefault;
    end;
  finally
    for i := 0 to Pred(tablo.Count) do
      TCell(tablo.Items[i]).Free;
    tablo.Free;
  end;
  _prp.Refresh;
  _tablo.Refresh;
  ActivateTabSheet(PreparationPageControl, DrawSheet);
end;

procedure TtournamentW.tabloGridDblClick(Sender: TObject);
var
  x: TZReadOnlyQuery;
begin
  inherited;
  x := getROQuery(pvCnx);
  try
    x.SQL.Add('SELECT licence,nomjou,libclb,codcls,serjou,codclb,serprp,serblo,vrbrgl'
             +' FROM prptab'
             +' WHERE sertab = ' + sertab.Field.AsString
             +'   and serblo is null'
             +'   and serjou > 0'
             +' order by 3,2');
    // afficher la grille dans une fenêtre détachée
    with TtabloW.Create(Self,pvCnx, _tab.FieldByName('sertab').AsInteger,
                             _cat.FieldByName('codcat').AsString,
                             _tab.FieldByName('taille').AsInteger,
                             _tab.FieldByName('nbrjou').AsInteger,
                             _tab.FieldByName('nbrtds').AsInteger) do
    begin
      try
        tabloSource.DataSet := Self._tablo;
        joueursSource.DataSet := x;
        x.Open;
        ShowModal;
      finally
        Free;
      end;
    end;
  finally
    x.Close;
    x.Free;
  end;
end;

procedure TtournamentW.tabloGridTitleClick(Column: TColumn);
begin
  inherited;
  orderByColumn(TZQuery(Column.Grid.DataSource.DataSet),Column,'ASC');
end;

procedure TtournamentW.SeedActionExecute(Sender: TObject);
begin
  inherited;
  _clscat.First;
  with TSeedsW.Create(Self,pvCnx, sertab.Field.AsInteger, _clscat.FieldByName('codcls').AsString, nbrtds.Field.AsInteger) do
  begin
    try
      ShowModal;
      if dts.DataSet.Active then
        dts.DataSet.Close;
      updateTDS(sertab.Field.AsInteger, tempTableName);
    finally
      Free;
    end;
  end;
  _prp.Refresh;
end;

procedure TtournamentW.tournamentNavClick(Sender: TObject;
  Button: TNavigateBtn);
begin
  inherited;
  dattrn.SetFocus;
end;

procedure TtournamentW.tournamentSourceDataChange(Sender: TObject;
  Field: TField);
var
  dgw: TdataGridW;
  z: TZReadOnlyQuery;
begin
  inherited;
  if Field = tournamentSource.DataSet.FieldByName('codclb') then
  begin
    z := getROQuery(pvCnx);
    with z do
    begin
      try
        SQL.Add('SELECT codclb, libclb FROM club'
               +' WHERE codclb LIKE :codclb');
        Params[0].AsString := Field.AsString;
        Open;
        if not Eof then
        begin
          tournamentSource.DataSet.FieldByName('organisateur').AsString := FieldByName('libclb').AsString;
          tournamentSource.DataSet.FieldByName('expcol').AsString       := Field.AsString;
        end
        else
        begin
          Close;
          Params[0].AsString := Field.AsString + '%';
          Open;
          if not Eof then
          begin
            dgw := TdataGridW.Create(Self);
            try
              dgw.source.DataSet := z;
              dgw.ShowModal;
            finally
              dgw.Free;
            end;
            Field.AsString := z.FieldByName('codclb').AsString;
          end
          else
            raise Exception.Create('Problème avec la table CLUB ?');
        end;
      finally
        Free;
      end;
    end;
  end
end;

procedure TtournamentW.umpiresActionExecute(Sender: TObject);
var
  z: TZQuery;
begin
  inherited;
  z := getQuery(pvCnx);
  try
    z.SQL.Add('SELECT * FROM umpires'
             +' WHERE sertrn = ' + sertrn.Field.AsString
             +' ORDER BY numtbl');
    with TdataGridW.Create(Self,nil) do
    begin
      try
        source.DataSet := z;
        z.Open;
        ShowModal;
      finally
        z.Close;
        Free;
      end;
    end;
  finally
    z.Free;
  end;
end;

procedure TtournamentW.updateTableau(sertab: integer);
var
  x,z: TZReadOnlyQuery;
  hdc: boolean;
begin
  z := getROQuery(pvCnx);
  try
    x := getROQuery(pvCnx);
    try
      x.SQL.Add('SELECT handicap FROM categories WHERE sercat = :sercat');
      x.ParamByName('sercat').AsInteger := sertab;
      x.Open;
      hdc := not(x.IsEmpty) and (x.Fields[0].AsString = '1');
      x.Close;
      x.SQL.Clear;
      x.SQL.Add('SELECT COUNT( * ) FROM insc WHERE sercat = :sertab');
      x.ParamByName('sertab').AsInteger := sertab;
      x.Open;

      z.SQL.Add('update tableau'
               +' set taille = :taille'
               +'    ,nbrjou = :nbrjou'
               +'    ,nbrtds = :nbrtds'
               +' WHERE sertab = :sertab');
      z.ParamByName('sertab').AsInteger := sertab;
      z.ParamByName('taille').AsInteger := getTailleTableau(x.Fields[0].AsInteger);
      z.ParamByName('nbrjou').AsInteger := x.Fields[0].AsInteger;
      if not hdc then
        z.ParamByName('nbrtds').AsInteger := z.ParamByName('taille').AsInteger div 8
      else
        z.ParamByName('nbrtds').AsInteger := 0;
      z.ExecSQL;
    finally
      x.Free;
    end;
  finally
    z.Free;
  end;
end;

procedure TtournamentW.updateTDS(const sertab: integer;
  const tempTableName: string);
var
  z,x: TZReadOnlyQuery;
begin
  z := getROQuery(pvCnx);
  try
    x := getROQuery(pvCnx);
    try
      z.SQL.Add(Format('SELECT serprp,numtds,newtds FROM %s',[tempTableName])
                      +' WHERE newtds < 9999');
      x.SQL.Add('update prptab set numtds = :newtds WHERE serprp = :serprp');
      x.Prepare;
      z.Open;
      pvCnx.startTransaction;
      try
        while not z.Eof do
        begin
          x.ParamByName('newtds').AsInteger := z.FieldByName('newtds').AsInteger;
          x.ParamByName('serprp').AsInteger := z.FieldByName('serprp').AsInteger;
          x.ExecSQL;
          z.Next;
          Application.ProcessMessages;
        end;
        pvCnx.commit;
      except
        pvCnx.rollback;
        raise;
      end;
      z.Close;
    finally
      x.Free;
    end;
  finally
    z.Free;
  end;
end;

function getInterval(taille, joueurs: integer): integer;
var
  i: integer;
begin
  if taille mod joueurs = 0 then
  begin
    if Joueurs = 1 then
      Result := taille div 2
    else
      Result := taille div joueurs;
  end
  else
  begin
    i := 0;
    Result := taille div joueurs;
    while Power(2,i) < Result do
      Inc(i);
    Result := Trunc(Power(2,i-1));
  end;
end;

procedure TtournamentW.build(tablo: TTablo; aleatoire: boolean);
var
  contnr: TObjectList;
  i, j, k, cc, first, last, passe, interval: integer;
  clubs,
  joueurs,
  itv,
  z,x,y,w: TZReadOnlyQuery;
  positions,rows: TStrings;
  c: TCell;
  jcls,
  jclb,
  th,
  tb,
  tab,
  p: TPoint;
  codcls,
  nomjou: string;
begin
  Memo1.Lines.Clear;
  //debug(StringOfChar('-',80));
  Randomize;
  contnr := TObjectList.Create(False);
  try
    { on crée les entrées du tablo }
    z := getROQuery(pvCnx,contnr);
    z.SQL.Add('INSERT INTO tablo(serblo,sertab,nomjou,numtds,numrow,sertrn) VALUES (:serblo,:sertab,:nomjou,:numtds,:numrow,:sertrn)');
    z.Prepare;
    z.ParamByName('sertab').AsInteger := sertab.Field.AsInteger;
    z.ParamByName('nomjou').AsString := 'BYE';
    z.ParamByName('sertrn').AsInteger := _sertrn;
    for i := 0 to Pred(tablo.Count) do
    begin
      z.ParamByName('serblo').AsInteger := pvSeq.SerialByName('categorie');
      z.ParamByName('numtds').AsInteger := Succ(i);
      z.ParamByName('numrow').AsInteger := TCell(tablo[i]).numrow;
      z.ExecSQL;
      Application.ProcessMessages;
    end;

    z.SQL.Clear;
    z.SQL.Add('update tablo set'
             +'    serjou  = :serjou'
             +'   ,licence = :licence'
             +'   ,nomjou  = :nomjou'
             +'   ,codclb  = :codclb'
             +'   ,libclb  = :libclb'
             +'   ,codcls  = :codcls'
             +'   ,vrbrgl  = :vrbrgl'
             +' WHERE numtds = :numtds'
             +'   and sertab = ' + sertab.Field.AsString);
    z.Prepare;

    x := getROQuery(pvCnx,contnr);
    y := getROQuery(pvCnx,contnr);
    joueurs := getROQuery(pvCnx, contnr);
    w := getROQuery(pvCnx,contnr);

    if not aleatoire then
    begin
      { on commence par placer toutes les têtes de série }
      joueurs.SQL.Add('SELECT serprp,licence,nomjou,codclb,libclb,codcls,numtds,seqcls,serjou,vrbrgl'
                     +' FROM prptab'
                     +' WHERE sertab = ' + sertab.Field.AsString
                     +'   and serjou > 0'
                     +'   and nomjou not like ' + QuotedStr('BYE')
                     +'   and numtds <= ' + nbrtds.Field.AsString
                     +' order by numtds');

      w.SQL.Add('SELECT serblo FROM tablo WHERE sertab = :sertab and numtds = :numtds');
      w.Prepare;
      w.ParamByName('sertab').AsInteger := sertab.Field.AsInteger;
      x.SQL.Add('update prptab set serblo = :serblo WHERE serprp = :serprp');
      x.Prepare;
      joueurs.Open;
      //debug('tds : ' + IntToStr(joueurs.RecordCount));
      while not joueurs.Eof do
      begin
        c := tablo.getByTDS(joueurs.FieldByName('numtds').AsInteger);
//        debug(c.asString);
        for i := 0 to Pred(z.Params.Count) do
          if joueurs.FindField(z.Params[i].Name) <> nil then
            z.Params[i].Value := joueurs.FieldByName(z.Params[i].Name).Value;
        z.ExecSQL;
        //debug(Format('%s %s %s %s',[z.ParamByName('licence').AsString,z.ParamByName('nomjou').AsString,z.ParamByName('codcls').AsString,z.ParamByName('libclb').AsString]));
        w.ParamByName('numtds').AsInteger := c.numtds;
        w.Open;
        x.ParamByName('serprp').AsInteger := joueurs.FieldByName('serprp').AsInteger;
        x.ParamByName('serblo').AsInteger := w.FieldByName('serblo').AsInteger;
        x.ExecSQL;
        //debug(Format('update ptptab set serblo = %s WHERE serprp = %s',[x.ParamByName('serblo').AsString,x.ParamByName('serprp').AsString]));
        w.Close;
        c.busy := True;
        joueurs.Next;
      end;
      joueurs.Close;
    end;
//        - d'une liste de clubs triés par nombre de joueurs par ordre décroissant
    clubs := getROQuery(pvCnx,contnr);
    clubs.SQL.Add('SELECT codclb, COUNT(* ) nbrjou, rand() random'
                 +'  ,(SELECT COUNT(*) FROM prptab b WHERE sertab = :sertab'
                 +'                          and a.codclb = b.codclb) countall'
                 +'  FROM prptab a'
                 +' WHERE sertab = :sertab'
                 +'   and codclb not like ' + QuotedStr('')
                 +'   and coalesce(serblo,0) = 0'
                 +' group by 1,3,4'
                 +' order by countall desc, random');
    clubs.ParamByName('sertab').AsInteger := sertab.Field.AsInteger;

//        - d'une liste des joueurs d'un club classés par classement ordre croissant
    joueurs.SQL.Clear;
    joueurs.SQL.Add('SELECT serprp,licence,nomjou,codclb,libclb,codcls,seqcls,serjou,vrbrgl,rand()'
                   +' FROM prptab'
                   +' WHERE sertab = ' + sertab.Field.AsString
                   +'   and codclb = :codclb'
                   +'   and serblo is null');
    if not aleatoire then
      joueurs.SQL.Add(' order by seqcls,vrbrgl')
    else
      joueurs.SQL.Add(' order by 10');


    joueurs.Prepare;

    itv := getROQuery(pvCnx,contnr);
    itv.SQL.Add('SELECT COUNT(* ) mieux_classes'
               +'  ,(SELECT COUNT(* ) FROM prptab WHERE sertab = :sertab and seqcls = :seqcls and coalesce(serjou,0) > 0) pareils'
               +'  ,(SELECT COUNT(* ) FROM prptab WHERE sertab = :sertab and seqcls = :seqcls and coalesce(serjou,0) > 0) moins_classes'
               +' FROM prptab'
               +' WHERE sertab = ' + sertab.Field.AsString
               +'   and coalesce(serjou,0) > 0'
               +'   and seqcls < :seqcls');
    itv.Prepare;
    itv.ParamByName('sertab').AsInteger := sertab.Field.AsInteger;

    { bornes des dem-tableaux }
    th.X := 1;
    th.Y := taille.Field.AsInteger div 2;
    tb.X := Succ(th.Y);
    tb.Y := taille.Field.AsInteger;

    positions := TStringList.Create;
    try
      clubs.Open;
      //debug('clubs.open : ' + IntToStr(clubs.RecordCount));
      while not clubs.Eof do
      begin
        debug(clubs.FieldByName('codclb').AsString);
        joueurs.ParamByName('codclb').AsString := clubs.FieldByName('codclb').AsString;
        joueurs.Open;
        debug('joueurs.open : ' + IntToStr(joueurs.RecordCount));
        { quel interval minimum entre 2 joueurs d'un même club }
        interval := getInterval(taille.Field.AsInteger,clubs.FieldByName('countall').AsInteger);
        debug(Format('intervalle minimum entre 2 joueurs du club = %d',[j]));

        while not joueurs.Eof do
        begin
          c := nil;
          codcls := joueurs.FieldByName('codcls').AsString;
          nomjou := joueurs.FieldByName('nomjou').AsString;
          debug(Format('%s %s', [codcls,nomjou]));
          { définir le demi-tableau }
          { combien de joueurs de ce classement dans les demi-tableaux }
          x.SQL.Clear;
          x.SQL.Add('SELECT COUNT( * ) tabh'
                   +'  ,(SELECT COUNT( * ) FROM tablo WHERE sertab = :sertab'
                   +'      and codcls = :codcls'
                   +'      and numrow between :tbx and :tby) tabb'
                   +' FROM tablo'
                   +' WHERE sertab = :sertab'
                   +'   and codcls = :codcls'
                   +'   and numrow between 1 and :thy');
          x.ParamByName('sertab').AsInteger := sertab.Field.AsInteger;
          x.ParamByName('codcls').AsString := joueurs.FieldByName('codcls').AsString;
          x.ParamByName('tbx').AsInteger := tb.X;
          x.ParamByName('tby').AsInteger := tb.Y;
          x.ParamByName('thy').AsInteger := th.Y;
          x.Open;
          jcls.X := x.FieldByName('tabh').AsInteger;
          jcls.Y := x.FieldByName('tabb').AsInteger;
          x.Close;
          debug(format('Joueurs classés %s dans les demi-tableaux : jcls.x=%d jcls.y=%d',[joueurs.FieldByName('codcls').AsString,jcls.X,jcls.y]));
          { combien de joueurs du club dans les demi-tableaux }
          y.SQL.Clear;
          y.SQL.Add('SELECT COUNT( * ) tabh'
                   +'  ,(SELECT COUNT( * ) FROM tablo WHERE sertab = :sertab'
                   +'      and codclb = :codclb'
                   +'      and numrow between :tbx and :tby) tabb'
                   +' FROM tablo'
                   +' WHERE sertab = :sertab'
                   +'   and codclb = :codclb'
                   +'   and numrow between 1 and :thy');
          y.ParamByName('sertab').AsInteger := sertab.Field.AsInteger;
          y.ParamByName('codclb').AsString := joueurs.FieldByName('codclb').AsString;
          y.ParamByName('tbx').AsInteger := tb.X;
          y.ParamByName('tby').AsInteger := tb.Y;
          y.ParamByName('thy').AsInteger := th.Y;
          y.Open;
          jclb.X := y.FieldByName('tabh').AsInteger;
          jclb.Y := y.FieldByName('tabb').AsInteger;
          y.Close;
          debug(format('Joueurs du club %s dans les demi-tableaux : jclb.x=%d lclb.y=%d',[joueurs.FieldByName('codclb').AsString,jclb.X,jclb.y]));

          //debug('Choix du demi-tableau');
          tab.X := 0; tab.Y := 0;
          { si moins de joueurs du classement en haut }
          if not(aleatoire) and (jcls.X < jcls.Y) then
          begin
            tab := th;  // on prend le tableau du haut
            //debug('moins de joueurs classés en haut, on choisit le tableau du haut th');
          end
          { sinon si moins de joueurs en bas }
          else if not(aleatoire) and (jcls.X > jcls.Y) then
          begin
            tab := tb;
            //debug('Plus de joueurs classés en haut, on choisit le tableau du bas tb');
          end
          else      // égalité
          begin
            if not aleatoire then
              debug('il y a autant de classées en haut qu''en bas, on détermine selon les joueurs du club')
            else
              debug('aléatoire, choix en plaçant uniformément les joueurs du club');
            // si moins de joueurs du club en haut
            if jclb.X < jclb.Y then
            begin
              tab := th;
              //debug('moins de joueurs du club en haut, on choisit le tableau du haut th');
            end
              // sinon si moins de joueurs du club en bas
            else if jclb.X > jclb.Y then
            begin
              tab := tb;
              //debug('Plus de joueurs du club en haut, on choisit le tableau du bas tb');
            end
            else   // égalité
            begin
              { on choisit l'autre moitiéé de tableau du joueur le mieux classé }
              w.SQL.Clear;
              w.SQL.Add('SELECT min(numtds) FROM tablo'
                       +' WHERE sertab = :sertab'
                       +'   and codclb = :codclb');
              w.ParamByName('sertab').AsInteger := sertab.Field.AsInteger;
              w.ParamByName('codclb').AsString := joueurs.ParamByName('codclb').AsString;
              w.Open;
              if (w.Fields[0].AsInteger > 0) then
              begin
                if w.Fields[0].AsInteger <= tablo.taille div 2 then
                  tab := tb
                else
                  tab := th;
                w.Close;
              end
              else
              begin
                debug('il y a autant de joueurs du club en haut qu''en bas, on détermine par le nombre total de joueurs');
                { combien de joueurs dans les demi-tableaux }
                w.SQL.Clear;
                w.SQL.Add('SELECT COUNT( * ) tabh'
                         +'  ,(SELECT COUNT( * ) FROM tablo WHERE sertab = :sertab'
                         +'      and numrow between :tbx and :tby'
                         +'      and coalesce(serjou,0) > 0) tabb'
                         +' FROM tablo'
                         +' WHERE sertab = :sertab'
                         +'   and numrow between 1 and :thy'
                         +'   and coalesce(serjou,0) > 0');
                w.ParamByName('sertab').AsInteger := sertab.Field.AsInteger;
                w.ParamByName('tbx').AsInteger := tb.X;
                w.ParamByName('tby').AsInteger := tb.Y;
                w.ParamByName('thy').AsInteger := th.Y;
                w.Open;
                debug(format('demi tableau du haut (%d-%d) : %d joueurs',[th.x,th.y,w.FieldByName('tabh').AsInteger]));
                debug(format('demi tableau du bas  (%d-%d) : %d joueurs',[tb.x,tb.y,w.FieldByName('tabb').AsInteger]));
                // si moins de joueurs en haut
                if w.FieldByName('tabh').AsInteger < w.FieldByName('tabb').AsInteger then
                begin
                  tab := th;
                  //debug('on choisit th');
                end
                  // sinon si moins de joueurs en bas
                else if w.FieldByName('tabh').AsInteger > w.FieldByName('tabb').AsInteger then
                begin
                  tab := tb;
                  //debug('on choisit tb');
                end
                else
                begin
                  i := Random(1);
                  debug('random(1)='+IntToStr(i));
                  if i = 0 then
                    tab := th
                  else
                    tab := tb;
                  debug(format('Random -> tab.x = %d, tab.y = %d', [tab.X, tab.y]));
                end;
                w.Close;
              end;
            end;
          end;
          debug(format('Le demi-tableau sélectionné est tab.x=%d tab.y=%d',[tab.X,tab.y]));
          rows := TStringList.Create;
          try
            for passe := 1 to 2 do
            begin
              rows.Clear;
              debug(Format('passe=%d',[passe]));
              { places disponibles du demi-tableau }
              x.SQL.Clear;
              x.SQL.Add('SELECT codclb FROM tablo WHERE sertab = ' + sertab.Field.AsString
                       +' and numrow = :numrow');
              x.Prepare;
              { parcourir tablo }
              debug(format('on parcourt le demi-tableau %d-%d par sous-tableaux de %d positions',[tab.X,tab.Y,interval]));
              cc := 0; k := 0; first := 0; positions.Clear;
              for i := tab.X to tab.y do
              begin
                //debug(format('i = %d', [i]));
                Inc(k);
                //debug(format('index k de sous-tableau = %d', [k]));
                if first = 0 then
                begin
                  first := i;
                  //debug(format('first = %d', [first]));
                end;
                last := i;
                //debug(format('last = %d', [last]));

                x.ParamByName('numrow').AsInteger := i;
                x.Open;
                //debug(Format('Le code club de la position %d est %s',[i, x.Fields[0].AsString]));
                if x.Fields[0].AsString = '' then
                  rows.Add(IntToStr(i))
                else
                if x.Fields[0].AsString = clubs.FieldByName('codclb').AsString then
                begin
                  Inc(cc);
                  debug(Format('numrow %d est indisponible car joueur du même club : %s -> sortie du sous-tableau',[i,x.Fields[0].AsString]));
                  //Break;
                end
                else
                if x.Fields[0].AsString <> '' then
                begin
//                  Inc(cc);
                  debug(Format('numrow %d est indisponible car joueur d''un autre club : %s',[i,x.Fields[0].AsString]));
                end;

                //debug(format('combien de cellules de même club dans l''intervalle %d-%d : %d',[first,last,cc]));
                x.Close;
                { on a parcouru j cellules interval minimum entre 2 joueurs du club }
                if k = interval then
                begin
                  debug(format('on a parcouru tout le sous-tableau %d-%d. Les numrow disponibles sont %s',[first,last,rows.CommaText]));
                  { il n'y a pas de joueur du club placé, on ajoute les positions entre first et last libres à la liste }
                  if cc = 0 then
                  begin
                    //debug('cc = 0');
                    //debug(format('for k := first(%d) to last(%d)',[first,last]));
                    for k := first to last do
                    begin
                      c := tablo.getByRow(k);
                      //debug(format('c := tablo.getByRow(%d)',[k]));
                      //debug(c.asString);
                      if not c.busy then
                      begin
                        positions.Add(IntToStr(c.numrow));
                        //debug(format('positions.add(%d)',[c.numrow]));
                      end;
                    end;
                  end
                  else
                  begin
                    debug(format('cc <> 0 : %d, un joueur du club est déjà placé dans cet intervalle',[cc]));
                  end;
                  { on reset les variables de comptage }
                  k := 0;
                  cc := 0;
                  first := 0;
                  c := nil;
                  //debug('reset vars k,cc,first,c');
                end;
              end; { for i := tab.X to tab.y do }

              if positions.Count = 0 then
              begin
                if passe = 1 then
                begin
                  debug('pas de position, seconde passe');
                  debug(format('1ère passe -> tab.x = %d, tab.y = %', [tab.X,tab.Y]));
                  if tab = th then
                    tab := tb
                  else
                    tab := th;
                end
                else
                  debug('aucune position trouvée dans la seconde passe.');
              end
              else
              begin
                debug(format('%d positions trouvées, on sort de la passe %d',[positions.COUNT,passe]));
                Break;
              end;
            end; { for passe := 1 to 2 do }
          finally
            rows.Free;
          end;


          { choisir la place }
          debug(format('positions.COUNT=%d',[positions.Count]));
          debug(positions.CommaText);
          if positions.Count > 0 then
          begin
            if not aleatoire then
            begin
              { on essaye de prendre la position la plus proche possible selon
                le classement et la ranglëscht du joueur }
              w.SQL.Clear;
              w.SQL.Add('SELECT COUNT( * ) FROM prptab'
                       +' WHERE sertab = :sertab'
                       +'   and seqcls <= :seqcls'
                       +'   and vrbrgl <= :vrbrgl'
                       +'   and coalesce(serjou,0) > 0');
              w.ParamByName('sertab').AsInteger := sertab.Field.AsInteger;
              w.ParamByName('seqcls').AsInteger := joueurs.FieldByName('seqcls').AsInteger;
              w.ParamByName('vrbrgl').AsInteger := joueurs.FieldByName('vrbrgl').AsInteger;
              w.Open;
              k := w.Fields[0].AsInteger;
              debug(format('position du joueur dans la ranglëscht : %d',[k]));
              w.Close;
              { rechercher parmi les positions celle dont la tds se rapproche le plus de k }
              p.X := 0;
              p.Y := 999;
              for i := 0 to Pred(positions.Count) do
              begin
                c := tablo.getByRow(StrToInt(positions[i]));
                if c <> nil then
                begin
                  if c.numtds = k then
                  begin
                    debug('ranglëscht du joueur disponible : ' + c.asString);
                    Break;
                  end
                  else
                  begin
                    if c.numtds < k then
                    begin
                      if p.X < c.numtds then
                        p.X := c.numtds;
                    end
                    else
                    begin
                      if p.Y > c.numtds then
                        p.Y := c.numtds;
                    end;
                    c := nil;
                    debug(format('p.x = %d, p.y = %d',[p.X,p.y]));
                  end;
                end;
              end;
              if c = nil then
              begin
                if p.X > 0 then
                  c := tablo.getByTDS(p.x)
                else
                  c := tablo.getByTDS(p.y);
                debug('utilisation de c : ' + c.asString);
              end;
            end
            else
            begin
              k := Random(positions.Count);
              debug(format('random(%d)=%d',[positions.Count,k]));
              c := tablo.getByRow(StrToInt(positions[k]));
              debug('tablo.getByRow(StrToInt(positions[k])) -> ' + c.asString);
            end;
          end;

          if Assigned(c) then
          begin
            debug('c is assigned : ' + c.asString);
            for i := 0 to Pred(z.Params.Count) do
              if joueurs.FindField(z.Params[i].Name) <> nil then
                z.Params[i].Value := joueurs.FieldByName(z.Params[i].Name).Value;
            z.ParamByName('numtds').AsInteger := c.numtds;
            z.ExecSQL;
            c.busy := True;
            w.SQL.Clear;
            w.SQL.Add('SELECT serblo FROM tablo WHERE sertab = :sertab and numtds = :numtds');
            w.Prepare;
            w.ParamByName('sertab').AsInteger := sertab.Field.AsInteger;
            x.SQL.Clear;
            x := getROQuery(pvCnx,contnr);
            x.SQL.Add('update prptab set serblo = :serblo WHERE serprp = :serprp');
            x.Prepare;
            w.ParamByName('numtds').AsInteger := c.numtds;
            w.Open;
            x.ParamByName('serprp').AsInteger := joueurs.FieldByName('serprp').AsInteger;
            x.ParamByName('serblo').AsInteger := w.FieldByName('serblo').AsInteger;
            x.ExecSQL;
            w.Close;
          end
          else
            debug(Format('KO -> %s %s %s',[joueurs.FieldByName('libclb').AsString,joueurs.FieldByName('nomjou').AsString,joueurs.FieldByName('codcls').AsString]));
          debug(StringOfChar('=',80));
          { }

          joueurs.Next;
          Application.ProcessMessages;
        end;
        joueurs.Close;
        clubs.Next;
        Application.ProcessMessages;
      end;
      clubs.Close;
      { maj de categories.stacat }
      CheckAndSetCategorieStatusAfterUpdate(sertab.Field.AsInteger);
//      stacat(sertab.Field.AsInteger,csDraw);
      catSource.DataSet.Refresh;
      catSource.DataSet.Locate('sercat',sertab.Field.Value,[]);
    finally
      positions.Free;
    end;
    { contrôler la validité }
    z.SQL.Clear;
    z.SQL.Add('SELECT COUNT(* ) FROM tablo'
             +' WHERE sertab = ' + sertab.Field.AsString
             +'   and coalesce(serjou,0) > 0');
    z.Open;
    if z.Fields[0].AsInteger < nbrjou.Field.AsInteger then
    begin
      x.SQL.Clear;
      x.SQL.Add('SELECT licence,nomjou,libclb,codcls,vrbrgl,serjou,codclb,serprp,serblo,sertab'
               +' FROM prptab'
               +' WHERE sertab = ' + sertab.Field.AsString
               +'   and serblo is null'
               +'   and serjou > 0'
               +' order by 3,2');
      y.SQL.Clear;
      y.SQL.Add('SELECT numrow,numtds,licence,nomjou,libclb,codcls,serblo'
               +' FROM tablo'
               +' WHERE sertab = ' + sertab.Field.AsString
               +' order by 1');
      y.Open;
      with TjoueursNonPlacesW.Create(Self,pvCnx, sertab.Field.AsInteger) do
      begin
        try
          nbrjou := Self.nbrjou.Field.AsInteger;
          joueursSource.DataSet := x;
          x.Open;
          positionsSource.DataSet := y;
          y.Open;
          Caption := Self.catSource.DataSet.FieldByName('codcat').AsString;
          ShowModal;
          Self.tabloGrid.DataSource.DataSet.Refresh;
        finally
          Free;
        end;
      end;
    end;
  finally
    for i := 0 to contnr.Count-1 do
      freeROQuerys([TZReadOnlyQuery(contnr[i])]);
    contnr.Free;
  end;
  (*
  memo1.Lines.BeginUpdate;
  memo1.Lines.AddStrings(_debug);
  memo1.Lines.EndUpdate;
  _debug.Clear;
  *)
end;

procedure TtournamentW.byeButtonClick(Sender: TObject);
var
  z: TZReadOnlyQuery;
  m: TGame;
begin
  inherited;
  z := getROQuery(pvCnx);
  try
    Screen.Cursor := crSQLWait;
    z.SQL.Add('SELECT sermtc'
             +' FROM match'
             +' WHERE sertab = :sertab'
             +'   and ((serjo1 = 0 AND serjo2 > 0) OR (serjo1 > 0 AND serjo2 = 0))'
             +'   or  (serjo1 = 0 AND serjo2 = 0)'
             +'   and stamtc = 0'
             +'   and level = 1');
    z.ParamByName('sertab').AsInteger := _mtclv1.ParamByName('sertab').AsInteger;
    z.Open;
    pvCnx.startTransaction;
    try
      while not z.Eof do
      begin
        m := TGame.Create(Self,pvCnx,z.Fields[0].AsInteger);
        try
          m.write;
        finally
          m.Free;
        end;
        z.Next;
        Application.ProcessMessages;
      end;
      z.Close;
      pvCnx.commit;
    except
      pvCnx.rollback;
      raise;
    end;
  finally
    z.Free;
    Screen.Cursor := crDefault;
  end;
  _mtclv1.Refresh;
end;

procedure TtournamentW.ActionsListUpdate(Action: TBasicAction;
  var Handled: Boolean);
var
  cat: TDataset;
  active: boolean;
  stacat: TCategorysStatus;
begin
  inherited;
  DisplayTableauAction.Enabled := (_tournament.Active) and (not _tournament.Eof);
  if DisplayTableauAction.Enabled then
  begin
    cat := catSource.DataSet;
    active := cat.Active and not(cat.IsEmpty);
    stacat := csInactive;
    if active then
       stacat := TCategorysStatus(cat.FieldByName('stacat').AsInteger);
    if active then
    begin
      ResetAction.Enabled := (stacat > csInactive) and (stacat < csInProgress);// or IsDebuggerPresent;
      PrepareAction.Enabled := stacat = csInactive;
      SetCategStatutAction.Enabled := not cat.IsEmpty;
      SetPhaseAction.Enabled := stacat <= csPrepared;
      SetFirstRoundModeAction.Enabled := stacat <= csPrepared;
    end;

    if active and (cat.FieldByName('phase').AsInteger = Ord(frKO)) then
    begin
      autoDrawAction.Enabled := stacat = csPrepared;
      manualDrawAction.Enabled := stacat = csPrepared;
      SetGroupsAction.Enabled := False;
      SeedAction.Enabled := (stacat = csPrepared) and (cat.FieldByName('handicap').AsInteger = 0);
      GenerateGroupGamesAction.Enabled := False;
      GenerateDrawGamesAction.Enabled := stacat = csDraw;
      SetGroupsAction.Enabled := False;
      Swap2PlayersAction.Enabled := False;
      PrepareForKOPhaseAction.Enabled := False;
    end
    else if active and (cat.FieldByName('phase').AsInteger = Ord(frQualification)) then
    begin
      autoDrawAction.Enabled := False;
      manualDrawAction.Enabled := False;
      SeedAction.Enabled := (stacat = csPrepared);
      SetGroupsAction.Enabled := (stacat = csPrepared);
      PrepareForKOPhaseAction.Enabled := True;
      if _tab.FindField('nbrgrp') <> nil then
      begin
        GenerateGroupGamesAction.Enabled := (stacat = csGroup) and (GetQualificationsGroupStatusCount(cat.FieldByName('sercat').AsInteger, qgsValidated) = _tab.FieldByName('nbrgrp').AsInteger);
        Swap2PlayersAction.Enabled := (stacat = csGroup) and not(GenerateGroupGamesAction.Enabled);
      end
      else
      begin
        GenerateGroupGamesAction.Enabled := False;
        Swap2PlayersAction.Enabled := False;
      end;
    end;
    addAPlayerAction.Enabled := False;
    aleatoireBox.Enabled := active and (stacat = csPrepared) and (cat.FieldByName('handicap').AsInteger = 1);
    SeekConfigAction.Enabled := (ActiveControl = codclb) or (ActiveControl = saison);
    SelectSeekCodClbAction.Enabled := (ActiveControl = codclb);
    SelectSeekSaisonAction.Enabled := (ActiveControl = saison);
  end;
  Handled := True;
end;

function TtournamentW.GetQualificationsGroupStatusCount(const sercat: integer;
  const qgs: TQualificationGroupStatus): integer;
begin
  if (pvStagrp.Active) and (pvStagrp.Params[0].AsInteger = sercat)
                       and (pvStagrp.Params[1].AsInteger = Ord(qgs)) then
    pvStagrp.Refresh
  else
  begin
    pvStagrp.Close;
    pvStagrp.Params[0].AsInteger := sercat;
    pvStagrp.Params[1].AsInteger := Ord(qgs);
    pvStagrp.Open;
  end;
  Result := pvStagrp.Fields[0].AsInteger;
end;

procedure TtournamentW.ActivateTabSheet(PageControl: TPageControl; Sheet: TTabSheet);
begin
  if PageControl.ActivePageIndex <> Sheet.PageIndex then
    PageControl.ActivePageIndex := Sheet.PageIndex;
end;

procedure TtournamentW.addAPlayerActionExecute(Sender: TObject);
var
  z,x: TZReadOnlyQuery;
  serjou,numtds,taille,nbrjou: integer;
begin
  inherited;
  { permet d'ajouter un joueur à un tableau. Permet la sélection dans la liste
    des joueurs autorisés ou d'ajouter un nouveau joueur }
  with TaddAPlayerW.Create(Self, pvCnx, _sertrn,catSource.DataSet.FieldByName('sercat').AsInteger,maxcat.Field.AsInteger) do
  begin
    try
      if ShowModal = mrOk then
      begin
        pvCnx.startTransaction;
        try
          z := getROQuery(pvCnx);
          try
            z.SQL.Add('SELECT coalesce(max(serjou),0) FROM joueur'
                     +' WHERE licence = :licence'
                     +'   and codclb = :codclb'
                     +'   and codcls = :codcls'
                     +'   and saison = :saison');
            z.ParamByName('licence').AsString := licence.Text;
            z.ParamByName('codclb').AsString := codclb.Text;
            z.ParamByName('codcls').AsString := codcls.Text;
            z.ParamByName('saison').AsString := saison.Field.AsString;
            z.Open;
            serjou := z.Fields[0].AsInteger;
            z.Close;
            { joueur n'existe pas dans la base de données, on l'ajoute }
            if serjou = 0 then
            begin
              z.SQL.Clear;
              z.SQL.Add('INSERT INTO joueur (serjou,saison,licence,codclb,nomjou,codcls,topcls,topdem,datann,catage,vrbrgl)'
                       +' VALUES '
                       +'(:serjou,:saison,:licence,:codclb,:nomjou,:codcls,:topcls,:topdem,:datann,:catage,:vrbrgl)');
              z.ParamByName('serjou').AsInteger := pvSeq.SerialByName('joueur');
              z.ParamByName('saison').AsInteger := Self.saison.Field.AsInteger;
              z.ParamByName('licence').AsString := licence.Text;
              z.ParamByName('codclb').AsString := codclb.Text;
              z.ParamByName('nomjou').AsString := nom.Text;
              z.ParamByName('codcls').AsString := codcls.Text;
              z.ParamByName('topcls').AsString := codcls.Text;
              z.ParamByName('topdem').AsString := codcls.Text;
              z.ParamByName('datann').AsDateTime := datnss.DateTime;
              z.ParamByName('catage').AsString := getCatage(datnss.DateTime,Self.saison.Field.AsInteger);
              z.ParamByName('vrbrgl').AsString := vrbrgl.Text;
              z.ExecSQL;
              serjou := z.ParamByName('serjou').AsInteger;
            end;
            { inscription dans la catégorie }
            z.SQL.Clear;
            z.SQL.Add('INSERT INTO insc (serinsc,sercat,datinsc,simple,serjou,serptn,statut,sertrn)'
                     +' VALUES '
                     +'(:serinsc,:sercat,:datinsc,:simple,:serjou,:serptn,:statut,:sertrn)');
            z.ParamByName('serinsc').AsInteger := pvSeq.SerialByName('inscription');
            z.ParamByName('sercat').AsInteger := sercat;
            z.ParamByName('datinsc').AsDateTime := Now;
            z.ParamByName('simple').AsString := Self.catSource.DataSet.FieldByName('simple').AsString;
            z.ParamByName('serjou').AsInteger := serjou;
            z.ParamByName('statut').AsString := '1';
            z.ParamByName('sertrn').AsInteger := sertrn;
            z.ExecSQL;

            { Mettre à jour la table tableau (taille,nbrjou,nbrtds) }
            updateTableau(sercat);

            { Si le tableau a été préparé, ajouter l'entrée en fin de tableau.
              Que fait-on si la taille du tableau change ?
            }
            z.SQL.Clear;
            z.SQL.Add('SELECT COUNT(*) tableau'
                     +'  ,(SELECT COUNT(*) FROM prptab WHERE sertab = :sertab and coalesce(serjou,0) > 0) joueurs'
                     +' FROM prptab WHERE sertab = :sertab');
            z.ParamByName('sertab').AsInteger := sercat;
            z.Open;
            if z.Fields[0].AsInteger > 0 then
            begin
              { tableau pas complet, on ajoute l'entrée en première position libre }
              if (Succ(z.FieldByName('joueurs').AsInteger) <= z.FieldByName('tableau').AsInteger) then
              begin
                numtds := Succ(z.FieldByName('joueurs').AsInteger);
                z.Close;
                z.SQL.Clear;
                z.SQL.Add('SELECT serprp FROM prptab WHERE sertab = ' + IntToStr(sercat)
                         +'  and numtds = ' + IntToStr(numtds));
                z.Open;
                numtds := z.Fields[0].AsInteger;   // serprp, pas numtds
                z.Close;
                z.SQL.Clear;
                z.SQL.Add('update prptab'
                         +'  set serjou = ' + IntToStr(serjou)
                         +'     ,licence = :licence'
                         +'     ,nomjou = :nomjou'
                         +'     ,codclb = :codclb'
                         +'     ,codcls = :codcls'
                         +'     ,classement = :codcls'
                         +'     ,libclb = :libclb'
                         +'     ,seqcls = :seqcls'
                         +' WHERE serprp = ' + IntToStr(numtds));
                x := getROQuery(pvCnx);
                try
                  x.SQL.Add('SELECT licence,nomjou,a.codclb,libclb,a.codcls,numseq seqcls'
                           +' FROM joueur a INNER JOIN club b ON a.codclb = b.codclb'
                           +'               INNER JOIN classement c ON a.codcls = c.codcls'
                           +' WHERE a.serjou = ' + IntToStr(serjou));
                  x.Open;
                  if not x.IsEmpty then
                  begin
                    z.ParamByName('licence').AsString := x.FieldByName('licence').AsString;
                    z.ParamByName('nomjou').AsString := x.FieldByName('nomjou').AsString;
                    z.ParamByName('codclb').AsString := x.FieldByName('codclb').AsString;
                    z.ParamByName('codcls').AsString := x.FieldByName('codcls').AsString;
                    z.ParamByName('libclb').AsString := x.FieldByName('libclb').AsString;
                    z.ParamByName('seqcls').AsInteger := x.FieldByName('seqcls').AsInteger;
                    z.ExecSQL;
                  end;
                  x.Close;
                finally
                  x.Free;
                end;
              end
              else
              { on doit passer à un tableau de taille supérieure }
              begin
                z.Close;
                z.SQL.Clear;
                z.SQL.Add('SELECT taille,nbrjou FROM tableau'
                         +' WHERE sertab = :sertab');
                z.ParamByName('sertab').AsInteger := sercat;
                z.Open;
                taille := z.FieldByName('taille').AsInteger;
                nbrjou := z.FieldByName('nbrjou').AsInteger;

                z.Close;
                z.SQL.Clear;
                z.SQL.Add('INSERT INTO prptab (sertab,serprp,serjou,serptn,licence,nomjou'
                          +'  ,seqcls,codclb,libclb,codcls,classement,vrbrgl,numtds,sertrn)'
                         +' VALUES '
                         +'(:sertab,:serprp,:serjou,:serptn,:licence,:nomjou,:seqcls'
                         +'   ,:codclb,:libclb,:codcls,:classement,:vrbrgl,:numtds,:sertrn)');
                z.Prepare;
                z.ParamByName('sertab').AsInteger := sercat;
                z.ParamByName('sertrn').AsInteger := sertrn;
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
                { création des cellules vides "BYE" }
                for numtds := nbrjou to taille do
                begin
                  z.ParamByName('serprp').AsInteger := pvSeq.SerialByName('categorie');
                  z.ParamByName('numtds').AsInteger := numtds;
                  z.ExecSQL;
                end;
                { ajout du joueur }
                numtds := nbrjou;
                z.Close;
                z.SQL.Clear;
                z.SQL.Add('SELECT serprp FROM prptab WHERE sertab = ' + IntToStr(sercat)
                         +'  and numtds = ' + IntToStr(numtds));
                z.Open;
                numtds := z.Fields[0].AsInteger;   // serprp, pas numtds
                z.Close;
                z.SQL.Clear;
                z.SQL.Add('update prptab'
                         +'  set serjou = ' + IntToStr(serjou)
                         +'     ,licence = :licence'
                         +'     ,nomjou = :nomjou'
                         +'     ,codclb = :codclb'
                         +'     ,codcls = :codcls'
                         +'     ,classement = :codcls'
                         +'     ,libclb = :libclb'
                         +'     ,seqcls = :seqcls'
                         +' WHERE serprp = ' + IntToStr(numtds));
                x := getROQuery(pvCnx);
                try
                  x.SQL.Add('SELECT licence,nomjou,a.codclb,libclb,a.codcls,numseq seqcls'
                           +' FROM joueur a INNER JOIN club b ON a.codclb = b.codclb'
                           +'               INNER JOIN classement c ON a.codcls = c.codcls'
                           +' WHERE a.serjou = ' + IntToStr(serjou));
                  x.Open;
                  if not x.IsEmpty then
                  begin
                    z.ParamByName('licence').AsString := x.FieldByName('licence').AsString;
                    z.ParamByName('nomjou').AsString := x.FieldByName('nomjou').AsString;
                    z.ParamByName('codclb').AsString := x.FieldByName('codclb').AsString;
                    z.ParamByName('codcls').AsString := x.FieldByName('codcls').AsString;
                    z.ParamByName('libclb').AsString := x.FieldByName('libclb').AsString;
                    z.ParamByName('seqcls').AsInteger := x.FieldByName('seqcls').AsInteger;
                    z.ExecSQL;
                  end;
                  x.Close;
                finally
                  x.Free;
                end;
              end;
            end;
            if z.Active then
              z.Close;
          finally
            z.Free;
          end;
          pvCnx.commit;
        except
          pvCnx.rollback;
          raise;
        end;
        Self.catSource.DataSet.Refresh;
        if Self.tabSource.DataSet.Active then Self.tabSource.DataSet.Refresh;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TtournamentW.checkMatchesLevel(const sertab, level: integer);
var
  ctn: TObjectList;
  lvl,
  prochain,
  upd,upl: TZReadOnlyQuery;
begin
  { naviguer les matchs du level
    quand un match est en cours (stamtc=0)
      si un des 2 joueurs est BYE
        si le prochain match n'est pas renseigné
          on maj le statut du match en cours
          on renseigne le prochain match
  }
  ctn := TObjectList.Create;
  try
    lvl := getROQuery(pvCnx,ctn);
    lvl.SQL.Add('SELECT sermtc,vainqueur,perdant,prochain,serjo1,serjo2,numseq'
               +' FROM match'
               +' WHERE sertab = :sertab'
               +'   and level = :level'
               +'   and stamtc < :stamtc'
               +' order by numseq');
    lvl.ParamByName('sertab').AsInteger := sertab;
    lvl.ParamByName('level').AsInteger := level;
    lvl.ParamByName('stamtc').AsInteger := Ord(gsOver);
    prochain := getROQuery(pvCnx,ctn);
    prochain.SQL.Add('SELECT sermtc FROM match'
                    +' WHERE sertab = :sertab'
                    +'   and level = :level'
                    +'   and numseq = :numseq');
    prochain.Prepare;
    prochain.ParamByName('sertab').AsInteger := sertab;
    prochain.ParamByName('level').AsInteger := level;

    upd := getROQuery(pvCnx,ctn);
    upd.SQL.Add('update match'
               +'   set serjo1 = :serjo1'
               +'      ,serjo2 = :serjo2'
               +'      ,handi1 = :handi1'
               +'      ,handi2 = :handi2'
               +' WHERE sermtc = :sermtc');
    upd.Prepare;

    upl := getROQuery(pvCnx,ctn);
    upl.SQL.Add('update match'
               +'   set stamtc = :stamtc'
               +' WHERE sermtc = :sermtc');
    upl.Prepare;

    lvl.Open;
    while not lvl.Eof do
    begin
      lvl.Next;
      Application.ProcessMessages;
    end;
    lvl.Close;
  finally
    ctn.Free;
  end;
end;

procedure TtournamentW.arenaView;
begin
  nilArenaView;

  if not Assigned(glArena15W) then
    glArena15W := Tarena15W.Create(Self,pvCnx,TTournament.Create(pvCnx, Self.sertrn.Field.AsInteger));
  try
    if not glArena15W.Visible then
      glArena15W.Show
    else
      glArena15W.BringToFront;
  except
    glArena15W := Tarena15W.Create(Self,pvCnx,TTournament.Create(pvCnx, Self.sertrn.Field.AsInteger));
    glArena15W.Show;
  end;
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

procedure TtournamentW.PrepareForKOPhaseActionExecute(Sender: TObject);
var
  categ: TQualificationGroup;
begin
  inherited;
  categ := TQualificationGroup.Create(pvCnx, catSource.DataSet.FieldByName('sercat').AsInteger);
  try
    categ.ChangeQualificationGroupPhaseToKO;
    catSource.DataSet.Refresh;
  finally
    categ.Free;
  end;
end;

end.
