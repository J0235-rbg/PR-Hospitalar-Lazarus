unit Unit1;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs;

type

  { TForm1 }

  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  // 1. Força a soldagem do adaptador na válvula do subsolo
  DataSource1.DataSet := dmDados.zqryGeral;

  // 2. Prepara o comando SQL
  dmDados.zqryGeral.Close;
  dmDados.zqryGeral.SQL.Text := 'SELECT * FROM pacientes';

  // 3. ABRE A VÁLVULA (Isso faz os dados inundarem o DBGrid!)
  dmDados.zqryGeral.Open;
end;
end;

end.

