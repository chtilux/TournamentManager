unit matchWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ZDataset, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Mask, Vcl.Buttons,
  tmUtils15, lal_connection, TMEnums, Game;

type
  TmatchW = class(TForm)
    mtcSource: TDataSource;
    tabSource: TDataSource;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    codcat: TDBText;
    level: TDBText;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    numtbl: TEdit;
    nomjo1: TDBEdit;
    nomjo2: TDBEdit;
    codcl1: TDBEdit;
    codcl2: TDBEdit;
    handi1: TDBEdit;
    handi2: TDBEdit;
    Label7: TLabel;
    scoreEdit: TEdit;
    nomvqr: TEdit;
    score: TEdit;
    okButton: TBitBtn;
    cancelButton: TBitBtn;
    score_1_1: TEdit;
    score_2_1: TEdit;
    score_1_2: TEdit;
    score_2_2: TEdit;
    score_1_3: TEdit;
    score_2_3: TEdit;
    score_1_4: TEdit;
    score_2_4: TEdit;
    score_1_5: TEdit;
    score_2_5: TEdit;
    score_1_6: TEdit;
    score_2_6: TEdit;
    score_1_7: TEdit;
    score_2_7: TEdit;
    score1: TEdit;
    score2: TEdit;
    woj1: TCheckBox;
    woj2: TCheckBox;
    games: TEdit;
    saisieBox: TRadioGroup;
    Label8: TLabel;
    DBText1: TDBText;
    arbitre: TLabel;
    Label9: TLabel;
    sermtc: TDBText;
    cancelGameButton: TBitBtn;
    changePlayAreaButton: TBitBtn;
    PointsEdit: TEdit;
    procedure FormDestroy(Sender: TObject);
    procedure numtblKeyPress(Sender: TObject; var Key: Char);
    procedure scoreEditKeyPress(Sender: TObject; var Key: Char);
    procedure saisieBoxClick(Sender: TObject);
    procedure woj1Click(Sender: TObject);
    procedure woj2Click(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure scoreEditExit(Sender: TObject);
    procedure cancelGameButtonClick(Sender: TObject);
    procedure numtblExit(Sender: TObject);
    procedure changePlayAreaButtonClick(Sender: TObject);
  private
    { Déclarations privées }
    _tab: TZReadOnlyQuery;
    _match: TGame;
    pvCnx: TLalConnection;
    function getGameResult: TGameResult;
    procedure clearScores;
    procedure cancelGame;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent; cnx: TLalConnection; match: TGame); reintroduce; overload;
    function analyseScore(score: string; method: TScoreMethod): boolean;
    property gameResult: TGameResult read getGameResult;
    property match: TGame read _match;
  end;

implementation

{$R *.dfm}

uses
  lal_dbUtils, UITypes;

{ TmatchW }

function TmatchW.analyseScore(score: string; method: TScoreMethod): Boolean;
var
  i: Integer;
  edt: TEdit;
begin
  clearScores;
  score := Trim(score);
  if Length(score) = 0 then
  begin
    Result := False;
    Exit;
  end
  else
  begin
    Result := _match.analyzeScore(score,method);
    if Result then
    begin
      score1.Text := Format('%d',[_match.gameResult.score[1]]);
      score2.Text := Format('%d',[_match.gameResult.score[2]]);
      case method of
        smGames: begin
          for i := 1 to Pred(2*match.SetsToWin) do
          begin
            edt := TEdit(FindComponent(Format('score_1_%d',[i])));
            edt.Text := IntToStr(match.gameResult.games[i].score[1]);
            edt := TEdit(FindComponent(Format('score_2_%d',[i])));
            edt.Text := IntToStr(match.gameResult.games[i].score[2]);
          end;
          PointsEdit.Text := Format('%.2d-%.2d',[match.gameResult.points[1],match.gameResult.points[2]]);
        end;
        smSets: ;
      end;
      games.Text := _match.gameResult.asPoints;
      nomvqr.Text := _match.WinnerName;
    end;
  end;
end;

procedure TmatchW.cancelGame;
begin
  tmUtils15.cancelGame(_match.sermtc);
end;

procedure TmatchW.cancelGameButtonClick(Sender: TObject);
begin
  if MessageDlg('Do you really want to cancel the game ?', mtConfirmation, [mbYes,mbNo],0) = mrYes then
  begin
    cancelGame;
    ModalResult := mrOk;
  end;
