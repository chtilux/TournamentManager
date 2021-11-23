unit childWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, ZDataset, DB;

type
  TchildW = class(TForm)
    topPanel: TPanel;
    midpanel: TPanel;
    bottomPanel: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Déclarations privées }
  protected
  public
    { Déclarations publiques }
  end;

  TChildWindowClass = class of TChildW;

implementation

{$R *.dfm}

procedure TchildW.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
