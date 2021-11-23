unit arena15Window;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, tmUtils15, lal_connection, lal_utils, Inifiles, ZDataset, Db,
  ZAbstractRODataset, System.Actions, Vcl.ActnList, Vcl.Menus, PlayerStatusWindow,
  Tournament, Arena, AreaContent, ZIBEventAlerter;

type
  Tarena15W = class(TForm)
    workspacePanel: TPanel;
    Splitter1: TSplitter;
    topPanel: TPanel;
    bottomPanel: TPanel;
    Splitter3: TSplitter;
    inputPanel: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    umpiresView: TListView;
    fontSizeEdit: TEdit;
    categGridFontSize: TUpDown;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    categsPanel: TPanel;
    scrollCategs: TScrollBox;
    sb: TStatusBar;
    umpiresViewActions: TActionList;
    setUmpireAction: TAction;
    unsetUmpireAction: TAction;
    activatePlayArea: TAction;
    deactivatePlayArea: TAction;
    refreshUmpiresAction: TAction;
    BitBtn7: TBitBtn;
    PopupMenu1: TPopupMenu;
    detailPanel: TPanel;
    arenaPanel: TPanel;
    Splitter5: TSplitter;
    Label1: TLabel;
    filterGamesBox: TComboBox;
    refreshAllAction: TAction;
    drawBox: TPaintBox;
    ViewPlayerStatusAction: TAction;
    Button1: TButton;
    ZIBEventAlerter1: TZIBEventAlerter;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure scrollCategsResize(Sender: TObject);
    procedure categGridFontSizeClick(Sender: TObject; Button: TUDBtnType);
    procedure umpiresViewCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure umpiresViewClick(Sender: TObject);
    procedure umpiresViewActionsUpdate(Action: TBasicAction;
      var Handled: Boolean);
    procedure unsetUmpireActionExecute(Sender: TObject);
    procedure refreshUmpiresActionExecute(Sender: TObject);
    procedure setUmpireActionExecute(Sender: TObject);
    procedure activatePlayAreaExecute(Sender: TObject);
    procedure deactivatePlayAreaExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sbDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure BitBtn1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure umpiresViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure filterGamesBoxChange(Sender: TObject);
    procedure refreshAllActionExecute(Sender: TObject);
    procedure detailPanelResize(Sender: TObject);
    procedure drawBoxDblClick(Sender: TObject);
    procedure ViewPlayerStatusActionExecute(Sender: TObject);
    procedure ZIBEventAlerter1EventAlert(Sender: TObject; EventName: string;
      EventCount: Integer; var CancelAlerts: Boolean);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    pvArena: TArena;
    pvTournament: TTournament;
    pvCnx: TLalConnection;
    pvInProgressCategs: TZReadOnlyQuery;
    pvUmpires: TZReadOnlyQuery;
    pvGame: TZReadOnlyQuery;
    pvPlayer: TZReadOnlyQuery;
    pvUmpire: TZReadOnlyQuery;
    pvPlayerStatus: TPlayerStatus;
    pvPlayerStatusW: TPlayerStatusW;
    pvDisplayContentFactory: IAreaContentDisplayFactory;

    procedure readLayout(trn: TTournament);
    procedure iniReadCallback(ini: TInifile);
    procedure iniWriteCallback(ini: TInifile);
    procedure buildQuerys;

    procedure clearCategs;
    procedure inProgressCategorys;
    procedure umpires;
    procedure games;
    procedure runCateg(Sender: TObject);

    procedure onGameIsOver(var Message: TMessage); message wm_gameIsOver;
    procedure onGameInfo(var Message: TMessage); message wm_gameInfo;
    procedure onCategIsOver(var Message: TMessage); message wm_categChanged;
    procedure onUmpiresRefresh(var Message: TMessage); message wm_umpiresRefresh;
    procedure onNoPlayAreaAvailable(var Message: TMessage); message wm_noPlayAreaAvailable;
    procedure onPlayerIsBusy(var Message: TMessage); message wm_playerIsBusy;
    procedure onPlayerIsUmpire(var Message: TMessage); message wm_playerIsUmpire;
    procedure onGameCatchResult(var Message: TMessage); message wm_gameCatchResult;
    procedure GridOnHighlightPlayer(var Message: TMessage); message wm_highLightPlayer;
    procedure onPlayAreaRefresh(var Message: TMessage); message wm_playAreaRefresh;
    procedure onColorsChanged(var Message: TMessage); message wm_colorsChanged;
    procedure onBeginGame(var Message: TMessage); message wm_beginGame;
    procedure onEndGame(var Message: TMessage); message wm_endGame;
    procedure onDisplayDraw(var Message: TMessage); message wm_displayDraw;
    procedure onCancelGame(var Message: TMessage); message wm_gameCanceled;
    procedure onPlayerStatus(var Message: TMessage); message wm_playerStatus;
    procedure OnRefreshArenaDisplay(var Message: TMessage); message wm_refreshArenaDisplay;

    procedure onFilterGameEvent(DataSet: TDataSet; var Accept: Boolean);
    procedure filterGames(const filtered: boolean);

    procedure displayDraw(const sertab,sermtc: integer);
    procedure resetFieldsFocus;

