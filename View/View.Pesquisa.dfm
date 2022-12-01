object Pesquisa: TPesquisa
  Left = 0
  Top = 0
  Caption = 'Pesquisa'
  ClientHeight = 325
  ClientWidth = 696
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 696
    Height = 325
    Align = alClient
    DataSource = DataSource1
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
    OnKeyPress = DBGrid1KeyPress
    Columns = <
      item
        Expanded = False
        FieldName = 'codigo'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'descricao'
        Width = 426
        Visible = True
      end>
  end
  object Table: TFDQuery
    SQL.Strings = (
      'SELECT idpedido codigo, '#39'teste'#39' descricao FROM wktech.pedido')
    Left = 242
    Top = 116
  end
  object DataSource1: TDataSource
    DataSet = Table
    Left = 240
    Top = 168
  end
end
