object tabloW: TtabloW
  Left = 0
  Top = 0
  Caption = 'Tableau'
  ClientHeight = 593
  ClientWidth = 860
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 860
    Height = 593
    Align = alClient
    BorderWidth = 3
    TabOrder = 0
    object Panel3: TPanel
      Left = 4
      Top = 4
      Width = 389
      Height = 585
      Align = alClient
      TabOrder = 0
      object tabloGrid: TDBGrid
        Left = 1
        Top = 53
        Width = 387
        Height = 531
        Align = alClient
        DataSource = tabloSource
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect, dgTitleClick, dgTitleHotTrack]
        PopupMenu = PopupMenu1
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnCellClick = tabloGridCellClick
        OnDrawColumnCell = tabloGridDrawColumnCell
        OnKeyPress = tabloGridKeyPress
        OnTitleClick = tabloGridTitleClick
      end
      object tableauLabel: TStaticText
        Left = 1
        Top = 1
        Width = 126
        Height = 27
        Align = alTop
        Alignment = taCenter
        Caption = 'tableauLabel'
        Color = 8404992
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        Transparent = False
      end
      object DBNavigator1: TDBNavigator
        Left = 1
        Top = 28
        Width = 387
        Height = 25
        DataSource = tabloSource
        Align = alTop
        TabOrder = 2
      end
    end
    object Panel2: TPanel
      Left = 393
      Top = 4
      Width = 463
      Height = 585
      Align = alRight
      TabOrder = 1
      object sourcePanel: TPanel
        Left = 1
        Top = 1
        Width = 370
        Height = 583
        Align = alClient
        TabOrder = 0
        object Splitter1: TSplitter
          Left = 1
          Top = 138
          Width = 368
          Height = 3
          Cursor = crVSplit
          Align = alTop
          ExplicitTop = 225
          ExplicitWidth = 357
        end
        object Panel4: TPanel
          Left = 1
          Top = 1
          Width = 368
          Height = 137
          Align = alTop
          TabOrder = 0
          object StaticText1: TStaticText
            Left = 1
            Top = 1
            Width = 106
            Height = 27
            Align = alTop
            Alignment = taCenter
            Caption = 'non plac'#233's'
            Color = 8404992
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -19
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            TabOrder = 0
            Transparent = False
          end
          object joueursNav: TDBNavigator
            Left = 1
            Top = 28
            Width = 366
            Height = 18
            DataSource = joueursSource
            Align = alTop
            TabOrder = 1
          end
          object joueursGrid: TDBGrid
            Left = 1
            Top = 46
            Width = 366
            Height = 90
            Align = alClient
            DataSource = joueursSource
            Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect, dgTitleClick, dgTitleHotTrack]
            TabOrder = 2
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnCellClick = tabloGridCellClick
          end
        end
        object Panel5: TPanel
          Left = 1
          Top = 141
          Width = 368
          Height = 441
          Align = alClient
          TabOrder = 1
          object StaticText2: TStaticText
            Left = 1
            Top = 1
            Width = 91
            Height = 27
            Align = alTop
            Alignment = taCenter
            Caption = 'par clubs'
            Color = 8404992
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -19
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            TabOrder = 0
            Transparent = False
          end
          object DBNavigator2: TDBNavigator
            Left = 1
            Top = 28
            Width = 366
            Height = 18
            DataSource = clubsSource
            Align = alTop
            TabOrder = 1
          end
          object clubsGrid: TDBGrid
            Left = 1
            Top = 46
            Width = 366
            Height = 394
            Align = alClient
            DataSource = clubsSource
            Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect, dgTitleClick, dgTitleHotTrack]
            TabOrder = 2
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnCellClick = tabloGridCellClick
            Columns = <
              item
                Expanded = False
                FieldName = 'joueurs'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'libclb'
                Title.Caption = 'club'
                Width = 178
                Visible = True
              end>
          end
        end
      end
      object swapPanel: TPanel
        Left = 371
        Top = 1
        Width = 91
        Height = 583
        Align = alRight
        TabOrder = 1
        object Label1: TLabel
          Left = 8
          Top = 314
          Width = 34
          Height = 13
          Caption = 'Police :'
        end
        object swap1: TEdit
          Left = 6
          Top = 28
          Width = 75
          Height = 21
          NumbersOnly = True
          TabOrder = 0
        end
        object swap2: TEdit
          Left = 5
          Top = 55
          Width = 75
          Height = 21
          NumbersOnly = True
          TabOrder = 1
        end
        object excelButton: TButton
          Left = 6
          Top = 264
          Width = 75
          Height = 25
          Caption = 'excel'
          TabOrder = 2
          OnClick = excelButtonClick
        end
        object Button1: TButton
          Left = 6
          Top = 82
          Width = 75
          Height = 25
          Action = swapAction
          TabOrder = 3
        end
        object fontSizeBox: TComboBox
          Left = 6
          Top = 330
          Width = 74
          Height = 21
          TabOrder = 4
          Text = 'fontSizeBox'
          OnChange = fontSizeBoxChange
          Items.Strings = (
            '6'
            '8'
            '10'
            '12'
            '14')
        end
      end
    end
  end
  object tabloSource: TDataSource
    AutoEdit = False
    Left = 228
    Top = 204
  end
  object ActionList1: TActionList
    Left = 232
    Top = 296
    object swapAction: TAction
      Caption = 'Intervertir'
      ShortCut = 16467
      OnExecute = swapActionExecute
    end
    object placeAction: TAction
      Caption = 'Placer'
      ShortCut = 16464
      OnExecute = placeActionExecute
    end
  end
  object joueursSource: TDataSource
    AutoEdit = False
    Left = 593
    Top = 141
  end
  object clubsSource: TDataSource
    AutoEdit = False
    Left = 568
    Top = 328
  end
  object PopupMenu1: TPopupMenu
    Left = 220
    Top = 412
    object Intervertir1: TMenuItem
      Action = swapAction
    end
    object Placer1: TMenuItem
      Action = placeAction
    end
  end
end