//    procedure OnGameIsOverDatabaseEvent;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; cnx: TLalConnection; trn: TTournament); reintroduce; overload;
    destructor Destroy; override;
  end;

var
  glArena15W: Tarena15W;

implementation

{$R *.dfm}

uses
  lal_dbUtils, ArenaPanel, ArenaQualificationPanel, ArenaCategoryPanel,
  dataGridWindow, saisieWindow, draw, drawWindow, TMEnums, Game, Group,
  PlayArea;

type
  TPanelKind = (pkCateg,pkPlayer1,pkPlayer2,pkArea,pkUmpire,pkError);

var
  lcSBColors: array[TPanelKind] of TColor;
  {: to prevent twice draw's drawing }
  lcSertab,
  lcSermtc: integer;

{ Tarena15W }

procedure Tarena15W.activatePlayAreaExecute(Sender: TObject);
begin
  setPlayAreaStatus(umpiresView.Selected.Caption.ToInteger(), pasAvailable);
  refreshUmpiresAction.Execute;
end;

procedure Tarena15W.umpiresViewActionsUpdate(Action: TBasicAction;
  var Handled: Boolean);
var
  li: TListItem;
begin
  li := umpiresView.Selected;
  if li = nil  then
  begin
    setUmpireAction.Enabled := False;
    unsetUmpireAction.Enabled := False;
    activatePlayArea.Enabled := False;
    deactivatePlayArea.Enabled := False;
    Handled := True;
    Exit;
  end;
  setUmpireAction.Enabled := li.SubItems[0] = '';
  unsetUmpireAction.Enabled := li.SubItems[0] <> '';
  activatePlayArea.Enabled := li.SubItems[1] = Ord(pasInactive).ToString;
  deactivatePlayArea.Enabled := (li.SubItems[1] = Ord(pasAvailable).ToString) and
                                (li.SubItems[2] = '0');
  Handled := True;
end;

procedure Tarena15W.BitBtn1Click(Sender: TObject);
var
  pt: TPoint;
begin
  GetCursorPos(pt);
  PopupMenu1.Popup(pt.X, pt.Y);
end;

procedure Tarena15W.buildQuerys;
begin
  pvInProgressCategs := getROQuery(pvCnx, Self);
  pvInProgressCategs.SQL.Add('SELECT sercat,codcat,heudeb,simple,handicap,stacat'
                            +'      ,first_round_mode,phase'
                            +'      ,(SELECT MAX(level) FROM match m WHERE m.sertab = c.sercat) level'
                            +' FROM Categories c'
                            +' WHERE sertrn = ' + pvTournament.Sertrn.ToString
                            +'   AND stacat = ' + Ord(csInProgress).ToString
                            +' ORDER BY heudeb DESC,codcat');

  pvUmpires := getROQuery(pvCnx, Self);
  pvUmpires.SQL.Add('SELECT ump.numtbl,COALESCE(ump.serump,0)serump,ump.statbl,COALESCE(ump.sermtc,0)sermtc'
                   +'      ,CASE'
                   +'         WHEN mtc.nummtc IS NOT NULL THEN mtc.nummtc'
                   +'         WHEN grp.numgrp IS NOT NULL THEN grp.numgrp'
                   +'       END nummtc'
                   +'      ,CASE'
                   +'         WHEN mtc.nummtc IS NOT NULL THEN ''K-O'''
                   +'         WHEN grp.numgrp IS NOT NULL THEN ''GROUPE'''
                   +'       END phase'
                   +'      ,CASE'
                   +'         WHEN mtc.nummtc IS NOT NULL THEN ump.umpire'
                   +'         WHEN grp.numgrp IS NOT NULL THEN cat.codcat||'' - GROUPE ''||grp.numgrp'
                   +'         ELSE ump.umpire'
                   +'       END umpire'
                   +' FROM umpires ump'
                   +'    LEFT JOIN match mtc ON mtc.sermtc = ump.sermtc'
                   +'    LEFT JOIN groupe grp ON grp.sergrp = ump.sermtc'
                   +'    LEFT JOIN categories cat ON cat.sercat = grp.sercat'
                   +' WHERE ump.sertrn = ' + pvTournament.Sertrn.ToString
//                   +'   AND (((mtc.stamtc = 1) OR (grp.stagrp = 3)) OR COALESCE(ump.sermtc,0)=0)'
                   +' ORDER BY ump.numtbl');
  pvGame := getROQuery(pvCnx, Self);
  pvGame.SQL.Add('SELECT serjo1,serjo2,numtbl,sermtc,sertab,level,nummtc'
                +'  ,(SELECT nomjou FROM joueur a WHERE a.serjou = m.serjo1) nomjo1'
                +'  ,(SELECT nomjou FROM joueur a WHERE a.serjou = m.serjo2) nomjo2'
                +'  ,(SELECT nomjou FROM joueur a WHERE a.serjou = m.vainqueur) winnerName'
                +'  ,(SELECT nomjou FROM joueur a WHERE a.serjou = m.perdant) loserName'
                +'  ,(SELECT umpire FROM umpires u WHERE u.SERTRN = m.sertrn AND u.NUMTBL = m.NUMTBL ) umpireName'
                +'  ,(SELECT codcat FROM categories c WHERE m.sertab = c.sercat) codcat'
                +'  FROM MATCH m'
                +'    WHERE m.sermtc = :sermtc');
  pvGame.Prepare;

  pvPlayer := getROQuery(pvCnx, Self);
  pvPlayer.SQL.Add('SELECT nomjou FROM joueur WHERE serjou = :serjou');
  pvPlayer.Prepare;

  pvUmpire := getROQuery(pvCnx, Self);
  pvUmpire.SQL.Add('SELECT DISTINCT a.serjou'
                  +'  FROM joueur a INNER JOIN insc i ON i.serjou = a.serjou AND i.sertrn = :sertrn'
                  +' WHERE a.nomjou = :nomjou');
  pvUmpire.Prepare;
  pvUmpire.ParamByName('sertrn').AsInteger :=  pvTournament.Sertrn;
end;

procedure Tarena15W.clearCategs;
var
  ap: TArenaPanel;
begin
  while scrollCategs.ControlCount > 0 do
  begin
    ap := TArenaPanel(scrollCategs.Controls[0]);
    if Assigned(ap.Dataset) and ap.Dataset.Filtered then
      ap.Dataset.Filtered := False;
    ap.Free;
  end;
end;

constructor Tarena15W.Create(AOwner: TComponent; cnx: TLalConnection;
  trn: TTournament);
begin
  inherited Create(AOwner);
  pvCnx := cnx;
  pvTournament := trn;

  buildQuerys;

  pvDisplayContentFactory := TAreaContentDisplayFactory.Create;

  pvArena := TArena.Create(Self);
  pvArena.Visible := False;
  pvArena.Parent := topPanel;
  pvArena.tournament := trn;
  pvArena.Align := alClient;
  pvArena.Color := getItemsColor(piArena);
  pvArena.TextColor := getItemsColor(piUmpire);
  pvArena.ArenaLayout := getArenaLayout(pvTournament);
  pvArena.createAreas;

  lcSBColors[pkCateg] := getItemsColor(piDraw);
  lcSBColors[pkPlayer1] := getItemsColor(piStabylo);
  lcSBColors[pkPlayer2] := getItemsColor(piStabylo);
  lcSBColors[pkArea] := getItemsColor(piArena);
  lcSBColors[pkUmpire] := getItemsColor(piUmpire);
  lcSBColors[pkError] := getItemsColor(piError);

  filterGamesBox.Items.Add('None');
  filterGamesBox.Items.Add(getGamesDesc(gsInactive));
  filterGamesBox.Items.Add(getGamesDesc(gsInProgress));

  pvPlayerStatus := TPlayerStatus.Create(pvCnx);
  pvPlayerStatus.AvailableColor := getItemsColor(piAvailable);
  pvPlayerStatus.IsPlayingColor := getItemsColor(piInProgress);
  pvPlayerStatus.IsUmpireColor := getItemsColor(piUmpire);
  pvPlayerStatusW := TPlayerStatusW.Create(Self);
  pvPlayerStatusW.PlayerStatus := pvPlayerStatus;
  pvPlayerStatusW.QualifiedColor := getItemsColor(piQualified);
  pvPlayerStatusW.DisqualifiedColor := getItemsColor(piDisqualified);
  pvPlayerStatusW.WOColor := getItemsColor(piWO);
  pvArena.Visible := True;
end;

procedure Tarena15W.deactivatePlayAreaExecute(Sender: TObject);
begin
  setPlayAreaStatus(umpiresView.Selected.Caption.ToInteger(), pasInactive);
  refreshUmpiresAction.Execute;
end;

destructor Tarena15W.Destroy;
begin
  pvPlayerStatus.Free;
  pvTournament.Free;
  inherited;
end;

procedure Tarena15W.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  writeFormPos(Self,iniWriteCallback);
  if Assigned(pvPlayerStatusW) then
    FreeAndNil(pvPlayerStatusW);
end;

procedure Tarena15W.FormDestroy(Sender: TObject);
begin
  ZIBEventAlerter1.UnRegisterEvents;
end;

procedure Tarena15W.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Chr(Key) = 'z') or (Chr(Key) = 'Z')) and (ssAlt in Shift) then
  begin
    Key := 0;
    if not Assigned(saisie) then
      saisie := TsaisieW.Create(Self, pvCnx, pvTournament.Sertrn);
    saisie.Show;
  end
  else if ((Chr(Key) = 'r') or (Chr(Key) = 'R')) and (ssCtrl in Shift) then
  begin
    Key := 0;
    refreshAllAction.Execute;
  end
