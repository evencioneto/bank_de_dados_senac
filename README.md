# 🍕 Projeto de Banco de Dados: Pizzaria "A Redonda"

Bem-vindo ao repositório do projeto de banco de dados da **Pizzaria "A Redonda"**. Este projeto foi desenvolvido como parte de uma atividade acadêmica para demonstrar conhecimentos em modelagem de dados e linguagem SQL.

## 📖 Sobre o Projeto

O objetivo é criar um banco de dados relacional capaz de gerenciar as operações essenciais de uma pizzaria que opera com atendimento local e delivery.

O sistema foi modelado para armazenar:
* **Clientes:** Informações de contato e endereço para entregas.
* **Cardápio:** Produtos oferecidos (pizzas, bebidas, adicionais).
* **Pedidos:** Registro financeiro e logístico das vendas.
* **Detalhes do Pedido:** Itens específicos consumidos em cada venda.

---

## 🛠️ Estrutura do Banco de Dados (Schema)

Abaixo está a documentação das tabelas planejadas para o sistema:

### 1. Tabela: `Clientes`
| Atributo | Tipo | Restrições | Descrição |
| :--- | :--- | :--- | :--- |
| `ClienteID` | `INT` | **PK, AI** | Identificador único do cliente. |
| `Nome` | `VARCHAR(150)` | `NOT NULL` | Nome completo. |
| `Telefone` | `VARCHAR(15)` | `UNIQUE` | Telefone (chave para identificação no delivery). |
| `Endereco` | `VARCHAR(255)` | `NULL` | Endereço de entrega. |
| `DataCadastro`| `DATE` | `NOT NULL` | Data de registro. |

### 2. Tabela: `Cardapio`
| Atributo | Tipo | Restrições | Descrição |
| :--- | :--- | :--- | :--- |
| `ItemCardapioID`| `INT` | **PK, AI** | Identificador do item. |
| `Nome` | `VARCHAR(100)` | `UNIQUE` | Nome do produto. |
| `Descricao` | `VARCHAR(255)` | `NULL` | Ingredientes/Detalhes. |
| `Preco` | `DECIMAL(10,2)`| `CHECK > 0`| Preço unitário. |
| `Tipo` | `VARCHAR(50)` | `NOT NULL` | Categoria (Pizza, Bebida, etc). |
| `Tamanho` | `VARCHAR(50)` | `NULL` | P, M, G (apenas para pizzas). |

### 3. Tabela: `Pedidos`
| Atributo | Tipo | Restrições | Descrição |
| :--- | :--- | :--- | :--- |
| `PedidoID` | `INT` | **PK, AI** | Identificador do pedido. |
| `ClienteID` | `INT` | **FK** | Cliente que fez o pedido. |
| `DataHora` | `DATETIME` | `NOT NULL` | Momento da venda. |
| `TipoEntrega` | `VARCHAR(50)` | `NOT NULL` | Delivery ou Retirada. |
| `Total` | `DECIMAL(10,2)`| `NOT NULL` | Valor final da nota. |
| `Status` | `VARCHAR(50)` | `NOT NULL` | Situação atual (ex: Em preparo). |

### 4. Tabela: `DetalhesPedido`
| Atributo | Tipo | Restrições | Descrição |
| :--- | :--- | :--- | :--- |
| `DetalheID` | `INT` | **PK, AI** | Identificador da linha. |
| `PedidoID` | `INT` | **FK** | Vínculo com o pedido. |
| `ItemCardapioID`| `INT` | **FK** | Vínculo com o produto. |
| `Quantidade` | `INT` | `CHECK > 0`| Quantidade comprada. |
| `Subtotal` | `DECIMAL(10,2)`| `NOT NULL` | Preço * Quantidade. |

---

## 💻 Script SQL Completo

Copie o código abaixo e execute em seu SGBD (MySQL/MariaDB) para criar o banco e popular com dados de teste.

