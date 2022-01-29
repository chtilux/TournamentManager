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
      TabOrder = 13
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
      TabOrder = 14
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
            Width = 191
            Height = 25
            Action = CreateExcelGroupFileAction
            TabOrder = 1
          end
          object Button11: TButton
            Left = 832
            Top = 3
            Width = 75
            Height = 25
            Action = resultsAction
            TabOrder = 2
          end
          object Button12: TButton
            Left = 913
            Top = 3
            Width = 75
            Height = 25
            Action = internetAction
            TabOrder = 3
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
            OnEnter = catGridEnter
            OnKeyDown = catGridKeyDown
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
    end
    object autoDrawAction: TAction
      Category = 'KOMode'
      Caption = 'auto Draw'
    end
    object addAPlayerAction: TAction
      Caption = 'Ajouter un joueur...'
    end
    object ResetAction: TAction
      Caption = 'Reset Tableau'
    end
    object GenerateDrawGamesAction: TAction
      Category = 'KOMode'
      Caption = 'Matchs'
    end
    object GenerateGroupGamesAction: TAction
      Category = 'QualificationMode'
      Caption = 'Matchs'
    end
    object excelAction: TAction
      Caption = 'tab.excel'
    end
    object orderByAction: TAction
      Caption = 'Reset order by'
    end
    object checkMatchesAction: TAction
      Caption = 'Check matchs'
    end
    object importAction: TAction
      Caption = 'Importer...'
      OnExecute = importActionExecute
    end
    object SeedAction: TAction
      Caption = 'TDS...'
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
    end
    object SetPhaseAction: TAction
      Caption = 'Modifier la phase'
      OnExecute = SetPhaseActionExecute
    end
    object DisplayTableauAction: TAction
      Caption = 'Tableau'
    end
    object SetFirstRoundModeAction: TAction
      Caption = 'Modifier le mode 1er tour'
      OnExecute = SetFirstRoundModeActionExecute
    end
    object Swap2PlayersAction: TAction
      Category = 'QualificationMode'
      Caption = 'Swap 2 players'
    end
    object PrepareForKOPhaseAction: TAction
      Category = 'QualificationMode'
      Caption = 'Prepare for KO phase'
    end
    object CreateExcelGroupFileAction: TAction
      Caption = 'Cr'#233'er le fichier excel de groupes...'
      OnExecute = CreateExcelGroupFileActionExecute
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
    object Crerlefichierexceldegroupes1: TMenuItem
      Action = CreateExcelGroupFileAction
    end
    object SetCategStatusMenu: TMenuItem
      Caption = 'Modifier le statut...'
      Visible = False
      OnClick = SetCategStatutActionExecute
    end
    object Modifierlestatut1: TMenuItem
      Action = SelectSeekCategAction
      Visible = False
    end
    object N1: TMenuItem
      Caption = '-'
      Visible = False
    end
    object Modifierlemode1ertour1: TMenuItem
      Action = SetFirstRoundModeAction
      Visible = False
    end
    object Modifierlaphase1: TMenuItem
      Action = SetPhaseAction
      Visible = False
    end
    object PrepareforKOphaseMenu: TMenuItem
      Action = PrepareForKOPhaseAction
      Visible = False
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
