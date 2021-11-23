unit styleWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.Styles.Ext, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ToolWin,
  Vcl.ExtCtrls,Vcl.ActnList;

type
  TstyleW = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Panel2: TPanel;
    previewPanel: TPanel;
    Splitter1: TSplitter;
    ListView1: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    _style: string;
    Loading: boolean;
    FStylesPath: string;
    FPreview: TVclStylesPreview;
    procedure getStyleNames;
    procedure clearVCLStylesList;
  public
    { Déclarations publiques }
    property styleName: string read _style write _style;
  end;

implementation

{$R *.dfm}

uses
 IOUtils,
  Vcl.Themes,
  Vcl.Styles;


{ TstyleW }

procedure TstyleW.BitBtn3Click(Sender: TObject);
begin
  if (ListView1.Selected<>nil) and (ListView1.Selected.Caption='Resource') then
  begin
    TStyleManager.SetStyle(styleName);
  end;
end;

procedure TstyleW.clearVCLStylesList;
var
  i: integer;
begin
  for i := 0 to Pred(ListView1.Items.Count) do
  begin
    if Assigned(ListView1.Items[i].Data) then
      TCustomStyleExt(ListView1.Items[i].Data).Free;
  end;
  ListView1.items.clear;
end;

procedure TstyleW.FormCreate(Sender: TObject);
begin
  Loading := False;
  ReportMemoryLeaksOnShutdown := False;
  FStylesPath := IncludeTrailingPathDelimiter('c:\work\styles\');
  FPreview := TVclStylesPreview.Create(Self);
  FPreview.Parent := previewPanel;
  FPreview.BoundsRect := previewPanel.ClientRect;
  Screen.Cursor := crHourglass;
  try
    Update;
    getStyleNames;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TstyleW.FormDestroy(Sender: TObject);
begin
  clearVCLStylesList;
  Fpreview.Free;
end;

procedure TstyleW.FormShow(Sender: TObject);
var
  item: TListItem;
begin
  if ListView1.Items.Count > 0 then
  begin
    item := ListView1.FindCaption(0,styleName,False,True,False);
    if item <> nil then
      ListView1.Selected := item;
  end;
end;

procedure TstyleW.getStyleNames;
Var
 StyleName: string;
 Item     : TListItem;
 StyleInfo:  TStyleInfo;
 SourceInfo: TSourceInfo;
 VCLStyleExt:TCustomStyleServices;
begin
   Loading:=True;

   for StyleName in  TStyleManager.StyleNames do
     if not SameText(StyleName,'Windows') then
     begin
        Item:=ListView1.Items.Add;
        Item.Caption:='Resource';
        Item.SubItems.Add('');

        SourceInfo:=TStyleManager.StyleSourceInfo[StyleName];
        VCLStyleExt:=TCustomStyleExt.Create(TStream(SourceInfo.Data));

        Item.Data  :=VCLStyleExt;
        StyleInfo  :=TCustomStyleExt(VCLStyleExt).StyleInfo;
        Item.SubItems.Add(StyleInfo.Name);
        Item.SubItems.Add(StyleInfo.Author);
        Item.SubItems.Add(StyleInfo.AuthorURL);
        Item.SubItems.Add(StyleInfo.Version);
     end;
   Loading:=False;
end;

type
  TVclStylesPreviewClass = class(TVclStylesPreview);

 procedure TstyleW.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  LStyle: TCustomStyle;
begin
  if Selected then
  begin
    LStyle := nil;
    if Assigned(Item.Data) then
      LStyle := TCustomStyleExt(Item.Data)
    else
    if not Loading then
    begin
      LStyle := TCustomStyleExt.Create(FStylesPath+Item.SubItems[0]);
      Item.Data := LStyle;
    end;

    if Assigned(LStyle) and not Loading then
    begin
      styleName := Item.SubItems[1];
      FPreview.Caption := styleName;
      FPreview.Style := LStyle;
      TVclStylesPreviewClass(FPreview).Paint;
    end;
  end;
end;

end.
