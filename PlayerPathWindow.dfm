inherited PlayerPathW: TPlayerPathW
  Caption = 'Parcours joueur'
  ClientWidth = 1080
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 1096
  ExplicitHeight = 409
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    Width = 1080
    inherited Panel2: TPanel
      Width = 1068
      inherited Panel4: TPanel
        Width = 1066
        ParentFont = False
        inherited PageControl1: TPageControl
          Width = 1062
          Font.Height = -16
          Font.Style = [fsBold]
          ParentFont = False
          TabHeight = 25
          TabWidth = 400
          ExplicitWidth = 935
          inherited gridSheet: TTabSheet
            Caption = 'Path'
            ExplicitLeft = 4
            ExplicitTop = 24
            ExplicitWidth = 927
            ExplicitHeight = 257
            inherited grid: TDBGrid
              Width = 1054
              Height = 250
              Font.Charset = ANSI_CHARSET
              Font.Name = 'Arial Narrow'
              ParentFont = False
              TitleFont.Height = -16
              TitleFont.Style = [fsBold]
              OnDrawColumnCell = gridDrawColumnCell
            end
          end
        end
      end
      inherited Panel5: TPanel
        Width = 1066
        inherited cancel: TBitBtn
          Width = 223
          ExplicitWidth = 96
        end
      end
      inherited Panel3: TPanel
        Width = 1066
        inherited Panel9: TPanel
          Caption = ''
          inherited nav: TDBNavigator
            Hints.Strings = ()
            ExplicitTop = 1
          end
        end
      end
    end
  end
end
