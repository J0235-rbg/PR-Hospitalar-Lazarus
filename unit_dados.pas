unit unit_dados;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, ZConnection, ZDataset, db;

type

  { TdmDados }

  TdmDados = class(TDataModule)
    dsMedicos: TDataSource;
    dsUsuarios: TDataSource;
    dsPacientes: TDataSource;
    ZConexao: TZConnection;
    zqryGeral: TZQuery;
    zqryPacientes: TZQuery;
    zqryUsuarios: TZQuery;
    zqryMedicos: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure dsPacientesDataChange(Sender: TObject; Field: TField);
  private
  public
    function SalvarTriagem(IdPac: Integer; Sintomas: String; PA: String; Temp: Double; Urgencia: String): Boolean;
  end;

var
  dmDados: TdmDados;
  vUsuarioLogadoId: Integer;
  vUsuarioLogadoPerfil: String;

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

procedure TdmDados.dsPacientesDataChange(Sender: TObject; Field: TField);
begin

end;

function TdmDados.SalvarTriagem(IdPac: Integer; Sintomas: String; PA: String; Temp: Double; Urgencia: String): Boolean;
begin
  Result := False;
  try
    zqryGeral.Close;
    // usei o now() para pegar a data e hora automaticamente
    zqryGeral.SQL.Text :=
      'INSERT INTO triagens (paciente_id, data_hora_chegada, pressao_arterial, temperatura, sintomas_principais, nivel_urgencia) ' +
      'VALUES (:paciente_id, NOW(), :pa, :temp, :sintomas, :urgencia)';

    zqryGeral.ParamByName('paciente_id').AsInteger := IdPac;
    zqryGeral.ParamByName('pa').AsString           := PA;
    zqryGeral.ParamByName('temp').AsFloat          := Temp;
    zqryGeral.ParamByName('sintomas').AsString     := Sintomas;
    zqryGeral.ParamByName('urgencia').AsString     := Urgencia;

    zqryGeral.ExecSQL;
    Result := True;
  except
    on E: Exception do
    begin
      ShowMessage('Erro interno no banco de dados: ' + E.Message);
      Result := False;
    end;
  end;
end;

end.
