unit Tournament;

interface

uses
  System.Classes, lal_connection;

type
  TTournament = class(TPersistent)
  private
    FSertrn: integer;
    FOrganizer: string;
    FSaison: string;
    FNumberOfAreas: smallint;
    FDescription: string;
  public
    constructor Create(cnx: TLalConnection; Value: integer); virtual;
    property Sertrn: integer read FSertrn;
    property Organizer: string read FOrganizer;
    property Description: string read FDescription;
    property NumberOfAreas: smallint read FNumberOfAreas;
    property Saison: string read FSaison;
  end;


implementation

uses
  System.SysUtils, lal_dbUtils;

{ TTournament }

constructor TTournament.Create(cnx: TLalConnection; Value: integer);
begin
  FSertrn := Value;
  with getROQuery(cnx) do
  begin
    try
      SQL.Add('SELECT s.libelle as saison,'
             +'       t.dattrn, t.organisateur, t.libelle, t.numtbl'
             +' FROM tournoi t INNER JOIN saison s ON t.saison = s.saison'
             +' WHERE t.sertrn = ' + FSertrn.ToString);
      Open;
      if not Eof then
      begin
        Self.FOrganizer := FieldByName('organisateur').AsString;
        Self.FDescription := FieldByName('libelle').AsString;
        Self.FSaison := FieldByName('saison').AsString;
        Self.FNumberOfAreas := FieldByName('numtbl').AsInteger;
      end;
      Close;
    finally
      Free;
    end;
  end;
end;

end.

