unit PlayerPathWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dataGridWindow, Data.DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, Vcl.DBCtrls, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.ExtCtrls,
  lal_connection;

type
  TPlayerPathW = class(TdataGridW)
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure gridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
    pvSerjou,
    pvSertrn: integer;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; cnx: TLalConnection; const serjou,sertrn: integer); reintroduce; overload;
  end;

implementation

{$R *.dfm}

uses
  tmUtils15;

constructor TPlayerPathW.Create(AOwner: TComponent; cnx: TLalConnection;
  const serjou, sertrn: integer);
begin
  pvSerjou := serjou;
  pvSertrn := sertrn;
  inherited Create(AOwner, cnx);
end;

procedure TPlayerPathW.FormCreate(Sender: TObject);
begin
  inherited;
  data.Connection := cnx.get;
  data.SQL.Add('SELECT'
              +'  c2.CODCAT,m.nummtc,m.heure,j2.NOMJOU,m.score'
              +'  ,CASE'
              +'     WHEN m.VAINQUEUR = :serjou THEN ''gagné'''
              +'     WHEN m.PERDANT = :serjou THEN   ''perdu'''
              +'     ELSE ''à jouer'''
              +'   END statut'
              +'  ,j3.nomjou NomVainqueur'
              +'  ,CASE'
              +'     WHEN m.VAINQUEUR = :serjou THEN 1'
              +'     WHEN m.PERDANT = :serjou THEN   2'
              +'     ELSE 0'
              +'   END statutMatch'
              +'  ,m.vainqueur'
              +'  ,j1.nomjou joueur'
              +' FROM'
              +'  "MATCH" m'
              +'    INNER JOIN CATEGORIES c2 ON m.SERTAB = c2.SERCAT'
              +'    INNER JOIN JOUEUR j1 ON (j1.serjou IN (m.serjo1,m.serjo2))'
              +'    LEFT JOIN JOUEUR  j2 ON (j2.serjou IN (m.serjo1,m.serjo2))'
              +'    LEFT JOIN JOUEUR  j3 ON j3.serjou = m.vainqueur'
              +' WHERE'
              +'    m.sertrn = :sertrn'
              +' AND j1.serjou = :serjou'
              +' AND j1.serjou IN (serjo1,serjo2)'
              +' AND j2.serjou <> j1.serjou'
              +' ORDER BY c2.heudeb,m.NUMMTC');
  data.ParamByName('sertrn').AsInteger := pvSertrn;
  data.ParamByName('serjou').AsInteger := pvSerjou;
end;

procedure TPlayerPathW.FormShow(Sender: TObject);
begin
  inherited;
  with grid.Columns do
  begin
    Clear;
    with Add do
    begin
      FieldName := 'codcat';
      Title.Caption := 'Tableau';
      Alignment := taLeftJustify;
      ReadOnly := True;
    end;
    with Add do
    begin
      FieldName := 'nummtc';
      Title.Caption := 'Match n°';
      Alignment := taLeftJustify;
      ReadOnly := True;
    end;
    with Add do
    begin
      FieldName := 'heure';
      Title.Caption := 'Heure';
      Alignment := taLeftJustify;
      ReadOnly := True;
    end;
    with Add do
    begin
      FieldName := 'nomjou';
      Title.Caption := 'Adversaire';
      Alignment := taLeftJustify;
      ReadOnly := True;
    end;
    with Add do
    begin
      FieldName := 'score';
      Title.Caption := 'Score';
      Alignment := taLeftJustify;
      ReadOnly := True;
    end;
    with Add do
    begin
      FieldName := 'statut';
      Title.Caption := 'Statut';
      Alignment := taLeftJustify;
      ReadOnly := True;
    end;
    with Add do
    begin
      FieldName := 'NomVainqueur';
      Title.Caption := 'Vainqueur';
      Alignment := taLeftJustify;
      ReadOnly := True;
    end;
  end;
  data.Open;
  gridSheet.Caption := data.FieldByName('joueur').AsString;
end;

procedure TPlayerPathW.gridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
  with TDBGrid(Sender), TDBGrid(Sender).Canvas do
  begin
    if not DataSource.DataSet.Eof then
    begin
      case DataSource.DataSet.FieldByName('StatutMatch').AsInteger of
        0: Brush.Color := getItemsColor(piInactive);
        1: Brush.Color := getItemsColor(piWinner);
        2: Brush.Color := getItemsColor(piLoser);
      end;
      DefaultDrawColumnCell(Rect,DataCol,Column,State);
    end;
  end;
end;

end.
