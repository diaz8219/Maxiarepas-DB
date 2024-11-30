use master;

-- Creando base de datos

create database MaxiArepasActualizado;

use MaxiArepasActualizado;

go;

-- Creando tablas
create table Cliente(
	ID_Cliente int primary key,
	Nombre_Cliente varchar(40) not null,
	Apellido_Cliente varchar(40) not null,
	Email_Cliente varchar(40) not null unique
);

create table Mensaje_Satisfaccion(
	Cod_Mensaje int primary key,
	ID_Cliente int 
	foreign key (ID_Cliente) references Cliente(ID_Cliente),
	Mensaje_Satisfaccion varchar(200) not null,
	Calificacion int not null
);

create table Producto(
	Cod_Producto int primary key,
	Nombre_Producto varchar(40) not null,
	Precio_Producto int not null,
	Descripcion_Producto varchar(200) not null
);

create table Inventario(
	Cod_Inventario int primary key,
	Cod_Producto int 
	foreign key (Cod_Producto) references Producto(Cod_Producto),
	Fecha_Abastecimiento date,
	Cantidad_Inventario int not null
);

create table Venta(
	Cod_Venta int primary key,
	ID_Cliente int
	foreign key (ID_Cliente) references Cliente(ID_Cliente),
	Cod_Producto int
	foreign key (Cod_Producto) references Producto(Cod_Producto),
	Cantidad_Venta int not null,
	Precio_Total int not null,
	Fecha_Venta date not null
);

-- Insertando registros en masa
bulk insert Cliente
from 'D:\Bulk Insert\Cliente.txt';

bulk insert Producto
from 'D:\Bulk Insert\Productos_Arepas.txt';

bulk insert Inventario
from 'D:\Bulk Insert\Inventario.txt';

bulk insert Venta
from 'D:\Bulk Insert\Venta.txt';

bulk insert Mensaje_Satisfaccion
from 'D:\Bulk Insert\Mensaje.txt';

select * from Cliente;
select * from Producto;
select * from Inventario;
select * from Venta;
select * from Mensaje_Satisfaccion;



-- Creando procedimientos almacenados
create proc MensajesSatisfaccion
as
begin
	select 
		concat(Nombre_Cliente, ' ', Apellido_Cliente) as Nombre_Completo,
		Mensaje_Satisfaccion as Mensaje,
		Calificacion
	from Cliente
	inner join Mensaje_Satisfaccion on Cliente.ID_Cliente = Mensaje_Satisfaccion.ID_Cliente
	order by Nombre_Completo
end;

create proc CantidadVentas
as
begin
	select
		Pr.Cod_Producto,
		Pr.Nombre_Producto,
		sum(Ve.Cantidad_Venta) as Total_Vendido,
		sum(Ve.Precio_Total) as Total_Ingresos
	from Venta Ve
	inner join Producto Pr on Ve.Cod_Producto = Pr.Cod_Producto
	group by Pr.Cod_Producto, Pr.Nombre_Producto
	order by Total_Vendido desc
end;

exec CantidadVentas;
exec MensajesSatisfaccion;
