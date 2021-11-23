object saisieW: TsaisieW
  Left = 0
  Top = 0
  Caption = 'Matchs en cours er recherche'
  ClientHeight = 549
  ClientWidth = 780
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
    Width = 780
    Height = 41
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 601
    object Label1: TLabel
      Left = 32
      Top = 16
      Width = 58
      Height = 13
      Caption = 'Recherche :'
    end
    object SpeedButton1: TSpeedButton
      Left = 287
      Top = 11
      Width = 23
      Height = 22
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333FFFFF3333333333999993333333333F77777FFF333333999999999
        3333333777333777FF33339993707399933333773337F3777FF3399933000339
        9933377333777F3377F3399333707333993337733337333337FF993333333333
        399377F33333F333377F993333303333399377F33337FF333373993333707333
        333377F333777F333333993333101333333377F333777F3FFFFF993333000399
        999377FF33777F77777F3993330003399993373FF3777F37777F399933000333
        99933773FF777F3F777F339993707399999333773F373F77777F333999999999
        3393333777333777337333333999993333333333377777333333}
      NumGlyphs = 2
      OnClick = SpeedButton1Click
    end
    object search: TEdit
      Left = 96
      Top = 12
      Width = 185
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
      OnChange = searchChange
      OnKeyPress = searchKeyPress
    end
    object sourceBox: TRadioGroup
      Left = 408
      Top = 1
      Width = 209
      Height = 35
      Caption = 'Source'
      Columns = 2
      ItemIndex = 1
      Items.Strings = (
        'tous les matchs'
        'en cours')
      TabOrder = 1
      OnClick = sourceBoxClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 780
    Height = 508
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 601
    ExplicitHeight = 288
    object searchGrid: TDBGrid
      Left = 1
      Top = 1
      Width = 778
      Height = 506
      Align = alClient
      DataSource = searchSource
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDrawColumnCell = searchGridDrawColumnCell
      OnKeyPress = searchKeyPress
      Columns = <
        item
          Expanded = False
          FieldName = 'codcat'
          Title.Alignment = taCenter
          Title.Caption = 'Cat'#233'gorie'
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'nummtc'
          Title.Alignment = taCenter
          Title.Caption = 'N'#176' Match'
          Width = 60
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'numtbl'
          Title.Alignment = taCenter
          Title.Caption = 'Table'
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'heure'
          Title.Alignment = taCenter
          Title.Caption = 'Heure'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'joueur 1'
          Title.Alignment = taCenter
          Title.Caption = 'Joueur 1'
          Width = 205
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'joueur 2'
          Title.Alignment = taCenter
          Title.Caption = 'Joueur 2'
          Width = 205
          Visible = True
        end>
    end
  end
  object searchSource: TDataSource
    AutoEdit = False
    Left = 288
    Top = 113
  end
end
