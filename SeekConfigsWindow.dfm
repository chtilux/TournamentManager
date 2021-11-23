inherited SeekConfigsW: TSeekConfigsW
  Caption = 'SeekConfigsW'
  ClientHeight = 657
  ClientWidth = 816
  ExplicitWidth = 832
  ExplicitHeight = 696
  PixelsPerInch = 96
  TextHeight = 13
  inherited OKBtn: TButton
    Left = 730
    ExplicitLeft = 730
  end
  inherited CancelBtn: TButton
    Left = 730
    ExplicitLeft = 730
  end
  inherited Panel1: TPanel
    Width = 716
    Height = 646
    ExplicitWidth = 716
    ExplicitHeight = 646
    inherited DBNavigator1: TDBNavigator
      Width = 710
      Hints.Strings = ()
      ExplicitWidth = 710
    end
    inherited DBGrid1: TDBGrid
      Width = 710
      Height = 352
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgMultiSelect, dgTitleClick, dgTitleHotTrack]
    end
    object Memo1: TMemo
      Left = 3
      Top = 386
      Width = 710
      Height = 241
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 2
    end
  end
  inherited SB: TStatusBar
    Top = 638
    Width = 816
    ExplicitTop = 638
    ExplicitWidth = 816
  end
  object ConfigureButton: TBitBtn [4]
    Left = 730
    Top = 80
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Configure'
    TabOrder = 4
    OnClick = ConfigureButtonClick
  end
  object NewButton: TBitBtn [5]
    Left = 730
    Top = 111
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Nouveau'
    TabOrder = 5
    OnClick = NewButtonClick
  end
  object DuplicateButton: TBitBtn [6]
    Left = 730
    Top = 142
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Duplique'
    TabOrder = 6
    OnClick = DuplicateButtonClick
  end
  object ExportAsXMLButton: TBitBtn [7]
    Left = 730
    Top = 173
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Exporte XML'
    TabOrder = 7
    OnClick = ExportAsXMLButtonClick
  end
  object ImporteFromXMLButton: TBitBtn [8]
    Left = 730
    Top = 204
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Importe XML'
    TabOrder = 8
    OnClick = ImporteFromXMLButtonClick
  end
  inherited dataSource: TDataSource
    OnDataChange = dataSourceDataChange
  end
end
