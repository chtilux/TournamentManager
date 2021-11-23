unit matchPanel;

interface

uses
  Vcl.ExtCtrls, lal_connection, Classes;

type
  TMatch = class(TObject)
  private
    _cnx: TLalConnection;
    _sermtc: integer;
    _level: integer;
    _nummtc: string;
  public
    constructor Create(cnx: TLalConnection; const sermtc: integer); reintroduce; overload;
    property level: integer read _level write _level;
    property numero: string read _nummtc write _nummtc;
  end;

  TMatchPanel = class(TPanel)
  private
    _match: TMatch;
    function getLevel: integer;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property match: TMatch read _match write _match;
    property level: integer read getLevel;
  end;

implementation

uses
  ZDataset, lal_dbUtils, System.Types, SysUtils;

{ TMatch }

constructor TMatch.Create(cnx: TLalConnection; const sermtc: integer);
begin
  _cnx := cnx;
  _sermtc := sermtc;
end;

{ TMatchPanel }

constructor TMatchPanel.Create(AOwner: TComponent);
begin
  inherited;
  ShowCaption := False;
  _match := nil;
end;

destructor TMatchPanel.Destroy;
begin
  if Assigned(_match) then
    FreeAndNil(_match);
  inherited;
end;

function TMatchPanel.getLevel: integer;
begin
  Result := 1;
  if Assigned(match) then
    Result := _match.level;
end;

procedure TMatchPanel.Paint;
begin
  inherited;
end;

end.
