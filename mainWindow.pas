unit mainWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, System.Actions,
  Vcl.ActnList, childWindow, Vcl.Imaging.jpeg, Vcl.ExtCtrls, tmUtils15,
  lal_connection, ZConnection;

type
  TmainW = class(TForm)
    sb: TStatusBar;
    MainMenu1: TMainMenu;
    Fichier1: TMenuItem;
    openTournamentMenu: TMenuItem;
    newTournamentMenu: TMenuItem;
    N1: TMenuItem;
    databaseMenu: TMenuItem;
    newDatabaseMenu: TMenuItem;
    openDatabaseMenu: TMenuItem;
    N2: TMenuItem;
    settingMenu: TMenuItem;
    clubsMenu: TMenuItem;
    catageMenu: TMenuItem;
    classementsMenu: TMenuItem;
    handicapsMenu: TMenuItem;
    defaultValuesMenu: TMenuItem;
    N3: TMenuItem;
    Quitter1: TMenuItem;
    editMenu: TMenuItem;
    settingsMenu: TMenuItem;
    N4: TMenuItem;
    ActionList1: TActionList;
    newTournamentAction: TAction;
    openTournamentAction: TAction;
    newDatabaseAction: TAction;
    openDatabaseAction: TAction;
    settingsAction: TAction;
    clubsAction: TAction;
    classementsAction: TAction;
    catageAction: TAction;
    handicapsAction: TAction;
    closeTournamentAction: TAction;
    closeTournamentMenu: TMenuItem;
    defValuesAction: TAction;
    saisonsAction: TAction;
    saisonsMenu: TMenuItem;
    Window1: TMenuItem;
    Window2: TMenuItem;
    N5: TMenuItem;
    Styledefentre1: TMenuItem;
    deleteTournamentAction: TAction;
    Supprimeruntournoi1: TMenuItem;
    dictAction: TAction;
    Dictionnaire1: TMenuItem;
    SeekConfigsAction: TAction;
    SeekConfigs1: TMenuItem;
    SaveToFileAction: TAction;
    Savetofile1: TMenuItem;
    procedure Quitter1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure newDatabaseActionExecute(Sender: TObject);
    procedure openDatabaseActionExecute(Sender: TObject);
    procedure settingsActionExecute(Sender: TObject);
    procedure clubsActionExecute(Sender: TObject);
    procedure classementsActionExecute(Sender: TObject);
    procedure catageActionExecute(Sender: TObject);
    procedure handicapsActionExecute(Sender: TObject);
    procedure newTournamentActionExecute(Sender: TObject);
    procedure databaseMenuClick(Sender: TObject);
    procedure closeTournamentActionExecute(Sender: TObject);
    procedure Fichier1Click(Sender: TObject);
    procedure openTournamentActionExecute(Sender: TObject);
    procedure defValuesActionExecute(Sender: TObject);
    procedure saisonsActionExecute(Sender: TObject);
    procedure deleteTournamentActionExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure dictActionExecute(Sender: TObject);
    procedure SeekConfigsActionExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure SaveToFileActionExecute(Sender: TObject);
  private
    { Déclarations privées }
    _user,
    _password: string;
    pvVersion: single;
    pvFIB: TZConnection;
    pvCnx: TLalConnection;

    function getDatabase: string;
    procedure openDatabase(const filename: string);
    procedure createDatabase(const filename: string);
    function buildStyles: boolean;
    function getVersion: double;
    function makeVersion(const version: double): boolean; overload;
    procedure dbInfos;
    procedure colorsChanged(var Message: TMessage); message wm_colorsChanged;
    procedure LoadSettingsFromText(var Values: TStrings);
    function getSettingsValue(const setting, default: string): string;
    procedure setSettingsValue(const setting, value: string);
    procedure SaveSettingsToFile(const SettingsValues: TStrings;
      const Filename: TFilename);
  public
    { Déclarations publiques }
    property cnx: TLalConnection read pvCnx;
    property fib: TZConnection read pvFIB;
  end;

var
  mainW: TmainW;

implementation

{$R *.dfm}

uses
  Vcl.Themes, System.UITypes, lal_dbUtils, SeekConfigsWindow, TypInfo,
  clubsWindow, classementsWindow, catageWindow, handicapsWindow, tournamentWindow,
  defValuesWindow, saisonsWindow, DB, tournamentsWindow, Math, ZSequence,
  Vcl.GraphUtil, System.IOUtils, System.Types, ZDataset, lal_fbUtils,
  Generics.Collections, mmSystem, dicWindow, lal_seek, lal_utils,
  TMEnums, category;

procedure TmainW.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  settingsAction.Enabled := False;
  settingsAction.Visible := False;
  Handled := True;
end;

function TmainW.buildStyles: boolean;
var
  s: string;
  f: string;
begin
  Result := False;
//{$ifdef VER330 or HIGHER}
  s:= 'c:\work\styles\';
  if DirectoryExists(s) then
  begin
    for f in TDirectory.GetFiles(s, '*.vsf') do
    begin
      if TStyleManager.IsValidStyle(f) then
      begin
        TStyleManager.LoadFromFile(f);
        Result := True;
      end;
    end;
  end;
//{$endif}
end;

procedure TmainW.catageActionExecute(Sender: TObject);
begin
  with TcatageW.Create(Self,pvFIB) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TmainW.classementsActionExecute(Sender: TObject);
begin
  with TclassementsW.Create(Self,pvFIB) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TmainW.closeTournamentActionExecute(Sender: TObject);
begin
  if (MDIChildCount > 0) and Assigned(ActiveMDIChild) then
    ActiveMDIChild.Close;
end;

procedure TmainW.clubsActionExecute(Sender: TObject);
begin
  with TclubsW.Create(Self,pvFIB) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TmainW.colorsChanged(var Message: TMessage);
var
  i: Integer;
begin
  for i := 0 to Pred(MDIChildCount) do
    MDIChildren[i].Perform(wm_colorsChanged,0,0);
end;

procedure TmainW.createDatabase(const filename: string);
begin
  if (pvCnx.get.Connected) then
    pvCnx.get.Disconnect;
  lal_fbUtils.createFB25Database(pvFIB, filename,_user,_password);
  glSettings.Write('settings','database','pardc1',filename);
end;

procedure TmainW.databaseMenuClick(Sender: TObject);
begin
  openDatabaseAction.Enabled := Self.MDIChildCount = 0;
  newDatabaseAction.Enabled := openDatabaseAction.Enabled;
end;

procedure TmainW.dbInfos;
begin
  if pvCnx.get <> nil then
  begin
    sb.Panels[2].Text := Format('%s (%f)', [pvCnx.get.Database, pvVersion]);
    sb.Panels[3].Text := glSettings.WorkingDirectory;
    sb.Panels[4].Text := Format('user : %s, owner : %s',[pvCnx.get.User,Lowercase(pvCnx.owner)]);
  end;
end;

procedure TmainW.defValuesActionExecute(Sender: TObject);
begin
  with TdefvaluesW.Create(Self,pvFIB) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TmainW.deleteTournamentActionExecute(Sender: TObject);
var
  sel: TtournamentsW;
  sertrn: integer;
