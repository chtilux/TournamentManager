unit groupPanel;

interface

uses
  Classes, Vcl.ExtCtrls, lal_connection, ZDataset, ZAbstractRODataset, Db,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Windows, Winapi.Messages, Vcl.ActnList,
  Vcl.Controls, System.SysUtils, tmUtils15;

type
  TPlayerData = class
  public
    sergrp: integer;
    serjou: integer;
    constructor Create(const sergrp, serjou: integer);
  end;

  ESwapDataError = class(Exception);
  TSwapData = class
  public
    class procedure swap(cnx: TLalConnection; data1, data2: TPlayerData);
  end;

  TGroupPanel = class(TPanel)
  private
    pvCnx: TLalConnection;
    pvSerGrp: integer;
    pvGroupNumberLabel,
    pvTableNumberLabel: TLabel;

    pvGroupSource,
    pvPlayersSource,
    pvGamesSource,
    pvResultsSource: TDatasource;

    pvGridsPanel: TPanel;

    pvPlayersGrid,
    pvGamesGrid,
    pvResultsGrid: TDBGrid;

    pvCreateGamesButton,
    pvValidateGroupCompoButton,
    pvResetGamesButton: TButton;

    pvActions: TActionList;
    pvCreateGamesAction,
    pvValidateGroupCompoAction,
    pvResetGamesAction: TAction;

    pvGroupQuery,
    pvPlayersQuery,
    pvGamesQuery,
    pvResultsQuery: TZReadOnlyQuery;
    FCreateGamesProc: TProc<integer>;

    procedure CreateVisualControls;
    procedure CreateDataLinks;

    function GetGroupNumber: integer;
    function GetTableNumber: integer;
    procedure SetGroupNumber(const Value: integer);
    procedure SetTableNumber(const Value: integer);
    procedure SetCreateGamesProc(const Value: TProc<integer>);

    procedure CreateHeaderPanel;
    procedure CreateGridsPanel;
    procedure CreateGridAndDatasource(var grid: TDBGrid; var source: TDatasource);
    procedure CreateGridColumns(var grid: TDBGrid);
    procedure CreateButtonsPanel;

    procedure ValidateGroupCompo(Sender: TObject);
    procedure CreateGames(Sender: TObject);
    procedure ResetGames(Sender: TObject);
    procedure UpdateCategoryStatus;

    procedure PlayersGridDrawColumnCell(Sender: TObject; const Rect: TRect;
                     DataCol: Integer; Column: TColumn; AState: TGridDrawState);
    procedure ActionsUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure QualificationGroupRefresh(var Message: TMessage); message wm_qualificationGroupRefresh;

  protected
    procedure Resize; override;

  public
    constructor Create(AOwner: TComponent; cnx: TLalConnection; const sergrp: integer); reintroduce; overload;
    procedure Refresh;
    property GroupNumber: integer read GetGroupNumber write SetGroupNumber;
    property TableNumber: integer read GetTableNumber write SetTableNumber;
    property CreateGamesProc:  TProc<integer> read FCreateGamesProc write SetCreateGamesProc;
    property Sergrp: integer read pvSerGrp;
  end;

implementation

uses
  Vcl.Forms, Vcl.Graphics, Vcl.Dialogs, TMEnums, System.Actions, System.UITypes;

{ TGroupPanel }

constructor TGroupPanel.Create(AOwner: TComponent; cnx: TLalConnection;
  const sergrp: integer);
begin
  inherited Create(AOwner);
  Visible := False;
  pvCnx := cnx;
  pvSerGrp := sergrp;
  Font.Size := 8;
  Caption := '';
  Align := alLeft;
  CreateVisualControls;
  CreateDataLinks;
  Refresh;
  Visible := True;
end;

procedure TGroupPanel.CreateVisualControls;
begin
  { 5 layers : header, players, games, results, buttons }
  CreateHeaderPanel;
  CreateButtonsPanel;
  CreateGridsPanel;
  CreateGridAndDatasource(pvPlayersGrid, pvPlayersSource);
  pvPlayersGrid.OnDrawColumnCell := PlayersGridDrawColumnCell;
  CreateGridAndDatasource(pvGamesGrid, pvGamesSource);
  CreateGridAndDatasource(pvResultsGrid, pvResultsSource);
end;

procedure TGroupPanel.CreateHeaderPanel;
var
  pnl: TPanel;
begin
  pnl := TPanel.Create(Self);
  pnl.Parent := Self;
  pnl.Align := AlTop;
  pnl.Caption := '';
  pnl.BorderWidth := 2;
  pnl.Font.Size := 12;
  pvGroupNumberLabel := TLabel.Create(Self);
  with pvGroupNumberLabel do
  begin
    Parent := pnl;
    Align := alLeft;
  end;
  pvTableNumberLabel := TLabel.Create(Self);
  with pvTableNumberLabel do
  begin
    Parent := pnl;
    Align := alRight;
  end;
  pnl.Update;
  pnl.AutoSize := True;
