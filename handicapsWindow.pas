unit handicapsWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dataWindow, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls;

type
  ThandicapsW = class(TdataW)
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.dfm}

procedure ThandicapsW.FormCreate(Sender: TObject);
begin
  inherited;
  pvData.SQL.Add('select cl1,cl2,hdc from handicap order by cl1,cl2');
  pvData.Open;
end;

end.
