object addAPlayerW: TaddAPlayerW
  Left = 0
  Top = 0
  Caption = 'addAPlayerW'
  ClientHeight = 373
  ClientWidth = 763
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 763
    Height = 277
    Align = alTop
    BorderWidth = 3
    TabOrder = 0
    object DBGrid1: TDBGrid
      Left = 4
      Top = 4
      Width = 755
      Height = 269
      Align = alClient
      DataSource = DataSource1
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 277
    Width = 763
    Height = 55
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 656
      Top = 8
      Width = 88
      Height = 13
      Caption = 'Date de naissance'
    end
    object licence: TLabeledEdit
      Left = 10
      Top = 24
      Width = 79
      Height = 21
      CharCase = ecUpperCase
      EditLabel.Width = 35
      EditLabel.Height = 13
      EditLabel.Caption = 'Licence'
      TabOrder = 0
    end
    object nom: TLabeledEdit
      Left = 104
      Top = 24
      Width = 247
      Height = 21
      CharCase = ecUpperCase
      EditLabel.Width = 21
      EditLabel.Height = 13
      EditLabel.Caption = 'Nom'
      TabOrder = 1
    end
    object codcls: TLabeledEdit
      Left = 368
      Top = 24
      Width = 79
      Height = 21
      CharCase = ecUpperCase
      EditLabel.Width = 55
      EditLabel.Height = 13
      EditLabel.Caption = 'Classement'
      TabOrder = 2
    end
    object codclb: TLabeledEdit
      Left = 464
      Top = 24
      Width = 79
      Height = 21
      CharCase = ecUpperCase
      EditLabel.Width = 21
      EditLabel.Height = 13
      EditLabel.Caption = 'Club'
      TabOrder = 3
      OnChange = codclbChange
    end
    object vrbrgl: TLabeledEdit
      Left = 563
      Top = 24
      Width = 79
      Height = 21
      Alignment = taRightJustify
      EditLabel.Width = 53
      EditLabel.Height = 13
      EditLabel.Caption = 'Rangl'#235'scht'
      NumbersOnly = True
      TabOrder = 4
      Text = '9999'
    end
    object datnss: TDateTimePicker
      Left = 656
      Top = 24
      Width = 87
      Height = 21
      Date = 43494.771898784730000000
      Time = 43494.771898784730000000
      TabOrder = 5
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 332
    Width = 763
    Height = 41
    Align = alBottom
    TabOrder = 2
    object okButton: TBitBtn
      Left = 260
      Top = 5
      Width = 91
      Height = 31
      Caption = 'OK'
      Default = True
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
      TabOrder = 0
      OnClick = okButtonClick
    end
    object cancelButton: TBitBtn
      Left = 392
      Top = 5
      Width = 91
      Height = 31
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object DataSource1: TDataSource
    OnDataChange = DataSource1DataChange
    Left = 296
    Top = 56
  end
end
