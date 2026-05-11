
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