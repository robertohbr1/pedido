program TestePedido;

uses
  Vcl.Forms,
  View.Pedido in 'View\View.Pedido.pas' {FormPedido},
  View.Pesquisa in 'View\View.Pesquisa.pas' {Pesquisa},
  Model.Main in 'Model\Model.Main.pas' {DM: TDataModule},
  Model.Pedido in 'Model\Model.Pedido.pas',
  Controller.Pedido in 'Controller\Controller.Pedido.pas',
  Controller.Utilities in 'Controller\Controller.Utilities.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPedido, FormPedido);
  ReportMemoryLeaksOnShutdown := True;
  Application.Run;
end.
