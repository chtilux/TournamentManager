unit defValuesWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dataWindow, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TdefvaluesW = class(TdataW)
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.dfm}

procedure TdefvaluesW.FormCreate(Sender: TObject);
begin
  inherited;
  pvData.SQL.Add('select tablename,colname,defvalue from defvalues'
               +' order by tablename,colname');
  pvData.Open;
end;

end.
