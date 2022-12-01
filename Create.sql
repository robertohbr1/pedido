#CREATE SCHEMA `wktech` ;

CREATE TABLE cliente (
idcliente INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100)  NOT NULL, 
cidade VARCHAR(100)  NOT NULL, 
uf VARCHAR(2)  NOT NULL);

Insert into cliente (nome, cidade, uf) 
select nome, cidade, 'AB' from (
select 'Elgoe' nome, 'Sloazrose' cidade
union select 'Usfor','Khiujeka'
union select 'Gouxin','Bazlagos'
union select 'Hazas','Sliutrery'
union select 'Kaizi','Groyinas'
union select 'Cilue','Jioweles'
union select 'Zuri','Rabraco'
union select 'Ruovu','Ripedo'
union select 'Cogol','Nedrok'
union select 'Boesei','Prezraco'
union select 'Zyegol','Shuazlathe'
union select 'Caiel','Klovlence'
union select 'Cupoi','Soofago'
union select 'Ragehaur','Criokane'
union select 'Feinsios','Chaxul'
union select 'Keyfin','Ozhifrans'
union select 'Lasuo','Aplokresa'
union select 'Byaer','Diecico'
union select 'Myugi','Phevlurgh'
union select 'Vali','Khenalo') a;

ALTER TABLE cliente ADD INDEX NOME (Nome ASC);

CREATE TABLE produto (
idproduto INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
descricao VARCHAR(100)  NOT NULL, 
preco  DECIMAL(19,3) NOT NULL);

Insert into produto (descricao, preco) 
select descricao, preco from (
select 'Abajur' descricao, 10 preco
union select 'Lata de refrigerante', 20
union select 'Carretel de fita', 15
union select 'Frasco de loção', 12
union select 'Par de luvas de borracha', 5
union select 'Toalhinha', 8
union select 'Óculos', 50 
union select 'Unha', 12
union select 'Bandeja de cubos de gelo', 8
union select 'Caixa de chocolates', 6
union select 'Escova de cabelo', 4
union select 'Controle remoto', 10 
union select 'Perfume', 105
union select 'Cinto de segurança', 18
union select 'Banco', 22
union select 'Par de luvas de borracha', 10
union select 'Pena', 13
union select 'Zíper', 8
union select 'Cachorro de pelúcia', 20
union select 'Vela', 1
union select 'Palito de dente', .5
union select 'Pá', 10
union select 'Cartão de felicitações', 6
union select 'Televisão', 999.99) a;

ALTER TABLE produto ADD INDEX DESCRICAO (Descricao ASC);

CREATE TABLE pedido (
idpedido INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
data_emissao DATETIME NOT NULL,
idcliente INT  NOT NULL, 
valor_total DECIMAL(19,2) NOT NULL);

ALTER TABLE pedido ADD INDEX FK_CLIENTE_idx (idcliente ASC);
ALTER TABLE pedido ADD CONSTRAINT FK_CLIENTE FOREIGN KEY (idcliente) REFERENCES cliente (idcliente);

CREATE TABLE pedido_item (
idpedido_item INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
idpedido INT NOT NULL,
idproduto INT NOT NULL,
qtd DECIMAL(19,2) NOT NULL,
valor_unit DECIMAL(19,2) NOT NULL,
valor_total DECIMAL(19,2) NOT NULL);

ALTER TABLE pedido_item ADD INDEX FK_PEDIDO_idx (idpedido ASC);
ALTER TABLE pedido_item ADD CONSTRAINT FK_PEDIDO FOREIGN KEY (idpedido) REFERENCES pedido (idpedido);

ALTER TABLE pedido_item ADD INDEX FK_PRODUTO_idx (idproduto ASC);
ALTER TABLE pedido_item ADD CONSTRAINT FK_PRODUTO FOREIGN KEY (idproduto) REFERENCES produto (idproduto);
