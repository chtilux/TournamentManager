object matchW: TmatchW
  Left = 0
  Top = 0
  Caption = 'Saisie des r'#233'sultats des rencontres'
  ClientHeight = 248
  ClientWidth = 699
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 699
    Height = 41
    Align = alTop
    TabOrder = 0
    object codcat: TDBText
      Left = 91
      Top = 9
      Width = 70
      Height = 25
      AutoSize = True
      DataField = 'codcat'
      DataSource = tabSource
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object level: TDBText
      Left = 461
      Top = 18
      Width = 65
      Height = 17
      DataField = 'level'
      DataSource = mtcSource
    end
    object Label1: TLabel
      Left = 36
      Top = 16
      Width = 45
      Height = 13
      Caption = 'Tableau :'
    end
    object Label2: TLabel
      Left = 425
      Top = 18
      Width = 29
      Height = 13
      Caption = 'Tour :'
    end
    object Label8: TLabel
      Left = 536
      Top = 18
      Width = 80
      Height = 13
      Caption = 'Prochain match :'
    end
    object DBText1: TDBText
      Left = 624
      Top = 18
      Width = 65
      Height = 17
      DataField = 'prochain'
      DataSource = mtcSource
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 699
    Height = 166
    Align = alClient
    TabOrder = 1
    DesignSize = (
      699
      166)
    object Label3: TLabel
      Left = 47
      Top = 16
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Caption = 'Table :'
    end
    object Label4: TLabel
      Left = 16
      Top = 53
      Width = 64
      Height = 13
      Alignment = taRightJustify
      Caption = 'Adversaires :'
    end
    object Label5: TLabel
      Left = 25
      Top = 111
      Width = 55
      Height = 13
      Alignment = taRightJustify
      Caption = 'Vainqueur :'
    end
    object Label6: TLabel
      Left = 35
      Top = 135
      Width = 45
      Height = 13
      Alignment = taRightJustify
      Caption = 'Perdant :'
    end
    object Label7: TLabel
      Left = 144
      Top = 16
      Width = 33
      Height = 13
      Caption = 'score :'
    end
    object arbitre: TLabel
      Left = 88
      Top = 135
      Width = 4
      Height = 13
      Caption = '-'
    end
    object Label9: TLabel
      Left = 579
      Top = 143
      Width = 39
      Height = 13
      Caption = 'sermtc :'
    end
    object sermtc: TDBText
      Left = 624
      Top = 143
      Width = 65
      Height = 17
      DataField = 'sermtc'
      DataSource = mtcSource
    end
    object numtbl: TEdit
      Left = 88
      Top = 13
      Width = 40
      Height = 21
      TabOrder = 0
      OnExit = numtblExit
      OnKeyPress = numtblKeyPress
    end
    object nomjo1: TDBEdit
      Left = 88
      Top = 50
      Width = 208
      Height = 21
      TabStop = False
      DataField = 'Player1Name'
      DataSource = mtcSource
      ReadOnly = True
      TabOrder = 1
    end
    object nomjo2: TDBEdit
      Left = 88
      Top = 74
      Width = 208
      Height = 21
      TabStop = False
      DataField = 'Player2name'
      DataSource = mtcSource
      ReadOnly = True
      TabOrder = 2
    end
    object codcl1: TDBEdit
      Left = 297
      Top = 50
      Width = 40
      Height = 21
      TabStop = False
      DataField = 'codcl1'
      DataSource = mtcSource
      ReadOnly = True
      TabOrder = 3
    end
    object codcl2: TDBEdit
      Left = 297
      Top = 74
      Width = 40
      Height = 21
      TabStop = False
      DataField = 'codcl2'
      DataSource = mtcSource
      ReadOnly = True
      TabOrder = 4
    end
    object handi1: TDBEdit
      Left = 338
      Top = 50
      Width = 40
      Height = 21
      TabStop = False
      DataField = 'handi1'
      DataSource = mtcSource
      ReadOnly = True
      TabOrder = 5
    end
    object handi2: TDBEdit
      Left = 338
      Top = 74
      Width = 40
      Height = 21
      TabStop = False
      DataField = 'handi2'
      DataSource = mtcSource
      ReadOnly = True
      TabOrder = 6
    end
    object scoreEdit: TEdit
      Left = 183
      Top = 13
      Width = 195
      Height = 21
      TabOrder = 7
      Text = '3.0'
      OnExit = scoreEditExit
      OnKeyPress = scoreEditKeyPress
    end
    object nomvqr: TEdit
      Left = 88
      Top = 108
      Width = 208
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 8
    end
    object score: TEdit
      Left = 297
      Top = 108
      Width = 81
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 9
    end
    object score_1_1: TEdit
      Left = 424
      Top = 50
      Width = 30
      Height = 21
      TabStop = False
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 10
    end
    object score_2_1: TEdit
      Left = 424
      Top = 74
      Width = 30
      Height = 21
      TabStop = False
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 11
    end
    object score_1_2: TEdit
      Left = 455
      Top = 50
      Width = 30
      Height = 21
      TabStop = False
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 12
    end
    object score_2_2: TEdit
      Left = 455
      Top = 74
      Width = 30
      Height = 21
      TabStop = False
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 13
    end
    object score_1_3: TEdit
      Left = 487
      Top = 50
      Width = 30
      Height = 21
      TabStop = False
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 14
    end
    object score_2_3: TEdit
      Left = 487
      Top = 74
      Width = 30
      Height = 21
      TabStop = False
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 15
    end
    object score_1_4: TEdit
      Left = 519
      Top = 50
      Width = 30
      Height = 21
      TabStop = False
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 16
    end
    object score_2_4: TEdit
      Left = 519
      Top = 74
      Width = 30
      Height = 21
      TabStop = False
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 17
    end
    object score_1_5: TEdit
      Left = 550
      Top = 50
      Width = 30
      Height = 21
      TabStop = False
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 18
    end
    object score_2_5: TEdit
      Left = 550
      Top = 74
      Width = 30
      Height = 21
      TabStop = False
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 19
    end
    object score_1_6: TEdit
      Left = 582
      Top = 50
      Width = 30
      Height = 21
      TabStop = False
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 20
    end
    object score_2_6: TEdit
      Left = 582
      Top = 74
      Width = 30
      Height = 21
      TabStop = False
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 21
    end
    object score_1_7: TEdit
      Left = 614
      Top = 50
      Width = 30
      Height = 21
      TabStop = False
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 22
    end
    object score_2_7: TEdit
      Left = 614
      Top = 74
      Width = 30
      Height = 21
      TabStop = False
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 23
    end
    object score1: TEdit
      Left = 645
      Top = 50
      Width = 44
      Height = 21
      TabStop = False
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 24
    end
    object score2: TEdit
      Left = 645
      Top = 74
      Width = 44
      Height = 21
      TabStop = False
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 25
    end
    object woj1: TCheckBox
      Left = 381
      Top = 52
      Width = 36
      Height = 17
      Caption = 'wo'
      TabOrder = 26
      OnClick = woj1Click
    end
    object woj2: TCheckBox
      Left = 381
      Top = 75
      Width = 36
      Height = 17
      Caption = 'wo'
      TabOrder = 27
      OnClick = woj2Click
    end
    object games: TEdit
      Left = 208
      Top = 132
      Width = 170
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 28
    end
    object saisieBox: TRadioGroup
      Left = 423
      Top = 5
      Width = 265
      Height = 38
      Caption = 'Mode de saisie'
      Columns = 2
      Items.Strings = (
        'd'#233'tail (11-6, 11-8, ...)'
        'sets (3-1)')
      TabOrder = 29
    end
    object PointsEdit: TEdit
      Left = 645
      Top = 98
      Width = 44
      Height = 21
      TabStop = False
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 30
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 207
    Width = 699
    Height = 41
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      699
      41)
    object okButton: TBitBtn
      Left = 532
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Enabled = False
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
      Left = 614
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      TabStop = False
    end
    object cancelGameButton: TBitBtn
      Left = 16
      Top = 6
      Width = 112
      Height = 25
      Caption = 'Cancel Game !'
      Kind = bkIgnore
      NumGlyphs = 2
      TabOrder = 2
      OnClick = cancelGameButtonClick
    end
    object changePlayAreaButton: TBitBtn
      Left = 134
      Top = 6
      Width = 112
      Height = 25
      Caption = 'Change play area'
      Enabled = False
      Kind = bkRetry
      NumGlyphs = 2
      TabOrder = 3
      OnClick = changePlayAreaButtonClick
    end
  end
  object mtcSource: TDataSource
    Left = 512
    Top = 280
  end
  object tabSource: TDataSource
    Left = 568
    Top = 288
  end
end
