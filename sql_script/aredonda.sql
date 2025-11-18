-- ---------------------------------------------------------
-- 1. CRIAÇÃO DA ESTRUTURA (DDL)
-- ---------------------------------------------------------

CREATE DATABASE IF NOT EXISTS `PizzariaARedondaDB`;
USE `PizzariaARedondaDB`;

-- Tabela de Clientes
CREATE TABLE Clientes (
    ClienteID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(150) NOT NULL,
    Telefone VARCHAR(15) NOT NULL UNIQUE,
    Endereco VARCHAR(255) NULL,
    DataCadastro DATE NOT NULL
);

-- Tabela de Cardápio
CREATE TABLE Cardapio (
    ItemCardapioID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL UNIQUE,
    Descricao VARCHAR(255),
    Preco DECIMAL(10, 2) NOT NULL CHECK (Preco > 0),
    Tipo VARCHAR(50) NOT NULL, 
    Tamanho VARCHAR(50) NULL 
);

-- Tabela de Pedidos
CREATE TABLE Pedidos (
    PedidoID INT AUTO_INCREMENT PRIMARY KEY,
    ClienteID INT NOT NULL,
    DataHora DATETIME NOT NULL,
    TipoEntrega VARCHAR(50) NOT NULL, 
    TaxaEntrega DECIMAL(10, 2) NOT NULL,
    Total DECIMAL(10, 2) NOT NULL,
    Status VARCHAR(50) NOT NULL,
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

-- Tabela de Detalhes do Pedido (Itens)
CREATE TABLE DetalhesPedido (
    DetalheID INT AUTO_INCREMENT PRIMARY KEY,
    PedidoID INT NOT NULL,
    ItemCardapioID INT NOT NULL,
    Quantidade INT NOT NULL CHECK (Quantidade > 0),
    Subtotal DECIMAL(10, 2) NOT NULL,
    Observacoes VARCHAR(255) NULL,
    FOREIGN KEY (PedidoID) REFERENCES Pedidos(PedidoID),
    FOREIGN KEY (ItemCardapioID) REFERENCES Cardapio(ItemCardapioID),
    UNIQUE (PedidoID, ItemCardapioID)
);

-- ---------------------------------------------------------
-- 2. INSERÇÃO DE DADOS (DML)
-- ---------------------------------------------------------

-- Inserindo Clientes
INSERT INTO Clientes (Nome, Telefone, Endereco, DataCadastro) VALUES
('Felipe Mendes', '11987654321', 'Rua das Margaridas, 100', '2025-01-15'),
('Beatriz Costa', '21991234567', 'Av. Atlântica, 500', '2025-02-20'),
('Carlos Pereira', '31988776655', 'Rua da Serra, 45', '2025-03-05');

-- Inserindo Cardápio
INSERT INTO Cardapio (Nome, Descricao, Preco, Tipo, Tamanho) VALUES
('Mussarela', 'Molho, mussarela e orégano.', 45.00, 'Pizza', 'Média'),
('Calabresa', 'Molho, mussarela, calabresa e cebola.', 55.00, 'Pizza', 'Grande'),
('Portuguesa', 'Molho, mussarela, presunto, ovo, cebola.', 60.00, 'Pizza', 'Grande'),
('Coca-Cola Lata', '350ml', 7.00, 'Bebida', NULL),
('Borda Recheada', 'Catupiry Original', 12.00, 'Adicional', NULL);

-- Inserindo Pedidos
INSERT INTO Pedidos (ClienteID, DataHora, TipoEntrega, TaxaEntrega, Total, Status) VALUES
(1, '2025-11-18 19:30:00', 'Delivery', 10.00, 65.00, 'Entregue'),
(2, '2025-11-18 20:00:00', 'Retirada', 0.00, 60.00, 'Concluído'),
(3, '2025-11-18 20:45:00', 'Delivery', 10.00, 84.00, 'Em Preparo');

-- Inserindo Itens nos Pedidos
INSERT INTO DetalhesPedido (PedidoID, ItemCardapioID, Quantidade, Subtotal, Observacoes) VALUES
(1, 2, 1, 55.00, 'Sem pimenta'), -- Pedido 1: Calabresa
(2, 3, 1, 60.00, 'Sem cebola'),  -- Pedido 2: Portuguesa
(3, 2, 1, 55.00, NULL),          -- Pedido 3: Calabresa
(3, 5, 1, 12.00, NULL),          -- Pedido 3: Borda
(3, 4, 2, 14.00, 'Gelada');      -- Pedido 3: 2x Coca-Cola
