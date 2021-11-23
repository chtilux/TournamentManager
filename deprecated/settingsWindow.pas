unit settingsWindow;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.ValEdit, Vcl.ImgList, lal_connection;

type
  TsettingsW = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    pg: TPageControl;
    general: TTabSheet;
    OKBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    Panel3: TPanel;
    generalList: TValueListEditor;
    workingDirectoryEdit: TButtonedEdit;
    Label1: TLabel;
    tournamentsEdit: TButtonedEdit;
    Label2: TLabel;
    Label3: TLabel;
    exportDirectoryEdit: TButtonedEdit;
    templatesDirectoryLabel: TLabel;
    templatesDirectoryEdit: TButtonedEdit;
    Label4: TLabel;
    flttResultsDocumentEdit: TButtonedEdit;
    Label5: TLabel;
    drawTemplateEdit: TButtonedEdit;
    ImageList1: TImageList;
    procedure workingDirectoryEditRightButtonClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure tournamentsEditRightButtonClick(Sender: TObject);
    procedure exportDirectoryEditRightButtonClick(Sender: TObject);
    procedure templatesDirectoryEditRightButtonClick(Sender: TObject);
    procedure flttResultsDocumentEditRightButtonClick(Sender: TObject);
    procedure drawTemplateEditRightButtonClick(Sender: TObject);
  private
    { Déclarations privées }
    pvCnx: TLalConnection;
    function getDirectory(eInitialDir: string): string;
    function getFilename(eInitialDir: string): string; overload;
    function getFilename(eInitialDir: string; const afilter: string): string; overload;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent; var values: TStrings); reintroduce; overload;
    constructor Create(AOwner: TComponent; var values: TStrings; cnx: TLalConnection); reintroduce; overload;
    constructor Create(AOwner: TComponent; cnx: TLalConnection); reintroduce; overload;
  end;

implementation

{$R *.dfm}

uses
  Dialogs, tmUtils15, FileCtrl;

{ TsettingsW }

constructor TsettingsW.Create(AOwner: TComponent; var values: TStrings);
begin
  inherited Create(AOwner);
  generalList.Strings.Assign(values);
end;

constructor TsettingsW.Create(AOwner: TComponent; cnx: TLalConnection);
begin
  inherited Create(AOwner);
  pvCnx := cnx;
  glSettings.Read;
  workingDirectoryEdit.Text := glSettings.WorkingDirectory;
  tournamentsEdit.Text := glSettings.TournamentsDirectory;
  exportDirectoryEdit.Text := glSettings.ExportDirectory;
  templatesDirectoryEdit.Text := glSettings.TemplatesDirectory;
  flttResultsDocumentEdit.Text := glSettings.FLTTResultsDocument;
  drawTemplateEdit.Text := glSettings.DrawTemplatePattern;
end;

procedure TsettingsW.drawTemplateEditRightButtonClick(Sender: TObject);
begin
  drawTemplateEdit.Text := ExtractFileName(getFilename(templatesDirectoryEdit.Text));
end;

constructor TsettingsW.Create(AOwner: TComponent; var values: TStrings;
  cnx: TLalConnection);
begin
  Create(AOwner, values);
  pvCnx := cnx;
  glSettings.Read;
  workingDirectoryEdit.Text := glSettings.WorkingDirectory;
  tournamentsEdit.Text := glSettings.TournamentsDirectory;
  exportDirectoryEdit.Text := glSettings.ExportDirectory;
  templatesDirectoryEdit.Text := glSettings.TemplatesDirectory;
  flttResultsDocumentEdit.Text := glSettings.FLTTResultsDocument;
  drawTemplateEdit.Text := glSettings.DrawTemplatePattern;
end;

function TsettingsW.getDirectory(eInitialDir: string): string;
var
  dir: string;
const
  SELDIRHELP = 1000;
begin
  Result := eInitialDir;
  if SelectDirectory(eInitialDir, [sdAllowCreate, sdPerformCreate, sdPrompt],SELDIRHELP) then
    Result := ExtractFileName(ExcludeTrailingPathDelimiter(eInitialDir));
end;

function TsettingsW.getFilename(eInitialDir: string;
  const afilter: string): string;
begin
  Result := eInitialDir;
  with TOpenDialog.Create(Self) do
  begin
    try
      InitialDir := templatesDirectoryEdit.Text;
      Filter := afilter;
      FilterIndex := 1;
      Options := [ofFileMustExist];
      if Execute then
        Result := Filename;
    finally
      Free;
    end;
  end;
end;

function TsettingsW.getFilename(eInitialDir: string): string;
begin
  Result := eInitialDir;
  with TOpenDialog.Create(Self) do
  begin
    try
      InitialDir := templatesDirectoryEdit.Text;
      Filter := 'Excel Files (*.xlsx,*.xltx,*.xls)|*.xlsx;*.xltx;*.xls|All files (*.*)|*.*';
      FilterIndex := 1;
      Options := [ofFileMustExist];
      if Execute then
        Result := Filename;
    finally
      Free;
    end;
  end;
end;

procedure TsettingsW.templatesDirectoryEditRightButtonClick(Sender: TObject);
begin
  templatesDirectoryEdit.Text := getDirectory(templatesDirectoryEdit.Text);
end;

procedure TsettingsW.tournamentsEditRightButtonClick(Sender: TObject);
begin
  tournamentsEdit.Text := getDirectory(tournamentsEdit.Text);
end;

procedure TsettingsW.workingDirectoryEditRightButtonClick(Sender: TObject);
begin
  workingDirectoryEdit.Text := getDirectory(workingDirectoryEdit.Text);
end;

procedure TsettingsW.exportDirectoryEditRightButtonClick(Sender: TObject);
begin
  exportDirectoryEdit.Text := getDirectory(exportDirectoryEdit.Text);
end;

procedure TsettingsW.flttResultsDocumentEditRightButtonClick(Sender: TObject);
begin
  flttResultsDocumentEdit.Text := ExtractFileName(getFilename(templatesDirectoryEdit.Text));
end;

procedure TsettingsW.OKBtnClick(Sender: TObject);
begin
  glSettings.WorkingDirectory := Self.workingDirectoryEdit.Text;
  glSettings.TournamentsDirectory := Self.tournamentsEdit.Text;
  glSettings.ExportDirectory := Self.exportDirectoryEdit.Text;
  glSettings.TemplatesDirectory := Self.templatesDirectoryEdit.Text;
  glSettings.FLTTResultsDocument := Self.flttResultsDocumentEdit.Text;
  glSettings.DrawTemplatePattern := Self.drawTemplateEdit.Text;
  glSettings.Write;
end;

end.

