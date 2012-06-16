inherited TeacherDlg: TTeacherDlg
  Left = 208
  Top = 198
  Caption = '%s '#1087#1088#1077#1087#1086#1076#1072#1074#1072#1090#1077#1083#1103
  ClientHeight = 276
  ClientWidth = 348
  Constraints.MaxHeight = 310
  Constraints.MinHeight = 310
  OldCreateOrder = True
  OnActivate = FormActivate
  ExplicitWidth = 356
  ExplicitHeight = 310
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    Top = 235
    Width = 348
    TabOrder = 1
    ExplicitTop = 235
    ExplicitWidth = 348
    inherited Panel2: TPanel
      Left = 97
      Top = 2
      ExplicitLeft = 97
      ExplicitTop = 2
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 348
    Height = 174
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 0
    DesignSize = (
      348
      174)
    object Label1: TLabel
      Left = 8
      Top = 122
      Width = 94
      Height = 13
      Caption = #1054#1089#1085#1086#1074#1085#1086#1081' '#1082#1072#1073#1080#1085#1077#1090
    end
    object le2: TLabeledEdit
      Left = 10
      Top = 58
      Width = 328
      Height = 19
      Anchors = [akLeft, akTop, akRight]
      Ctl3D = False
      EditLabel.Width = 19
      EditLabel.Height = 13
      EditLabel.Caption = #1048#1084#1103
      ParentCtl3D = False
      TabOrder = 1
      OnChange = le1Change
      OnKeyPress = le1KeyPress
      OnKeyUp = le1KeyUp
    end
    object le1: TLabeledEdit
      Left = 10
      Top = 20
      Width = 328
      Height = 19
      Anchors = [akLeft, akTop, akRight]
      Ctl3D = False
      EditLabel.Width = 44
      EditLabel.Height = 13
      EditLabel.Caption = #1060#1072#1084#1080#1083#1080#1103
      ParentCtl3D = False
      TabOrder = 0
      OnChange = le1Change
      OnKeyPress = le1KeyPress
      OnKeyUp = le1KeyUp
    end
    object le3: TLabeledEdit
      Left = 10
      Top = 97
      Width = 328
      Height = 19
      Anchors = [akLeft, akTop, akRight]
      Ctl3D = False
      EditLabel.Width = 49
      EditLabel.Height = 13
      EditLabel.Caption = #1054#1090#1095#1077#1089#1090#1074#1086
      ParentCtl3D = False
      TabOrder = 2
      OnChange = le1Change
      OnKeyPress = le1KeyPress
      OnKeyUp = le1KeyUp
    end
    object ComboBox1: TComboBox
      Left = 10
      Top = 138
      Width = 328
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      Color = 15132415
      Ctl3D = True
      ItemHeight = 13
      ParentCtl3D = False
      TabOrder = 3
      OnKeyUp = ComboBox1KeyUp
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 174
    Width = 348
    Height = 61
    Align = alBottom
    BevelInner = bvLowered
    Color = 15138790
    TabOrder = 2
    object Panel6: TPanel
      Left = 2
      Top = 2
      Width = 344
      Height = 57
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 2
      ParentColor = True
      TabOrder = 0
      object Label2: TLabel
        Left = 2
        Top = 2
        Width = 340
        Height = 53
        Align = alClient
        Caption = 
          #1044#1083#1103' '#1073#1083#1091#1078#1076#1072#1102#1097#1080#1093' '#1087#1088#1077#1087#1086#1076#1072#1074#1072#1090#1077#1083#1077#1081' '#1085#1091#1078#1085#1086' '#1074#1099#1073#1088#1072#1090#1100' "'#1051#1102#1073#1086#1081' '#1089#1074#1086#1073#1086#1076#1085#1099#1081' '#1082#1072#1073 +
          #1080#1085#1077#1090'". '#1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1077#1076#1086#1089#1090#1072#1102#1097#1080#1081' '#1082#1072#1073#1080#1085#1077#1090' '#1084#1086#1078#1085#1086' '#1082#1083#1072#1074#1080#1096#1077#1081' Insert, '#1072' '#1080#1079#1084 +
          #1077#1085#1080#1090#1100' '#1085#1077#1074#1077#1088#1085#1099#1081' '#1082#1083#1072#1074#1080#1096#1077#1081' F2. '#1051#1080#1096#1085#1080#1077' '#1082#1072#1073#1080#1085#1077#1090#1099' '#1091#1076#1072#1083#1103#1102#1090#1089#1103' '#1082#1083#1072#1074#1080#1096#1077#1081' D' +
          'elete.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        ExplicitWidth = 320
        ExplicitHeight = 52
      end
    end
  end
end
