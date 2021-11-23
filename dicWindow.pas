unit dicWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dataGridWindow, Data.DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, Vcl.DBCtrls, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TdicW = class(TdataGridW)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure gridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; AState: TGridDrawState);
    procedure gridDblClick(Sender: TObject);
  private
    { Déclarations privées }
    FColorsChanged: boolean;
    pvCledic: string;
  public
    { Déclarations publiques }
    procedure beforePost(Dataset: TDataset);
    procedure afterPost(Dataset: TDataset);
    property colorsChanged: boolean read FColorsChanged default False;
  end;

implementation

{$R *.dfm}

procedure TdicW.afterPost(Dataset: TDataset);
begin
  if (pvCledic = 'COLORS') then
    FColorsChanged := True;
end;

procedure TdicW.beforePost(Dataset: TDataset);
begin
  pvCledic := Dataset.FieldByName('cledic').AsString.ToUpper;
end;

procedure TdicW.FormCreate(Sender: TObject);
begin
  inherited;
  data.Connection := cnx.get;
  data.SQL.Add('select * from dictionnaire'
              +' order by cledic,coddic');
  data.BeforePost := beforePost;
  data.AfterPost := afterPost;
  FColorsChanged := False;
end;

procedure TdicW.FormDestroy(Sender: TObject);
begin
  data.Close;
  inherited;
end;

procedure TdicW.FormShow(Sender: TObject);
begin
  inherited;
  data.Open;
  grid.DataSource := source;
end;

procedure TdicW.gridDblClick(Sender: TObject);
var
  cl: TColor;
begin
  inherited;
  with TDBGrid(Sender), TDBGrid(Sender).DataSource.DataSet do
  begin
    if Eof then Exit;

    if (FieldByName('cledic').AsString.ToUpper = 'COLORS') and  (SelectedField.FieldName.ToUpper = 'PARDC1') then
    begin
      try
        cl := StringToColor(SelectedField.AsString);
      except
        cl := clWindow;
      end;
      with TColorDialog.Create(Self) do
      begin
        try
          Color := cl;
          if Execute then
          begin
            if Color <> cl then
            begin
              Edit;
              FieldByName('pardc1').AsString := ColorToString(Color);
            end;
          end;
        finally
          Free;
        end;
      end;

    end;
  end;
end;

procedure TdicW.gridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
var
  cl: TColor;
begin
  inherited;
  with TDBGrid(Sender), TDBGrid(Sender).DataSource.DataSet, TDBGrid(Sender).Canvas do
  begin
    if Eof then Exit;

    if (FieldByName('cledic').AsString.ToUpper = 'COLORS') and  (Column.Field.FieldName.ToUpper = 'PARDC1') then
    begin
      try
        cl := StringToColor(Column.Field.AsString);
      except
        cl := clWindow;
      end;
      Canvas.Brush.Color := cl;
    end;
    if gdSelected in AState then
    begin
      Brush.Color := clHighlight;
      Font.Color := clHighlightText;
    end;
    DefaultDrawColumnCell(Rect,DataCol,Column,AState);
  end;
end;

end.
