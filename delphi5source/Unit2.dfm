object Form2: TForm2
  Left = 102
  Top = 69
  Width = 309
  Height = 301
  Caption = 'Inpact: method selector'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
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
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 57
    Top = 0
    Width = 3
    Height = 274
    Cursor = crHSplit
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 57
    Height = 274
    Align = alLeft
    Caption = 'Libraries'
    TabOrder = 0
    object lib_list: TFileListBox
      Left = 2
      Top = 15
      Width = 53
      Height = 257
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnChange = lib_listChange
    end
  end
  object GroupBox2: TGroupBox
    Left = 60
    Top = 0
    Width = 241
    Height = 274
    Align = alClient
    Caption = 'Methods'
    TabOrder = 1
    object Panel1: TPanel
      Left = 2
      Top = 15
      Width = 237
      Height = 26
      Align = alTop
      BevelOuter = bvNone
      Constraints.MinWidth = 136
      TabOrder = 0
      object select_but: TButton
        Left = 8
        Top = 0
        Width = 57
        Height = 25
        Caption = 'Select'
        TabOrder = 0
        OnClick = select_butClick
      end
      object done_but: TButton
        Left = 72
        Top = 0
        Width = 57
        Height = 25
        Caption = 'Done'
        Default = True
        TabOrder = 1
        OnClick = done_butClick
      end
    end
    object meth_list: TListBox
      Left = 2
      Top = 41
      Width = 237
      Height = 231
      Align = alClient
      Constraints.MinHeight = 30
      ItemHeight = 13
      TabOrder = 1
      OnDblClick = meth_listDblClick
    end
  end
end
