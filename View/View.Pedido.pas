unit View.Pedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Phys.MySQLDef, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  Vcl.Grids, Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Vcl.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, Vcl.Mask, Vcl.DBCtrls, System.ImageList, Vcl.ImgList,
  Vcl.NumberBox, Vcl.WinXPickers;

type
  TFormPedido = class(TForm)
    Panel1: TPanel;
    btnPesquisarPedido: TButton;
    btnBuscaCliente: TButton;
    btnBuscaProduto: TButton;
    ImageList1: TImageList;
    Panel2: TPanel;
    lblCliente: TLabel;
    Panel3: TPanel;
    lblProduto: TLabel;
    btnCriarPedido: TButton;
    Panel4: TPanel;
    Label5: TLabel;
    Panel5: TPanel;
    Label6: TLabel;
    Panel6: TPanel;
    Label7: TLabel;
    Panel7: TPanel;
    Label8: TLabel;
    Panel8: TPanel;
    Label9: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Panel9: TPanel;
    btnInserirProduto: TButton;
    Label10: TLabel;
    Label11: TLabel;
    edProduto: TEdit;
    nbQtd: TNumberBox;
    nbValor: TNumberBox;
    btnCancelarProduto: TButton;
    Panel10: TPanel;
    btnGravarPedido: TButton;
    btnCancelarPedido: TButton;
    btnAlterarPedido: TButton;
    edPedido: TEdit;
    edCliente: TEdit;
    nbTotal: TNumberBox;
    Grid: TStringGrid;
    edEmissao: TDatePicker;
    procedure btnPesquisarPedidoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnBuscaClienteClick(Sender: TObject);
    procedure btnBuscaProdutoClick(Sender: TObject);
    procedure edClienteChange(Sender: TObject);
    procedure btnCriarPedidoClick(Sender: TObject);
    procedure btnInserirProdutoClick(Sender: TObject);
    procedure edProdutoChange(Sender: TObject);
    procedure btnCancelarProdutoClick(Sender: TObject);
    procedure btnGravarPedidoClick(Sender: TObject);
    procedure btnCancelarPedidoClick(Sender: TObject);
    procedure btnAlterarPedidoClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure EditarProduto;
    procedure ConfigProduto(bEnabled: boolean);
    procedure ConfigAlterarProduto;
    procedure ConfigInserirProduto;
    procedure LimpaProduto;
    procedure ApagarProduto;
    procedure CalculaTotal;
    procedure AjustaBotoesPrincipais(bEdicao: boolean);
    procedure GravarPedido;
    procedure BuscaPedido(Chave: string);
    procedure LimpaCampos;
    procedure VaiUltimoPedido;
    procedure CarregaGrid;
    procedure FormatGrid;
    procedure GravaGrid;
    procedure LimpaGrid;
    procedure InsereGrid(idpedido_item, idproduto: integer; descricao: string; qtd, valor_unit: double);
    procedure UpdateGrid(row: integer; qtd, valor_unit: double);

  public
    { Public declarations }
  end;

Const
// Configuração do Grid
  COL_IDPEDIDO_ITEM = 0;
  COL_IDPRODUTO = 1;
  COL_DESCRICAO = 2;
  COL_QTD = 3;
  COL_VALOR_UNIT = 4;
  COL_VALOR_TOTAL = 5;

type
  THackStringGrid = class(TStringGrid);

var
  FormPedido: TFormPedido;

implementation

{$R *.dfm}

uses Math, View.Pesquisa, Controler.Utils;

Const EditState = [dsEdit, dsInsert];

procedure TFormPedido.btnPesquisarPedidoClick(Sender: TObject);
begin
  if Pesquisar('PEDIDO') then
    BuscaPedido(PesquisaRetorno);
end;

procedure TFormPedido.BuscaPedido(Chave: string);
var Query: TFDQuery;
begin
  if Chave = '' then
    exit;

  AbreQuery(Query, 'select * from pedido where idpedido = ' + Chave);

  edPedido.Text := Query.FieldByName('idpedido').AsString;
  edEmissao.Date := Query.FieldByName('data_emissao').AsDateTime;
  edCliente.Text := Query.FieldByName('idcliente').AsString;
  nbTotal.Value := Query.FieldByName('valor_total').AsFloat;

  FechaQuery(Query);

  CarregaGrid;
