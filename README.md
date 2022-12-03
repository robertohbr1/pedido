# pedido
Pedido em Delphi e MySQL sem uso de componentes de BD

Melhorias:
- Removi a FDConn da Pesquisa
- Permite informar os códigos, e incluir uma nova Validação para evitar que o usuário informe código inválido (antes não era necessário, pois era só através da busca)
- Corrigido problema no Criar, que não limpava Grid
- Criei configuração de Conexão via INI. Será solicitado na primeira vez.
- Padrão MVC
- Não encontrei problema na TabOrder. Se existir, por favor, me informe onde.

Outras Melhorias Possíveis (se necessário, posso fazer):
-  Tela de Pesquisa 
    - Incluir opção de Filtro para Busca
    - Remover Componente Table e DS
- Tela de Configuração da Conexão 
    - Criar uma tela com os 3 campos: Banco, User, Password
