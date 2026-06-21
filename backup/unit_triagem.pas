unit unit_triagem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  DBCtrls, FGL, unit_dados;

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