end;

procedure Tarena15W.FormShow(Sender: TObject);
var
  i: Integer;
begin
  readLayout(pvTournament);

  umpires;
  inProgressCategorys;
  games;
  Caption := Format('Tournoi %d, %s, %s',[pvTournament.Sertrn,pvTournament.Description,pvTournament.Organizer]);
  readFormPos(Self,iniReadCallback);
  for i := 0 to scrollCategs.ControlCount-1 do
    TArenaPanel(scrollCategs.Controls[i]).gridFontSize := Self.categGridFontSize.Position;

  ZIBEventAlerter1.Connection := pvCnx.get;
  ZIBEventAlerter1.Events.Add(cs_game_is_over);
  ZIBEventAlerter1.RegisterEvents;
end;

procedure Tarena15W.games;
var
  m: TGame;
  g: Group.TGroup;
  content: IAreaContent;
begin
  pvUmpires.Open;
  try
    while not pvUmpires.Eof do
    begin
      if pvUmpires.FieldByName('sermtc').AsInteger > 0 then
      begin
        if pvUmpires.FieldByName('phase').AsString = 'K-O' then
        begin
          m := TGame.Create(Self,pvCnx,pvUmpires.FieldByName('sermtc').AsInteger);
          Content := TGameContent.Create(pvCnx, actKo, pvUmpires.FieldByName('sermtc').AsInteger);
          TGameContent(Content).Game := m;
          Content.Display := pvDisplayContentFactory.CreateAreaGameContentDisplay;
