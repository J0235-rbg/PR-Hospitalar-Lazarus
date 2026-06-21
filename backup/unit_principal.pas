unit unit_principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls,
  DBGrids, DBCtrls, ZConnection, ZDataset, unit_pacientes, unit_dados, unit_triagem,
  unit_fila, unit_usuarios, unit_medicos;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    MainMenu1: TMainMenu;
    menuAtendimentos: TMenuItem;
    menuTriagem: TMenuItem;
    menuPacientes: TMenuItem;
    menuMedicos: TMenuItem;
    menuUsuarios: TMenuItem;
    menuSistema: TMenuItem;
    menuCadastros: TMenuItem;
    menuTrocarUsuario: TMenuItem;
    MenuItem2: TMenuItem;
    menuAgenda: TMenuItem;
    menuSair: TMenuItem;
    StatusBar1: TStatusBar;
    StatusBar2: TStatusBar;
    ToolBar1: TToolBar;
    procedure btnPacientesClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure menuAgendaClick(Sender: TObject);
    procedure menuCadastrosClick(Sender: TObject);
    procedure menuPacientesClick(Sender: TObject);
    procedure menuTriagemClick(Sender: TObject);
    procedure menuUsuariosClick(Sender: TObject);
    procedure ZconexaoAfterConnect(Sender: TObject);
  private

  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.btnSairClick(Sender: TObject);
begin
  if MessageDlg('Sair', 'Deseja realmente fechar o sistema?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    Application.Terminate;
end;

procedure TfrmPrincipal.DataSource1DataChange(Sender: TObject; Field: TField);
begin

end;

procedure TfrmPrincipal.DBNavigator1Click(Sender: TObject;
  Button: TDBNavButtonType);
begin

end;

procedure TfrmPrincipal.btnPacientesClick(Sender: TObject);
begin
  // 1. Verifica se a tela ainda não existe na memória
  if frmTriagem = nil then
    Application.CreateForm(TfrmTriagem, frmTriagem);

  // 2. Agora que temos certeza que ela existe, abrimos a porta
  frmTriagem.ShowModal;
end;
procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  // 1. ENGENHARIA DINÂMICA: Constrói a Casa de Máquinas direto na memória
  if not Assigned(dmDados) then
    dmDados := TdmDados.Create(Application);

  try
    // 2. Força a soldagem do adaptador na válvula do subsolo
    DataSource1.DataSet := dmDados.zqryGeral;

    // 3. Prepara o comando SQL e abre a válvula
    dmDados.zqryGeral.Close;
    dmDados.zqryGeral.SQL.Text := 'SELECT * FROM pacientes;';
    dmDados.zqryGeral.Open;
  except
    on E: Exception do
      ShowMessage('Erro ao inicializar conexão dinâmica: ' + E.Message);
  end;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  // 1. O Rodapé de Auditoria: Mostra quem está logado no sistema
  StatusBar1.SimplePanel := True; // Ativa o modo de texto simples no rodapé
  StatusBar1.SimpleText := '  Usuário Logado (Perfil): ' + vUsuarioLogadoPerfil;

  // 2. A Catraca de Segurança (RBAC)
  if vUsuarioLogadoPerfil = 'Enfermeiro' then
  begin
    // Bloqueia acessos sensíveis para a enfermagem
    menuUsuarios.Visible := False;
    menuMedicos.Visible := False; // Opcional: Enfermeiro geralmente não cadastra médicos
  end
  else if vUsuarioLogadoPerfil = 'Administrador' then
  begin
    // Libera o cofre todo para o Admin
    menuUsuarios.Visible := True;
    menuMedicos.Visible := True;
  end;
end;

procedure TfrmPrincipal.menuAgendaClick(Sender: TObject);
begin
  Application.CreateForm(TfrmFilaMedica, frmFilaMedica);
  try
    frmFilaMedica.ShowModal;
  finally
    frmFilaMedica.Free;
  end;
end; // Corrigido o fechamento aqui!

procedure TfrmPrincipal.menuCadastrosClick(Sender: TObject);
begin

end;

procedure TfrmPrincipal.menuPacientesClick(Sender: TObject);
begin
  frmPacientes.ShowModal;
end;

procedure TfrmPrincipal.menuTriagemClick(Sender: TObject);
begin
  if frmTriagem = nil then
    Application.CreateForm(TfrmTriagem, frmTriagem);

  frmTriagem.ShowModal;
end;

procedure TfrmPrincipal.menuUsuariosClick(Sender: TObject);
begin
  frmUsuarios.ShowModal;
end;

procedure TfrmPrincipal.ZconexaoAfterConnect(Sender: TObject);
begin

end;

end.
