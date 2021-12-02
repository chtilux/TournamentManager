unit tournamentsWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dataWindow, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, ZDataset, Vcl.ComCtrls;

type
  TtournamentsW = class(TdataW)
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    procedure BeforeDelete(Dataset: TDataset);
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.dfm}

uses
  lal_utils, tmUtils15;

procedure TtournamentsW.FormCreate(Sender: TObject);
begin
  inherited;
  pvData.SQL.Add('select sertrn,saison,dattrn,organisateur,libelle'
               +' from tournoi'
               +' order by saison desc,dattrn desc');
  pvData.BeforeDelete := BeforeDelete;
  pvData.Open;
end;

procedure TTournamentsW.BeforeDelete(Dataset: TDataset);
begin
  deleteTournament(pvData.FieldByName('sertrn').AsInteger);
  Abort;
end;

procedure TtournamentsW.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
  dbgrid_highlight_current(TDBGrid(sender),Rect,DataCol,Column,State);
  TDBGrid(sender).DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TtournamentsW.DBGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  dbgrid_mousemove(TDBGrid(Sender),Shift,X,Y);
end;

procedure TtournamentsW.DBGrid1DblClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

end.
