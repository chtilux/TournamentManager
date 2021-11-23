inherited dicW: TdicW
  Caption = 'Dictionnaire'
  ClientHeight = 577
  ClientWidth = 668
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 684
  ExplicitHeight = 616
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    Width = 668
    Height = 577
    ExplicitWidth = 668
    ExplicitHeight = 577
    inherited Panel2: TPanel
      Width = 656
      Height = 565
      ExplicitWidth = 656
      ExplicitHeight = 565
      inherited Panel4: TPanel
        Width = 654
        Height = 496
        ExplicitWidth = 654
        ExplicitHeight = 496
        inherited PageControl1: TPageControl
          Width = 650
          Height = 492
          ExplicitWidth = 650
          ExplicitHeight = 492
          inherited gridSheet: TTabSheet
            ExplicitWidth = 642
            ExplicitHeight = 464
            inherited grid: TDBGrid
              Width = 642
              Height = 464
              DataSource = nil
              OnDrawColumnCell = gridDrawColumnCell
              OnDblClick = gridDblClick
              Columns = <
                item
                  Expanded = False
                  FieldName = 'cledic'
                  Title.Alignment = taCenter
                  Title.Caption = 'cl'#233
                  Width = 100
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'coddic'
                  Title.Alignment = taCenter
                  Title.Caption = 'code'
                  Width = 100
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'libdic'
                  Title.Alignment = taCenter
                  Title.Caption = 'libell'#233
                  Width = 100
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'pardc1'
                  Title.Alignment = taCenter
                  Title.Caption = 'param'#232'tre 1'
                  Width = 100
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'pardc2'
                  Title.Alignment = taCenter
                  Title.Caption = 'param'#232'tre 2'
                  Width = 100
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'pardc3'
                  Title.Alignment = taCenter
                  Title.Caption = 'param'#232'tre 3'
                  Width = 100
                  Visible = True
                end>
            end
          end
        end
      end
      inherited Panel5: TPanel
        Top = 523
        Width = 654
        ExplicitTop = 523
        ExplicitWidth = 654
        inherited cancel: TBitBtn
          Width = 112
          ExplicitWidth = 112
        end
      end
      inherited Panel3: TPanel
        Width = 654
        ExplicitWidth = 654
        inherited Panel9: TPanel
          inherited nav: TDBNavigator
            Hints.Strings = ()
          end
        end
      end
    end
  end
end
