unit unit_fila;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBGrids,
  StdCtrls, DB, ZDataset;

type

  { TfrmFilaMedica }

  TfrmFilaMedica = class(TForm)
    btnAtender: TButton;
    btnAtualizar: TButton;
    dsFila: TDataSource;
    DBGridFila: TDBGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    zqryFila: TZQuery;
    procedure btnAtenderClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure AtualizarFila;
  public

  end;

var
  frmFilaMedica: TfrmFilaMedica;

implementation

uses unit_dados;

{$R *.lfm}

{ TfrmFilaMedica }

procedure TfrmFilaMedica.FormShow(Sender: TObject);
begin
  AtualizarFila;
end;

procedure TfrmFilaMedica.btnAtualizarClick(Sender: TObject);
begin
  AtualizarFila;
end;

procedure TfrmFilaMedica.AtualizarFila;
begin
  zqryFila.Close;
  // SQL Inteligente: Ordena por gravidade (Manchester) e depois por hora de chegada
  zqryFila.SQL.Text :=
    'SELECT t.id, p.nome AS "Paciente", t.classificacao AS "Risco", ' +
    '       t.queixa_principal AS "Queixa", t.data_triagem AS "Chegada" ' +
    'FROM triagens t ' +
    'JOIN pacientes p ON p.id = t.id_paciente ' +
    'WHERE t.status = ''Aguardando Atendimento'' ' +
    'ORDER BY ' +
    '  CASE t.classificacao ' +
    '    WHEN ''VERMELHO'' THEN 1 ' +
    '    WHEN ''LARANJA''  THEN 2 ' +
    '    WHEN ''AMARELO''  THEN 3 ' +
    '    WHEN ''VERDE''    THEN 4 ' +
    '    WHEN ''AZUL''     THEN 5 ' +
    '    ELSE 6 ' +
    '  END, t.data_triagem ASC';
  zqryFila.Open;
end;

procedure TfrmFilaMedica.btnAtenderClick(Sender: TObject);
var
  IdTriagem: Integer;
begin
  if zqryFila.IsEmpty then
  begin
    ShowMessage('Não há pacientes na fila de espera.');
    Exit;
  end;

  // Pega o ID da triagem selecionada no Grid
  IdTriagem := zqryFila.FieldByName('id').AsInteger;

  // Como boa prática, mudamos o status para 'Em Atendimento'
  try
    dmDados.zqryGeral.Close;
    dmDados.zqryGeral.SQL.Text := 'UPDATE triagens SET status = ''Atendido'' WHERE id = :id';
    dmDados.zqryGeral.ParamByName('id').AsInteger := IdTriagem;
    dmDados.zqryGeral.ExecSQL;

    ShowMessage('Paciente ' + zqryFila.FieldByName('Paciente').AsString + ' chamado para o consultório!');
    AtualizarFila; // Atualiza a tela para sumir o paciente que já entrou
  except
    on E: Exception do
      ShowMessage('Erro ao atualizar atendimento: ' + E.Message);
  end;
end;

end.
