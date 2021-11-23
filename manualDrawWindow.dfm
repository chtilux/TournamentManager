object manualDrawW: TmanualDrawW
  Left = 0
  Top = 0
  Caption = 'Set draw manual'
  ClientHeight = 817
  ClientWidth = 1104
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object workspacePanel: TPanel
    Left = 0
    Top = 0
    Width = 1032
    Height = 798
    Align = alClient
    Padding.Left = 3
    Padding.Top = 3
    Padding.Right = 3
    Padding.Bottom = 3
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 625
      Top = 4
      Height = 790
      ExplicitLeft = 456
      ExplicitTop = 272
      ExplicitHeight = 100
    end
    object Panel2: TPanel
      Left = 4
      Top = 4
      Width = 621
      Height = 790
      Align = alLeft
      TabOrder = 0
      object Panel4: TPanel
        Left = 1
        Top = 1
        Width = 619
        Height = 41
        Align = alTop
        TabOrder = 0
        object fontSizeEdit: TEdit
          Left = 76
          Top = 12
          Width = 61
          Height = 21
          NumbersOnly = True
          TabOrder = 0
          Text = '8'
        end
        object fontSizeUD: TUpDown
          Left = 137
          Top = 12
          Width = 17
          Height = 21
          Associate = fontSizeEdit
          Min = 6
          Max = 14
          Position = 8
          TabOrder = 1
          Thousands = False
          OnChanging = fontSizeUDChanging
        end
        object highlightCheckbox: TCheckBox
          Left = 176
          Top = 16
          Width = 97
          Height = 17
          Caption = 'Highlight'
          Checked = True
          State = cbChecked
          TabOrder = 2
          OnClick = highlightCheckboxClick
        end
      end
      object drawGrid: TDBGrid
        Left = 1
        Top = 42
        Width = 619
        Height = 747
        Align = alClient
        DataSource = drawSource
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDrawColumnCell = drawGridDrawColumnCell
        OnDragDrop = drawGridDragDrop
        OnDragOver = drawGridDragOver
      end
    end
    object Panel1: TPanel
      Left = 628
      Top = 4
      Width = 400
      Height = 790
      Align = alClient
      TabOrder = 1
      object Panel5: TPanel
        Left = 1
        Top = 1
        Width = 398
        Height = 41
        Align = alTop
        TabOrder = 0
      end
      object prpGrid: TDBGrid
        Left = 1
        Top = 42
        Width = 398
        Height = 747
        Align = alClient
        DataSource = prpSource
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnCellClick = prpGridCellClick
        OnDrawColumnCell = prpGridDrawColumnCell
        OnDragOver = prpGridDragOver
        OnMouseMove = prpGridMouseMove
      end
    end
  end
  object Panel3: TPanel
    Left = 1032
    Top = 0
    Width = 72
    Height = 798
    Align = alRight
    Color = 16762623
    ParentBackground = False
    TabOrder = 1
    object applyButton: TBitBtn
      Left = 6
      Top = 46
      Width = 59
      Height = 45
      Caption = 'Apply'
      TabOrder = 0
      OnClick = applyButtonClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 798
    Width = 1104
    Height = 19
    Panels = <
      item
        Width = 200
      end
      item
        Width = 300
      end
      item
        Width = 200
      end
      item
        Width = 200
      end>
  end
  object drawSource: TDataSource
    Left = 96
    Top = 136
  end
  object prpSource: TDataSource
    OnDataChange = prpSourceDataChange
    Left = 664
    Top = 144
  end
end
