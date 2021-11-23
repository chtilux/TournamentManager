object SeedsW: TSeedsW
  Left = 0
  Top = 0
  Caption = 'T'#234'tes de s'#233'rie'
  ClientHeight = 390
  ClientWidth = 898
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 898
    Height = 32
    Align = alTop
    BorderWidth = 3
    TabOrder = 0
    object nav: TDBNavigator
      Left = 4
      Top = 4
      Width = 240
      Height = 24
      DataSource = dts
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbEdit, nbPost, nbCancel, nbRefresh]
      Align = alLeft
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 32
    Width = 898
    Height = 358
    Align = alClient
    BorderWidth = 3
    TabOrder = 1
    object grid: TDBGrid
      Left = 4
      Top = 4
      Width = 890
      Height = 350
      Align = alClient
      DataSource = dts
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnKeyPress = gridKeyPress
      OnTitleClick = gridTitleClick
    end
  end
  object dts: TDataSource
    Left = 432
    Top = 104
  end
end
