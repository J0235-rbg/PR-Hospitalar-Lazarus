program ProjetoHospital;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMSI}
  Interfaces,
  {$ENDIF}
  Forms, Controls, Interfaces, unit_principal, unit_triagem, unit_fila, unit_dados,
unit_login, unit_pacientes, unit_usuarios;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;

  // Deixamos apenas as telas visuais normais aqui. O dmDados FOI REMOVIDO daqui!
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmLogin, FormLogin);

  // O Porteiro: Abre a tela de login e trava o sistema.
  // Se o resultado for "mrOk" (Senha Certa), ele roda o hospital.
  if FormLogin.ShowModal = mrOk then
  begin
  Application.CreateForm(TfrmPacientes, frmPacientes);
  Application.CreateForm(TfrmUsuarios, frmUsuarios);
    Application.Run;
  end;
end.
