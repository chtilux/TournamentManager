unit Arena;

interface

uses
  Vcl.Controls, Vcl.Graphics, Tournament, System.Classes, PlayArea, AreaContent;

type
  TArena = class;

  TArenaLayout = class(TPersistent)
  private
    FTableColor: TColor;
    procedure SetTableColor(const Value: TColor);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property TableColor: TColor read FTableColor write SetTableColor;
  end;

  {: areas container }
  TAreas = class(TCollection)
  private
    FArena: TArena;
    function getArea(const Index: Integer): TPlayArea;
  protected
    function GetOwner: TPersistent; override;
    procedure Update(area: TCollectionItem); override;
  public
    constructor Create(arena: TArena);
    property Areas[const index: integer]: TPlayArea read getArea; default;
    property arena: TArena read FArena;
  end;

  {: arena manager }
  TArena = class(TCustomControl)
  private
    FAreas: TAreas;
    FTextColor: TColor;
    FTournament: TTournament;
    FAreasPerRow: smallint;
    FHeaderHeight: integer;
    pvDefLayout: boolean;
    FArenaLayout: TArenaLayout;

    procedure SetTextColor(const Value: TColor);
    procedure SetTournament(const Value: TTournament);
    procedure setAreasPerRow(const Value: smallint);
    procedure SetHeaderHeight(const Value: integer);
    procedure resizeLayout(al: TArenaLayout);
    procedure SetArenaLayout(const Value: TArenaLayout);

  protected
    procedure Resize; override;
    procedure Paint; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function addArea: TPlayArea;
    procedure createAreas;
    procedure Assign(Source: TPersistent); override;

  published
    property Areas: TAreas read FAreas;
    property Tournament: TTournament read FTournament write SetTournament;
    property Color;
    property OnResize;
    property TextColor: TColor read FTextColor write SetTextColor default clBlack;
    property AreasPerRow: smallint read FAreasPerRow write setAreasPerRow default 4;
    property headerHeight: integer read FHeaderHeight write SetHeaderHeight default 35;
    property ArenaLayout: TArenaLayout read FArenaLayout write SetArenaLayout;
  end;

implementation

uses
  Winapi.Windows;

{ TArenaLayout }

procedure TArenaLayout.Assign(Source: TPersistent);
begin
  if Source is TArenaLayout then
  begin
    FTableColor := TArenaLayout(Source).TableColor;
  end
  else
    inherited;
end;

procedure TArenaLayout.SetTableColor(const Value: TColor);
begin
  FTableColor := Value;
end;

{ TAreas }

constructor TAreas.Create(arena: TArena);
begin
  inherited Create(TPlayArea);
  FArena := arena;
end;

function TAreas.getArea(const Index: Integer): TPlayArea;
begin
  Result := TPlayArea(Items[Index]);
end;

function TAreas.getOwner: TPersistent;
begin
  Result := FArena;
end;

procedure TAreas.Update(area: TCollectionItem);
begin
  inherited;
  FArena.Repaint;
end;

{ TArena }

function TArena.addArea: TPlayArea;
begin
  Result := TPlayArea(FAreas.Add);
  Result.AreaNumber := Areas.Count;
end;

procedure TArena.Assign(Source: TPersistent);
begin
  if (Source is TArena) then
  begin
    FAreas.Assign(TArena(Source).Areas);
    FTextColor := TArena(Source).TextColor;
    FTournament.Assign(TArena(Source).Tournament);
    FAreasPerRow := TArena(Source).AreasPerRow;
  end
  else
    inherited;
end;

constructor TArena.Create(AOwner: TComponent);
var
  factory: IAreaContentDisplayFactory;
begin
  inherited;
  FAreas := TAreas.Create(Self);
  Color := clSilver;
  FTextColor := clBlack;
  FAreasPerRow := 4;
  FHeaderHeight := 35;
  factory := TAreaContentDisplayFactory.Create;
end;

procedure TArena.createAreas;
var
  i: Integer;
begin
  for i := 1 to tournament.NumberOfAreas do
  begin
    with addArea do
    begin
      AreaNumber := i;
    end;
  end;
end;

destructor TArena.Destroy;
begin
  if Assigned(FArenaLayout) then
    FArenaLayout.Free;
  FAreas.Free;
  inherited;
end;

procedure TArena.Paint;
var
  R: TRect;
  s: string;
  i: Integer;
begin
  inherited;
  R := GetClientRect;
  s := tournament.Description;
  Canvas.Brush.Color := Color;
  Canvas.FillRect(GetClientRect);
  Canvas.Font.Color := FTextColor;
  Canvas.Font.Size := 14;
  { header tournament description }
  Canvas.Brush.Color := clGray;
  Canvas.Font.Color := clNavy;
  Canvas.Rectangle(0,0,R.Width,FHeaderHeight);
  Canvas.TextOut((r.Width - Canvas.TextWidth(s)) div 2, (FHeaderHeight - Canvas.TextHeight('W')) div 2, s);
  for i := 0 to FAreas.Count - 1 do
    FAreas[i].Paint;
end;

procedure TArena.Resize;
var
  cols,
  cx, cy,   // width and height of a playing area
  gx, gy,   // gasp between playing areas
  col,row,i: integer;
  pa: TPlayArea;
begin
  inherited;
  if pvDefLayout then
  begin
    cols := tournament.NumberOfAreas div AreasPerRow;
    if (tournament.NumberOfAreas mod AreasPerRow) > 0 then
      Inc(cols);
    {: one col more for dividing }
    cx := ClientWidth div Succ(cols);
    {: assume 4 playing areas per column }
    cy := (ClientHeight - FHeaderHeight) div 5;
    {: gasp between areas }
    gx := cx div Succ(cols);
    gy := cy div Succ(AreasPerRow);
    for i := 0 to FAreas.Count - 1 do
    begin
      pa := FAreas[i];
      if Assigned(pa) then
      begin
        col := i div AreasPerRow;
        row := i - (col * AreasPerRow);
        pa.setBounds(gx + (col * (cx+gx)),
                     gy + (row * (cy+gy)) + FHeaderHeight,
                     cx,
                     cy);
      end;
    end;
  end
  else
    resizeLayout(ArenaLayout);
end;

procedure TArena.resizeLayout(al: TArenaLayout);
begin

end;

procedure TArena.setAreasPerRow(const Value: smallint);
begin
  if Value <> FAreasPerRow then
  begin
    FAreasPerRow := Value;
    Invalidate;
  end;
end;

procedure TArena.SetArenaLayout(const Value: TArenaLayout);
begin
  FArenaLayout := Value;
  pvDefLayout := not Assigned(FArenaLayout);
end;

procedure TArena.SetHeaderHeight(const Value: integer);
begin
  FHeaderHeight := Value;
  Invalidate;
end;

procedure TArena.SetTextColor(const Value: TColor);
begin
  FTextColor := Value;
end;

procedure TArena.SetTournament(const Value: TTournament);
begin
  Ftournament := Value;
end;

end.

