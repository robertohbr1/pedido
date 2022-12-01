unit formPesquisa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TPesquisa = class(TForm)
    DBGrid1: TDBGrid;
    Table: TFDQuery;
    DataSource1: TDataSource;
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function Pesquisar(Tabela : string): boolean;

var
  Pesquisa: TPesquisa;
  PesquisaRetorno: string;

implementation

uses DMMain;

{$R *.dfm}

function Pesquisar(Tabela : string): boolean;
var SQL : string;
begin
  if Tabela = 'PEDIDO' then
    SQL := 'SELECT idpedido codigo, concat(DATE_FORMAT(data_emissao,''%d/%m/%Y''), '' - '', cliente.nome) descricao '
            + ' FROM pedido inner join cliente on pedido.idcliente = cliente.idcliente order by 2 desc'
  else if Tabela = 'CLIENTE' then
    SQL := 'SELECT idcliente codigo, nome descricao FROM cliente order by 2'
  else if Tabela = 'PRODUTO' then
    SQL := 'SELECT idproduto codigo, descricao FROM produto order by 2'
  else
    raise Exception.Create('Tabela ' + Tabela + ' não configurada na Pesquisar');
  PesquisaRetorno := '';

  Application.CreateForm(TPesquisa, Pesquisa);

  With Pesquisa do
  begin
    Visible := False;
    Table.Connection := Dm.WktechConnection;
    Table.Active := False;
    Table.SQL.Text := SQL;
    Table.Active := True;
    ShowModal;
  end;

  Result := (PesquisaRetorno <> '');
  FreeAndNil(Pesquisa);
end;

procedure TPesquisa.DBGrid1DblClick(Sender: TObject);
begin
  PesquisaRetorno := Table.FieldByName('codigo').AsString;
  Pesquisa.Close;
end;

procedure TPesquisa.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    DBGrid1DblClick(Sender);
end;

end.
