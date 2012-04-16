object Dialog: TDialog
  Left = 0
  Top = 0
  Caption = 'Dialog'
  ClientHeight = 439
  ClientWidth = 448
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 398
    Width = 448
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      448
      41)
    object Panel2: TPanel
      Left = 132
      Top = 0
      Width = 185
      Height = 41
      Anchors = []
      BevelOuter = bvNone
      TabOrder = 0
      object btnCancel: TButton
        Left = 95
        Top = 8
        Width = 75
        Height = 25
        Caption = #1054#1090#1084#1077#1085#1072
        ModalResult = 2
        TabOrder = 0
      end
      object btnOK: TButton
        Left = 14
        Top = 8
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        ModalResult = 1
        TabOrder = 1
      end
    end
  end
end