end;

procedure TFormPedido.btnBuscaClienteClick(Sender: TObject);
begin
  if Pesquisar('CLIENTE') then
  begin
    edCliente.Text := PesquisaRetorno;
    SendKeysTab;
  end;
end;

procedure TFormPedido.AjustaBotoesPrincipais(bEdicao: boolean);
begin
  btnPesquisarPedido.Visible := not bEdicao;
  btnAlterarPedido.Visible := not bEdicao;
  btnCriarPedido.Visible := not bEdicao;
  btnGravarPedido.Visible := bEdicao;
  btnCancelarPedido.Visible := bEdicao;
  btnInserirProduto.Visible := bEdicao;
  edEmissao.Enabled := bEdicao;
  btnBuscaCliente.Visible := bEdicao;
  nbQtd.Enabled := bEdicao;
  nbValor.Enabled := bEdicao;

  btnBuscaProduto.Visible := bEdicao;
end;

procedure TFormPedido.ApagarProduto;
begin
  if not btnGravarPedido.Visible then
    exit;

  if Perguntar('Deseja apagar o Produto?') then
  begin
    with THackStringGrid(Grid) do
      DeleteRow(Grid.Row);
    CalculaTotal;
  end
  else
    raise Exception.Create('Operação Cancelada');
end;

procedure TFormPedido.btnAlterarPedidoClick(Sender: TObject);
begin
  AjustaBotoesPrincipais(True);
end;

procedure TFormPedido.btnBuscaProdutoClick(Sender: TObject);
begin
  if Pesquisar('PRODUTO') then
  begin
    edProduto.Text := PesquisaRetorno;
    SendKeysTab;
  end;
end;

procedure TFormPedido.btnCriarPedidoClick(Sender: TObject);
begin
  LimpaCampos;

  AjustaBotoesPrincipais(True);
end;

procedure TFormPedido.btnGravarPedidoClick(Sender: TObject);
begin
  ValidaCodigoExiste(edCliente, lblCliente.Caption);

  GravarPedido;
  AjustaBotoesPrincipais(False);
end;

procedure TFormPedido.CalculaTotal;
var
  I: Integer;
  Soma: double;
begin
  Soma := 0;
  for I := 1 to Grid.RowCount - 1 do
    Soma := Soma + StrToFloat(Grid.Cells[COL_VALOR_TOTAL, I]);

  nbTotal.Value := Soma;
end;

procedure TFormPedido.ConfigAlterarProduto;
begin
  ConfigProduto(False);
  btnInserirProduto.Caption := 'Alterar';
end;

procedure TFormPedido.ConfigInserirProduto;
begin
  ConfigProduto(True);
  btnInserirProduto.Caption := 'Inserir';
end;

procedure TFormPedido.LimpaCampos;
begin
  edPedido.Text := '';
  edEmissao.Date := now;
  edCliente.Text := '';
  nbTotal.Value := 0;

  LimpaGrid;
end;

procedure TFormPedido.LimpaGrid;
begin
  Grid.RowCount := 1;
end;

procedure TFormPedido.VaiUltimoPedido;
begin
  BuscaPedido(BuscaValor('select max(idpedido) from pedido'));
end;

procedure TFormPedido.LimpaProduto;
begin
  edProduto.Text := '';
  nbQtd.Value := 0;
  nbValor.Value := 0;
end;

procedure TFormPedido.ConfigProduto(bEnabled: boolean);
begin
  Grid.Enabled := bEnabled;
  btnBuscaProduto.Visible := bEnabled;
  btnCancelarProduto.Visible := not bEnabled;
end;

procedure TFormPedido.btnCancelarProdutoClick(Sender: TObject);
begin
  ConfigInserirProduto;
  LimpaProduto;
end;

procedure TFormPedido.btnCancelarPedidoClick(Sender: TObject);
begin
  if btnCancelarProduto.Visible then
    btnCancelarProduto.Click;
  AjustaBotoesPrincipais(False);
  VaiUltimoPedido;
