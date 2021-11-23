unit ArenaCategoryPanel;

interface

uses
  Classes, Vcl.ExtCtrls, lal_connection, ZDataset, ZAbstractRODataset, Db,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, tmUtils15, Windows, Winapi.Messages,
  ArenaPanel;

type
  TArenaCategPanel = class(TArenaPanel)
  private
    pvData: TZReadOnlyQuery;
    pvGames: TZReadOnlyQuery;
    pvIsUmpire: TZReadOnlyQuery;
    pvIsPlaying: TZReadOnlyQuery;
    pvSerJouToHighLight: integer;
    pvTimer: TTimer;
    function GetDrawSize: smallint;
  protected
    { virtual ones }
    procedure SetGridFontSize(const Value: integer); override;
    function GetGridFontSize: integer;               override;

    procedure categDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; AState: TGridDrawState);
    procedure gridColEnter(Sender: TObject);
    procedure gridCellClick(Column: TColumn);
    {: adjust dbgrid's column width }
    procedure ResizeColumns(Sender: TObject);
    {: enter the Panel }
    procedure enterPanel(Sender: TObject);
    {: double-click on FGrid to activate a game }
    procedure GridDblClick(Sender: TObject);
    {: on keypress vk_return set inProgress or catch result }
    procedure GridKeyPress(Sender: TObject; var Key: Char);
    {: to reset field focus }
    procedure GridMouseLeave(Sender: TObject);
    procedure GridOnHighlightPlayer(var Message: TMessage); message wm_highLightPlayer;
    procedure onHighlightTimer(Sender: TObject);
  public
    constructor Create(AOwner: TComponent; cnx: TLalConnection; const sercat: integer); override;
    procedure Refresh; override;
    procedure resetFieldFocus;
    property drawSize: smallint read GetDrawSize;
    property gridFontSize: integer read GetGridFontSize write SetgridFontSize;
  end;

implementation

uses
  Vcl.Graphics, System.SysUtils, Vcl.Controls, getTableNumberDialog, Vcl.Forms,
  TMEnums, System.UITypes;

{ TCategPanel }

procedure TArenaCategPanel.categDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; AState: TGridDrawState);
var
  f: TField;
  cl: TColor;
begin
  with TDBGrid(Sender),TDBGrid(Sender).Canvas,TDBGrid(Sender).DataSource.DataSet do
  begin
    if not Eof then
    begin
      Brush.Color := getGameColor(TGameStatus(FieldByName('stamtc').AsInteger));
    end;
    if (FieldByName('serjo1').AsInteger = pvSerJouToHighLight) or
       (FieldByName('serjo2').AsInteger = pvSerJouToHighLight) then
    begin
      Brush.Color := clBlack;
      Font.Color := clWhite;
      Font.Style := [fsBold];
    end;

    f := nil;
    {: umpire oder busy (playing) }
    if (UpperCase(Column.FieldName) = 'NOMJO1') or (UpperCase(Column.FieldName) = 'SERJO1') then
      f := FieldByname('serjo1')
    else if (UpperCase(Column.FieldName) = 'NOMJO2') or (UpperCase(Column.FieldName) = 'SERJO2') then
      f := FieldByname('serjo2');
    cl := Brush.Color;
    if f <> nil then
    begin
      if (pvSerJouToHighLight = f.AsInteger) and (pvTimer.Enabled) then
//        cl := clYellow
        cl := cl
      else
      begin
        pvIsUmpire.ParamByName('serjou').AsInteger := f.AsInteger;
        pvIsUmpire.Open;
        try
          if not pvIsUmpire.Eof then
          begin
            cl := getItemsColor(piUmpire);
          end
          else
          begin
            pvIsPlaying.ParamByName('serjou').AsInteger := f.AsInteger;
            pvIsPlaying.Open;
            try
              if not pvIsPlaying.Eof then
              begin
                cl := getItemsColor(piBusy);
                if SerCat = pvIsPlaying.FieldByName('sertab').AsInteger then
                  cl := getItemsColor(piInProgress);
              end;
            finally
              pvIsPlaying.Close;
            end;
          end;
        finally
          pvIsUmpire.Close;
        end;
      end;
      Brush.Color := cl;
    end;

    {: table column }
    if (Uppercase(Column.FieldName) = 'NUMTBL') then
    begin
      Brush.Color := clBlack;
      Font.Color := clWhite;
      Font.Style := [fsBold];
    end
    else
    if (Uppercase(Column.FieldName) = 'LEVEL') then
    begin
      Brush.Color := clNavy;
      Font.Color := clWhite;
      Font.Style := [];
    end;

    if gdSelected in AState then
    begin
      Canvas.Brush.Color := clHighlight;
      Canvas.Font.Color := clHighlightText;
    end;
    DefaultDrawColumnCell(Rect,DataCol,Column,AState);
  end;
