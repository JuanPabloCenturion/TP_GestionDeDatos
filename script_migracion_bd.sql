USE [GD2C2021]

-- CREACION DEL ESQUEMA

GO
CREATE SCHEMA ESQUEMA
GO

CREATE TABLE ESQUEMA.MARCA(
	MARCA_ID INT PRIMARY KEY IDENTITY(1,1),
	MARCA_NOMBRE NVARCHAR(255)
)

CREATE TABLE ESQUEMA.MATERIAL(
	MATERIAL_ID INT PRIMARY KEY IDENTITY(1,1),
	MATERIAL_NOMBRE NVARCHAR(255),
	MATERIAL_DESCRIPCION NVARCHAR(255)
)

CREATE TABLE ESQUEMA.TIPO_TAREA(
	TIPO_TAREA_ID INT PRIMARY KEY IDENTITY(1,1),
	TIPO_TAREA_TIPO NVARCHAR(255),
	TIPO_TAREA_DESCRIPCION NVARCHAR(255)
)

CREATE TABLE ESQUEMA.TAREA(
	TAREA_ID INT PRIMARY KEY IDENTITY(1,1),
	TAREA_NOMBRE NVARCHAR(255),
	TAREA_DESCRIPCION NVARCHAR(255),
	TAREA_TIPO_ID INT REFERENCES ESQUEMA.TIPO_TAREA(TIPO_TAREA_ID)
)

CREATE TABLE ESQUEMA.MATERIAL_X_TAREA(
	MATERIAL_X_TAREA_MATERIAL_ID INT,
	MATERIAL_X_TAREA_TAREA_ID INT,
	MATERIAL_X_TAREA_CANTIDAD INT
)

CREATE TABLE ESQUEMA.CIUDAD(
	CIUDAD_ID INT PRIMARY KEY IDENTITY(1,1),
	CIUDAD_NOMBRE NVARCHAR(255)
)

CREATE TABLE ESQUEMA.ESTADO(
	ESTADO_ID INT PRIMARY KEY IDENTITY(1,1),
	ESTADO_DESCRIPCION NVARCHAR(255)
)

CREATE TABLE ESQUEMA.RECORRIDO(
	RECORRIDO_ID INT PRIMARY KEY IDENTITY(1,1),
	RECORRIDO_CIUDAD_ORIGEN INT REFERENCES ESQUEMA.CIUDAD(CIUDAD_ID),
	RECORRIDO_CIUDAD_DESTINO INT REFERENCES ESQUEMA.CIUDAD(CIUDAD_ID),
	RECORRIDO_KM_RECORIDOS INT,
	RECORRIDO_PRECIO_RECORRIDO DECIMAL(18,2)
)

CREATE TABLE ESQUEMA.MODELO_CAMION(
	MODELO_CAMION_ID INT PRIMARY KEY IDENTITY(1,1),
	MODELO_CAMION_DESCRIPCION NVARCHAR(255),
	MODELO_CAMION_VELOCIDAD_MAXIMA INT,
	MODELO_CAMION_CAPACIDAD_TANQUE INT,
	MODELO_CAMION_CAPACIDAD_CARGA INT,
	MODELO_CAMION_MARCA_ID INT REFERENCES ESQUEMA.MARCA(MARCA_ID)
)

CREATE TABLE ESQUEMA.CAMION(
	CAMION_PATENTE NVARCHAR(255) PRIMARY KEY,
	CAMION_NRO_CHASIS NVARCHAR(255), 
	CAMION_NRO_MOTOR NVARCHAR(255),
	CAMION_FECHA_ALTA DATETIME,
	CAMION_MODELO_ID INT REFERENCES ESQUEMA.MODELO_CAMION(MODELO_CAMION_ID)
)

CREATE TABLE ESQUEMA.CHOFER(
	CHOFER_NRO_LEGAJO INT PRIMARY KEY,
	CHOFER_NOMBRE NVARCHAR(255),
	CHOFER_APELLIDO NVARCHAR(255),
	CHOFER_DNI DECIMAL(18,2), 
	CHOFER_DIRECCION NVARCHAR(255),
	CHOFER_TELEFONO INT,
	CHOFER_MAIL NVARCHAR(225),
	CHOFER_FECHA_NACIMIENTO DATETIME,
	CHOFER_COSTO_HOAR INT
)