end;

procedure TFormPedido.btnInserirProdutoClick(Sender: TObject);
begin
  ValidaVazio(edProduto, edProduto.Text, 'Informe o Produto');
  ValidaCodigoExiste(edProduto, lblProduto.Caption);

  ValidaZero(nbQtd, nbQtd.Value, 'Informe a Quantidade');
  ValidaZero(nbValor, nbValor.Value, 'Informe o Valor Unitário');

  if Grid.Enabled then
    InsereGrid(0, StrToInt(edProduto.Text), lblProduto.Caption, nbQtd.Value, nbValor.Value)
  else
  begin
    UpdateGrid(Grid.Row, nbQtd.Value, nbValor.Value);
    ConfigInserirProduto;
  end;

  LimpaProduto;
  CalculaTotal;
end;

procedure TFormPedido.edClienteChange(Sender: TObject);
begin
  lblCliente.Caption := BuscaDescricao('Select nome from cliente where idcliente = ', edCliente.Text);
end;

procedure TFormPedido.CarregaGrid;
var Query: TFDQuery;
begin
  LimpaGrid;

  AbreQuery(Query, 'SELECT pedido_item.*, produto.descricao '
      + ' FROM pedido_item '
      + ' inner join produto on pedido_item.idproduto = produto.idproduto '
      + ' where pedido_item.idpedido = ' + edPedido.Text);
  while not Query.Eof do
  begin
    InsereGrid( Query.FieldByName('idpedido_item').AsInteger,
                Query.FieldByName('idproduto').AsInteger,
                Query.FieldByName('descricao').AsString,
                Query.FieldByName('qtd').AsFloat,
                Query.FieldByName('valor_unit').AsFloat);
    Query.Next;
  end;
  FechaQuery(Query);
end;

procedure TFormPedido.edProdutoChange(Sender: TObject);
begin
  lblProduto.Caption := BuscaDescricao('Select descricao from produto where idproduto = ', edProduto.Text);
end;

procedure TFormPedido.FormatGrid;
  procedure DefColumn(col: integer; Caption: string; Width: integer; Align: TAlignment);
  begin
    Grid.Cells[col, 0] := Caption;
    Grid.ColWidths[col] := Width;
    Grid.ColAlignments[col] := Align;
  end;

begin
  LimpaGrid;

  DefColumn(COL_IDPEDIDO_ITEM,  'id',            0, taLeftJustify);
  DefColumn(COL_IDPRODUTO,      'Produto',      80, taLeftJustify);
  DefColumn(COL_DESCRICAO,      'Descrição',   300, taLeftJustify);
  DefColumn(COL_QTD,            'Qtd',          80, taRightJustify);
  DefColumn(COL_VALOR_UNIT,     'Valor Unit',   80, taRightJustify);
  DefColumn(COL_VALOR_TOTAL,    'Valor Total',  80, taRightJustify);
end;

procedure TFormPedido.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//
end;

procedure TFormPedido.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if btnGravarPedido.Visible then
    raise Exception.Create('Pedido não foi Concluído. Utilize o botão ' + btnGravarPedido.Caption
          + ' ou o botão ' + btnCancelarPedido.Caption);
end;

procedure TFormPedido.FormCreate(Sender: TObject);
begin
  AbreDM;

  FormatGrid;
  VaiUltimoPedido;
  AjustaBotoesPrincipais(False);
end;

procedure TFormPedido.FormDestroy(Sender: TObject);
begin
  FechaDM;
end;

procedure TFormPedido.GravaGrid;
var
  x: Integer;
