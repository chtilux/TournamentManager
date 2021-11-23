unit draw;

interface

uses
  Vcl.Controls, lal_connection, ZDataset, ZAbstractRODataset, Db, Winapi.Windows,
  tmUtils15, Vcl.ExtCtrls, Graphics, TMEnums;

type

  TDrawDirection = (ddTop,ddBottom);

  TDrawCell = record
    R: TRect;
    isNull: boolean;
    level,
    numseq,
    sermtc: integer;
    numtbl,
    winner,
    score: string;
    stamtc: TGameStatus;
  end;

  TDraw = class(TObject)
  private
    pvSermtc: integer;
    pvDraw: TZReadOnlyQuery;
    pvSize,
    pvMaxLevel,
    pvColWidth,
    pvxMargin,
    pvyMargin,
    pvHeight,
    pvCellWidth,
    pvMiddle: integer;
    pvCanvas: TCanvas;
    pvCateg,
    pvHeudeb: string;
    FDetailled: boolean;
    function getGameRect(source: TRect; dr: TDrawCell; direction: TDrawDirection; level,numseq: integer): TDrawCell;
    procedure drawGameRect(const dc: TDrawCell);
    procedure SetDetailled(const Value: boolean);
  public
    constructor Create(cnx: TLalConnection; const sertab, sermtc: integer);
    destructor Destroy; override;
    procedure display(box: TCanvas);
    property Detailled: boolean read FDetailled write SetDetailled;
  end;

implementation

uses
  SysUtils, Forms, TypInfo;

var
  lcCellHeight: integer;

{ TDraw }

constructor TDraw.Create(cnx: TLalConnection; const sertab, sermtc: integer);
var
  i: integer;
begin
  inherited Create;
  pvSermtc := sermtc;
  pvDraw := TZReadOnlyQuery.Create(nil);
  pvDraw.Connection := cnx.get;
  pvDraw.SQL.Add('SELECT taille FROM tableau WHERE sertab = ' + sertab.ToString);
  pvDraw.Open;
  pvSize := pvDraw.Fields[0].AsInteger;
  pvDraw.Close;
  i := pvSize;
  pvMaxLevel := 0;
  while i > 1 do
  begin
    Inc(pvMaxLevel);
    i := i div 2;
  end;

  pvDraw.SQL.Clear;
  pvDraw.SQL.Add('SELECT codcat,heudeb FROM categories WHERE sercat = ' + sertab.ToString);
    pvDraw.Open;
  pvCateg := pvDraw.FieldByName('codcat').AsString;
  pvHeudeb := pvDraw.FieldByName('heudeb').AsString;
  pvDraw.Close;

  pvDraw.SQL.Clear;
  pvDraw.SQL.Add('SELECT stamtc,sermtc,numtbl,score'
                +' ,(SELECT nomjou FROM joueur WHERE vainqueur = serjou) WinnerName'
                +' FROM match m'
                +' WHERE sertab = ' + sertab.ToString
                +'   AND level = :level'
                +'   AND numseq = :numseq');
  pvDraw.Prepare;
end;

destructor TDraw.Destroy;
begin
  pvDraw.Free;
  inherited;
end;

procedure TDraw.display(box: TCanvas);
var
  R,header: TRect;
  dc,fdc: TDrawCell;
  level,
  numcell,
  i: integer;
  procedure DataToDc;
  begin
    with dc, pvDraw do
    begin
      sermtc := FieldByName('sermtc').AsInteger;
      stamtc := TGameStatus(FieldByName('stamtc').AsInteger);
      if stamtc > gsInactive then
        numtbl := FieldByName('numtbl').AsString;
      winner := FieldByName('winnername').AsString;
      score := FieldByName('score').AsString;
    end;
  end;
begin
  R := box.ClipRect;
  pvyMargin := 20;
  with box do
  begin
    Brush.Color := getItemsColor(piDraw);
    FillRect(R);

    header := R;
    header.Bottom := pvyMargin;
    Brush.Color := getItemsColor(piHighlight);
    Font.Color := getItemsColor(piHighLightText);
    Font.Size := 10;
    Font.Style := [fsBold];
    SetBkMode(Handle, TRANSPARENT);
    FillRect(header);
    SetTextAlign(Handle, TA_LEFT);
    TextOut(header.Left + 4, header.Top + 4, pvCateg);
    SetTextAlign(Handle, TA_RIGHT);
    TextOut(header.Right - 4, header.Top+4, pvHeudeb);

    pvColWidth := R.Width div Succ(pvMaxLevel);
    pvxMargin := pvColWidth div 2;
    pvCellWidth := pvColWidth;
    pvHeight := R.Bottom - pvyMargin;
    pvMiddle := pvyMargin + (pvHeight div 2);
    Self.pvCanvas := box;

    SetTextAlign(Handle, TA_CENTER);
    SetBkColor(Handle, TRANSPARENT);

    {for each level }
    for level := 1 to pvMaxLevel do
    begin
      { how many cells in the level }
      numcell := pvSize;
      i := level;
      repeat
        numcell := numcell div 2;
        Dec(i);
      until i = 0;

      { cell heights of level }
      lcCellHeight := pvHeight div numcell;

      { draw from middle to top }
      dc.isNull := True;
      { saves first draw cell }
      fdc := dc;
      pvDraw.ParamByName('level').AsInteger := level;
      for i := (numcell div 2) downto 1 do
      begin
        dc := getGameRect(R, dc, ddTop, level, i);
        if fdc.isNull then
        begin
          { saves first draw cell }
          fdc := dc;
          fdc.isNull := False;
        end;
        dc.numtbl := '';
        pvDraw.ParamByName('numseq').AsInteger := i;
        pvDraw.Open;
        DataToDc;
        dc.level := level;
        dc.numseq := i;
        pvDraw.Close;
        drawGameRect(dc);
      end;

      dc := fdc;
      { draw from middle to bottom }
      for i :=  Succ(numcell div 2) to numcell do
      begin
        dc := getGameRect(R, dc, ddBottom, level, i);
        dc.numtbl := '';
        pvDraw.ParamByName('numseq').AsInteger := i;
        pvDraw.Open;
        dc.level := level;
        dc.numseq := i;
        DataToDc;
        pvDraw.Close;
        drawGameRect(dc);
      end;
    end;
  end;
