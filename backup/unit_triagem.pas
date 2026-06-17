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
  dmDados.zqryGeral.SQL.Text := 'SELECT id, nome_completo FROM pacientes ORDER BY nome_completo';
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
  vIdPaciente: Integer;
  vTemp: Double;
begin
  // Vamos forçar o paciente 1 por enquanto, até configurarmos a lista de seleção
  vIdPaciente := 1;

  // ATENÇÃO: Confirme se os nomes dessas caixas (edtTemperatura, edtQueixa, edtPA, edtFC)
  // são os mesmos que estão no Inspetor de Objetos. Se forem diferentes, o nome no código deve ser igual ao da caixa!
  vTemp := StrToFloatDef(edtTemp.Text, 36.5);

  // Chama a função enviando os dados validados
  if dmDados.SalvarTriagem(vIdPaciente, edtQueixa.Text, edtPA.Text, vTemp, cbManchester.Text) then
  begin
    ShowMessage('Triagem gravada com sucesso no PostgreSQL!');

    // Limpando os campos após salvar
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

end.
