unit internetWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  OverbyteIcsWndControl, OverbyteIcsFtpCli, Vcl.StdCtrls, Vcl.CheckLst,
  Vcl.FileCtrl;

type
  TinternetW = class(TForm)
    Panel1: TPanel;
    pg: TPageControl;
    catTab: TTabSheet;
    setTab: TTabSheet;
    ftp: TFtpClient;
    userName: TLabeledEdit;
    password: TLabeledEdit;
    hostName: TLabeledEdit;
    hostDirName: TLabeledEdit;
    localDirName: TLabeledEdit;
    connect: TButton;
    send: TButton;
    disconnect: TButton;
    localFilenames: TFileListBox;
    pb: TProgressBar;
    procedure FormShow(Sender: TObject);
    procedure connectClick(Sender: TObject);
    procedure disconnectClick(Sender: TObject);
    procedure sendClick(Sender: TObject);
  private
    { Déclarations privées }
    _sertrn: integer;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent; const sertrn: integer); reintroduce; overload;
  end;


implementation

{$R *.dfm}

uses
  tmUtils15;

{ TinternetW }

procedure TinternetW.connectClick(Sender: TObject);
begin
  ftp.UserName := userName.Text;
  ftp.PassWord := password.Text;
  ftp.HostName := hostName.Text;
  ftp.HostDirName := hostDirName.Text;
  ftp.Passive := True;
  ftp.Binary := True;
  ftp.Connect;
  send.Enabled := ftp.Connected;
  disconnect.Enabled := ftp.Connected;
  connect.Enabled := False;
end;

constructor TinternetW.Create(AOwner: TComponent; const sertrn: integer);
begin
  _sertrn := sertrn;
  inherited Create(AOwner);
end;

procedure TinternetW.disconnectClick(Sender: TObject);
begin
  ftp.Quit;
  connect.Enabled := True;
  send.Enabled := False;
  disconnect.Enabled := False;
end;

procedure TinternetW.FormShow(Sender: TObject);
begin
//  userName.Text := getSettingsValue('ftpUsername','luclacroxb');
//  password.Text := getSettingsValue('ftpPassword','Klm789rty');
//  hostName.Text := getSettingsValue('ftpHostname','ftp.cluster023.hosting.ovh.net');
//  hostDirName.Text := getSettingsValue('ftpHostDirName','/www/tm/docs');
  userName.Text := glSettings.Read('settings.internet','ftpUsername','pardc1','luclacroxb');
  password.Text := glSettings.Read('settings.internet','ftpPassword','pardc1','Klm789rty');
  hostName.Text := glSettings.Read('settings.internet','ftpHostname','pardc1','ftp.cluster023.hosting.ovh.net');
  hostDirName.Text := glSettings.Read('settings.internet','ftpHostDirName','pardc1','/www/tm/docs');
//  localDirName.Text := Format('%s\%s', [ExcludeTrailingPathDelimiter(glSettings.Read('export','c:\work\export')),getExportDirectory(_sertrn)]);
  localDirName.Text := buildExportDirectory(_sertrn);
  localFilenames.Directory := localDirName.Text;
  connect.Enabled := True;
  send.Enabled := False;
  disconnect.Enabled := False;
  pb.Visible := False;
end;

procedure TinternetW.sendClick(Sender: TObject);
var
  files: TStrings;
  i: integer;
begin
  files := TStringList.Create;
  try
    for i := 0 to localFilenames.Count-1 do
      if localFilenames.Selected[i] then
        files.Add(IncludeTrailingPathDelimiter(localDirName.Text)+localFilenames.Items[i]);

    if files.Count > 0 then
    begin
      pb.Max := files.Count;
      pb.Position := 0;
      pb.Visible := True;
      if not ftp.Connected then
        ftp.Connect;
      ftp.Cwd;
      for i := 0 to files.Count-1 do
      begin
        ftp.LocalFileName := files[i];
        ftp.HostFileName := ExtractFilename(files[i]);
        ftp.Put;
        pb.Position := pb.Position + 1;
        pb.Update;
      end;
    end;
  finally
    files.Free;
    pb.Visible := False;
  end;
end;

end.
