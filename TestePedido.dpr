program TestePedido;

uses
  Vcl.Forms,
  View.Pedido in 'View\View.Pedido.pas' {FormPedido},
  View.Pesquisa in 'View\View.Pesquisa.pas' {Pesquisa},
  Controler.Utils in 'Controler\Controler.Utils.pas',
  Model.Main in 'Model\Model.Main.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPedido, FormPedido);
  Application.CreateForm(TDM, DM);
  ReportMemoryLeaksOnShutdown := True;
  Application.Run;
end.
