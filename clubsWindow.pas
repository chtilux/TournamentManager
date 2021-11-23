unit clubsWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dataWindow, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TclubsW = class(TdataW)
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.dfm}

procedure TclubsW.FormCreate(Sender: TObject);
begin
  inherited;
  pvdata.SQL.Add('select codclb,libclb from club order by codclb');
  pvData.Open;
end;

end.
