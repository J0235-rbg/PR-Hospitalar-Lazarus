unit unit_triagem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, FGL;

type
  TListaIDs = specialize TFPGList<Integer>;

  { TfrmTriagem }

  TfrmTriagem = class(TForm)
    btnSalvarTriagem: TButton;
    cbManchester: TComboBox;
    cbPacientes: TComboBox;
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
    procedure FormShow(Sender: TObject);
  private
    IDsPacientes: TListaIDs;
    procedure CarregarPacientes;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmTriagem: TfrmTriagem;

implementation

// Vincula o seu menu principal e seu módulo de dados
uses unit_dados;

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
  CarregarPacientes;
end;

procedure TfrmTriagem.CarregarPacientes;
begin
  cbPacientes.Clear;
  IDsPacientes.Clear;

  // Usando o componente zqryGeral que você criou no DataModule
  dmDados.zqryGeral.Close;
  dmDados.zqryGeral.SQL.Text := 'SELECT id, nome FROM pacientes ORDER BY nome';
  dmDados.zqryGeral.Open;

  while not dmDados.zqryGeral.EOF do
  begin
    cbPacientes.Items.Add(dmDados.zqryGeral.FieldByName('nome').AsString);
    IDsPacientes.Add(dmDados.zqryGeral.FieldByName('id').AsInteger);
    dmDados.zqryGeral.Next;
  end;

  if cbPacientes.Items.Count > 0 then
    cbPacientes.ItemIndex := 0;
end;

procedure TfrmTriagem.btnSalvarTriagemClick(Sender: TObject);
var
  IdPaciente: Integer;
  CorSelecionada: String;
  Temperatura: Double;
  Batimentos: Integer;
begin
  // 1. Validações básicas de interface
  if cbPacientes.ItemIndex = -1 then
  begin
    ShowMessage('Selecione um paciente antes de gravar.');
    Exit;
  end;

  if cbManchester.ItemIndex = -1 then
  begin
    ShowMessage('Selecione uma classificação de cor.');
    Exit;
  end;

  // 2. Preparação dos dados da tela
  IdPaciente := IDsPacientes[cbPacientes.ItemIndex];

  CorSelecionada := Copy(cbManchester.Text, 1, Pos(' ', cbManchester.Text) - 1);
  if CorSelecionada = '' then CorSelecionada := cbManchester.Text;

  Temperatura := StrToFloatDef(edtTemp.Text, 36.5);
  Batimentos  := StrToIntDef(edtFC.Text, 80);

  // 3. O PULO DO GATO: Chamamos a função do DataModule e testamos se deu certo
  if dmDados.SalvarTriagem(IdPaciente, edtQueixa.Text, edtPA.Text, Temperatura, Batimentos, CorSelecionada) then
  begin
    ShowMessage('Triagem realizada com sucesso! Paciente enviado para a fila.');
    Self.Close;
  end;
end;

end.
