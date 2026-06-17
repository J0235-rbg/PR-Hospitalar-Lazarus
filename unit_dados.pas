unit unit_dados;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, ZConnection, ZDataset, db;

type

  { TdmDados }

  TdmDados = class(TDataModule)
    ZConexao: TZConnection;
    zqryGeral: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
  public
    // Criamos a assinatura do método aqui para que as telas possam enxergar
    function SalvarTriagem(IdPac: Integer; Sintomas: String; PA: String; Temp: Double; Urgencia: String): Boolean;
  end;

var
  dmDados: TdmDados;

implementation

{$R *.lfm}

procedure TdmDados.DataModuleCreate(Sender: TObject);
begin
  try
    ZConexao.Connected := True;
  except
    on E: Exception do
      ShowMessage('Erro crítico ao conectar no banco: ' + E.Message);
  end;
end;

// A LÓGICA DO BANCO FICA TODA AQUI DENTRO AGORA
function TdmDados.SalvarTriagem(IdPac: Integer; Sintomas: String; PA: String; Temp: Double; Urgencia: String): Boolean;
begin
  Result := False;
  try
    zqryGeral.Close;
    // O comando SQL agora usa os nomes EXATOS da sua tabela
    // Note o uso do NOW() para preencher a data_hora_chegada automaticamente
    zqryGeral.SQL.Text :=
      'INSERT INTO triagens (paciente_id, data_hora_chegada, pressao_arterial, temperatura, sintomas_principais, nivel_urgencia) ' +
      'VALUES (:paciente_id, NOW(), :pa, :temp, :sintomas, :urgencia)';

    zqryGeral.ParamByName('paciente_id').AsInteger := IdPac;
    zqryGeral.ParamByName('pa').AsString           := PA;
    zqryGeral.ParamByName('temp').AsFloat          := Temp;
    zqryGeral.ParamByName('sintomas').AsString     := Sintomas;
    zqryGeral.ParamByName('urgencia').AsString     := Urgencia;

    zqryGeral.ExecSQL;
    Result := True; // Sucesso!
  except
    on E: Exception do
    begin
      ShowMessage('Erro interno no banco de dados: ' + E.Message);
      Result := False;
    end;
  end;
end;

end.
