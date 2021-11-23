object dataGridW: TdataGridW
  Left = 0
  Top = 0
  Caption = 'dataGridW'
  ClientHeight = 370
  ClientWidth = 653
  Color = 16744703
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 653
    Height = 370
    Align = alClient
    BorderWidth = 5
    TabOrder = 0
    object Panel2: TPanel
      Left = 6
      Top = 6
      Width = 641
      Height = 358
      Align = alClient
      Color = 14531583
      ParentBackground = False
      TabOrder = 0
      object Panel4: TPanel
        Left = 1
        Top = 27
        Width = 639
        Height = 289
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 2
        TabOrder = 0
        object PageControl1: TPageControl
          Left = 2
          Top = 2
          Width = 635
          Height = 285
          ActivePage = gridSheet
          Align = alClient
          TabOrder = 0
          object gridSheet: TTabSheet
            Caption = 'gridSheet'
            object grid: TDBGrid
              Left = 0
              Top = 0
              Width = 627
              Height = 257
              Align = alClient
              DataSource = source
              TabOrder = 0
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'Tahoma'
              TitleFont.Style = []
            end
          end
        end
      end
      object Panel5: TPanel
        Left = 1
        Top = 316
        Width = 639
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          639
          41)
        object ok: TBitBtn
          Left = 220
          Top = 8
          Width = 95
          Height = 25
          Caption = 'OK'
          Glyph.Data = {
            DE010000424DDE01000000000000760000002800000024000000120000000100
            0400000000006801000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            3333333333333333333333330000333333333333333333333333F33333333333
            00003333344333333333333333388F3333333333000033334224333333333333
            338338F3333333330000333422224333333333333833338F3333333300003342
            222224333333333383333338F3333333000034222A22224333333338F338F333
            8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
            33333338F83338F338F33333000033A33333A222433333338333338F338F3333
            0000333333333A222433333333333338F338F33300003333333333A222433333
            333333338F338F33000033333333333A222433333333333338F338F300003333
            33333333A222433333333333338F338F00003333333333333A22433333333333
            3338F38F000033333333333333A223333333333333338F830000333333333333
            333A333333333333333338330000333333333333333333333333333333333333
            0000}
          ModalResult = 1
          NumGlyphs = 2
          TabOrder = 0
        end
        object cancel: TBitBtn
          Left = 321
          Top = 8
          Width = 97
          Height = 25
          Anchors = [akLeft, akTop, akRight, akBottom]
          Kind = bkCancel
          NumGlyphs = 2
          TabOrder = 1
        end
      end
      object Panel3: TPanel
        Left = 1
        Top = 1
        Width = 639
        Height = 26
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object Panel9: TPanel
          Left = 0
          Top = 0
          Width = 305
          Height = 26
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel9'
          TabOrder = 0
          object nav: TDBNavigator
            Left = 0
            Top = 0
            Width = 305
            Height = 26
            DataSource = source
            Align = alClient
            TabOrder = 0
          end
        end
      end
    end
  end
  object source: TDataSource
    DataSet = data
    Left = 264
    Top = 184
  end
  object data: TZQuery
    Params = <>
    Left = 320
    Top = 176
  end
end
