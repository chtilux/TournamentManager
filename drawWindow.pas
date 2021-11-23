unit drawWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Inifiles, Vcl.ExtCtrls, lal_connection;

type
  TdrawW = class(TForm)
    drawImage: TImage;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
  private
    { Déclarations privées }
    pvSertab,
    pvSermtc: integer;
    pvCnx: TLalConnection;
    procedure iniReadCallback(ini: TInifile);
    procedure iniWriteCallback(ini: TInifile);
    procedure drawDraw;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent; cnx: TLalConnection; sertab, sermtc: integer); reintroduce; overload;
  end;

implementation

{$R *.dfm}

uses
  lal_utils, draw;

constructor TdrawW.Create(AOwner: TComponent; cnx: TLalConnection; sertab, sermtc: integer);
begin
  inherited Create(AOwner);
  pvCnx := cnx;
  pvSertab := sertab;
  pvSermtc := sermtc;
end;

procedure TdrawW.drawDraw;
var
  d: TDraw;
  bmp: TBitmap;
begin
  if (pvSertab = 0) then Exit;

  d := TDraw.Create(pvCnx,pvSertab,pvSermtc);
  try
    bmp := TBitmap.Create;
    try
      bmp.SetSize(drawImage.Width,drawImage.Height);
      d.Detailled := True;
      d.display(bmp.Canvas);
      drawImage.Picture := nil;
      drawImage.Picture.Assign(bmp);
    finally
      bmp.Free;
    end;
  finally
    d.Free;
  end;
end;

procedure TdrawW.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  writeFormPos(Self,iniWriteCallback);
  Action := caFree;
end;

procedure TdrawW.FormResize(Sender: TObject);
begin
  drawDraw;
end;

procedure TdrawW.FormShow(Sender: TObject);
begin
  readFormPos(Self,iniReadCallback);
  drawDraw;
end;

procedure TdrawW.iniReadCallback(ini: TInifile);
begin
  Left := ini.ReadInteger('Self','Left',Self.Left);
  Top := ini.ReadInteger('Self','Top',Self.Top);
  Height := ini.ReadInteger('Self','Height',Self.Height);
  Width := ini.ReadInteger('Self','Width',Self.Width);
end;

procedure TdrawW.iniWriteCallback(ini: TInifile);
begin
  ini.WriteInteger('Self','Left',Self.Left);
  ini.WriteInteger('Self','Top',Self.Top);
  ini.WriteInteger('Self','Height',Self.Height);
  ini.WriteInteger('Self','Width',Self.Width);
end;

end.
