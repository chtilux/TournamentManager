unit catageWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dataWindow, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Buttons;

type
  TcatageW = class(TdataW)
    newButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure newButtonClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.dfm}

uses
  lal_dbUtils, tmUtils15;

procedure TcatageW.FormCreate(Sender: TObject);
begin
  inherited;
  pvData.SQL.Add('select catage,saison,inferieur,superieur,numseq from catage order by saison,numseq');
  pvData.Open;
end;

procedure TcatageW.newButtonClick(Sender: TObject);
var
  catage: string;
  inferieur,
  superieur: integer;
  numseq: smallint;
begin
  inherited;
  catage := data.FieldByName('catage').AsString;
  inferieur := data.FieldByName('inferieur').AsInteger;
  superieur := data.FieldByName('superieur').AsInteger;
  numseq := data.FieldByName('numseq').AsInteger;
  if data.State in dsEditModes then
    data.Post;
  data.Insert;
  data.FieldByName('saison').AsInteger := Succ(getCurrentSaison);
  data.FieldByName('catage').AsString := catage;
  if inferieur > 0 then data.FieldByName('inferieur').AsInteger := Succ(inferieur);
  if superieur > 0 then data.FieldByName('superieur').AsInteger := Succ(superieur);
  data.FieldByName('numseq').AsInteger := numseq;
  //data.Post;
end;

end.
