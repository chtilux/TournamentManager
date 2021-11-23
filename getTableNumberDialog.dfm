object getTableNumberDlg: TgetTableNumberDlg
  Left = 0
  Top = 0
  Caption = 'getTableNumberDlg'
  ClientHeight = 522
  ClientWidth = 482
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
  object DBGrid1: TDBGrid
    Left = 8
    Top = 8
    Width = 466
    Height = 473
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnKeyDown = DBGrid1KeyDown
  end
  object DataSource1: TDataSource
    Left = 232
    Top = 264
  end
  object ActionList1: TActionList
    Left = 320
    Top = 248
    object okAction: TAction
      Caption = 'Accepter'
      OnExecute = okActionExecute
    end
    object cancelAction: TAction
      Caption = 'Refuser'
      ShortCut = 27
      OnExecute = cancelActionExecute
    end
  end
end
