unit saisieWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ZDataset, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, lal_connection;

type
  TsaisieW = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    search: TEdit;
    searchGrid: TDBGrid;
    searchSource: TDataSource;
    sourceBox: TRadioGroup;
    SpeedButton1: TSpeedButton;
    procedure searchChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sourceBoxClick(Sender: TObject);
    procedure searchKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton1Click(Sender: TObject);
    procedure searchGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Déclarations privées }
    _sertrn: integer;
    _search: TZReadOnlyQuery;
    pvCnx: TLalConnection;
    procedure SearchGames(const SearchText: string);
    function GetAllGamesSQL: string;
    function GetByPlayerNameSQL: string;
    function GetByTableNumberSQL: string;
    function GetSourceBoxCaseSQL: string;
    function GetOrderBySQL: string;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent; cnx: TLalConnection; const sertrn: integer); reintroduce; overload;
    function editMatch(const sermtc: integer): boolean;
  end;

var
  saisie: TsaisieW;

implementation

{$R *.dfm}

uses
  tmUtils15, lal_dbUtils, matchWindow, UITypes, lal_utils, TMEnums, Game;

constructor TsaisieW.Create(AOwner: TComponent; cnx: TLalConnection; const sertrn: integer);
begin
  _sertrn := sertrn;
  pvCnx := cnx;
  inherited Create(AOwner);
  _search := getROQuery(pvCnx, Self);
  searchSource.DataSet := _search;
end;

function TsaisieW.editMatch(const sermtc: integer): boolean;
var
  m: TGame;
  mw: TmatchW;
begin
  m := Game.TGame.Create(Self,pvCnx,sermtc);
  try
    mw := TmatchW.Create(Self, pvCnx, m);
    try
      Result := (mw.ShowModal = mrOk);
    finally
      mw.Free;
    end;

    if Result then
    begin
      if m.gameResult.isWO then
      begin
        if MessageDlg('Le résultat du match est WO. Le perdant est-il disponible pour arbitrer ?',
                      mtConfirmation, [mbYes,mbNo], 0) = mrNo then
        begin
          setAsUmpire(_sertrn,0,'',m.playAreaNumber);
          broadcastMessage(wm_playAreaRefresh,0,0);
        end;
      end;
    end;
  finally
    m.Free;
  end;
end;

procedure TsaisieW.FormShow(Sender: TObject);
begin
  searchChange(search);
end;

procedure TsaisieW.searchChange(Sender: TObject);
begin
  SearchGames(string(search.Text).Trim);
end;

procedure TsaisieW.SearchGames(const SearchText: string);
var
  sql: string;
  p: TParam;
begin
  if SearchText.IsEmpty then
    sql := GetAllGamesSQL
  else if not isDigit(SearchText[1]) then
    sql := GetByPlayerNameSQL
  else
    sql := GetByTableNumberSQL;
  sql := sql + GetOrderBySQL;

  _search.DisableControls;
  try
    if _search.Active then
      _search.Close;
    _search.SQL.Clear;
    _search.SQL.Add(sql);
    p := _search.Params.FindParam('sertrn');
    if Assigned(p) then
      p.AsInteger := _sertrn;
    p := _search.Params.FindParam('search');
    if Assigned(p) then
      p.AsString := SearchText + '%';
    _search.Open;
  finally
    _search.EnableControls;
  end;
end;

function TsaisieW.GetAllGamesSQL: string;
begin
  Result := 'SELECT mtc.sermtc,cat.codcat||''- GROUPE ''||grp.numgrp AS codcat'
           +'      ,mtc.nummtc,j1.nomjou "joueur 1",j2.nomjou "joueur 2"'
           +'      ,mtc.numtbl,mtc.heure,mtc.level,mtc.numseq'
           +' FROM MATCH mtc INNER join joueur j1 ON j1.serjou = mtc.serjo1'
           +'                INNER join joueur j2 ON j2.serjou = mtc.serjo2'
           +'                INNER JOIN categories cat ON mtc.sertab = cat.sercat'
           +'                INNER JOIN match_groupe mg ON mg.sermtc = mtc.sermtc'
           +'                INNER JOIN groupe grp ON grp.sergrp = mg.sergrp'
           +' WHERE mtc.sertrn = :sertrn'
           + GetSourceBoxCaseSQL
           +' UNION '
           +'SELECT mtc.sermtc,cat.codcat,mtc.nummtc,t1.nomjou "joueur 1"'
           +'      ,t2.nomjou "joueur 2",mtc.numtbl,mtc.heure,mtc.level,mtc.numseq'
           +' FROM match mtc INNER join tablo t1 ON mtc.sertab = t1.sertab AND mtc.serjo1 = t1.serjou'
           +'                INNER JOIN tablo t2 ON mtc.sertab = t2.sertab AND mtc.serjo2 = t2.serjou'
           +'                INNER JOIN categories cat ON mtc.sertab = cat.sercat'
           +' WHERE mtc.sertrn = :sertrn'
           +GetSourceBoxCaseSQL;
end;

