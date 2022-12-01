program TestePedido;

uses
  Vcl.Forms,
  Pedido in 'Pedido.pas' {FormPedido},
  formPesquisa in 'formPesquisa.pas' {Pesquisa},
  Utils in 'Utils.pas',
  DMMain in 'DMMain.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPedido, FormPedido);
  Application.CreateForm(TDM, DM);
  ReportMemoryLeaksOnShutdown := True;
  Application.Run;
end.