```sql
-- =====================================================
-- PARTE 1: DDL (Data Definition Language)
-- Criação da estrutura do banco de dados
-- =====================================================

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

-- Tabela de Detalhes (Itens do Pedido)
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

-- =====================================================
-- PARTE 2: DML (Data Manipulation Language)
-- Inserção de dados fictícios para teste
-- =====================================================

-- Inserindo Clientes
INSERT INTO Clientes (Nome, Telefone, Endereco, DataCadastro) VALUES
('Felipe Mendes', '11987654321', 'Rua das Margaridas, 100', '2025-01-15'),
('Beatriz Costa', '21991234567', 'Av. Atlântica, 500', '2025-02-20'),
('Carlos Pereira', '31988776655', 'Rua da Serra, 45', '2025-03-05');

-- Inserindo Produtos no Cardápio
INSERT INTO Cardapio (Nome, Descricao, Preco, Tipo, Tamanho) VALUES
('Mussarela', 'Molho, mussarela e orégano.', 45.00, 'Pizza', 'Média'),
('Calabresa', 'Molho, mussarela, calabresa e cebola.', 55.00, 'Pizza', 'Grande'),
('Portuguesa', 'Molho, mussarela, presunto, ovo.', 60.00, 'Pizza', 'Grande'),
('Coca-Cola Lata', '350ml', 7.00, 'Bebida', NULL),
('Borda Recheada', 'Catupiry Original', 12.00, 'Adicional', NULL);

-- Inserindo Pedidos
INSERT INTO Pedidos (ClienteID, DataHora, TipoEntrega, TaxaEntrega, Total, Status) VALUES
(1, '2025-11-18 19:30:00', 'Delivery', 10.00, 65.00, 'Entregue'),
(2, '2025-11-18 20:00:00', 'Retirada', 0.00, 60.00, 'Concluído'),
(3, '2025-11-18 20:45:00', 'Delivery', 10.00, 84.00, 'Em Preparo');

-- Inserindo Detalhes dos Pedidos
INSERT INTO DetalhesPedido (PedidoID, ItemCardapioID, Quantidade, Subtotal, Observacoes) VALUES
-- Pedido 1 (Felipe)
(1, 2, 1, 55.00, 'Sem pimenta'),
-- Pedido 2 (Beatriz)
(2, 3, 1, 60.00, 'Sem cebola'),
-- Pedido 3 (Carlos)
(3, 2, 1, 55.00, NULL),
(3, 5, 1, 12.00, NULL),
(3, 4, 2, 14.00, 'Gelada');
```

---

## 🎓 Conceitos Abordados: DDL vs DML

Para desenvolver este projeto, utilizamos dois subconjuntos fundamentais da linguagem SQL. Abaixo explicamos a diferença entre eles com exemplos extraídos do próprio código.

### 1. DDL (Data Definition Language)
É a parte do SQL responsável por definir a **estrutura** do banco de dados. Pense nisso como a "construção" da casa.

* **Função:** Criar, alterar ou excluir objetos (tabelas, bancos, índices).
* **Comandos Comuns:** `CREATE`, `ALTER`, `DROP`.
* **Exemplo no Projeto:**
    ```sql
    CREATE TABLE Pedidos (...);
    ```
    *Aqui estamos criando a estrutura onde os pedidos serão armazenados, mas não estamos inserindo nenhum pedido real ainda.*

### 2. DML (Data Manipulation Language)
É a parte responsável por gerenciar os **dados** dentro das estruturas criadas. Pense nisso como "mobiliar" a casa e viver nela.

* **Função:** Inserir, ler, atualizar e deletar registros (linhas).
* **Comandos Comuns:** `INSERT`, `UPDATE`, `DELETE`.
* **Exemplo no Projeto:**
    ```sql
    INSERT INTO Pedidos (...) VALUES (...);
    ```
    *Aqui estamos efetivamente registrando um pedido real no sistema.*

---

## ⚙️ Como Executar

1.  Certifique-se de ter um SGBD instalado (MySQL Workbench, DBeaver ou similar).
2.  Copie o script SQL completo da seção acima.
3.  Abra seu editor SQL e cole o código.
4.  Execute todo o script (Geralmente ícone de ⚡ ou `Ctrl+Enter`).
5.  Para verificar os dados, execute o comando de teste:
    ```sql
    SELECT * FROM Pedidos;
    ```

## 🎯 Conclusão

Ao finalizar este projeto, foi possível compreender na prática:
* A importância de definir tipos de dados corretos (`INT`, `DECIMAL`, `DATE`).
* Como relacionar tabelas usando **Chaves Estrangeiras** (`Foreign Keys`).
* A distinção clara entre a criação da estrutura (**DDL**) e a manipulação dos dados (**DML**).
