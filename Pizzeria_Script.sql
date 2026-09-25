CREATE DATABASE [db_pizzeria]
GO

USE [db_pizzeria]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- CREACION DE TABLAS
-- =============================================

-- 1. TABLA MAESTRA: T_Pizzas
CREATE TABLE [dbo].[T_Pizzas](
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[n_pizza] [varchar](50) NOT NULL,
	[precio] [decimal](18, 2) NOT NULL,
	[esta_activa] [bit] NOT NULL CONSTRAINT [DF_T_Pizzas_esta_activa] DEFAULT (1),
 CONSTRAINT [PK_T_Pizzas] PRIMARY KEY CLUSTERED 
(
	[codigo] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- 2. TABLA DETALLE: T_Ingredientes
CREATE TABLE [dbo].[T_Ingredientes](
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[codigo_pizza] [int] NOT NULL,
	[n_ingrediente] [varchar](50) NOT NULL,
	[cantidad] [float] NULL,
	[unidad] [varchar](10) NULL,
 CONSTRAINT [PK_T_Ingredientes] PRIMARY KEY CLUSTERED 
(
	[codigo] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- RELACION CLAVE FORANEA (1 a N)
ALTER TABLE [dbo].[T_Ingredientes] WITH CHECK ADD CONSTRAINT [FK_T_Ingredientes_T_Pizzas] FOREIGN KEY([codigo_pizza])
REFERENCES [dbo].[T_Pizzas] ([codigo])
GO

ALTER TABLE [dbo].[T_Ingredientes] CHECK CONSTRAINT [FK_T_Ingredientes_T_Pizzas]
GO

-- =============================================
-- INSERCION DE DATOS DE PRUEBA
-- =============================================

SET IDENTITY_INSERT [dbo].[T_Pizzas] ON 
INSERT [dbo].[T_Pizzas] ([codigo], [n_pizza], [precio], [esta_activa]) VALUES (1, N'Pizza Muzzarella', 8500.00, 1)
INSERT [dbo].[T_Pizzas] ([codigo], [n_pizza], [precio], [esta_activa]) VALUES (2, N'Pizza Especial Jamón y Morrones', 11000.00, 1)
SET IDENTITY_INSERT [dbo].[T_Pizzas] OFF
GO

SET IDENTITY_INSERT [dbo].[T_Ingredientes] ON 
-- Ingredientes para Pizza Muzzarella (codigo_pizza = 1)
INSERT [dbo].[T_Ingredientes] ([codigo], [codigo_pizza], [n_ingrediente], [cantidad], [unidad]) VALUES (1, 1, N'Masa Clásica', 1, N'unidad')
INSERT [dbo].[T_Ingredientes] ([codigo], [codigo_pizza], [n_ingrediente], [cantidad], [unidad]) VALUES (2, 1, N'Salsa de Tomate', 150, N'ml')
INSERT [dbo].[T_Ingredientes] ([codigo], [codigo_pizza], [n_ingrediente], [cantidad], [unidad]) VALUES (3, 1, N'Queso Muzzarella', 300, N'g')
INSERT [dbo].[T_Ingredientes] ([codigo], [codigo_pizza], [n_ingrediente], [cantidad], [unidad]) VALUES (4, 1, N'Aceitunas Verdes', 8, N'unidades')

-- Ingredientes para Pizza Especial (codigo_pizza = 2)
INSERT [dbo].[T_Ingredientes] ([codigo], [codigo_pizza], [n_ingrediente], [cantidad], [unidad]) VALUES (5, 2, N'Masa Clásica', 1, N'unidad')
INSERT [dbo].[T_Ingredientes] ([codigo], [codigo_pizza], [n_ingrediente], [cantidad], [unidad]) VALUES (6, 2, N'Salsa de Tomate', 150, N'ml')
INSERT [dbo].[T_Ingredientes] ([codigo], [codigo_pizza], [n_ingrediente], [cantidad], [unidad]) VALUES (7, 2, N'Queso Muzzarella', 350, N'g')
INSERT [dbo].[T_Ingredientes] ([codigo], [codigo_pizza], [n_ingrediente], [cantidad], [unidad]) VALUES (8, 2, N'Jamón Cocido', 150, N'g')
INSERT [dbo].[T_Ingredientes] ([codigo], [codigo_pizza], [n_ingrediente], [cantidad], [unidad]) VALUES (9, 2, N'Morrones Rojos', 100, N'g')
SET IDENTITY_INSERT [dbo].[T_Ingredientes] OFF
GO

-- =============================================
-- STORED PROCEDURES (DINAMICA DE TRANSACCION Y CONSULTAS)
-- =============================================

-- 1. SP INSERTAR MAESTRO (Retorna el ID autogenerado)
CREATE PROCEDURE [dbo].[SP_INSERTAR_MAESTRO] 
    @nombre varchar(50),
    @precio decimal(18,2),
    @id int OUTPUT
AS
BEGIN
    INSERT INTO T_Pizzas(n_pizza, precio, esta_activa) 
    VALUES (@nombre, @precio, 1);
    
    SET @id = SCOPE_IDENTITY();
END
GO

-- 2. SP INSERTAR DETALLE (El id del maestro va primero)
CREATE PROCEDURE [dbo].[SP_INSERTAR_DETALLE] 
    @codigo_pizza int,
    @nombre varchar(50),
    @cantidad float = NULL,
    @unidad varchar(10) = NULL
AS
BEGIN
    INSERT INTO T_Ingredientes (codigo_pizza, n_ingrediente, cantidad, unidad) 
    VALUES (@codigo_pizza, @nombre, @cantidad, @unidad);
END
GO

-- 3. SP GUARDAR / ACTUALIZAR PIZZA
CREATE PROCEDURE [dbo].[SP_GUARDAR_PIZZA]
    @codigo int,
    @nombre varchar(50),
    @precio decimal(18,2)
AS
BEGIN 
    IF @codigo = 0
        BEGIN
            INSERT INTO T_Pizzas (n_pizza, precio, esta_activa) 
            VALUES (@nombre, @precio, 1);
        END
    ELSE
        BEGIN
            UPDATE T_Pizzas 
            SET n_pizza = @nombre, precio = @precio 
            WHERE codigo = @codigo;
        END
END
GO

-- 4. SP RECUPERAR TODAS LAS PIZZAS
CREATE PROCEDURE [dbo].[SP_RECUPERAR_PIZZAS] 
AS
BEGIN
    SELECT * FROM T_Pizzas WHERE esta_activa = 1;
END
GO

-- 5. SP RECUPERAR PIZZA POR CODIGO CON SUS INGREDIENTES
CREATE PROCEDURE [dbo].[SP_RECUPERAR_PIZZA_POR_CODIGO]
    @codigo int
AS
BEGIN
    SELECT p.codigo AS pizza_codigo, p.n_pizza, p.precio, p.esta_activa,
           i.codigo AS ingrediente_codigo, i.n_ingrediente, i.cantidad, i.unidad
    FROM T_Pizzas p
    LEFT JOIN T_Ingredientes i ON i.codigo_pizza = p.codigo
    WHERE p.codigo = @codigo AND p.esta_activa = 1;
END
GO

-- 6. SP BAJA LOGICA DE PIZZA
CREATE PROCEDURE [dbo].[SP_REGISTRAR_BAJA_PIZZA] 
    @codigo int 
AS
BEGIN
    UPDATE T_Pizzas SET esta_activa = 0 WHERE codigo = @codigo;
END
GO