end;

constructor TArenaCategPanel.Create(AOwner: TComponent; cnx: TLalConnection;
  const sercat: integer);
begin
  inherited Create(AOwner,cnx,sercat);
  Visible := False;
  try
    pvIsUmpire := TZReadOnlyQuery.Create(Self);
    pvIsUmpire.Connection := Cnx.get;
    pvIsUmpire.SQL.Add('SELECT numtbl FROM umpires u'
                      +' WHERE sertrn = ' + Sertrn.ToString
                      +'   AND serump = :serjou');
    pvIsUmpire.Prepare;

    pvIsPlaying := TZReadOnlyQuery.Create(Self);
    pvIsPlaying.Connection := Cnx.get;
    pvIsPlaying.SQL.Add('SELECT sertab,numtbl'
                       +' FROM match'
                       +' WHERE sertrn = ' + Sertrn.ToString
                       +'   AND score IS NULL'
                       +'   AND stamtc = ' + Ord(gsInProgress).ToString
                       +'   AND(serjo1 = :serjou OR serjo2 = :serjou)');
    pvIsPlaying.Prepare;

    pvData := TZReadOnlyQuery.Create(Self);
    pvData.Connection := Cnx.get;
    pvData.SQL.Add('SELECT codcat,heudeb,simple,handicap,stacat'
                  +'   ,(SELECT COUNT(*) FROM insc i WHERE i.sercat = c.sercat) registrations'
                  +'   ,(SELECT taille FROM tableau t WHERE t.sertab = c.sercat) drawSize'
                  +'   ,(SELECT MAX(level) FROM match m WHERE m.sertab = c.sercat) level'
                  +'   ,(SELECT COUNT(*) FROM MATCH m WHERE m.sertab = c.sercat AND m.stamtc = '+Ord(gsInProgress).ToString+') inProgress'
                  +'   ,(SELECT COUNT(*) FROM MATCH m WHERE m.sertab = c.sercat AND m.stamtc < '+Ord(gsOver).ToString+') remaining'
                  +' FROM categories c'
                  +' WHERE c.sercat = ' + SerCat.ToString);
    pvData.Open;

    pvGames := TZReadOnlyQuery.Create(Self);
    with pvGames do
    begin
      Connection := Cnx.get;
      SQL.Add('select a.level,a.numseq,a.nummtc,a.sermtc,a.serjo1,a.serjo2,a.stamtc,a.numtbl'
             +'  ,b.nomjou nomjo1'
             +'  ,c.nomjou nomjo2'
             +'  ,a.sertab'
             +' from match a left outer join tablo b on a.sertab = b.sertab and a.serjo1 = b.serjou'
             +'              left outer join tablo c on a.sertab = c.sertab and a.serjo2 = c.serjou'
             +' where a.sertab = ' + sercat.ToString
             +'   and a.serjo1 > 0'
             +'   and a.serjo2 > 0'
             +'   and a.stamtc < ' + Ord(gsOver).ToString
             +' order by a.level,a.numseq');
    end;
    pvGames.Open;

    FHeader.OnClick := enterPanel;

    with TLabel.Create(Self) do
    begin
      Parent := FHeader;
      Align := alLeft;
      Caption := pvData.FieldByName('codcat').AsString;
      OnClick := enterPanel;
    end;
    with TLabel.Create(Self) do
    begin
      Parent := FHeader;
      Align := alRight;
      Alignment := taRightJustify;
      Caption := pvData.FieldByName('heudeb').AsString;
      OnClick := enterPanel;
    end;
    FInfos := TLabel.Create(Self);
    with FInfos do
    begin
      Parent := FHeader;
      Align := alClient;
      Alignment := taCenter;
      OnClick := enterPanel;
    end;

    SetDatasourceDataset(pvGames);

    FGrid.OnDrawColumnCell := categDrawColumnCell;
    FGrid.OnDblClick := GridDblClick;
    FGrid.OnCellClick := gridCellClick;
    FGrid.OnColEnter := gridColEnter;
    FGrid.OnKeyPress := GridKeyPress;
    FGrid.OnMouseLeave := GridMouseLeave;
    with FGrid.Columns.Add do
    begin
      FieldName := 'level';
      Width := 12;
      Alignment := taCenter;
    end;
    with FGrid.Columns.Add do
    begin
      FieldName := 'nomjo1';
      Width := FGrid.Width div 3;
    end;
    with FGrid.Columns.Add do
    begin
      FieldName := 'numtbl';
      Width := 18;
      Alignment := taCenter;
    end;
    with FGrid.Columns.Add do
    begin
      FieldName := 'nomjo2';
      Width := FGrid.Width div 3;
    end;
    OnResize := ResizeColumns;
    OnEnter  := enterPanel;

    pvTimer := TTimer.Create(Self);
    pvTimer.Interval := 3000;
    pvTimer.OnTimer := onHighlightTimer;
    Refresh;
  finally
    Visible := True;
  end;
