object clscatageW: TclscatageW
  Left = 0
  Top = 0
  Caption = 'Classes d'#39#226'ge'
  ClientHeight = 604
  ClientWidth = 436
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    436
    604)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 332
    Height = 588
    Anchors = [akLeft, akTop, akRight, akBottom]
    Shape = bsFrame
    ExplicitWidth = 295
  end
  object OKBtn: TButton
    Left = 351
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    ExplicitLeft = 364
  end
  object CancelBtn: TButton
    Left = 351
    Top = 38
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Annuler'
    ModalResult = 2
    TabOrder = 1
    ExplicitLeft = 364
  end
  object HelpBtn: TButton
    Left = 351
    Top = 68
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Aide'
    TabOrder = 2
    ExplicitLeft = 364
  end
  object lv: TListView
    Left = 16
    Top = 17
    Width = 316
    Height = 568
    Anchors = [akLeft, akTop, akRight, akBottom]
    Checkboxes = True
    Columns = <
      item
        Caption = 'Classement'
      end
      item
        AutoSize = True
        Caption = 'Libell'#233
      end>
    MultiSelect = True
    TabOrder = 3
    ViewStyle = vsReport
    ExplicitWidth = 257
  end
  object allButton: TButton
    Left = 353
    Top = 128
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'ALL'
    TabOrder = 4
    OnClick = allButtonClick
    ExplicitLeft = 366
  end
end