end;

procedure TGroupPanel.CreateGridsPanel;
begin
  pvGridsPanel := TPanel.Create(Self);
  pvGridsPanel.Parent := Self;
  pvGridsPanel.Align := AlClient;
  pvGridsPanel.Caption := '';
  pvGridsPanel.Update;
end;

procedure TGroupPanel.CreateGridAndDatasource(var grid: TDBGrid; var source: TDatasource);
begin
  grid := TDBGrid.Create(Self);
  grid.Parent := pvGridsPanel;
  grid.Align := alTop;
  grid.ReadOnly := True;
  grid.Font.Size := 8;
  source := TDataSource.Create(Self);
  source.AutoEdit := False;
  grid.DataSource := source;
  CreateGridColumns(grid);
end;

procedure TGroupPanel.CreateGridColumns(var grid: TDBGrid);
begin
  if grid = pvPlayersGrid then
  begin
    with grid.Columns.Add do
    begin
      FieldName := 'numseq';
      Alignment := taCenter;
      Width := 30;
      Title.Caption := 'N°';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'nomjou';
      Alignment := taLeftJustify;
      Width := 120;
      Title.Caption := 'Joueur';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'libclb';
      Alignment := taLeftJustify;
      Width := 120;
      Title.Caption := 'Club';
      Title.Alignment := taCenter;
    end;
  end
  else
  if grid = pvGamesGrid then
  begin
    with grid.Columns.Add do
    begin
      FieldName := 'nummtc';
      Alignment := taCenter;
      Width := 30;
      Title.Caption := 'N°';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'nomjou1';
      Alignment := taLeftJustify;
      Width := 120;
      Title.Caption := 'Joueur';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'nomjou2';
      Alignment := taLeftJustify;
      Width := 120;
      Title.Caption := 'Joueur';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'score';
      Alignment := taCenter;
      Width := 40;
      Title.Caption := 'Sets';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'games';
      Alignment := taLeftJustify;
      Width := 120;
      Title.Caption := 'Points';
      Title.Alignment := taCenter;
    end;
  end
  else
  if grid = pvResultsGrid then
  begin
    with grid.Columns.Add do
    begin
      FieldName := 'nomjou';
      Alignment := taLeftJustify;
      Width := 120;
      Title.Caption := 'Joueur';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'wins';
      Alignment := taCenter;
      Width := 50;
      Title.Caption := 'Gagnés';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'games';
      Alignment := taCenter;
      Width := 50;
      Title.Caption := 'Sets';
      Title.Alignment := taCenter;
    end;
    with grid.Columns.Add do
    begin
      FieldName := 'points';
      Alignment := taCenter;
      Width := 50;
      Title.Caption := 'Points';
      Title.Alignment := taCenter;
    end;
  end;
end;

procedure TGroupPanel.CreateButtonsPanel;
var
  pnl: TPanel;
  procedure CreateButton(var bt: TButton; var act: TAction; evt: TNotifyEvent; const Caption: string);
  begin
    bt := TButton.Create(Self);
    bt.Parent := pnl;
    bt.Align := alLeft;
    bt.Width := pnl.Width div 3;
    act := TAction.Create(Self);
    act.Caption := Caption;
    act.OnExecute := evt;
    act.ActionList := pvActions;
    bt.Action := act;
  end;
begin
  pnl := TPanel.Create(Self);
  pnl.Parent := Self;
  pnl.Align := AlBottom;
  pnl.Caption := '';
  pnl.BorderWidth := 2;
  pvActions := TActionList.Create(Self);
  CreateButton(pvValidateGroupCompoButton,pvValidateGroupCompoAction,ValidateGroupCompo,'Validate');
  CreateButton(pvCreateGamesButton,pvCreateGamesAction,CreateGames,'Create');
  CreateButton(pvResetGamesButton,pvResetGamesAction,ResetGames,'Reset');
  pvActions.OnUpdate := ActionsUpdate;
end;

procedure TGroupPanel.CreateGames(Sender: TObject);
begin
  if Assigned(FCreateGamesProc) then
  begin
    FCreateGamesProc(pvSerGrp);
    Refresh;
  end;
end;

procedure TGroupPanel.ValidateGroupCompo(Sender: TObject);
begin
  UpdateQualificationGroupStatus(pvSerGrp, qgsValidated);
  UpdateCategoryStatus;
  Refresh;
end;

