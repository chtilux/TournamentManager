unit clscatageWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  lal_connection;

type
  TclscatageW = class(TForm)
    Bevel1: TBevel;
    OKBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    lv: TListView;
    allButton: TButton;
    procedure allButtonClick(Sender: TObject);
  private
    { Déclarations privées }
    _catage: string;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent; cnx: TLalConnection; catage: string = '0'); reintroduce; overload;
  end;

var
  clscatageW: TclscatageW;

implementation

{$R *.dfm}

uses
  lal_dbUtils;

{ TForm1 }

constructor TclscatageW.Create(AOwner: TComponent; cnx: TLalConnection; catage: string);
begin
  _catage := catage;
  inherited Create(AOwner);
  with getROQuery(cnx) do
  begin
    try
      SQL.Add('select codcls, libcls, numseq from classement');
      if _catage <> '*' then
        SQL.Add(' where catage = ' + QuotedStr(_catage));
      SQL.Add(' order by numseq');
      Open;
      while not Eof do
      begin
        with lv.Items.Add do
        begin
          Caption := Fields[0].AsString;
          SubItems.Add(Fields[1].AsString);
        end;
        Next;
      end;
      Close;
    finally
      Free;
    end;
  end;
end;


procedure TclscatageW.allButtonClick(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  for i := 0 to lv.Items.Count-1 do
    lv.Items[i].Checked := True;
end;

end.
