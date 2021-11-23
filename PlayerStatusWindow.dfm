object PlayerStatusW: TPlayerStatusW
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Statut joueur'
  ClientHeight = 123
  ClientWidth = 424
  Color = 8388672
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnDblClick = statutDblClick
  DesignSize = (
    424
    123)
  PixelsPerInch = 96
  TextHeight = 16
  object statut: TLabel
    Left = 15
    Top = 8
    Width = 394
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'nom'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = False
    OnDblClick = statutDblClick
    ExplicitWidth = 425
  end
  object categs: TListView
    Left = 15
    Top = 37
    Width = 394
    Height = 76
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clCream
    Columns = <
      item
        AutoSize = True
      end>
    ShowColumnHeaders = False
    TabOrder = 0
    ViewStyle = vsReport
    OnCustomDrawItem = categsCustomDrawItem
    OnDblClick = statutDblClick
  end
end
