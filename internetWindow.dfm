object internetW: TinternetW
  Left = 0
  Top = 0
  Caption = 'Envoi des fichiers par FTP'
  ClientHeight = 459
  ClientWidth = 732
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 732
    Height = 459
    Align = alClient
    BorderWidth = 3
    Color = clMaroon
    ParentBackground = False
    TabOrder = 0
    object pg: TPageControl
      Left = 4
      Top = 4
      Width = 724
      Height = 451
      ActivePage = catTab
      Align = alClient
      TabOrder = 0
      object catTab: TTabSheet
        Caption = 'Cat'#233'gories'
        object localDirName: TLabeledEdit
          Left = 16
          Top = 24
          Width = 241
          Height = 21
          EditLabel.Width = 61
          EditLabel.Height = 13
          EditLabel.Caption = 'localDirName'
          TabOrder = 0
        end
        object connect: TButton
          Left = 280
          Top = 56
          Width = 75
          Height = 25
          Caption = 'connect'
          TabOrder = 1
          OnClick = connectClick
        end
        object send: TButton
          Left = 280
          Top = 88
          Width = 75
          Height = 25
          Caption = 'send'
          Enabled = False
          TabOrder = 2
          OnClick = sendClick
        end
        object disconnect: TButton
          Left = 280
          Top = 120
          Width = 75
          Height = 25
          Caption = 'disconnect'
          Enabled = False
          TabOrder = 3
          OnClick = disconnectClick
        end
        object localFilenames: TFileListBox
          Left = 16
          Top = 51
          Width = 241
          Height = 326
          ItemHeight = 13
          Mask = '*.pdf'
          MultiSelect = True
          TabOrder = 4
        end
        object pb: TProgressBar
          Left = 361
          Top = 96
          Width = 344
          Height = 17
          TabOrder = 5
        end
      end
      object setTab: TTabSheet
        Caption = 'Settings'
        ImageIndex = 1
        ExplicitLeft = 44
        ExplicitTop = 96
        ExplicitWidth = 0
        ExplicitHeight = 0
        object userName: TLabeledEdit
          Left = 16
          Top = 24
          Width = 200
          Height = 21
          EditLabel.Width = 48
          EditLabel.Height = 13
          EditLabel.Caption = 'userName'
          TabOrder = 0
        end
        object password: TLabeledEdit
          Left = 16
          Top = 64
          Width = 200
          Height = 21
          EditLabel.Width = 46
          EditLabel.Height = 13
          EditLabel.Caption = 'password'
          TabOrder = 1
        end
        object hostName: TLabeledEdit
          Left = 16
          Top = 104
          Width = 200
          Height = 21
          EditLabel.Width = 48
          EditLabel.Height = 13
          EditLabel.Caption = 'hostName'
          TabOrder = 2
        end
        object hostDirName: TLabeledEdit
          Left = 16
          Top = 144
          Width = 200
          Height = 21
          EditLabel.Width = 61
          EditLabel.Height = 13
          EditLabel.Caption = 'hostDirName'
          TabOrder = 3
        end
      end
    end
  end
end
