unit tm.AuscheidungsGroup;

interface

uses
  System.SysUtils, Spring.Collections, TMEnums, ZConnection;

type
  TGroup = record
    NumberOfPlayers: smallint;
    NumberOfGroups: smallint;
  end;

  TAusscheidund = record
    Groups: array of TGroup;
  end;

  THauptRunde = record
    Group: TGroup;
    Players: smallint;
    System: TFirstRoundMode;
  end;

  IAuscheidungGruppe = interface;
  TAnhang2 = class(TObject)
  public
    Teilnehmer: smallint;
    Auscheidung: TAusscheidund;
    HauptRunde: THauptRunde;
    GruppenListe: IList<IAuscheidungGruppe>;
    constructor Create;
  end;

  TSpieler = record
    Verein: string;
    Lizenz: string;
    Name: string;
    Klassement: string;
    Serjou: integer;
    Platzziffer: smallint;
  end;

  IAuscheidungGruppe = interface
    ['{9EC44548-C694-4624-9A3F-4BFEA2762691}']
    function GetGruppeNummer: smallint;
    property GruppeNummer: smallint read GetGruppeNummer;
    procedure AddSpieler(Spieler: TSpieler);
    function GetTeilnehmer: smallint;
    property Teilnehmer: smallint read GetTeilnehmer;
    function GetSpieler: IDictionary<integer, TSpieler>;
    property Spieler: IDictionary<integer,TSpieler> read GetSpieler;
  end;

  TAuscheidungGruppe = class(TInterfacedObject, IAuscheidungGruppe)
  private
    FGruppeNummer: smallint;
    function GetGruppeNummer: smallint;
    function GetTeilnehmer: smallint;
    function GetSpieler: IDictionary<integer, TSpieler>;
  protected
    FSpieler: IDictionary<integer,TSpieler>;
    FTeilnehmer: smallint;
  public
    constructor Create(const GruppeNummer, Teilnehmer: smallint); virtual;
    property GruppeNummer: smallint read GetGruppeNummer;
    property Teilnehmer: smallint read GetTeilnehmer;
    procedure AddSpieler(Spieler: TSpieler);
    property Spieler: IDictionary<integer,TSpieler> read GetSpieler;
  end;

  TAG_2 = class(TAuscheidungGruppe)

  end;

  TAG_3 = class(TAuscheidungGruppe)

  end;

  TAG_4 = class(TAuscheidungGruppe)

  end;

  TAG_5 = class(TAuscheidungGruppe)

  end;

  TAuscheidungsGruppeFabrik = class(TObject)
  public
    class function CreateGruppe(const GruppeNummer, Teilnehmer: smallint): IAuscheidungGruppe;
  end;

  procedure ExportAuscheidungsGruppeToExcel(Cnx: TZConnection; const sertab: integer; const Templates, Filename: TFilename; Anhang: TAnhang2);

implementation

uses
  u_pro_excel, System.Variants, ZDataset;

{ TAuscheidungsGrupeFabrik }

class function TAuscheidungsGruppeFabrik.CreateGruppe(
  const GruppeNummer, Teilnehmer: smallint): IAuscheidungGruppe;
begin
  case Teilnehmer of
    2 : Result := TAG_2.Create(GruppeNummer, Teilnehmer);
    3 : Result := TAG_3.Create(GruppeNummer, Teilnehmer);
    4 : Result := TAG_4.Create(GruppeNummer, Teilnehmer);
    5 : Result := TAG_5.Create(GruppeNummer, Teilnehmer);
    else raise Exception.CreateFmt('Pas de groupe de %d joueurs définis !',[Teilnehmer]);
  end;
end;

{ TAuscheidungGruppe }

procedure TAuscheidungGruppe.AddSpieler(Spieler: TSpieler);
begin
  Spieler.Platzziffer := Succ(FSpieler.Count);
  FSpieler.AddOrSetValue(Succ(FSpieler.Count), Spieler);
end;

constructor TAuscheidungGruppe.Create(const GruppeNummer, Teilnehmer: smallint);
begin
  FGruppeNummer := GruppeNummer;
  FTeilnehmer := Teilnehmer;
  FSpieler := TCollections.CreateDictionary<integer,TSpieler>;
end;

function TAuscheidungGruppe.GetGruppeNummer: smallint;
begin
  Result := FGruppeNummer;
end;

function TAuscheidungGruppe.GetSpieler: IDictionary<integer, TSpieler>;
begin
  Result := FSpieler;
end;

