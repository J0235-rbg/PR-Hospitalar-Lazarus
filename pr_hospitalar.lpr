program ProjetoHospital;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMSI}
  Interfaces, // necessário para o LCL
  {$ENDIF}
  Forms, unit_principal, Interfaces,
unit_triagem, unit_fila; // O nome aqui deve ser o nome da sua unit

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  // Aqui ele cria o formulário principal
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmTriagem, frmTriagem);
  Application.CreateForm(TfrmFilaMedica, frmFilaMedica);
  Application.Run;
end.
