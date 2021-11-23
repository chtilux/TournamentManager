object inscJouW: TinscJouW
  Left = 0
  Top = 0
  Caption = 'Statut joueur'
  ClientHeight = 329
  ClientWidth = 475
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 475
    Height = 41
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 16
      Width = 58
      Height = 13
      Caption = 'Recherche :'
    end
    object search: TEdit
      Left = 96
      Top = 12
      Width = 185
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
      OnChange = searchChange
      OnKeyDown = searchKeyDown
    end
    object Accepter: TBitBtn
      Left = 299
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Accepter'
      ModalResult = 1
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 475
    Height = 288
    Align = alClient
    TabOrder = 1
    object searchGrid: TDBGrid
      Left = 1
      Top = 1
      Width = 473
      Height = 286
      Align = alClient
      DataSource = searchSource
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDrawColumnCell = searchGridDrawColumnCell
      OnKeyDown = searchGridKeyDown
      Columns = <
        item
          Expanded = False
          FieldName = 'nomjou'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'codcat'
          Width = 81
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'statut'
          Width = 103
          Visible = True
        end>
    end
  end
  object searchSource: TDataSource
    Left = 288
    Top = 113
  end
end
