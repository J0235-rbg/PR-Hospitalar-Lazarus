unit unit_login;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, md5, unit_dados;

type

  { TfrmLogin }

  TfrmLogin = class(TForm)
    btnEntrar: TButton;
    edtUsuario: TEdit;
    edtSenha: TEdit;
    Usuario: TLabel;
    Senha: TLabel;
    procedure btnEntrarClick(Sender: TObject);
  private

  public

  end;

var
  FormLogin: TfrmLogin;

implementation

{$R *.lfm}

{ TfrmLogin }

procedure TfrmLogin.btnEntrarClick(Sender: TObject);
var
  vSenhaHash: String;
begin
  // 1. Verificação de Segurança (Evita consultar o banco com campos vazios)
  if (edtUsuario.Text = '') or (edtSenha.Text = '') then
  begin
    ShowMessage('Atenção: Preencha o usuário e a senha para acessar o sistema.');
    Exit;
  end;

  // 2. Criptografia na Memória
  // O Lazarus pega o texto limpo, converte para MD5 e transforma em texto visível
  vSenhaHash := MD5Print(MD5String(edtSenha.Text));

  // 3. Consulta Parametrizada no Banco de Dados
  try
    dmDados.zqryGeral.Close;
    dmDados.zqryGeral.SQL.Text :=
      'SELECT id, perfil_acesso FROM usuarios ' +
      'WHERE login = :login AND senha_hash = :senha AND ativo = true';

    // Proteção contra SQL Injection
    dmDados.zqryGeral.ParamByName('login').AsString := edtUsuario.Text;
    dmDados.zqryGeral.ParamByName('senha').AsString := vSenhaHash;

    dmDados.zqryGeral.Open;

    // 4. A Decisão da Fechadura
    if not dmDados.zqryGeral.IsEmpty then
    begin
      // Achou o usuário! Acesso Liberado.
      ShowMessage('Acesso Autorizado! Bem-vindo, ' + dmDados.zqryGeral.FieldByName('perfil_acesso').AsString);

      vUsuarioLogadoId := dmDados.zqryGeral.FieldByName('id').AsInteger;
      vUsuarioLogadoPerfil := dmDados.zqryGeral.FieldByName('perfil_acesso').AsString;

      // Essa linha fecha a tela de login e envia o sinal verde para o .lpr abrir o sistema
      ModalResult := mrOk;
    end
    else
    begin
      // Não achou o usuário ou a senha bateu errado. Acesso Negado.
      ShowMessage('Acesso Negado: Usuário ou senha incorretos (ou conta inativa).');
      edtSenha.Clear;
      edtSenha.SetFocus; // Coloca o cursor piscando de volta na caixa de senha
    end;

  except
    on E: Exception do
      ShowMessage('Erro interno ao tentar validar o acesso: ' + E.Message);
  end;
end;
end.