function TAuscheidungGruppe.GetTeilnehmer: smallint;
begin
  Result := FTeilnehmer;
end;

procedure ExportAuscheidungsGruppeToExcel(Cnx: TZConnection; const sertab: integer; const Templates, Filename: TFilename; Anhang: TAnhang2);
var
  grp, agrp: IAuscheidungGruppe;
  Keys: IReadOnlyCollection<integer>;
  key: integer;
  xls, wkb, sht: Variant;
  teilnehmer: smallint;
  fname: TFilename;
  extension: string;
  FileIndex: integer;
  row: Integer;
  z: TZReadOnlyQuery;
begin
  teilnehmer := 0;
  wkb := Unassigned;
  extension := ExtractFileExt(Filename);
  z := TZReadOnlyQuery.Create(nil);
  try
    z.Connection := Cnx;
    z.SQL.Add('SELECT trn.dattrn, trn.libelle'
             +'      ,cat.codcat'
             +' FROM tournoi trn'
             +'   INNER JOIN categories cat ON cat.sertrn = trn.sertrn'
             +' WHERE cat.sercat = :sercat');
    z.Params[0].AsInteger := sertab;
    z.Open;
    for grp in Anhang.GruppenListe do
    begin
      agrp := grp;
      { changement de modèle }
      if teilnehmer <> grp.Teilnehmer then
      begin
        if teilNehmer = 0 then
          teilnehmer := grp.Teilnehmer;
        { on sauvegarde le fichier actuel }
        if not VarIsEmpty(wkb) then
        begin
          FileIndex := 0;
          fname := Format('%s_Gruppe%d_%.3d%s',[ChangeFileExt(Filename, ''),Teilnehmer,FileIndex,extension]);
          while FileExists(fname) do
          begin
            Inc(FileIndex);
            fname := Format('%s_Gruppe%d_%.3d%s',[ChangeFileExt(Filename, ''),Teilnehmer,FileIndex,extension]);
          end;
          wkb.SaveAs(fname, AddToMRU:=True);
          wkb.Close;
          wkb := Unassigned;
          sht := UnAssigned;
        end;
        Teilnehmer := grp.Teilnehmer;
        createExcelWorkbook(xls, wkb, sht, True, Format('%s\Group_%d.xltx',[ExcludeTrailingPathDelimiter(Templates),grp.Teilnehmer]));
        sht := wkb.Worksheets['tableau'];
        sht.Select;
        sht.Cells[1,2] := FormatDateTime('dddd dd mmmm yyyy', z.FieldByName('dattrn').AsDateTime);
        sht.Cells[2,2] := z.FieldByName('libelle').AsString;
        sht.Cells[3,2] := z.FieldByName('codcat').AsString;
        sht.Cells[4,2] := Format('%d participants',[Anhang.Teilnehmer]);
        sht := wkb.Worksheets['position'];
        sht.Select;
        row := 2;
      end;


      Keys := grp.Spieler.Keys;
      for key in Keys.Ordered do
      begin
        Inc(row);
        sht.Cells[row,4] := grp.Spieler[Key].Verein;
        sht.Cells[row,5] := grp.Spieler[Key].Lizenz;
        sht.Cells[row,6] := grp.Spieler[Key].Name;
        sht.Cells[row,7] := grp.Spieler[Key].Klassement;
        sht.Cells[row,8] := grp.GruppeNummer;
        sht.cells[row,9] := grp.Spieler[Key].PlatzZiffer;
      end;
  //      InsereJoueurDansGroupeQualification(sergrp, grp.Spieler[key].Serjou, sercat, self.sertrn.Field.AsInteger);
    end;

    if not VarIsEmpty(wkb) then
    begin
      FileIndex := 0;
      fname := Format('%s_Gruppe%d_%.3d%s',[ChangeFileExt(Filename, ''),agrp.Teilnehmer,FileIndex,extension]);
      while FileExists(fname) do
      begin
        Inc(FileIndex);
        fname := Format('%s_Gruppe%d_%.3d%s',[ChangeFileExt(Filename, ''),agrp.Teilnehmer,FileIndex,extension]);
      end;
      wkb.SaveAs(fname, AddToMRU:=True);
      wkb.Close;
      wkb := Unassigned;
      sht := UnAssigned;
    end;
  finally
    z.Free;
  end;
end;

{ TAnhang2 }

constructor TAnhang2.Create;
begin
  GruppenListe := TCollections.CreateList<IAuscheidungGruppe>;
end;

end.