//          pvArena.Areas[Pred(pvUmpires.FieldByName('numtbl').AsInteger)].Game := m;
          pvArena.Areas[Pred(pvUmpires.FieldByName('numtbl').AsInteger)].Content := Content;
        end
        else if pvUmpires.FieldByName('phase').AsString = 'GROUPE' then
        begin
          { TODO : Adapter TArena pour afficher un groupe }
//          content := TGroupContent.Create(pvCnx, pvUmpires.FieldByName('sermtc').AsInteger);
          g := TGroup.Create(pvCnx, pvUmpires.FieldByName('sermtc').AsInteger);
          Content := TGroupContent.Create(pvCnx, actGroup, pvUmpires.FieldByName('sermtc').AsInteger);
          Content.Display := pvDisplayContentFactory.CreateAreaGroupContentDisplay;
          TGroupContent(Content).Groupe := g;
          pvArena.Areas[Pred(pvUmpires.FieldByName('numtbl').AsInteger)].Content := content;
        end;
      end
      else
        pvArena.Areas[Pred(pvUmpires.FieldByName('numtbl').AsInteger)].Content := nil;
      pvUmpires.Next;
      Application.ProcessMessages;
    end;
  finally
    pvUmpires.Close;
  end;
end;

procedure Tarena15W.GridOnHighlightPlayer(var Message: TMessage);
var
  i: integer;
begin
  for i := 0 to scrollCategs.ControlCount-1 do
    TArenaPanel(scrollCategs.Controls[i]).Perform(wm_highLightPlayer,Message.WParam,Message.LParam);
end;

procedure Tarena15W.iniReadCallback(ini: TInifile);
begin
  TopPanel.Height := ini.ReadInteger('TopPanel','Height',TopPanel.Height);
  DetailPanel.Width := ini.ReadInteger('DetailPanel','Width',detailPanel.Width);
  InputPanel.Width := ini.ReadInteger('InputPanel','Width',inputPanel.Width);
  categGridFontSize.Position := ini.ReadInteger('gridCateg','FontSize',12);
  if Assigned(pvPlayerStatusW) then
  begin
    pvPlayerStatusW.Left := ini.ReadInteger('PlayerStatus','Left',pvPlayerStatusW.Left);
    pvPlayerStatusW.Top := ini.ReadInteger('PlayerStatus','Top',pvPlayerStatusW.Top);
    pvPlayerStatusW.Width := ini.ReadInteger('PlayerStatus','Width',pvPlayerStatusW.Width);
    pvPlayerStatusW.Height := ini.ReadInteger('PlayerStatus','Height',pvPlayerStatusW.Height);
  end;
