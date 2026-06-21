unit unit_usuarios;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids, unit_dados;

type

  { TfrmUsuarios }

  TfrmUsuarios = class(TForm)
    btnNovo: TButton;
    btnSalvar: TButton;
    btnExcluir: TButton;
    cbPerfil: TComboBox;
    chkAtivo: TCheckBox;
    DBGrid1: TDBGrid;
    edtSenha: TEdit;
    edtLogin: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure btnExcluirClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frmUsuarios: TfrmUsuarios;

implementation

{$R *.lfm}

// Evento OnShow da Tela

procedure TfrmUsuarios.btnNovoClick(Sender: TObject);
begin
  edtLogin.Clear;
  edtSenha.Clear;
  cbPerfil.ItemIndex := -1; // Limpa a seleção do combo
  chkAtivo.Checked := True; // Deixa marcado como ativo por padrão
  edtLogin.SetFocus; // Coloca o cursor piscando no campo de login
end;

procedure TfrmUsuarios.btnSalvarClick(Sender: TObject);
begin
  // Validação de Campos Obrigatórios
  if (edtLogin.Text = '') or (edtSenha.Text = '') or (cbPerfil.Text = '') then
  begin
    ShowMessage('Atenção: Todos os campos são obrigatórios.');
    Exit;
  end;

  try
    dmDados.zqryGeral.Close;
    dmDados.zqryGeral.SQL.Text :=
      'INSERT INTO usuarios (login, senha_hash, perfil_acesso, ativo, data_criacao) ' +
      'VALUES (:login, :senha, :perfil, :ativo, NOW())';

    dmDados.zqryGeral.ParamByName('login').AsString := edtLogin.Text;
    dmDados.zqryGeral.ParamByName('senha').AsString := edtSenha.Text;
    dmDados.zqryGeral.ParamByName('perfil').AsString := cbPerfil.Text;
    dmDados.zqryGeral.ParamByName('ativo').AsBoolean := chkAtivo.Checked;

    dmDados.zqryGeral.ExecSQL;

    ShowMessage('Usuário cadastrado com sucesso!');

    // Atualiza a Grid
    dmDados.zqryUsuarios.Close;
    dmDados.zqryUsuarios.Open;

    // Limpa a tela
    edtLogin.Clear;
    edtSenha.Clear;
    cbPerfil.ItemIndex := -1;
    edtLogin.SetFocus;
  except
    on E: Exception do
      ShowMessage('Erro ao salvar usuário: ' + E.Message);
  end;
end;

procedure TfrmUsuarios.btnExcluirClick(Sender: TObject);
begin
  // Trava de segurança: verifica se existe alguém selecionado na planilha
  if dmDados.zqryUsuarios.IsEmpty then
  begin
    ShowMessage('Nenhum usuário selecionado para exclusão.');
    Exit;
  end;

  // Caixa de diálogo pedindo confirmação com o nome do usuário
  if MessageDlg('Confirmação', 'Deseja realmente remover o acesso do usuário ' +
                dmDados.zqryUsuarios.FieldByName('login').AsString + '?',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      dmDados.zqryGeral.Close;
      dmDados.zqryGeral.SQL.Text := 'DELETE FROM usuarios WHERE id = :id';

      // Captura o ID da linha selecionada silenciosamente
      dmDados.zqryGeral.ParamByName('id').AsInteger := dmDados.zqryUsuarios.FieldByName('id').AsInteger;
      dmDados.zqryGeral.ExecSQL;

      ShowMessage('Usuário removido com sucesso!');

      // Atualiza a grade para o usuário sumir da tela
      dmDados.zqryUsuarios.Close;
      dmDados.zqryUsuarios.Open;
    except
      on E: Exception do
        ShowMessage('Erro ao excluir usuário: ' + E.Message);
    end;
  end;
end;

procedure TfrmUsuarios.FormShow(Sender: TObject);
begin
  dmDados.zqryUsuarios.Close;
  dmDados.zqryUsuarios.SQL.Text := 'SELECT id, login, perfil_acesso, ativo, data_criacao FROM usuarios ORDER BY login';
  dmDados.zqryUsuarios.Open;
end;
end.
