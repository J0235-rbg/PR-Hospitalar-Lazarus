unit unit_medicos;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, unit_dados;

type

  { TfrmMedicos }

  TfrmMedicos = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Nome: TLabel;
    Label2: TLabel;
    Label3: TLabel;
  private

  public

  end;

var
  frmMedicos: TfrmMedicos;

implementation

{$R *.lfm}

end.

