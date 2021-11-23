unit SeekConfigsWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dataWindow, Data.DB, Vcl.ComCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons;

type
  TSeekConfigsW = class(TdataW)
    ConfigureButton: TBitBtn;
    NewButton: TBitBtn;
    DuplicateButton: TBitBtn;
    ExportAsXMLButton: TBitBtn;
    Memo1: TMemo;
    ImporteFromXMLButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure ConfigureButtonClick(Sender: TObject);
    procedure NewButtonClick(Sender: TObject);
    procedure DuplicateButtonClick(Sender: TObject);
    procedure ExportAsXMLButtonClick(Sender: TObject);
    procedure ImporteFromXMLButtonClick(Sender: TObject);
    procedure dataSourceDataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  lal_seek;

procedure TSeekConfigsW.ConfigureButtonClick(Sender: TObject);
begin
  inherited;
  with TLalSeek.Create(nil) do
  begin
    try
      Connection := pvCnx;
      ID := Self.pvData.FieldByName('id').AsInteger;
      configure;
      Self.pvData.Refresh;
    finally
      Free;
    end;
  end;
end;

procedure TSeekConfigsW.NewButtonClick(Sender: TObject);
begin
  inherited;
  with TLalSeek.Create(nil) do
  begin
    try
      Connection := pvCnx;
      ID := -1;
      configure;
      Self.pvData.Refresh;
    finally
      Free;
    end;
  end;
end;

procedure TSeekConfigsW.dataSourceDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  if Field = nil then
  begin
    Memo1.Lines.Clear;
    Memo1.Lines.Add(TDataSource(Sender).DataSet.FieldByName('source').AsString);
    if TDataSource(Sender).DataSet.FieldByName('params').AsString <> '' then
    begin
      Memo1.Lines.Add(StringOfChar('-',20)+' params '+StringOfChar('-',20));
      Memo1.Lines.Add(TDataSource(Sender).DataSet.FieldByName('params').AsString);
    end;
    if TDataSource(Sender).DataSet.FieldByName('returning').AsString <> '' then
    begin
      Memo1.Lines.Add(StringOfChar('-',20)+' return '+StringOfChar('-',20));
      Memo1.Lines.Add(TDataSource(Sender).DataSet.FieldByName('returning').AsString);
    end;
    if TDataSource(Sender).DataSet.FieldByName('fieldname').AsString <> '' then
    begin
      Memo1.Lines.Add(StringOfChar('-',20)+' fieldname '+StringOfChar('-',20));
      Memo1.Lines.Add(TDataSource(Sender).DataSet.FieldByName('fieldname').AsString);
    end;
  end;
end;

procedure TSeekConfigsW.DuplicateButtonClick(Sender: TObject);
begin
  inherited;
  with TLalSeek.Create(nil) do
  begin
    try
      Connection := pvCnx;
      ID := Self.pvData.FieldByName('id').AsInteger;
      ID := Duplicate;
      configure;
      Self.pvData.Refresh;
    finally
      Free;
    end;
  end;
end;

procedure TSeekConfigsW.ExportAsXMLButtonClick(Sender: TObject);
var
  xml: TStrings;
begin
  inherited;
  Memo1.Lines.Clear;
  if DBGrid1.SelectedRows.Count = 0 then
  begin
    xml := TLalSeek.GetConfigsAsXML(pvCnx);
    try
      Memo1.Lines.AddStrings(xml);
    finally
      xml.Free;
    end;
  end
  else
  begin
    xml := TLalSeek.GetConfigsAsXML(DBGrid1);
    try
      Memo1.Lines.AddStrings(xml);
    finally
      xml.Free;
    end;
  end
end;

procedure TSeekConfigsW.FormCreate(Sender: TObject);
begin
  inherited;
  pvData.SQL.Add('SELECT id,seek_code,description,source,params,returning,fieldname'
                +' FROM seek_config'
                +' ORDER BY 2');
  pvData.Open;
end;

procedure TSeekConfigsW.ImporteFromXMLButtonClick(Sender: TObject);
begin
  inherited;
  if Memo1.Lines.Count > 0 then
    TLalSeek.ImportXML(pvCnx, Memo1.Lines);
end;

end.
