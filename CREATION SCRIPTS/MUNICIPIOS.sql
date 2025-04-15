drop table director;
drop table comercial;
drop table resto_empleados;
drop table autor;
drop table venta;
drop table vendedor;
drop table cliente;
drop table oficina;
drop table datos_personales;


-- CREAR TABLA DATOS PERSONALES
CREATE TABLE datos_personales (
dni CHAR(9) PRIMARY KEY,
nombre VARCHAR2(15),
primer_apellido VARCHAR(15),
segundo_apellido VARCHAR2(15),
domicilio VARCHAR2(25),
telefono NUMBER(9),
correo VARCHAR(30)
);

-- CREAR TABLA DIRECTOR
CREATE TABLE director (
dni_director PRIMARY KEY,
CONSTRAINT director_datos_personales FOREIGN KEY (dni_director) REFERENCES datos_personales(dni)
);

-- CREAR TABLA COMERCIAL
CREATE TABLE comercial (
dni_comercial PRIMARY KEY,
CONSTRAINT comercial_datos_personales FOREIGN KEY (dni_comercial) REFERENCES datos_personales(dni),
comision VARCHAR2(15)
);

-- CREAR TABLA RESTO EMPLEADOS
CREATE TABLE resto_empleados (
dni_resto_empleados PRIMARY KEY,
CONSTRAINT resto_empleados_datos_personales FOREIGN KEY (dni_resto_empleados) REFERENCES datos_personales(dni),
cargo VARCHAR2(15)
);

-- CREAR TABLA AUTOR
CREATE TABLE autor (
dni_autor PRIMARY KEY,
CONSTRAINT autor_datos_personales FOREIGN KEY (dni_autor) REFERENCES datos_personales(dni),
cuenta VARCHAR2(25)
);

-- CREAR TABLA OFICINA
CREATE TABLE oficina (
codigo_oficina CHAR(5) PRIMARY KEY,
director VARCHAR2(15),
felefono NUMBER(9),
oficina_dni_director NOT NULL,
CONSTRAINT oficina1_datos_personales FOREIGN KEY (oficina_dni_director) REFERENCES datos_personales(dni),
oficina_dni_comercial NOT NULL,
CONSTRAINT oficina2_datos_personales FOREIGN KEY (oficina_dni_comercial) REFERENCES datos_personales(dni)
);

-- CREAR TABLA VENDEDOR
CREATE TABLE vendedor (
turno VARCHAR2(10) NOT NULL,
dni_vendedor PRIMARY KEY,
CONSTRAINT vendedor_datos_personales FOREIGN KEY (dni_vendedor) REFERENCES datos_personales(dni),
vendedor_codigo_oficina NOT NULL,
CONSTRAINT vendedor_oficina FOREIGN KEY (vendedor_codigo_oficina) REFERENCES oficina(codigo_oficina)
);

-- CREAR TABLA CLIENTE
CREATE TABLE cliente (
numtarjera CHAR(12) NOT NULL,
dni_cliente PRIMARY KEY,
CONSTRAINT cliente_datos_personales FOREIGN KEY (dni_cliente) REFERENCES datos_personales(dni)
);

-- CREAR TABLA VENTA
CREATE TABLE venta (
codventa CHAR(5) PRIMARY KEY,
fecha DATE,
cantlineas NUMBER(10),
tipo VARCHAR(20),
venta_dni_vendedor NOT NULL,
CONSTRAINT venta_vendedor FOREIGN KEY (venta_dni_vendedor) REFERENCES vendedor(dni_vendedor),
venta_dni_cliente NOT NULL,
CONSTRAINT venta_cliente FOREIGN KEY (venta_dni_cliente) REFERENCES cliente(dni_cliente)
);