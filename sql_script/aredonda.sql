-- 1. Cria o banco de dados
CREATE DATABASE IF NOT EXISTS `GraosProsaDB`;

-- 2. Seleciona o banco de dados
USE `GraosProsaDB`;

-- 3. Cria a tabela de Produtos
CREATE TABLE Produtos (
    ProdutoID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL UNIQUE,
    Descricao VARCHAR(255),
    Preco DECIMAL(10, 2) NOT NULL CHECK (Preco > 0),
    Categoria VARCHAR(50) NOT NULL
);

-- 4. Cria a tabela de Clientes
CREATE TABLE Clientes (
    ClienteID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(150) NOT NULL,
    Telefone VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    DataCadastro DATE NOT NULL
);

-- 5. Cria a tabela de Pedidos
CREATE TABLE Pedidos (
    PedidoID INT AUTO_INCREMENT PRIMARY KEY,
    ClienteID INT,
    DataHora DATETIME NOT NULL,
    Status VARCHAR(50) NOT NULL,
    Total DECIMAL(10, 2) NOT NULL,
    
    -- Chave estrangeira para a tabela Clientes
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

-- 6. Cria a tabela de Itens do Pedido (Muitos para Muitos entre Produtos e Pedidos)
CREATE TABLE ItensPedido (
    ItemID INT AUTO_INCREMENT PRIMARY KEY,
    PedidoID INT NOT NULL,
    ProdutoID INT NOT NULL,
    Quantidade INT NOT NULL CHECK (Quantidade > 0),
    Subtotal DECIMAL(10, 2) NOT NULL,
    
    -- Chave estrangeira para a tabela Pedidos
    FOREIGN KEY (PedidoID) REFERENCES Pedidos(PedidoID),
    
    -- Chave estrangeira para a tabela Produtos
    FOREIGN KEY (ProdutoID) REFERENCES Produtos(ProdutoID),
    
    -- Garante que um produto só apareça uma vez por pedido
    UNIQUE (PedidoID, ProdutoID)
);