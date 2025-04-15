/* ====== CONSULTAS Y VISTAS AEROPUERTO I ====== */

/* 1. Obtener la capacidad de aquellos aviones con capacidad 
mayor que la media de los otros aviones y envergadura menor que 
la media de las diferentes envergaduras de los otros aviones */

SELECT CAPACIDAD
FROM AVIONES A
WHERE CAPACIDAD > (SELECT AVG(A2.CAPACIDAD) FROM AVIONES A2) AND
      ENVERGADURA < (SELECT AVG(A2.ENVERGADURA) FROM AVIONES A2);

/* 2. Cree una vista sobre la tabla aviones con las columnas 
envergadura y tipo para los aviones de los tipos 737 o 73S. 
¿Cuántos aviones hay en la vista? Borre la vista */

CREATE OR REPLACE VIEW ENV_TIPO AS
    SELECT ENVERGADURA,TIPO FROM AVIONES 
    WHERE TIPO LIKE '737' OR TIPO LIKE '73S';

SELECT * FROM ENV_TIPO;

DROP VIEW ENV_TIPO;

/* 3. Visualizar las tres primeras letras de los orígenes y 
destinos de los vuelos realizados por aviones con longitud 
mayor que 2/3 de la media y envergadura menor la máxima 
envergadura menos 5, ordenados alfabéticamente por destino
Obtener la solución por subselect, join y exists */

SELECT DISTINCT SUBSTR(ORIGEN,1,3) AS ORIGEN,DESTINO
FROM VUELOS V
LEFT JOIN AVIONES A ON TIPO_AVION=TIPO
WHERE LONGITUD > (SELECT AVG(A2.LONGITUD) FROM AVIONES A2)*2/3 AND
      ENVERGADURA < (SELECT MAX(A2.ENVERGADURA) FROM AVIONES A2)-5
ORDER BY DESTINO;

/* 4. Obtener la longitud de aquellos aviones con longitud 
menor que la media de los otros aviones y capacidad mayor que 
la media de las diferentes capacidades de los otros aviones */

SELECT LONGITUD,CAPACIDAD
FROM AVIONES A
WHERE LONGITUD < (SELECT AVG(A2.LONGITUD) FROM AVIONES A2 WHERE A.LONGITUD<>A2.LONGITUD) AND
      CAPACIDAD > (SELECT AVG(A2.CAPACIDAD) FROM AVIONES A2 WHERE A.CAPACIDAD<>A2.CAPACIDAD);

/* 5. Crear una vista sobre la tabla aviones con las columnas 
tipo y longitud para los aviones cuya longitud sea menor que la 
envergadura mas 10. ¿Cuál es la mayor longitud de la vista? 
Borrar la vista */

CREATE OR REPLACE VIEW TIPO_LONG AS
    SELECT TIPO,LONGITUD FROM AVIONES WHERE LONGITUD<ENVERGADURA+10;

SELECT * FROM TIPO_LONG;

DROP VIEW TIPO_LONG;

/* 6. Visualizar los primeros 2 caracteres de los num_vuelo y 
el origen de los vuelos a los que corresponden partes con número 
de parte entre 2 y 8 y que recorren distancias mayores que la 
media , ordenándolos alfabéticamente por origen */

SELECT DISTINCT SUBSTR(V.NUM_VUELO,1,2) AS NUM_VUELO,ORIGEN
FROM VUELOS V
LEFT JOIN PARTES P ON V.NUM_VUELO=P.NUM_VUELO
WHERE NUM_PARTE BETWEEN 2 AND 8 AND
      DISTANCIA > (SELECT AVG(V2.DISTANCIA) FROM VUELOS V2)
ORDER BY ORIGEN;

/* 7. Obtenga la longitud de los aviones que realizan vuelos 
que recorren distancias mayores que la media de las distancias 
de los vuelos recorridos por la misma compañía */

SELECT DISTINCT LONGITUD
FROM AVIONES A
LEFT JOIN VUELOS V ON TIPO=TIPO_AVION
WHERE DISTANCIA > (SELECT AVG(V2.DISTANCIA) FROM VUELOS V2 WHERE A.TIPO LIKE V2.TIPO_AVION);

/* 8. Cree una vista sobre la tabla aviones con las columnas 
tipo y velocidad de crucero para los aviones con capacidad menor 
que 175 ¿Cuáles son la mayor y menor velocidad de crucero de 
la vista? Borre la vista */

CREATE OR REPLACE VIEW TIPO_VELOID AS
    SELECT TIPO,VELOCIDAD_CRUCERO
    FROM AVIONES A
    WHERE CAPACIDAD < 175;

SELECT * FROM TIPO_VELOID;

DROP VIEW TIPO_VELOID;

/* 9. Visualizar los números de vuelo, las tres primeras letras 
del origen y las tres primeras letras del destino para los vuelos 
realizados por aviones con posibilidad de almacenar más combustible 
que la media de todos y con longitud menor que 2/3 de la máxima 
longitud. Ordenarlos por número de vuelo */

SELECT NUM_VUELO,SUBSTR(ORIGEN,1,3) AS ORIGEN,SUBSTR(DESTINO,1,3) AS DESTINO
FROM VUELOS V
LEFT JOIN AVIONES A ON TIPO=TIPO_AVION
WHERE COMBUSTIBLE > (SELECT AVG(A2.COMBUSTIBLE) FROM AVIONES A2) AND
      LONGITUD < (SELECT MAX(A2.LONGITUD) FROM AVIONES A2)*2/3
ORDER BY NUM_VUELO;
      
/* 10. Obtenga la capacidad de los aviones que realizan vuelos 
que recorren distancias menores que la media de las distancias 
de los vuelos recorridos por la misma compañía. */

SELECT DISTINCT CAPACIDAD
FROM AVIONES A 
LEFT JOIN VUELOS V ON TIPO=TIPO_AVION
WHERE DISTANCIA < (SELECT AVG(V2.DISTANCIA) FROM VUELOS V2 WHERE SUBSTR(V.NUM_VUELO,1,2) LIKE SUBSTR(V2.NUM_VUELO,1,2));
