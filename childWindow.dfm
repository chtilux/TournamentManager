object childW: TchildW
  Left = 0
  Top = 0
  Caption = 'childW'
  ClientHeight = 575
  ClientWidth = 779
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object topPanel: TPanel
    Left = 0
    Top = 0
    Width = 779
    Height = 65
    Align = alTop
    TabOrder = 0
  end
  object midpanel: TPanel
    Left = 0
    Top = 65
    Width = 779
    Height = 469
    Align = alClient
    BorderWidth = 3
    TabOrder = 1
  end
  object bottomPanel: TPanel
    Left = 0
    Top = 534
    Width = 779
    Height = 41
    Align = alBottom
    TabOrder = 2
  end
end
