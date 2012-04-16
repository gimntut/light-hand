object TableForm: TTableForm
  Left = 13
  Top = 158
  Caption = #1051#1105#1075#1082#1072#1103' '#1088#1091#1082#1072
  ClientHeight = 580
  ClientWidth = 845
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 597
    Top = 0
    Width = 248
    Height = 580
    Align = alRight
    TabOrder = 0
    object ToolBar1: TToolBar
      Left = 1
      Top = 67
      Width = 246
      Height = 22
      AutoSize = True
      Caption = 'ToolBar1'
      Images = SubjCmds1ImLst
      TabOrder = 0
      object Label3: TLabel
        Left = 0
        Top = 0
        Width = 85
        Height = 22
        AutoSize = False
        Caption = #1057#1087#1080#1089#1086#1082' '
        Layout = tlCenter
      end
      object ToolButton13: TToolButton
        Left = 85
        Top = 0
        Width = 8
        Caption = 'ToolButton13'
        Down = True
        ImageIndex = 11
        Style = tbsSeparator
      end
      object ToolButton1: TToolButton
        Left = 93
        Top = 0
        Action = SubjCmds1_VM_Subjects
      end
      object ToolButton2: TToolButton
        Left = 116
        Top = 0
        Action = SubjCmds1_VM_Columns
      end
      object ToolButton3: TToolButton
        Left = 139
        Top = 0
        Action = SubjCmds1_VM_WeekDays
      end
      object ToolButton4: TToolButton
        Left = 162
        Top = 0
        Action = SubjCmds1_VM_Lessons
      end
    end
    object ToolBar2: TToolBar
      Left = 1
      Top = 1
      Width = 246
      Height = 22
      AutoSize = True
      Caption = 'ToolBar2'
      Images = SubjCmds1ImLst
      TabOrder = 1
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 85
        Height = 22
        AutoSize = False
        Caption = #1050#1083#1077#1090#1082#1080' '
        Layout = tlCenter
      end
      object ToolButton11: TToolButton
        Left = 85
        Top = 0
        Width = 8
        Caption = 'ToolButton11'
        ImageIndex = 6
        Style = tbsSeparator
      end
      object ToolButton5: TToolButton
        Left = 93
        Top = 0
        Action = SubjCmds1_TC_Subject
      end
      object ToolButton6: TToolButton
        Left = 116
        Top = 0
        Action = SubjCmds1_TC_Teacher
      end
      object ToolButton7: TToolButton
        Left = 139
        Top = 0
        Action = SubjCmds1_TC_Kabinet
      end
      object ToolButton14: TToolButton
        Left = 162
        Top = 0
        Width = 8
        Caption = 'ToolButton14'
        ImageIndex = 6
        Style = tbsSeparator
      end
      object ToolButton15: TToolButton
        Left = 170
        Top = 0
        Action = SubjCmds1_LockLess
      end
      object ToolButton16: TToolButton
        Left = 193
        Top = 0
        Action = SubjCmds1_LockDay
      end
    end
    object ToolBar3: TToolBar
      Left = 1
      Top = 45
      Width = 246
      Height = 22
      AutoSize = True
      Caption = 'ToolBar3'
      Images = SubjCmds1ImLst
      TabOrder = 3
      object Label2: TLabel
        Left = 0
        Top = 0
        Width = 85
        Height = 22
        AutoSize = False
        Caption = #1047#1072#1075#1086#1083#1086#1074#1082#1080' '
        Layout = tlCenter
      end
      object ToolButton12: TToolButton
        Left = 85
        Top = 0
        Width = 8
        Caption = 'ToolButton12'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object ToolButton8: TToolButton
        Left = 93
        Top = 0
        Action = SubjCmds1_CM_Klass
      end
      object ToolButton9: TToolButton
        Left = 116
        Top = 0
        Action = SubjCmds1_CM_Teacher
      end
      object ToolButton10: TToolButton
        Left = 139
        Top = 0
        Action = SubjCmds1_CM_Kabinet
      end
    end
    object ToolBar4: TToolBar
      Left = 1
      Top = 23
      Width = 246
      Height = 22
      AutoSize = True
      Caption = 'ToolBar4'
      Images = SubjCmds1ImLst
      TabOrder = 2
      object Label4: TLabel
        Left = 0
        Top = 0
        Width = 85
        Height = 22
        AutoSize = False
        Caption = #1042#1080#1076
        Layout = tlCenter
      end
      object ToolButton22: TToolButton
        Left = 85
        Top = 0
        Width = 8
        Caption = 'ToolButton22'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object ToolButton19: TToolButton
        Left = 93
        Top = 0
        Action = SubjCmds1_VW_FullView
      end
      object ToolButton20: TToolButton
        Left = 116
        Top = 0
        Action = SubjCmds1_VW_SanPIN
      end
      object ToolButton21: TToolButton
        Left = 139
        Top = 0
        Action = SubjCmds1_VW_TextAct
      end
    end
    object SubjList1: TSubjList
      Left = 1
      Top = 89
      Width = 246
      Height = 490
      Align = alClient
      Color = 15658751
      SubjSource = SS1
      ViewMode = vmSubjects
    end
  end
  object SubjGrid1: TSubjGrid
    Left = 0
    Top = 0
    Width = 597
    Height = 580
    Colors.Cross = 15636464
    Colors.Fixed = 16752029
    Colors.FullView = clLime
    Colors.Main = clSkyBlue
    Colors.NotFullView = clRed
    Colors.SanPinLesson = 7982333
    Colors.SanPinWeekDay = clGreen
    Colors.Select = clBlue
    Colors.SelectSanPinLesson = clNavy
    Colors.SelectText = clYellow
    Colors.Text = clBlack
    ColumnMode = cmKlass
    FullView = True
    SubjSource = SS1
    TableContent = tcSubject
  end
  object MainMenu1: TMainMenu
    Images = SubjCmds1ImLst
    Left = 136
    Top = 64
    object N1: TMenuItem
      Caption = #1042#1080#1076
      object N4: TMenuItem
        Action = SubjCmds1_CM_Klass
        AutoCheck = True
        GroupIndex = 1
        RadioItem = True
      end
      object N2: TMenuItem
        Action = SubjCmds1_CM_Teacher
        AutoCheck = True
        GroupIndex = 1
        RadioItem = True
      end
      object N3: TMenuItem
        Action = SubjCmds1_CM_Kabinet
        AutoCheck = True
        GroupIndex = 1
        RadioItem = True
      end
      object N7: TMenuItem
        AutoCheck = True
        Caption = '-'
        GroupIndex = 2
        RadioItem = True
      end
      object N6: TMenuItem
        Action = SubjCmds1_TC_Subject
        AutoCheck = True
        GroupIndex = 2
        RadioItem = True
      end
      object N15: TMenuItem
        Action = SubjCmds1_TC_Teacher
        AutoCheck = True
        GroupIndex = 2
      end
      object N8: TMenuItem
        Action = SubjCmds1_TC_Kabinet
        AutoCheck = True
        GroupIndex = 2
        RadioItem = True
      end
    end
    object N9: TMenuItem
      AutoCheck = True
      Caption = #1091#1075#1091
      ImageIndex = 12
      object N11: TMenuItem
        Action = SubjCmds1_LockLess
        AutoCheck = True
      end
      object N10: TMenuItem
        Action = SubjCmds1_LockDay
        AutoCheck = True
      end
      object N12: TMenuItem
        AutoCheck = True
        Caption = '-'
      end
      object N17: TMenuItem
        Action = SubjCmds1_VM_Subjects
        AutoCheck = True
      end
      object N13: TMenuItem
        Action = SubjCmds1_VM_Columns
        AutoCheck = True
      end
      object N18: TMenuItem
        Action = SubjCmds1_VM_WeekDays
        AutoCheck = True
      end
      object N16: TMenuItem
        Action = SubjCmds1_VM_Lessons
        AutoCheck = True
      end
    end
    object C1: TMenuItem
      Caption = #1060#1072#1081#1083
      OnClick = C1Click
      object N14: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100
        OnClick = N14Click
      end
      object C2: TMenuItem
        Caption = 'C'#1086#1093#1088#1072#1085#1080#1090#1100
        OnClick = C1Click
      end
      object N5: TMenuItem
        Caption = #1057#1077#1088#1074#1080#1089
        OnClick = N5Click
      end
    end
    object N19: TMenuItem
      Caption = #1072#1075#1072
      object N20: TMenuItem
        Action = SubjCmds1_VW_FullView
        AutoCheck = True
      end
      object N22: TMenuItem
        Action = SubjCmds1_VW_TextAct
        AutoCheck = True
      end
      object N23: TMenuItem
        Action = SubjCmds1_VW_SanPIN
        AutoCheck = True
      end
    end
  end
  object SubjCmds1: TSubjCmds
    Grid = SubjGrid1
    Source = SS1
    Left = 104
    Top = 64
  end
  object SS1: TSubjSource
    Activate = False
    ColumnMode = cmKlass
    FileName = 
      'd:\'#1052#1086#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1099'\Delphi\'#1064#1082#1086#1083#1072'\'#1056#1072#1089#1087#1080#1089#1072#1085#1080#1077' ('#1085#1080#1095#1077#1075#1086' '#1083#1080#1096#1085#1077#1075#1086')\defaul' +
      't.rsp'
    Manager = SubjManager1
    ViewMode = vmSubjects
    WeekDays = [wdMonday, wdTuesday, wdWednesday, wdThursday, wdFriday, wdSaturday]
    Left = 72
    Top = 64
  end
  object SubjManager1: TSubjManager
    Left = 168
    Top = 64
  end
  object XPManifest1: TXPManifest
    Left = 256
    Top = 232
  end
end
