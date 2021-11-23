unit dataGridWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, lal_connection, Vcl.ComCtrls;

type
  TdataGridW = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel3: TPanel;
    nav: TDBNavigator;
    source: TDataSource;
    ok: TBitBtn;
    cancel: TBitBtn;
    data: TZQuery;
    Panel9: TPanel;
    PageControl1: TPageControl;
    gridSheet: TTabSheet;
    grid: TDBGrid;
  private
    { Déclarations privées }
  protected
    cnx: TLalConnection;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent; cnx: TLalConnection); reintroduce; overload;
  end;

implementation

{$R *.dfm}

{ TForm1 }

constructor TdataGridW.Create(AOwner: TComponent; cnx: TLalConnection);
begin
  Self.cnx := cnx;
  inherited Create(AOwner);
end;

end.
