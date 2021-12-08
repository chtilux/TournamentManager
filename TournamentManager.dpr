program TournamentManager;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  mainWindow in 'mainWindow.pas' {mainW},
  dataWindow in 'dataWindow.pas' {dataW},
  clubsWindow in 'clubsWindow.pas' {clubsW},
  classementsWindow in 'classementsWindow.pas' {classementsW},
  catageWindow in 'catageWindow.pas' {catageW},
  handicapsWindow in 'handicapsWindow.pas' {handicapsW},
  childWindow in 'childWindow.pas' {childW},
  tournamentWindow in 'tournamentWindow.pas' {tournamentW},
  tournamentsWindow in 'tournamentsWindow.pas' {tournamentsW},
  defValuesWindow in 'defValuesWindow.pas' {defvaluesW},
  saisonsWindow in 'saisonsWindow.pas' {saisonsW},
  tabloWindow in 'tabloWindow.pas' {tabloW},
  joueursNonPlacesWindow in 'joueursNonPlacesWindow.pas' {joueursNonPlacesW},
  addAPlayerWindow in 'addAPlayerWindow.pas' {addAPlayerW},
  matchWindow in 'matchWindow.pas' {matchW},
  inscJoueur in 'inscJoueur.pas' {inscJouW},
  umpiresWindow in 'umpiresWindow.pas' {umpiresW},
  SeedsWindow in 'SeedsWindow.pas' {SeedsW},
  saisieWindow in 'saisieWindow.pas' {saisieW},
  internetWindow in 'internetWindow.pas',
  getTableNumberDialog in 'getTableNumberDialog.pas' {getTableNumberDlg},
  clscatageWindow in 'clscatageWindow.pas' {clscatageW},
  colorsDialog in 'colorsDialog.pas' {colorsDlg},
  dataGridWindow in 'dataGridWindow.pas' {dataGridW},
  dicWindow in 'dicWindow.pas' {dicW},
  tmUtils15 in 'tmUtils15.pas',
  arena15Window in 'arena15Window.pas' {arena15W},
  ArenaCategoryPanel in 'ArenaCategoryPanel.pas',
  draw in 'draw.pas',
  drawWindow in 'drawWindow.pas' {drawW},
  manualDrawWindow in 'manualDrawWindow.pas' {manualDrawW},
  SeekConfigsWindow in 'SeekConfigsWindow.pas' {SeekConfigsW},
  PlayerStatusWindow in 'PlayerStatusWindow.pas' {PlayerStatusW},
  PlayerPathWindow in 'PlayerPathWindow.pas' {PlayerPathW},
  groupPanel in 'groupPanel.pas',
  ArenaQualificationPanel in 'ArenaQualificationPanel.pas',
  Swap2PlayersWindow in 'Swap2PlayersWindow.pas' {Swap2PlayersW},
  ArenaPanel in 'ArenaPanel.pas',
  TMEnums in 'TMEnums.pas',
  Tournament in 'Tournament.pas',
  Arena in 'Arena.pas',
  PlayArea in 'PlayArea.pas',
  AreaContent in 'AreaContent.pas',
  Game in 'Game.pas',
  Group in 'Group.pas',
  category in 'category.pas',
  lal_ZQuerysManager in 'lal_ZQuerysManager.pas',
  lal_ZObject in 'lal_ZObject.pas',
  tm.AuscheidungsGroup in 'tm.AuscheidungsGroup.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainW, mainW);
  Application.Run;
end.
