object dataW: TdataW
  Left = 227
  Top = 108
  BorderStyle = bsSizeToolWin
  Caption = 'Dialogue'
  ClientHeight = 530
  ClientWidth = 399
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    399
    530)
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TButton
    Left = 313
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 313
    Top = 38
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Annuler'
    ModalResult = 2
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 8
    Top = 5
    Width = 299
    Height = 519
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 2
    object DBNavigator1: TDBNavigator
      Left = 3
      Top = 3
      Width = 293
      Height = 25
      DataSource = dataSource
      Align = alTop
      TabOrder = 0
    end
    object DBGrid1: TDBGrid
      Left = 3
      Top = 28
      Width = 293
      Height = 471
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      DataSource = dataSource
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object SB: TStatusBar
    Left = 0
    Top = 511
    Width = 399
    Height = 19
    Panels = <
      item
        Width = 300
      end>
  end
  object dataSource: TDataSource
    Left = 192
    Top = 272
  end
end