end;

procedure Tarena15W.iniWriteCallback(ini: TInifile);
begin
  ini.WriteInteger('TopPanel','Height',TopPanel.Height);
  ini.WriteInteger('DetailPanel','Width',detailPanel.Width);
  ini.WriteInteger('InputPanel','Width',inputPanel.Width);
  ini.WriteInteger('gridCateg','FontSize',categGridFontSize.Position);
  if Assigned(pvPlayerStatusW) then
  begin
    ini.WriteInteger('PlayerStatus','Left',pvPlayerStatusW.Left);
    ini.WriteInteger('PlayerStatus','Top',pvPlayerStatusW.Top);
    ini.WriteInteger('PlayerStatus','Width',pvPlayerStatusW.Width);
    ini.WriteInteger('PlayerStatus','Height',pvPlayerStatusW.Height);
  end;
end;

procedure Tarena15W.inProgressCategorys;
var
  ap: TArenaPanel;
  lcCount: integer;
begin
  clearCategs;
  if pvInProgressCategs.Active then
    pvInProgressCategs.Refresh
  else
    pvInProgressCategs.Open;

  pvInProgressCategs.First;
  lcCount := pvInProgressCategs.RecordCount;
  scrollCategs.Visible := False;
  try
    while not pvInProgressCategs.Eof do
    begin
      if pvInProgressCategs.FieldByName('phase').AsInteger = Ord(frKO) then
        ap := TArenaCategPanel.Create(Self, pvCnx, pvInProgressCategs.FieldByName('sercat').AsInteger)
      else
        ap := TArenaQualificationPanel.Create(Self, pvCnx, pvInProgressCategs.FieldByName('sercat').AsInteger);
      with ap, pvInProgressCategs do
      begin
        Parent := scrollCategs;
        Visible := False; // to avoid flickering
        Align := alRight;
        Width := (Self.categsPanel.ClientWidth - Pred(lcCount)) div lcCount;
        Caption := FieldByName('codcat').AsString;
        Dataset.OnFilterRecord := Self.onFilterGameEvent;
        Visible := True;
        ap.gridFontSize := Self.categGridFontSize.Position;
        Next;
        Application.ProcessMessages;
      end;
    end;
  finally
    scrollCategs.Visible := True;
  end;
end;

procedure Tarena15W.onBeginGame(var Message: TMessage);
var
  m: TGame;
  content: IAreaContent;
begin
  m := TGame.Create(Self,pvCnx,Message.WParam);
  content := TGameContent.Create(pvCnx,actKo,Message.WParam);
  TGameContent(content).Game := m;
  pvArena.Areas[Pred(Message.LParam)].Content := content;
  broadcastMessage(wm_displayDraw,m.sertab,m.sermtc);
end;

procedure Tarena15W.onCancelGame(var Message: TMessage);
begin
  refreshAllAction.Execute;
end;

procedure Tarena15W.onCategIsOver(var Message: TMessage);
begin
  inProgressCategorys;
end;

procedure Tarena15W.onColorsChanged(var Message: TMessage);
var
  i: Integer;
begin
  umpiresView.Color := getItemsColor(piUmpire);
  umpiresView.Refresh;
  for i := 0 to scrollCategs.ControlCount-1 do
    TArenaPanel(scrollCategs.Controls[i]).Refresh;
  pvArena.Repaint;
end;

procedure Tarena15W.onDisplayDraw(var Message: TMessage);
begin
  displayDraw(Message.WParam,Message.LParam);
end;

procedure Tarena15W.onEndGame(var Message: TMessage);
var
  m: TGame;
begin
  if Assigned(pvArena.Areas[Pred(Message.LParam)].Content) and (pvArena.Areas[Pred(Message.LParam)].Content.ContentType = actKo) then
  begin
    m := TGameContent(pvArena.Areas[Pred(Message.LParam)].Content).Game;
    if Assigned(m) then
      broadcastMessage(wm_displayDraw,m.sertab,m.sermtc);
  end;
  pvArena.Areas[Pred(Message.LParam)].Content := nil;
end;

