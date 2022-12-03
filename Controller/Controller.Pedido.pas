unit Controller.Pedido;

interface

uses System.Generics.Collections, Model.Pedido;

{$M+}

Type
  tControllerPedidoItem = class;

  tControllerPedido = class(TObject)
  private
    fidpedido: Integer;
    fdata_emissao:  TDate;
    fidcliente: integer;
    fvalor_total: Double;

    mdPedido: TModelPedido;
    FPedidoItem: TObjectList<tControllerPedidoItem>;

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

    property PedidoItem: TObjectList<tControllerPedidoItem> read FPedidoItem write FPedidoItem;
  end;


  tControllerPedidoItem = class(TObject)
  private
    fPedido: tControllerPedido;
    fPedidoItem: tModelPedidoItem;
    fidpedido_item: Integer;
    fidproduto: Integer;
    fqtd: Double;
    fvalor_unit: Double;
    fvalor_total: Double;
    FDescricao: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Save;

  published
    property Pedido: tControllerPedido read fPedido write fPedido;
    property idpedido_item: Integer read fidpedido_item write fidpedido_item;
    property idproduto: Integer read fidproduto write fidproduto;
    property qtd: Double read fqtd write fqtd;
    property valor_unit: Double read fvalor_unit write fvalor_unit;
    property valor_total: Double read Fvalor_total write Fvalor_total;
    property Descricao: string read FDescricao;
  end;

implementation

uses
  System.SysUtils;

{ tControllerPedido }

procedure tControllerPedido.AddItem(xIdPedidoItem, xIdProduto: integer;
      xDescricao : string;  xQtd, xValor_Unit, xValor_Total: double);
begin
  FPedidoItem.Add(tControllerPedidoItem.Create);
  With FPedidoItem.Items[FPedidoItem.Count -1] do
  begin
    idpedido_item := xIdPedidoItem;
    idproduto := xIdProduto;
    FDescricao := xDescricao;
    qtd := xQtd;
    valor_unit := xValor_Unit;
    valor_total := xValor_Total;
  end;

  mdPedido.AddItem(xIdPedidoItem, xIdProduto, xDescricao, xQtd, xValor_Unit, xValor_Total);
end;

procedure tControllerPedido.CarregaItens;
var x: Integer;
begin
  FPedidoItem.Clear;

  for x := 0 to mdPedido.PedidoItem.Count - 1 do
  begin
    With mdPedido.PedidoItem[x] do
      AddItem(
          idpedido_item,
          idproduto,
          descricao,
          qtd,
          valor_unit,
          valor_total);
  end;
end;

constructor tControllerPedido.Create;
begin
  mdPedido := TModelPedido.Create;
  FPedidoItem := TObjectList<tControllerPedidoItem>.Create;
end;

destructor tControllerPedido.Destroy;
begin
  FreeAndNil(FPedidoItem);
  FreeAndNil(mdPedido);
  Inherited;
end;

procedure tControllerPedido.LimpaItens;
begin
  FPedidoItem.Clear;
  mdPedido.LimpaItens;
end;

procedure tControllerPedido.Read(Chave: string);
begin
  mdPedido.Read(Chave);
  idcliente := mdPedido.idcliente;
  data_emissao := mdPedido.data_emissao;
  valor_total := mdPedido.valor_total;
  idpedido := mdPedido.idpedido;

  CarregaItens;
end;

procedure tControllerPedido.Save;
begin
  mdPedido.idcliente := idcliente;
  mdPedido.data_emissao := data_emissao;
  mdPedido.valor_total := valor_total;
  mdPedido.idpedido := idpedido;

  mdPedido.Save;

  idpedido := mdPedido.idpedido;
end;

procedure tControllerPedido.SetData_emissao(const Value: TDate);
begin
  fdata_emissao := Value;
end;

procedure tControllerPedido.SetIdcliente(const Value: integer);
begin
  fidcliente := Value;
end;

procedure tControllerPedido.SetIdpedido(const Value: Integer);
begin
  fidpedido := Value;
end;

procedure tControllerPedido.SetValor_total(const Value: Double);
begin
  fvalor_total := Value;
end;

function tControllerPedido.Ultimo: integer;
begin
  Result := mdPedido.Ultimo;
end;

{ tControllerPedidoItem }

constructor tControllerPedidoItem.Create;
begin
  fPedidoItem := tModelPedidoItem.Create;
end;

destructor tControllerPedidoItem.Destroy;
begin
  FreeAndNil(fPedidoItem);
  inherited;
end;

procedure tControllerPedidoItem.Save;
begin
  fPedidoItem.Save;
end;

end.
