unit unit_fila;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBGrids,
  StdCtrls, DB, ZDataset, unit_dados;

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

{$R *.lfm}

{ TfrmFilaMedica }

procedure TfrmFilaMedica.FormShow(Sender: TObject);
begin
  zqryFila.Connection := dmDados.zConexao;
  dsFila.DataSet := zqryFila;
  DBGridFila.DataSource := dsFila;
  AtualizarFila;
end;

procedure TfrmFilaMedica.btnAtualizarClick(Sender: TObject);
begin
  AtualizarFila;
end;

procedure TfrmFilaMedica.AtualizarFila;
begin
  zqryFila.Close;
  zqryFila.SQL.Text :=
    'select t.id, p.nome_completo as "Paciente", t.data_hora_consulta as "Horário", t.status as "Status" ' +
    'from consultas t ' +
    'join pacientes p ON p.id = t.paciente_id ' +
    'where t.status = ''Aguardando Atendimento'' ' +
    'order by t.data_hora_consulta ASC';
  zqryFila.Open;
end;

procedure TfrmFilaMedica.btnAtenderClick(Sender: TObject);
var
  IdFila: Integer;
begin
  if zqryFila.IsEmpty then
  begin
    ShowMessage('Não há pacientes na fila de espera.');
    Exit;
  end;

  IdFila := zqryFila.FieldByName('id').AsInteger;

  try
    dmDados.zqryGeral.Close;

    dmDados.zqryGeral.SQL.Text := 'update consultas set status = ''Atendido'' WHERE id = :id';
    dmDados.zqryGeral.ParamByName('id').AsInteger := IdFila;
    dmDados.zqryGeral.ExecSQL;

    ShowMessage('Paciente ' + zqryFila.FieldByName('Paciente').AsString + ' chamado para o consultório!');

    AtualizarFila;
  except
    on E: Exception do
      ShowMessage('Erro ao atualizar atendimento: ' + E.Message);
  end;
end;

end.