procedure Tarena15W.onFilterGameEvent(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept := Dataset.FieldByName('stamtc').AsInteger = Pred(filterGamesBox.ItemIndex);
end;

procedure Tarena15W.onGameCatchResult(var Message: TMessage);
begin
  if not Assigned(saisie) then
    saisie := TsaisieW.Create(Self, pvCnx, pvTournament.Sertrn);
  saisie.editMatch(Message.WParam);
end;

procedure Tarena15W.onGameInfo(var Message: TMessage);
begin
  pvGame.ParamByName('sermtc').AsInteger := Message.WParam;
  pvGame.Open;
  try
    sb.Panels[Ord(pkCateg)].Text := pvGame.FieldByName('codcat').AsString;
    sb.Panels[Ord(pkPlayer1)].Text := pvGame.FieldByName('nomjo1').AsString;
    sb.Panels[Ord(pkPlayer2)].Text := pvGame.FieldByName('nomjo2').AsString;
    sb.Panels[Ord(pkArea)].Text := pvGame.FieldByName('numtbl').AsString;
    sb.Panels[Ord(pkUmpire)].Text := pvGame.FieldByName('umpireName').AsString;
  finally
    pvGame.Close;
  end;
end;

procedure Tarena15W.onGameIsOver(var Message: TMessage);
var
  i: integer;
begin
  for i := 0 to scrollCategs.ControlCount-1 do
    if TArenaPanel(scrollCategs.Controls[i]).SerCat = integer(Message.WParam) then
    begin
      TArenaPanel(scrollCategs.Controls[i]).Refresh;
    end;
  refreshUmpiresAction.Execute;
end;

//procedure Tarena15W.OnGameIsOverDatabaseEvent;
//var
//  i: integer;
//begin
//  for i := 0 to scrollCategs.ControlCount-1 do
//    TArenaPanel(scrollCategs.Controls[i]).Refresh;
//
//  refreshUmpiresAction.Execute;
//end;

procedure Tarena15W.onNoPlayAreaAvailable(var Message: TMessage);
begin
  sb.Panels[Ord(pkError)].Text := 'NO PLAY AREA AVAILABLE';
end;

procedure Tarena15W.onPlayAreaRefresh(var Message: TMessage);
var
  i: Integer;
begin
  if Message.WParam > 0 then
    pvArena.Areas[Pred(Message.WParam)].Status := TPlayAreaStatus(Message.LParam)
  else
  begin
    pvArena.Refresh;
    for i := 0 to scrollCategs.ControlCount-1 do
      TArenaPanel(scrollCategs.Controls[i]).Refresh;
  end;
end;

procedure Tarena15W.onPlayerIsBusy(var Message: TMessage);
begin
  pvPlayer.Params[0].AsInteger := Message.WParam;
  pvPlayer.Open;
  try
    if not pvPlayer.Eof then
      sb.Panels[Ord(pkError)].Text := Format('%s already playing at table %d',[pvPlayer.FieldByName('nomjou').AsString,Message.LParam])
    else
      sb.Panels[Ord(pkError)].Text := 'Un des joueurs est déjà engagé sur une autre table';
  finally
    pvPlayer.Close;
  end;
end;

procedure Tarena15W.onPlayerIsUmpire(var Message: TMessage);
begin
  pvPlayer.Params[0].AsInteger := Message.WParam;
  pvPlayer.Open;
  try
    if not pvPlayer.Eof then
      sb.Panels[Ord(pkError)].Text := Format('%s is umpire at table %d',[pvPlayer.FieldByName('nomjou').AsString,Message.LParam])
    else
      sb.Panels[Ord(pkError)].Text := 'Un des joueurs est arbitre sur une autre table';
  finally
    pvPlayer.Close;
  end;
end;

procedure Tarena15W.onPlayerStatus(var Message: TMessage);
begin
  pvPlayerStatus.Read(Message.WParam,Message.LParam);
  pvPlayerStatusW.Refresh;
end;

procedure Tarena15W.OnRefreshArenaDisplay(var Message: TMessage);
var
  area: TCollectionItem;
  content: IAreaContent;
begin
  for area in pvArena.Areas do
  begin
    content := TPlayArea(area).Content;
    if Assigned(content) and (Message.WParam = content.SerialContent) or (Message.LParam = TPlayArea(area).AreaNumber) then
    begin
      TPlayArea(area).Paint;
      TPlayArea(area).Panel.Repaint;
      Break;
    end;
  end;
end;

procedure Tarena15W.onUmpiresRefresh(var Message: TMessage);
begin
  refreshUmpiresAction.Execute;
end;

procedure Tarena15W.PopupMenu1Popup(Sender: TObject);
var
  item: TMenuItem;
begin
  PopupMenu1.Items.Clear;
  with TZReadOnlyQuery.Create(nil) do
  begin
    try
      Connection := pvCnx.get;
      SQL.Add('SELECT codcat,heudeb,sercat'
             +' FROM categories'
             +' WHERE sertrn = ' + pvTournament.Sertrn.ToString
//             +'   and stacat = ' + Ord(csDraw).ToString
             +Format('   AND stacat BETWEEN %d AND %d',[Ord(csGroup),Ord(csDraw)])
             +' ORDER BY 2,1');
      Open;
      while not Eof do
      begin
        item := TMenuItem.Create(Self);
        item.Caption := Fields[0].AsString;
        item.Tag := Fields[2].AsInteger;
        item.OnClick := runCateg;
        PopupMenu1.Items.Add(item);
        Next;
        Application.ProcessMessages;
      end;
      Close;
    finally
      Free;
    end;
  end;
end;

procedure Tarena15W.readLayout(trn: TTournament);
begin
end;

procedure Tarena15W.refreshAllActionExecute(Sender: TObject);
begin
  refreshUmpiresAction.Execute;
  inProgressCategorys;
  games;
end;

procedure Tarena15W.refreshUmpiresActionExecute(Sender: TObject);
begin
  umpires;
  resetFieldsFocus;
end;

procedure Tarena15W.resetFieldsFocus;
var
  i: integer;
begin
  for i := 0 to scrollCategs.ControlCount - 1 do
    if scrollCategs.Controls[i] is TArenaCategPanel then
      TArenaCategPanel(scrollCategs.Controls[i]).resetFieldFocus;
end;

procedure Tarena15W.runCateg(Sender: TObject);
var
  sercat: integer;
begin
  sercat := TComponent(Sender).Tag;
  updateCategoryStatut(sercat,csInProgress);  // must before inProgressCategorys because pvInProgressCategs.Refresh
  inProgressCategorys;
end;

procedure Tarena15W.sbDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
  const Rect: TRect);
