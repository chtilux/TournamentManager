unit umpiresWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, ZDataset,
  Vcl.DBGrids, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, lal_connection;

type
  TumpiresW = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
    _z: TZReadOnlyQuery;
    procedure numtblGetText(Sender: TField; var Text: string; DisplayText: boolean);
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent; cnx: TLalConnection; const sertrn: integer); reintroduce; overload;
  end;

implementation

{$R *.dfm}

uses
  lal_dbUtils;

procedure TumpiresW.Button1Click(Sender: TObject);
begin
  _z.Refresh;
end;

constructor TumpiresW.Create(AOwner: TComponent; cnx: TLalConnection; const sertrn: integer);
begin
  inherited Create(AOwner);
  _z := getROQuery(cnx, Self);
  _z.SQL.Add('select distinct numtbl,codcat,nomjou,modifie'
            +' from match a, categories b, tablo c'
            +' where a.perdant > 0'
            +'   and a.sertrn = :sertrn'
            +'   and a.sertab = b.sercat'
            +'   and a.numtbl is not null'
            +'   and a.modifie = (select max(modifie) from match x where x.sertrn = a.sertrn and x.numtbl = a.numtbl)'
            +'   and c.serjou = a.perdant'
            +' order by 1');
  _z.ParamByName('sertrn').AsInteger := sertrn;
  DataSource1.DataSet := _z;
end;

procedure TumpiresW.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TumpiresW.FormShow(Sender: TObject);
begin
  DataSource1.DataSet.Open;
  DataSource1.DataSet.FieldByName('numtbl').OnGetText := numtblGetText;
end;

procedure TumpiresW.numtblGetText(Sender: TField; var Text: string;
  DisplayText: boolean);
var
  i: integer;
begin
  DisplayText := Sender.AsString <> '';
  if DisplayText then
    if TryStrToInt(Sender.AsString,i) then
      Text := Format('Table %.2d',[i])
    else
      Text := Format('Table %s',[Sender.AsString]);
end;

end.
