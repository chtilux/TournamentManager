unit matchesWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, childWindow, Vcl.ExtCtrls, ZDataset,
  Vcl.StdCtrls;

type
  TmatchesW = class(TchildW)
    organisateur: TStaticText;
    handicap: TStaticText;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    workspacePanel: TPanel;
    hsb: TScrollBar;
    vsb: TScrollBar;
    procedure FormShow(Sender: TObject);
    procedure workspacePanelResize(Sender: TObject);
    //procedure midpanelResize(Sender: TObject);
  private
    { Déclarations privées }
    _sertab: integer;
    _taille: integer;
    _levels: integer;
    procedure load;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent; const sertab: integer); reintroduce; overload;
  end;

implementation

{$R *.dfm}

uses
  lal_dbUtils, tmUtils, matchPanel;

const
  numrows: integer = 16;

{ TmatchesW }

constructor TmatchesW.Create(AOwner: TComponent; const sertab: integer);
const
  hdc: array[boolean] of string = ('','par handicap');
  simple: array[boolean] of string = ('doubles','simples');
var
  i,j: integer;
begin
  _sertab := sertab;
  inherited Create(AOwner);
  with getROQuery(_cnx) do
  begin
    try
      SQL.Add('select codcat,heudeb,simple,handicap,dattrn,organisateur,libelle'
             +'   ,taille,nbrjou,nbrtds'
             +' from categories a, tournoi b, tableau c'
             +' where a.sertrn = b.sertrn'
             +'   and a.sercat = c.sertab'
             +'   and sercat = :sercat');
      ParamByName('sercat').AsInteger := sertab;
      Open;
      Caption := FieldByName('codcat').AsString;
      organisateur.Caption := Format('%s - %s',[FieldByName('organisateur').AsString,FieldByName('libelle').AsString]);
      handicap.Caption := Format('%s - %s %s - Tableau de %d - %d joueurs - %d têtes de séries',[FieldByName('codcat').AsString,simple[FieldByName('simple').AsString = '1'],hdc[FieldByName('handicap').AsString='1'],FieldByName('taille').AsInteger,FieldByName('nbrjou').AsInteger,FieldByName('nbrtds').AsInteger]);
      _taille := FieldByName('taille').AsInteger;
      i := _taille;
      j := 0;
      while (i div 2) >= 1 do
      begin
        Inc(j);
        i := i div 2;
      end;
      _levels := j;
      hsb.Min := 1;
      hsb.Max := 4;
      vsb.Min := 1;
      vsb.Max := _taille div numrows;
      Close;
    finally
      Free;
    end;
  end;
end;

procedure TmatchesW.FormShow(Sender: TObject);
begin
  inherited;
  Screen.Cursor := crHourglass;
  try
    load;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TmatchesW.load;
var
  z: TZReadOnlyQuery;
  mp: TMatchPanel;
  i: integer;
  m: TMatch;
const
  margin: integer = 3;
  cl: array[0..3] of TColor = (clSilver,clGreen,clAqua,clDkGray);
begin
  z := getROQuery(_cnx);
  try
    z.SQL.Add('select taille from tableau where sertab = :sertab');
    z.ParamByName('sertab').AsInteger := _sertab;
    z.Open;
    z.Close;
    z.SQL.Clear;
    z.SQL.Add('select sermtc,level,nummtc,stamtc'
             +' from match'
             +' where sertab = :sertab'
             +' order by level,nummtc');
    z.ParamByName('sertab').AsInteger := _sertab;
    i := 0;
    z.Open;
    while not z.Eof do
    begin
      m := TMatch.Create(_cnx,z.FieldByName('sermtc').AsInteger);
      m.level := z.FieldByName('level').AsInteger;
      m.numero := z.FieldByName('nummtc').AsString;

      mp := TMatchPanel.Create(_cnx);
      mp.Parent := workspacePanel;
      mp.ParentColor := False;
      mp.Color := cl[z.FieldByName('stamtc').AsInteger];
      mp.Visible := True;
      mp.Tag := i;
      mp.match := m;

      z.Next;
      Inc(i);
      Application.ProcessMessages;
    end;
    z.Close;
  finally
    z.Free;
  end;
end;

procedure TmatchesW.workspacePanelResize(Sender: TObject);
var
  taille, i, cw, ch, w, h: integer;
  mp: TMatchPanel;
  z: TZReadOnlyQuery;
const
  margin: integer = 3;
begin
  inherited;
  z := getROQuery(_cnx);
  try
    z.SQL.Add('select taille from tableau where sertab = :sertab');
    z.ParamByName('sertab').AsInteger := _sertab;
    z.Open;
    taille := z.FieldByName('taille').AsInteger;
    z.Close;
  finally
    z.Free;
  end;
  cw := midPanel.ClientWidth;
  ch := midpanel.ClientHeight;
  w := (cw-2*margin) div 8;
  h := (ch-2*margin) div (taille div 2);
  for i := 0 to workspacePanel.ControlCount-1 do
  begin
    if workspacePanel.Controls[i] is TMatchPanel then
    begin
      mp := TMatchPanel(midPanel.Controls[i]);
      mp.Width := w;
      mp.Height := h;
      mp.Left := margin + Pred(mp.Level) * w;
      mp.Top := margin + mp.Tag * h;
    end;
  end;
end;

end.