begin
  // Marca os Itens com qtd = -1, para Deletar os que foram removidos do Grid
  ExecSql('update pedido_item set qtd = -1 where idpedido = ' + edPedido.Text);

  for x := 1 to Grid.RowCount -1 do
  begin
    if Grid.Cells[COL_IDPEDIDO_ITEM, x] = '0' then
      ExecSql('Insert into pedido_item '
          + '(idpedido,'
          + 'idproduto,'
          + 'qtd,'
          + 'valor_unit,'
          + 'valor_total)'
          + ' values'
          + '(' + edPedido.Text + ','
          + Grid.Cells[COL_IDPRODUTO, x] + ','
          + FloatToSql(Grid.Cells[COL_QTD, x].ToDouble) + ','
          + FloatToSql(Grid.Cells[COL_VALOR_UNIT, x].ToDouble) + ','
          + ' round(' + FloatToSql(Grid.Cells[COL_QTD, x].ToDouble) + ' * ' + FloatToSql(Grid.Cells[COL_VALOR_UNIT, x].ToDouble) + ', 2))')
    else
      ExecSql('Update pedido_item set '
          + ' idproduto = ' + Grid.Cells[COL_IDPRODUTO, x] + ','
          + ' qtd = ' + FloatToSql(Grid.Cells[COL_QTD, x].ToDouble) + ','
          + ' valor_unit = ' + FloatToSql(Grid.Cells[COL_VALOR_UNIT, x].ToDouble) + ','
          + ' valor_total = ' + ' Round(' + FloatToSql(Grid.Cells[COL_QTD, x].ToDouble) + ' * ' + FloatToSql(Grid.Cells[COL_VALOR_UNIT, x].ToDouble) + ', 2)'
          + ' where idpedido_item = ' + Grid.Cells[COL_IDPEDIDO_ITEM, x]);
  end;

  // Apaga os Itens com qtd = -1, pois foram removidos do Grid
  ExecSql('delete from pedido_item where idpedido = ' + edPedido.Text + ' and qtd = -1');
end;

procedure TFormPedido.GravarPedido;
begin
  TransStart;
  try
    if edPedido.text = '' then
    begin
      ExecSql('Insert into pedido (idcliente,data_emissao,valor_total) values'
        + '(' + edCliente.text + ',' + DateToSql(edEmissao.Date) + ','
        + FloatToSql(nbTotal.Value) + ')');
      edPedido.Text := BuscaValor('SELECT LAST_INSERT_ID()');
    end
    else
    begin
      ExecSql('update pedido set '
      + ' idcliente = ' + edCliente.text + ','
      + ' data_emissao = ' + DateToSql(edEmissao.Date) + ','
      + ' valor_total = ' + FloatToSql(nbTotal.Value)
      + ' where idpedido = ' + edPedido.Text);
    end;
    GravaGrid;

  except
  on E: Exception do
    begin
      TransRollBack;
      raise Exception.Create(E.Message);
    end;
  end;
  TransCommit;
end;

procedure TFormPedido.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Grid.Row = 0 then
    exit;

  if Key = VK_RETURN then
    EditarProduto;
  if Key = VK_DELETE then
    ApagarProduto;
end;

procedure TFormPedido.InsereGrid(idpedido_item, idproduto: integer;
  descricao: string; qtd, valor_unit: double);
var x: integer;
begin
  Grid.RowCount := Grid.RowCount + 1;
  x := Grid.RowCount - 1;
  Grid.Cells[COL_IDPEDIDO_ITEM, x] := idpedido_item.ToString;
  Grid.Cells[COL_IDPRODUTO, x] := idproduto.ToString;
  Grid.Cells[COL_DESCRICAO, x] := descricao;
  UpdateGrid(x, qtd, valor_unit);
end;

procedure TFormPedido.UpdateGrid(row: integer; qtd, valor_unit: double);
begin
  Grid.Cells[COL_QTD, row]         := FormatFloat('#0.00', qtd);
  Grid.Cells[COL_VALOR_UNIT, row]  := FormatFloat('#0.00', valor_unit);
  Grid.Cells[COL_VALOR_TOTAL, row] := FormatFloat('#0.00', qtd * valor_unit);
end;

procedure TFormPedido.EditarProduto;
begin
  if not btnGravarPedido.Visible then
    exit;

  edProduto.Text  := Grid.Cells[COL_IDPRODUTO, Grid.Row];
  nbQtd.Value     := Grid.Cells[COL_QTD, Grid.Row].ToDouble;
  nbValor.Value   := Grid.Cells[COL_VALOR_UNIT, Grid.Row].ToDouble;

  ConfigAlterarProduto;
end;

end.
