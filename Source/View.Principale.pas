unit View.Principale;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TEdit = class(Vcl.StdCtrls.TEdit)
  public
    function ToText: string;
  end;

  TCreaIntefaceClasseView = class(TForm)
    mmoInterface: TMemo;
    lblInterface: TLabel;
    mmoClasse: TMemo;
    btnInterfaceCreaClasse: TButton;
    btnDaCampiClasseEInterface: TButton;
    mmoVariabile: TMemo;
    lblVariabile: TLabel;
    edtInterface: TEdit;
    lblClasse: TLabel;
    lblInterface1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnInterfaceCreaClasseClick(Sender: TObject);
    procedure btnDaCampiClasseEInterfaceClick(Sender: TObject);
  end;

var
  CreaIntefaceClasseView: TCreaIntefaceClasseView;

implementation

uses
  System.StrUtils,
  Spring.Collections,
  Spring;

{$R *.dfm}

procedure TCreaIntefaceClasseView.FormCreate(Sender: TObject);
begin
  btnInterfaceCreaClasse.Enabled := False;
end;

procedure TCreaIntefaceClasseView.btnInterfaceCreaClasseClick(Sender: TObject);
var
  Da: IList<string>;
  ListaInterface: IList<string>;
  ListaNomeClasse: IList<string>;
  ListaNomeVariabile: IList<string>;
  MetodoNew: string;
  NomeClasse: string;
  NomeInterface: string;
  NomeMetodo: string;
  NomeVariabile: string;
  ParteImplementation: Shared<TStringBuilder>;
  ParteInterface: Shared<TStringBuilder>;
  ParteInterfacePublic: Shared<TStringBuilder>;
  ParteInterfaceStrictPrivate: Shared<TStringBuilder>;
  Riga: string;
  xx: string;
begin
  Da := TCollections.CreateList<string>;
  Da.AddRange(mmoInterface.Lines.ToStringArray);
  ParteInterface := TStringBuilder.Create;
  ParteInterface.Value.AppendLine('type');
  ParteInterfaceStrictPrivate := TStringBuilder.Create;
  ParteInterfaceStrictPrivate.Value.Append('  ').Append('strict private').AppendLine;
  ParteInterfacePublic := TStringBuilder.Create;
  ParteInterfacePublic.Value.Append('  ').Append('public').AppendLine;
  ParteImplementation := TStringBuilder.Create;

  for Riga in Da do
  begin
    if Riga.Contains('IInterface') then
    begin
      ListaNomeClasse := TCollections.CreateList<string>;
      ListaNomeClasse.AddRange(Riga.Split(['=']));
      NomeClasse := Format('T%s', [ListaNomeClasse.First.Trim.Remove(0, 1).Trim]);
      NomeInterface := Format('I%s', [ListaNomeClasse.First.Trim.Remove(0, 1).Trim]);
      ParteInterface.Value.Append('  ').Append(NomeClasse).AppendFormat(' = class sealed(TInterfacedObject, %s', [NomeInterface]).Append(')').AppendLine;
    end;

    if Riga.Trim.StartsWith('function') then
    begin
      ListaNomeVariabile := TCollections.CreateList<string>;
      ListaNomeVariabile.AddRange(Riga.Trim.Split([' ', '(']));
      NomeVariabile := Format('F%s', [ListaNomeVariabile[1]]);

      ParteInterfacePublic.Value.AppendLine(Riga);
      NomeMetodo := Format('function %s.%s', [NomeClasse, Riga.Trim]);
      ParteImplementation.Value.Append(NomeMetodo.Replace('.function ', '.').Replace('overload;', EmptyStr).Trim).AppendLine;

      ParteImplementation.Value.AppendLine('begin')
                               .Append('  ');

      if Riga.Contains('(') then
      begin
        ParteImplementation.Value.AppendLine('Result := Self;')
                                 .Append('  ').AppendFormat('%s := Value;', [NomeVariabile.Replace(':', EmptyStr)]).AppendLine;
      end
      else
      begin
        ParteInterfaceStrictPrivate.Value.Append('    ').Append(NomeVariabile).Append(' ').Append(ListaNomeVariabile[2]).AppendLine;
        ParteImplementation.Value.AppendFormat('Result := %s;', [NomeVariabile.Replace(':', EmptyStr)]).AppendLine;
      end;

      ParteImplementation.Value.AppendLine('end;').AppendLine;
    end;
  end;

  ParteInterfacePublic.Value.Append('    ').AppendFormat('class function New: %s;', [NomeInterface]).AppendLine;
  ParteInterfacePublic.Value.AppendLine('  end;').AppendLine
                            .AppendLine('implementation');
  ParteImplementation.Value.AppendFormat('class function %s.New: %s;', [NomeClasse, NomeInterface]).AppendLine
                           .AppendLine('begin')
                           .Append('  ').AppendLine('Result := Self.Create;')
                           .AppendLine('end;').AppendLine;
  ParteImplementation.Value.Append('end.');

  mmoClasse.Lines.Text := ParteInterface.Value.ToString;
  mmoClasse.Lines.Append(ParteInterfaceStrictPrivate.Value.ToString);
  mmoClasse.Lines.Append(ParteInterfacePublic.Value.ToString);
  mmoClasse.Lines.Append(ParteImplementation.Value.ToString);
