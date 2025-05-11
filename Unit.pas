unit Unit1;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Net.HttpClient, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Types, Vcl.Controls,
  Vcl.Forms, Vcl.StdCtrls, Vcl.Grids, Vcl.Dialogs;

type
  TForm1 = class(TForm)
    EditConta: TEdit;
    Label1: TLabel;
    ButtonBuscar: TButton;
    StringGrid1: TStringGrid;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;

    procedure FormCreate(Sender: TObject);
    procedure ButtonBuscarClick(Sender: TObject);

  private
    procedure ExibirExtrato(json: TJSONArray);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  StringGrid1.Cells[0, 0] := 'Data';
  StringGrid1.Cells[1, 0] := 'Descrição';
  StringGrid1.Cells[2, 0] := 'Valor';
end;

procedure TForm1.ButtonBuscarClick(Sender: TObject);
var
  Conta: string;
  JsonArray: TJSONArray;
begin
  Conta := Trim(EditConta.Text);
  if Conta = '' then
  begin
    ShowMessage('Informe o número da conta.');
    Exit;
  end;

  RESTClient1.BaseURL := 'http://localhost:8080/api/extrato';
  RESTRequest1.Resource := Conta;
  RESTRequest1.Method := rmGET;
  RESTRequest1.Execute;

  if RESTResponse1.StatusCode = 200 then
  begin
    JsonArray := RESTResponse1.JSONValue as TJSONArray;
    ExibirExtrato(JsonArray);
  end
  else
  begin
    ShowMessage('Erro ao buscar extrato: ' + RESTResponse1.StatusText);
  end;
end;

procedure TForm1.ExibirExtrato(json: TJSONArray);
var
  I: Integer;
  Item: TJSONObject;
begin
  StringGrid1.RowCount := json.Count + 1;

  for I := 0 to json.Count - 1 do
  begin
    Item := json.Items[I] as TJSONObject;

    StringGrid1.Cells[0, I + 1] := Item.GetValue('data').Value;
    StringGrid1.Cells[1, I + 1] := Item.GetValue('descricao').Value;
    StringGrid1.Cells[2, I + 1] := FormatFloat('#,##0.00', Item.GetValue('valor').AsType<Double>);
  end;
end;

end.
