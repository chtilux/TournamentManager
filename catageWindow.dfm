inherited catageW: TcatageW
  Caption = 'Cat'#233'gories d'#39#226'ge'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    inherited DBNavigator1: TDBNavigator
      Hints.Strings = ()
    end
  end
  object newButton: TBitBtn [4]
    Left = 313
    Top = 77
    Width = 75
    Height = 25
    Caption = 'New'
    TabOrder = 4
    OnClick = newButtonClick
  end
end
