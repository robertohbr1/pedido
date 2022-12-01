object DM: TDM
  OldCreateOrder = False
  Height = 244
  Width = 746
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'C:\Projetos\Job\WKTech\Output\libmysql.dll'
    Left = 160
    Top = 56
  end
  object WktechConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=wktech')
    LoginPrompt = False
    Left = 382
    Top = 56
  end
end
