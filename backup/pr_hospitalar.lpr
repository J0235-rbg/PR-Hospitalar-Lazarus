program ProjetoHospital;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMSI}
  Interfaces,
  {$ENDIF}
  Forms, Interfaces, unit_principal, unit_triagem, unit_fila, unit_dados;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;

  // Deixamos apenas as telas visuais normais aqui. O dmDados FOI REMOVIDO daqui!
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