const
  cf: array[TPanelKind] of TColor = (clBlack,clBlack,clBlack,clWhite,clBlack,clWhite);
begin
  with StatusBar.Canvas do
  begin
    Brush.Color := lcSBColors[TPanelKind(Panel.Index)];
    Font.Color := cf[TPanelKind(Panel.Index)];
    FillRect(Rect);
    Font.Style := [fsBold];
    TextOut(Rect.Left + 10, Rect.Top + 2, Panel.Text);
  end;
end;

procedure Tarena15W.scrollCategsResize(Sender: TObject);
var
  i: integer;
  p: TArenaPanel;
begin
  for i := 0 to scrollCategs.ControlCount - 1 do
  begin
    if scrollCategs.Controls[i] is TArenaPanel then
    begin
      p := TArenaPanel(scrollCategs.Controls[i]);
      p.Width := (categsPanel.ClientWidth - Pred(pvInProgressCategs.RecordCount)) div pvInProgressCategs.RecordCount;
    end;
  end;
end;

procedure Tarena15W.setUmpireActionExecute(Sender: TObject);
var
  z: TZReadOnlyQuery;
begin
  {: show a list of avalaible players }
  z := getROQuery(pvCnx);
  try
    z.SQL.Add('SELECT DISTINCT j.serjou,j.nomjou'
             +' FROM joueur j INNER JOIN insc i ON j.SERJOU = i.SERJOU'
             +' INNER JOIN tournoi t ON t.SERTRN = i.SERTRN'
             +' INNER JOIN CATEGORIES c ON i.SERCAT = c.SERCAT'
             +' WHERE i.sertrn = ' + pvTournament.Sertrn.ToString
             +' AND j.serjou NOT IN (SELECT m.serjo1 FROM MATCH m WHERE m.SERTRN = t.sertrn AND m.STAMTC = :gameStatus)'
             +' AND j.serjou NOT IN (SELECT m.serjo2 FROM MATCH m WHERE m.SERTRN = t.sertrn AND m.STAMTC = :gameStatus)'
             +' AND j.serjou NOT IN (SELECT serump FROM umpires u WHERE u.sertrn = t.sertrn AND u.serump = j.serjou)'
             +' ORDER BY 2');
    z.Params[0].AsInteger := Ord(gsInProgress);
    z.Open;
    with TdataGridW.Create(Self) do
    begin
      try
        source.DataSet := z;
        if ShowModal = mrOk then
        begin
          setAsUmpire(pvTournament.Sertrn,z.Fields[0].AsInteger,z.Fields[1].AsString,umpiresView.Selected.Caption.ToInteger());
          refreshUmpiresAction.Execute;
        end;
      finally
        Free;
      end;
    end;
    z.Close;
  finally
    z.Free;
  end;
end;

procedure Tarena15W.umpires;
var
  i: integer;
