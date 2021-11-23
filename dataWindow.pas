unit dataWindow;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.DBCtrls, ZDataset, Vcl.ComCtrls, ZConnection;

type
  TdataW = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Panel1: TPanel;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    dataSource: TDataSource;
    SB: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
  protected
    pvData: TZQuery;
    pvCnx: TZConnection;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent; cnx: TZConnection); reintroduce; overload;
    property data: TZQuery read pvData;
  end;

implementation

{$R *.dfm}

//uses
//  tmUtils;

constructor TdataW.Create(AOwner: TComponent; cnx: TZConnection);
begin
  pvCnx := cnx;
  inherited Create(AOwner);
end;

procedure TdataW.FormCreate(Sender: TObject);
begin
  pvData := TZQuery.Create(Self);
  pvData.Connection := pvCnx;
  dataSource.DataSet := pvData;
end;

procedure TdataW.FormShow(Sender: TObject);
begin
  if not pvData.IsEmpty then
    DBGrid1.SetFocus;
end;

end.
