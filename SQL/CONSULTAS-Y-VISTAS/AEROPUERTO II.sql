/* ====== CONSULTAS Y VISTAS AEROPUERTO II ====== */

/* 11. Crear una vista sobre la tabla partes y sus 
columnas num_parte y fecha para los partes con hora 
de llegada posterior a las 12.00.00 ¿Cuál es la fecha 
de llegada más tardía? Borre la vista */

CREATE OR REPLACE VIEW VISTA_PARTES AS
    SELECT NUM_PARTE,FECHA AS FECHA FROM PARTES WHERE TO_CHAR(HORA_LLEGADA,'HH/MM/SS') > '12/00/00';

SELECT * FROM VISTA_PARTES;

DROP VIEW VISTA_PARTES;

-- COMPROBAR HORAS DE LLEGADA
SELECT NUM_PARTE,TO_CHAR(HORA_LLEGADA,'HH/MM/SS') AS HORA_LLEGADA FROM PARTES;

/* 12. Visualizar los  dos primeros caracteres de 
los números de vuelo y el destino de los vuelos a 
que corresponden partes con combustibles consumidos 
mayores que un tercio de la media de todos los 
combustibles consumidos. Ordenarlos alfabéticamente 
por destinos */

SELECT DISTINCT SUBSTR(V.NUM_VUELO,1,2) AS NUM_VUELO,DESTINO
FROM VUELOS V
LEFT JOIN PARTES P ON V.NUM_VUELO=P.NUM_VUELO
WHERE COMB_CONSUMIDO > (SELECT AVG(P2.COMB_CONSUMIDO) FROM PARTES P2)*1/3
ORDER BY DESTINO;

/* 13. Obtener los número de vuelos de aquellos que 
recorren una distancia mayor que la media de las que 
recorren los vuelos que parten del mismo origen */

SELECT NUM_VUELO
FROM VUELOS V
WHERE DISTANCIA > (SELECT AVG(V2.DISTANCIA) FROM VUELOS V2 WHERE V2.ORIGEN=V.ORIGEN);

/* 14. Crear una vista sobre la tabla partes con sus 
columnas num_parte y comb_consumido para los vuelos en 
que se consumió más de 1500 litros. ¿Cuántos partes hay 
en la vista? Borre la vista */

CREATE OR REPLACE VIEW VISTA_PARTE AS
    SELECT NUM_PARTE,COMB_CONSUMIDO
    FROM PARTES P
    WHERE COMB_CONSUMIDO > 1500;

SELECT * FROM VISTA_PARTE;

DROP VIEW VISTA_PARTE;

/* 15. Visualizar el total de plazas libres por número
de vuelo para los realizados desde Madrid a Barcelona 
o Sevilla y que recorran una distancia menor que la media
de todos los vuelos que salen de Madrid. Ordenarlos de 
menor a mayor */

SELECT PLAZAS_LIBRES,R.NUM_VUELO
FROM RESERVAS R
LEFT JOIN VUELOS V ON V.NUM_VUELO=R.NUM_VUELO
WHERE V.ORIGEN LIKE 'MADRID' AND (V.DESTINO LIKE 'BARCELONA' OR V.DESTINO LIKE 'SEVILLA') AND
      V.DISTANCIA < (SELECT AVG(V2.DISTANCIA) FROM VUELOS V2 WHERE V2.ORIGEN LIKE 'MADRID')
ORDER BY PLAZAS_LIBRES;

/* 16. Obtener los número de vuelos de aquellos que 
recorren una distancia menor que la media de las que 
recorren los vuelos que llegan a su mismo destino */

SELECT NUM_VUELO
FROM VUELOS V
WHERE DISTANCIA < (SELECT AVG(V2.DISTANCIA) FROM VUELOS V2 WHERE V2.DESTINO LIKE V.DESTINO);

/* 17.	Crear una vista sobre la tabla partes con sus 
columnas num_parte y comb_consumido para los partes con 
fecha entre el 28 y el 30 de Septiembre de 1993. 
Visualizar todo el contenido de la vista. Borrar la vista. */

CREATE OR REPLACE VIEW VISTA_PARTES AS
    SELECT NUM_PARTE,COMB_CONSUMIDO
    FROM PARTES P
    WHERE FECHA BETWEEN '28/09/93' AND '30/09/93';

SELECT * FROM VISTA_PARTES;

DROP VIEW VISTA_PARTES;

/* 18.	Visualizar el número de vuelo y la media de 
las plazas libres por número de vuelo para los realizados 
desde Barcelona o Sevilla a Madrid y que recorren una 
distancia menor que la media de todos de los vuelos que 
llegan a Madrid más 10.  Ordenarlos de menor a mayor
Hacerlo con Join, Exists y Subselect */

SELECT R.NUM_VUELO,AVG(PLAZAS_LIBRES) AS PLAZAS_LIBRES
FROM RESERVAS R
LEFT JOIN VUELOS V ON R.NUM_VUELO=V.NUM_VUELO
WHERE (V.ORIGEN LIKE 'BARCELONA' OR V.ORIGEN LIKE 'SEVILLA') AND V.DESTINO LIKE 'MADRID' AND
      V.DISTANCIA < (SELECT AVG(V2.DISTANCIA) FROM VUELOS V2 WHERE V2.DESTINO LIKE 'MADRID')+10
GROUP BY R.NUM_VUELO
ORDER BY PLAZAS_LIBRES;

/* 19.	Obtener, para cada número de vuelo, el total de 
plazas libres de los vuelos que recorren distancias mayores 
que la media de las distancias recorridas por vuelos de 
las misma compañía */

SELECT V.NUM_VUELO,PLAZAS_LIBRES
FROM RESERVAS R
LEFT JOIN VUELOS V ON V.NUM_VUELO=R.NUM_VUELO
WHERE V.DISTANCIA > (SELECT AVG(V2.DISTANCIA) FROM VUELOS V2 WHERE SUBSTR(V.NUM_VUELO,1,2) LIKE SUBSTR(V2.NUM_VUELO,1,2));

/* 20.	Crear una vista sobre la tabla vuelos con las 
columnas num_vuelo y tipo_avion con las distancias 
recorridas mayores a 900. Visualizar los datos de la 
vista para los vuelos de Iberia. Borrar la vista */

CREATE OR REPLACE VIEW VISTA_VUELOS AS
    SELECT NUM_VUELO,TIPO_AVION,DISTANCIA
    FROM VUELOS V
    WHERE DISTANCIA > 900 AND
          SUBSTR(NUM_VUELO,1,2) LIKE 'IB';

SELECT * FROM VISTA_VUELOS;

DROP VIEW VISTA_VUELOS;

/* 21.	Crear una vista con las ciudades y la suma de 
las capacidades de los aviones que salen de  esas ciudades. 
Se debe obtener información solo de las ciudades de las 
que al menos salgan tres vuelos. */

CREATE OR REPLACE VIEW VISTA_CAPACIDADES AS
    SELECT ORIGEN, SUM(CAPACIDAD) AS CAPACIDAD
    FROM  VUELOS V
    LEFT JOIN AVIONES A ON TIPO_AVION=TIPO
    WHERE 3 <= (SELECT COUNT(V2.ORIGEN) FROM VUELOS V2 WHERE V.ORIGEN LIKE V2.ORIGEN GROUP BY V2.ORIGEN)
    GROUP BY ORIGEN;

SELECT * FROM VISTA_CAPACIDADES;

DROP VIEW VISTA_CAPACIDADES;
