object mainW: TmainW
  Left = 0
  Top = 0
  Caption = 'Tournament Manager'
  ClientHeight = 575
  ClientWidth = 1078
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = False
  Visible = True
  WindowState = wsMaximized
  WindowMenu = Window1
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sb: TStatusBar
    Left = 0
    Top = 556
    Width = 1078
    Height = 19
    Panels = <
      item
        Width = 350
      end
      item
        Width = 300
      end
      item
        Width = 300
      end
      item
        Width = 50
      end>
  end
  object MainMenu1: TMainMenu
    Left = 360
    Top = 216
    object Fichier1: TMenuItem
      Caption = 'Fichier'
      OnClick = Fichier1Click
      object newTournamentMenu: TMenuItem
        Action = newTournamentAction
      end
      object openTournamentMenu: TMenuItem
        Action = openTournamentAction
      end
      object closeTournamentMenu: TMenuItem
        Action = closeTournamentAction
      end
      object Supprimeruntournoi1: TMenuItem
        Action = deleteTournamentAction
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object databaseMenu: TMenuItem
        Caption = 'Base de donn'#233'es'
        OnClick = databaseMenuClick
        object newDatabaseMenu: TMenuItem
          Action = newDatabaseAction
        end
        object openDatabaseMenu: TMenuItem
          Action = openDatabaseAction
        end
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object settingMenu: TMenuItem
        Caption = 'Param'#232'tres'
        object saisonsMenu: TMenuItem
          Action = saisonsAction
        end
        object clubsMenu: TMenuItem
          Action = clubsAction
        end
        object classementsMenu: TMenuItem
          Action = classementsAction
        end
        object catageMenu: TMenuItem
          Action = catageAction
        end
        object handicapsMenu: TMenuItem
          Action = handicapsAction
        end
        object defaultValuesMenu: TMenuItem
          Action = defValuesAction
        end
        object SeekConfigs1: TMenuItem
          Action = SeekConfigsAction
        end
        object N4: TMenuItem
          Caption = '-'
        end
        object Dictionnaire1: TMenuItem
          Action = dictAction
        end
        object settingsMenu: TMenuItem
          Action = settingsAction
        end
        object Styledefentre1: TMenuItem
          Caption = 'Style de fen'#234'tre'
        end
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Quitter1: TMenuItem
        Caption = 'Quitter'
        ShortCut = 16465
        OnClick = Quitter1Click
      end
    end
    object editMenu: TMenuItem
      Caption = 'Edit'
    end
    object Window1: TMenuItem
      Caption = 'Fe&n'#234'tre'
      object N5: TMenuItem
        Caption = '-'
      end
      object Window2: TMenuItem
        Caption = 'Fe&n'#234'tre'
      end
    end
  end
  object ActionList1: TActionList
    OnUpdate = ActionList1Update
    Left = 448
    Top = 200
    object newTournamentAction: TAction
      Category = 'tournament'
      Caption = 'Nouveau tournoi...'
      ShortCut = 16462
      OnExecute = newTournamentActionExecute
    end
    object openTournamentAction: TAction
      Category = 'tournament'
      Caption = 'Ouvrir un tournoi...'
      ShortCut = 16463
      OnExecute = openTournamentActionExecute
    end
    object newDatabaseAction: TAction
      Category = 'database'
      Caption = 'Nouvelle base de donn'#233'es...'
      OnExecute = newDatabaseActionExecute
    end
    object openDatabaseAction: TAction
      Category = 'database'
      Caption = 'Ouvrir une base de donn'#233'es...'
      OnExecute = openDatabaseActionExecute
    end
    object settingsAction: TAction
      Category = 'settings'
      Caption = 'Param'#232'tres...'
      ShortCut = 49235
      OnExecute = settingsActionExecute
    end
    object clubsAction: TAction
      Category = 'settings'
      Caption = 'Clubs...'
      OnExecute = clubsActionExecute
    end
    object classementsAction: TAction
      Category = 'settings'
      Caption = 'Classements...'
      OnExecute = classementsActionExecute
    end
    object catageAction: TAction
      Category = 'settings'
      Caption = 'Cat'#233'gories d'#39#226'ge...'
      OnExecute = catageActionExecute
    end
    object handicapsAction: TAction
      Category = 'settings'
      Caption = 'Handicaps...'
      OnExecute = handicapsActionExecute
    end
    object closeTournamentAction: TAction
      Category = 'tournament'
      Caption = 'Fermer le tournoi'
      ShortCut = 16471
      OnExecute = closeTournamentActionExecute
    end
    object defValuesAction: TAction
      Category = 'settings'
      Caption = 'Valeurs par d'#233'faut...'
      OnExecute = defValuesActionExecute
    end
    object saisonsAction: TAction
      Category = 'settings'
      Caption = 'Saisons...'
      OnExecute = saisonsActionExecute
    end
    object deleteTournamentAction: TAction
      Category = 'tournament'
      Caption = 'Supprimer un tournoi...'
      OnExecute = deleteTournamentActionExecute
    end
    object dictAction: TAction
      Category = 'settings'
      Caption = 'Dictionnaire...'
      OnExecute = dictActionExecute
    end
    object SeekConfigsAction: TAction
      Category = 'settings'
      Caption = 'Seek Configs...'
      OnExecute = SeekConfigsActionExecute
    end
  end
end
