object umpiresW: TumpiresW
  Left = 0
  Top = 0
  Caption = 'Arbitres'
  ClientHeight = 333
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 35
    Align = alTop
    BorderWidth = 3
    TabOrder = 0
    object Button1: TButton
      Left = 4
      Top = 4
      Width = 592
      Height = 27
      Align = alClient
      Caption = 'Refresh'
      TabOrder = 0
      OnClick = Button1Click
      ExplicitLeft = 32
      ExplicitWidth = 75
      ExplicitHeight = 25
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 35
    Width = 600
    Height = 298
    Align = alClient
    BorderWidth = 3
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 4
      Top = 4
      Width = 592
      Height = 290
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
  object DataSource1: TDataSource
    AutoEdit = False
    Left = 296
    Top = 168
  end
end