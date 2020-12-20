object Form1: TForm1
  Left = 124
  Top = 71
  Width = 337
  Height = 413
  Caption = 'Inpact'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000BBB00000000000BB000B0000000000CF0000B00000000CFF
    9000B00000000FF99000B00000000F99C000B0000000099CC000B000000009CC
    F000B00000000CCFF000B00000000CFF9000B00000000FF9900B000000000F99
    C00B00000000099CC00B0000000009CCF00B000000000CCFF00B00000000FFFF
    0000F1FF0000CEFF0000CF7F0000877F0000877F0000877F0000877F0000877F
    0000877F0000877F000086FF000086FF000086FF000086FF000086FF0000}
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 170
    Width = 329
    Height = 2
    Cursor = crVSplit
    Align = alTop
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 329
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object GroupBox4: TGroupBox
      Left = 0
      Top = 0
      Width = 40
      Height = 33
      Align = alLeft
      Caption = 'Stage'
      TabOrder = 0
      object stage_selector: TComboBox
        Left = 0
        Top = 13
        Width = 40
        Height = 21
        DropDownCount = 13
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        MaxLength = 2
        ParentFont = False
        TabOrder = 0
        Text = '4'
        OnChange = stage_selectorChange
        Items.Strings = (
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12'
          '13'
          '14'
          '15'
          '16')
      end
    end
    object GroupBox5: TGroupBox
      Left = 40
      Top = 0
      Width = 289
      Height = 33
      Align = alClient
      Caption = 'Title'
      TabOrder = 1
      object title_win: TMemo
        Left = 2
        Top = 15
        Width = 285
        Height = 16
        Align = alClient
        BorderStyle = bsNone
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          'New touch')
        ParentFont = False
        TabOrder = 0
        WantReturns = False
        OnChange = title_winChange
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 33
    Width = 329
    Height = 137
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 1
    object Splitter2: TSplitter
      Left = 153
      Top = 0
      Width = 2
      Height = 137
      Cursor = crHSplit
    end
    object GroupBox2: TGroupBox
      Left = 0
      Top = 0
      Width = 153
      Height = 137
      Align = alLeft
      Caption = 'Music'
      TabOrder = 0
      object music_win: TRichEdit
        Left = 2
        Top = 15
        Width = 149
        Height = 120
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Fixedsys'
        Font.Style = []
        Constraints.MinHeight = 50
        Constraints.MinWidth = 50
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        OnChange = music_winChange
        OnMouseDown = music_winMouseDown
      end
    end
    object GroupBox3: TGroupBox
      Left = 155
      Top = 0
      Width = 174
      Height = 137
      Align = alClient
      Caption = 'Report'
      TabOrder = 1
      object report_win: TRichEdit
        Left = 2
        Top = 15
        Width = 170
        Height = 120
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Constraints.MinHeight = 50
        Constraints.MinWidth = 50
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object main: TRichEdit
    Left = 0
    Top = 172
    Width = 329
    Height = 187
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Fixedsys'
    Font.Pitch = fpFixed
    Font.Style = []
    Constraints.MinHeight = 50
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 2
    WordWrap = False
    OnChange = mainChange
    OnKeyUp = mainKeyDown
    OnMouseDown = mainMouseDown
  end
  object MainMenu1: TMainMenu
    Left = 304
    Top = 65528
    object File1: TMenuItem
      Caption = '&File'
      object New1: TMenuItem
        Caption = '&New'
        OnClick = New1Click
      end
      object Open1: TMenuItem
        Caption = '&Open...'
        OnClick = Open1Click
      end
      object Save1: TMenuItem
        Caption = '&Save'
        ShortCut = 16467
        OnClick = Save1Click
      end
      object SaveAs1: TMenuItem
        Caption = 'Save &As...'
        OnClick = SaveAs1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Print1: TMenuItem
        Caption = '&Print...'
        OnClick = Print1Click
      end
      object PrintSetup1: TMenuItem
        Caption = 'P&rint Setup...'
        OnClick = PrintSetup1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      object Undo1: TMenuItem
        Action = EditUndo1
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Cut1: TMenuItem
        Action = EditCut1
      end
      object Copy1: TMenuItem
        Action = EditCopy1
      end
      object Paste1: TMenuItem
        Action = EditPaste1
      end
      object SelectAll1: TMenuItem
        Action = EditSelectAll1
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Font1: TMenuItem
        Caption = '&Font'
        OnClick = Font1Click
      end
    end
    object Music1: TMenuItem
      Caption = '&Music'
      object New2: TMenuItem
        Caption = '&New'
        OnClick = New2Click
      end
      object Open2: TMenuItem
        Caption = '&Open...'
        OnClick = Open2Click
      end
      object SaveAs2: TMenuItem
        Caption = 'Save &As...'
        OnClick = SaveAs2Click
      end
    end
    object t1: TMenuItem
      Caption = '&Touch'
      object RunRightclick1: TMenuItem
        Caption = '&Prove (right click)'
        ShortCut = 120
        OnClick = RunRightclick1Click
      end
      object OpenCloseBlockdoubleclick1: TMenuItem
        Caption = '&Expand/Collapse (double click)'
        ShortCut = 119
        OnClick = OpenCloseBlockdoubleclick1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Insertmethod1: TMenuItem
        Caption = 'Insert method'
        ShortCut = 116
        OnClick = Insertmethod1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object Contents1: TMenuItem
        Action = HelpContents1
        Enabled = False
      end
      object About1: TMenuItem
        Caption = '&About...'
        OnClick = About1Click
      end
    end
  end
  object ActionList1: TActionList
    Left = 233
    Top = 65528
    object EditCopy1: TEditCopy
      Category = 'Edit'
      Caption = '&Copy'
      Hint = 'Copy'
      ImageIndex = 1
      ShortCut = 16451
    end
    object EditCut1: TEditCut
      Category = 'Edit'
      Caption = 'Cu&t'
      Hint = 'Cut'
      ImageIndex = 0
      ShortCut = 16472
    end
    object EditPaste1: TEditPaste
      Category = 'Edit'
      Caption = '&Paste'
      Hint = 'Paste'
      ImageIndex = 2
      ShortCut = 16470
    end
    object EditUndo1: TEditUndo
      Category = 'Edit'
      Caption = '&Undo'
      ImageIndex = 3
      ShortCut = 32776
    end
    object HelpContents1: THelpContents
      Category = 'Help'
      Caption = '&Contents'
      ShortCut = 112
    end
    object EditSelectAll1: TEditSelectAll
      Category = 'Edit'
      Caption = 'Select &All'
    end
  end
  object OpenDialog_music: TOpenDialog
    Left = 265
    Top = 65528
  end
  object SaveDialog_music: TSaveDialog
    Left = 201
    Top = 65528
  end
  object PrintDialog1: TPrintDialog
    Options = [poPrintToFile]
    Left = 161
    Top = 65528
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 129
    Top = 65528
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'inp'
    Filter = 'Inpact Files (*.inp)|*.inp'
    Left = 364
    Top = 65528
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'inp'
    Filter = 'Inpact Files (*.inp)|*.inp'
    Left = 404
    Top = 65528
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Left = 440
    Top = 65528
  end
end