procedure TGroupPanel.ResetGames(Sender: TObject);
begin
  if MessageDlg('Confirmez-vous les remise à zéro des matchs du groupe ?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then
  begin
    with TZReadOnlyQuery.Create(nil) do
    begin
      try
        Connection := pvCnx.get;
        pvCnx.startTransaction;
        try
          SQL.Add('DELETE FROM match WHERE sermtc IN (SELECT sermtc FROM match_groupe WHERE sergrp = :sergrp)');
          Params[0].AsInteger := pvSerGrp;
          ExecSQL;
//          Supprimés par trigger sur match
//          SQL.Clear;
//          SQL.Add('DELETE FROM match_groupe WHERE sergrp = :sergrp');
//          Params[0].AsInteger := FSerGrp;
//          ExecSQL;
          UpdateQualificationGroupStatus(pvSergrp, qgsValidated);
          pvCnx.commit;
          UpdateCategoryStatus;
        except
          pvCnx.rollback;
          raise;
        end;
        Self.Refresh;
      finally
        Free;
      end;
    end;
  end;
end;

procedure TGroupPanel.UpdateCategoryStatus;
begin
  CheckAndSetCategorieStatusAfterUpdate(pvGroupQuery.FieldByName('sercat').AsInteger);
end;

procedure TGroupPanel.CreateDataLinks;
begin
  pvGroupQuery := TZReadOnlyQuery.Create(Self);
  with pvGroupQuery do
  begin
    Connection := Self.pvCnx.get;
    SQL.Add('SELECT grp.sercat,grp.numgrp,grp.stagrp,grp.sertrn,grp.sergrp'
           +'      ,cat.codcat,cat.heudeb'
           +'      ,grp.teilnehmer'
           +' FROM groupe grp'
           +'  INNER JOIN categories cat ON grp.sercat = cat.sercat'
           +' WHERE grp.sergrp = :sergrp');
  end;
  pvGroupSource := TDatasource.Create(Self);
  pvGroupSource.DataSet := pvGroupQuery;

  pvPlayersQuery := TZReadOnlyQuery.Create(Self);
  with pvPlayersQuery do
  begin
    Connection := Self.pvCnx.get;
    SQL.Add('SELECT cpg.numseq,cpg.sergrp'
           +'      ,jou.nomjou,jou.codcls,jou.vrbrgl'
           +'      ,clb.libclb'
           +' FROM compo_groupe cpg'
           +'  INNER JOIN joueur jou ON cpg.serjou = jou.serjou'
           +'  INNER JOIN club clb ON jou.codclb = clb.codclb'
           +' WHERE cpg.sergrp = :sergrp'
           +' ORDER BY cpg.numseq');
    DataSource := pvGroupSource;
  end;
  pvPlayersSource.DataSet := pvPlayersQuery;

  pvGamesQuery := TZReadOnlyQuery.Create(Self);
  with pvGamesQuery do
  begin
    Connection := Self.pvCnx.get;
    SQL.Add('SELECT mtc.nummtc,j1.nomjou AS nomjou1,j2.nomjou AS nomjou2,mtc.score,mtc.games'
           +' FROM match_groupe mg'
           +'   INNER JOIN match mtc ON mg.sermtc = mtc.sermtc'
           +'   INNER JOIN joueur j1 ON mtc.serjo1 = j1.serjou'
           +'   INNER JOIN joueur j2 ON mtc.serjo2 = j2.serjou'
           +' WHERE mg.sergrp = :sergrp'
           +' ORDER BY mtc.nummtc');
    DataSource := pvGroupSource;
  end;
  pvGamesSource.DataSet := pvGamesQuery;

  pvResultsQuery := TZReadOnlyQuery.Create(Self);
  with pvResultsQuery do
  begin
    Connection := Self.pvCnx.get;
    SQL.Add('SELECT jou.nomjou, sum(WINNER) wins, sum(gr.GAMES) games, sum(gr.POINTS) points'
            +' FROM groupe_result gr'
            +'      INNER JOIN joueur jou ON jou.serjou = gr.serjou'
            +' WHERE gr.sergrp = :sergrp'
            +' GROUP BY 1'
            +' ORDER BY 2 DESC, 3 DESC, 4 DESC');
    DataSource := pvGroupSource;
  end;
  pvResultsSource.DataSet := pvResultsQuery;

  pvGroupQuery.Params[0].AsInteger := pvSerGrp;
  pvGroupQuery.Open;
  pvPlayersQuery.Open;
  pvGamesQuery.Open;
  pvResultsQuery.Open;

  GroupNumber := pvGroupQuery.FieldByName('numgrp').AsInteger;
end;

procedure TGroupPanel.Refresh;
begin
  pvPlayersQuery.Refresh;
  pvGroupQuery.Refresh;
  pvGamesQuery.Refresh;
  pvResultsQuery.Refresh;
end;

function TGroupPanel.GetGroupNumber: integer;
begin
  Result := StrToIntDef(pvGroupNumberLabel.Caption,0);
end;

function TGroupPanel.GetTableNumber: integer;
begin
  Result := StrToIntDef(pvTableNumberLabel.Caption,0);
end;

procedure TGroupPanel.SetCreateGamesProc(const Value: TProc<integer>);
begin
  FCreateGamesProc := Value;
end;

procedure TGroupPanel.SetGroupNumber(const Value: integer);
begin
  pvGroupNumberLabel.Caption := Format('Groupe %d [%d] (%d)', [Value, pvGroupQuery.FieldByName('teilnehmer').AsInteger, pvSerGrp]);
end;

procedure TGroupPanel.SetTableNumber(const Value: integer);
begin
  pvTableNumberLabel.Caption := Format('%d', [Value]);
end;

procedure TGroupPanel.Resize;
begin
  inherited;
  pvPlayersGrid.Height := pvGridsPanel.Height div 3;
  pvGamesGrid.Height := pvGridsPanel.Height div 3;
  pvResultsGrid.Height := pvGridsPanel.Height div 3;
end;

procedure TGroupPanel.PlayersGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; AState: TGridDrawState);
const
  cl: array[Boolean] of TColor = (clWhite, clWebIvory);