CREATE TABLE ESQUEMA.VIAJE(
	VIAJE_NRO INT PRIMARY KEY IDENTITY(1,1),
	VIAJE_CAMION_ID NVARCHAR(255) REFERENCES ESQUEMA.CAMION(CAMION_PATENTE),
	VIAJE_CHOFER_ID INT REFERENCES ESQUEMA.CHOFER(CHOFER_NRO_LEGAJO), 
	VIAJE_FECHA_INICIO DATETIME,
	VIAJE_FECHA_FIN DATETIME,
	VIAJE_CONSUMO_COMBUSTIBLE DECIMAL(18,2),
	VIAJE_CANTIDAD_PAQUETES INT,
	VIAJE_RECORIDO_ID INT REFERENCES ESQUEMA.CHOFER(CHOFER_NRO_LEGAJO)
)

CREATE TABLE ESQUEMA.TIPO_PAQUETE(
	TIPO_PAQUETE_ID INT PRIMARY KEY IDENTITY(1,1),
	TIPO_PAQUETE_DESCRIPCION NVARCHAR(255),
	TIPO_PAQUETE_ANCHO_MAXIMO DECIMAL(18,2),
	TIPO_PAQUETE_ALTO_MAXIMO DECIMAL(18,2),
	TIPO_PAQUETE_LARGO_MAXIMO DECIMAL(18,2),
	TIPO_PAQUETE_PESO_MAXIMO DECIMAL(18,2),
	TIPO_PAQUETE_PRECIO DECIMAL(18,2)
)

CREATE TABLE ESQUEMA.PAQUETE(
	PAQUETE_ID INT PRIMARY KEY IDENTITY(1,1),
	PAQUETE_VIAJE_ID INT REFERENCES ESQUEMA.VIAJE(VIAJE_NRO),
	PAQUETE_PRECIO_FINAL DECIMAL(18,2),
	PAQUETE_TIPO_ID INT REFERENCES ESQUEMA.TIPO_PAQUETE(TIPO_PAQUETE_ID)
)

CREATE TABLE ESQUEMA.ORDEN_TRABAJO(
	ORDEN_TRABAJO_NRO INT PRIMARY KEY,
	ORDEN_TRABAJO_CAMION_ID NVARCHAR(255) REFERENCES ESQUEMA.CAMION(CAMION_PATENTE),
	ORDEN_TRABAJO_FECHA_GENERACION NVARCHAR(255),
	ORDEN_TRABAJO_ESTADO_ID INT REFERENCES ESQUEMA.ESTADO(ESTADO_ID)
)

CREATE TABLE ESQUEMA.MECANICO(
	MECANICO_NRO_LEGAJO INT PRIMARY KEY,
	MECANICO_TALLER_ID INT,
	MECANICO_NOMBRE NVARCHAR(255),
	MECANICO_APELLIDO NVARCHAR(255),
	MECANICO_DNI DECIMAL(18,2),
	MECANICO_DIRECCION NVARCHAR(255),
	MECANICO_TELEFONO INT,
	MECANICO_MAIL NVARCHAR(255),
	MECANICO_FECHA_NACIMIENTO DATETIME,
	MECANICO_COSTO_HORA INT
)

CREATE TABLE ESQUEMA.TAREA_ASIGNADA(
	TAREA_ASIGNADA_CODIGO INT PRIMARY KEY IDENTITY(1,1),
	TAREA_ASIGNADA_MECANICO_ID INT REFERENCES ESQUEMA.MECANICO(MECANICO_NRO_LEGAJO),
	TAREA_ASIGNADA_TAREA_ID INT REFERENCES ESQUEMA.TAREA(TAREA_ID),
	TAREA_ASIGNADA_TIEMPO_ESTIMADO INT,
	TAREA_ASIGNADA_TIEMPO_REAL INT,
	TAREA_ASIGNADA_FECHA_INICIO_ESTIMADA DATETIME,
	TAREA_ASIGNADA_FECHA_INICIO_REAL DATETIME,
	TAREA_ASIGNADA_FECHA_FIN DATETIME,
	TAREA_ASIGNADA_ORDEN_TRABAJO_ID INT REFERENCES ESQUEMA.ORDEN_TRABAJO(ORDEN_TRABAJO_NRO)
)

CREATE TABLE ESQUEMA.TALLER(
	TALLER_ID INT PRIMARY KEY IDENTITY(1,1),
	TALLER_DIRECCION NVARCHAR(255),
	TALLER_TELEFONO INT,
	TALLER_MAIL NVARCHAR(255),
	TALLER_NOMBRE NVARCHAR(255),
	TALLER_CIUDAD INT REFERENCES ESQUEMA.CIUDAD(CIUDAD_ID)
)


