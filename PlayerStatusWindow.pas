unit PlayerStatusWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, tmUtils15, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TPlayerStatusW = class(TForm)
    statut: TLabel;
    categs: TListView;
    procedure categsCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure statutDblClick(Sender: TObject);
  private
    { Private declarations }
    FPlayerStatus: TPlayerStatus;
    FDisqualifiedColor: TColor;
    FWOColor: TColor;
    FQualifiedColor: TColor;
    procedure SetPlayerStatus(const Value: TPlayerStatus);
    procedure SetDisqualifiedColor(const Value: TColor);
    procedure SetQualifiedColor(const Value: TColor);
    procedure SetWOColor(const Value: TColor);
  public
    { Public declarations }
    property PlayerStatus: TPlayerStatus read FPlayerStatus write SetPlayerStatus;
    property QualifiedColor: TColor read FQualifiedColor write SetQualifiedColor;
    property DisqualifiedColor: TColor read FDisqualifiedColor write SetDisqualifiedColor;
    property WOColor: TColor read FWOColor write SetWOColor;
    procedure Refresh;
  end;

implementation

{$R *.dfm}

uses
  PlayerPathWindow;

{ TPlayerStatusW }

procedure TPlayerStatusW.categsCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  case integer(Item.Data) of
    0: Sender.Canvas.Brush.Color := DisqualifiedColor;
    1: Sender.Canvas.Brush.Color := QualifiedColor;
    2: Sender.Canvas.Brush.Color := WOColor;
  end
end;

procedure TPlayerStatusW.Refresh;
var
  i: Integer;
begin
  categs.OnCustomDrawItem := nil;
  if Assigned(PlayerStatus) then
  begin
    categs.Items.Clear;
    for i := 0 to PlayerStatus.Tableaux.Count-1 do
      with categs.Items.Add do
      begin
        Caption := PlayerStatus.Tableaux[i];
        Data := Pointer(PlayerStatus.Tableaux.Objects[i]);
      end;
    statut.Caption := PlayerStatus.EnCours;
//    statut.Color := PlayerStatus.StatusColor;
    statut.Refresh;
  end
  else
  begin
    categs.Items.Clear;
    statut.Caption := '';
    statut.Color := Color;
  end;
end;

procedure TPlayerStatusW.SetDisqualifiedColor(const Value: TColor);
begin
  FDisqualifiedColor := Value;
  categs.Refresh;
end;

procedure TPlayerStatusW.SetPlayerStatus(const Value: TPlayerStatus);
begin
  FPlayerStatus := Value;
  Refresh;
end;

procedure TPlayerStatusW.SetQualifiedColor(const Value: TColor);
begin
  FQualifiedColor := Value;
  categs.Refresh;
end;

procedure TPlayerStatusW.SetWOColor(const Value: TColor);
begin
  FWOColor := Value;
  categs.Refresh;
end;

procedure TPlayerStatusW.statutDblClick(Sender: TObject);
begin
  with TPlayerPathW.Create(Self,PlayerStatus.Connection,PlayerStatus.Joueur,PlayerStatus.Tournoi) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

end.