end;

procedure TArenaCategPanel.enterPanel(Sender: TObject);
begin
  broadcastMessage(wm_displayDraw,SerCat,Dataset.FieldByName('sermtc').AsInteger);
end;

function TArenaCategPanel.GetDrawSize: smallint;
begin
  Result := pvData.FieldByName('drawSize').AsInteger;
end;

function TArenaCategPanel.GetGridFontSize: integer;
begin
  Result := FGrid.Font.Size;
end;

procedure TArenaCategPanel.gridCellClick(Column: TColumn);
var
  f: TField;
begin
  broadcastMessage(wm_gameInfo,FGrid.DataSource.Dataset.FieldByName('sermtc').AsInteger,0);
  broadcastMessage(wm_displayDraw,SerCat,Dataset.FieldByName('sermtc').AsInteger);
  f := FGrid.SelectedField;
  if (f = FGrid.DataSource.DataSet.FieldByName('nomjo1')) or (f = FGrid.DataSource.DataSet.FieldByName('nomjo2')) then
  begin
    if UpperCase(f.FieldName) = 'NOMJO1' then f := FGrid.DataSource.DataSet.FieldByName('serjo1')
    else f := FGrid.DataSource.DataSet.FieldByName('serjo2');
    broadcastMessage(wm_playerStatus,f.AsInteger,Sertrn);
  end;
end;

procedure TArenaCategPanel.gridColEnter(Sender: TObject);
//var
//  f: TField;
begin
  broadcastMessage(wm_gameInfo,FGrid.DataSource.Dataset.FieldByName('sermtc').AsInteger,0);
//  f := FGrid.SelectedField;
//  if (f = FGrid.DataSource.DataSet.FieldByName('nomjo1')) or (f = FGrid.DataSource.DataSet.FieldByName('nomjo2')) then
//  begin
//    if UpperCase(f.FieldName) = 'NOMJO1' then f := FGrid.DataSource.DataSet.FieldByName('serjo1')
//    else f := FGrid.DataSource.DataSet.FieldByName('serjo2');
//    broadcastMessage(wm_playerStatus,f.AsInteger,pvSertrn);
//  end;
end;

procedure TArenaCategPanel.GridDblClick(Sender: TObject);
begin
  {: allow to activate a game if :
        1. the current game is available
        2. a play area is available
        3. both players are available }
  if (FGrid.DataSource.DataSet.Eof) then
    Exit;

  if (FGrid.DataSource.DataSet.FieldByName('stamtc').AsInteger > Ord(gsInProgress)) then
    Exit;

  if (FGrid.DataSource.DataSet.FieldByName('stamtc').AsInteger = Ord(gsInProgress)) then
  begin
    broadcastMessage(wm_gameCatchResult,FGrid.DataSource.Dataset.FieldByName('sermtc').AsInteger,FGrid.Datasource.Dataset.FieldByName('numtbl').AsInteger);
    Exit;
  end;

  pvPlayAreaAvailable.Open;
  try
    if pvPlayAreaAvailable.Fields[0].AsInteger = 0 then
    begin
      broadcastMessage(wm_noPlayAreaAvailable,0,0);
      Exit;
    end;

    with FGrid.DataSource.DataSet do
    begin
      pvIsUmpire.ParamByName('serjou').AsInteger := FieldByName('serjo1').AsInteger;
      pvIsUmpire.Open;
      if not pvIsUmpire.Eof then
      begin
        broadcastMessage(wm_playerIsUmpire,pvIsUmpire.ParamByName('serjou').AsInteger,pvIsUmpire.FieldByName('numtbl').AsInteger);
        Exit;
      end;
      pvIsUmpire.Close;
      pvIsUmpire.ParamByName('serjou').AsInteger := FieldByName('serjo2').AsInteger;
      pvIsUmpire.Open;
      if not pvIsUmpire.Eof then
      begin
        broadcastMessage(wm_playerIsUmpire,pvIsUmpire.ParamByName('serjou').AsInteger,pvIsUmpire.FieldByName('numtbl').AsInteger);
        Exit;
      end;
      pvIsUmpire.Close;
      pvIsPlaying.ParamByName('serjou').AsInteger := FieldByName('serjo1').AsInteger;
      pvIsPlaying.Open;
      if not pvIsPlaying.Eof then
      begin
        broadcastMessage(wm_playerIsBusy,pvIsPlaying.ParamByName('serjou').AsInteger,pvIsPlaying.FieldByName('numtbl').AsInteger);
        Exit;
      end;
      pvIsPlaying.Close;
      pvIsPlaying.ParamByName('serjou').AsInteger := FieldByName('serjo2').AsInteger;
      pvIsPlaying.Open;
      if not pvIsPlaying.Eof then
      begin
        broadcastMessage(wm_playerIsBusy,pvIsPlaying.ParamByName('serjou').AsInteger,pvIsPlaying.FieldByName('numtbl').AsInteger);
        Exit;
      end;
      pvIsPlaying.Close;
      { we are there, play area selection }

      if getTableNumberDlg.ShowModal = mrOk then
      begin
        beginGame(Sertrn, FieldByName('sermtc').AsInteger, getTableNumberDlg.PlayAreaNumber);
        Self.Refresh;  // refresh panel
        broadCastMessage(wm_refreshArenaDisplay, FieldByName('sermtc').AsInteger, getTableNumberDlg.PlayAreaNumber);
        broadcastMessage(wm_umpiresRefresh,0,0);
      end;
    end;
  finally
    if pvIsUmpire.Active then pvIsUmpire.Close;
    if pvIsPlaying.Active then pvIsPlaying.Close;

    pvPlayAreaAvailable.Close;
  end;
