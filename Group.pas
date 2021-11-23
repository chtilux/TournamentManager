unit Group;

interface

uses
  lal_connection, ZDataset, Data.Db, System.Classes;

type

  TGroup = class
  private
    pvCnx: TLalConnection;
    pvGroupe,
    pvCompoGroupe,
    pvPlayAreaNumber: TZReadOnlyQuery;
    function GetHeure: string;
    function GetSerial: integer;
    function GetPlayAreaNumber: integer;
    function GetGroupNumber: integer;
    function GetPlayersList: TStrings;
  public
    constructor Create(cnx: TLalConnection; const sergrp: integer); reintroduce; overload;
    destructor Destroy; override;
    property Serial: integer read GetSerial;
    property Heure: string read GetHeure;
    property PlayAreaNumber: integer read GetPlayAreaNumber;
    property GroupNumber: integer read GetGroupNumber;
    property PlayersList: TStrings read GetPlayersList;
  end;

implementation

{ TGroup }

constructor TGroup.Create(cnx: TLalConnection;
  const sergrp: integer);
begin
  inherited Create;
  pvCnx := cnx;
  pvGroupe := TZReadOnlyQuery.Create(nil);
  pvGroupe.Connection := pvCnx.get;
  pvGroupe.SQL.Add('SELECT sergrp,sercat,numgrp,stagrp,sertrn,heure'
                  +' FROM groupe'
                  +' WHERE sergrp = :sergrp');
  pvGroupe.Params[0].AsInteger := sergrp;
  pvGroupe.Open;

  pvCompoGroupe := TZReadOnlyQuery.Create(nil);
  pvCompoGroupe.Connection := pvCnx.get;
  pvCompoGroupe.SQL.Add('SELECT cg.numseq, cg.serjou,jou.nomjou,clb.libclb'
                       +' FROM compo_groupe cg'
                       +'      INNER JOIN joueur jou ON jou.serjou = cg.serjou'
                       +'      INNER JOIN club clb ON clb.codclb = jou.codclb'
                       +' WHERE cg.sergrp = :sergrp'
                       +' ORDER BY 1');
  pvCompoGroupe.Params[0].AsInteger := sergrp;
  pvCompoGroupe.Open;
  pvPlayAreaNumber := TZReadOnlyQuery.Create(nil);
  pvPlayAreaNumber.Connection := pvCnx.get;
  pvPlayAreaNumber.SQL.Add('SELECT DISTINCT numtbl FROM umpires'
                          +' WHERE sermtc = :sergrp');
  pvPlayAreaNumber.Params[0].AsInteger := sergrp;
  pvPlayAreaNumber.Open;
end;

destructor TGroup.Destroy;
begin
  pvPlayAreaNumber.Close; pvPlayAreaNumber.Free;
  pvCompoGroupe.Close; pvCompoGroupe.Free;
  pvGroupe.Close; pvGroupe.Free;
  inherited;
end;

function TGroup.GetGroupNumber: integer;
begin
  Result := pvGroupe.FieldByName('numgrp').AsInteger;
end;

function TGroup.GetHeure: string;
begin
  Result := pvGroupe.FieldByName('heure').AsString;
end;

function TGroup.GetPlayAreaNumber: integer;
begin
  Result := pvPlayAreaNumber.Fields[0].AsInteger;
end;

function TGroup.GetPlayersList: TStrings;
begin
  Result := TStringList.Create;
  pvCompoGroupe.First;
  while not pvCompoGroupe.Eof do
  begin
    Result.Add(pvCompoGroupe.FieldByName('nomjou').AsString);
    pvCompoGroupe.Next;
  end;
end;

function TGroup.GetSerial: integer;
begin
  Result := pvGroupe.FieldByName('sergrp').AsInteger;
end;

end.

