object Swap2PlayersW: TSwap2PlayersW
  Left = 0
  Top = 0
  Caption = 'Swap 2 groups players '
  ClientHeight = 247
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 120
    Top = 198
    Width = 143
    Height = 42
    Action = SwapAction
    Caption = 'SWAP'
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 369
    Height = 81
    Caption = 'Joueur 1'
    TabOrder = 1
    object Groupe: TLabel
      Left = 16
      Top = 23
      Width = 35
      Height = 13
      Caption = 'Groupe'
    end
    object Joueur: TLabel
      Left = 192
      Top = 23
      Width = 33
      Height = 13
      Caption = 'Joueur'
    end
    object numgrpBox1: TComboBox
      Left = 16
      Top = 40
      Width = 145
      Height = 21
      Enabled = False
      TabOrder = 0
      OnClick = numgrpBox1Click
    end
    object NomjouBox1: TComboBox
      Left = 192
      Top = 40
      Width = 145
      Height = 21
      Enabled = False
      TabOrder = 1
      OnClick = NomjouBox1Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 95
    Width = 369
    Height = 81
    Caption = 'Joueur 2'
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 23
      Width = 35
      Height = 13
      Caption = 'Groupe'
    end
    object Label2: TLabel
      Left = 192
      Top = 23
      Width = 33
      Height = 13
      Caption = 'Joueur'
    end
    object numgrpBox2: TComboBox
      Left = 16
      Top = 40
      Width = 145
      Height = 21
      Enabled = False
      TabOrder = 0
      OnClick = numgrpBox2Click
    end
    object NomjouBox2: TComboBox
      Left = 192
      Top = 40
      Width = 145
      Height = 21
      Enabled = False
      TabOrder = 1
      OnClick = NomjouBox2Click
    end
  end
  object ActionList1: TActionList
    OnUpdate = ActionList1Update
    Left = 272
    Top = 200
    object SwapAction: TAction
      Caption = 'SWAP'
      OnExecute = SwapActionExecute
    end
  end
end
