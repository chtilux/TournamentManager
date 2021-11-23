object styleW: TstyleW
  Left = 0
  Top = 0
  Caption = 'Style de fen'#234'tre'
  ClientHeight = 374
  ClientWidth = 803
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 505
    Top = 0
    Height = 333
    Align = alRight
    ExplicitLeft = 616
  end
  object Panel1: TPanel
    Left = 0
    Top = 333
    Width = 803
    Height = 41
    Align = alBottom
    TabOrder = 0
    ExplicitLeft = 120
    ExplicitTop = 336
    ExplicitWidth = 393
    object BitBtn1: TBitBtn
      Left = 8
      Top = 9
      Width = 75
      Height = 25
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 89
      Top = 9
      Width = 75
      Height = 25
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
    object BitBtn3: TBitBtn
      Left = 546
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Apply'
      Kind = bkRetry
      NumGlyphs = 2
      TabOrder = 2
      OnClick = BitBtn3Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 505
    Height = 333
    Align = alClient
    BorderWidth = 3
    Caption = 'Panel2'
    TabOrder = 1
    ExplicitWidth = 615
    object ListView1: TListView
      Left = 4
      Top = 4
      Width = 497
      Height = 325
      Align = alClient
      Columns = <
        item
          Caption = 'Source'
          Width = 80
        end
        item
          AutoSize = True
          Caption = 'Style File'
        end
        item
          Caption = 'Name'
          Width = 100
        end
        item
          Caption = 'Author'
          Width = 100
        end
        item
          Caption = 'Author URL'
          Width = 100
        end
        item
          Caption = 'Version'
          Width = 55
        end>
      TabOrder = 0
      ViewStyle = vsReport
      OnSelectItem = ListView1SelectItem
    end
  end
  object previewPanel: TPanel
    Left = 508
    Top = 0
    Width = 295
    Height = 333
    Align = alRight
    BorderWidth = 3
    TabOrder = 2
    ExplicitLeft = 509
  end
end
