unit ArenaQualificationPanel;

interface

uses
  ArenaCategoryPanel, System.Classes, Vcl.Controls, lal_connection, ZDataset,
  Windows, Vcl.Grids, Vcl.DBGrids, ArenaPanel;

type
  TArenaQualificationPanel = class(TArenaPanel)
  private
    pvGroupe,
    pvCompoGroupe: TZReadOnlyQuery;
  protected
    procedure SetGridFontSize(const Value: integer); override;
    function GetGridFontSize: integer;               override;
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; AState: TGridDrawState);
    procedure GridDblClick(Sender: TObject);
    procedure RunGroup(const sergrp: integer);
  public
    constructor Create(AOwner: TComponent; cnx: TLalConnection; const sercat: integer); override;
    procedure Refresh; override;
  end;

implementation

uses
  ZAbstractRODataset, Data.DB, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Graphics,
  tmUtils15, System.SysUtils, GetTableNumberDialog, TMEnums;

{ TArenaQualificationPanel }

constructor TArenaQualificationPanel.Create(AOwner: TComponent;
  cnx: TLalConnection; const sercat: integer);
begin
  inherited Create(AOwner,cnx,sercat);
  pvGroupe := TZReadOnlyQuery.Create(Self);
  pvGroupe.Connection := Self.Connection.get;
  pvGroupe.SQL.Add('SELECT grp.sergrp,grp.numgrp,grp.stagrp, ump.numtbl, grp.heure heudeb, dic.libdic'
                  +'      ,grp.numgrp||'' (''||grp.sergrp||'')'' AS libgrp'
                  +' FROM groupe grp'
                  +'   LEFT JOIN umpires ump ON ump.sermtc = grp.sergrp'
                  +'   LEFT JOIN dictionnaire dic ON dic.pardc1 = grp.stagrp'
                  +' WHERE grp.sercat = :sercat'
                  +'   AND dic.cledic = ' + QuotedStr('TQualificationGroupStatus')
                  +' ORDER BY grp.numgrp');
  pvGroupe.Params[0].AsInteger := sercat;
  pvGroupe.Open;
  SetDatasourceDataset(pvGroupe);

  pvCompoGroupe := TZReadOnlyQuery.Create(Self);
  pvCompoGroupe.Connection := Self.Connection.get;
  pvCompoGroupe.SQL.Add('SELECT cpg.numseq'
                       +'      ,jou.nomjou'
                       +'      ,clb.libclb'
                       +' FROM compo_groupe cpg'
                       +'  INNER JOIN joueur jou ON cpg.serjou = jou.serjou'
                       +'  INNER JOIN club clb ON jou.codclb = clb.codclb'
                       +' WHERE cpg.sergrp = :sergrp'
                       +' ORDER BY cpg.numseq');
  pvCompoGroupe.Prepare;

  with TLabel.Create(Self) do
  begin
    Parent := FHeader;
    Align := alLeft;
    Caption := pvCateg.FieldByName('codcat').AsString;
//    OnClick := enterPanel;
  end;
  with TLabel.Create(Self) do
  begin
    Parent := FHeader;
    Align := alRight;
    Alignment := taRightJustify;
    Caption := pvCateg.FieldByName('heudeb').AsString;
//    OnClick := enterPanel;
  end;
  FInfos := TLabel.Create(Self);
  with FInfos do
  begin
    Parent := FHeader;
    Align := alClient;
    Alignment := taCenter;
    Caption := sercat.ToString;
//    OnClick := enterPanel;
  end;

  with FGrid.Columns.Add do
  begin
    FieldName := 'libgrp';
    Width := 48;
    Alignment := taCenter;
  end;
  with FGrid.Columns.Add do
  begin
    FieldName := 'heudeb';
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
    FieldName := 'libdic';
    Width := FGrid.Width div 3;
  end;
  FGrid.OnDrawColumnCell := GridDrawColumnCell;
  FGrid.OnDblClick := GridDblClick;
end;

function TArenaQualificationPanel.GetGridFontSize: integer;
begin
  Result := FGrid.Font.Size;
end;

procedure TArenaQualificationPanel.SetGridFontSize(const Value: integer);
begin
  inherited;
  FGrid.Font.Size := Value;
end;

procedure TArenaQualificationPanel.GridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
  with TDBGrid(Sender),TDBGrid(Sender).Canvas,TDBGrid(Sender).DataSource.DataSet do
  begin
    if not Eof then
    begin
      Brush.Color := GetGroupStatusColor(TQualificationGroupStatus(FieldByName('stagrp').AsInteger));
    end;

    if (Uppercase(Column.FieldName) = 'NUMTBL') then
    begin
      Brush.Color := clBlack;
      Font.Color := clWhite;
      Font.Style := [fsBold];
    end
    else
    if (Uppercase(Column.FieldName) = 'LIBGRP') then
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

procedure TArenaQualificationPanel.GridDblClick(Sender: TObject);
begin
  if not(Dataset.Eof) and (Dataset.FieldByName('stagrp').AsInteger = Ord(qgsGamesAreCreated)) then
    RunGroup(Dataset.FieldByName('sergrp').AsInteger);
end;

procedure TArenaQualificationPanel.Refresh;
begin
  pvGroupe.Refresh;
end;

procedure TArenaQualificationPanel.RunGroup(const sergrp: integer);
begin
  pvPlayAreaAvailable.Open;
  try
    if not pvPlayAreaAvailable.Eof then
    begin
      if getTableNumberDlg.ShowModal = mrOk then
      begin
        BeginQualificationGroup(SerTrn, sergrp, getTableNumberDlg.PlayAreaNumber);
        Refresh;
        broadCastMessage(wm_refreshArenaDisplay, sergrp, getTableNumberDlg.PlayAreaNumber);
        broadcastMessage(wm_umpiresRefresh,0,0);
      end;
    end
    else
      broadcastMessage(wm_noPlayAreaAvailable,0,0);
  finally
    pvPlayAreaAvailable.Close;
  end;
end;

end.

