unit unit_triagem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  DBCtrls, FGL, unit_dados, unit_pacientes;

type
  TListaIDs = specialize TFPGList<Integer>;

  { TfrmTriagem }

  TfrmTriagem = class(TForm)
    btnSalvarTriagem: TButton;
    cbManchester: TComboBox;
    dblcbPaciente: TDBLookupComboBox;
    GroupBox1: TGroupBox;
    edtQueixa: TEdit;
    edtPA: TEdit;
    edtTemp: TEdit;
    edtFC: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure btnSalvarTriagemClick(Sender: TObject);
    procedure dblcbPacienteChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    IDsPacientes: TListaIDs;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmTriagem: TfrmTriagem;

implementation

{$R *.lfm}

constructor TfrmTriagem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  IDsPacientes := TListaIDs.Create;
end;

destructor TfrmTriagem.Destroy;
begin
  IDsPacientes.Free;
  inherited Destroy;
end;

procedure TfrmTriagem.FormShow(Sender: TObject);
begin
  dmDados.zqryPacientes.Close;
  dmDados.zqryPacientes.SQL.Text := 'SELECT id, nome_completo FROM pacientes ORDER BY nome_completo';
  dmDados.zqryPacientes.Open;
  dblcbPaciente.ListSource := dmDados.dsPacientes;
  dblcbPaciente.ListField  := 'nome_completo';
  dblcbPaciente.KeyField   := 'id';
  end;

procedure TfrmTriagem.btnSalvarTriagemClick(Sender: TObject);
var
  vIdPaciente: Integer;
  vTemp: Double;
begin
  vIdPaciente := 1;

  vTemp := StrToFloatDef(edtTemp.Text, 36.5);

  if dmDados.SalvarTriagem(vIdPaciente, edtQueixa.Text, edtPA.Text, vTemp, cbManchester.Text) then
  begin
    ShowMessage('Triagem gravada com sucesso no PostgreSQL!');

    edtQueixa.Clear;
    edtPA.Clear;
    edtTemp.Clear;
    edtFC.Clear;
  end
  else
  begin
    ShowMessage('Atenção: Falha ao tentar gravar a triagem.');
  end;
end;

procedure TfrmTriagem.dblcbPacienteChange(Sender: TObject);
begin

end;

end.
