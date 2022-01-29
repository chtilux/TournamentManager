unit tournamentWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, childWindow, Vcl.StdCtrls, Vcl.ExtCtrls, ZDataset,DB,
  Vcl.Mask, Vcl.DBCtrls, Vcl.ComCtrls, lal_sequence, Vcl.Grids, Vcl.DBGrids,
  System.Actions, Vcl.ActnList, mainWindow, Vcl.Menus, Vcl.DBCGrids,
  Vcl.Buttons, ZAbstractRODataset,tmUtils15, lal_connection, Contnrs, lal_seek,
  groupPanel, TMEnums, Spring.Collections, tm.AuscheidungsGroup;

type
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
    catSource: TDataSource;
    clscatSource: TDataSource;
    tournamentNav: TDBNavigator;
    importButton: TButton;
    inscSource: TDataSource;
    joueursSource: TDataSource;
    clubsSource: TDataSource;
    ActionsList: TActionList;
    tabSource: TDataSource;
    prpSource: TDataSource;
    PrepareAction: TAction;
    prpclbSource: TDataSource;
    autoDrawAction: TAction;
    tabloSource: TDataSource;
    Memo1: TMemo;
    Splitter3: TSplitter;
    addAPlayerAction: TAction;
    Label11: TLabel;
    codcls: TDBEdit;
    ResetAction: TAction;
    GenerateDrawGamesAction: TAction;
    excelAction: TAction;
    orderByAction: TAction;
    resetGridMenu: TPopupMenu;
    Resetorderby1: TMenuItem;
    joueurs: TDBText;
    mtclv1Source: TDataSource;
    mtclv2Source: TDataSource;
    mtclv3Source: TDataSource;
    checkMatchesAction: TAction;
    importAction: TAction;
    SeedAction: TAction;
    eliminateAction: TAction;
    inscGridMenu: TPopupMenu;
    disqualifyMenu: TMenuItem;
    inscAction: TAction;
    editMatchAction: TAction;
    CtrlGridMenu: TPopupMenu;
    Editer1: TMenuItem;
    Label15: TLabel;
    expcol: TDBEdit;
    resultsAction: TAction;
    internetAction: TAction;
    checkDoublonsAction: TAction;
    BitBtn3: TBitBtn;
    arenaAction: TAction;
    Label16: TLabel;
    numtbl: TDBEdit;
    requalifyMenu: TMenuItem;
    BitBtn4: TBitBtn;
    codclb: TDBEdit;
    manualDrawAction: TAction;
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
    SetGroupsAction: TAction;
    SetPhaseAction: TAction;
    Modifierlaphase1: TMenuItem;
    GenerateGroupGamesAction: TAction;
    DisplayTableauAction: TAction;
    SetFirstRoundModeAction: TAction;
    Modifierlemode1ertour1: TMenuItem;
    N1: TMenuItem;
    Swap2PlayersAction: TAction;
    PrepareForKOPhaseAction: TAction;
    PrepareforKOphaseMenu: TMenuItem;
    CreateExcelGroupFileAction: TAction;
    Crerlefichierexceldegroupes1: TMenuItem;
    pg: TPageControl;
    catSheet: TTabSheet;
    Panel1: TPanel;
    DBNavigator1: TDBNavigator;
    DisplayCategoryButton: TButton;
    Button11: TButton;
    Button12: TButton;
    Panel2: TPanel;
    Splitter5: TSplitter;
    catGrid: TDBGrid;
    Panel3: TPanel;
    clsGrid: TDBGrid;
    Panel21: TPanel;
    DBNavigator2: TDBNavigator;
    clsCatageButton: TButton;
    inscSheet: TTabSheet;
    Panel4: TPanel;
    Panel5: TPanel;
    Label13: TLabel;
    DBNavigator5: TDBNavigator;
    inscSearch: TEdit;
    Panel6: TPanel;
    inscGrid: TDBGrid;
    joueursSheet: TTabSheet;
    Panel7: TPanel;
    Label14: TLabel;
    DBNavigator4: TDBNavigator;
    joueurSearch: TEdit;
    Panel8: TPanel;
    joueursGrid: TDBGrid;
    ClubsSheet: TTabSheet;
    Panel9: TPanel;
    DBNavigator6: TDBNavigator;
    Panel10: TPanel;
    clubsGrid: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure pgChanging(Sender: TObject; var AllowChange: Boolean);
    procedure pgChange(Sender: TObject);
    procedure catGridTitleClick(Column: TColumn);
    procedure Memo1DblClick(Sender: TObject);
    procedure catGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormDestroy(Sender: TObject);
    procedure leftMatchGridDblClick(Sender: TObject);
    procedure leftMatchGridKeyPress(Sender: TObject; var Key: Char);
    procedure leftMatchGridPaintPanel(DBCtrlGrid: TDBCtrlGrid; Index: Integer);
    procedure importActionExecute(Sender: TObject);
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
    procedure internetActionExecute(Sender: TObject);
    procedure checkDoublonsActionExecute(Sender: TObject);
    procedure requalifyMenuClick(Sender: TObject);
    procedure tournamentSourceDataChange(Sender: TObject; Field: TField);
    procedure codclbKeyPress(Sender: TObject; var Key: Char);
    procedure tournamentNavClick(Sender: TObject; Button: TNavigateBtn);
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
    procedure SetFirstRoundModeActionExecute(Sender: TObject);
    procedure CreateExcelGroupFileActionExecute(Sender: TObject);
  private
    { Déclarations privées }
    _openMode: TOpenMode;
    _sertrn: integer;
    _tournament,
    _cat,
    _insc,
    _clubs,
    _joueurs : TZQuery;
    _debug: TStrings;
    _loading: boolean;
    pvCnx: TLalConnection;
    pvSeq: TLalSequence;
    pvSeek: TLalSeek;
    pvAnhangs: IDictionary<integer,TAnhang2>;

    function  editMatch(const sermtc: integer): boolean;
    function SelectSeek(var seek_code: string): boolean;
    procedure closeDatasets;
    procedure colorsChanged(var Message: TMessage); message wm_colorsChanged;
    procedure dbGridColumns(grid: TDBGrid);
    procedure doublonDataChange(Sender: TObject; Field: TField);
    procedure FirstRoundModeGetText(Sender: TField; var Text: string; DisplayText: boolean);
    procedure importation(const tournoi: integer);
    procedure openImportationDocument(const filename: string; var xls, wkb, sht: Variant);
    procedure doImportation(const tournoi: integer; var xls, wkb, sht: Variant);
    procedure joueursGetText(Sender: TField; var Text: string; DisplayText: boolean);
    procedure newRecord(Dataset: TDataset);
    procedure onCategChange(var Message: TMessage); message wm_categChanged;
    procedure writeDatasets;

    procedure ExecuteDisplayTableauAction;

    procedure ImporteInscriptions(const tournoi: integer);
    procedure CreateQualificationGroups(const tournoi: integer;
      const categorie: string);
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
  manualDrawWindow, SeedsWindow, Swap2PlayersWindow, Tournament, Game, Category,
  DriveOLEExcel;