begin
  sertrn := 0;
  if MessageDlg('Confirmez-vous la suppression d''un tournoi ?', mtWarning, [mbYes,mbNo], 0, mbNo) = mrYes then
  begin
    sel := TtournamentsW.Create(nil,pvFIB);
    try
      if sel.ShowModal = mrOk then
        sertrn := sel.dataSource.DataSet.FieldByName('sertrn').AsInteger;
    finally
      sel.Free;
    end;
    if sertrn > 0 then
      if MessageDlg('Confirmez-vous la suppression du tournoi ?', mtWarning, [mbYes,mbNo], 0) = mrYes then
        deleteTournament(sertrn);
  end;
end;

procedure TmainW.dictActionExecute(Sender: TObject);
begin
  with TdicW.Create(Self, pvCnx) do
  begin
    try
      if ShowModal = mrOk then
      begin
        Screen.Cursor := crHourGlass;
        try
          initColorsArray;
          if colorsChanged then
            broadcastMessage(wm_colorsChanged,0,0);
        finally
          Screen.Cursor := crDefault;
        end;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TmainW.Fichier1Click(Sender: TObject);
begin
  closeTournamentAction.Enabled := False;
  if Assigned(ActiveMDIChild) and (ActiveMDIChild is TtournamentW) then
    closeTournamentAction.Enabled := not(TtournamentW(ActiveMDIChild).tournamentSource.DataSet.State in dsEditModes);
end;

procedure TmainW.FormActivate(Sender: TObject);
begin
  if (pvCnx.get.Database = '') or not(pvCnx.get.Connected) then
  begin
    MessageDlg('Sans connexion à une base de données, vous ne pouvez pas continuer', mtWarning, [mbOk], 0);
  end;
end;

procedure TmainW.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := MDIChildCount = 0;
end;

procedure TmainW.FormCreate(Sender: TObject);
begin
  pvFIB := TZConnection.Create(Self);
  pvCnx := TLalConnection.Create(Self,pvFIB);
  LoadSettingsFromText(glSettingsValues);
  if buildStyles then
  begin
    try
      if not IsDebuggerPresent  then
        TStyleManager.TrySetStyle('Lavender Classico',False)
      else
      begin
        TStyleManager.TrySetStyle('Luna');
        Caption := Format('%s -> %s',[Caption, 'DEBUG']);
      end;
    except
    end;
  end;
end;

procedure TMainW.LoadSettingsFromText(var Values: TStrings);
var
  Filename: TFilename;
begin
  Filename := ChangeFileExt(Application.ExeName,'.settings');
  if FileExists(Filename) then
    Values.LoadFromFile(Filename);
end;

procedure TmainW.FormDestroy(Sender: TObject);
var
  Filename: TFileName;
begin
  Filename := ChangeFileExt(Application.ExeName,'.settings');
  glSettings.Write;
  glSettings.Free;
end;

procedure TmainW.SaveSettingsToFile(const SettingsValues: TStrings; const Filename: TFilename);
begin
  SettingsValues.SaveToFile(Filename);
end;

