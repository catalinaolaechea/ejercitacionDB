
-- BLOQUE 1
-- Mostrar código, nombre y salario de todos los empleados que ganen más de 50000.
-- Ordenar de mayor a menor salario.

select empl_codigo, empl_nombre, empl_salario from Empleado 
where empl_salario > 50000
order by empl_salario desc

-- Mostrar código y detalle de los depósitos ubicados en la zona '001'
select depo_codigo, depo_detalle from DEPOSITO
where depo_zona = '001'

-- Mostrar los clientes cuyo límite de crédito esté entre 500 y 3000.
-- Ordenar por límite de crédito.

select * from Cliente 
where clie_limite_credito between 500 and 3000
order by clie_limite_credito

-- BLOQUE 2 
/*
Mostrar:
Código de producto
Detalle del producto
Detalle del rubro al que pertenece
*/
select prod_codigo, prod_detalle, rubr_detalle from Producto 
left join Rubro on prod_rubro = rubr_id

/*
Mostrar:
Nombre y apellido del empleado
Nombre del departamento al que pertenece
*/
select empl_nombre, empl_apellido, depa_detalle from Empleado
left join Departamento on empl_departamento = depa_codigo


/*
Mostrar:
Código de cliente
Razón social
Nombre y apellido del vendedor asignado
*/
select clie_codigo, clie_razon_social, empl_nombre, empl_apellido from Cliente
left join Empleado on empl_codigo = clie_vendedor


-- BLOQUE 3
-- Mostrar el stock total por producto.
select prod_codigo, prod_detalle , sum (stoc_cantidad)
from Producto left join STOCK on stoc_producto = prod_codigo
group by prod_codigo, prod_detalle

--Mostrar cuántos productos hay por rubro.
select  rubr_detalle, count(*) from Rubro join Producto on prod_rubro = rubr_id
group by rubr_detalle

-- Mostrar cuántos depósitos tiene asignado cada encargado.
select empl_nombre, empl_apellido, count(*) from Empleado join DEPOSITO on depo_encargado = empl_codigo
group by empl_nombre, empl_apellido

-- BLOQUE 4
-- Mostrar los productos cuyo stock total sea mayor a 1000

select prod_codigo, prod_detalle, sum(stoc_cantidad) as total_stock from Producto inner join STOCK on stoc_producto = prod_codigo
group by prod_codigo, prod_detalle
having sum(stoc_cantidad) > 1000

-- Mostrar los clientes que hicieron más de 5 facturas.
select clie_codigo as cliente ,count(*) as cantidad_de_facturas from Cliente inner join Factura on clie_codigo = fact_cliente
group by clie_codigo 
having count(*) > 5

-- Mostrar los productos que se vendieron más de 100 unidades en total.
select prod_codigo, prod_detalle info_producto , sum(item_cantidad) as cantidad_total from Producto inner join Item_Factura on item_producto = prod_codigo
group by  prod_codigo, prod_detalle 
having sum(item_cantidad) > 100

-- BLOQUE 5
-- Mostrar los productos cuyo precio sea mayor al precio promedio de todos los productos.

select prod_detalle as producto, prod_precio as precio from Producto 
where prod_precio > (
	select AVG(prod_precio) from Producto
)

-- Mostrar los empleados que ganan más que el promedio de su departamento.
select empl_nombre, empl_apellido from Empleado as e
where empl_salario > (
	select avg(empl_salario) from Empleado
	where empl_departamento = e.empl_departamento
)

-- TOP siempre va con ORDER BY

-- Mostrar los clientes que compraron algo en el año 2012 (CONSULTAR)
select clie_codigo from Cliente
where (select count(fact_numero) from Factura where fact_cliente = clie_codigo and year(fact_fecha) = 2012 ) >= 1

select clie_codigo as cliente from Cliente 
inner join Factura on fact_cliente = clie_codigo
where year(fact_fecha) = 2012 
group by clie_codigo


-- BLOQUE 6 
-- Mostrar el producto más caro de toda la base.

select TOP 1 prod_codigo, prod_detalle, prod_precio from Producto 
where prod_precio > (
	select avg(prod_precio) from Producto
)
order by prod_precio desc

-- Mostrar el cliente que más dinero gastó en total (complicado)
select top 1 clie_codigo, sum(fact_total) as total_gastado from Cliente 
inner join Factura on fact_cliente = clie_codigo  
group by clie_codigo
order by 2 desc

-- Mostrar el depósito con mayor stock total.


-- Mostrar para el o los artículos que tengan stock en todos los depósitos, nombre del 
-- artículo, stock del depósito que más stock tiene. 

select stoc_producto , max(stoc_cantidad)
from STOCK 
where stoc_producto in (
	select stoc_producto
	from stock 
	group by stoc_producto
	having count(distinct stoc_deposito) = (
		select count(*) from deposito
	)
)
GROUP BY stoc_producto

-- Mostrar el cliente que realizó la compra de mayor importe.
-- Mostrar: código de cliente, número de factura, total de la factura
select fact_cliente, fact_numero, fact_total from Factura 
where fact_total = (select max(fact_total) from Factura)

-- Mostrar los clientes que compraron en TODOS los años registrados en la tabla Factura.
-- Mostrar: código de cliente, cantidad de años distintos en que compró
select fact_cliente, count(distinct year(fact_fecha)) as antiguedad  from Factura 
group by fact_cliente
having count(distinct year(fact_fecha)) = ( 
	select count(distinct year(fact_fecha)) from Factura 
)

-- Mostrar el código del jefe, código del empleado que lo tiene como jefe, nombre del 
-- mismo y la cantidad de depósitos que ambos tienen asignados. 

select empl.empl_codigo, empl.empl_nombre , jefe.empl_jefe, 
count(distinct depo_jefe.depo_codigo) as depositos_jefe, count(distinct depo_empl.depo_codigo) as depositos_empl 
from Empleado empl inner join Empleado jefe on empl.empl_jefe = jefe.empl_codigo
left join DEPOSITO depo_empl on empl.empl_codigo = depo_empl.depo_encargado
left join DEPOSITO depo_jefe on jefe.empl_codigo = depo_jefe.depo_encargado
group by empl.empl_codigo, empl.empl_nombre , jefe.empl_jefe 

/*
Mostrar los 10 productos más vendidos en la historia y también los 10 productos menos 
vendidos en la historia. Además mostrar de esos productos, quien fue el cliente que 
mayor compra realizo. 
*/


select 
    empl.empl_codigo, 
    empl.empl_nombre , 
    jefe.empl_codigo, 
count(distinct depo_jefe.depo_codigo) + count(distinct depo_empl.depo_codigo) as depositos_empl 
from Empleado empl 
    inner join Empleado jefe 
        on empl.empl_jefe = jefe.empl_codigo
    left join DEPOSITO depo_jefe 
        on jefe.empl_codigo = depo_jefe.depo_encargado
    left join DEPOSITO depo_empl 
        on empl.empl_codigo = depo_empl.depo_encargado

group by 
    empl.empl_codigo, 
    empl.empl_nombre , 
    jefe.empl_codigo

select * from Empleado