const
  SPIELER_PER_GRUPPE = 3;

var
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
  _tournament.FieldDefs.Update;
  for i := 0 to Pred(_tournament.FieldDefs.Count) do
    _tournament.FieldDefs[i].CreateField(Self);
  _tournament.FieldByName('first_round_mode').OnGetText := FirstRoundModeGetText;

  _cat := getQuery(pvCnx, Self);
  _cat.SQL.Add('SELECT DISTINCT ins.categorie, categ.*'
               +'   ,(SELECT COUNT(*) FROM inscriptions i WHERE i.tournoi = ins.tournoi AND i.categorie = ins.categorie) participants'
               +'   ,0 a_jouer'
               +' FROM inscriptions ins'
               +'   LEFT JOIN categories categ ON categ.sertrn = ins.tournoi AND categ.codcat = ins.categorie'
               +' WHERE ins.tournoi = :tournoi'
               +' ORDER BY ins.categorie');
  _cat.Prepare;
  catSource.DataSet := _cat;

  _insc := getQuery(pvCnx, Self);
  { 25.01.2022 : version 2.0 }
  _insc.SQL.Add('SELECT * FROM inscriptions'
               +' WHERE tournoi = :tournoi'
               +' ORDER BY categorie,vbrgl,classement,points DESC,top_classement_saison');
  inscSource.DataSet := _insc;

  _joueurs := getQuery(pvCnx, Self);
  _joueurs.SQL.Add('SELECT * FROM inscriptions'
                  +' WHERE tournoi = :tournoi'
                  +' ORDER BY nom_joueur,categorie');
  _joueurs.Prepare;
  joueursSource.DataSet := _joueurs;

  _clubs  := getQuery(pvCnx, Self);
  _clubs.SQL.Add('SELECT * FROM inscriptions'
                +' WHERE tournoi = :tournoi'
                +' ORDER BY code_club, nom_joueur, categorie');
  _clubs.Prepare;
  clubsSource.DataSet := _clubs;

  pvSeek := TLalSeek.Create(Self);
  pvSeek.Connection := pvCnx.get;
  pvSeek.SeekKey := VK_F3;
