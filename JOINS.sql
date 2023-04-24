--JOINS
-- 1
-- Listado con las localidades, su ID, nombre y el nombre de la provincia a la que pertenece. 

SELECT l.IDLocalidad, l.Localidad, p.Provincia FROM Localidades l INNER JOIN Provincias p on l.IDProvincia=p.IDProvincia

-- 2..

-- Listado que informe el ID de la multa, el monto a abonar y los datos del agente que la realizó. Debe incluir los apellidos y nombres de los agentes. Así como también la fecha de nacimiento y la edad.

SELECT m.IdMulta, m.Monto, a.Apellidos, a.Nombres, a.FechaNacimiento, DATEDIFF(YEAR,0,GETDATE()- CAST(FechaNacimiento as datetime)) Edad FROM Multas m INNER JOIN Agentes a on m.IdAgente=a.IdAgente

-- 3
-- Listar todos los datos de todas las multas realizadas por agentes que a la fecha de hoy tengan más de 5 años de antigüedad.

SELECT * FROM Multas WHERE DATEDIFF(YEAR, 0, GETDATE() - CAST(FechaHora as datetime))>5

UPDATE Multas SET FechaHora='2017-02-22 09:10:00.000'
WHERE IdMulta=1 -- SE MODIFICA PARA PODER CORROBORAR LA CONSULTA

-- 4
-- Listar todos los datos de todas las multas cuyo importe de referencia supere los $15000.

SELECT * FROM Multas m INNER JOIN TipoInfracciones ti on m.IdTipoInfraccion=ti.IdTipoInfraccion WHERE ti.ImporteReferencia>15000

-- 5
-- Listar los nombres y apellidos de los agentes, sin repetir, que hayan labrado multas en la provincia de Buenos Aires o en Cordoba.

SELECT distinct a.Apellidos, a.Nombres, * FROM Agentes a LEFT JOIN Multas m on a.IdAgente=m.IdAgente INNER JOIN Localidades loc on m.IDLocalidad=loc.IDLocalidad INNER JOIN Provincias pr on loc.IDProvincia=pr.IDProvincia WHERE Provincia='Buenos Aires'

-- 6
-- Listar los nombres y apellidos de los agentes, sin repetir, que hayan labrado multas del tipo "Exceso de velocidad".

SELECT distinct a.Nombres, a.Apellidos FROM Agentes a LEFT JOIN Multas m on a.IdAgente=m.IdAgente inner join TipoInfracciones ti on m.IdTipoInfraccion= ti.IdTipoInfraccion WHERE ti.Descripcion='Exceso de velocidad'

-- 7
-- Listar apellidos y nombres de los agentes que no hayan labrado multas.

SELECT a.Apellidos, a.Nombres, m.IdMulta from Agentes a LEFT JOIN Multas m on a.IdAgente=m.IdAgente WHERE m.IdMulta is NULL

-- 8
-- Por cada multa, lista el nombre de la localidad y provincia, el tipo de multa, los apellidos y nombres de los agentes y su legajo, el monto de la multa y la diferencia en pesos en relación al tipo de infracción cometida.

SELECT m.IdMulta, loc.Localidad, pr.Provincia, ti.Descripcion, a.Apellidos, a.Nombres, a.Legajo, m.Monto, (m.Monto - ti.ImporteReferencia) DiferenciaMonto FROM Multas m INNER JOIN Localidades loc on m.IDLocalidad=loc.IDLocalidad INNER JOIN Provincias pr on loc.IDProvincia=pr.IDProvincia INNER JOIN Agentes a on m.IdAgente=a.IdAgente INNER JOIN TipoInfracciones ti on m.IdTipoInfraccion=ti.IdTipoInfraccion

-- 9
-- Listar las localidades en las que no se hayan registrado multas.

SELECT loc.Localidad, m.IdMulta FROM Localidades loc LEFT JOIN Multas m on loc.IDLocalidad=m.IDLocalidad WHERE m.IdMulta is NULL

-- 10
-- Listar los datos de las multas pagadas que se hayan labrado en la provincia de Buenos Aires.

SELECT * FROM Multas m LEFT JOIN Localidades loc on m.IDLocalidad= loc.IDLocalidad inner JOIN Provincias pr on loc.IDProvincia=pr.IDProvincia WHERE m.Pagada=0 and pr.Provincia='Buenos Aires'

-- 11
-- Listar el ID de la multa, la patente, el monto y el importe de referencia a partir del tipo de infracción cometida. También incluir una columna llamada TipoDeImporte a partir de las siguientes condiciones:
-- 'Punitorio' si el monto de la multa es mayor al importe de referencia
-- 'Leve' si el monto de la multa es menor al importe de referencia
-- 'Justo' si el monto de la multa es igual al importe de referencia

SELECT m.IdMulta, m.Patente, m.Monto, ti.ImporteReferencia,
case
when m.Monto>ti.ImporteReferencia then 'Punitorio'
when m.Monto<ti.ImporteReferencia then 'Leve'
when m.Monto=ti.ImporteReferencia then 'Justo'
end as TipoImporte 
FROM Multas m INNER JOIN TipoInfracciones ti on m.IdTipoInfraccion=ti.IdTipoInfraccion