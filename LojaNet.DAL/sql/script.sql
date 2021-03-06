USE [master]

CREATE DATABASE [LojaNetDb]
GO

USE [LojaNetDb]
GO

CREATE TABLE [dbo].[Cliente](
	[Id] [varchar](50) NOT NULL,
	[Nome] [varchar](100) NULL,
	[Email] [varchar](100) NULL,
	[Telefone] [varchar](50) NULL,
 CONSTRAINT [PK_Cliente] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[Pedido](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Data] [datetime] NULL,
	[ClienteId] [varchar](50) NULL,
	[FormaPagamentoId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PedidoItem](
	[PedidoId] [int] NOT NULL,
	[Ordem] [int] NOT NULL,
	[ProdutoId] [varchar](50) NULL,
	[Quantidade] [int] NULL,
	[Preco] [money] NULL,
PRIMARY KEY CLUSTERED 
(
	[PedidoId] ASC,
	[Ordem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Produto](
	[Id] [nvarchar](128) NOT NULL,
	[Nome] [nvarchar](max) NULL,
	[Preco] [decimal](18, 2) NOT NULL,
	[Estoque] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Produto] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE PROCEDURE [dbo].[ClienteAlterar]
@Id varchar(50),
@Nome varchar(100),
@Telefone varchar(100),
@Email varchar(50)

as

UPDATE Cliente SET Nome=@Nome, Email=@Email, Telefone=@Telefone
Where Id=@Id


GO
CREATE PROCEDURE [dbo].[ClienteExcluir]
@Id varchar(50)


as

DELETE FROM  Cliente Where Id=@Id


GO
CREATE PROCEDURE [dbo].[ClienteIncluir]
@Id varchar(50),
@Nome varchar(100),
@Email varchar(100),
@Telefone varchar(50)

as


INSERT INTO Cliente(Id, Nome, Email, Telefone)
VALUES (@Id, @Nome,@Email, @Telefone)
GO

CREATE PROCEDURE [dbo].[ClienteListar]

as


Select Id, Nome, Email, Telefone 
From Cliente
GO

CREATE PROCEDURE [dbo].[ClienteObterPorId]
@Id varchar(50)

as


Select Id, Nome, Email, Telefone
From Cliente
Where Id=@Id
GO

CREATE Procedure [dbo].[PedidoAlterar]
@Id int,
@Data DateTime,
@ClienteId varchar(50),
@FormaPagamentoId int

as

UPDATE Pedido set 
	ClienteId=@ClienteID, FormaPagamentoId=@FormaPagamentoId
Where Id=@Id

GO

Create Procedure [dbo].[PedidoExcluir]
@Id int

as

DELETE FROM PedidoItem Where PedidoId=@Id;
DELETE FROM Pedido Where Id=@Id;
GO

Create Procedure [dbo].[PedidoIncluir]

@Data DateTime,
@ClienteId varchar(50),
@FormaPagamentoId int

as

INSERT INTO Pedido(Data,ClienteId,FormaPagamentoId)
values(@Data,@CLienteId, @FormaPagamentoId);

SELECT @@Identity


GO
CREATE Procedure [dbo].[PedidoItemAlterar]

@PedidoId int,
@Ordem int,
@ProdutoId varchar(50),
@Quantidade int ,
@Preco money

as 

Update PedidoItem Set ProdutoId=@ProdutoId, Quantidade=@Quantidade, Preco=@Preco
Where PedidoId=@PedidoId and Ordem=@Ordem
GO
CREATE Procedure [dbo].[PedidoItemExcluir]

@PedidoId int,
@Ordem int

as 

DELETE FROM PedidoItem Where PedidoId=@PedidoId and Ordem=@Ordem
GO
CREATE Procedure [dbo].[PedidoItemExcluirExtras]

@PedidoId int,
@Ordem int

as 

DELETE FROM PedidoItem Where PedidoId=@PedidoId and Ordem>@Ordem
GO
CREATE Procedure [dbo].[PedidoItemIncluir]

@PedidoId int,
@Ordem int,
@ProdutoId varchar(50),
@Quantidade int,
@Preco money

as 

INSERT INTO PedidoItem(PedidoId,Ordem, ProdutoId,Quantidade, Preco)
values(@PedidoId,@Ordem, @ProdutoId,@Quantidade, @Preco)
GO

CREATE Procedure [dbo].[PedidoItemObterPorPedidoId]

@PedidoId int


as 

Select PedidoItem.PedidoId, PedidoItem.Ordem, PedidoItem.ProdutoId,PedidoItem.Quantidade, PedidoItem.Preco, Produto.Nome ProdutoNome
FROM PedidoItem
  INNER JOIN Produto on Produto.Id=PedidoItem.ProdutoId
Where PedidoId=@PedidoId
Order By PedidoItem.Ordem
GO
CREATE Procedure [dbo].[PedidoListar]

as

Select Pedido.Id, Pedido.ClienteId, Pedido.FormaPagamentoId, Pedido.Data, Cliente.Nome as ClienteNome
FROM Pedido
 INNER JOIN Cliente ON Cliente.Id=Pedido.ClienteId


GO
CREATE Procedure [dbo].[PedidoObterPorId]
@Id int

as

Select Pedido.Id, PEdido.ClienteId, Pedido.FormaPagamentoId, Pedido.Data, Cliente.Nome ClienteNome
FROM Pedido
  INNER JOIN Cliente ON Cliente.Id=Pedido.ClienteId
Where Pedido.Id=@Id
