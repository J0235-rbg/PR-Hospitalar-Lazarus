unit unit_medicos;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  unit_dados;

type

  { TfrmMedicos }

  TfrmMedicos = class(TForm)
    btnNovo: TButton;
    btnSalvar: TButton;
    btnExcluir: TButton;
    DBGrid1: TDBGrid;
    edtNome: TEdit;
    edtCRM: TEdit;
    edtEspecialidade: TEdit;
    Nome: TLabel;
    CRM: TLabel;
    Especialidade: TLabel;
    procedure btnExcluirClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
  private

  public

  end;

var
  frmMedicos: TfrmMedicos;

implementation

{$R *.lfm}

{ TfrmMedicos }

procedure TfrmMedicos.btnNovoClick(Sender: TObject);
begin
  begin
  edtNome.Clear;
  edtCRM.Clear;
  edtEspecialidade.Clear;
  edtNome.SetFocus;
end;
end;

procedure TfrmMedicos.btnExcluirClick(Sender: TObject);
begin
  begin
  if dmDados.zqryMedicos.IsEmpty then
  begin
    ShowMessage('Nenhum médico selecionado para exclusão.');
    Exit;
  end;

  if MessageDlg('Confirmação', 'Deseja realmente remover o cadastro do Dr(a). ' +
                dmDados.zqryMedicos.FieldByName('nome').AsString + '?',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      dmDados.zqryGeral.Close;
      dmDados.zqryGeral.SQL.Text := 'DELETE FROM medicos WHERE id = :id';
      dmDados.zqryGeral.ParamByName('id').AsInteger := dmDados.zqryMedicos.FieldByName('id').AsInteger;
      dmDados.zqryGeral.ExecSQL;

      ShowMessage('Médico removido com sucesso.');

      dmDados.zqryMedicos.Close;
      dmDados.zqryMedicos.Open;
    except
      on E: Exception do
        ShowMessage('Erro ao excluir médico: ' + E.Message);
    end;
  end;
end;
end;

procedure TfrmMedicos.btnSalvarClick(Sender: TObject);
begin
  begin
  if (edtNome.Text = '') or (edtCRM.Text = '') then
  begin
    ShowMessage('Atenção: Nome e CRM são campos obrigatórios.');
    Exit;
  end;

  try
    dmDados.zqryGeral.Close;
    dmDados.zqryGeral.SQL.Text :=
      'INSERT INTO medicos (nome, crm, especialidade) VALUES (:nome, :crm, :especialidade)';

    dmDados.zqryGeral.ParamByName('nome').AsString := edtNome.Text;
    dmDados.zqryGeral.ParamByName('crm').AsString := edtCRM.Text;
    dmDados.zqryGeral.ParamByName('especialidade').AsString := edtEspecialidade.Text;

    dmDados.zqryGeral.ExecSQL;

    ShowMessage('Médico cadastrado com sucesso!');

    // Atualiza a tabela na tela
    dmDados.zqryMedicos.Close;
    dmDados.zqryMedicos.Open;

    btnNovoClick(Sender); // Limpa os campos
  except
    on E: Exception do
      ShowMessage('Erro ao salvar médico: ' + E.Message);
  end;
end;
end;

end.

