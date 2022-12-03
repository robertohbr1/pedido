unit Model.Pedido;

interface

uses System.Generics.Collections;

{$M+}

Type
  tModelPedidoItem = class;

  tModelPedido = class(TObject)
  private
    fidpedido: Integer;
    fdata_emissao:  TDate;
    fidcliente: integer;
    fvalor_total: Double;
    FPedidoItem: TObjectList<tModelPedidoItem>;
    procedure SetData_emissao(const Value: TDate);
    procedure SetIdcliente(const Value: integer);
    procedure SetIdpedido(const Value: Integer);
    procedure SetValor_total(const Value: Double);
    procedure CarregaItens;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Read(Chave: string);
    procedure Save;
    function Ultimo: integer;
    procedure LimpaItens;
    procedure AddItem(xIdPedidoItem, xIdProduto: integer; xDescricao : string;
            xQtd, xValor_Unit, xValor_Total: double);

  published
    property idpedido: Integer read fidpedido write SetIdpedido;
    property data_emissao: TDate read fdata_emissao write SetData_emissao;
    property idcliente: integer read fidcliente write SetIdcliente;
    property valor_total: Double read fvalor_total write SetValor_total;

    property PedidoItem: TObjectList<tModelPedidoItem> read FPedidoItem write FPedidoItem;
  end;


  tModelPedidoItem = class(TObject)
  private
    fPedido: tModelPedido;
    fidpedido_item: Integer;
    fidproduto: Integer;
    fqtd: Double;
    fvalor_unit: Double;
    fvalor_total: Double;
    fDescricao: string;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Save;

  published
    property Pedido: tModelPedido read fPedido write fPedido;
    property idpedido_item: Integer read fidpedido_item write fidpedido_item;
    property idproduto: Integer read fidproduto write fidproduto;
    property qtd: Double read fqtd write fqtd;
    property valor_unit: Double read fvalor_unit write fvalor_unit;
    property valor_total: Double read Fvalor_total write Fvalor_total;
    property Descricao: string read FDescricao;
  end;

implementation

uses FireDAC.Comp.Client, System.SysUtils, Controller.Utilities;

{ tModelPedido }

procedure tModelPedido.AddItem(xIdPedidoItem, xIdProduto: integer; xDescricao : string;
      xQtd, xValor_Unit, xValor_Total: double);
begin
  FPedidoItem.Add(tModelPedidoItem.Create);
  With FPedidoItem.Items[FPedidoItem.Count -1] do
  begin
    fPedido := Self;
    idpedido_item := xIdPedidoItem;
    idproduto := xIdProduto;
    fDescricao := xDescricao;
    qtd := xQtd;
    valor_unit := xValor_Unit;
    valor_total := xValor_Total;
  end;
end;

procedure tModelPedido.CarregaItens;
var Query: TFDQuery;
begin
  FPedidoItem.Clear;

  AbreQuery(Query, 'SELECT pedido_item.*, produto.descricao '
      + ' FROM pedido_item '
      + ' inner join produto on pedido_item.idproduto = produto.idproduto '
      + ' where pedido_item.idpedido = ' + IntToStr(idpedido));
  while not Query.Eof do
  begin
    FPedidoItem.Add(tModelPedidoItem.Create);
    With FPedidoItem[FPedidoItem.Count -1] do
    begin
      idpedido_item := Query.FieldByName('idpedido_item').AsInteger;
      idproduto := Query.FieldByName('idproduto').AsInteger;
      fdescricao := Query.FieldByName('descricao').AsString;
      qtd := Query.FieldByName('qtd').AsFloat;
      valor_unit := Query.FieldByName('valor_unit').AsFloat;
      valor_total := Query.FieldByName('valor_total').AsFloat;
    end;
    Query.Next;
  end;
  FechaQuery(Query);
end;

constructor tModelPedido.Create;
begin
  FPedidoItem := TObjectList<tModelPedidoItem>.Create;
end;

destructor tModelPedido.Destroy;
begin
  FreeAndNil(FPedidoItem);
  Inherited;
end;

procedure tModelPedido.LimpaItens;
begin
  FPedidoItem.Clear;
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

  CarregaItens;
end;

procedure tModelPedido.Save;
var
  x: Integer;
begin
  TransStart;
  try
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

    // Marca os Itens com qtd = -1, para Deletar os que foram removidos do Grid
    ExecSql('update pedido_item set qtd = -1 where idpedido = ' + IntToStr(idpedido));

    for x := 0 to PedidoItem.Count - 1 do
      PedidoItem[x].Save;

    // Apaga os Itens com qtd = -1, pois foram removidos do Grid
    ExecSql('delete from pedido_item where idpedido = ' + IntToStr(idpedido) + ' and qtd = -1');
  except
  on E: Exception do
    begin
      TransRollBack;
      raise Exception.Create(E.Message);
    end;
  end;
  TransCommit;
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

function tModelPedido.Ultimo: integer;
begin
  Result := StrToInt('0' + BuscaValor('select max(idpedido) from pedido'));
end;

{ tModelPedidoItem }

constructor tModelPedidoItem.Create;
begin
//
end;

destructor tModelPedidoItem.Destroy;
begin
  inherited;
end;

procedure tModelPedidoItem.Save;
begin
  if idpedido_item = 0 then
    ExecSql('Insert into pedido_item '
        + '(idpedido,'
        + 'idproduto,'
        + 'qtd,'
        + 'valor_unit,'
        + 'valor_total)'
        + ' values'
        + '(' + IntToStr(fPedido.idpedido) + ','
        + IntToStr(idproduto) + ','
        + FloatToSql(qtd) + ','
        + FloatToSql(valor_unit) + ','
        + ' round(' + FloatToSql(valor_total) + ', 2))')
  else
    ExecSql('Update pedido_item set '
        + ' idproduto = ' + IntToStr(idproduto) + ','
        + ' qtd = ' + FloatToSql(qtd) + ','
        + ' valor_unit = ' + FloatToSql(valor_unit) + ','
        + ' valor_total = ' + ' Round(' + FloatToSql(valor_total) + ', 2)'
        + ' where idpedido_item = ' + IntToStr(idpedido_item));
end;

end.
