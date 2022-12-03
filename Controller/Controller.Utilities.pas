unit Controller.Utilities;

interface

uses FireDAC.Comp.Client, Vcl.Controls, Winapi.Windows, Vcl.Forms;

procedure TransStart;
procedure TransCommit;
procedure TransRollBack;

function DateToSql(Data: TDate): string;
function FloatToSql(Value: Double): string;

procedure ExecSql(SQL: string);

procedure AbreDM;
procedure FechaDM;

procedure AbreQuery(var Query: TFDQuery; Sql: string);
procedure FechaQuery(var Query: TFDQuery);

function BuscaValor(SQL: string): string;
function BuscaDescricao(SQL: string; Valor: string): string;
function BuscaDescricaoCliente(Valor: string): string;
function BuscaDescricaoProduto(Valor: string): string;

procedure ValidaZero(Controle: TWinControl; Valor: Double; Msg: string);
procedure ValidaVazio(Controle: TWinControl; Valor: string; Msg: string);
procedure ValidaCodigoExiste(Controle: TWinControl; Valor: string);

procedure Mostrar(sMensagem : string);
Function Perguntar(sMensagem : string; iDefault : integer = MB_DEFBUTTON1) : Boolean;

CONST NAO_ENCONTRADO = '*** Não encontrado ***';

implementation

uses System.SysUtils, Model.Main, Model.Selects;

function DateToSql(Data: TDate): string;
begin
  result := mdDateToSql(Data);
end;

function FloatToSql(Value: Double): string;
begin
  result := mdFloatToSql(Value);
end;

procedure ExecSql(SQL: string);
begin
  mdExecSQL(SQL);
end;

procedure AbreDM;
begin
  mdAbreDM;
end;

procedure FechaDM;
begin
  mdFechaDM;
end;

procedure AbreQuery(var Query: TFDQuery; Sql: string);
begin
  mdAbreQuery(Query, Sql);
end;

procedure FechaQuery(var Query: TFDQuery);
begin
  mdFechaQuery(Query);
end;

function BuscaValor(SQL: string): string;
begin
  Result := mdBuscaValor(SQL, NAO_ENCONTRADO);
end;

function BuscaDescricao(SQL: string; Valor: string): string;
begin
  if Valor = '' then
    Result := ''
  else
    result := BuscaValor(SQL + Valor);
end;

function BuscaDescricaoCliente(Valor: string): string;
begin
  Result := BuscaDescricao(SelBuscaDescricaoCliente, Valor);
end;

function BuscaDescricaoProduto(Valor: string): string;
begin
  Result := BuscaDescricao(SelBuscaDescricaoProduto, Valor);
end;

procedure TransStart;
begin
  mdTransStart;
end;

procedure TransCommit;
begin
  mdTransCommit;
end;

procedure TransRollBack;
begin
  mdTransRollBack;
end;

procedure GeraErro(Controle: TWinControl; Msg: string);
begin
  Controle.SetFocus;
  raise Exception.Create(Msg);
end;

procedure ValidaZero(Controle: TWinControl; Valor: Double; Msg: string);
begin
  if Valor = 0 then
    GeraErro(Controle, Msg);
end;

procedure ValidaVazio(Controle: TWinControl; Valor: string; Msg: string);
begin
  if Valor = '' then
    GeraErro(Controle, Msg);
end;

procedure ValidaCodigoExiste(Controle: TWinControl; Valor: string);
begin
  if Valor = NAO_ENCONTRADO then
    GeraErro(Controle, 'Código inválido');
end;

Function Perguntar(sMensagem : string; iDefault : integer = MB_DEFBUTTON1) : Boolean;
begin
  result := application.MessageBox(pChar(sMensagem), pChar('Questão'), mb_YesNo + mb_IconQuestion + iDefault) = idYes;
end;

procedure Mostrar(sMensagem : string);
begin
  application.MessageBox(pChar(sMensagem), pChar('Aviso'), MB_OK);
end;

end.
