unit Model.Main;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, Data.DB,
  FireDAC.Comp.Client, Data.Win.ADODB;

type
  TDM = class(TDataModule)
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    WktechConnection: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    procedure AbreConnection;
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses IniFiles, Controller.Utils, Vcl.Dialogs;

procedure TDM.AbreConnection;
var oArquivoINI: Tinifile;
    Conectou: boolean;

  function LeChave(Chave: string) : string;
  begin
    Result := oArquivoINI.ReadString('Servidor', Chave, EmptyStr);
  end;

  procedure GravaChave(Chave: string);
  begin
    oArquivoIni.WriteString('Servidor', Chave, InputBox('Informe', Chave, LeChave(Chave)));
  end;

  procedure Configura;
  begin
    If Perguntar ('Problema na Conexão com o Banco de Dados MySQL. Tentar Configurar?') then
    begin
      GravaChave('Database');
      GravaChave('UserName');
      GravaChave('Password');
    end
    else
      Halt;
  end;

begin
  if WktechConnection.Connected then
    exit;

  Conectou := False;
  oArquivoINI := Tinifile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');
  while Not Conectou do
  begin
    with WktechConnection.Params do
    begin
      UserName := LeChave('UserName');
      Password := LeChave('Password');
      Database := LeChave('Database');
    end;
    try
      WktechConnection.Connected := True;
      Conectou := True;
    except
    on E: Exception do
      Configura;
    end;
  end;
  FreeAndNil(oArquivoINI);
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  AbreConnection;
end;

end.


