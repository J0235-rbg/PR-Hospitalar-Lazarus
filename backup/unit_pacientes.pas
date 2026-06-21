unit unit_pacientes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids, unit_dados;

type

  { TfrmPacientes }

  TfrmPacientes = class(TForm)
    btnNovo: TButton;
    btnSalvar: TButton;
    btnExcluir: TButton;
    DBGrid1: TDBGrid;
    edtNomeCompleto: TEdit;
    edtCPF: TEdit;
    edtDataNasc: TEdit;
    edtTelefone: TEdit;
    edtEndereco: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure btnExcluirClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
  private

  public

  end;

var
  frmPacientes: TfrmPacientes;

implementation

{$R *.lfm}

{ TfrmPacientes }

procedure TfrmPacientes.btnNovoClick(Sender: TObject); // Botão Novo
begin
  edtNomeCompleto.Clear;
  edtCPF.Clear;
  edtDataNasc.Clear;
  edtTelefone.Clear;
  edtEndereco.Clear;
  edtNomeCompleto.SetFocus;
end;

procedure TfrmPacientes.btnExcluirClick(Sender: TObject); // Botão Excluir
begin
  if dmDados.zqryPacientes.IsEmpty then
  begin
    ShowMessage('Não há nenhum paciente para excluir.');
    Exit;
  end;

  if MessageDlg('Confirmação', 'Tem certeza que deseja excluir o paciente ' +
                dmDados.zqryPacientes.FieldByName('nome_completo').AsString + '?',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      dmDados.zqryGeral.Close;
      dmDados.zqryGeral.SQL.Text := 'DELETE FROM pacientes WHERE id = :id';
      dmDados.zqryGeral.ParamByName('id').AsInteger := dmDados.zqryPacientes.FieldByName('id').AsInteger;
      dmDados.zqryGeral.ExecSQL;

      ShowMessage('Paciente excluído com sucesso!');

      dmDados.zqryPacientes.Close;
      dmDados.zqryPacientes.Open;
    except
      on E: Exception do
        ShowMessage('Erro ao excluir: ' + E.Message);
    end;
  end;
end;

procedure TfrmPacientes.btnSalvarClick(Sender: TObject); // Botão Salvar
begin
  if (edtNomeCompleto.Text = '') or (edtCPF.Text = '') then
  begin
    ShowMessage('Atenção: Os campos Nome Completo e CPF são obrigatórios.');
    Exit;
  end;

  try
    dmDados.zqryGeral.Close;
    dmDados.zqryGeral.SQL.Text :=
      'INSERT INTO pacientes (nome_completo, cpf, data_nascimento, telefone, endereco) ' +
      'VALUES (:nome, :cpf, :data_nasc, :telefone, :endereco)';

    dmDados.zqryGeral.ParamByName('nome').AsString := edtNomeCompleto.Text;
    dmDados.zqryGeral.ParamByName('cpf').AsString := edtCPF.Text;

    if edtDataNasc.Text <> '' then
      dmDados.zqryGeral.ParamByName('data_nasc').AsDate := StrToDate(edtDataNasc.Text)
    else
      dmDados.zqryGeral.ParamByName('data_nasc').Clear;

    dmDados.zqryGeral.ParamByName('telefone').AsString := edtTelefone.Text;
    dmDados.zqryGeral.ParamByName('endereco').AsString := edtEndereco.Text;

    dmDados.zqryGeral.ExecSQL; // Manda pro banco

    ShowMessage('Paciente cadastrado com sucesso!');

    dmDados.zqryPacientes.Close;
    dmDados.zqryPacientes.Open;

    btnNovoClick(Sender);
  except
    on E: Exception do
      ShowMessage('Erro ao salvar no banco: ' + E.Message);
  end;
end;

end.

