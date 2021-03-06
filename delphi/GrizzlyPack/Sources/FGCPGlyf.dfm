object DlgGlyph: TDlgGlyph
  Left = 291
  Top = 349
  HorzScrollBar.Visible = False
  VertScrollBar.Increment = 30
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Choix d'#39'un bouton'
  ClientHeight = 366
  ClientWidth = 689
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object LabelFiltrer: TLabel
    Left = 276
    Top = 307
    Width = 33
    Height = 16
    Alignment = taRightJustify
    Caption = 'Filtrer'
  end
  object BtnFinal: TBitBtn
    Left = 144
    Top = 300
    Width = 125
    Height = 61
    Caption = 'Choix final'
    Default = True
    ModalResult = 1
    TabOrder = 0
    NumGlyphs = 2
    Spacing = -1
  end
  object BtnCancel: TBitBtn
    Left = 272
    Top = 332
    Width = 121
    Height = 29
    TabOrder = 1
    Kind = bkCancel
  end
  object BtnNext: TBitBtn
    Left = 4
    Top = 332
    Width = 137
    Height = 29
    Caption = 'Page suivante'
    TabOrder = 2
    OnClick = BtnNextClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      33333FF3333333333333447333333333333377FFF33333333333744473333333
      333337773FF3333333333444447333333333373F773FF3333333334444447333
      33333373F3773FF3333333744444447333333337F333773FF333333444444444
      733333373F3333773FF333334444444444733FFF7FFFFFFF77FF999999999999
      999977777777777733773333CCCCCCCCCC3333337333333F7733333CCCCCCCCC
      33333337F3333F773333333CCCCCCC3333333337333F7733333333CCCCCC3333
      333333733F77333333333CCCCC333333333337FF7733333333333CCC33333333
      33333777333333333333CC333333333333337733333333333333}
    Layout = blGlyphRight
    NumGlyphs = 2
  end
  object BtnPrior: TBitBtn
    Left = 4
    Top = 300
    Width = 137
    Height = 29
    Caption = 'Page pr'#233'c'#233'dente'
    TabOrder = 3
    OnClick = BtnPriorClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333FF3333333333333744333333333333F773333333333337
      44473333333333F777F3333333333744444333333333F7733733333333374444
      4433333333F77333733333333744444447333333F7733337F333333744444444
      433333F77333333733333744444444443333377FFFFFFF7FFFFF999999999999
      9999733777777777777333CCCCCCCCCC33333773FF333373F3333333CCCCCCCC
      C333333773FF3337F333333333CCCCCCC33333333773FF373F3333333333CCCC
      CC333333333773FF73F33333333333CCCCC3333333333773F7F3333333333333
      CCC333333333333777FF33333333333333CC3333333333333773}
    NumGlyphs = 2
  end
  object DirListBox: TDirectoryListBox
    Left = 524
    Top = 4
    Width = 161
    Height = 209
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 4
    OnChange = DirListBoxChange
  end
  object DriveComboBox1: TDriveComboBox
    Left = 524
    Top = 216
    Width = 161
    Height = 22
    DirList = DirListBox
    TabOrder = 5
  end
  object CBEnglish: TCheckBox
    Left = 524
    Top = 240
    Width = 125
    Height = 17
    Caption = 'English version'
    TabOrder = 6
    OnClick = CBEnglishClick
  end
  object PanelAbout: TPanel
    Left = 4
    Top = 4
    Width = 385
    Height = 145
    BorderWidth = 2
    TabOrder = 7
    Visible = False
    object Memo1: TMemo
      Left = 3
      Top = 3
      Width = 379
      Height = 97
      Align = alClient
      Alignment = taCenter
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Times New Roman'
      Font.Style = []
      Lines.Strings = (
        'Glyph property editor'
        ''
        'GrizzlyPack')
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 3
      Top = 100
      Width = 379
      Height = 42
      Align = alBottom
      BevelOuter = bvLowered
      TabOrder = 1
      OnResize = Panel1Resize
      object BtnCloseAbout: TBitBtn
        Left = 241
        Top = 4
        Width = 93
        Height = 33
        Caption = '&Fermer'
        TabOrder = 0
        OnClick = BtnCloseAboutClick
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00388888888877
          F7F787F8888888888333333F37004444400888FFF444448888888888F333FF8F
          000033334D5007FFF4333388888888883338888F3337333345D50FFFF4333333
          338F888F3338F33F73F333334D5D0FFFF43333333388788F3338F33F99903333
          45D50FEFE4333333338F878F3338F33F003333334D5D0FFFF43333333388788F
          3338F33F3373333345D50FEFE4333333338F878F3338F33F373333334D5D0FFF
          F43333333388788F3338F33FAAAA333345D50FEFE4333333338F878F3338F33F
          300033334D5D0EFEF43333333388788F3338F33F3777333345D50FEFE4333333
          338F878F3338F33F333333334D5D0EFEF43333333388788F3338F33F00A03333
          4444444444333333338F8F8FFFF8F33F544C3333333333333333333333888888
          8888333F55553333330000003333333333333FFFFFF3333F577F3333330AAAA0
          333333333333888888F3333F77F53333330000003333333333338FFFF8F3333F
          C333}
        NumGlyphs = 2
      end
    end
  end
  object BtnAbout: TBitBtn
    Left = 396
    Top = 332
    Width = 121
    Height = 29
    Caption = 'A propos...'
    TabOrder = 8
    OnClick = BtnAboutClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      0400000000000001000000000000000000001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333FFFFF3333333333F797F3333333333F737373FF333333BFB999BFB
      33333337737773773F3333BFBF797FBFB33333733337333373F33BFBFBFBFBFB
      FB3337F33333F33337F33FBFBFB9BFBFBF3337333337F333373FFBFBFBF97BFB
      FBF37F333337FF33337FBFBFBFB99FBFBFB37F3333377FF3337FFBFBFBFB99FB
      FBF37F33333377FF337FBFBF77BF799FBFB37F333FF3377F337FFBFB99FB799B
      FBF373F377F3377F33733FBF997F799FBF3337F377FFF77337F33BFBF99999FB
      FB33373F37777733373333BFBF999FBFB3333373FF77733F7333333BFBFBFBFB
      3333333773FFFF77333333333FBFBF3333333333377777333333}
    NumGlyphs = 2
  end
  object RGButtons: TRadioGroup
    Left = 524
    Top = 260
    Width = 161
    Height = 101
    Caption = 'Boutons (LxH)'
    Columns = 2
    ItemIndex = 1
    Items.Strings = (
      '6x10'
      '4x10'
      '2x10'
      '6x5'
      '4x5'
      '2x5')
    TabOrder = 9
    OnClick = RGButtonsClick
  end
  object EditFiltrer: TEdit
    Left = 316
    Top = 303
    Width = 201
    Height = 24
    TabOrder = 10
    OnChange = EditFiltrerChange
  end
end