begin
  umpiresView.Color := getItemsColor(piUmpire);
  umpiresView.Items.BeginUpdate;
  try
    umpiresView.Items.Clear;
    pvUmpires.Open;
    try
      while not pvUmpires.Eof do
      begin
        with umpiresView.Items.Add do
        begin
          Caption := Format('%.2d', [pvUmpires.FieldByName('numtbl').AsInteger]);
          SubItems.Add(pvUmpires.FieldByName('umpire').AsString);
          SubItems.Add(pvUmpires.FieldByName('statbl').AsString);
          pvArena.Areas[Pred(pvUmpires.FieldByName('numtbl').AsInteger)].Status := TPlayAreaStatus(pvUmpires.FieldByName('statbl').AsInteger);
          SubItems.Add(pvUmpires.FieldByName('sermtc').AsString);
        end;
        pvUmpires.Next;
        Application.ProcessMessages;
      end;
    finally
      pvUmpires.Close;
    end;
  finally
    umpiresView.Items.EndUpdate;
  end;

  for i := 0 to scrollCategs.ControlCount-1 do
    TArenaPanel(scrollCategs.Controls[i]).Refresh;
end;

procedure Tarena15W.umpiresViewClick(Sender: TObject);
begin
  if (umpiresView.Selected <> nil) and (umpiresView.Selected.SubItems[0] <> '') then
  begin
    pvUmpire.ParamByName('nomjou').AsString := umpiresView.Selected.SubItems[0];
    pvUmpire.Open;
    try
      if not pvUmpire.Eof then
      begin
        broadcastMessage(wm_highLightPlayer,pvUmpire.Fields[0].AsInteger,0);
        broadcastMessage(wm_playerStatus,pvUmpire.Fields[0].AsInteger, pvTournament.Sertrn);
      end;
    finally
      pvUmpire.Close;
    end;
  end;
end;

procedure Tarena15W.umpiresViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  try
    if Item.Selected then
      Sender.Canvas.Brush.Color := clYellow
    else
      Sender.Canvas.Brush.Color := getUmpiresColor(TPlayAreaStatus(Item.SubItems[1].ToInteger));//getPlayAreasColor((Item.SubItems[1].ToInteger));
  except
    Sender.Canvas.Brush.Color := getItemsColor(piUmpire);
  end;
end;

procedure Tarena15W.umpiresViewSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  umpiresViewClick(Sender);
end;

procedure Tarena15W.unsetUmpireActionExecute(Sender: TObject);
begin
  setAsUmpire(pvTournament.Sertrn, 0,'',umpiresView.Selected.Caption.ToInteger());
  refreshUmpiresAction.Execute;
end;

procedure Tarena15W.ViewPlayerStatusActionExecute(Sender: TObject);
begin
  if not pvPlayerStatusW.Visible then
    pvPlayerStatusW.Show;
  pvPlayerStatusW.Refresh;
end;

procedure Tarena15W.ZIBEventAlerter1EventAlert(Sender: TObject;
  EventName: string; EventCount: Integer; var CancelAlerts: Boolean);
begin
  if EventName = cs_game_is_over then
  begin
    inProgressCategorys;
  end;
end;

procedure Tarena15W.detailPanelResize(Sender: TObject);
begin
  displayDraw(lcSertab, lcSermtc);
end;

procedure Tarena15W.displayDraw(const sertab,sermtc: integer);
var
  d: TDraw;
begin
  if (sertab = 0) and (sermtc = 0) then
    Exit
  else if (sertab = 0) and (sermtc > 0) then
  begin
    lcSermtc := sermtc;
    lcSerTab := 0;
    with getROQuery(pvCnx) do
    begin
      try
        SQL.Add('SELECT sertab FROM match WHERE sermtc = ' + sermtc.ToString);
        Open;
        if not IsEmpty then
          lcSertab := Fields[0].AsInteger;
        Close;
      finally
        Free;
      end;
    end;
  end
  else
  begin
    lcSertab := sertab;
    lcSermtc := sermtc;
  end;

  if (lcSertab = 0) and (lcSermtc = 0) then
    Exit;

  d := TDraw.Create(pvCnx,lcSertab,lcSermtc);
  try
    d.display(drawBox.Canvas);
  finally
    d.Free;
  end;
end;

procedure Tarena15W.drawBoxDblClick(Sender: TObject);
begin
  TdrawW.Create(Self, pvCnx, lcSertab, lcSermtc).Show;
end;

procedure Tarena15W.filterGames(const filtered: boolean);
var
  i: Integer;
begin
  for i := 0 to scrollCategs.ControlCount-1 do
  begin
    TArenaPanel(scrollCategs.Controls[i]).Dataset.Filtered := filtered;
    TArenaPanel(scrollCategs.Controls[i]).Refresh;
  end;
end;

procedure Tarena15W.filterGamesBoxChange(Sender: TObject);
begin
  filterGames(filterGamesBox.ItemIndex > 0);
end;

procedure Tarena15W.categGridFontSizeClick(Sender: TObject; Button: TUDBtnType);
var
  i: Integer;
begin
  for i := 0 to scrollCategs.ControlCount-1 do
    TArenaPanel(scrollCategs.Controls[i]).gridFontSize := categGridFontSize.Position;
end;

end.
