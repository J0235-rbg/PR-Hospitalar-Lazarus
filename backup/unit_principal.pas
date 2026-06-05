unit unit_principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls,
  ZConnection;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    menuPacientes: TMenuItem;
    menuMedicos: TMenuItem;
    MenuItem2: TMenuItem;
    menuAgenda: TMenuItem;
    MenuItem4: TMenuItem;
    menuSair: TMenuItem;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    btnPacientes: TToolButton;
    btnMedicos: TToolButton;
    btnSair: TToolButton;
    Zconexao: TZConnection;
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure menuAgendaClick(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure ZconexaoAfterConnect(Sender: TObject);
  private

  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation
uses unit_dados, unit_triagem, unit_fila;

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.btnSairClick(Sender: TObject);
begin
  if MessageDlg('Sair', 'Deseja realmente fechar o sistema?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    Application.Terminate;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin

end;

procedure TfrmPrincipal.menuAgendaClick(Sender: TObject);
begin
  begin
    Application.CreateForm(TfrmFilaMedica, frmFilaMedica);
    try
      frmFilaMedica.ShowModal;
    finally
      frmFilaMedica.Free;
    end;

end;


procedure TfrmPrincipal.ZconexaoAfterConnect(Sender: TObject);
begin

end;

end.
