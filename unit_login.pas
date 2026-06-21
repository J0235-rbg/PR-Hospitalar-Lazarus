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
begin
  if (edtUsuario.Text = '') or (edtSenha.Text = '') then
  begin
    ShowMessage('Atenção: Preencha o usuário e a senha para acessar o sistema.');
    Exit;
  end;

  // Removi a variável vSenhaHash e o comando MD5! A consulta agora usa o edtSenha direto.

  try
    dmDados.zqryGeral.Close;
    dmDados.zqryGeral.SQL.Text :=
      'SELECT id, perfil_acesso FROM usuarios ' +
      'WHERE login = :login AND senha_hash = :senha AND ativo = true';

    dmDados.zqryGeral.ParamByName('login').AsString := edtUsuario.Text;
    // Mandando a senha limpa para comparar no banco
    dmDados.zqryGeral.ParamByName('senha').AsString := edtSenha.Text;

    dmDados.zqryGeral.Open;

    if not dmDados.zqryGeral.IsEmpty then
    begin
      ShowMessage('Acesso Autorizado! Bem-vindo, ' + dmDados.zqryGeral.FieldByName('perfil_acesso').AsString);

      // Guarda o crachá
      vUsuarioLogadoId := dmDados.zqryGeral.FieldByName('id').AsInteger;
      vUsuarioLogadoPerfil := dmDados.zqryGeral.FieldByName('perfil_acesso').AsString;

      ModalResult := mrOk;
    end
    else
    begin
      ShowMessage('Acesso Negado: Usuário ou senha incorretos (ou conta inativa).');
      edtSenha.Clear;
      edtSenha.SetFocus;
    end;

  except
    on E: Exception do
      ShowMessage('Erro interno ao tentar validar o acesso: ' + E.Message);
  end;
end;
end.
