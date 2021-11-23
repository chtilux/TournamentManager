unit getTableNumberDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  ZDataset,ZAbstractRODataset, System.Actions, Vcl.ActnList, lal_connection;

type
  TgetTableNumberDlg = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ActionList1: TActionList;
    okAction: TAction;
    cancelAction: TAction;
    procedure FormShow(Sender: TObject);
    procedure cancelActionExecute(Sender: TObject);
    procedure okActionExecute(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Déclarations privées }
    tables: TZReadOnlyQuery;
    function GetPlayAreaNumber: integer;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent; cnx: TLalConnection; const sertrn: integer); reintroduce; overload;
    property PlayAreaNumber: integer read GetPlayAreaNumber;
  end;

var
  getTableNumberDlg: TgetTableNumberDlg;

implementation

{$R *.dfm}

uses
  tmUtils15, lal_dbUtils, TMEnums;

procedure TgetTableNumberDlg.cancelActionExecute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

constructor TgetTableNumberDlg.Create(AOwner: TComponent; cnx: TLalConnection;
  const sertrn: integer);
begin
  inherited Create(AOwner);
  tables := getROQuery(cnx, Self);
  tables.SQL.Add('select numtbl,umpire from umpires'
                +' where statbl = ' + Ord(pasAvailable).ToString
                +'   and sertrn = ' + sertrn.ToString
                +' order by 1');
  DataSource1.DataSet := tables;
end;

procedure TgetTableNumberDlg.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    ModalResult := mrOk
  else if Key = VK_CANCEL then
   ModalResult := mrCancel;
end;

procedure TgetTableNumberDlg.FormShow(Sender: TObject);
begin
  if tables.Active then
    tables.Refresh
  else
    tables.Open;
end;

function TgetTableNumberDlg.GetPlayAreaNumber: integer;
begin
  Result := tables.FieldByName('numtbl').AsInteger;
end;

procedure TgetTableNumberDlg.okActionExecute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