end;

procedure TmatchW.changePlayAreaButtonClick(Sender: TObject);
begin
  { if play area number has been updated, need to updates umpires }
  if (match.prioPAN <> 0) and (match.prioPAN <> string(numtbl.Text).ToInteger) then
  begin
    with getROQuery(pvCnx) do
    begin
      try
        SQL.Add('UPDATE umpires SET'
               +'  sermtc = 0'
               +' ,statbl = :statbl'
               +' WHERE sertrn = :sertrn'
               +'   AND numtbl = :numtbl');
        ParamByName('statbl').AsInteger := Ord(pasAvailable);
        ParamByName('sertrn').AsInteger := match.sertrn;
        ParamByName('numtbl').AsInteger := match.prioPAN;
        pvCnx.startTransaction;
        try
          ExecSQL;
          SQL.Clear;
          SQL.Add('UPDATE match SET numtbl = :numtbl'
                 +'  ,stamtc = :stamtc'
                 +'  ,modifie = CURRENT_TIMESTAMP'
                 +' WHERE sermtc = :sermtc');
          ParamByName('numtbl').AsInteger := string(numtbl.Text).ToInteger;
          ParamByName('stamtc').AsInteger := Ord(gsInProgress);
          ParamByName('sermtc').AsInteger := match.sermtc;
          ExecSQL;
          SQL.Clear;
          SQL.Add('UPDATE umpires SET'
                 +'  sermtc = :sermtc'
                 +' ,statbl = :statbl'
                 +' WHERE sertrn = :sertrn'
                 +'   AND numtbl = :numtbl');
          ParamByName('sermtc').AsInteger := match.sermtc;
          ParamByName('statbl').AsInteger := Ord(pasBusy);
          ParamByName('sertrn').AsInteger := match.sertrn;
          ParamByName('numtbl').AsInteger := string(numtbl.Text).ToInteger;
          ExecSQL;
          pvCnx.commit;
          broadcastMessage(wm_endGame,match.sermtc,match.prioPAN);
          broadcastMessage(wm_beginGame,match.sermtc,match.playAreaNumber);
          broadcastMessage(wm_umpiresRefresh,0,0);
          ModalResult := mrOk;
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

procedure TmatchW.clearScores;
var
  i: integer;
begin
  for i := 1 to Pred(2*_tab.FieldByName('numset').AsInteger) do
  begin
    TEdit(FindComponent(Format('score_1_%d',[i]))).Clear;
    TEdit(FindComponent(Format('score_2_%d',[i]))).Clear;
  end;
  score1.Clear;
  score2.Clear;
  nomvqr.Clear;
  games.Clear;
  PointsEdit.Clear;
end;

constructor TmatchW.Create(AOwner: TComponent; cnx: TLalConnection; match: TGame);
var
  i: integer;
begin
  inherited Create(AOwner);
  pvCnx := cnx;
  _match := match;
  mtcSource.DataSet := _match.Dataset;

  _tab := getROQuery(pvCnx,Self);
  _tab.SQL.Add('SELECT codcat,simple,handicap,numset,phase'
              +' FROM categories'
              +' WHERE sercat = :sertab');
  _tab.DataSource := mtcSource;
  _tab.Open;
  tabSource.DataSet := _tab;

  saisieBox.ItemIndex := StrToInt(glSettings.Read('settings.matchWindow','saisieBox','pardc1','0'));
//  saisieBox.ItemIndex := StrToInt(getSettingsValue('saisieBox','0'));
  for i := 2*_tab.FieldByName('numset').AsInteger to 7 do
  begin
    TEdit(FindComponent(Format('score_1_%d',[i]))).Visible := False;
    TEdit(FindComponent(Format('score_2_%d',[i]))).Visible := False;
  end;
  numtbl.Text := match.playAreaNumber.ToString;
  woj1.Enabled := (_tab.FieldByName('phase').AsInteger = Ord(frKO)) and (match.Dataset.FieldByName('serjo1').AsInteger > 0);
  woj2.Enabled := (_tab.FieldByName('phase').AsInteger = Ord(frKO)) and (match.Dataset.FieldByName('serjo2').AsInteger > 0);
  score.Text := match.Dataset.FieldByName('score').AsString;
  games.Text := match.Dataset.FieldByName('games').AsString;
  nomvqr.Text := match.WinnerName;
  arbitre.Caption := match.LoserName;

  if not IsDebuggerPresent then
    scoreEdit.Clear;

  if match.Dataset.FieldByName('stamtc').Value = gsOver then
  begin
    if _tab.FieldByName('phase').AsInteger = Ord(frQualification) then
      saisieBox.ItemIndex := Ord(smGames)
    else if saisieBox.ItemIndex = Ord(smGames) then
      scoreEdit.Text := games.Text
    else if saisieBox.ItemIndex = Ord(smSets) then
      scoreEdit.Text := score.Text;
  end;
