object arena15W: Tarena15W
  Left = 0
  Top = 0
  Caption = 'arena15W'
  ClientHeight = 751
  ClientWidth = 1189
  Color = 8388672
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    1189
    751)
  PixelsPerInch = 96
  TextHeight = 13
  object workspacePanel: TPanel
    Left = 5
    Top = 5
    Width = 1179
    Height = 740
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvLowered
    Color = 16776673
    ParentBackground = False
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 1
      Top = 393
      Width = 1177
      Height = 5
      Cursor = crVSplit
      Align = alTop
      Color = 4194368
      ParentColor = False
      ExplicitWidth = 1411
    end
    object topPanel: TPanel
      Left = 1
      Top = 1
      Width = 1177
      Height = 392
      Align = alTop
      BevelOuter = bvNone
      BorderWidth = 3
      TabOrder = 0
      object Splitter5: TSplitter
        Left = 802
        Top = 3
        Height = 386
        Align = alRight
        ExplicitLeft = 745
        ExplicitTop = -6
        ExplicitHeight = 392
      end
      object detailPanel: TPanel
        Left = 805
        Top = 3
        Width = 369
        Height = 386
        Align = alRight
        BevelOuter = bvNone
        BorderWidth = 5
        Color = clGray
        DoubleBuffered = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBackground = False
        ParentDoubleBuffered = False
        ParentFont = False
        TabOrder = 0
        OnResize = detailPanelResize
        object drawBox: TPaintBox
          Left = 5
          Top = 5
          Width = 359
          Height = 376
          Align = alClient
          OnDblClick = drawBoxDblClick
          ExplicitLeft = 136
          ExplicitTop = 144
          ExplicitWidth = 105
          ExplicitHeight = 105
        end
      end
      object arenaPanel: TPanel
        Left = 3
        Top = 3
        Width = 799
        Height = 386
        Align = alClient
        BevelOuter = bvNone
        Color = clBlack
        ParentBackground = False
        TabOrder = 1
      end
    end
    object bottomPanel: TPanel
      Left = 1
      Top = 398
      Width = 1177
      Height = 341
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Splitter3: TSplitter
        Left = 500
        Top = 0
        Width = 5
        Height = 318
        Align = alRight
        Color = 8388672
        ParentColor = False
        ExplicitLeft = 736
        ExplicitHeight = 371
      end
      object inputPanel: TPanel
        Left = 505
        Top = 0
        Width = 672
        Height = 318
        Align = alRight
        BevelOuter = bvNone
        Color = clSilver
        ParentBackground = False
        TabOrder = 0
        object Label1: TLabel
          Left = 6
          Top = 217
          Width = 65
          Height = 13
          Caption = 'Filter games :'
        end
        object BitBtn1: TBitBtn
          Left = 6
          Top = 6
          Width = 70
          Height = 64
          Caption = 'Run draw'
          TabOrder = 0
          OnClick = BitBtn1Click
        end
        object BitBtn2: TBitBtn
          Left = 94
          Top = 6
          Width = 70
          Height = 64
          Action = refreshAllAction
          Caption = 'Refresh all'
          TabOrder = 1
        end
        object umpiresView: TListView
          Left = 170
          Top = 0
          Width = 502
          Height = 318
          Align = alRight
          Anchors = [akLeft, akTop, akRight, akBottom]
          Color = 33023
          Columns = <
            item
              Caption = 'Table'
            end
            item
              AutoSize = True
              Caption = 'Arbitre'
            end>
          RowSelect = True
          TabOrder = 2
          ViewStyle = vsReport
          OnClick = umpiresViewClick
          OnCustomDrawItem = umpiresViewCustomDrawItem
          OnSelectItem = umpiresViewSelectItem
        end
        object fontSizeEdit: TEdit
          Left = 6
          Top = 239
          Width = 27
          Height = 21
          NumbersOnly = True
          ReadOnly = True
          TabOrder = 3
          Text = '6'
        end
        object categGridFontSize: TUpDown
          Left = 33
          Top = 239
          Width = 16
          Height = 21
          Associate = fontSizeEdit
          Min = 6
          Max = 14
          Position = 6
          TabOrder = 4
          OnClick = categGridFontSizeClick
        end
        object BitBtn3: TBitBtn
          Left = 6
          Top = 76
          Width = 158
          Height = 25
          Action = setUmpireAction
          Caption = 'set Umpire'
          TabOrder = 5
        end
        object BitBtn4: TBitBtn
          Left = 6
          Top = 131
          Width = 158
          Height = 25
          Action = deactivatePlayArea
          Caption = 'Deactivate play area'
          TabOrder = 6
        end
        object BitBtn5: TBitBtn
          Left = 6
          Top = 156
          Width = 158
          Height = 25
          Action = activatePlayArea
          Caption = 'Activate play area'
          TabOrder = 7
        end
        object BitBtn6: TBitBtn
          Left = 6
          Top = 101
          Width = 158
          Height = 25
          Action = unsetUmpireAction
          Caption = 'Unset Umpire'
          TabOrder = 8
        end
        object BitBtn7: TBitBtn
          Left = 6
          Top = 186
          Width = 158
          Height = 25
          Action = refreshUmpiresAction
          Caption = 'Refresh'
          TabOrder = 9
        end
        object filterGamesBox: TComboBox
          Left = 77
          Top = 214
          Width = 87
          Height = 21
          Style = csDropDownList
          TabOrder = 10
          OnChange = filterGamesBoxChange
        end
        object Button1: TButton
          Left = 77
          Top = 238
          Width = 87
          Height = 25
          Action = ViewPlayerStatusAction
          TabOrder = 11
        end
      end
      object categsPanel: TPanel
        Left = 0
        Top = 0
        Width = 500
        Height = 318
        Align = alClient
        BevelOuter = bvNone
        Color = clSilver
        ParentBackground = False
        TabOrder = 1
        object scrollCategs: TScrollBox
          Left = 0
          Top = 0
          Width = 500
          Height = 318
          Align = alClient
          BevelInner = bvNone
          BevelWidth = 3
          TabOrder = 0
          OnResize = scrollCategsResize
        end
      end
      object sb: TStatusBar
        Left = 0
        Top = 318
        Width = 1177
        Height = 23
        Color = 8388672
        Panels = <
          item
            Style = psOwnerDraw
            Width = 160
          end
          item
            Style = psOwnerDraw
            Width = 160
          end
          item
            Style = psOwnerDraw
            Width = 160
          end
          item
            Style = psOwnerDraw
            Width = 50
          end
          item
            Style = psOwnerDraw
            Width = 160
          end
          item
            Style = psOwnerDraw
            Text = '---'
            Width = 300
          end>
        SizeGrip = False
        OnDrawPanel = sbDrawPanel
      end
    end
  end
  object umpiresViewActions: TActionList
    OnUpdate = umpiresViewActionsUpdate
    Left = 728
    Top = 440
    object setUmpireAction: TAction
      Category = 'umpire'
      Caption = 'set Umpire'
      OnExecute = setUmpireActionExecute
    end
    object unsetUmpireAction: TAction
      Category = 'umpire'
      Caption = 'Unset Umpire'
      OnExecute = unsetUmpireActionExecute
    end
    object activatePlayArea: TAction
      Category = 'playArea'
      Caption = 'Activate play area'
      OnExecute = activatePlayAreaExecute
    end
    object deactivatePlayArea: TAction
      Category = 'playArea'
      Caption = 'Deactivate play area'
      OnExecute = deactivatePlayAreaExecute
    end
    object refreshUmpiresAction: TAction
      Category = 'umpires'
      Caption = 'Refresh'
      OnExecute = refreshUmpiresActionExecute
    end
    object refreshAllAction: TAction
      Caption = 'Refresh all'
      ShortCut = 16466
      OnExecute = refreshAllActionExecute
    end
    object ViewPlayerStatusAction: TAction
      Caption = 'Player Status...'
      OnExecute = ViewPlayerStatusActionExecute
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 672
    Top = 440
  end
  object ZIBEventAlerter1: TZIBEventAlerter
    AutoRegister = False
    Registered = False
    OnEventAlert = ZIBEventAlerter1EventAlert
    Left = 305
    Top = 209
  end
end