function TsaisieW.GetByPlayerNameSQL: string;
begin
  Result := 'SELECT mtc.sermtc,cat.codcat||''- GROUPE ''||grp.numgrp AS codcat'
           +'      ,mtc.nummtc,j1.nomjou "joueur 1",j2.nomjou "joueur 2"'
           +'      ,mtc.numtbl,mtc.heure,mtc.level,mtc.numseq'
           +' FROM MATCH mtc INNER join joueur j1 ON j1.serjou = mtc.serjo1'
           +'                INNER join joueur j2 ON j2.serjou = mtc.serjo2'
           +'                INNER JOIN categories cat ON mtc.sertab = cat.sercat'
           +'                INNER JOIN match_groupe mg ON mg.sermtc = mtc.sermtc'
           +'                INNER JOIN groupe grp ON grp.sergrp = mg.sergrp'
           +' WHERE mtc.sertrn = :sertrn'
           +'   AND (j1.nomjou LIKE :search OR j2.nomjou LIKE :search)'
           + GetSourceBoxCaseSQL
           +' UNION '
           +'SELECT mtc.sermtc,cat.codcat,mtc.nummtc,t1.nomjou "joueur 1"'
           +'      ,t2.nomjou "joueur 2",mtc.numtbl,mtc.heure,mtc.level,mtc.numseq'
           +' FROM match mtc INNER join tablo t1 ON mtc.sertab = t1.sertab AND mtc.serjo1 = t1.serjou'
           +'                INNER JOIN tablo t2 ON mtc.sertab = t2.sertab AND mtc.serjo2 = t2.serjou'
           +'                INNER JOIN categories cat ON mtc.sertab = cat.sercat'
           +' WHERE mtc.sertrn = :sertrn'
           +'   AND (t1.nomjou LIKE :search OR t2.nomjou LIKE :search)'
           +GetSourceBoxCaseSQL;
end;

function TsaisieW.GetByTableNumberSQL: string;
begin
  Result := 'SELECT mtc.sermtc,cat.codcat||''- GROUPE ''||grp.numgrp AS codcat'
           +'      ,mtc.nummtc,j1.nomjou "joueur 1",j2.nomjou "joueur 2"'
           +'      ,mtc.numtbl,mtc.heure,mtc.level,mtc.numseq'
           +' FROM MATCH mtc INNER join joueur j1 ON j1.serjou = mtc.serjo1'
           +'                INNER join joueur j2 ON j2.serjou = mtc.serjo2'
           +'                INNER JOIN categories cat ON mtc.sertab = cat.sercat'
           +'                INNER JOIN match_groupe mg ON mg.sermtc = mtc.sermtc'
           +'                INNER JOIN groupe grp ON grp.sergrp = mg.sergrp'
           +' WHERE mtc.sertrn = :sertrn'
           +'   AND mtc.numtbl LIKE :search'
           + GetSourceBoxCaseSQL
           +' UNION '
           +'SELECT mtc.sermtc,cat.codcat,mtc.nummtc,t1.nomjou "joueur 1"'
           +'      ,t2.nomjou "joueur 2",mtc.numtbl,mtc.heure,mtc.level,mtc.numseq'
           +' FROM match mtc INNER join tablo t1 ON mtc.sertab = t1.sertab AND mtc.serjo1 = t1.serjou'
           +'                INNER JOIN tablo t2 ON mtc.sertab = t2.sertab AND mtc.serjo2 = t2.serjou'
           +'                INNER JOIN categories cat ON mtc.sertab = cat.sercat'
           +' WHERE mtc.sertrn = :sertrn'
           +'   AND mtc.numtbl LIKE :search'
           +GetSourceBoxCaseSQL;
end;

function TsaisieW.GetSourceBoxCaseSQL: string;
begin
  case sourceBox.ItemIndex of
    0 : Result := '   AND mtc.stamtc < ' + Ord(gsOver).ToString;
    1 : Result := '   AND mtc.stamtc = ' + Ord(gsInProgress).ToString + ' AND mtc.numtbl IS NOT NULL';
  end;
end;

function TsaisieW.GetOrderBySQL: string;
begin
  Result := ' ORDER BY 7,2,8,9';
end;

procedure TsaisieW.searchGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  dbgrid_highlight_current(TDBGrid(Sender),Rect,DataCol,Column,State);
end;

procedure TsaisieW.searchKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    if not _search.IsEmpty then
    begin
      Key := #0;
      if (ActiveControl <> searchGrid) and (_search.RecordCount > 0) then
      begin
        searchGrid.SetFocus;
      end
      else if (_search.RecordCount >= 1) then
      begin
        if editMatch(_search.FieldByName('sermtc').AsInteger) then
        begin
          _search.Refresh;
          search.SelectAll;
          search.SetFocus;
        end;
      end;
    end
    else
    begin
      search.SelectAll;
    end;
  end
  else if Key = #167 {§} then
  begin
    Key := #0;
    if search.Text <> '' then
      search.Clear
    else
      Close;
  end
  else
    Caption := Ord(Key).ToString;
end;

procedure TsaisieW.sourceBoxClick(Sender: TObject);
begin
  searchChange(search);
end;

procedure TsaisieW.SpeedButton1Click(Sender: TObject);
begin
  searchGrid.DataSource.DataSet.Refresh;
end;

end.
