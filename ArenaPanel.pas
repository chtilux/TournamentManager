unit ArenaPanel;

interface

uses
  Vcl.ExtCtrls, lal_connection, Data.Db, ZDataset, Vcl.StdCtrls, Vcl.DBGrids,
  System.Classes;

type
  TArenaPanel = class(TPanel)
  private
    pvCnx: TLalConnection;
    pvSource: TDatasource;
    pvSertrn: integer;
    FSerCat: integer;
    Fcodcat: string;
    Fheudeb: string;
    function GetDataset: TDataset;
  protected
    pvCateg: TZReadOnlyQuery;
    pvPlayAreaAvailable: TZReadOnlyQuery;
    FHeader: TPanel;
    FInfos: TLabel;
    FGrid: TDBGrid;
    function GetGridFontSize: integer; virtual; abstract;
    procedure SetGridFontSize(const Value: integer); virtual; abstract;
    procedure SetDatasourceDataset(Value: TDataset);
  public
    constructor Create(AOwner: TComponent; cnx: TLalConnection; const sercat: integer); reintroduce; overload; virtual;
    destructor Destroy; override;
    procedure Refresh; virtual;
    property SerCat: integer read FSercat;
    property SerTrn: integer read pvSerTrn;
    property codcat: string read FCodCat;
    property heudeb: string read FHeuDeb;
    property gridFontSize: integer read GetGridFontSize write SetgridFontSize;
    property Dataset: TDataset read GetDataset;
    property Connection: TLalConnection read pvCnx;
  end;

implementation

uses
  Vcl.Graphics, Vcl.Controls, tmUtils15, System.SysUtils, TMEnums;

{ TArenaPanel }

constructor TArenaPanel.Create(AOwner: TComponent; cnx: TLalConnection;
  const sercat: integer);
begin
  inherited Create(AOwner);
  pvCnx := cnx;
  FSerCat := sercat;
  pvCateg := TZReadOnlyQuery.Create(Self);
  with pvCateg do
  begin
    Connection := pvCnx.get;
    SQL.Add('SELECT sertrn,codcat,heudeb,stacat,first_round_mode,phase'
           +' FROM categories'
           +' WHERE sercat = :sercat');
    Params[0].AsInteger := FSercat;
    Open;
    if not Eof then
    begin
      Self.pvSertrn := FieldByName('sertrn').AsInteger;
      Self.Fcodcat := FieldByName('codcat').AsString;
      Self.Fheudeb := FieldByName('heudeb').AsString;
    end;
  end;

  pvPlayAreaAvailable := TZReadOnlyQuery.Create(Self);
  pvPlayAreaAvailable.Connection := Cnx.get;
  pvPlayAreaAvailable.SQL.Add('SELECT COUNT(* ) FROM umpires'
                             +' WHERE sertrn = :sertrn'
                             +'   AND statbl = :statbl');
  pvPlayAreaAvailable.Params[0].AsInteger := SerTrn;
  pvPlayAreaAvailable.Params[1].AsInteger := Ord(pasAvailable);

  pvSource := TDataSource.Create(Self);
  pvSource.AutoEdit := False;

  Caption := '';
  Font.Size := 8;

  FHeader := TPanel.Create(Self);
  FHeader.Parent := Self;
  FHeader.Visible := False;
  FHeader.ParentBackground := False;
  FHeader.Color := clHighlight;
  FHeader.Font.Color := clHighlightText;
  FHeader.Align := alTop;
  FHeader.Caption := '';
  FHeader.Height := FHeader.Height div 2;
  FHeader.Visible := True;

  FGrid := TDBGrid.Create(AOwner);
  FGrid.Parent := Self;
  FGrid.Align := alClient;
  FGrid.DataSource := pvSource;
  FGrid.ReadOnly := True;
  FGrid.Options := [dgColLines,dgRowLines];
  FGrid.Font.Size := 6;
  FGrid.Color := getItemsColor(piInactive);
end;

destructor TArenaPanel.Destroy;
begin
  pvCateg.Close;
  inherited;
end;

function TArenaPanel.GetDataset: TDataset;
begin
  Result := nil;
  if Assigned(pvSource) then
    Result := pvSource.DataSet;
end;

procedure TArenaPanel.Refresh;
begin

end;

procedure TArenaPanel.SetDatasourceDataset(Value: TDataset);
begin
  pvSource.DataSet := Value;
end;

end.