end;

procedure TArenaCategPanel.GridKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    if not FGrid.DataSource.DataSet.Eof then
    begin
      if FGrid.DataSource.DataSet.FieldByName('stamtc').AsInteger = Ord(gsInactive) then
        GridDblClick(Sender)
      else if FGrid.DataSource.DataSet.FieldByName('stamtc').AsInteger = Ord(gsInProgress) then
        broadcastMessage(wm_gameCatchResult,FGrid.DataSource.DataSet.FieldByName('sermtc').AsInteger,FGrid.DataSource.DataSet.FieldByName('numtbl').AsInteger);
    end;
  end;
end;

procedure TArenaCategPanel.GridMouseLeave(Sender: TObject);
begin
  resetFieldFocus;
end;

procedure TArenaCategPanel.GridOnHighlightPlayer(var Message: TMessage);
begin
  pvTimer.Enabled := False;
  pvSerJouToHighLight := Message.WParam;
  pvTimer.Enabled := True;
  FGrid.Refresh;
end;

procedure TArenaCategPanel.onHighlightTimer(Sender: TObject);
begin
  pvTimer.Enabled := False;
  pvSerJouToHighLight := 0;
  FGrid.Refresh;
end;

procedure TArenaCategPanel.Refresh;
begin
  inherited;
  pvGames.DisableControls;
  try
    pvGames.Refresh;
  finally
    pvGames.EnableControls;
    pvData.Refresh;
  end;
  FInfos.Caption := Format('%d/%d/%d',[pvData.FieldByName('inProgress').AsInteger,
                                       pvData.FieldByName('remaining').AsInteger,
                                       Pred(pvData.FieldByName('drawSize').AsInteger)]);
end;

procedure TArenaCategPanel.resetFieldFocus;
begin
  FGrid.SelectedField := DataSet.FieldByName('numtbl');
end;

procedure TArenaCategPanel.ResizeColumns(Sender: TObject);
var
  cx: integer;
begin
  inherited;
  if FGrid.Columns.Count > 0 then
  begin
    try
      {: begin new proc }
      cx :=  FGrid.Width;
      if FGrid.BorderStyle = bsSingle then
      begin
        if FGrid.Ctl3D then  // border is sunken, vertical border is 2 pixels wide
          Dec(cx, 4)
        else
          Dec(cx, 2);       // border is one-dimentional 1 pixel wide
      end;
      cx := cx - GetSystemMetrics(SM_CXVSCROLL);
      if dgIndicator in FGrid.Options then
      begin
        Dec(cx,IndicatorWidth);
        if dgColLines in FGrid.Options then
          Dec(cx, 1);
      end;
      Dec(cx, FGrid.Columns[0].Width + FGrid.Columns[2].Width);
      cx := (cx div 2)-2;
      FGrid.Columns[1].width := cx;
      FGrid.Columns[3].width := cx;
      {: end new proc }
    except
    end;
  end;
end;

procedure TArenaCategPanel.SetGridFontSize(const Value: integer);
begin
  FGrid.Font.Size := Value;
end;

end.
