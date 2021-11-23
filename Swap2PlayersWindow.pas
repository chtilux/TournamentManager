unit Swap2PlayersWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, lal_connection, Vcl.StdCtrls, GroupPanel,
  System.Actions, Vcl.ActnList, Vcl.Buttons,
  Vcl.ExtCtrls;

type
  TSwap2PlayersW = class(TForm)
    BitBtn1: TBitBtn;
    ActionList1: TActionList;
    SwapAction: TAction;
    GroupBox1: TGroupBox;
    numgrpBox1: TComboBox;
    NomjouBox1: TComboBox;
    Groupe: TLabel;
    Joueur: TLabel;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    numgrpBox2: TComboBox;
    NomjouBox2: TComboBox;
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure SwapActionExecute(Sender: TObject);
    procedure numgrpBox1Click(Sender: TObject);
    procedure numgrpBox2Click(Sender: TObject);
    procedure NomjouBox1Click(Sender: TObject);
    procedure NomjouBox2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    pvCnx: TLalConnection;
    pvSercat: integer;
    Data1,Data2: TPlayerData;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent; cnx: TLalConnection; const sercat: integer); reintroduce; overload;
  end;

implementation

{$R *.dfm}

uses
  ZDataset, ZAbstractRODataset, DB;

{ TSwap2PlayersW }

procedure TSwap2PlayersW.ActionList1Update(Action: TBasicAction;
  var Handled: Boolean);
begin
  SwapAction.Enabled := Assigned(Data1) and Assigned(Data2);
  Handled := True;
end;

constructor TSwap2PlayersW.Create(AOwner: TComponent; cnx: TLalConnection; const sercat: integer);
begin
  inherited Create(AOwner);
  pvCnx := cnx;
  pvSercat := sercat;
  Data1 := nil;
  Data2 := nil;

  with TZReadOnlyQuery.Create(nil) do
  begin
    try
      Connection := pvCnx.get;
      SQL.Add('SELECT numgrp,sergrp FROM groupe WHERE sercat = :sercat');
      Params[0].AsInteger := pvSercat;
      Open;
      numgrpBox1.Enabled := not Eof;
      while not Eof do
      begin
        numgrpBox1.Items.AddObject(Fields[0].AsString, Pointer(Fields[1].AsInteger));
        Next;
      end;
      Close;
    finally
      Free;
    end;
  end;
end;

procedure TSwap2PlayersW.FormDestroy(Sender: TObject);
begin
  Data1.Free;
  Data2.Free;
end;

procedure TSwap2PlayersW.NomjouBox1Click(Sender: TObject);
begin
  if not Assigned(Data1) then
    Data1 := TPlayerData.Create(integer(numgrpBox1.Items.Objects[numgrpBox1.ItemIndex]),integer(NomjouBox1.Items.Objects[NomjouBox1.ItemIndex]))
  else
    Data1.serjou := integer(NomjouBox1.Items.Objects[NomjouBox1.ItemIndex]);
end;

procedure TSwap2PlayersW.NomjouBox2Click(Sender: TObject);
begin
  if not Assigned(Data2) then
    Data2 := TPlayerData.Create(integer(numgrpBox2.Items.Objects[numgrpBox2.ItemIndex]),integer(NomjouBox2.Items.Objects[NomjouBox2.ItemIndex]))
  else
    Data2.serjou := integer(NomjouBox2.Items.Objects[NomjouBox2.ItemIndex]);
end;

procedure TSwap2PlayersW.numgrpBox1Click(Sender: TObject);
begin
  NomjouBox1.Items.BeginUpdate;
  try
    NomjouBox1.Items.Clear;
    with TZReadOnlyQuery.Create(nil) do
    begin
      try
        Connection := pvCnx.get;
        SQL.Add('SELECT cg.numseq,cg.serjou,jou.nomjou,clb.libclb'
               +' FROM compo_groupe cg'
               +'   INNER JOIN joueur jou ON jou.serjou = cg.serjou'
               +'   INNER JOIN club clb ON clb.codclb = jou.codclb'
               +' WHERE cg.sergrp = :sergrp'
               +' ORDER BY cg.numseq');
        Params[0].AsInteger := integer(numgrpBox1.Items.Objects[numgrpBox1.ItemIndex]);
        Open;
        NomjouBox1.Enabled := not Eof;
        while not Eof do
        begin
          NomJouBox1.Items.AddObject(Fields[2].AsString+', '+Fields[3].AsString, Pointer(Fields[1].AsInteger));
          Next;
        end;
        Close;
      finally
        Free;
      end;
    end;
  finally
    NomjouBox1.Items.EndUpdate;
  end;

  numgrpBox2.Items.BeginUpdate;
  try
    numgrpBox2.Items.Clear;
    with TZReadOnlyQuery.Create(nil) do
    begin
      try
        Connection := pvCnx.get;
        SQL.Add('SELECT numgrp,sergrp FROM groupe WHERE sercat = :sercat');
        Params[0].AsInteger := pvSercat;
        Open;
        numgrpBox2.Enabled := not Eof;
        while not Eof do
        begin
          if Fields[0].AsString <> numgrpBox1.Text then
            numgrpBox2.Items.AddObject(Fields[0].AsString, Pointer(Fields[1].AsInteger));
          Next;
        end;
        Close;
      finally
        Free;
      end;
    end;

  finally
    numgrpBox2.Items.EndUpdate;
  end;
end;

procedure TSwap2PlayersW.numgrpBox2Click(Sender: TObject);
begin
  NomjouBox2.Items.BeginUpdate;
  try
    NomjouBox2.Items.Clear;
    with TZReadOnlyQuery.Create(nil) do
    begin
      try
        Connection := pvCnx.get;
        SQL.Add('SELECT cg.numseq,cg.serjou,jou.nomjou,clb.libclb'
               +' FROM compo_groupe cg'
               +'   INNER JOIN joueur jou ON jou.serjou = cg.serjou'
               +'   INNER JOIN club clb ON clb.codclb = jou.codclb'
               +' WHERE cg.sergrp = :sergrp'
               +' ORDER BY cg.numseq');
        Params[0].AsInteger := integer(numgrpBox2.Items.Objects[numgrpBox2.ItemIndex]);
        Open;
        NomjouBox2.Enabled := not Eof;
        while not Eof do
        begin
          if Fields[1].AsInteger <> integer(NomjouBox1.Items.Objects[NomjouBox1.ItemIndex]) then // normalement ce test est superflu car le combo du groupe est filtré
            NomJouBox2.Items.AddObject(Fields[2].AsString+', '+Fields[3].AsString, Pointer(Fields[1].AsInteger));
          Next;
        end;
        Close;
      finally
        Free;
      end;
    end;
  finally
    NomjouBox2.Items.EndUpdate;
  end;
end;

procedure TSwap2PlayersW.SwapActionExecute(Sender: TObject);
begin
  TSwapData.swap(pvCnx, Data1, Data2);
  ModalResult := mrOk;
end;

end.

