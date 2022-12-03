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
  Vcl.NumberBox, Vcl.WinXPickers, Controller.Pedido;

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
    procedure btnLimparProdutoClick(Sender: TObject);
  private
    { Private declarations }
    ctPedido: TControllerPedido;
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
    procedure LimpaGrid;
    procedure ValidaItemPendente;
    procedure InsereGrid(idpedido_item, idproduto: integer; descricao: string; qtd, valor_unit, valor_total: double);
    procedure UpdateGrid(row: integer; qtd, valor_unit, valor_total: double);

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

uses Math, View.Pesquisa, Controller.Utilities, View.Utilities;

Const EditState = [dsEdit, dsInsert];

procedure TFormPedido.btnPesquisarPedidoClick(Sender: TObject);
begin
  if Pesquisar('PEDIDO') then
    BuscaPedido(PesquisaRetorno);
end;

procedure TFormPedido.BuscaPedido(Chave: string);
begin
  if Chave = '' then
    exit;

  ctPedido.Read(Chave);

  With ctPedido do
  begin
    edPedido.Text := IntToStr(idpedido);
    edEmissao.Date := data_emissao;
    edCliente.Text := IntToStr(idcliente);
    nbTotal.Value := valor_total;
  end;

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
  btnCancelarProduto.Visible := bEdicao;
  btnInserirProduto.Visible := bEdicao;
  btnBuscaCliente.Visible := bEdicao;
  btnBuscaProduto.Visible := bEdicao;

  edEmissao.Enabled := bEdicao;
  nbQtd.Enabled := bEdicao;
  nbValor.Enabled := bEdicao;
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
  ValidaItemPendente;

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
  btnCancelarProduto.Caption := 'Cancelar';
end;

procedure TFormPedido.ConfigInserirProduto;
begin
  ConfigProduto(True);
  btnInserirProduto.Caption := 'Inserir';
  btnCancelarProduto.Caption := 'Limpar';
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
  BuscaPedido(ctPedido.Ultimo.ToString);
end;

procedure TFormPedido.ValidaItemPendente;

  procedure GeraRaise(Msg: string);
  begin
    raise Exception.Create('Item ainda não foi ' + Msg + ' no Grid.')
  end;

begin
  if edProduto.text <> '' then
  begin
    if btnInserirProduto.Caption = 'Inserir' then
      GeraRaise('Inserido')
    else
      GeraRaise('Alterado');
  end;
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
end;

procedure TFormPedido.btnCancelarProdutoClick(Sender: TObject);
begin
  ConfigInserirProduto;
  LimpaProduto;
end;

procedure TFormPedido.btnCancelarPedidoClick(Sender: TObject);
begin
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
    InsereGrid(0, StrToInt(edProduto.Text), lblProduto.Caption, nbQtd.Value, nbValor.Value, nbQtd.Value * nbValor.Value)
  else
  begin
    UpdateGrid(Grid.Row, nbQtd.Value, nbValor.Value, nbQtd.Value * nbValor.Value);
    ConfigInserirProduto;
  end;

  LimpaProduto;
  CalculaTotal;
end;

procedure TFormPedido.btnLimparProdutoClick(Sender: TObject);
begin
  LimpaProduto;
end;

procedure TFormPedido.edClienteChange(Sender: TObject);
begin
  lblCliente.Caption := BuscaDescricaoCliente(edCliente.Text);
end;

procedure TFormPedido.CarregaGrid;
var x: Integer;
begin
  LimpaGrid;
  with ctPedido do
    for x := 0 to PedidoItem.Count - 1 do
    begin
      with ctPedido.PedidoItem[x] do
        InsereGrid(
            idpedido_item,
            idproduto,
            descricao,
            qtd,
            valor_unit,
            valor_total);
    end;
end;

procedure TFormPedido.edProdutoChange(Sender: TObject);
begin
  lblProduto.Caption := BuscaDescricaoProduto(edProduto.Text);
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

  ctPedido := TControllerPedido.Create;

  FormatGrid;
  VaiUltimoPedido;
  AjustaBotoesPrincipais(False);
end;

procedure TFormPedido.FormDestroy(Sender: TObject);
begin
  FreeAndNil(ctPedido);

  FechaDM;
end;

procedure TFormPedido.GravarPedido;
var x: Integer;
begin
  With ctPedido do
  begin
    idcliente := StrToInt(edCliente.text);
    data_emissao := edEmissao.Date;
    valor_total := nbTotal.Value;
    idpedido := StrToInt('0' + edPedido.Text);

    LimpaItens;

    for x := 1 to Grid.RowCount -1 do
    begin
      AddItem(
          Grid.Cells[COL_IDPEDIDO_ITEM, x].ToInteger,
          Grid.Cells[COL_IDPRODUTO, x].ToInteger,
          Grid.Cells[COL_DESCRICAO, x],
          Grid.Cells[COL_QTD, x].ToDouble,
          Grid.Cells[COL_VALOR_UNIT, x].ToDouble,
          Grid.Cells[COL_VALOR_TOTAL, x].ToDouble);
    end;

    Save;

    BuscaPedido(IntToStr(idPedido));
  end;
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
  descricao: string; qtd, valor_unit, valor_total: double);
var x: integer;
begin
  Grid.RowCount := Grid.RowCount + 1;
  x := Grid.RowCount - 1;
  Grid.Cells[COL_IDPEDIDO_ITEM, x] := idpedido_item.ToString;
  Grid.Cells[COL_IDPRODUTO, x] := idproduto.ToString;
  Grid.Cells[COL_DESCRICAO, x] := descricao;
  UpdateGrid(x, qtd, valor_unit, valor_total);
end;

procedure TFormPedido.UpdateGrid(row: integer; qtd, valor_unit, valor_total: double);
begin
  Grid.Cells[COL_QTD, row]         := FormatFloat('#0.00', qtd);
  Grid.Cells[COL_VALOR_UNIT, row]  := FormatFloat('#0.00', valor_unit);
  Grid.Cells[COL_VALOR_TOTAL, row] := FormatFloat('#0.00', valor_total);
end;

procedure TFormPedido.EditarProduto;
begin
  if not btnGravarPedido.Visible then
    exit;

  ValidaItemPendente;

  edProduto.Text  := Grid.Cells[COL_IDPRODUTO, Grid.Row];
  nbQtd.Value     := Grid.Cells[COL_QTD, Grid.Row].ToDouble;
  nbValor.Value   := Grid.Cells[COL_VALOR_UNIT, Grid.Row].ToDouble;

  ConfigAlterarProduto;
end;

end.
