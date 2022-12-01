unit Utils;

interface

uses FireDAC.Comp.Client, Vcl.Controls;

procedure SendKeysTab;

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

procedure ValidaZero(Controle: TWinControl; Valor: Double; Msg: string);
procedure ValidaVazio(Controle: TWinControl; Valor: string; Msg: string);

implementation

uses Winapi.Windows, System.SysUtils, Vcl.Forms, DMMain;

procedure SendKeysTab;
begin
  keybd_event(VK_TAB, 0, 0, 0);
  keybd_event(VK_TAB, 0, KEYEVENTF_KEYUP, 0);
end;

function DateToSql(Data: TDate): string;
begin
  result := '''' + FormatDateTime('yyyy/mm/dd', Data) + '''';
end;

function FloatToSql(Value: Double): string;
begin
  result := FloatToStr(Value).Replace(',', '.');
end;

procedure ExecSql(SQL: string);
begin
  DM.WktechConnection.ExecSQL(SQL);
end;

procedure AbreDM;
begin
  Application.CreateForm(TDM, DM);
end;

procedure FechaDM;
begin
  //DM.Free;
end;

procedure AbreQuery(var Query: TFDQuery; Sql: string);
begin
  Query := TFDQuery.Create(nil);
  Query.Connection := DM.WktechConnection;
  Query.Sql.Text := Sql;
  Query.Open;
end;

procedure FechaQuery(var Query: TFDQuery);
begin
  Query.Close;
  Query.Free;
end;

function BuscaValor(SQL: string): string;
var Query: TFDQuery;
begin
  AbreQuery(Query, SQL);
  result := Query.Fields[0].AsString;
  FechaQuery(Query);
end;

function BuscaDescricao(SQL: string; Valor: string): string;
begin
  if Valor = '' then
    Result := ''
  else
    result := BuscaValor(SQL + Valor);
end;

procedure TransStart;
begin
  DM.WktechConnection.StartTransaction;
end;

procedure TransCommit;
begin
  DM.WktechConnection.Commit;
end;

procedure TransRollBack;
begin
  DM.WktechConnection.Rollback;
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

end.
