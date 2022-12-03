unit Model.Selects;

interface

uses FireDAC.Comp.Client;

procedure mdAbreDM;
procedure mdFechaDM;

procedure mdAbreQuery(var Query: TFDQuery; Sql: string);
procedure mdFechaQuery(var Query: TFDQuery);

function mdBuscaValor(SQL, cstNaoEncontrado: string): string;

function mdDateToSql(Data: TDate): string;
function mdFloatToSql(Value: Double): string;

procedure mdExecSql(SQL: string);

procedure mdTransStart;
procedure mdTransCommit;
procedure mdTransRollBack;

function SelBuscaDescricaoCliente: string;
function SelBuscaDescricaoProduto: string;

implementation

uses System.SysUtils,Model.Main, Vcl.Forms;

procedure mdAbreDM;
begin
  Application.CreateForm(TDM, DM);
end;

procedure mdFechaDM;
begin
  //DM.Free;
end;

function mdDateToSql(Data: TDate): string;
begin
  result := '''' + FormatDateTime('yyyy/mm/dd', Data) + '''';
end;

function mdFloatToSql(Value: Double): string;
begin
  result := FloatToStr(Value).Replace(',', '.');
end;

procedure mdExecSql(SQL: string);
begin
  DM.WktechConnection.ExecSQL(SQL);
end;

procedure mdTransStart;
begin
  DM.WktechConnection.StartTransaction;
end;

procedure mdTransCommit;
begin
  DM.WktechConnection.Commit;
end;

procedure mdTransRollBack;
begin
  DM.WktechConnection.Rollback;
end;


function SelBuscaDescricaoCliente: string;
begin
  Result := 'Select nome from cliente where idcliente = ';
end;

function SelBuscaDescricaoProduto: string;
begin
  Result := 'Select descricao from produto where idproduto = ';
end;

procedure mdAbreQuery(var Query: TFDQuery; Sql: string);
begin
  Query := TFDQuery.Create(nil);
  Query.Connection := DM.WktechConnection;
  Query.Sql.Text := Sql;
  Query.Open;
end;

procedure mdFechaQuery(var Query: TFDQuery);
begin
  Query.Close;
  Query.Free;
end;

function mdBuscaValor(SQL, cstNaoEncontrado: string): string;
var Query: TFDQuery;
begin
  mdAbreQuery(Query, SQL);
  if Query.eof then
    result := cstNaoEncontrado
  else
    result := Query.Fields[0].AsString;
  mdFechaQuery(Query);
end;



end.