begin
  inherited;
  if TDBGrid(Sender).DataSource.DataSet.Eof then
    Exit;
  with TDBGrid(Sender),TDBGrid(Sender).Canvas,TDBGrid(Sender).DataSource.DataSet do
  begin
    { Changer de couleur toutes les 2 cellules }
    if FindField('numseq') <> nil then
      Brush.Color := cl[Odd(FieldByName('numseq').AsInteger)];
    { highlight tête de série }
    if gdSelected in AState then begin
      Brush.Color := clHighlight;
      Font.Color := clHighLightText;
    end;
    DefaultDrawColumnCell(Rect,DataCol,Column,AState);
  end;
end;

procedure TGroupPanel.QualificationGroupRefresh(var Message: TMessage);
begin
  if Message.WParam = Self.pvSerGrp then
    Refresh;
end;

procedure TGroupPanel.ActionsUpdate(Action: TBasicAction; var Handled: Boolean);
begin
  pvValidateGroupCompoAction.Enabled := pvGroupQuery.FieldByName('stagrp').AsInteger = Ord(qgsInactive);
  pvCreateGamesAction.Enabled := pvGamesQuery.IsEmpty and (pvGroupQuery.FieldByName('stagrp').AsInteger = Ord(qgsValidated));
  pvResetGamesAction.Enabled := not(pvGamesQuery.IsEmpty) and (pvGroupQuery.FieldByName('stagrp').AsInteger < Ord(qgsInProgress));
  Handled := True;
end;

{ TPlayerData }

constructor TPlayerData.Create(const sergrp, serjou: integer);
begin
  Self.sergrp := sergrp;
  Self.serjou := serjou;
end;

{ TSwapData }

class procedure TSwapData.swap(cnx: TLalConnection; data1, data2: TPlayerData);
begin
  if data1.serjou = data2.serjou then
    raise ESwapDataError.Create('Cannot swap the same player !');

  with TZReadOnlyQuery.Create(nil) do
  begin
    try
      Connection := cnx.get;
      SQL.Add('UPDATE compo_groupe'
             +' SET serjou = :new_serjou'
             +' WHERE sergrp = :sergrp'
             +'   AND serjou = :old_serjou');
      Prepare;
      cnx.startTransaction;
      try
        Params[0].AsInteger := data2.serjou;
        Params[1].AsInteger := data1.sergrp;
        Params[2].AsInteger := data1.serjou;
        ExecSQL;
        Params[0].AsInteger := data1.serjou;
        Params[1].AsInteger := data2.sergrp;
        Params[2].AsInteger := data2.serjou;
        ExecSQL;

        SQL.Clear;
        SQL.Add('UPDATE prptab'
               +' SET sergrp = :sergrp'
               +' WHERE sergrp = :old_sergrp'
               +'   AND serjou = :serjou');
        Params[0].AsInteger := data2.sergrp;
        Params[1].AsInteger := data1.sergrp;
        Params[2].AsInteger := data1.serjou;
        ExecSQL;
        Params[0].AsInteger := data1.sergrp;
        Params[1].AsInteger := data2.sergrp;
        Params[2].AsInteger := data2.serjou;
        ExecSQL;

        cnx.commit;
      except
        on E:Exception do
        begin
          cnx.rollback;
          raise ESwapDataError.Create('Swap error : ' + E.Message);
        end;
      end;
    finally
      Free;
    end;
  end;
end;

end.