end;

procedure TmatchW.FormDestroy(Sender: TObject);
begin
  glSettings.Write('settings.matchWindow','saisieBox','pardc1',IntToStr(saisieBox.ItemIndex));
//  setSettingsValue('saisieBox',IntToStr(saisieBox.ItemIndex));
end;

function TmatchW.getGameResult: TGameResult;
begin
  Result := _match.gameResult;
end;

procedure TmatchW.numtblExit(Sender: TObject);
begin
  { check play area is available }
  with getROQuery(pvCnx) do
  begin
    try
      if match.prioPAN <> string(numtbl.Text).ToInteger then
      begin
        SQL.Add('SELECT statbl FROM umpires WHERE numtbl = :numtbl'
               +' AND sertrn = :sertrn');
        Params[0].AsInteger := string(numtbl.Text).ToInteger;
        Params[1].AsInteger := match.sertrn;
        Open;
        if not Eof then
        begin
          if Fields[0].AsInteger <> Ord(pasAvailable) then
          begin
            MessageDlg('These play area is not available !', mtError, [mbOk], 0);
            numtbl.Text := match.prioPAN.ToString;
            Abort;
          end;
        end
        else
        begin
          MessageDlg('Incorrect play area number !', mtError, [mbOk], 0);
          numtbl.Text := match.prioPAN.ToString;
          Abort;
        end;
      end;
    finally
      Free;
    end;
  end;
  match.playAreaNumber := StrToInt(numtbl.Text);
  changePlayAreaButton.Enabled := (match.prioPAN > 0) and (match.playAreaNumber <> match.prioPAN);
  okButton.Enabled := okButton.Enabled or (numtbl.Text <> '');
end;

procedure TmatchW.numtblKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL,0,0);
  end;
end;

procedure TmatchW.okButtonClick(Sender: TObject);
begin
  if (match.gameResult.isOk) or (match.playAreaNumber <> 0) then
  begin
    if match.write then
      ModalResult := mrOk;
  end;
end;

procedure TmatchW.saisieBoxClick(Sender: TObject);
begin
  scoreEdit.SetFocus;
end;

procedure TmatchW.scoreEditExit(Sender: TObject);
begin
  okButton.Enabled := analyseScore(Trim(scoreEdit.Text),TScoreMethod(saisieBox.ItemIndex));
  if okButton.Enabled then
    okButton.SetFocus;
end;

procedure TmatchW.scoreEditKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    if scoreEdit.Modified then
      okButton.Enabled := analyseScore(Trim(scoreEdit.Text),TScoreMethod(saisieBox.ItemIndex));
    if okButton.Enabled then
      okButton.SetFocus;
  end;
end;

procedure TmatchW.woj1Click(Sender: TObject);
begin
  if woj2.Checked then
  begin
    if woj1.Checked then
      woj1.Checked := False;
    Abort;
  end;
  scoreEdit.Clear;
  clearScores;
  if woj1.Checked then
  begin
    nomvqr.Text := match.setWO(1,woLose);
    score2.Text := IntToStr(match.SetsToWin);
    score1.Text := 'W-O';
  end
  else
  begin
    match.resetWO;
    nomvqr.Clear;
    score2.clear;
    score1.clear;
  end;
  okButton.Enabled := match.gameResult.isOk;
end;

procedure TmatchW.woj2Click(Sender: TObject);
begin
  if woj1.Checked then
  begin
    if woj2.Checked then
      woj2.Checked := False;
    Abort;
  end;
  scoreEdit.Clear;
  clearScores;
  if woj2.Checked then
  begin
    nomvqr.Text := match.setWO(2,woLose);
    score1.Text := IntToStr(match.SetsToWin);
    score2.Text := 'W-O'
  end
  else
  begin
    match.resetWO;
    nomvqr.Clear;
    score2.clear;
    score1.clear;
  end;
  okButton.Enabled := match.gameResult.isOk;
end;

end.
