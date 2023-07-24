program CreaClasse;

uses
  Vcl.Forms,
  View.Principale in 'Source\View.Principale.pas' {CreaIntefaceClasseView};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TCreaIntefaceClasseView, CreaIntefaceClasseView);
  Application.Run;
end.
