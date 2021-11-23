object joueursNonPlacesW: TjoueursNonPlacesW
  Left = 0
  Top = 0
  Caption = 'joueursNonPlacesW'
  ClientHeight = 473
  ClientWidth = 652
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 140
    Width = 652
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitWidth = 333
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 652
    Height = 140
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 0
    object StaticText1: TStaticText
      Left = 1
      Top = 1
      Width = 158
      Height = 23
      Align = alTop
      Caption = 'Joueurs non plac'#233's'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object joueursGrid: TDBGrid
      Left = 1
      Top = 24
      Width = 650
      Height = 115
      Align = alClient
      DataSource = joueursSource
      PopupMenu = PopupMenu1
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnCellClick = positionsGridCellClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 143
    Width = 652
    Height = 330
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    object StaticText2: TStaticText
      Left = 1
      Top = 1
      Width = 161
      Height = 23
      Align = alTop
      Caption = 'Positions '#224' occuper'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object positionsGrid: TDBGrid
      Left = 1
      Top = 24
      Width = 650
      Height = 305
      Align = alClient
      DataSource = positionsSource
      PopupMenu = PopupMenu1
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnCellClick = positionsGridCellClick
      OnDrawColumnCell = positionsGridDrawColumnCell
    end
  end
  object joueursSource: TDataSource
    Left = 280
    Top = 112
  end
  object positionsSource: TDataSource
    Left = 408
    Top = 225
  end
  object ActionList1: TActionList
    Left = 496
    Top = 311
    object placeAction: TAction
      Caption = 'Placer'
      ShortCut = 16464
      OnExecute = placeActionExecute
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 312
    Top = 215
    object Placer1: TMenuItem
      Action = placeAction
    end
  end
end
