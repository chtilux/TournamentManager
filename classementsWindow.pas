unit classementsWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dataWindow, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TclassementsW = class(TdataW)
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.dfm}

procedure TclassementsW.FormCreate(Sender: TObject);
begin
  inherited;
  pvData.SQL.Add('select codcls,libcls,numseq,catage,selcls from classement order by catage,codcls');
  pvData.Open;
end;

end.
