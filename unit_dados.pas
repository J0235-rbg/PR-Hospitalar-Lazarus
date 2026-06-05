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
    function SalvarTriagem(IdPac: Integer; Queixa: String; PA: String; Temp: Double; FC: Integer; Cor: String): Boolean;
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
function TdmDados.SalvarTriagem(IdPac: Integer; Queixa: String; PA: String; Temp: Double; FC: Integer; Cor: String): Boolean;
begin
  Result := False;
  try
    zqryGeral.Close;
    zqryGeral.SQL.Text :=
      'INSERT INTO triagens (id_paciente, queixa_principal, pressao_arterial, temperatura, frequencia_cardiaca, classificacao) ' +
      'VALUES (:id_pac, :queixa, :pa, :temp, :fc, :cor)';

    zqryGeral.ParamByName('id_pac').AsInteger := IdPac;
    zqryGeral.ParamByName('queixa').AsString  := Queixa;
    zqryGeral.ParamByName('pa').AsString      := PA;
    zqryGeral.ParamByName('temp').AsFloat     := Temp;
    zqryGeral.ParamByName('fc').AsInteger     := FC;
    zqryGeral.ParamByName('cor').AsString     := Cor;

    zqryGeral.ExecSQL;
    Result := True; // Se chegou aqui sem erro, deu certo!
  except
    on E: Exception do
    begin
      ShowMessage('Erro interno no banco de dados: ' + E.Message);
      Result := False;
    end;
  end;
end;

end.
