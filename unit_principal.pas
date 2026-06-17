unit unit_principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls,
  DBGrids, DBCtrls, ZConnection, ZDataset;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
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
    procedure btnPacientesClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
    procedure FormCreate(Sender: TObject);
    procedure menuAgendaClick(Sender: TObject);
    procedure menuPacientesClick(Sender: TObject);
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
procedure TfrmPrincipal.menuAgendaClick(Sender: TObject);
begin
  Application.CreateForm(TfrmFilaMedica, frmFilaMedica);
  try
    frmFilaMedica.ShowModal;
  finally
    frmFilaMedica.Free;
  end;
end; // Corrigido o fechamento aqui!

procedure TfrmPrincipal.menuPacientesClick(Sender: TObject);
begin

end;

procedure TfrmPrincipal.ZconexaoAfterConnect(Sender: TObject);
begin

end;

end.
