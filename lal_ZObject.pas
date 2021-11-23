unit lal_ZObject;

interface

uses
  System.SysUtils, lal_connection, ZConnection;

type
  ELalZObject = class(Exception);

  TLalZObject = class
  private
    FCnx: TLalConnection;
    function GetZConnection: TZConnection;
  public
    constructor Create(cnx: TLalConnection); virtual;
    property Cnx: TLalConnection read FCnx;
    property ZConnection: TZConnection read GetZConnection;
  end;

implementation

uses
  Spring;

{ TLalZObject }

constructor TLalZObject.Create(cnx: TLalConnection);
begin
  Guard.CheckNotNull(cnx,'TLalConnection is nil !');
//  if not Assigned(cnx) then
//    raise ELalZObject.Create('TLalConnection is nil !');
  FCnx := cnx;
end;

function TLalZObject.GetZConnection: TZConnection;
begin
  Result := Cnx.get;
end;

end.

