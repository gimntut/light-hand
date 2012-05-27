inherited SubjectDlg: TSubjectDlg
  Left = 194
  Top = 172
  Caption = '%s '#1087#1088#1077#1076#1084#1077#1090#1072
  ClientHeight = 350
  ClientWidth = 591
  OldCreateOrder = True
  ShowHint = True
  OnClose = FormClose
  ExplicitWidth = 599
  ExplicitHeight = 384
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    Top = 309
    Width = 591
    TabOrder = 2
    ExplicitTop = 309
    ExplicitWidth = 591
    inherited Panel2: TPanel
      Left = 217
      ExplicitLeft = 217
      inherited btnCancel: TButton
        Tag = 7
        OnEnter = ComponentEnter
        OnExit = ComponentExit
      end
      inherited btnOK: TButton
        Tag = 7
        OnEnter = ComponentEnter
        OnExit = ComponentExit
      end
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 245
    Width = 591
    Height = 64
    Align = alBottom
    BevelInner = bvLowered
    Color = 15138790
    TabOrder = 3
    object Panel6: TPanel
      Left = 2
      Top = 2
      Width = 587
      Height = 60
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 2
      ParentColor = True
      TabOrder = 0
      object lbHelp: TLabel
        Left = 2
        Top = 2
        Width = 583
        Height = 56
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
  object pn2: TPanel
    Left = 0
    Top = 41
    Width = 440
    Height = 204
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pn3: TPanel
      Left = 0
      Top = 0
      Width = 440
      Height = 204
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object rgLessonPos: TRadioGroup
        Tag = 7
        Left = 0
        Top = 164
        Width = 440
        Height = 40
        Align = alBottom
        Caption = ' '#1055#1086#1083#1086#1078#1077#1085#1080#1077' '#1091#1088#1086#1082#1072' '
        Columns = 3
        Ctl3D = False
        Enabled = False
        ItemIndex = 0
        Items.Strings = (
          #1042#1077#1079#1076#1077
          #1055#1086#1089#1083#1077#1076#1085#1080#1081
          #1055#1077#1088#1074#1099#1081)
        ParentCtl3D = False
        TabOrder = 0
        OnEnter = ComponentEnter
      end
      object rgLessonType: TRadioGroup
        Tag = 8
        Left = 0
        Top = 124
        Width = 440
        Height = 40
        Align = alBottom
        Caption = ' '#1042#1080#1076' '#1091#1088#1086#1082#1072' '
        Columns = 3
        Ctl3D = False
        Enabled = False
        ItemIndex = 0
        Items.Strings = (
          #1054#1073#1099#1095#1085#1099#1081
          #1055#1072#1088#1085#1099#1081
          #1055#1086#1083#1086#1074#1080#1085#1085#1099#1081)
        ParentCtl3D = False
        TabOrder = 1
        OnEnter = ComponentEnter
      end
      object sgTeachKab: TSuperGrid
        Tag = 6
        Left = 0
        Top = 0
        Width = 440
        Height = 124
        Align = alClient
        Color = 16770790
        ColCount = 2
        Ctl3D = False
        DefaultRowHeight = 18
        FixedColor = 16752029
        RowCount = 6
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goTabs]
        ParentCtl3D = False
        ScrollBars = ssNone
        TabOrder = 2
        OnEnter = ComponentEnter
        OnExit = ComponentExit
        OnKeyUp = gdTeachKabKeyUp
        OnSelectCell = sgTeachKabSelectCell
        Columns = <
          item
            Caption = #1059#1095#1080#1090#1077#1083#1103
            DataType = ctString
            ReadOnly = True
            RelativeWidth = 50
          end
          item
            Caption = #1050#1072#1073#1080#1085#1077#1090#1099
            DataType = ctString
            ReadOnly = True
            RelativeWidth = 50
          end>
        ListColor = 15132415
        OnBeforeChangeCell = sgTeachKabBeforeChangeCell
        OnChangeCell = sgTeachKabChangeCell
        ColWidths = (
          219
          216)
      end
    end
  end
  object pn1: TPanel
    Left = 0
    Top = 0
    Width = 591
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label3: TLabel
      Left = 64
      Top = 4
      Width = 87
      Height = 13
      Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077
    end
    object Label1: TLabel
      Left = 1
      Top = 4
      Width = 29
      Height = 13
      Caption = #1050#1083#1072#1089#1089
    end
    object Bevel1: TBevel
      Left = 486
      Top = 0
      Width = 105
      Height = 41
      Align = alRight
      Anchors = [akLeft, akTop, akRight, akBottom]
      Shape = bsLeftLine
      ExplicitWidth = 106
    end
    object edSanPin: TLabeledEdit
      Tag = 4
      Left = 399
      Top = 18
      Width = 49
      Height = 19
      Ctl3D = False
      EditLabel.Width = 40
      EditLabel.Height = 13
      EditLabel.Caption = #1057#1072#1085#1055#1048#1053
      MaxLength = 3
      ParentCtl3D = False
      TabOrder = 3
      Text = '0'
      OnChange = edLongNameChange
      OnEnter = ComponentEnter
      OnExit = ComponentExit
      OnKeyPress = edTimeKeyPress
      OnKeyUp = edLongNameKeyUp
    end
    object edLongName: tListEdit
      Tag = 2
      Left = 64
      Top = 18
      Width = 217
      Height = 19
      AutoSelect = False
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      OnChange = edLongNameChange
      OnEnter = ComponentEnter
      OnExit = ComponentExit
      OnKeyUp = edLongNameKeyUp
      ChoiceColor = 16512
      ChoiceTextColor = clYellow
      OnChangeIndex = edLongNameChangeIndex
    end
    object edShortName: TLabeledEdit
      Tag = 3
      Left = 287
      Top = 18
      Width = 106
      Height = 19
      Ctl3D = False
      EditLabel.Width = 99
      EditLabel.Height = 13
      EditLabel.Caption = #1050#1086#1088#1086#1090#1082#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077
      ParentCtl3D = False
      TabOrder = 2
      OnChange = edLongNameChange
      OnEnter = ComponentEnter
      OnExit = ComponentExit
      OnKeyUp = edLongNameKeyUp
    end
    object edTime: TLabeledEdit
      Tag = 5
      Left = 496
      Top = 18
      Width = 89
      Height = 19
      Ctl3D = False
      EditLabel.Width = 82
      EditLabel.Height = 13
      EditLabel.Caption = #1063#1072#1089#1086#1074' '#1074' '#1085#1077#1076#1077#1083#1102
      MaxLength = 3
      ParentCtl3D = False
      TabOrder = 5
      Text = '0'
      OnChange = edTimeChange
      OnEnter = ComponentEnter
      OnExit = ComponentExit
      OnKeyPress = edTimeKeyPress
      OnKeyUp = edLongNameKeyUp
    end
    object pnKlass: TPanel
      Left = 1
      Top = 17
      Width = 58
      Height = 21
      BevelOuter = bvNone
      TabOrder = 0
      object Panel8: TPanel
        Left = 0
        Top = 0
        Width = 58
        Height = 21
        Align = alClient
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object btKlass: TSpeedButton
          Left = 38
          Top = 0
          Width = 20
          Height = 20
          Flat = True
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0DC0000DC0000DC0000C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0DC0000DC0000FF
            FF6BDC0000DC0000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0DC0000DC0000F5BA4EFFFF6BEA6B2CDC0000C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0DC0000EA6B2CFDF767FB
            E861F8CC55E0210DDC0000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0DC0000E64C20FBE560F5BA4EE96028FEFC69ED7F35DC0000C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0DC0000DC0000F9D659F9D659E43A18DC
            0000F4AF49FADD5DE23014DC0000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0DC0000
            DC0000F5BA4EFBE560E64C20C0C0C0DC0000E64C20FDF265F0933EDC0000C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0DC0000F19E42FDF767EA6B2CC0C0C0C0C0C0C0
            C0C0DC0000F19E42FCEA62E43A18DC0000C0C0C0C0C0C0C0C0C0DC0000DC0000
            FFFF6BEE8939DC0000C0C0C0C0C0C0C0C0C0DC0000E43A18FCEA62F19E42DC00
            00C0C0C0C0C0C0C0C0C0DC0000DC0000DC0000DC0000C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0DC0000F0933EFDF265E64C20DC0000C0C0C0C0C0C0C0C0C0DC0000
            DC0000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0DC0000E23014FADD5DF4AF
            49DC0000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0DC0000ED7F35FEFC69E96028DC0000C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0DC0000E0210DF8CC
            55F6C452DC0000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0DC0000EA6B2CFFFF6BEA6B2CDC0000C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0DC0000DC00
            00FFFF6BDC0000DC0000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0DC0000DC0000000000}
        end
        object edKlass: TEdit
          Left = 0
          Top = 1
          Width = 38
          Height = 19
          TabStop = False
          AutoSize = False
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 0
        end
      end
      object cbKlass: TComboBox
        Tag = 1
        Left = 0
        Top = 0
        Width = 58
        Height = 21
        Style = csDropDownList
        Color = 16770790
        ItemHeight = 13
        TabOrder = 1
        OnEnter = ComponentEnter
        OnExit = ComponentExit
        OnKeyPress = cbKlassKeyPress
        OnKeyUp = cbKlassKeyUp
      end
    end
    object btnPlus: TBitBtn
      Left = 456
      Top = 13
      Width = 22
      Height = 22
      Hint = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1085#1086#1074#1086#1075#1086' '#1085#1072#1079#1074#1072#1085#1080#1103' '#1074' '#1089#1087#1080#1089#1086#1082
      TabOrder = 4
      OnClick = btnPlusClick
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C40E0000C40E0000000000000000000080FFFF80FFFF
        80FFFF80FFFF80FFFF80FFFFCFB0A0D0C0C0D0C0BFD0B8A080FFFF80FFFF80FF
        FF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFFBF9050EF
        D8AFEFE0BFBF784080FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF
        80FFFF80FFFF80FFFF80FFFFDFC890FFF8EFFFF8FFD0A87080FFFF80FFFF80FF
        FF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFFD0B070FF
        F8DFFFF8EFD0A06F80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF
        80FFFF80FFFF80FFFF80FFFFD0A870FFF8D0FFF8EFD0A86F80FFFF80FFFF80FF
        FF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFFD0B070FF
        F8D0FFF8E0D0A87080FFFF80FFFF80FFFF80FFFF80FFFF80FFFFA0785F9F480F
        9F501F9F5820A0582F9F582FEFC89FFFF8C0FFF8CFEFC8A0AF7040AF7840B078
        40B0804FB07840D0B0A0CFB09FFFD89FFFE0AFFFE8B0FFE8BFFFF0BFFFE8BFFF
        E8BFFFF0BFFFF8CFFFF8E0FFF8EFFFF8EFFFF8FFFFF8DFEFD8D0C0A89FFFC080
        FFC89FFFD09FFFD0A0FFD8AFFFD8AFFFE0B0FFE0B0FFF0C0FFF8CFFFF8CFFFF8
        D0FFF8DFFFF8C0E0D0CFBF988FEF8840EF985FE0985FE0A060E0A86FFFC89FFF
        D8AFFFE0B0FFD8AFDFB080DFA870DFA86FDFB070D0985FDFC0B080FFFF80FFFF
        80FFFF80FFFF80FFFF80FFFFC08050FFD8AFFFE0B0D0905F80FFFF80FFFF80FF
        FF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFFC07840FF
        D8A0FFD8AFDF985F80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF
        80FFFF80FFFF80FFFF80FFFFC0783FFFD09FFFD0A0DF905080FFFF80FFFF80FF
        FF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFFC0703FFF
        C89FFFD0A0DF885080FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF
        80FFFF80FFFF80FFFF80FFFFB05810FFA860FFA060CF682080FFFF80FFFF80FF
        FF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFFDFC0BFC0
        A8AFC0A8AFC0A8AF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF}
    end
  end
  object Panel3: TPanel
    Left = 440
    Top = 41
    Width = 151
    Height = 204
    Align = alRight
    TabOrder = 4
    object lbxListOfChoice: TListBox
      Left = 1
      Top = 1
      Width = 149
      Height = 202
      TabStop = False
      Align = alClient
      Color = 15132415
      Ctl3D = False
      ItemHeight = 13
      ParentCtl3D = False
      Sorted = True
      TabOrder = 0
      OnClick = lbxListOfChoiceClick
      OnDblClick = lbxListOfChoiceDblClick
      OnEnter = lbxListOfChoiceEnter
      OnExit = lbxListOfChoiceExit
      OnKeyUp = lbxListOfChoiceKeyUp
    end
  end
end
