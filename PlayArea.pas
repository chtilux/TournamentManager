unit PlayArea;

interface

uses
  System.Classes, Vcl.ExtCtrls, TMEnums, AreaContent, Game;

type
  TPlayArea = class(TCollectionItem)
  private
    FAreaNumber: integer;
    FPanel: TPanel;
    FContent: IAreaContent;
    FStatus: TPlayAreaStatus;
    procedure SetAreaNumber(const Value: integer);
    procedure SetContent(Value: IAreaContent);
    procedure SetStatus(const Value: TPlayAreaStatus);
    procedure onPanelDblClick(Sender: TObject);
    procedure onPanelClick(Sender: TObject);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Areas: TCollection); override;
    destructor Destroy; override;
    procedure setBounds(const x,y,cx,cy: integer);
    procedure Paint;
    property Panel: TPanel read FPanel;
    property AreaNumber: integer read FAreaNumber write SetAreaNumber;
    property Content: IAreaContent read FContent write SetContent;
    property Status: TPlayAreaStatus read FStatus write SetStatus default pasAvailable;
  end;

implementation

uses
  Arena, Vcl.Controls, System.SysUtils, Winapi.Windows, Vcl.Graphics, System.DateUtils,
  tmUtils15;

{ TPlayArea }

constructor TPlayArea.Create(Areas: TCollection);
begin
  inherited;
  FPanel := TPanel.Create(TAreas(Areas).arena);
  FPanel.Parent := TAreas(Areas).arena;
  FPanel.BevelOuter := bvNone;
  FPanel.OnClick := onPanelClick;
  FPanel.OnDblClick := onPanelDblClick;
  FStatus := pasAvailable;
end;

destructor TPlayArea.Destroy;
begin
  if Assigned(Content) and (Content.ContentType = actKo) and Assigned(TGameContent(Content).Game) then
    TGameContent(Content).Game.Free
  else if Assigned(Content) and (Content.ContentType = actGroup) and Assigned(TGroupContent(Content).Groupe) then
    TGroupContent(Content).Groupe.Free;
  inherited;
end;

function TPlayArea.getDisplayName: string;
begin
  Result := 'Area n°' + IntToStr(AreaNumber);
end;

procedure TPlayArea.onPanelClick(Sender: TObject);
begin
  if Assigned(Content) and (Content.ContentType = actKo) then
  begin
    with (Content.AsObject as TGameContent) do
      broadcastMessage(wm_displayDraw,Game.Dataset.FieldByName('sertab').AsInteger,Game.DataSet.FieldByName('sermtc').AsInteger);
  end;
end;

procedure TPlayArea.onPanelDblClick(Sender: TObject);
begin
  if Assigned(Content) and (Content.ContentType = actKo) then
    broadcastMessage(wm_gameCatchResult, Content.SerialContent, Content.PlayAreaNumber);
end;

procedure TPlayArea.Paint;
var
  cc: TControlCanvas;
  R,tr: TRect;
const
  yOffset: integer = 8;
begin
  if Assigned(Content) and Assigned(Content.Display) then
    Content.Display.PaintMethod(Self)
  else
  begin
    { méthode par défaut }
  cc := TControlCanvas.Create;
  try
    cc.Control := FPanel;
    R := FPanel.ClientRect;
    with cc do
    begin
      Brush.Color := getPlayAreasColor(FStatus);
      FillRect(R);

      {: table area draw }
      Brush.Color := getItemsColor(piGameTable);
      {: table limits (2.74m x 1.525m = ratio 1.7967 }
      tr.Height := (R.Height div 4) * 3;
      tr.Width := Trunc(tr.Height * 1.7967);
      tr.SetLocation(R.Left + ((R.Width - tr.Width) div 2),
                     R.Top + ((R.Height - tr.Height) div 2)+yOffset);
      R := tr;
      Rectangle(R);

      {: white border }
      Pen.Color := clWhite;
      Pen.Width := 2;
      MoveTo(R.Left,R.Top);
      LineTo(R.Right,R.Top);
      LineTo(R.Right,R.Bottom);
      LineTo(R.Left,R.Bottom);
      LineTo(R.Left,R.Top);
      {: thin white line in the middle }
      Pen.Width := 1;
      MoveTo(R.Left,R.Top + (R.Height div 2));
      LineTo(R.Right,R.Top + (R.Height div 2));
      {: net }
      InflateRect(R,0,10);
      Pen.Color := clBlack;
      MoveTo(R.Left + (R.Width div 2), R.Top);
      LineTo(R.Left + (R.Width div 2), R.Bottom);
      {: play area number }
      SetBkMode(Handle,OPAQUE);
      Brush.Color := clCream;
      Ellipse((FPanel.Width div 2) - 12, ((FPanel.Height div 2) - 12) +yOffset,
              (FPanel.Width div 2) + 12, ((FPanel.Height div 2) + 12) +yOffset);
      Font.Color := getItemsColor(piArena);
      Font.Size := 12;
      Font.Style := [fsBold];
      SetBkMode(Handle,TRANSPARENT);
      SetTextAlign(Handle, TA_CENTER);
      TextOut(FPanel.Width div 2,
              ((FPanel.Height - TextHeight('W')) div 2)+yOffset,
              Self.AreaNumber.ToString);
    end;
  finally
    cc.Free;
  end;
  end;
//  else if Assigned(Content) and (Content.ContentType = actKo) then
//    glPaintPlayAreaGameContent(Self)
//  else if Assigned(Content) and (Content.ContentType = actGroup) then
//    glPaintPlayAreaGroupContent(Self);
end;

procedure TPlayArea.SetAreaNumber(const Value: integer);
begin
  FAreaNumber := Value;
end;

procedure TPlayArea.setBounds(const x, y, cx, cy: integer);
begin
  FPanel.SetBounds(x,y,cx,cy);
end;

procedure TPlayArea.SetContent(Value: IAreaContent);
begin
  if Assigned(Content) and (Content.ContentType = actKo) and Assigned(TGameContent(Content).Game) then
    try TGameContent(Content).Game.Free; except end;
  if Assigned(Content) and (Content.ContentType = actGroup) and Assigned(TGroupContent(Content).Groupe) then
    try TGroupContent(Content).Groupe.Free; except end;
  FContent := Value;
  Paint;
end;

procedure TPlayArea.SetStatus(const Value: TPlayAreaStatus);
begin
  if FStatus <> Value then
  begin
    FStatus := Value;
    Paint;
  end;
end;

end.

