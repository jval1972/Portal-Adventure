object ConfigForm: TConfigForm
  Left = 930
  Top = 61
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'The hunt for Dr. Freak'
  ClientHeight = 258
  ClientWidth = 330
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000001110000011910000000000000000000199910000999900000000000000
    0000019991000099991000000000000000000199954444599910000000000000
    00000195CCCCCCCC59100100000000000090004CCCCCCCCCC400090000000000
    009104CCCCCCCCCCCC4019000000000000910CCCCCCCCCCCCC40190000000000
    00110CCCCCCCCCCCCCC0900000000000004C4CCCCCCCCCCCCC44C40000000000
    000CC4CCCCCCCCCCCC4CC00000000000000CC4CCCCCCCCCCCC4CC00000000000
    0004CCCCCCCCCCCCCC4CC000000000000004CCCCCCCCCCCCCC4C400000000000
    0000CCCCCCCCCCCCC4CC40000000000000004CCCCCCCCCCCCCC4000000000000
    000000CCCCCCCCCCCC4000000000000000000004CCCCCCCCC400000000000000
    000000004CCCCCCCC000000000000000000000004CCCCCCC0000000000000000
    0000000004CCCC40000000000000000000000000222AA2220000000000000000
    00000000AAAAAAAA000000000000000000000002AAAAAAAA0000000000000000
    00000002AAAAAAAA000000000000000000000002AAAAAAAA0000000000000000
    00000002AAAAAAAA000000000000000000000000AAAAAAAA0000000000000000
    00000000AAAAAAA20000000000000000000000002AAAAAA00000000000000000
    000000000AAAAA20000000000000000000000000022AA200000000000000FF83
    C1FFFF83C1FFFF83C1FFFF8001FFFF80013FFC80013FFC80013FFC80013FFC00
    003FFC00003FFE00003FFE00007FFE00007FFE00007FFE00007FFF0000FFFF80
    01FFFFC003FFFFE003FFFFF007FFFFF80FFFFFF00FFFFFE00FFFFFE007FFFFE0
    07FFFFE007FFFFE007FFFFE00FFFFFF00FFFFFF00FFFFFF01FFFFFF83FFF}
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 32
    Width = 90
    Height = 13
    Caption = 'Screen resolution: '
    FocusControl = ComboBox1
  end
  object ComboBox1: TComboBox
    Left = 152
    Top = 32
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object CheckBox1: TCheckBox
    Left = 32
    Top = 80
    Width = 97
    Height = 17
    Caption = 'Fullscreen'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object CheckBox2: TCheckBox
    Left = 32
    Top = 112
    Width = 97
    Height = 17
    Caption = 'Low resolution'
    TabOrder = 2
    Visible = False
  end
  object Button1: TButton
    Left = 24
    Top = 208
    Width = 273
    Height = 25
    Cancel = True
    Caption = 'Play!'
    Default = True
    ModalResult = 1
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 168
    Top = 232
    Width = 113
    Height = 25
    Caption = 'Visit homepage!'
    TabOrder = 6
    Visible = False
    OnClick = Button2Click
  end
  object RadioGroup1: TRadioGroup
    Left = 168
    Top = 72
    Width = 121
    Height = 105
    Caption = '      '
    ItemIndex = 0
    Items.Strings = (
      'Beginner'
      'Easy'
      'Medium'
      'Hard')
    TabOrder = 4
  end
  object CheckBox3: TCheckBox
    Left = 182
    Top = 71
    Width = 73
    Height = 17
    Caption = ' Autostart '
    TabOrder = 3
  end
  object XPManifest1: TXPManifest
    Left = 32
    Top = 152
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'dem'
    Filter = 'Demo Files (*.dem)|*.dem|All Files (*.*)|*.*'
    InitialDir = '.'
    Options = [ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 120
    Top = 152
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'dem'
    Filter = 'Demo Files (*.dem)|*.dem|All Files (*.*)|*.*'
    InitialDir = '.'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 200
    Top = 152
  end
end
