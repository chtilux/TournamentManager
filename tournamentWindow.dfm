inherited tournamentW: TtournamentW
  Caption = 'Tournoi'
  ClientHeight = 688
  ClientWidth = 1060
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 1076
  ExplicitHeight = 727
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter3: TSplitter [0]
    Left = 0
    Top = 630
    Width = 1060
    Height = 0
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 505
    ExplicitWidth = 1017
  end
  inherited topPanel: TPanel
    Width = 1060
    Height = 97
    ExplicitWidth = 1060
    ExplicitHeight = 97
    object Label1: TLabel
      Left = 16
      Top = 12
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = 's'#233'rial :'
      FocusControl = sertrn
    end
    object Label2: TLabel
      Left = 11
      Top = 39
      Width = 37
      Height = 13
      Alignment = taRightJustify
      Caption = 'saison :'
      FocusControl = saison
    end
    object Label3: TLabel
      Left = 155
      Top = 12
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = 'date :'
      FocusControl = dattrn
    end
    object Label4: TLabel
      Left = 292
      Top = 12
      Width = 68
      Height = 13
      Alignment = taRightJustify
      Caption = 'organisateur :'
      FocusControl = organisateur
    end
    object Label5: TLabel
      Left = 327
      Top = 39
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Caption = 'libell'#233' :'
      FocusControl = libelle
    end
    object Label6: TLabel
      Left = 685
      Top = 12
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = 'max. cat. :'
      FocusControl = maxcat
    end
    object Label11: TLabel
      Left = 820
      Top = 12
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Caption = 'top.class. :'
      FocusControl = codcls
    end
    object joueurs: TDBText
      Left = 630
      Top = 67
      Width = 61
      Height = 19
      AutoSize = True
      DataField = 'inscriptions'
      DataSource = tournamentSource
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label15: TLabel
      Left = 542
      Top = 12
      Width = 45
      Height = 13
      Alignment = taRightJustify
      Caption = 'exp.dir. :'
      FocusControl = expcol
    end
    object Label16: TLabel
      Left = 818
      Top = 39
      Width = 56
      Height = 13
      Alignment = taRightJustify
      Caption = 'nbr.tables :'
      FocusControl = numtbl
    end
    object Label17: TLabel
      Left = 808
      Top = 66
      Width = 66
      Height = 13
      Alignment = taRightJustify
      Caption = 'Premier tour :'
      FocusControl = firstRoundModeTournoi
    end
    object sertrn: TDBEdit
      Left = 54
      Top = 9
      Width = 67
      Height = 21
      DataField = 'sertrn'
      DataSource = tournamentSource
      TabOrder = 0
    end
    object saison: TDBEdit
      Left = 54
      Top = 36
      Width = 67
      Height = 21
      DataField = 'saison'
      DataSource = tournamentSource
      PopupMenu = SeekConfigureMenu
      TabOrder = 1
      OnEnter = saisonEnter
      OnKeyDown = saisonKeyDown
    end
    object dattrn: TDBEdit
      Left = 190
      Top = 9
      Width = 67
      Height = 21
      DataField = 'dattrn'
      DataSource = tournamentSource
      TabOrder = 3
    end
    object organisateur: TDBEdit
      Left = 403
      Top = 9
      Width = 133
      Height = 21
      DataField = 'organisateur'
      DataSource = tournamentSource
      TabOrder = 4
    end
    object libelle: TDBEdit
      Left = 366
      Top = 36
      Width = 445
      Height = 21
      DataField = 'libelle'
      DataSource = tournamentSource
      TabOrder = 8
    end
    object maxcat: TDBEdit
      Left = 744
      Top = 9
      Width = 67
      Height = 21
      DataField = 'maxcat'
      DataSource = tournamentSource
      TabOrder = 6
    end
    object tournamentNav: TDBNavigator
      Left = 366
      Top = 63
      Width = 224
      Height = 25
      DataSource = tournamentSource
      VisibleButtons = [nbEdit, nbPost, nbCancel, nbRefresh]
      TabOrder = 11
      OnClick = tournamentNavClick
    end
    object importButton: TButton
      Left = 54
      Top = 63
      Width = 65
      Height = 25
      Action = importAction
      TabOrder = 12
    end
    object codcls: TDBEdit
      Left = 880
      Top = 9
      Width = 67
      Height = 21
      DataField = 'codcls'
      DataSource = tournamentSource
      TabOrder = 7
    end
    object saisieButton: TBitBtn
      Left = 126
      Top = 63
      Width = 65
      Height = 25
      Action = ziedelenAction
      Caption = '&Ziedelen...'
      NumGlyphs = 2
      TabOrder = 13
    end
    object BitBtn1: TBitBtn
      Left = 198
      Top = 63
      Width = 65
      Height = 25
      Action = umpiresAction
      Caption = 'Arbitres...'
      TabOrder = 14
    end
    object BitBtn2: TBitBtn
      Left = 270
      Top = 63
      Width = 65
      Height = 25
      Action = inscAction
      Caption = 'Insc...'
      NumGlyphs = 2
      TabOrder = 15
    end
    object expcol: TDBEdit
      Left = 593
      Top = 9
      Width = 72
      Height = 21
      DataField = 'expcol'
      DataSource = tournamentSource
      TabOrder = 5
    end
    object BitBtn3: TBitBtn
      Left = 953
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Facturation'
      TabOrder = 16
      OnClick = BitBtn3Click
    end
    object numtbl: TDBEdit
      Left = 880
      Top = 36
      Width = 67
      Height = 21
      DataField = 'numtbl'
      DataSource = tournamentSource
      TabOrder = 9
    end
    object BitBtn4: TBitBtn
      Left = 953
      Top = 34
      Width = 75
      Height = 25
      Caption = '&Arena15'
      TabOrder = 17
      OnClick = BitBtn4Click
    end
    object codclb: TDBEdit
      Left = 366
      Top = 9
      Width = 38
      Height = 21
      CharCase = ecUpperCase
      DataField = 'codclb'
      DataSource = tournamentSource
      PopupMenu = SeekConfigureMenu
      TabOrder = 2
      OnEnter = codclbEnter
      OnKeyDown = codclbKeyDown
      OnKeyPress = codclbKeyPress
    end
    object firstRoundModeTournoi: TDBEdit
      Left = 880
      Top = 63
      Width = 67
      Height = 21
      DataField = 'first_round_mode'
      DataSource = tournamentSource
      PopupMenu = SeekConfigureMenu
      TabOrder = 10
      OnEnter = firstRoundModeTournoiEnter
      OnKeyDown = firstRoundModeTournoiKeyDown
    end
  end
  inherited midpanel: TPanel
    Top = 97
    Width = 1060
    Height = 533
    ExplicitTop = 97
    ExplicitWidth = 1060
    ExplicitHeight = 533
    object pg: TPageControl
      Left = 4
      Top = 4
      Width = 1052
      Height = 525
      ActivePage = catSheet
      Align = alClient
      TabOrder = 0
      OnChange = pgChange
      OnChanging = pgChanging
      object catSheet: TTabSheet
        Caption = 'Cat'#233'gories'
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 1044
          Height = 31
          Align = alTop
          TabOrder = 0
          object DBNavigator1: TDBNavigator
            Left = 3
            Top = 3
            Width = 216
            Height = 25
            DataSource = catSource
            VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbEdit, nbPost, nbCancel, nbRefresh]
            TabOrder = 0
          end
          object DisplayCategoryButton: TButton
            Left = 250
            Top = 3
            Width = 75
            Height = 25
            Action = DisplayTableauAction
            TabOrder = 1
          end
          object Button2: TButton
            Left = 331
            Top = 3
            Width = 119
            Height = 25
            Action = addAPlayerAction
            TabOrder = 2
          end
          object Button11: TButton
            Left = 832
            Top = 3
            Width = 75
            Height = 25
            Action = resultsAction
            TabOrder = 3
          end
          object Button12: TButton
            Left = 913
            Top = 3
            Width = 75
            Height = 25
            Action = internetAction
            TabOrder = 4
          end
          object checkDoublonsButton: TButton
            Left = 456
            Top = 3
            Width = 119
            Height = 25
            Action = checkDoublonsAction
            TabOrder = 5
          end
        end
        object Panel2: TPanel
          Left = 0
          Top = 31
          Width = 1044
          Height = 466
          Align = alClient
          BevelOuter = bvNone
          BevelWidth = 3
          Caption = 'Panel2'
          TabOrder = 1
          object Splitter5: TSplitter
            Left = 0
            Top = 326
            Width = 1044
            Height = 3
            Cursor = crVSplit
            Align = alBottom
            ExplicitLeft = -8
            ExplicitTop = 232
            ExplicitWidth = 1001
          end
          object catGrid: TDBGrid
            Left = 0
            Top = 0
            Width = 1044
            Height = 326
            Align = alClient
            Color = 14531583
            DataSource = catSource
            PopupMenu = categPopup
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnDrawColumnCell = catGridDrawColumnCell
            OnDblClick = catGridDblClick
            OnEnter = catGridEnter
            OnKeyDown = catGridKeyDown
            OnKeyPress = catGridKeyPress
            OnMouseMove = catGridMouseMove
            OnTitleClick = catGridTitleClick
          end
          object Panel3: TPanel
            Left = 0
            Top = 329
            Width = 1044
            Height = 137
            Align = alBottom
            Caption = 'Panel3'
            TabOrder = 1
            object clsGrid: TDBGrid
              Left = 1
              Top = 32
              Width = 1042
              Height = 104
              Align = alClient
              DataSource = clscatSource
              TabOrder = 0
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'Tahoma'
              TitleFont.Style = []
            end
            object Panel21: TPanel
              Left = 1
              Top = 1
              Width = 1042
              Height = 31
              Align = alTop
              TabOrder = 1
              object DBNavigator2: TDBNavigator
                Left = 3
                Top = 3
                Width = 240
                Height = 25
                DataSource = clscatSource
                TabOrder = 0
              end
              object clsCatageButton: TButton
                Left = 249
                Top = 3
                Width = 75
                Height = 25
                Caption = 'classements'
                TabOrder = 1
                OnClick = clsCatageButtonClick
              end
            end
          end
        end
      end
      object inscSheet: TTabSheet
        Caption = 'Inscriptions'
        ImageIndex = 1
        object Panel4: TPanel
          Left = 0
          Top = 0
          Width = 1044
          Height = 497
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 3
          TabOrder = 0
          object Panel5: TPanel
            Left = 3
            Top = 3
            Width = 1038
            Height = 41
            Align = alTop
            TabOrder = 0
            object Label13: TLabel
              Left = 304
              Top = 17
              Width = 58
              Height = 13
              Caption = 'Recherche :'
            end
            object DBNavigator5: TDBNavigator
              Left = 4
              Top = 14
              Width = 240
              Height = 25
              DataSource = inscSource
              TabOrder = 0
            end
            object inscSearch: TEdit
              Left = 369
              Top = 14
              Width = 121
              Height = 21
              CharCase = ecUpperCase
              TabOrder = 1
              OnChange = inscSearchChange
            end
          end
          object Panel6: TPanel
            Left = 3
            Top = 44
            Width = 1038
            Height = 450
            Align = alClient
            BorderWidth = 3
            TabOrder = 1
            object inscGrid: TDBGrid
              Left = 4
              Top = 4
              Width = 1030
              Height = 442
              Align = alClient
              DataSource = inscSource
              Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
              PopupMenu = inscGridMenu
              TabOrder = 0
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'Tahoma'
              TitleFont.Style = []
              OnDrawColumnCell = inscGridDrawColumnCell
              OnDblClick = inscGridDblClick
              OnMouseMove = inscGridMouseMove
              OnTitleClick = catGridTitleClick
            end
          end
        end
      end
      object joueursSheet: TTabSheet
        Caption = 'Joueurs'
        ImageIndex = 2
        object Panel7: TPanel
          Left = 0
          Top = 0
          Width = 1044
          Height = 41
          Align = alTop
          TabOrder = 0
          object Label14: TLabel
            Left = 312
            Top = 20
            Width = 58
            Height = 13
            Caption = 'Recherche :'
          end
          object DBNavigator4: TDBNavigator
            Left = 4
            Top = 14
            Width = 240
            Height = 25
            DataSource = joueursSource
            TabOrder = 0
          end
          object joueurSearch: TEdit
            Left = 377
            Top = 15
            Width = 121
            Height = 21
            CharCase = ecUpperCase
            TabOrder = 1
            OnChange = joueurSearchChange
          end
        end
        object Panel8: TPanel
          Left = 0
          Top = 41
          Width = 1044
          Height = 456
          Align = alClient
          BorderWidth = 3
          TabOrder = 1
          object joueursGrid: TDBGrid
            Left = 4
            Top = 4
            Width = 1036
            Height = 448
            Align = alClient
            Color = 13434879
            DataSource = joueursSource
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnDrawColumnCell = joueursGridDrawColumnCell
            OnDblClick = inscGridDblClick
            OnMouseMove = joueursGridMouseMove
            OnTitleClick = catGridTitleClick
          end
        end
      end
      object ClubsSheet: TTabSheet
        Caption = 'Clubs'
        ImageIndex = 3
        object Panel9: TPanel
          Left = 0
          Top = 0
          Width = 1044
          Height = 41
          Align = alTop
          TabOrder = 0
          object DBNavigator6: TDBNavigator
            Left = 4
            Top = 14
            Width = 240
            Height = 25
            DataSource = clubsSource
            TabOrder = 0
          end
        end
        object Panel10: TPanel
          Left = 0
          Top = 41
          Width = 1044
          Height = 456
          Align = alClient
          BorderWidth = 3
          TabOrder = 1
          object clubsGrid: TDBGrid
            Left = 4
            Top = 4
            Width = 1036
            Height = 448
            Align = alClient
            DataSource = clubsSource
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnDrawColumnCell = clubsGridDrawColumnCell
            OnMouseMove = clubsGridMouseMove
            OnTitleClick = catGridTitleClick
          end
        end
      end
      object tabSheet: TTabSheet
        Caption = 'Tableau'
        ImageIndex = 4
        object Panel11: TPanel
          Left = 0
          Top = 0
          Width = 1044
          Height = 497
          Align = alClient
          BorderWidth = 3
          TabOrder = 0
          object Splitter1: TSplitter
            Left = 179
            Top = 4
            Height = 489
            ExplicitLeft = 312
            ExplicitTop = 80
            ExplicitHeight = 100
          end
          object Panel12: TPanel
            Left = 4
            Top = 4
            Width = 175
            Height = 489
            Align = alLeft
            TabOrder = 0
            object Splitter4: TSplitter
              Left = 1
              Top = 263
              Width = 173
              Height = 3
              Cursor = crVSplit
              Align = alTop
              ExplicitTop = 224
              ExplicitWidth = 6
            end
            object Panel16: TPanel
              Left = 1
              Top = 266
              Width = 173
              Height = 222
              Align = alClient
              Caption = 'Panel16'
              TabOrder = 0
              object prpclbGrid: TDBGrid
                Left = 1
                Top = 1
                Width = 171
                Height = 220
                Align = alClient
                DataSource = prpclbSource
                TabOrder = 0
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -11
                TitleFont.Name = 'Tahoma'
                TitleFont.Style = []
                OnCellClick = prpclbGridCellClick
              end
            end
            object Panel17: TPanel
              Left = 1
              Top = 1
              Width = 173
              Height = 262
              Align = alTop
              TabOrder = 1
              object Label7: TLabel
                Left = 22
                Top = 33
                Width = 38
                Height = 13
                Caption = 'sertab :'
              end
              object sertab: TDBText
                Left = 64
                Top = 33
                Width = 48
                Height = 17
                DataField = 'sertab'
                DataSource = tabSource
              end
              object Label8: TLabel
                Left = 17
                Top = 55
                Width = 43
                Height = 13
                Caption = 'joueurs :'
              end
              object nbrjou: TDBText
                Left = 64
                Top = 55
                Width = 48
                Height = 17
                DataField = 'nbrjou'
                DataSource = tabSource
              end
              object Label9: TLabel
                Left = 1
                Top = 99
                Width = 59
                Height = 13
                Caption = 't'#234'tes.s'#233'rie :'
              end
              object nbrtds: TDBText
                Left = 64
                Top = 99
                Width = 48
                Height = 17
                DataField = 'nbrtds'
                DataSource = tabSource
              end
              object taille: TDBText
                Left = 64
                Top = 77
                Width = 48
                Height = 17
                DataField = 'taille'
                DataSource = tabSource
              end
              object Label10: TLabel
                Left = 17
                Top = 77
                Width = 43
                Height = 13
                Caption = 'tableau :'
              end
              object prpButton: TButton
                Left = 1
                Top = 2
                Width = 75
                Height = 25
                Action = PrepareAction
                TabOrder = 0
              end
              object autoDrawButton: TButton
                Left = 1
                Top = 172
                Width = 77
                Height = 25
                Action = autoDrawAction
                TabOrder = 1
              end
              object aleatoireBox: TCheckBox
                Left = 98
                Top = 176
                Width = 62
                Height = 17
                Alignment = taLeftJustify
                Caption = 'al'#233'atoire'
                TabOrder = 2
              end
              object AddAPlayerButton: TButton
                Left = 1
                Top = 115
                Width = 159
                Height = 25
                Action = addAPlayerAction
                TabOrder = 3
              end
              object Button5: TButton
                Left = 85
                Top = 2
                Width = 75
                Height = 25
                Action = ResetAction
                TabOrder = 4
              end
              object GenerateGamesButton: TButton
                Left = 85
                Top = 231
                Width = 75
                Height = 25
                Caption = 'Matchs'
                TabOrder = 5
              end
              object Button7: TButton
                Left = 1
                Top = 231
                Width = 75
                Height = 25
                Action = excelAction
                TabOrder = 6
              end
              object Button9: TButton
                Left = 98
                Top = 95
                Width = 62
                Height = 20
                Action = SeedAction
                TabOrder = 7
              end
              object ManuelDrawButton: TButton
                Left = 1
                Top = 198
                Width = 77
                Height = 25
                Action = manualDrawAction
                TabOrder = 8
              end
              object GroupsButton: TButton
                Left = 1
                Top = 146
                Width = 77
                Height = 25
                Action = SetGroupsAction
                TabOrder = 9
              end
              object Swap2PlayersButton: TButton
                Left = 83
                Top = 146
                Width = 77
                Height = 25
                Action = Swap2PlayersAction
                TabOrder = 10
                TabStop = False
              end
            end
          end
          object Panel13: TPanel
            Left = 182
            Top = 4
            Width = 858
            Height = 489
            Align = alClient
            TabOrder = 1
            object Splitter2: TSplitter
              Left = 1
              Top = 266
              Width = 856
              Height = 3
              Cursor = crVSplit
              Align = alTop
              ExplicitTop = 217
              ExplicitWidth = 153
            end
            object Panel14: TPanel
              Left = 1
              Top = 1
              Width = 856
              Height = 265
              Align = alTop
              TabOrder = 0
              object prpGrid: TDBGrid
                Left = 1
                Top = 31
                Width = 854
                Height = 233
                Align = alClient
                DataSource = prpSource
                PopupMenu = resetGridMenu
                TabOrder = 0
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -11
                TitleFont.Name = 'Tahoma'
                TitleFont.Style = []
                OnCellClick = prpGridCellClick
                OnDrawColumnCell = prpGridDrawColumnCell
                OnTitleClick = tabloGridTitleClick
              end
              object Panel18: TPanel
                Left = 1
                Top = 1
                Width = 854
                Height = 30
                Align = alTop
                TabOrder = 1
                object Panel19: TPanel
                  Left = 1
                  Top = 1
                  Width = 296
                  Height = 28
                  Align = alLeft
                  TabOrder = 0
                  object codcat: TDBText
                    Left = 1
                    Top = 1
                    Width = 104
                    Height = 26
                    Align = alLeft
                    Color = 16733525
                    DataField = 'codcat'
                    DataSource = catSource
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWhite
                    Font.Height = -19
                    Font.Name = 'Tahoma'
                    Font.Style = [fsBold]
                    ParentColor = False
                    ParentFont = False
                    Transparent = False
                  end
                  object sercat: TDBText
                    Left = 105
                    Top = 1
                    Width = 190
                    Height = 26
                    Align = alClient
                    Alignment = taCenter
                    Color = clTeal
                    DataField = 'sercat'
                    DataSource = catSource
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWhite
                    Font.Height = -19
                    Font.Name = 'Tahoma'
                    Font.Style = [fsBold]
                    ParentColor = False
                    ParentFont = False
                    Transparent = False
                    ExplicitLeft = 101
                    ExplicitTop = -3
                  end
                end
                object Panel20: TPanel
                  Left = 297
                  Top = 1
                  Width = 556
                  Height = 28
                  Align = alClient
                  TabOrder = 1
                  object DBText33: TDBText
                    Left = 1
                    Top = 1
                    Width = 184
                    Height = 26
                    Align = alLeft
                    Alignment = taCenter
                    Color = 16744576
                    DataField = 'first_round_mode'
                    DataSource = catSource
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWhite
                    Font.Height = -19
                    Font.Name = 'Tahoma'
                    Font.Style = [fsBold]
                    ParentColor = False
                    ParentFont = False
                    Transparent = False
                  end
                  object DBText34: TDBText
                    Left = 185
                    Top = 1
                    Width = 160
                    Height = 26
                    Align = alLeft
                    Alignment = taCenter
                    Color = 16744703
                    DataField = 'phase'
                    DataSource = catSource
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWhite
                    Font.Height = -19
                    Font.Name = 'Tahoma'
                    Font.Style = [fsBold]
                    ParentColor = False
                    ParentFont = False
                    Transparent = False
                  end
                  object DBNavigator7: TDBNavigator
                    Left = 345
                    Top = 1
                    Width = 210
                    Height = 26
                    Align = alClient
                    TabOrder = 0
                  end
                end
              end
            end
            object PreparationPanel: TPanel
              Left = 1
              Top = 269
              Width = 856
              Height = 219
              Align = alClient
              TabOrder = 1
              object PreparationPageControl: TPageControl
                Left = 1
                Top = 1
                Width = 854
                Height = 217
                ActivePage = GroupsSheet
                Align = alClient
                TabOrder = 0
                object GroupsSheet: TTabSheet
                  Caption = 'Groupes'
                  ImageIndex = 1
                  object groupsPanel: TPanel
                    Left = 0
                    Top = 0
                    Width = 846
                    Height = 189
                    Align = alClient
                    TabOrder = 0
                    object GroupsScrollBox: TScrollBox
                      Left = 1
                      Top = 1
                      Width = 844
                      Height = 187
                      Align = alClient
                      BevelInner = bvNone
                      BevelWidth = 3
                      TabOrder = 0
                    end
                  end
                end
                object DrawSheet: TTabSheet
                  Caption = 'Tableau'
                  object tabloGrid: TDBGrid
                    Left = 0
                    Top = 0
                    Width = 846
                    Height = 189
                    Align = alClient
                    DataSource = tabloSource
                    PopupMenu = resetGridMenu
                    TabOrder = 0
                    TitleFont.Charset = DEFAULT_CHARSET
                    TitleFont.Color = clWindowText
                    TitleFont.Height = -11
                    TitleFont.Name = 'Tahoma'
                    TitleFont.Style = []
                    OnCellClick = prpGridCellClick
                    OnDrawColumnCell = prpGridDrawColumnCell
                    OnDblClick = tabloGridDblClick
                    OnTitleClick = tabloGridTitleClick
                  end
                end
              end
            end
          end
        end
      end
      object GamesSheet: TTabSheet
        Caption = 'Matchs'
        ImageIndex = 5
        OnResize = GamesSheetResize
        object Panel22: TPanel
          Left = 0
          Top = 0
          Width = 1044
          Height = 497
          Align = alClient
          BorderWidth = 3
          TabOrder = 0
          object Panel23: TPanel
            Left = 4
            Top = 4
            Width = 1036
            Height = 41
            Align = alTop
            TabOrder = 0
            object DBText25: TDBText
              Left = 619
              Top = 1
              Width = 416
              Height = 39
              Align = alRight
              Color = 16733525
              DataField = 'codcat'
              DataSource = catSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -19
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentColor = False
              ParentFont = False
              Transparent = False
              ExplicitLeft = 576
            end
            object Label12: TLabel
              Left = 12
              Top = 13
              Width = 32
              Height = 13
              Caption = 'Level :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object DBText16: TDBText
              Left = 547
              Top = 1
              Width = 72
              Height = 39
              Align = alRight
              DataField = 'sertab'
              DataSource = tabSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -19
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ExplicitLeft = 504
            end
            object SpeedButton1: TSpeedButton
              Left = 12
              Top = 2
              Width = 20
              Height = 13
              OnClick = SpeedButton1Click
            end
            object levelBox: TComboBox
              Left = 50
              Top = 10
              Width = 61
              Height = 21
              TabOrder = 0
              OnChange = levelBoxChange
            end
            object byeButton: TBitBtn
              Left = 179
              Top = 6
              Width = 75
              Height = 25
              Caption = 'BYE'
              Default = True
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
              NumGlyphs = 2
              TabOrder = 1
              OnClick = byeButtonClick
            end
            object ouverts: TCheckBox
              Left = 118
              Top = 14
              Width = 58
              Height = 17
              Caption = 'ouverts'
              TabOrder = 2
              OnClick = ouvertsClick
            end
            object Button10: TButton
              Left = 266
              Top = 6
              Width = 75
              Height = 25
              Action = excelAction
              TabOrder = 3
            end
            object completCheck: TCheckBox
              Left = 413
              Top = 13
              Width = 65
              Height = 17
              Caption = 'complet'
              TabOrder = 4
            end
            object score: TCheckBox
              Left = 347
              Top = 13
              Width = 53
              Height = 17
              Caption = 'score'
              TabOrder = 5
            end
          end
          object Panel24: TPanel
            Left = 4
            Top = 45
            Width = 1036
            Height = 448
            Align = alClient
            TabOrder = 1
            object leftMatchPanel: TPanel
              Left = 1
              Top = 1
              Width = 300
              Height = 446
              Align = alLeft
              TabOrder = 0
              object leftMatchGrid: TDBCtrlGrid
                Left = 1
                Top = 1
                Width = 298
                Height = 444
                Align = alClient
                Color = 16762623
                DataSource = mtclv1Source
                PanelHeight = 111
                PanelWidth = 281
                ParentColor = False
                ParentShowHint = False
                PopupMenu = CtrlGridMenu
                TabOrder = 0
                RowCount = 4
                SelectedColor = clAqua
                ShowHint = True
                OnDblClick = leftMatchGridDblClick
                OnKeyPress = leftMatchGridKeyPress
                OnPaintPanel = leftMatchGridPaintPanel
                object DBText1: TDBText
                  Left = 14
                  Top = 4
                  Width = 83
                  Height = 17
                  DataField = 'nummtc'
                  DataSource = mtclv1Source
                end
                object DBText2: TDBText
                  Left = 14
                  Top = 23
                  Width = 125
                  Height = 17
                  DataField = 'nomjo1'
                  DataSource = mtclv1Source
                  OnMouseMove = DBText2MouseMove
                end
                object DBText3: TDBText
                  Left = 14
                  Top = 41
                  Width = 125
                  Height = 17
                  DataField = 'nomjo2'
                  DataSource = mtclv1Source
                  OnMouseMove = DBText3MouseMove
                end
                object DBText4: TDBText
                  Left = 208
                  Top = 4
                  Width = 65
                  Height = 17
                  Alignment = taRightJustify
                  Anchors = [akTop, akRight]
                  DataField = 'prochain'
                  DataSource = mtclv1Source
                end
                object DBText13: TDBText
                  Left = 141
                  Top = 23
                  Width = 29
                  Height = 17
                  Alignment = taCenter
                  DataField = 'codcl1'
                  DataSource = mtclv1Source
                end
                object DBText14: TDBText
                  Left = 141
                  Top = 41
                  Width = 29
                  Height = 17
                  Alignment = taCenter
                  DataField = 'codcl2'
                  DataSource = mtclv1Source
                end
                object DBText5: TDBText
                  Left = 176
                  Top = 30
                  Width = 45
                  Height = 17
                  Alignment = taCenter
                  DataField = 'score'
                  DataSource = mtclv1Source
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -16
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  ParentFont = False
                end
                object DBText23: TDBText
                  Left = 227
                  Top = 34
                  Width = 139
                  Height = 17
                  DataField = 'games'
                  DataSource = mtclv1Source
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  ParentFont = False
                end
                object DBText27: TDBText
                  Left = 103
                  Top = 4
                  Width = 48
                  Height = 17
                  Alignment = taCenter
                  DataField = 'modifie'
                  DataSource = mtclv1Source
                end
                object DBText30: TDBText
                  Left = 157
                  Top = 4
                  Width = 50
                  Height = 17
                  Alignment = taRightJustify
                  DataField = 'numtbl'
                  DataSource = mtclv1Source
                end
              end
            end
            object midMatchPanel: TPanel
              Left = 301
              Top = 1
              Width = 300
              Height = 446
              Align = alLeft
              TabOrder = 1
              object midMatchGrid: TDBCtrlGrid
                Left = 1
                Top = 1
                Width = 298
                Height = 444
                Align = alClient
                DataSource = mtclv2Source
                PanelHeight = 111
                PanelWidth = 281
                PopupMenu = CtrlGridMenu
                TabOrder = 0
                RowCount = 4
                SelectedColor = clAqua
                OnClick = leftMatchGridDblClick
                OnKeyPress = leftMatchGridKeyPress
                OnPaintPanel = leftMatchGridPaintPanel
                object DBText7: TDBText
                  Left = 11
                  Top = 4
                  Width = 86
                  Height = 17
                  DataField = 'nummtc'
                  DataSource = mtclv2Source
                end
                object DBText8: TDBText
                  Left = 11
                  Top = 23
                  Width = 125
                  Height = 17
                  DataField = 'nomjo1'
                  DataSource = mtclv2Source
                  OnMouseMove = DBText2MouseMove
                end
                object DBText9: TDBText
                  Left = 11
                  Top = 41
                  Width = 125
                  Height = 17
                  DataField = 'nomjo2'
                  DataSource = mtclv2Source
                  OnMouseMove = DBText3MouseMove
                end
                object DBText10: TDBText
                  Left = 205
                  Top = 4
                  Width = 65
                  Height = 17
                  Alignment = taRightJustify
                  Anchors = [akTop, akRight]
                  DataField = 'prochain'
                  DataSource = mtclv2Source
                end
                object DBText11: TDBText
                  Left = 141
                  Top = 23
                  Width = 42
                  Height = 17
                  DataField = 'codcl1'
                  DataSource = mtclv2Source
                end
                object DBText12: TDBText
                  Left = 141
                  Top = 41
                  Width = 42
                  Height = 17
                  DataField = 'codcl2'
                  DataSource = mtclv2Source
                end
                object DBText6: TDBText
                  Left = 189
                  Top = 30
                  Width = 45
                  Height = 18
                  Alignment = taCenter
                  DataField = 'score'
                  DataSource = mtclv2Source
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -16
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  ParentFont = False
                end
                object DBText28: TDBText
                  Left = 103
                  Top = 4
                  Width = 48
                  Height = 17
                  Alignment = taCenter
                  DataField = 'modifie'
                  DataSource = mtclv2Source
                end
                object DBText24: TDBText
                  Left = 240
                  Top = 34
                  Width = 139
                  Height = 17
                  DataField = 'games'
                  DataSource = mtclv2Source
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  ParentFont = False
                end
                object DBText31: TDBText
                  Left = 157
                  Top = 4
                  Width = 50
                  Height = 17
                  Alignment = taRightJustify
                  DataField = 'numtbl'
                  DataSource = mtclv2Source
                end
              end
            end
            object rightMatchPanel: TPanel
              Left = 601
              Top = 1
              Width = 434
              Height = 446
              Align = alClient
              TabOrder = 2
              object rightMatchGrid: TDBCtrlGrid
                Left = 1
                Top = 1
                Width = 432
                Height = 444
                Align = alClient
                DataSource = mtclv3Source
                PanelHeight = 111
                PanelWidth = 415
                PopupMenu = CtrlGridMenu
                TabOrder = 0
                RowCount = 4
                SelectedColor = clAqua
                OnDblClick = leftMatchGridDblClick
                OnKeyPress = leftMatchGridKeyPress
                OnPaintPanel = leftMatchGridPaintPanel
                object DBText17: TDBText
                  Left = 11
                  Top = 4
                  Width = 86
                  Height = 17
                  DataField = 'nummtc'
                  DataSource = mtclv3Source
                end
                object DBText18: TDBText
                  Left = 11
                  Top = 23
                  Width = 125
                  Height = 17
                  DataField = 'nomjo1'
                  DataSource = mtclv3Source
                  OnMouseMove = DBText2MouseMove
                end
                object DBText19: TDBText
                  Left = 11
                  Top = 41
                  Width = 125
                  Height = 17
                  DataField = 'nomjo2'
                  DataSource = mtclv3Source
                  OnMouseMove = DBText3MouseMove
                end
                object DBText20: TDBText
                  Left = 267
                  Top = 4
                  Width = 62
                  Height = 17
                  Alignment = taRightJustify
                  Anchors = [akTop, akRight]
                  DataField = 'prochain'
                  DataSource = mtclv3Source
                  ExplicitLeft = 224
                end
                object DBText21: TDBText
                  Left = 141
                  Top = 23
                  Width = 42
                  Height = 17
                  DataField = 'codcl1'
                  DataSource = mtclv3Source
                end
                object DBText22: TDBText
                  Left = 141
                  Top = 41
                  Width = 42
                  Height = 17
                  DataField = 'codcl2'
                  DataSource = mtclv3Source
                end
                object DBText15: TDBText
                  Left = 195
                  Top = 30
                  Width = 45
                  Height = 17
                  Alignment = taCenter
                  DataField = 'score'
                  DataSource = mtclv3Source
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -16
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  ParentFont = False
                end
                object DBText29: TDBText
                  Left = 103
                  Top = 3
                  Width = 48
                  Height = 17
                  DataField = 'modifie'
                  DataSource = mtclv3Source
                end
                object DBText26: TDBText
                  Left = 247
                  Top = 35
                  Width = 139
                  Height = 17
                  DataField = 'games'
                  DataSource = mtclv3Source
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  ParentFont = False
                end
                object DBText32: TDBText
                  Left = 157
                  Top = 3
                  Width = 50
                  Height = 17
                  Alignment = taRightJustify
                  DataField = 'numtbl'
                  DataSource = mtclv3Source
                end
              end
            end
          end
        end
      end
    end
  end
  inherited bottomPanel: TPanel
    Top = 630
    Width = 1060
    Height = 58
    ExplicitTop = 630
    ExplicitWidth = 1060
    ExplicitHeight = 58
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 1058
      Height = 56
      Align = alClient
      Lines.Strings = (
        'Memo1')
      ScrollBars = ssBoth
      TabOrder = 0
      WantReturns = False
      WordWrap = False
      OnDblClick = Memo1DblClick
    end
  end
  object tournamentSource: TDataSource
    AutoEdit = False
    OnDataChange = tournamentSourceDataChange
    Left = 178
    Top = 240
  end
  object catSource: TDataSource
    OnDataChange = catSourceDataChange
    Left = 250
    Top = 240
  end
  object clscatSource: TDataSource
    Left = 652
    Top = 240
  end
  object inscSource: TDataSource
    Left = 317
    Top = 240
  end
  object joueursSource: TDataSource
    Left = 719
    Top = 240
  end
  object clubsSource: TDataSource
    Left = 853
    Top = 240
  end
  object ActionsList: TActionList
    OnUpdate = ActionsListUpdate
    Left = 744
    Top = 188
    object PrepareAction: TAction
      Caption = 'Pr'#233'parer'
      OnExecute = PrepareActionExecute
    end
    object autoDrawAction: TAction
      Category = 'KOMode'
      Caption = 'auto Draw'
      OnExecute = autoDrawActionExecute
    end
    object addAPlayerAction: TAction
      Caption = 'Ajouter un joueur...'
      OnExecute = addAPlayerActionExecute
    end
    object ResetAction: TAction
      Caption = 'Reset Tableau'
      OnExecute = ResetActionExecute
    end
    object GenerateDrawGamesAction: TAction
      Category = 'KOMode'
      Caption = 'Matchs'
      OnExecute = GenerateDrawGamesActionExecute
    end
    object GenerateGroupGamesAction: TAction
      Category = 'QualificationMode'
      Caption = 'Matchs'
      OnExecute = GenerateGroupGamesActionExecute
    end
    object excelAction: TAction
      Caption = 'tab.excel'
      OnExecute = excelActionExecute
    end
    object orderByAction: TAction
      Caption = 'Reset order by'
      OnExecute = orderByActionExecute
    end
    object checkMatchesAction: TAction
      Caption = 'Check matchs'
      OnExecute = checkMatchesActionExecute
    end
    object umpiresAction: TAction
      Caption = 'Arbitres...'
      OnExecute = umpiresActionExecute
    end
    object ziedelenAction: TAction
      Caption = 'Ziedelen...'
      OnExecute = ziedelenActionExecute
    end
    object importAction: TAction
      Caption = 'Importer...'
      OnExecute = importActionExecute
    end
    object SeedAction: TAction
      Caption = 'TDS...'
      OnExecute = SeedActionExecute
    end
    object eliminateAction: TAction
      Caption = 'Eliminer du tableau'
      OnExecute = eliminateActionExecute
    end
    object inscAction: TAction
      Caption = 'Insc...'
      OnExecute = inscActionExecute
    end
    object editMatchAction: TAction
      Caption = 'Editer...'
      OnExecute = editMatchActionExecute
    end
    object resultsAction: TAction
      Caption = 'R'#233'sultats'
      OnExecute = resultsActionExecute
    end
    object internetAction: TAction
      Caption = 'Internet...'
      OnExecute = internetActionExecute
    end
    object checkDoublonsAction: TAction
      Caption = 'Contr'#244'ler les doublons'
      OnExecute = checkDoublonsActionExecute
    end
    object arenaAction: TAction
      Caption = '&Arena'
    end
    object manualDrawAction: TAction
      Category = 'KOMode'
      Caption = 'manual'
      OnExecute = manualDrawActionExecute
    end
    object SetCategStatutAction: TAction
      Caption = 'Modifier le statut...'
      OnExecute = SetCategStatutActionExecute
    end
    object SeekConfigAction: TAction
      Category = 'Seek'
      Caption = 'Seek config...'
      OnExecute = SeekConfigActionExecute
    end
    object SelectSeekCodClbAction: TAction
      Category = 'Seek'
      Caption = 'Select Seek...'
      OnExecute = SelectSeekCodClbActionExecute
    end
    object SelectSeekSaisonAction: TAction
      Category = 'Seek'
      Caption = 'Select Seek...'
      OnExecute = SelectSeekSaisonActionExecute
    end
    object SelectSeekCategAction: TAction
      Category = 'Seek'
      Caption = 'Select Seek...'
      OnExecute = SelectSeekCategActionExecute
    end
    object SelectFirstRoundModeAction: TAction
      Category = 'Seek'
      Caption = 'Mode premier tour'
      OnExecute = SelectFirstRoundModeActionExecute
    end
    object SetGroupsAction: TAction
      Category = 'QualificationMode'
      Caption = 'Set Groups...'
      OnExecute = SetGroupsActionExecute
    end
    object SetPhaseAction: TAction
      Caption = 'Modifier la phase'
      OnExecute = SetPhaseActionExecute
    end
    object DisplayTableauAction: TAction
      Caption = 'Tableau'
      OnExecute = DisplayTableauActionExecute
    end
    object SetFirstRoundModeAction: TAction
      Caption = 'Modifier le mode 1er tour'
      OnExecute = SetFirstRoundModeActionExecute
    end
    object Swap2PlayersAction: TAction
      Category = 'QualificationMode'
      Caption = 'Swap 2 players'
      OnExecute = Swap2PlayersActionExecute
    end
    object PrepareForKOPhaseAction: TAction
      Category = 'QualificationMode'
      Caption = 'Prepare for KO phase'
      OnExecute = PrepareForKOPhaseActionExecute
    end
  end
  object tabSource: TDataSource
    Left = 920
    Top = 240
  end
  object prpSource: TDataSource
    Left = 451
    Top = 240
  end
  object prpclbSource: TDataSource
    Left = 988
    Top = 240
  end
  object tabloSource: TDataSource
    Left = 786
    Top = 240
  end
  object resetGridMenu: TPopupMenu
    Left = 903
    Top = 188
    object Resetorderby1: TMenuItem
      Action = orderByAction
    end
  end
  object mtclv1Source: TDataSource
    AutoEdit = False
    Left = 384
    Top = 240
  end
  object mtclv2Source: TDataSource
    AutoEdit = False
    Left = 518
    Top = 240
  end
  object mtclv3Source: TDataSource
    AutoEdit = False
    Left = 585
    Top = 240
  end
  object inscGridMenu: TPopupMenu
    Left = 987
    Top = 188
    object disqualifyMenu: TMenuItem
      Action = eliminateAction
      Caption = 'Disqualifier du tableau'
    end
    object requalifyMenu: TMenuItem
      Caption = 'Requalifier dans le tableau'
      OnClick = requalifyMenuClick
    end
  end
  object CtrlGridMenu: TPopupMenu
    Left = 581
    Top = 188
    object Editer1: TMenuItem
      Action = editMatchAction
    end
  end
  object categPopup: TPopupMenu
    Left = 824
    Top = 188
    object SetCategStatusMenu: TMenuItem
      Caption = 'Modifier le statut...'
      OnClick = SetCategStatutActionExecute
    end
    object Modifierlestatut1: TMenuItem
      Action = SelectSeekCategAction
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Modifierlemode1ertour1: TMenuItem
      Action = SetFirstRoundModeAction
    end
    object Modifierlaphase1: TMenuItem
      Action = SetPhaseAction
    end
    object PrepareforKOphaseMenu: TMenuItem
      Action = PrepareForKOPhaseAction
    end
  end
  object SeekConfigureMenu: TPopupMenu
    Left = 664
    Top = 188
    object SeekconfigMenu: TMenuItem
      Action = SeekConfigAction
    end
    object SelectSeekMenu: TMenuItem
      Caption = 'Select Seek...'
    end
  end
end
