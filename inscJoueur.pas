unit inscJoueur;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ZDataset, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, lal_connection;

type
  TinscJouW = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    search: TEdit;
    searchGrid: TDBGrid;
    searchSource: TDataSource;
    Accepter: TBitBtn;
    procedure searchChange(Sender: TObject);
    procedure searchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure searchGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure searchGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Déclarations privées }
    _sertrn: integer;
    _search: TZReadOnlyQuery;
    procedure statutGetText(Sender: TField; var Text: string; DisplayText: boolean);
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent; cnx: TLalConnection; const sertrn: integer); reintroduce; overload;
  end;

implementation

{$R *.dfm}

uses
  lal_dbUtils, matchWindow, tmUtils15, TMEnums;

constructor TinscJouW.Create(AOwner: TComponent; cnx: TLalConnection; const sertrn: integer);
begin
  _sertrn := sertrn;
  inherited Create(AOwner);
  _search := getROQuery(cnx, Self);
  searchSource.DataSet := _search;
end;

procedure TinscJouW.FormShow(Sender: TObject);
begin
  searchChange(search);
end;

procedure TinscJouW.searchChange(Sender: TObject);
var
  s: string;
  sql: string;
begin
  s := Trim(search.Text);
  if Length(s) > 0 then
  begin
    { par nom de joueur }
    if not isDigit(s[1]) then
    begin
      sql := 'select nomjou,codcat,statut,a.serjou'
            +' from joueur a, categories b, insc c'
            +' WHERE a.serjou = c.serjou'
            +'   and b.sercat = c.sercat'
            +'   and a.nomjou LIKE :search'
            +Format('    and c.sertrn = %d',[_sertrn])
            +' ORDER BY nomjou,heudeb,codcat';
    end;
  end
  else
  begin
    sql := 'select nomjou,codcat,statut,a.serjou'
          +' from joueur a, categories b, insc c'
          +' WHERE a.serjou = c.serjou'
          +'   and b.sercat = c.sercat'
          +Format('    and c.sertrn = %d',[_sertrn])
          +' ORDER BY nomjou,heudeb,codcat';
  end;
  _search.DisableControls;
  try
    if _search.Active then
      _search.Close;
    _search.SQL.Clear;
    _search.SQL.Add(sql);
    if _search.Params.Count = 1 then
      _search.ParamByName('search').AsString := Format('%s%%',[s]);
    _search.Open;
    _search.FieldByName('statut').OnGetText := statutGetText;
  finally
    _search.EnableControls;
  end;
end;

procedure TinscJouW.searchGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
const
  cl: array[TRegistrationStatus] of TColor = (clSilver,clCream,$00DDBBFF);
begin
  inherited;
  with searchGrid.Canvas do
  begin
    try
      if not (searchGrid.DataSource.DataSet.IsEmpty) and
         not (searchGrid.DataSource.DataSet.FieldByname('statut').AsString = '') then
        Brush.Color := cl[TRegistrationStatus(searchGrid.DataSource.DataSet.FieldByName('statut').Value)];
      if (gdSelected in State) or (gdRowSelected in State) then
        Font.Style := [fsBold];
    except

    end;
  end;
  searchGrid.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TinscJouW.searchGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Key := 0;
  search.SelectAll;
  search.SetFocus;
end;

procedure TinscJouW.searchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;
    search.SelectAll;
  end
  else if Key = VK_ESCAPE then
  begin
    Key := 0;
    if search.Text <> '' then
      search.Clear
    else
      Close;
  end;
end;

procedure TinscJouW.statutGetText(Sender: TField; var Text: string;
  DisplayText: boolean);
const
  statut: array[TRegistrationStatus] of string = ('Eliminé','Qualifié','W-O');
begin
  Text := statut[TRegistrationStatus(Sender.AsInteger)];
end;

end.
