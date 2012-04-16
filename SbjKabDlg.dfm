inherited KabinetDlg: TKabinetDlg
  Left = 254
  Caption = '%s '#1082#1072#1073#1080#1085#1077#1090#1072
  ClientHeight = 182
  ClientWidth = 391
  Constraints.MaxHeight = 216
  Constraints.MinHeight = 216
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  ExplicitWidth = 399
  ExplicitHeight = 216
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    Top = 141
    Width = 391
    ExplicitTop = 127
    ExplicitWidth = 396
    inherited Panel2: TPanel
      Left = 117
      ExplicitLeft = 120
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 391
    Height = 80
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 1
    ExplicitWidth = 396
    ExplicitHeight = 66
    DesignSize = (
      391
      80)
    object KabName: TLabeledEdit
      Left = 9
      Top = 24
      Width = 308
      Height = 19
      Anchors = [akLeft, akTop, akRight]
      Ctl3D = False
      EditLabel.Width = 99
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1082#1072#1073#1080#1085#1077#1090#1072
      ParentCtl3D = False
      TabOrder = 0
      ExplicitWidth = 313
    end
    object KabNum: TLabeledEdit
      Left = 324
      Top = 24
      Width = 57
      Height = 19
      Anchors = [akTop, akRight]
      Ctl3D = False
      EditLabel.Width = 31
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1086#1084#1077#1088
      ParentCtl3D = False
      TabOrder = 1
      OnChange = KabNumChange
      OnKeyPress = KabNumKeyPress
      OnKeyUp = KabNumKeyUp
      ExplicitLeft = 329
    end
    object chkView: TCheckBox
      Left = 9
      Top = 53
      Width = 265
      Height = 17
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1085#1086#1084#1077#1088' '#1082#1072#1073#1080#1085#1077#1090#1072' '#1074' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1080
      Checked = True
      Ctl3D = True
      ParentCtl3D = False
      State = cbChecked
      TabOrder = 2
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 80
    Width = 391
    Height = 61
    Align = alBottom
    BevelInner = bvLowered
    Color = 15138790
    TabOrder = 2
    ExplicitTop = 66
    ExplicitWidth = 396
    object Panel6: TPanel
      Left = 2
      Top = 2
      Width = 387
      Height = 57
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 2
      ParentColor = True
      TabOrder = 0
      ExplicitWidth = 392
      object lbHelp: TLabel
        Left = 2
        Top = 2
        Width = 383
        Height = 53
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        ExplicitWidth = 3
        ExplicitHeight = 13
      end
    end
  end
end
