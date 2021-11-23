object settingsW: TsettingsW
  Left = 195
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Classeur '#224' onglets'
  ClientHeight = 490
  ClientWidth = 415
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 415
    Height = 456
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    ParentColor = True
    TabOrder = 0
    object pg: TPageControl
      Left = 5
      Top = 5
      Width = 405
      Height = 446
      ActivePage = general
      Align = alClient
      TabOrder = 0
      object general: TTabSheet
        Caption = 'G'#233'n'#233'ral'
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 397
          Height = 418
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 3
          TabOrder = 0
          DesignSize = (
            397
            418)
          object Label1: TLabel
            Left = 13
            Top = 178
            Width = 93
            Height = 13
            Alignment = taRightJustify
            Caption = '&Working Directory :'
            FocusControl = workingDirectoryEdit
          end
          object Label2: TLabel
            Left = 36
            Top = 205
            Width = 70
            Height = 13
            Alignment = taRightJustify
            Caption = '&Tournaments :'
            FocusControl = tournamentsEdit
          end
          object Label3: TLabel
            Left = 62
            Top = 232
            Width = 44
            Height = 13
            Alignment = taRightJustify
            Caption = '&Exports :'
            FocusControl = exportDirectoryEdit
          end
          object templatesDirectoryLabel: TLabel
            Left = 50
            Top = 259
            Width = 56
            Height = 13
            Alignment = taRightJustify
            Caption = 'Te&mplates :'
            FocusControl = templatesDirectoryEdit
          end
          object Label4: TLabel
            Left = 41
            Top = 286
            Width = 65
            Height = 13
            Alignment = taRightJustify
            Caption = '&FLTT results :'
            FocusControl = flttResultsDocumentEdit
          end
          object Label5: TLabel
            Left = 29
            Top = 313
            Width = 77
            Height = 13
            Alignment = taRightJustify
            Caption = '&Draw template :'
            FocusControl = drawTemplateEdit
          end
          object generalList: TValueListEditor
            Left = 3
            Top = 3
            Width = 391
            Height = 166
            Anchors = [akLeft, akTop, akRight]
            KeyOptions = [keyEdit, keyAdd, keyDelete, keyUnique]
            TabOrder = 0
            ColWidths = (
              150
              235)
          end
          object workingDirectoryEdit: TButtonedEdit
            Left = 112
            Top = 175
            Width = 281
            Height = 21
            MaxLength = 30
            RightButton.DisabledImageIndex = 1
            RightButton.ImageIndex = 0
            RightButton.Visible = True
            TabOrder = 1
            OnRightButtonClick = workingDirectoryEditRightButtonClick
          end
          object tournamentsEdit: TButtonedEdit
            Left = 112
            Top = 202
            Width = 281
            Height = 21
            MaxLength = 30
            RightButton.DisabledImageIndex = 1
            RightButton.ImageIndex = 0
            RightButton.Visible = True
            TabOrder = 2
            OnRightButtonClick = tournamentsEditRightButtonClick
          end
          object exportDirectoryEdit: TButtonedEdit
            Left = 112
            Top = 229
            Width = 281
            Height = 21
            MaxLength = 30
            RightButton.DisabledImageIndex = 1
            RightButton.ImageIndex = 0
            RightButton.Visible = True
            TabOrder = 3
            OnRightButtonClick = exportDirectoryEditRightButtonClick
          end
          object templatesDirectoryEdit: TButtonedEdit
            Left = 112
            Top = 256
            Width = 281
            Height = 21
            MaxLength = 30
            RightButton.DisabledImageIndex = 1
            RightButton.ImageIndex = 0
            RightButton.Visible = True
            TabOrder = 4
            OnRightButtonClick = templatesDirectoryEditRightButtonClick
          end
          object flttResultsDocumentEdit: TButtonedEdit
            Left = 112
            Top = 283
            Width = 281
            Height = 21
            MaxLength = 30
            RightButton.DisabledImageIndex = 1
            RightButton.ImageIndex = 0
            RightButton.Visible = True
            TabOrder = 5
            OnRightButtonClick = flttResultsDocumentEditRightButtonClick
          end
          object drawTemplateEdit: TButtonedEdit
            Left = 112
            Top = 310
            Width = 281
            Height = 21
            MaxLength = 30
            RightButton.DisabledImageIndex = 1
            RightButton.ImageIndex = 0
            RightButton.Visible = True
            TabOrder = 6
            OnRightButtonClick = drawTemplateEditRightButtonClick
          end
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 456
    Width = 415
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object OKBtn: TButton
      Left = 170
      Top = 1
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = OKBtnClick
    end
    object CancelBtn: TButton
      Left = 251
      Top = 1
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Annuler'
      ModalResult = 2
      TabOrder = 1
    end
    object HelpBtn: TButton
      Left = 331
      Top = 1
      Width = 75
      Height = 25
      Caption = '&Aide'
      TabOrder = 2
    end
  end
  object ImageList1: TImageList
    Left = 177
    Top = 141
  end
end