end;

procedure TCreaIntefaceClasseView.btnDaCampiClasseEInterfaceClick(Sender: TObject);
var
  Classe: IList<string>;
  DictionaryVariabile: IDictionary<string, string>;
  Interfaci: IList<string>;
  NomeClasse: string;
  NomeInterface: string;
  Parte: IList<string>;
  Riga: string;
  TmpFunctionGet: string;
  TmpFunctionSet: string;
  VariabileOrdenate: TArray<string>;
begin
  DictionaryVariabile := TCollections.CreateDictionary<string, string>;
  Interfaci := TCollections.CreateList<string>;
  Classe := TCollections.CreateList<string>;
  Parte := TCollections.CreateList<string>;

  NomeInterface := edtInterface.ToText.Trim;
  NomeClasse := Format('T%s', [NomeInterface.Remove(0, 1)]).Trim;

  for Riga in mmoVariabile.Lines.ToStringArray do
  begin
    Parte.Clear;
    Parte.AddRange(Riga.Split([':']));
    DictionaryVariabile.Add(Parte.First.Trim, Parte.Last.Trim.Replace(';', EmptyStr));
  end;

  Interfaci.AddRange(['interface', EmptyStr]);
  Interfaci.Add('type');
  Interfaci.Add(Format('  %s = interface (IInterface)', [NomeInterface]));
  Interfaci.Add(Format('  [''%s'']', [TGUID.NewGuid.ToString]));

  Classe.AddRange(['interface', EmptyStr]);
  Classe.Add('type');
  Classe.Add(Format('  %s = class sealed(TInterfacedObject, %s)', [NomeClasse, NomeInterface]));
  Classe.Add('  strict private');

  for Riga in DictionaryVariabile.Keys.Ordered do
    Classe.Add(Format('    %s: %s;', [Riga, DictionaryVariabile[Riga]]));

  Classe.Add('  public');
  Classe.Add('    constructor Create;');
  Classe.Add('    destructor Destroy; override;');
  Classe.Add(Format('    class function New: %s;', [NomeInterface]));

  for Riga in DictionaryVariabile.Keys.Ordered do
  begin
    TmpFunctionGet := Format('    function %s: %s; overload;', [Riga.Remove(0, 1), DictionaryVariabile[Riga]]);
    TmpFunctionSet := Format('    function %s(Value: %s): %s; overload;', [Riga.Remove(0, 1), DictionaryVariabile[Riga], NomeInterface]);

    Interfaci.Add(TmpFunctionGet);
    Interfaci.Add(TmpFunctionSet);

    Classe.Add(TmpFunctionGet);
    Classe.Add(TmpFunctionSet);
  end;

  Classe.AddRange(['  end;', EmptyStr]);
  Classe.AddRange(['implementation', EmptyStr]);

  Classe.Add(Format('constructor %s.Create;', [NomeClasse]));
  Classe.AddRange(['begin', '  inherited;', 'end;', EmptyStr]);

  Classe.Add(Format('destructor %s.Destroy;', [NomeClasse]));
  Classe.AddRange(['begin', '  inherited;', 'end;', EmptyStr]);

  Classe.Add(Format('class function %s.New;', [NomeClasse]));
  Classe.AddRange(['begin', '  Result := Self.Create;', 'end;', EmptyStr]);

  for Riga in DictionaryVariabile.Keys.Ordered do
  begin
    Classe.Add(Format('function %s.%s: %s;', [NomeClasse, Riga.Remove(0, 1), DictionaryVariabile[Riga]]));
    Classe.AddRange(['begin', Format('  Result := %S;', [Riga]), 'end;', EmptyStr]);

    Classe.Add(Format('function %s.%s(Value: %s): %s;', [NomeClasse, Riga.Remove(0, 1), DictionaryVariabile[Riga], NomeInterface]));
    Classe.AddRange(['begin', '  Result := Self;', Format('  %s := Value;', [Riga]), 'end;', EmptyStr]);
  end;

  Interfaci.AddRange(['  end;', EmptyStr, 'implementation', EmptyStr, 'end.']);

  Classe.Add('end.');

  mmoInterface.Lines.Clear;
  mmoClasse.Lines.Clear;

  for Riga in Interfaci do
  begin
    mmoInterface.Lines.Add(Riga);
  end;

  for Riga in Classe do
  begin
    mmoClasse.Lines.Add(Riga);
  end;
end;

function TEdit.ToText: string;
begin
  Result := Self.Text;
end;

end.
