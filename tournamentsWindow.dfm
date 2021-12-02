inherited tournamentsW: TtournamentsW
  Caption = 'Tournois'
  ClientWidth = 1016
  ExplicitWidth = 1032
  PixelsPerInch = 96
  TextHeight = 13
  inherited OKBtn: TButton
    Left = 930
    ExplicitLeft = 930
  end
  inherited CancelBtn: TButton
    Left = 930
    ExplicitLeft = 930
  end
  inherited Panel1: TPanel
    Width = 916
    ExplicitWidth = 916
    inherited DBNavigator1: TDBNavigator
      Width = 910
      Hints.Strings = ()
      TabOrder = 1
      ExplicitWidth = 910
    end
    inherited DBGrid1: TDBGrid
      Width = 910
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ReadOnly = True
      TabOrder = 0
      OnDrawColumnCell = DBGrid1DrawColumnCell
      OnDblClick = DBGrid1DblClick
      OnMouseMove = DBGrid1MouseMove
    end
  end
  inherited SB: TStatusBar
    Width = 1016
    ExplicitWidth = 1016
  end
  inherited dataSource: TDataSource
    AutoEdit = False
  end
end
