unit addAPlayerWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, ZDataset, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, lal_connection;

type
  TaddAPlayerW = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    licence: TLabeledEdit;
    nom: TLabeledEdit;
    codcls: TLabeledEdit;
    codclb: TLabeledEdit;
    vrbrgl: TLabeledEdit;
    okButton: TBitBtn;
    cancelButton: TBitBtn;
    datnss: TDateTimePicker;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure codclbChange(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
  private
    { Déclarations privées }
    _sertrn,
    _sercat,
    _maxcat: integer;
    _data: TZReadOnlyQuery;
    pvCnx: TLalConnection;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent; cnx: TLalConnection; const sertrn, sercat, maxcat: integer); reintroduce; overload;
    property sercat: integer read _sercat;
    property sertrn: integer read _sertrn;
  end;

implementation

{$R *.dfm}

uses
  lal_dbUtils, System.UITypes;

{ TaddAPlayerW }

procedure TaddAPlayerW.codclbChange(Sender: TObject);
begin
  with getROQuery(pvCnx) do
  begin
    try
      sql.Add('select libclb from club where codclb = :codclb');
      Params[0].AsString := codclb.Text;
      Open;
      if not IsEmpty then
        codclb.EditLabel.Caption := Fields[0].AsString
      else
        codclb.EditLabel.Caption := 'code club inconnu !';
    finally
      Free;
    end;
  end;
end;

constructor TaddAPlayerW.Create(AOwner: TComponent; cnx: TLalConnection; const sertrn,
  sercat, maxcat: integer);
var
  z: TZReadOnlyQuery;
begin
  _sertrn := sertrn;
  _sercat := sercat;
  _maxcat := maxcat;
  pvCnx := cnx;
  inherited Create(AOwner);
  _data := getROQuery(pvCnx, Self);
  z := getROQuery(pvCnx);
  try
    z.SQL.Add('select codcls from tournoi where sertrn = :sertrn');
    z.Params[0].AsInteger := sertrn;
    z.Open;
    _data.SQL.Add('select licence,nomjou,a.codclb,libclb,codcls'
                 +'   ,topcls,topdem,vrbrgl,datann'
                 +' from joueur a, club b'
                 +' where a.codclb = b.codclb'
                 +'   and ' + z.fields[0].AsString + ' in '
                 +'  (select codcls from classements where sercat = :sercat)'
                 +'  and licence not in (select licence from joueur a, insc b'
                 +'                       where a.serjou = b.serjou'
                 +'                         and b.sercat = :sercat)'
                 +'  and (select count( * ) from insc'
                 +'        where sertrn = :sertrn'
                 +'          and serjou = a.serjou) < (select maxcat from tournoi'
                 +'                                    where sertrn = :sertrn)'
                 +' order by 2');
    _data.ParamByName('sercat').AsInteger := _sercat;
    _data.ParamByName('sertrn').AsInteger := _sertrn;
    z.Close;
  finally
    z.Free;
  end;
  DataSource1.DataSet := _data;
end;

procedure TaddAPlayerW.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  if Field = nil then
  begin
    licence.Text := _data.FieldByName('licence').AsString;
    nom.Text := _data.FieldByName('nomjou').AsString;
    codcls.Text := _data.FieldByName('codcls').AsString;
    codclb.Text := _data.FieldByName('codclb').AsString;
    datnss.DateTime := _data.FieldByName('datann').AsDateTime;
    with getROQuery(pvCnx) do
    begin
      try
        sql.Add('select libclb from club where codclb = :codclb');
        Params[0].AsString := codclb.Text;
        Open;
        if not IsEmpty then
          codclb.EditLabel.Caption := Fields[0].AsString
        else
          codclb.EditLabel.Caption := 'code club inconnu !';
      finally
        Free;
      end;
    end;
    vrbrgl.Text := _data.FieldByName('vrbrgl').AsString;
  end
end;

procedure TaddAPlayerW.FormShow(Sender: TObject);
begin
  _data.ParamByName('sercat').AsInteger := _sercat;
  _data.Open;
end;

procedure TaddAPlayerW.okButtonClick(Sender: TObject);
var
  z: TZReadOnlyQuery;
begin
  z := getROQuery(pvCnx);
  try
    { vérifier si pas déjà inscrit dans la catégorie }
    z.SQL.Add('select count( * ) from insc a, joueur b'
             +' where sercat = :sercat'
             +'   and a.serjou = b.serjou'
             +'   and b.licence = :licence');
    z.ParamByName('sercat').AsInteger := _sercat;
    z.ParamByName('licence').AsString := licence.Text;
    z.Open;
    if z.Fields[0].AsInteger > 0 then
    begin
      MessageDlg('Ce joueur est déjà inscrit dans cette catégorie.', mtWarning, [mbOk], 0);
      z.Close;
      Exit;
    end;
    z.Close;

    { Vérifier si maxcat pas atteind. }
    z.SQL.Clear;
    z.SQL.Add('select count( * ) from insc a, joueur b where sertrn = :sertrn'
             +'  and a.serjou = b.serjou'
             +'  and licence = :licence');
    z.ParamByName('sertrn').AsInteger := _sertrn;
    z.ParamByName('licence').AsString := licence.Text;
    z.Open;
    if z.Fields[0].AsInteger = _maxcat then
    begin
      MessageDlg('Ce joueur est déjà inscrit dans ' + IntToStr(_maxcat)
                +' catégories.', mtWarning, [mbOk], 0);
      z.Close;
      Exit;
    end;
    z.Close;
    ModalResult := mrOk;
  finally
    z.free;
  end;
end;

end.
