unit Model.Pedido;

interface

{$M+}

Type
  tModelPedido = class(TObject)
  private
    fidpedido: Integer;
    fdata_emissao:  TDate;
    fidcliente: integer;
    fvalor_total: Double;
    procedure SetData_emissao(const Value: TDate);
    procedure SetIdcliente(const Value: integer);
    procedure SetIdpedido(const Value: Integer);
    procedure SetValor_total(const Value: Double);

  public
    constructor Create;
    destructor Destroy; override;
    procedure Read(Chave: string);
    procedure Save;

  published
    property idpedido: Integer read fidpedido write SetIdpedido;
    property data_emissao: TDate read fdata_emissao write SetData_emissao;
    property idcliente: integer read fidcliente write SetIdcliente;
    property valor_total: Double read fvalor_total write SetValor_total;

  end;

implementation



uses FireDAC.Comp.Client, System.SysUtils, Controller.Utilities;

{ tModelPedido }

constructor tModelPedido.Create;
begin
  //
end;

destructor tModelPedido.Destroy;
begin
  Inherited;
end;

procedure tModelPedido.Read(Chave: string);
var Query: TFDQuery;
begin
  if Chave = '' then
    raise Exception.Create('Número de Pedido Inválido');

  AbreQuery(Query, 'select * from pedido where idpedido = ' + Chave);
  if Query.Eof then
    raise Exception.Create('Pedido não encontrado: ' + Chave);

  idpedido := Query.FieldByName('idpedido').AsInteger;
  data_emissao := Query.FieldByName('data_emissao').AsDateTime;
  idcliente := Query.FieldByName('idcliente').AsInteger;
  valor_total := Query.FieldByName('valor_total').AsFloat;

  FechaQuery(Query);
end;

procedure tModelPedido.Save;
begin
  if idpedido = 0 then
  begin
    ExecSql('Insert into pedido ('
        + ' idcliente,'
        + ' data_emissao,'
        + ' valor_total)'
        + ' values '
        + '(' + IntToStr(idcliente) + ','
        + DateToSql(data_emissao) + ','
        + FloatToSql(valor_total) + ')');

    idpedido := StrToInt(BuscaValor('SELECT LAST_INSERT_ID()'));
  end
  else
  begin
    ExecSql('update pedido set '
    + ' idcliente = ' + IntToStr(idcliente) + ','
    + ' data_emissao = ' + DateToSql(data_emissao) + ','
    + ' valor_total = ' + FloatToSql(valor_total)
    + ' where idpedido = ' + IntToStr(idpedido));
  end;
end;

procedure tModelPedido.SetData_emissao(const Value: TDate);
begin
  fdata_emissao := Value;
end;

procedure tModelPedido.SetIdcliente(const Value: integer);
begin
  fidcliente := Value;
end;

procedure tModelPedido.SetIdpedido(const Value: Integer);
begin
  fidpedido := Value;
end;

procedure tModelPedido.SetValor_total(const Value: Double);
begin
  fvalor_total := Value;
end;

end.
