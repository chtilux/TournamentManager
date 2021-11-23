inherited matchesW: TmatchesW
  Caption = 'matchesW'
  OnShow = FormShow
  ExplicitWidth = 795
  ExplicitHeight = 613
  PixelsPerInch = 96
  TextHeight = 13
  inherited topPanel: TPanel
    Height = 58
    ExplicitHeight = 58
    object organisateur: TStaticText
      Left = 1
      Top = 1
      Width = 777
      Height = 23
      Align = alTop
      Caption = 'organisateur'
      Color = 10485760
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      Transparent = False
    end
    object handicap: TStaticText
      Left = 1
      Top = 24
      Width = 777
      Height = 27
      Align = alTop
      Caption = 'organisateur'
      Color = 16733525
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 1
      Transparent = False
    end
  end
  inherited midpanel: TPanel
    Top = 58
    Height = 482
    Color = clGray
    ParentBackground = False
    ExplicitTop = 58
    ExplicitHeight = 482
    object Panel1: TPanel
      Left = 749
      Top = 4
      Width = 26
      Height = 474
      Align = alRight
      ParentBackground = False
      ParentColor = True
      TabOrder = 0
      object Panel3: TPanel
        Left = 1
        Top = 1
        Width = 24
        Height = 32
        Align = alTop
        TabOrder = 0
        ExplicitWidth = 29
      end
      object Panel4: TPanel
        Left = 1
        Top = 33
        Width = 24
        Height = 440
        Align = alClient
        TabOrder = 1
        ExplicitLeft = 16
        ExplicitTop = 288
        ExplicitWidth = 185
        ExplicitHeight = 41
        object vsb: TScrollBar
          Left = 1
          Top = 1
          Width = 22
          Height = 438
          Align = alClient
          Kind = sbVertical
          PageSize = 0
          TabOrder = 0
          ExplicitWidth = 27
        end
      end
    end
    object Panel2: TPanel
      Left = 4
      Top = 4
      Width = 745
      Height = 474
      Align = alClient
      ParentColor = True
      TabOrder = 1
      ExplicitWidth = 740
      object Panel5: TPanel
        Left = 1
        Top = 1
        Width = 743
        Height = 26
        Align = alTop
        TabOrder = 0
        object hsb: TScrollBar
          Left = 1
          Top = 1
          Width = 741
          Height = 24
          Align = alClient
          PageSize = 0
          TabOrder = 0
          ExplicitLeft = 400
          ExplicitTop = 8
          ExplicitWidth = 121
          ExplicitHeight = 17
        end
      end
      object workspacePanel: TPanel
        Left = 1
        Top = 27
        Width = 743
        Height = 446
        Align = alClient
        TabOrder = 1
        OnResize = workspacePanelResize
        ExplicitLeft = 152
        ExplicitTop = 192
        ExplicitWidth = 185
        ExplicitHeight = 41
      end
    end
  end
  inherited bottomPanel: TPanel
    Top = 540
    Height = 35
    ExplicitTop = 540
    ExplicitHeight = 35
  end
end
