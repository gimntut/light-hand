object ManageDlg: TManageDlg
  Left = 315
  Top = 147
  Caption = #1059#1089#1090#1088#1072#1085#1077#1085#1080#1077' '#1087#1077#1088#1077#1089#1077#1095#1077#1085#1080#1081
  ClientHeight = 338
  ClientWidth = 413
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ppAll: TPagePanel
    Left = 0
    Top = 0
    Width = 413
    Height = 297
    ActivePage = spKabinet
    Align = alClient
    object spTime: TSheetPanel
      Left = 0
      Top = 0
      Width = 413
      Height = 297
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 413
        Height = 81
        Align = alTop
        BevelInner = bvLowered
        TabOrder = 0
        object Panel2: TPanel
          Left = 2
          Top = 2
          Width = 409
          Height = 77
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 2
          Caption = 'Panel2'
          Color = 15138790
          TabOrder = 0
          object Label1: TLabel
            Left = 2
            Top = 2
            Width = 391
            Height = 48
            Align = alClient
            Caption = 
              #1044#1083#1103' '#1090#1086#1075#1086', '#1095#1090#1086#1073#1099' '#1085#1077' '#1073#1099#1083#1086' '#1087#1088#1077#1074#1099#1096#1077#1085#1080#1103' '#1086#1090#1074#1077#1076#1105#1085#1086#1075#1086' '#1087#1088#1077#1076#1084#1077#1090#1091' '#1074#1088#1077#1084#1077#1085#1080', ' +
              #1085#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1091#1076#1072#1083#1080#1090#1100' '#1086#1076#1080#1085' '#1080#1079' '#1091#1078#1077' '#1087#1086#1089#1090#1072#1074#1083#1077#1085#1085#1099#1093' '#1087#1088#1077#1076#1084#1077#1090#1086#1074
            Color = 15138790
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            WordWrap = True
          end
        end
      end
      object ListBox1: TListBox
        Left = 0
        Top = 81
        Width = 413
        Height = 180
        Align = alClient
        ItemHeight = 13
        TabOrder = 1
      end
      object Panel12: TPanel
        Left = 0
        Top = 261
        Width = 413
        Height = 36
        Align = alBottom
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 2
        object Label3: TLabel
          Left = 6
          Top = 16
          Width = 135
          Height = 16
          Caption = #1055#1088#1077#1076#1084#1077#1090' '#1085#1077' '#1074#1099#1073#1088#1072#1085
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label2: TLabel
          Left = 6
          Top = 3
          Width = 67
          Height = 13
          Caption = #1041#1091#1076#1077#1090' '#1091#1076#1072#1083#1105#1085
        end
      end
    end
    object spTeacher: TSheetPanel
      Left = 0
      Top = 0
      Width = 413
      Height = 297
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 413
        Height = 88
        Align = alTop
        BevelInner = bvLowered
        TabOrder = 0
        object Panel5: TPanel
          Left = 2
          Top = 2
          Width = 409
          Height = 84
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 2
          Caption = 'Panel2'
          Color = 15138790
          TabOrder = 0
          object Label4: TLabel
            Left = 2
            Top = 2
            Width = 405
            Height = 48
            Align = alClient
            Caption = 
              #1042#1099' '#1093#1086#1090#1080#1090#1077' '#1087#1086#1089#1090#1072#1074#1080#1090#1100' '#1087#1088#1077#1076#1084#1077#1090' %s. '#1053#1086' '#1087#1088#1077#1087#1086#1076#1072#1074#1072#1090#1077#1083#1100'('#1080') '#1101#1090#1086#1075#1086' '#1087#1088#1077#1076#1084#1077 +
              #1090#1072' '#1091#1078#1077' '#1079#1072#1085#1103#1090'('#1099') '#1087#1088#1077#1076#1084#1077#1090#1086#1084' %s. '#1042#1099#1073#1077#1088#1080#1090#1077' '#1086#1076#1080#1085' '#1080#1079' '#1074#1072#1088#1080#1072#1085#1090#1086#1074' '#1076#1077#1081#1089#1090#1074#1080 +
              #1081'.'
            Color = 15138790
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            WordWrap = True
          end
        end
      end
      object ComboBox1: TComboBox
        Left = 10
        Top = 96
        Width = 393
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        ItemIndex = 3
        TabOrder = 1
        Text = #1055#1088#1086#1074#1077#1089#1090#1080' '#1091#1088#1086#1082#1080' '#1074#1084#1077#1089#1090#1077
        Items.Strings = (
          #1059#1076#1072#1083#1080#1090#1100' '#1087#1072#1088#1072#1083#1083#1077#1083#1100#1085#1099#1081' '#1087#1088#1077#1076#1084#1077#1090
          #1055#1086#1084#1077#1085#1103#1090#1100' '#1087#1088#1077#1087#1086#1076#1072#1074#1072#1090#1077#1083#1103'('#1077#1081') '#1087#1072#1088#1072#1083#1083#1077#1083#1100#1085#1086#1075#1086' '#1087#1088#1077#1076#1084#1077#1090#1072
          #1055#1086#1084#1077#1085#1103#1090#1100' '#1087#1088#1077#1087#1086#1076#1072#1074#1072#1090#1077#1083#1077#1081' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1087#1088#1077#1076#1084#1077#1090#1072
          #1055#1088#1086#1074#1077#1089#1090#1080' '#1091#1088#1086#1082#1080' '#1074#1084#1077#1089#1090#1077)
      end
      object Panel6: TPanel
        Left = 8
        Top = 120
        Width = 393
        Height = 169
        TabOrder = 2
        object Panel7: TPanel
          Left = 1
          Top = 1
          Width = 391
          Height = 56
          Align = alTop
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 0
          object Panel8: TPanel
            Left = 1
            Top = 1
            Width = 389
            Height = 54
            Align = alClient
            BevelOuter = bvNone
            BorderWidth = 2
            Caption = 'Panel2'
            Color = 15138790
            TabOrder = 0
            object Label5: TLabel
              Left = 2
              Top = 2
              Width = 3
              Height = 16
              Align = alClient
              Color = 15138790
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              WordWrap = True
            end
          end
        end
        object PagePanel3: TPagePanel
          Left = 1
          Top = 57
          Width = 391
          Height = 111
          ActivePage = spChangeTeacher
          Align = alClient
          object spEmpty: TSheetPanel
            Left = 0
            Top = 0
            Width = 391
            Height = 111
            object Panel11: TPanel
              Left = 0
              Top = 0
              Width = 391
              Height = 111
              Align = alClient
              BevelInner = bvLowered
              BevelOuter = bvNone
              TabOrder = 0
            end
          end
          object spChangeTeacher: TSheetPanel
            Left = 0
            Top = 0
            Width = 391
            Height = 111
            object Panel9: TPanel
              Left = 0
              Top = 0
              Width = 391
              Height = 111
              Align = alClient
              BevelInner = bvLowered
              BevelOuter = bvNone
              TabOrder = 0
              object SuperGrid1: TSuperGrid
                Left = 1
                Top = 1
                Width = 389
                Height = 109
                Align = alClient
                ColCount = 2
                Ctl3D = False
                DefaultRowHeight = 18
                FixedColor = 16752029
                Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goTabs]
                ParentCtl3D = False
                TabOrder = 0
                Columns = <
                  item
                    Caption = #1042#1084#1077#1089#1090#1086
                    DataType = ctString
                    ReadOnly = True
                    RelativeWidth = 100
                  end
                  item
                    Caption = #1044#1086#1083#1078#1077#1085' '#1073#1099#1090#1100
                    DataType = ctString
                    ReadOnly = True
                    RelativeWidth = 100
                  end>
                ColWidths = (
                  193
                  191)
              end
            end
          end
        end
      end
    end
    object spKabinet: TSheetPanel
      Left = 0
      Top = 0
      Width = 413
      Height = 297
      object Panel10: TPanel
        Left = 8
        Top = 120
        Width = 393
        Height = 169
        TabOrder = 0
        object Panel13: TPanel
          Left = 1
          Top = 1
          Width = 391
          Height = 56
          Align = alTop
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 0
          object Panel14: TPanel
            Left = 1
            Top = 1
            Width = 389
            Height = 54
            Align = alClient
            BevelOuter = bvNone
            BorderWidth = 2
            Caption = 'Panel2'
            Color = 15138790
            TabOrder = 0
            object Label6: TLabel
              Left = 2
              Top = 2
              Width = 385
              Height = 50
              Align = alClient
              Color = 15138790
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              WordWrap = True
              ExplicitWidth = 3
              ExplicitHeight = 16
            end
          end
        end
        object PagePanel2: TPagePanel
          Left = 1
          Top = 57
          Width = 391
          Height = 111
          ActivePage = SheetPanel5
          Align = alClient
          object SheetPanel4: TSheetPanel
            Left = 0
            Top = 0
            Width = 391
            Height = 111
            object Panel15: TPanel
              Left = 0
              Top = 0
              Width = 391
              Height = 111
              Align = alClient
              BevelInner = bvLowered
              BevelOuter = bvNone
              TabOrder = 0
            end
          end
          object SheetPanel5: TSheetPanel
            Left = 0
            Top = 0
            Width = 391
            Height = 111
            object Panel16: TPanel
              Left = 0
              Top = 0
              Width = 391
              Height = 111
              Align = alClient
              BevelInner = bvLowered
              BevelOuter = bvNone
              TabOrder = 0
              object SuperGrid2: TSuperGrid
                Left = 1
                Top = 1
                Width = 389
                Height = 109
                Align = alClient
                ColCount = 2
                Ctl3D = False
                DefaultRowHeight = 18
                FixedColor = 16752029
                Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goTabs]
                ParentCtl3D = False
                TabOrder = 0
                Columns = <
                  item
                    Caption = #1042#1084#1077#1089#1090#1086
                    DataType = ctString
                    ReadOnly = True
                    RelativeWidth = 100
                  end
                  item
                    Caption = #1044#1086#1083#1078#1077#1085' '#1073#1099#1090#1100
                    DataType = ctString
                    ReadOnly = True
                    RelativeWidth = 100
                  end>
                ColWidths = (
                  193
                  191)
              end
            end
          end
        end
      end
      object Panel17: TPanel
        Left = 0
        Top = 0
        Width = 413
        Height = 88
        Align = alTop
        BevelInner = bvLowered
        TabOrder = 1
        object Panel18: TPanel
          Left = 2
          Top = 2
          Width = 409
          Height = 84
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 2
          Caption = 'Panel2'
          Color = 15138790
          TabOrder = 0
          object Label7: TLabel
            Left = 2
            Top = 2
            Width = 405
            Height = 80
            Align = alClient
            Caption = 
              #1042#1099' '#1093#1086#1090#1080#1090#1077' '#1087#1086#1089#1090#1072#1074#1080#1090#1100' '#1087#1088#1077#1076#1084#1077#1090' %s. '#1053#1086' '#1082#1072#1073#1080#1085#1077#1090'('#1099') '#1101#1090#1086#1075#1086' '#1087#1088#1077#1076#1084#1077#1090#1072' '#1091#1078#1077 +
              ' '#1079#1072#1085#1103#1090'('#1099') '#1087#1088#1077#1076#1084#1077#1090#1086#1084' %s. '#1042#1099#1073#1077#1088#1080#1090#1077' '#1086#1076#1080#1085' '#1080#1079' '#1074#1072#1088#1080#1072#1085#1090#1086#1074' '#1076#1077#1081#1089#1090#1074#1080#1081'.'
            Color = 15138790
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            WordWrap = True
            ExplicitWidth = 376
            ExplicitHeight = 48
          end
        end
      end
      object ComboBox2: TComboBox
        Left = 10
        Top = 96
        Width = 393
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
        Items.Strings = (
          #1059#1076#1072#1083#1080#1090#1100' '#1087#1072#1088#1072#1083#1083#1077#1083#1100#1085#1099#1081' '#1087#1088#1077#1076#1084#1077#1090
          #1055#1086#1084#1077#1085#1103#1090#1100' '#1082#1072#1073#1080#1085#1077#1090'('#1099') '#1087#1072#1088#1072#1083#1083#1077#1083#1100#1085#1086#1075#1086' '#1087#1088#1077#1076#1084#1077#1090#1072
          #1055#1086#1084#1077#1085#1103#1090#1100' '#1082#1072#1073#1080#1085#1077#1090'('#1099') '#1090#1077#1082#1091#1097#1077#1075#1086' '#1087#1088#1077#1076#1084#1077#1090#1072
          #1055#1088#1086#1074#1077#1089#1090#1080' '#1091#1088#1086#1082#1080' '#1074#1084#1077#1089#1090#1077)
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 297
    Width = 413
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object Button1: TButton
      Left = 240
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 0
    end
    object Button2: TButton
      Left = 320
      Top = 8
      Width = 75
      Height = 25
      Caption = #1044#1072#1083#1077#1077' >'
      TabOrder = 1
    end
  end
end
