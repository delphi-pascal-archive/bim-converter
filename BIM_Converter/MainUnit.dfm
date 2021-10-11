object BIMForm: TBIMForm
  Left = 219
  Top = 128
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'BIM converter by M.A.D.M.A.N.'
  ClientHeight = 426
  ClientWidth = 489
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object AuthorLbl: TLabel
    Left = 8
    Top = 312
    Width = 41
    Height = 16
    Caption = 'Author:'
  end
  object CommentLbl: TLabel
    Left = 8
    Top = 344
    Width = 60
    Height = 16
    Caption = 'Comment:'
  end
  object ImagePlace: TScrollBox
    Left = 8
    Top = 8
    Width = 473
    Height = 289
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    TabOrder = 0
    object Pictogram: TImage
      Left = 0
      Top = 0
      Width = 129
      Height = 129
      AutoSize = True
    end
    object BtnFullScreen: TSpeedButton
      Left = 10
      Top = 10
      Width = 90
      Height = 27
      Caption = 'Full screen'
      Flat = True
      OnClick = BtnFullScreenClick
    end
  end
  object BtnLoad: TBitBtn
    Left = 8
    Top = 368
    Width = 97
    Height = 25
    Caption = 'Load Picture'
    TabOrder = 1
    OnClick = BtnLoadClick
  end
  object BtnConvert: TBitBtn
    Left = 112
    Top = 368
    Width = 113
    Height = 25
    Caption = 'Convert to BIM'
    TabOrder = 2
    OnClick = BtnConvertClick
  end
  object AuthorEdit: TEdit
    Left = 80
    Top = 304
    Width = 401
    Height = 25
    TabOrder = 3
    Text = 'M.A.D.M.A.N.'
  end
  object CommentEdit: TEdit
    Left = 80
    Top = 336
    Width = 401
    Height = 25
    TabOrder = 4
    Text = 'There is test message'
  end
  object Progress: TProgressBar
    Left = 8
    Top = 400
    Width = 473
    Height = 17
    Smooth = True
    TabOrder = 5
  end
  object BtnLoadBim: TButton
    Left = 400
    Top = 368
    Width = 81
    Height = 25
    Caption = 'Load BIM'
    TabOrder = 6
    OnClick = BtnLoadBimClick
  end
  object RatioBox: TComboBox
    Left = 231
    Top = 368
    Width = 74
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    ItemIndex = 2
    TabOrder = 7
    Text = 'Default'
    Items.Strings = (
      'None'
      'Fastest'
      'Default'
      'Max')
  end
  object CbPassProtect: TCheckBox
    Left = 311
    Top = 376
    Width = 82
    Height = 17
    Caption = 'Password'
    TabOrder = 8
  end
  object OpenImage: TOpenPictureDialog
    Left = 16
    Top = 192
  end
  object SaveBIM: TSaveDialog
    Filter = 'Binary image (*.BIM)|*.bim'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 48
    Top = 192
  end
  object OpenBIM: TOpenDialog
    Filter = 'Binary image (*.BIM)|*.bim'
    Left = 80
    Top = 192
  end
end