procedure TmainW.SaveToFileActionExecute(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do
  begin
    try
      InitialDir := ExtractFilePath(ParamStr(0));
      Filter := 'Settings file (*.settings)|*.settings|All files (*.*)|*.*';
      FilterIndex := 1;
      if Execute then
        glSettings.SaveToFile(FileName);
    finally
      Free;
    end;
  end;
end;

procedure TmainW.FormShow(Sender: TObject);
var
  filename: string;
begin
  filename := getDatabase;
  if FileExists(filename) then
    openDatabase(filename);
  tmUtils15.setDatabaseLocalConnection(pvCnx);
  initColorsArray;
  glSettings := TTournamentSettings.Create(pvCnx, glSettingsValues);
  glSettings.Read;
  Caption := Format('%s (%s)',[ChangeFileExt(ExtractFilename(Application.ExeName), ''), GetAppVersion]);
  dbInfos;
end;


//function getSettingsValue(const setting, default: string): string;
//var
//  lcSettings: TStrings;
//  filename: string;
//begin
//  Result := '';
//  lcSettings := TStringList.Create;
//  try
//    filename := ChangeFileExt(Application.ExeName,'.settings');
//    if FileExists(filename) then
//    begin
//      lcSettings.LoadFromFile(filename);
//      Result := lcSettings.Values[setting];
//    end;
//    if Result = '' then
//      Result := default;
//  finally
//    lcSettings.Free;
//  end;
//end;
//
//procedure setSettingsValue(const setting, value: string);
//var
//  lcSettings: TStrings;
//  filename: string;
//begin
//  lcSettings := TStringList.Create;
//  try
//    filename := ChangeFileExt(Application.ExeName,'.settings');
//    if FileExists(filename) then
//      lcSettings.LoadFromFile(filename);
//    lcSettings.Values[setting] := Value;
//    lcSettings.SaveToFile(filename);
//  finally
//    lcSettings.Free;
//  end;
//end;

function TmainW.getDatabase: string;
var
  reponse: word;
begin
  Result := getSettingsValue('database','');
  if (Result = '') or not(FileExists(Result)) then
  begin
    reponse := MessageDlg('Voulez-vous choisir une base de données existante ?', mtConfirmation, [mbYes,mbNo,mbCancel],0);
    case reponse  of
      mrYes : begin
        with TOpenDialog.Create(Self) do
        begin
          try
            Filter := 'Firebird databases|*.fdb';
            FilterIndex := 1;
            if Execute then
            begin
              setSettingsValue('database',Filename);
              Result := Filename;
            end;
          finally
            Free;
          end;
        end;
        if FileExists(Result) then
          Result := getDatabase;
      end;

      mrNo : begin
        if MessageDlg('Voulez-vous créer une base de données ?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then
        begin
          with TOpenDialog.Create(Self) do
          begin
            try
              Options := Options - [ofNoTestFileCreate];
              Filter := 'Firebird databases|*.fdb';
              FilterIndex := 1;
              DefaultExt := '.fdb';
              if Execute then
              begin
                Result := Filename;
                setSettingsValue('database',Result);
              end;
            finally
              Free;
            end;
          end;
          createDatabase(Result);
        end;
      end;

      mrCancel : begin
        Result := '';
      end;
    end;
  end;
end;

function TmainW.getSettingsValue(const setting, default: string): string;
var
  lcSettings: TStrings;
  filename: string;
begin
  Result := glSettingsValues.Values[setting];
  if Result = '' then
  begin
    lcSettings := TStringList.Create;
    try
      filename := ChangeFileExt(Application.ExeName,'.settings');
      if FileExists(filename) then
      begin
        lcSettings.LoadFromFile(filename);
        Result := lcSettings.Values[setting];
      end;
      if Result = '' then
        Result := default;
    finally
      lcSettings.Free;
    end;
  end;
end;

procedure TmainW.setSettingsValue(const setting, value: string);
//var
//  lcSettings: TStrings;
//  filename: string;
begin
  glSettingsValues.Values[setting] := Value;
//  lcSettings := TStringList.Create;
//  try
//    filename := ChangeFileExt(Application.ExeName,'.settings');
//    if FileExists(filename) then
//      lcSettings.LoadFromFile(filename);
//    lcSettings.Values[setting] := Value;
//    lcSettings.SaveToFile(filename);
//  finally
//    lcSettings.Free;
//  end;
end;

function TmainW.getVersion: double;
var
  v: double;
  i: Integer;
  s: string;
begin
  Result := 0;
  if (ParamCount >= 2) then
  begin
    for i := 1 to ParamCount do
    begin
      if (ParamStr(i).ToLower = '-v') then
        if (i < ParamCount) then
        begin
          s := ParamStr(i+1);
          if (TryStrToFloat(s,Result)) then
            Exit;
        end;
    end;
  end;

  with getROQuery(pvCnx) do
  begin
    try
      sql.Add('SELECT COUNT(*) FROM rdb$relations'
             +' WHERE rdb$view_blr IS NULL'
             +'   AND (rdb$system_flag IS NULL OR rdb$system_flag = 0)'
             +'   AND UPPER(rdb$relation_name) = ''DICTIONNAIRE''');
      Open;
      if Fields[0].AsInteger = 1 then
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT pardc1 FROM dictionnaire'
               +' WHERE cledic = ''database'''
               +'   AND coddic = ''version''');
        Open;
        if not isEmpty then
          v := StrToFloat(Format('%.2f',[Fields[0].AsFloat]))
        else
          v := 0.0;
        Result := v;
      end;
      Close;
    finally
      Free;
    end;
  end;
end;

procedure TmainW.handicapsActionExecute(Sender: TObject);
begin
  with ThandicapsW.Create(Self,pvFIB) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TmainW.newDatabaseActionExecute(Sender: TObject);
begin
  if MessageDlg('Voulez-vous créer une base de données ?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then
  begin
    with TOpenDialog.Create(Self) do
    begin
      try
        Options := Options - [ofNoTestFileCreate];
        Filter := 'Firebird databases|*.fdb';
        FilterIndex := 1;
        DefaultExt := '.fdb';
        if Execute then
        begin
          setSettingsValue('database',Filename);
        end;
      finally
        Free;
      end;
    end;
    createDatabase(getSettingsValue('database',''));
    dbInfos;
  end;
end;

procedure TmainW.newTournamentActionExecute(Sender: TObject);
begin
  TtournamentW.Create(Self,pvCnx,0).Show;
end;

procedure TmainW.openDatabase(const filename: string);
begin
  loadDatabase(pvFIB,filename);
  setSettingsValue('database',filename);
  pvVersion := getVersion;
  if makeVersion(pvVersion) then
  begin
    MessageDlg('La base de données a changé de format ! Il faut relancer l''application.',mtInformation,[mbOk],0);
    Application.Terminate;
    Exit;
  end
  else
    dropTempTables(pvCnx);
end;

procedure TmainW.openDatabaseActionExecute(Sender: TObject);
begin
  with TOpenDialog.Create(Self) do
  begin
    try
      Filter := 'Firebird databases|*.fdb';
      FilterIndex := 1;
      Options := Options + [ofFileMustExist];
      if Execute then
      begin
        if pvCnx.get.Connected then
          pvCnx.get.Disconnect;
        setSettingsValue('database',Filename);
        openDatabase(Filename);
      end;
    finally
      Free;
    end;
  end;
end;

procedure TmainW.openTournamentActionExecute(Sender: TObject);
begin
  TtournamentW.Create(Self,pvCnx,-1).Show;
end;

procedure TmainW.Quitter1Click(Sender: TObject);
begin
  Close;
end;

procedure TmainW.saisonsActionExecute(Sender: TObject);
begin
  with TsaisonsW.Create(Self,pvFIB) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TmainW.SeekConfigsActionExecute(Sender: TObject);
begin
  with TSeekConfigsW.Create(Self,pvCnx.get) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TmainW.settingsActionExecute(Sender: TObject);
begin
//  with TsettingsW.Create(Self,pvCnx) do
//  begin
//    try
//      if ShowModal = mrOk then
//      begin
////        _settings.Assign(generalList.Strings);
//      end;
//    finally
//      Free;
//    end;
//  end;
end;

function TmainW.makeVersion(const version: double): boolean;
var
  z: TZReadOnlyQuery;
  xsql: TStrings;
  s: string;
  col: TTableColumnDef;
  i: Integer;
  procedure runSQL(sql: string); overload;
  begin
    if Trim(sql) = '' then Exit;
    z.SQL.Clear;
    z.SQL.Add(sql);
    z.ExecSQL;
  end;
  procedure runSQL(sql: TStrings); overload;
  var
    i: Integer;
  begin
    for i := 0 to Pred(sql.Count) do
      runSQL(sql[i]);
    sql.Clear;
  end;
  procedure runSQL(sql: string; const fieldName: string; var returnValue: integer); overload;
  begin
    if Trim(sql) = '' then
      Exit;
    z.SQL.Clear;
    z.SQL.Add(sql);
    z.Open;
    if not z.Eof then
      returnValue := z.FieldByName(fieldName).AsInteger;
  end;
  procedure AddEnum(enum: PTypeInfo);
  var
    EnumName: TSymbolName;
    Data: PTypeData;
    z: TZReadOnlyQuery;
    var i: integer;
  begin
    EnumName := enum.Name;
    Data := enum.TypeData;
    z := TZReadOnlyQuery.Create(nil);
    try
      z.Connection := pvFIB;
      z.SQL.Add('UPDATE OR INSERT INTO dictionnaire (cledic,coddic,pardc1)'
               +' VALUES (:cledic,:coddic,:pardc1)');
      z.Prepare;
      z.ParamByName('cledic').AsString := string(EnumName);
      for i := Data.MinValue to Data.MaxValue do
      begin
        z.ParamByName('coddic').AsString := GetEnumName(enum, i);
        z.ParamByName('pardc1').AsInteger := i;
        z.ExecSQL;
      end;
    finally
      z.Free;
    end;
  end;
  procedure AddSeekConfig(id: integer; const description,source,params,returns,seek_code,fieldname: string; seek_mode: integer); overload;
  begin
    if id = 0 then
    begin
      with TZSequence.Create(nil) do
      begin
        try
          Connection := pvFIB;
          SequenceName := 'SEEK_GEN_ID';
          id := GetNextValue;
        finally
          Free;
        end;
      end;
    end;

    RunSQL('UPDATE OR INSERT INTO seek_config (id,description,source,params,returning,seek_code,fieldname,seek_mode)'
          +' VALUES ('
          +Format('%d,%s,%s,%s,%s,%s,%s,%d',[ id
                                             ,description.QuotedString
                                             ,source.QuotedString
                                             ,params.QuotedString
                                             ,returns.QuotedString
                                             ,seek_code.QuotedString
                                             ,fieldname.QuotedString
                                             ,seek_mode])
          +')');
  end;
  procedure AddSeekConfig(enum: PTypeInfo); overload;
  var
    EnumName,
    Source,
    Params: string;
    id: integer;
  begin
    EnumName := GetEnumerationName(enum);
    id := 0;
    with getROQuery(pvCnx) do
    begin
      try
        SQL.Add('SELECT id FROM seek_config'
               +' WHERE UPPER(description) = :description');
        Params[0].AsString := EnumName.ToUpper;
        Open;
        if not Eof then
          id := Fields[0].AsInteger;
      finally
        Free;
      end;
    end;
    Source := Format('SELECT coddic,libdic,pardc1 FROM dictionnaire'
                    +' WHERE cledic = :cledic'
                    +' ORDER BY pardc1',[]);
    Params := 'cledic='+EnumName;
    AddSeekConfig(id,EnumName,Source,Params,'coddic=coddic',EnumName,'coddic',0);
  end;
  function updateDatabaseVersion(oldVersion, newVersion: double): boolean;
  begin
    runSQL(Format('update dictionnaire set pardc1 = %.2f',[newVersion])
          +Format(' where cledic = %s and coddic = %s and pardc1 = %.2f',['database'.QuotedString,'version'.QuotedString, oldVersion]));
    Result := True;
  end;
begin
  Result := tmUtils15.makeVersion(version);
  if Result  then
    Exit;

  z := getROQuery(pvCnx);
  try
    if version = 0 then
    begin
      runSQL('CREATE TABLE dictionnaire ('
            +'  cledic VARCHAR(30) NOT NULL,'
            +'  coddic VARCHAR(30) NOT NULL,'
            +'  libdic VARCHAR(40),'
            +'  pardc1 VARCHAR(30),'
            +'  pardc2 VARCHAR(30),'
            +'  pardc3 VARCHAR(30),'
            +'  pardc4 VARCHAR(30),'
            +'  pardc5 VARCHAR(30),'
            +'  pardc6 VARCHAR(30),'
            +'  pardc7 VARCHAR(30),'
            +'  pardc8 VARCHAR(30),'
            +'  pardc9 VARCHAR(30));');

      runSQL('CREATE UNIQUE INDEX i01_dictionnaire ON dictionnaire (cledic,coddic);');

      runSQL('INSERT INTO dictionnaire (cledic,coddic, pardc1) VALUES (''database'',''version'',''0'');');

      runSQL('CREATE TABLE classement ('
            +'  codcls VARCHAR(3) NOT NULL'
            +' ,libcls VARCHAR(20) NOT NULL'
            +' ,numseq SMALLINT NOT NULL'
            +' ,catage CHAR(1)'
            +' ,PRIMARY KEY(codcls))');

      xsql := TStringList.Create;
      try
        xsql.Add('INSERT INTO classement (codcls,libcls,numseq,catage) VALUES (''A1'',''A1'',10,0)');
        xsql.Add('INSERT INTO classement (codcls,libcls,numseq,catage) VALUES (''A2'',''A2'',12,0)');
        xsql.Add('INSERT INTO classement (codcls,libcls,numseq,catage) VALUES (''A3'',''A3'',14,0)');
        xsql.Add('INSERT INTO classement (codcls,libcls,numseq,catage) VALUES (''B1'',''B1'',20,0)');
        xsql.Add('INSERT INTO classement (codcls,libcls,numseq,catage) VALUES (''B2'',''B2'',22,0)');
        xsql.Add('INSERT INTO classement (codcls,libcls,numseq,catage) VALUES (''B3'',''B3'',24,0)');
        xsql.Add('INSERT INTO classement (codcls,libcls,numseq,catage) VALUES (''C1'',''C1'',30,0)');
        xsql.Add('INSERT INTO classement (codcls,libcls,numseq,catage) VALUES (''C2'',''C2'',32,0)');
        xsql.Add('INSERT INTO classement (codcls,libcls,numseq,catage) VALUES (''C3'',''C3'',34,0)');
        xsql.Add('INSERT INTO classement (codcls,libcls,numseq,catage) VALUES (''D1'',''D1'',40,0)');
        xsql.Add('INSERT INTO classement (codcls,libcls,numseq,catage) VALUES (''D2'',''D2'',42,0)');
        xsql.Add('INSERT INTO classement (codcls,libcls,numseq,catage) VALUES (''D3'',''D3'',44,0)');
        xsql.Add('INSERT INTO classement (codcls,libcls,numseq,catage) VALUES (''PM'',''Préminime'',100,1)');
        xsql.Add('INSERT INTO classement (codcls,libcls,numseq,catage) VALUES (''M'',''Minime'',102,1)');
        xsql.Add('INSERT INTO classement (codcls,libcls,numseq,catage) VALUES (''C'',''Cadet'',104,1)');
        xsql.Add('INSERT INTO classement (codcls,libcls,numseq,catage) VALUES (''J'',''Juniors'',106,1)');
        xsql.Add('INSERT INTO classement (codcls,libcls,numseq,catage) VALUES (''U21'',''U21'',108,1)');
        xsql.Add('INSERT INTO classement (codcls,libcls,numseq,catage) VALUES (''S'',''Senior'',110,1)');
        xsql.Add('INSERT INTO classement (codcls,libcls,numseq,catage) VALUES (''V'',''Vétéran'',112,1)');
        pvCnx.startTransaction;
        try
          runSQL(xsql);
          pvCnx.commit;
        except
          pvCnx.rollback;
          raise;
        end;
        runSQL('CREATE INDEX i01_classement ON classement(numseq)');

        runSQL('CREATE TABLE catage ('
              +'  catage VARCHAR(3) NOT NULL'
              +' ,saison SMALLINT NOT NULL'
              +' ,inferieur SMALLINT'
              +' ,superieur SMALLINT'
              +' ,PRIMARY KEY(catage,saison))');

        xsql.Add('INSERT INTO catage (catage,saison,inferieur,superieur) VALUES (''PM'' ,2018,2007,null)');
        xsql.Add('INSERT INTO catage (catage,saison,inferieur,superieur) VALUES (''M''  ,2018,2005,2006)');
        xsql.Add('INSERT INTO catage (catage,saison,inferieur,superieur) VALUES (''C''  ,2018,2003,2004)');
        xsql.Add('INSERT INTO catage (catage,saison,inferieur,superieur) VALUES (''J''  ,2018,2000,2002)');
        xsql.Add('INSERT INTO catage (catage,saison,inferieur,superieur) VALUES (''U21'',2018,1997,1999)');
        xsql.Add('INSERT INTO catage (catage,saison,inferieur,superieur) VALUES (''S''  ,2018,1978,1996)');
        xsql.Add('INSERT INTO catage (catage,saison,inferieur,superieur) VALUES (''V''  ,2018,NULL,1977)');
        pvCnx.startTransaction;
        try
          runSQL(xsql);
          pvCnx.commit;
        except
          pvCnx.rollback;
          raise;
        end;

        runSQL('CREATE TABLE tournoi ('
              +' sertrn integer not null'
              +',saison smallint not null'
              +',dattrn date not null'
              +',organisateur varchar(40) not null'
              +',libelle varchar(60) not null'
              +',maxcat smallint not null'
              +',primary key(sertrn))');
        runSQL('create index i01_tournoi on tournoi (saison)');
        runSQL('create index i02_tournoi on tournoi (dattrn);');

        runSQL('create table categories ('
              +' sercat integer not null'
              +',sertrn integer not null'
              +',saison smallint not null'
              +',codcat varchar(20) not null'
              +',heudeb char(5) not null'
              +',simple char(1) not null'
              +',handicap char(1) not null'
              +',numset smallint not null'
              +',catage char(1) not null'
              +',stacat char(1) not null'
              +',numseq smallint'
              +',primary key(sercat))');
        runSQL('create index i01_categories on categories(sertrn,numseq)');

        runSQL('create table categories_classement ('
              +' sercat integer not null'
              +',codcls varchar(3) not null'
              +',catage char(1) not null'
              +',primary key(sercat,codcls,catage))');

        runSQL('create table joueur ('
              +' serjou integer not null'
              +',saison smallint not null'
              +',licence varchar(8) not null'
              +',codclb varchar(3) not null'
              +',nomjou varchar(40) not null'
              +',codcls varchar(3) not null'
              +',topcls varchar(3) not null'
              +',topdem varchar(3) not null'
              +',datann date'
              +',catage varchar(3)'
              +',vrbrgl smallint not null'
              +',primary key(serjou))');
        runSQL('create unique index i01_joueur on joueur (licence,saison)');

        runSQL('create table insc ('
              +' serinsc integer not null'
              +',sercat integer not null'
              +',"double" char(1) not null'
              +',serjou integer not null'
              +',serptn integer'
              +',statut char(1) not null'
              +',primary key (serinsc))');
        runSQL('create index i01_insc on insc (sercat,"double",serjou,serptn)');

        runSQL('create table tableau ('
              +' sertab integer not null'
              +',taille smallint not null'
              +',nbrjou smallint not null'
              +',nbrtds smallint not null'
              +',primary key(sertab))');

        runSQL('create table adv ('
              +' seradv integer not null'
              +',serjou integer not null'
              +',serptn integer not null'
              +',numseq smallint not null'
              +',primary key(seradv))');

        runSQL('create table match ('
              +' sermtc integer not null'
              +',sertab integer not null'
              +',level  smallint not null'
              +',numseq smallint not null'
              +',datmtc date not null'
              +',heure varchar(5)'
              +',serjo1 integer not null'
              +',serjo2 integer not null'
              +',handi1 smallint'
              +',handi2 smallint'
              +',score varchar(3)'
              +',vainqueur integer'
              +',perdant integer'
              +',numtbl varchar(3)'
              +',prochain integer not null'
              +',stamtc char(1) not null'
              +',primary key(sermtc))');
        runSQL('create index i01_match on match (sertab,level,numseq)');
        runSQL('create index i02_match on match (serjo1)');
        runSQL('create index i03_match on match (serjo2)');

        runSQL('create table tablo ('
              +'	serblo integer not null,'
              +'	sertab integer not null,'
              +'	serjou integer,'
              +'	licence varchar(17),'
              +'	nomjou varchar(40),'
              +'	codclb varchar(8),'
              +'	libclb varchar(40),'
              +'	codcls varchar(7),'
              +'	vrbrgl smallint,'
              +'	numtds smallint,'
              +'	numrow smallint,'
              +'	sertrn integer not null,'
              +'	primary key (serblo))');
        runsql('create index i01_tablo on tablo (sertab,numtds)');
        runsql('create index i02_tablo on tablo (sertab,numrow)');
        runsql('create index i03_tablo on tablo (sertab,codcls);');
        runsql('create index i04_tablo on tablo (sertab,codclb);');
        runsql('create index i05_tablo on tablo (sertab,serjou);');

        runSQL('update dictionnaire set pardc1 = 1 where cledic = ''database'' and coddic = ''version''');
      finally
        xsql.Free;
      end;
      Result := True;
    end
    else
    if version = 1 then
    begin
      runSQL('alter table match add nummtc varchar(6) not null');
      runSQL('update dictionnaire set pardc1 = 2 where cledic = ''database'' and coddic = ''version'' and pardc1 = 1');
      Result := True;
    end
    else
    if version = 2 then
    begin
      runSQL('alter table match add games varchar(60) not null');
      runSQL('alter table match add sertrn integer not null');
      runSQL('alter table match add woj1 char(1) default 0');
      runSQL('alter table match add woj2 char(1) default 0');
      runSQL('alter table match add modifie timestamp');
      runSQL('create index i04_match on match(sertab,nummtc)');

      runSQL('update dictionnaire set pardc1 = 3 where cledic = ''database'' and coddic = ''version'' and pardc1 = 2');
      Result := True;
    end
    else
    if version = 3 then
    begin
      runSQL('alter table tournoi add codcls char(6)');
      runSQL('alter table tournoi add expcol varchar(8)');

      runSQL('update dictionnaire set pardc1 = 4 where cledic = ''database'' and coddic = ''version'' and pardc1 = 3');
      runSQL('drop table categories_classement');
      runSQL('drop table adv');
      runSQL('create table categories ('
            +' sercat integer not null'
            +',sertrn integer not null'
            +',saison smallint not null'
            +',codcat varchar(20) not null'
            +',heudeb char(5) not null'
            +',simple char(1) not null'
            +',handicap char(1) not null'
            +',numset smallint not null'
            +',catage char(1) not null'
            +',stacat char(1) not null'
            +',numseq smallint'
            +',primary key(sercat))');
      runSQL('create index i01_categories on categories(sertrn,numseq)');
      runSQL('create table classements ('
            +'  sercat integer not null'
            +' ,codcls varchar(3) not null'
            +' ,sertrn integer not null'
            +' ,primary key (sercat,codcls))');
      runSQL('create table club ('
            +'  codclb varchar(3) not null'
            +' ,libclb varchar(30) not null'
            +' ,primary key (codclb))');
      runSQL('create table defvalues ('
            +'  tablename varchar(25) not null'
            +' ,colname varchar(25) not null'
            +' ,defvalue varchar(25)'
            +' ,primary key (tablename,colname))');
      runSQL('create table doublons ('
            +'  licence varchar(13) not null'
            +' ,serjo1 integer'
            +' ,serjo2 integer'
            +' ,tablo varchar(20) not null'
            +' ,primary key(licence,tablo))');
      runSQL('create table handicap ('
            +'  cl1 varchar(3) not null'
            +' ,cl2 varchar(3) not null'
            +' ,hdc smallint not null'
            +' ,primary key(cl1,cl2))');
       runSQL('alter table insc add datinsc char(16) not null');
       runSQL('alter table insc add simple char(1) not null');
       runSQL('drop index i01_insc');
       runSQL('alter table insc drop "double"');
       runSQL('create index i01_insc on insc (sercat,simple,serjou,serptn)');
       Result := True;
    end
    else
    if version = 4 then
    begin

       runSQL('create table prptab ('
             +'	serprp integer not null,'
             +'	sertab integer not null,'
             +'	sertrn integer not null,'
             +'	serjou integer,'
             +'	serptn integer,'
             +'	licence varchar(17),'
             +'	nomjou varchar(40),'
             +'	codclb varchar(8),'
             +'	libclb varchar(40),'
             +'	seqcls smallint,'
             +'	codcls varchar(7),'
             +'	classement varchar(3),'
             +'	vrbrgl smallint,'
             +'	numtds smallint,'
             +'	serblo integer,'
             +' primary key (serprp))');
       runSQL('create index i01_prptab on prptab (sertab,numtds);');
       runSQL('create index i02_prptab on prptab (sertab,serjou);');
       runSQL('create index i03_prptab on prptab (sertab,codcls);');
       runSQL('create index i04_prptab on prptab (sertab,seqcls);');

       runSQL('create table saison ('
             +'  saison smallint not null'
             +' ,libelle varchar(11) not null'
             +' ,active char(1) not null'
             +' ,primary key(saison))');

       runSQL('create table temptables ('
             +' tablename varchar(16) not null'
             +' ,primary key(tablename))');

      runSQL('update dictionnaire set pardc1 = 5 where cledic = ''database'' and coddic = ''version'' and pardc1 = 4');
      Result := True;
    end
    else
    if version = 5 then
    begin
      runSQL('create sequence categorie');
      runSQL('create sequence inscription');
      runSQL('create sequence joueur');
      runSQL('create sequence tournoi');
      Result := updateDatabaseVersion(version,version+1);
    end
    else
    if version = 6 then
    begin
      xsql := TStringList.Create;
      try
        xsql.Add('INSERT INTO HANDICAP (CL1,CL2,HDC) VALUES (''A1'',''A1'',0)');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''A2'',''A1'',1);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''A2'',''A2'',0);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''A3'',''A1'',2);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''A3'',''A2'',2);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''B1'',''A1'',2);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''B1'',''A2'',2);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''B1'',''A3'',2);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''B2'',''A1'',3);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''B2'',''A2'',3);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''B2'',''A3'',3);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''B2'',''B1'',2);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''B3'',''A1'',4);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''B3'',''A2'',4);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''B3'',''A3'',4);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''B3'',''B1'',3);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''B3'',''B2'',2);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C1'',''A1'',5);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C1'',''A2'',5);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C1'',''A3'',5);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C1'',''B1'',4);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C1'',''B2'',3);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C1'',''B3'',2);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C2'',''A1'',6);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C2'',''A2'',6);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C2'',''A3'',6);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C2'',''B1'',5);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C2'',''B2'',4);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C2'',''B3'',3);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C2'',''C1'',2);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C3'',''A1'',7);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C3'',''A2'',7);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C3'',''A3'',7);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C3'',''B1'',6);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C3'',''B2'',5);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C3'',''B3'',4);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C3'',''C1'',3);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''C3'',''C2'',2);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D1'',''A1'',8);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D1'',''A2'',8);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D1'',''A3'',8);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D1'',''B1'',7);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D1'',''B2'',6);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D1'',''B3'',5);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D1'',''C1'',4);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D1'',''C2'',3);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D1'',''C3'',2);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D2'',''A1'',9);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D2'',''A2'',9);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D2'',''A3'',9);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D2'',''B1'',8);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D2'',''B2'',7);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D2'',''B3'',6);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D2'',''C1'',5);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D2'',''C2'',4);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D2'',''C3'',3);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D2'',''D1'',2);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D3'',''A1'',9);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D3'',''A2'',9);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D3'',''A3'',9);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D3'',''B1'',9);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D3'',''B2'',8);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D3'',''B3'',7);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D3'',''C1'',6);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D3'',''C2'',5);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D3'',''C3'',4);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D3'',''D1'',3);');
        xsql.Add('insert into handicap (cl1,cl2,hdc) values (''D3'',''D2'',2);');
        xsql.Add('insert into defvalues (tablename,colname,defvalue) values (''tournoi'',''maxcat'',''3'')');
        xsql.Add('insert into defvalues (tablename,colname,defvalue) values (''tournoi'',''codcls'',''topdem'')');
        xsql.Add('insert into defvalues (tablename,colname,defvalue) values (''categories'',''simple'',''1'')');
        xsql.Add('insert into defvalues (tablename,colname,defvalue) values (''categories'',''handicap'',''0'')');
        xsql.Add('insert into defvalues (tablename,colname,defvalue) values (''categories'',''numset'',''3'')');
        xsql.Add('insert into defvalues (tablename,colname,defvalue) values (''categories'',''catage'',''0'')');
        pvCnx.startTransaction;
        try
          runSQL(xsql);
          Result := updateDatabaseVersion(version,version+1);
          pvCnx.commit;
        except
          pvCnx.rollback;
          raise;
        end;
      finally
        xsql.Free;
      end
    end
    else
    if version = 7 then
    begin
      runSQL('alter table catage add numseq smallint not null');
      Result := updateDatabaseVersion(version,version+1);
    end
    else
    if version = 8 then
    begin
      runSQL('alter table classement add selcls varchar(3) not null');
      runSQL('update classement set selcls = codcls where 1 = 1');
      runSQL('update classement set selcls = ''A'' where selcls like ''A%''');
      Result := updateDatabaseVersion(version,version+1);
    end
    else
    if version = 9 then
    begin
      runSQL('alter table tournoi add numtbl smallint default 10 not null');
      Result := updateDatabaseVersion(version,version+1);
    end
    else
    if version = 10.0 then
    begin
      if not tableExists(pvCnx,'umpires') then
        runSQL('CREATE TABLE umpires ('
              +'  sertrn INTEGER NOT NULL'
              +' ,numtbl SMALLINT NOT NULL'
              +' ,serump INTEGER'
              +' ,umpire VARCHAR(40)'
              +' ,statbl CHAR(1) NOT NULL'
              +' ,sermtc INTEGER'
              +' ,prvmtc INTEGER'
              +' ,PRIMARY KEY(sertrn,numtbl))');

      if not IndexExists(pvCnx, 'i02_joueur') then
        runsql('CREATE INDEX i02_joueur ON joueur (nomjou)');

      if not PKExists(pvCnx,'dictionnaire') then
        RunSQL('ALTER TABLE dictionnaire ADD CONSTRAINT pk_dictionnaire PRIMARY KEY (cledic,coddic)');

      pvCnx.startTransaction;
      try
        s := Format('UPDATE OR INSERT INTO dictionnaire (cledic,coddic,pardc1) VALUES (%s,%s,%s)',['colors'.QuotedString,
                                                                                                   'vainqueur'.QuotedString,
                                                                                                   ColorToString(clAqua).QuotedString]);
        xsql := TStringList.Create;
        try
          xsql.Add(s);
          s := Format('UPDATE OR INSERT INTO dictionnaire (cledic,coddic,pardc1) VALUES (%s,%s,%s)',['colors'.QuotedString,
                                                                                                    'perdant'.QuotedString,
                                                                                                    ColorToString(clYellow).QuotedString]);
          xsql.Add(s);
          runSQL(xsql);
          pvCnx.commit;
        finally
          xsql.Free;
        end;
      except
        pvCnx.rollback;
        raise;
      end;

      if not tableColumnExists(pvCnx, 'tournoi', 'codclb') then
         RunSQL('ALTER TABLE tournoi ADD codclb VARCHAR(3) NOT NULL');

      pvCnx.startTransaction;
      try

        RunSQL('UPDATE OR INSERT INTO dictionnaire (cledic,coddic) VALUES (''dictionnaire'',''rules'')');
        RunSQL('UPDATE OR INSERT INTO dictionnaire (cledic,coddic,pardc1) VALUES (''rules'',''pointsOfASet'',''11'')');
        RunSQL('UPDATE OR INSERT INTO dictionnaire (cledic,coddic,pardc1) VALUES (''rules'',''bestOf'',''5'')');
        Result := updateDatabaseVersion(version,version+1);
        pvCnx.commit;
      except
        pvCnx.rollback;
        raise;
      end;
    end
    else
    if version = 11 then
    begin
      RunSQL('UPDATE tournoi SET codclb = ''EXP'''
            +' WHERE codclb IS NULL');
      Result := updateDatabaseVersion(version,version+1);
    end
    else
    if version = 12 then
    begin
      RunSQL(Format('UPDATE OR INSERT INTO dictionnaire (cledic,coddic,libdic,pardc1)'
                   +' VALUES (%s,%s,%s,%s)',['settings'.QuotedString,
                                             'qualification'.QuotedString,
                                             'K-O direct=0,Qualif=1 au premier tour'.QuotedString,
                                             GetEnumerationNameFromValue(TypeInfo(TFirstRoundMode),Ord(frKO)).QuotedString]));
      AddDatabaseTableColumn(cnx,'tournoi','first_round_mode','smallint');
      AddDatabaseTableColumn(cnx,'categories','first_round_mode','smallint');
      if not tableColumnExists(pvCnx, 'seek_config', 'seek_code') then
      begin
        RunSQL('ALTER TABLE seek_config ADD temp VARCHAR(16)');
        RunSQL('UPDATE seek_config SET temp = code_seek WHERE 1=1');
        RunSQL('ALTER TABLE seek_config DROP code_seek');
        RunSQL('ALTER TABLE seek_config ADD seek_code VARCHAR(30)');
        RunSQL('UPDATE seek_config SET seek_code = temp WHERE 1=1');
        RunSQL('ALTER TABLE seek_config DROP temp');
      end;
      cnx.startTransaction;
      try
        runSQL('UPDATE tournoi SET first_round_mode = 0 WHERE first_round_mode IS NULL');
        runSQL('UPDATE categories SET first_round_mode = 0 WHERE first_round_mode IS NULL');
        RunSQL('DELETE FROM seek_config');
        AddSeekConfig(1,'Liste des clubs','SELECT codclb,libclb FROM club ORDER BY libclb','','',cs_code_club_seek_code,'libclb',1);
        AddSeekConfig(2,'Liste des classements','SELECT codcls,libcls,selcls FROM classement WHERE catage = :catage ORDER BY numseq','catage=0','',cs_code_classement_seek_code,'codcls',1);
        AddSeekConfig(3,'Liste des saisons','SELECT active,libelle,saison FROM saison ORDER BY active DESC, saison','','',cs_saison_seek_code,'saison',0);
        AddEnum(TypeInfo(TCategorysStatus));
        AddEnum(TypeInfo(TGameStatus));
        AddEnum(TypeInfo(TPlayAreaStatus));
        AddEnum(TypeInfo(TRegistrationStatus));
        AddEnum(TypeInfo(TFirstRoundMode));
        AddSeekConfig(TypeInfo(TCategorysStatus));
        AddSeekConfig(TypeInfo(TGameStatus));
        AddSeekConfig(TypeInfo(TPlayAreaStatus));
        AddSeekConfig(TypeInfo(TRegistrationStatus));
        AddSeekConfig(TypeInfo(TFirstRoundMode));
        i := -1;
        RunSQL('SELECT MAX(id) id FROM seek_config','id',i);
        if i > -1 then
          RunSQL('ALTER SEQUENCE seek_gen_id RESTART WITH ' + IntToStr(i));
        updateDatabaseVersion(version,version+1);
        cnx.commit;
        Result := True;
      except
        cnx.rollback;
        raise;
      end;
    end
    else
    if version = 13 then
    begin
      if not tableColumnExists(cnx, 'prptab', 'sergrp') then
      begin
        RunSQL('ALTER TABLE prptab ADD sergrp INTEGER');
      end;
      cnx.startTransaction;
      try
        if not tableColumnExists(cnx, 'prptab', 'is_qualified') then
        begin
          RunSQL('ALTER TABLE prptab ADD is_qualified CHAR(1) DEFAULT ''1'' NOT NULL CHECK(UPPER(is_qualified) IN (''0'',''1''))');
          cnx.commit;
          cnx.startTransaction;
          RunSQL('UPDATE prptab SET is_qualified = 1 WHERE 1=1');
        end;
        if not tableExists(cnx,'groupe') then
        begin
          RunSQL('CREATE SEQUENCE seq_sergrp');
          RunSQL('CREATE TABLE groupe ('
                +'   sergrp INTEGER NOT NULL'
                +'  ,sercat INTEGER NOT NULL'
                +'  ,numgrp SMALLINT NOT NULL'
                +'  ,stagrp CHAR(1) DEFAULT ''0'' NOT NULL CHECK(UPPER(stagrp) IN (''0'',''1'',''2''))'
                +'  ,sertrn INTEGER NOT NULL'
                +'  ,CONSTRAINT pk_groupe PRIMARY KEY (sergrp)'
                +'  ,CONSTRAINT fk_groupe_sercat FOREIGN KEY (sercat) REFERENCES categories'
                +'  ,CONSTRAINT fk_groupe_sertrn FOREIGN KEY (sertrn) REFERENCES tournoi'
                +')');
        end;
        if not tableExists(cnx, 'compo_groupe') then
        begin
          RunSQL('CREATE TABLE compo_groupe ('
                +'   sergrp INTEGER NOT NULL'
                +'  ,numseq SMALLINT NOT NULL'
                +'  ,serjou INTEGER'
                +'  ,sercat INTEGER NOT NULL'
                +'  ,sertrn INTEGER NOT NULL'
                +'  ,CONSTRAINT pk_compo_groupe PRIMARY KEY(sergrp,numseq)'
                +'  ,CONSTRAINT fk_compo_groupe_sercat FOREIGN KEY (sercat) REFERENCES categories'
                +'  ,CONSTRAINT fk_compo_groupe_sertrn FOREIGN KEY (sertrn) REFERENCES tournoi'
                +')');
        end;
        if not tableColumnExists(cnx,'tableau','nbrgrp') then
        begin
          RunSQL('ALTER TABLE tableau ADD nbrgrp SMALLINT DEFAULT 0 NOT NULL');
          cnx.commit;
          cnx.startTransaction;
          RunSQL('UPDATE tableau SET nbrgrp = 0 WHERE 1=1');
        end;
        if not tableExists(cnx,'match_groupe') then
        begin
          RunSQL('CREATE TABLE match_groupe ('
                +'   sermtc INTEGER NOT NULL'
                +'  ,sergrp INTEGER NOT NULL'
                +'  ,sercat INTEGER NOT NULL'
                +'  ,sertrn INTEGER NOT NULL'
                +'  ,CONSTRAINT pk_match_groupe PRIMARY KEY (sermtc)'
                +'  ,CONSTRAINT fk_match_groupe_sercat FOREIGN KEY (sercat) REFERENCES categories'
                +'  ,CONSTRAINT fk_match_groupe_sertrn FOREIGN KEY (sertrn) REFERENCES tournoi'
                +')');
        end;

        if not ConstraintExists(cnx, 'fk_match_groupe_sermtc') then
          RunSQL('ALTER TABLE match_groupe ADD CONSTRAINT fk_match_groupe_sermtc FOREIGN KEY (sermtc) REFERENCES match');

        if not TriggerExists(cnx,'bd_match_groupe') then
          RunSQL('CREATE TRIGGER bd_match_groupe FOR match'
                +' ACTIVE BEFORE DELETE POSITION 0 '
                +'AS BEGIN'
                +'    DELETE FROM match_groupe WHERE sermtc = OLD.sermtc;'
                +'END');

        if not tableColumnExists(cnx, 'categories','phase') then
        begin
          RunSQL('ALTER TABLE categories ADD phase CHAR(1) DEFAULT ''0'' NOT NULL CHECK (phase IN (''0'',''1''))');
          cnx.commit;
          RunSQL('UPDATE categories SET phase = 0 WHERE first_round_mode = 0');
          RunSQL('UPDATE categories SET phase = 1 WHERE first_round_mode = 1');
        end;

        if not tableColumnExists(cnx, 'groupe', 'heure') then
        begin
          RunSQL('ALTER TABLE groupe ADD heure VARCHAR(5)');
          cnx.commit;
        end;

        AddEnum(TypeInfo(TQualificationGroupStatus));

        with getROQuery(cnx) do
        begin
          try
            SQL.Add('SELECT trim(cc.rdb$constraint_name), COUNT(*)'
                   +' FROM rdb$relation_constraints rc'
                   +' JOIN rdb$check_constraints cc ON rc.rdb$constraint_name = cc.rdb$constraint_name'
                   +' JOIN rdb$triggers trg ON cc.rdb$trigger_name = trg.rdb$trigger_name'
                   +' WHERE rc.rdb$constraint_type = ''CHECK'''
                   +' AND UPPER(trg.RDB$TRIGGER_SOURCE) LIKE ''CHECK(UPPER(STAGRP)%'''
                   +' AND   trg.rdb$trigger_type = 1'
                   +' group by 1');
            Open;
            if not(Eof) and (Fields[1].AsInteger = 1) then
            begin
              cnx.startTransaction;
              RunSQL('ALTER TABLE groupe DROP CONSTRAINT ' + Fields[0].AsString);
              cnx.commit;
              Close;
              cnx.startTransaction;
              RunSQL('ALTER TABLE groupe ADD CONSTRAINT chk_groupe_stagrp CHECK(stagrp IN (''0'',''1'',''2'',''3'',''4''))');
              cnx.commit;
            end
            else
            begin
              try RunSQL('ALTER TABLE groupe ADD CONSTRAINT chk_groupe_stagrp CHECK(stagrp IN (''0'',''1'',''2'',''3'',''4''))'); except end;
            end;
            if Active then Close;
          finally
            Free;
          end;
        end;

        if not TableExists(cnx, 'groupe_result') then
        begin
          cnx.startTransaction;
          RunSQL('CREATE TABLE groupe_result ('
                +'   sergrp INTEGER NOT NULL'
                +'  ,serjou INTEGER NOT NULL'
                +'  ,seradv INTEGER'
                +'  ,winner SMALLINT NOT NULL'
                +'  ,games  SMALLINT NOT NULL'
                +'  ,points SMALLINT NOT NULL'
                +'  ,sercat INTEGER NOT NULL'
                +'  ,sertrn INTEGER NOT NULL)');
          cnx.commit;
          runSQL('CREATE UNIQUE INDEX i01_groupe_result ON groupe_result (sergrp,serjou,seradv)');
        end;

        if not tableColumnExists(cnx, 'groupe', 'winner') then
        begin
          cnx.startTransaction;
          AddDatabaseTableColumn(cnx, 'groupe', 'winner', 'INTEGER');
          AddDatabaseTableColumn(cnx, 'groupe', 'umpire', 'INTEGER');
          cnx.commit;
        end;

        col.clear;
        col.TableName := 'categories';
        col.ColumnName := 'parent';
        col.DataType := 'integer';
        col.Default := 'DEFAULT 0';
        col.NotNull := 'NOT NULL';
        AddDatabaseTableColumn(cnx, col);
        runSQL('UPDATE categories SET parent = 0 WHERE parent IS NULL');

        updateDatabaseVersion(version,version+1);
        cnx.commit;
        Result := True;
      except
        cnx.rollback;
        raise;
      end;
    end
    else
    if version = 14 then
    begin
      xsql := TStringList.Create;
      try
        xsql.Add('CREATE TRIGGER trg_game_01 FOR match');
        xsql.Add(' ACTIVE AFTER UPDATE POSITION 0');
        xsql.Add(' AS BEGIN');
        xsql.Add('   IF ((NEW.stamtc <> OLD.stamtc) AND (new.stamtc = ' + Ord(gsOver).ToString+')) THEN');
        xsql.Add('     POST_EVENT ' + QuotedStr(cs_game_is_over)+';');
        xsql.Add(' END');
        RunSQL(xsql.Text);
        updateDatabaseVersion(version,version+1);
        cnx.commit;
      finally
        xsql.Free;
      end;
    end
    else
    if version = 15 then
    begin
      RunSQL('ALTER TABLE seek_config ALTER return TO returning');
      updateDatabaseVersion(version,version+1);
      cnx.commit;
    end
    else
    if version = 16 then
    begin
      RunSQL('ALTER TABLE tournoi         ADD CONSTRAINT fk_tournoi_saison          FOREIGN KEY (saison) REFERENCES saison (saison)');
      RunSQL('ALTER TABLE catage          ADD CONSTRAINT fk_catage_saison           FOREIGN KEY (saison) REFERENCES saison (saison)');
      RunSQL('ALTER TABLE joueur          ADD CONSTRAINT fk_joueur_saison           FOREIGN KEY (saison) REFERENCES saison (saison)');
      RunSQL('ALTER TABLE categories      ADD CONSTRAINT fk_categories_tournoi      FOREIGN KEY (sertrn) REFERENCES tournoi (sertrn)');
      RunSQL('ALTER TABLE classements     ADD CONSTRAINT fk_classements_tournoi     FOREIGN KEY (sertrn) REFERENCES tournoi (sertrn)');
      RunSQL('ALTER TABLE groupe_result   ADD CONSTRAINT fk_groupe_result_tournoi   FOREIGN KEY (sertrn) REFERENCES tournoi (sertrn)');
      RunSQL('ALTER TABLE insc            ADD CONSTRAINT fk_insc_tournoi            FOREIGN KEY (sertrn) REFERENCES tournoi (sertrn)');
      RunSQL('ALTER TABLE match           ADD CONSTRAINT fk_match_tournoi           FOREIGN KEY (sertrn) REFERENCES tournoi (sertrn)');
      RunSQL('ALTER TABLE prptab          ADD CONSTRAINT fk_prptab_tournoi          FOREIGN KEY (sertrn) REFERENCES tournoi (sertrn)');
      RunSQL('ALTER TABLE tableau         ADD CONSTRAINT fk_tableau_tournoi         FOREIGN KEY (sertrn) REFERENCES tournoi (sertrn)');
      RunSQL('ALTER TABLE tablo           ADD CONSTRAINT fk_tablo_tournoi           FOREIGN KEY (sertrn) REFERENCES tournoi (sertrn)');
      RunSQL('ALTER TABLE umpires         ADD CONSTRAINT fk_umpires_tournoi         FOREIGN KEY (sertrn) REFERENCES tournoi (sertrn)');
      RunSQL('ALTER TABLE classements     ADD CONSTRAINT fk_classements_categorie   FOREIGN KEY (sercat) REFERENCES categories (sercat)');
      RunSQL('ALTER TABLE groupe_result   ADD CONSTRAINT fk_groupe_result_categorie FOREIGN KEY (sercat) REFERENCES categories (sercat)');
      RunSQL('ALTER TABLE insc            ADD CONSTRAINT fk_insc_categorie          FOREIGN KEY (sercat) REFERENCES categories (sercat)');
      RunSQL('ALTER TABLE joueur          ADD CONSTRAINT fk_joueur_club             FOREIGN KEY (codclb) REFERENCES club (codclb)');
      RunSQL('ALTER TABLE groupe_result   ADD CONSTRAINT fk_groupe_result           FOREIGN KEY (serjou) REFERENCES joueur (serjou)');
      RunSQL('ALTER TABLE insc            ADD CONSTRAINT fk_insc_joueur             FOREIGN KEY (serjou) REFERENCES joueur (serjou)');
      RunSQL('ALTER TABLE compo_groupe    ADD CONSTRAINT fk_compo_groupe_joueur     FOREIGN KEY (serjou) REFERENCES joueur (serjou)');
      RunSQL('ALTER TABLE match           ADD CONSTRAINT fk_match_tableau           FOREIGN KEY (sertab) REFERENCES tableau (sertab)');
      RunSQL('ALTER TABLE prptab          ADD CONSTRAINT fk_prptab_tableau          FOREIGN KEY (sertab) REFERENCES tableau (sertab)');
      RunSQL('ALTER TABLE tablo           ADD CONSTRAINT fk_tablo_tableau           FOREIGN KEY (sertab) REFERENCES tableau (sertab)');
      updateDatabaseVersion(version,version+1);
      cnx.commit;
    end
    else
    if version = 17 then
    begin
      RunSQL('ALTER TABLE dictionnaire ALTER COLUMN pardc1 TYPE VARCHAR(100)');
      updateDatabaseVersion(version,version+1);
      cnx.commit;
    end;
  finally
    z.Free;
  end;
end;

end.