end;

procedure TDraw.drawGameRect(const dc: TDrawCell);
var
  cy,y: integer;
  r, Rect: TRect;
begin
  with pvCanvas do
  begin
    SetBkMode(Handle, TRANSPARENT);
    Font.Size := 8;
    Font.Color := clBlack;

    Rect := dc.R;
    {: computes height to draw }
    case dc.level of
      1..3 : cy := (Rect.Bottom - Rect.Top) div 2;
      4..5 : cy := (Rect.Bottom - Rect.Top) div 3;
      6    : cy := (Rect.Bottom - Rect.Top) div 4;
      else
        cy := (Rect.Bottom - Rect.Top) div 6;
    end;
    y := Rect.Top + (((Rect.Bottom - Rect.Top) - cy) div 2);

    {: retrieves brush color }
    Brush.Color := getGameColor(dc.stamtc);

    {: selected game }
    if dc.sermtc = pvSermtc then
      Brush.Color := getItemsColor(piStabylo);

    r.Left := Rect.Left+5;
    r.Top := y;
    r.Right := Rect.Left + Rect.Width - 15;
    r.Bottom := y + cy;
    Rectangle(r);

    if FDetailled or (pvSize < 64) or (dc.level > 1) then
    begin
      if dc.stamtc = gsInProgress then
        Font.Color := clRed
      else
        Font.Color := clNavy;
      SetTextAlign(Handle, TA_RIGHT);
      TextOut(r.Right - 1,Succ(r.Top), dc.numtbl);
      SetTextAlign(Handle, TA_LEFT);
      if not FDetailled then
        Font.Size := 6
      else
        Font.Size := 8;
      SetTextAlign(Handle, TA_RIGHT);
      TextOut(r.Right-1,R.Bottom-TextHeight('W')-1,dc.winner);
    end;

    if FDetailled then
    begin
      Font.Size := 6;
      Font.Color := clNavy;
      SetTextAlign(Handle, TA_LEFT);
      TextOut(R.Left+1, R.Top+1, dc.score);
    end;

    { lines }
    Pen.Width := 1;
    Pen.Color := clBlack;
    if (dc.level > 1) then
    begin
      MoveTo(Rect.Left, Rect.Top+(Rect.Bottom - Rect.Top) div 2);
      LineTo(r.Left, Rect.Top+(Rect.Bottom - Rect.Top) div 2);
    end;
    if (dc.level < pvMaxLevel) then
    begin
      MoveTo(r.Right, Rect.Top+(Rect.Bottom - Rect.Top) div 2);
      LineTo(Rect.Right, Rect.Top+(Rect.Bottom - Rect.Top) div 2);
      MoveTo(Rect.Right, Rect.Top+(Rect.Bottom - Rect.Top) div 2);
      if Odd(dc.numseq) then
      begin
        LineTo(Rect.Right, Rect.Bottom);
      end
      else
      begin
        LineTo(Rect.Right, Rect.Top);
      end;
    end;

  end;
end;

function TDraw.getGameRect(source: TRect; dr: TDrawCell; direction: TDrawDirection; level,numseq: integer): TDrawCell;
begin
  Result.isNull := False;
  with Result.R do
  begin
    Left := pvxMargin + ((Pred(level) * pvColWidth)+1);
    Width := pvColWidth;
    if level < Self.pvMaxLevel then
    begin
      if not dr.isNull then
      begin
        if direction = ddTop then
        begin
          Top := dr.R.Top - lcCellHeight;
        end
        else
        begin
          Top := dr.R.Bottom;
        end;
      end
      else
      begin
        if direction = ddTop then
          Top := pvMiddle - lcCellHeight
        else
          Top := pvMiddle;
      end;
    end
    else
      { last cell begins from top }
      Top    := pvyMargin;

    Bottom := Top + lcCellHeight;
  end;
end;

procedure TDraw.SetDetailled(const Value: boolean);
begin
  FDetailled := Value;
  if Assigned(pvCanvas) then
    display(pvCanvas);
end;

end.