end;

procedure TtournamentW.FormDestroy(Sender: TObject);
const
  checked: array[boolean] of string = ('0','1');
begin
  _debug.Free;
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
  dbGridColumns(catGrid);
  dbGridColumns(inscGrid);
  dbGridColumns(joueursGrid);
  dbGridColumns(clubsGrid);
  pg.ActivePage := catSheet;


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
        _cat.ParamByName('tournoi').Value := _sertrn;
        _cat.Open;
      end;
    end;
  end;

  pvAnhangs := TCollections.CreateDictionary<integer, TAnhang2>;

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

  _loading := False;
end;

procedure TtournamentW.importActionExecute(Sender: TObject);
begin
  ImporteInscriptions(sertrn.Field.Value);
end;

procedure TtournamentW.ImporteInscriptions(const tournoi: integer);
begin
  { on controle si il existe au moins 1 enregistrement de joueur. Si oui, demande
    de confirmation, sinon importation directe }
  with getROQuery(pvCnx) do
  begin
    try
      SQL.Add('SELECT COUNT(*) FROM inscriptions WHERE tournoi = :tournoi');
      Params[0].Value := tournoi;
      Open;
      if (Fields[0].AsInteger = 0) or
         ((Fields[0].AsInteger > 0) and (MessageDlg('Réimporter les inscriptions ?', TMsgDlgType.mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes)) then
        importation(tournoi);
    finally
      Free;
    end;
  end;
end;

procedure TtournamentW.importation(const tournoi: integer);
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
  xls, wkb, sht: Variant;
begin
  filename := getImportFilename;
  if FileExists(filename) then
  begin
    openImportationDocument(filename, xls, wkb, sht);
    Screen.Cursor := crSQLWait;
    try
      pvCnx.startTransaction;
      try
        doImportation(tournoi, xls, wkb, sht);
        pvCnx.commit;
        _cat.Refresh;
      except
        pvCnx.rollback;
        raise;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TtournamentW.openImportationDocument(const filename: string; var xls, wkb, sht: Variant);
begin
  openExcelWorkbook(xls,wkb,sht, filename);
end;

procedure TtournamentW.doImportation(const tournoi: integer; var xls, wkb, sht: Variant);
  function OrdOf(const c: char): integer;
  const
    A: integer = 0;
  begin
    if A = 0 then
      A := Ord('A');
    Result := Succ(Ord(c)-A);
  end;
var
  row: integer;
  z: TZReadOnlyQuery;
  categories: TStrings;
  categ: Integer;
const
  categorie = 'A';
  code_club = 'B';
  nom_joueur = 'C';
  nom_club = 'D';
  classement = 'E';
  vbrgl = 'F';
  points = 'G';
  top_classement = 'H';
  top_classement_demi_saison = 'I';
begin
  z := getROQuery(pvCnx);
  try
    { inscriptions }
    z.SQL.Add('INSERT INTO inscriptions (serinsc,tournoi,categorie,code_club,nom_joueur,nom_club,classement,vbrgl,points,top_classement_saison,top_classement_demi_saison)'
             +' VALUES (:serinsc,:tournoi,:categorie,:code_club,:nom_joueur,:nom_club,:classement,:vbrgl,:points,:top_classement_saison,:top_classement_demi_saison)');
    z.Prepare;
    z.ParamByName('tournoi').AsInteger := tournoi;
    for row := 2 to getWorksheetRowsCount(sht) do
    begin
      z.ParamByName('serinsc').AsInteger := 0;  // trigger
//      z.ParamByName('serinsc').AsInteger := pvSeq.SerialByName('inscription');
      z.ParamByName('categorie').AsString := sht.Cells[row,OrdOf(categorie)];
      z.ParamByName('code_club').AsString := sht.Cells[row,OrdOf(code_club)];
      z.ParamByName('nom_joueur').AsString := sht.Cells[row,OrdOf(nom_joueur)];
      z.ParamByName('nom_club').AsString := sht.Cells[row,OrdOf(nom_club)];
      z.ParamByName('classement').AsString := sht.Cells[row,OrdOf(classement)];
      z.ParamByName('vbrgl').AsInteger := sht.Cells[row,OrdOf(vbrgl)];
      z.ParamByName('points').AsFloat := sht.Cells[row,OrdOf(points)];
      z.ParamByName('top_classement_saison').AsString := sht.Cells[row,OrdOf(top_classement)];
      z.ParamByName('top_classement_demi_saison').AsString := sht.Cells[row,OrdOf(top_classement_demi_saison)];
      z.ExecSQL;
    end;

    categories := TStringList.Create;
    try
      { catégories }
      z.SQL.Clear;
      z.SQL.Add('SELECT DISTINCT categorie'
               +' FROM inscriptions'
               +' WHERE tournoi = :tournoi');
      z.Params[0].AsInteger := tournoi;
      z.Open;
      while not z.Eof do
      begin
        categories.Add(z.Fields[0].AsString);
        z.Next;
      end;
      z.Close;

      z.sql.Clear;
      z.SQL.Add('INSERT INTO categories (sercat,sertrn,saison,codcat,heudeb,simple,handicap,numset,catage,stacat,first_round_mode,parent,phase)'
               +' VALUES (:sercat,:sertrn,:saison,:codcat,:heudeb,:simple,:handicap,3,0,:stacat,:first_round_mode,0,:phase)');
      z.Prepare;
      z.ParamByName('sertrn').AsInteger := tournoi;
      z.ParamByName('saison').AsInteger := _tournament.FieldByName('saison').AsInteger;
      z.ParamByName('heudeb').AsString := '09:00';
      z.ParamByName('simple').AsBoolean := True;
      z.ParamByName('handicap').AsBoolean := False;
      z.ParamByName('stacat').Value := csInactive;
      z.ParamByName('first_round_mode').Value := frQualification;
      z.ParamByName('phase').Value := frQualification;

      for categ := 0 to categories.Count-1 do
      begin
        z.ParamByName('codcat').AsString := categories[categ];
        z.ParamByname('sercat').AsInteger := pvSeq.SerialByName('categorie');
        z.ExecSQL;
      end;
    finally
      categories.Free;
    end;
  finally
    z.Free;
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
//const
//  cl: array[TRegistrationStatus] of TColor = (clSilver,clCream,$00DDBBFF);
//  cs: array[TRegistrationStatus] of TPingItem = (piDisqualified,piQualified,piWO);
begin
  inherited;
  with inscGrid.Canvas do
  begin
//    if not inscGrid.DataSource.DataSet.IsEmpty then
//      Brush.Color := getRegistrationColor(TRegistrationStatus(inscGrid.DataSource.DataSet.FieldByName('statut').Value));
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
//  if (Trim(inscSearch.Text) <> '') and (Length(Trim(inscSearch.Text))>2) then
//  begin
//    if not _insc.Locate('nomjou',Trim(inscSearch.Text),[loCaseInsensitive]) then
//    begin
//      with getROQuery(pvCnx) do
//      begin
//        try
//          SQL.Add('SELECT serinsc'
//                 +' FROM insc a, joueur b'
//                 +' WHERE a.serjou = b.serjou'
//                 +'   and a.sercat = :sercat'
//                 +'   and b.nomjou like ' + QuotedStr(Trim(inscSearch.Text)+'%')
//                 +' order by nomjou');
//          ParamByname('sercat').AsInteger := _cat.FieldByName('sercat').AsInteger;
//          Open;
//          if not IsEmpty then
//          begin
//            mainW.sb.Panels[0].Text := Fields[0].AsString;
//            if _insc.Locate('serinsc',Fields[0].AsInteger,[]) then
//              ;
//          end;
//          Close;
//        finally
//          Free;
//        end;
//      end;
//    end;
//  end;
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
//  if (Trim(joueurSearch.Text) <> '') and (Length(Trim(joueurSearch.Text))>2) then
//  begin
//    if not _insc.Locate('nomjou',Trim(joueurSearch.Text),[loCaseInsensitive]) then
//    begin
//      with getROQuery(pvCnx) do
//      begin
//        try
//          SQL.Add('SELECT b.serjou'
//                 +' FROM insc a, joueur b'
//                 +' WHERE a.serjou = b.serjou'
//                 +'   and a.sertrn = :sertrn'
//                 +'   and b.nomjou like ' + QuotedStr(Trim(joueurSearch.Text)+'%')
//                 +' order by nomjou');
//          ParamByname('sertrn').AsInteger := _sertrn;
//          Open;
//          if not IsEmpty then
//          begin
//            mainW.sb.Panels[0].Text := Fields[0].AsString;
//            if joueursSource.Dataset.Locate('serjou',Fields[0].AsInteger,[]) then
//              ;
//          end;
//          Close;
//        finally
//          Free;
//        end;
//      end;
//    end;
//  end;
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
      FieldByName('simple').AsString := getDefValue('categories','simple',Ord(gkSimple).ToString);
      FieldByName('handicap').AsString := getDefValue('categories','handicap','0');
      FieldByName('numset').AsString := getDefValue('categories','numset','3');
      FieldByName('catage').AsString := getDefValue('categories','catage','0');
      FieldByName('first_round_mode').AsInteger := _tournament.FieldByName('first_round_mode').AsInteger;
      FieldByName('phase').AsInteger := _tournament.FieldByName('mode').AsInteger;
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

procedure TtournamentW.FirstRoundModeGetText(Sender: TField; var Text: string; DisplayText: boolean);
begin
  if not Sender.IsNull then
    Text := Format('%s [%s]',[Sender.AsString,GetEnumName(TypeInfo(TFirstRoundMode), Sender.AsInteger)]);
end;

procedure TtournamentW.onCategChange(var Message: TMessage);
begin
  catGrid.DataSource.DataSet.Refresh;
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
      _insc.ParamByName('tournoi').AsInteger := sertrn.Field.Value;
      _insc.Open;
    end;
    2: begin
      _joueurs.ParamByName('tournoi').AsInteger := sertrn.Field.Value;
      _joueurs.Open;
    end;
    3: begin
      _clubs.ParamByName('tournoi').AsInteger := sertrn.Field.Value;
      _clubs.Open;
    end;
  end;
end;

procedure TtournamentW.pgChanging(Sender: TObject; var AllowChange: Boolean);
begin
  inherited;
  if _insc.Active then
    _insc.Close
  else if _joueurs.Active then
    _joueurs.Close;
end;

procedure TtournamentW.writeDatasets;
begin
  if _tournament.state in dsEditModes then
    _tournament.Post;
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

procedure TtournamentW.CreateExcelGroupFileActionExecute(Sender: TObject);
begin
  inherited;
  CreateQualificationGroups(sertrn.Field.AsInteger,_cat.FieldByName('categorie').AsString);
end;

type
  THauptRunde = class;
  TAnHang = class(TObject)
  public
    TeilNehmer: word;
    AuscheidungRunde: IList<word>;
    HauptRunde: THauptRunde;
    constructor Create(const participants: word);
    destructor Destroy; override;
  end;

  THauptRunde = class(TObject)
  public
    TeilNehmer: word;
    AnHang: TAnHang;
    KORunde: word;
    constructor Create(const participants: word);
    destructor Destroy; override;
  end;

procedure TtournamentW.CreateQualificationGroups(const tournoi: integer; const categorie: string);
  function GetAnhang(const participants: word): TAnhang;
  begin
    Result := TAnHang.Create(participants);
  end;

type
  TSens = (TopToBottom, BottomToTop);

var
  participants,
  placés: word;
  anhang: TAnhang;
  Templates,
  FilenameTemplate: TFilename;
  xls,wkb,sht: Variant;
  orderby,
  spieler: TZReadOnlyQuery;
  row: Integer;
  dossard: integer;
  gruppenZahle: integer;
  i: Integer;
  sens: TSens;
const
  Offset: array[TSens] of integer = (1,-1);
begin
  { déterminer quel fichier modèle utiliser }
  participants := _cat.FieldByName('participants').AsInteger;
  anhang := GetAnhang(participants);
  try
    { créer le fichier }
    Templates := ExcludeTrailingPathDelimiter(glSettings.TemplatesDirectory);
    if DirectoryExists(Templates) then
    begin
      if anhang.HauptRunde.KORunde > 0 then
      begin
        FilenameTemplate := Format('%s\%s',[Templates, Format(glSettings.GroupTemplate, [anhang.HauptRunde.KORunde])]);
        if FileExists(FilenameTemplate) then
        begin
          createExcelWorkbook(xls, wkb, sht, True, FilenameTemplate);
          { feuille starter : compétition }
          SelecteFeuillet(wkb, 'starter');
          sht := wkb.ActiveSheet;
          sht.Cells[1,10] := libelle.Field.AsString;
          sht.Cells[2,10] := categorie;
          sht.Cells[3,10] := organisateur.Field.AsString;
          sht.Cells[4,10] := dattrn.Field.AsString;
          { feuille starter : participants }
          orderBy := nil;
          spieler := getROQuery(pvCnx);
          try
            orderBy := getROQuery(pvCnx);
            orderBy.SQL.Add('SELECT pardc1 FROM dictionnaire'
                            +'  WHERE cledic = :cledic'
                            +'    AND coddic = :coddic');
            orderBy.Params[0].AsString := 'SetzungPriorität';
            OrderBy.Params[1].AsString := Copy(categorie,1,2);
            OrderBy.Open;
            spieler.SQL.Add('SELECT nom_joueur,nom_club,code_club,classement,vbrgl'
                           +' FROM inscriptions'
                           +' WHERE tournoi = :tournoi'
                           +'   AND categorie = :categorie'
                           +'   ORDER BY ' + OrderBy.Fields[0].AsString);
            OrderBy.Close;
            spieler.Params[0].AsInteger := tournoi;
            spieler.Params[1].AsString := categorie;
            spieler.Open;
            row := 1;
            while not spieler.Eof do
            begin
              Inc(row);
              sht.Cells[row, 3] := spieler.FieldByName('nom_joueur').AsString;
              sht.Cells[row, 4] := spieler.FieldByName('nom_club').AsString;
              sht.Cells[row, 5] := spieler.FieldByName('classement').AsString;
              sht.Cells[row, 6] := spieler.FieldByName('vbrgl').AsString;
              spieler.Next;
            end;

            spieler.Close;

            dossard := sht.cells[2,1];
            SelecteFeuillet(wkb, 'Group_Seeding');
            sht := wkb.ActiveSheet;
            row := 0;

            sens := TopToBottom;
            placés := 0;
            while placés < participants do
            begin
              if sens = TopToBottom then
              begin
                for gruppenZahle in Anhang.AuscheidungRunde do
                begin
                  if row = 0 then
                    row := 2
                  else
                  begin
                    Inc(row, SPIELER_PER_GRUPPE*Offset[Sens]);
                    Inc(dossard, 1);
                  end;
                  sht.Cells[row, 2] := dossard;
                  Inc(placés);
                  if placés = participants then
                    Break;
                end;
              end
              else if sens = BottomToTop then
              begin
                for gruppenZahle := anhang.AuscheidungRunde.Count-1 downto 0 do
                begin
                  Inc(dossard, 1);
                  sht.Cells[row, 2] := dossard;
                  Inc(placés);
                  Inc(row, SPIELER_PER_GRUPPE*Offset[Sens]);
                end;
              end;

              Inc(row);
              if sens = TopToBottom then
                sens := BottomToTop
              else
                sens := TopToBottom;
            end;

          finally
            orderBy.Free;
            spieler.Free;
          end;

          { enregistrer la feuille }
          Templates := PrepareExportDirectories(sertrn.Field.AsInteger,organisateur.Field.AsString);
          i := 0;
          FilenameTemplate := Format('%s\%s_Gruppen_%d_v%.2d.xlsx',[Templates,categorie,anhang.HauptRunde.KORunde,i]);
          while FileExists(FilenameTemplate) do
          begin
            Inc(i);
            FilenameTemplate := Format('%s\%s_Gruppen_%d_v%.2d.xlsx',[Templates,categorie,anhang.HauptRunde.KORunde,i]);
          end;

          wkb.SaveAs(Filename := FilenameTemplate,
                     AddToMru := True);
        end;
      end;
    end;
  finally
    anhang.Free;
  end;
end;

procedure TtournamentW.ExecuteDisplayTableauAction;
begin
  if DisplayTableauAction.Enabled then
    DisplayTableauAction.Execute;
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

procedure TtournamentW.catGridTitleClick(Column: TColumn);
begin
  orderByColumn(TZQuery(Column.Grid.DataSource.DataSet),Column,'ASC');
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

procedure TtournamentW.closeDatasets;
begin
  _cat.Close;
  _tournament.Close;
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

procedure TtournamentW.ActionsListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  Handled := True;
end;

{ TAnHang }

constructor TAnHang.Create(const participants: word);
var
  reste: word;
  i: Integer;
  GruppenZahle: word;
begin
  TeilNehmer := participants;
  AuscheidungRunde := TCollections.CreateList<word>;
  case TeilNehmer of
    3,4,5: begin
      AuscheidungRunde.Add(TeilNehmer);
      HauptRunde := THauptRunde.Create(0);
    end;

    else begin
      reste := TeilNehmer mod SPIELER_PER_GRUPPE;
      GruppenZahle := TeilNehmer div SPIELER_PER_GRUPPE;
      case reste of
        0 : begin
          for i := 1 to GruppenZahle do
            AuscheidungRunde.Add(SPIELER_PER_GRUPPE);
          HauptRunde := THauptRunde.Create(AuscheidungRunde.Count);
        end;

        1: begin
          for i := 1 to Pred(GruppenZahle) do
            AuscheidungRunde.Add(SPIELER_PER_GRUPPE);
          AuscheidungRunde.Add(2);
          AuscheidungRunde.Add(2);
          HauptRunde := THauptRunde.Create(AuscheidungRunde.Count);
        end;

        2: begin
          for i := 1 to GruppenZahle do
            AuscheidungRunde.Add(SPIELER_PER_GRUPPE);
          AuscheidungRunde.Add(2);
          HauptRunde := THauptRunde.Create(AuscheidungRunde.Count);
        end;
      end;
    end;

  end;
end;

destructor TAnHang.Destroy;
begin
  HauptRunde.Free;
  inherited;
end;

{ THauptRunde }

constructor THauptRunde.Create(const participants: word);
begin
  TeilNehmer := participants;
  KORunde := 0;
  AnHang := nil;
  case TeilNehmer of
    2 : KORunde := 16;
    3 : AnHang := TAnHang.Create(3);
    4..8 : KORunde := 16;
    9..16 : KORunde := 16;
    17..32 : KORunde := 32;
    33..64 : KORunde := 32;
  end;
end;

destructor THauptRunde.Destroy;
begin
  AnHang.Free;
  inherited;
end;

end.
