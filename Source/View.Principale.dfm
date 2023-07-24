object CreaIntefaceClasseView: TCreaIntefaceClasseView
  Left = 0
  Top = 0
  Caption = 'Crea interface e classe'
  ClientHeight = 659
  ClientWidth = 1437
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  WindowState = wsMaximized
  OnCreate = FormCreate
  DesignSize = (
    1437
    659)
  TextHeight = 13
  object lblInterface: TLabel
    Left = 8
    Top = 344
    Width = 45
    Height = 13
    Caption = 'Interface'
  end
  object lblVariabile: TLabel
    Left = 8
    Top = 51
    Width = 40
    Height = 13
    Caption = 'Variabile'
  end
  object lblClasse: TLabel
    Left = 680
    Top = 8
    Width = 31
    Height = 13
    Caption = 'Classe'
  end
  object lblInterface1: TLabel
    Left = 8
    Top = 27
    Width = 45
    Height = 13
    Caption = 'Interface'
  end
  object mmoInterface: TMemo
    Left = 8
    Top = 360
    Width = 585
    Height = 291
    Lines.Strings = (
      'IMiaInterface = interface(IInterface)'
      '    function Id: Integer; overload;'
      '    function Id(Value: Integer): IMiaInterface; overload;'
      '    function Nome: string; overload;'
      '    function Nome(Value: string): IMiaInterface; overload;'
      '  end;')
    TabOrder = 4
    WordWrap = False
  end
  object mmoClasse: TMemo
    Left = 680
    Top = 24
    Width = 749
    Height = 627
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssBoth
    TabOrder = 2
    ExplicitWidth = 743
    ExplicitHeight = 618
  end
  object btnInterfaceCreaClasse: TButton
    Left = 599
    Top = 360
    Width = 75
    Height = 49
    Caption = 'Da interface crea classe'
    TabOrder = 5
    WordWrap = True
    OnClick = btnInterfaceCreaClasseClick
  end
  object btnDaCampiClasseEInterface: TButton
    Left = 599
    Top = 66
    Width = 75
    Height = 49
    Caption = 'Da campi crea classe e interface'
    TabOrder = 3
    WordWrap = True
    OnClick = btnDaCampiClasseEInterfaceClick
  end
  object mmoVariabile: TMemo
    Left = 8
    Top = 66
    Width = 585
    Height = 273
    Lines.Strings = (
      'FId: Integer;'
      'FNome: string;')
    TabOrder = 1
    WordWrap = False
  end
  object edtInterface: TEdit
    Left = 59
    Top = 24
    Width = 534
    Height = 21
    TabOrder = 0
    Text = 'IMiaInterface'
  end
end
