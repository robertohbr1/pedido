unit Controller.Pedido;

interface

uses
  Model.Pedido;

{$M+}

Type
  tControllerPedido = class(TObject)
  private
    fidpedido: Integer;
    fdata_emissao:  TDate;
    fidcliente: integer;
    fvalor_total: Double;

    mdPedido: TModelPedido;

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

uses
  System.SysUtils;

{ tControllerPedido }

constructor tControllerPedido.Create;
begin
  mdPedido := TModelPedido.Create;
end;

destructor tControllerPedido.Destroy;
begin
  FreeAndNil(mdPedido);
  Inherited;
end;

procedure tControllerPedido.Read(Chave: string);
begin
  mdPedido.Read(Chave);
  idcliente := mdPedido.idcliente;
  data_emissao := mdPedido.data_emissao;
  valor_total := mdPedido.valor_total;
  idpedido := mdPedido.idpedido;
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

end.
