/* ===== COLECCION FUNCIONES Y PROCEDIMIENTOS II ===== */

/* Ejercicio 2: Escribir un procedimiento que reciba dos 
números y visualice su suma. */

CREATE OR REPLACE PROCEDURE P_SUMAR(
NUM1 NUMBER,
NUM2 NUMBER
)
AS
    RESUL NUMBER;
BEGIN
    RESUL := NUM1+NUM2;
    DBMS_OUTPUT.PUT_LINE(NUM1 || ' + ' || NUM2 || ' = ' || RESUL);
END;
/

CREATE OR REPLACE FUNCTION F_SUMAR(
NUM1 NUMBER,
NUM2 NUMBER
) RETURN NUMBER
AS
BEGIN
    RETURN NUM1+NUM2;
END;
/

BEGIN
    P_SUMAR(3,4);
END;
/

/* Ejercicio 4: Escribir una funcion que reciba una fecha 
y devuelva el año, en número, correspondiente a esa fecha. */

CREATE OR REPLACE FUNCTION AÑO_DE(
FECHA DATE
) RETURN CHAR
AS
BEGIN
    RETURN TO_CHAR(FECHA,'YYYY');
END;
/

/* Ejercicio 5: Escribir un bloque PL/SQL que haga uso de 
la función anterior. */

BEGIN
    DBMS_OUTPUT.PUT_LINE('AÑO: ' || AÑO_DE('18/02/98'));
END;
/

/* Ejercicio 7: Desarrollar una función que devuelva el
número de años completos que hay entre dos fechas que 
se pasan como argumentos. */

CREATE OR REPLACE FUNCTION AÑOS_ENTRE(
FECHA1 DATE,
FECHA2 DATE
) RETURN NUMBER
AS
    AÑOS_COMPLETOS NUMBER;
BEGIN
    AÑOS_COMPLETOS := FLOOR(MONTHS_BETWEEN(FECHA2,FECHA1)/12);
    
    RETURN AÑOS_COMPLETOS;
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(AÑOS_ENTRE('01/01/2000','31/12/2002') || ' AÑOS');
END;
/

/* Ejercicio 8: Escribir una función que, haciendo uso 
de la función anterior devuelva los trienios que hay 
entre dos fechas. (Un trienio son tres años completos). */

CREATE OR REPLACE FUNCTION TREINTENOS_ENTRE(
FECHA1 DATE,
FECHA2 DATE
) RETURN NUMBER
AS
BEGIN
    RETURN FLOOR(AÑOS_ENTRE(FECHA1,FECHA2)/30);
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(TREINTENOS_ENTRE('01/01/2000','31/12/2032') || ' TREINTENOS');
END;
/

/* Ejercicio 9: Añadir la columna total2 y en ella 
escribir la suma del salario y la comisión de los
empleados con comisión distinta a 0 */

ALTER TABLE EMP2 ADD TOTAL2 NUMBER;

BEGIN
    UPDATE EMP2
    SET TOTAL2 = F_SUMAR(SAL,COMM)
    WHERE COMM<>0;
END;
/

COMMIT;

/* Ejercicio 10: Escribir una función que devuelva solamente
caracteres alfabéticos sustituyendo cualquier otro carácter 
por blancos a partir de una cadena que se pasará en la llamada. */

CREATE OR REPLACE FUNCTION CARACTERES(
CADENA VARCHAR2
) RETURN VARCHAR2
AS
    NUEVA_CADENA VARCHAR2(30);
    CARACTER CHAR;
BEGIN
    NUEVA_CADENA := UPPER(CADENA);
    
    FOR I IN 1 .. LENGTH(CADENA) LOOP
        CARACTER := SUBSTR(NUEVA_CADENA,I,1);
        IF CARACTER NOT IN ('A','B','C','D','E','F','G','H','I','J',
                            'K','L','M','N','Ñ','O','P','Q','R','S',
                            'T','U','V','W','X','Y','Z') THEN
            NUEVA_CADENA := REPLACE(NUEVA_CADENA,CARACTER,' ');
        END IF;
    END LOOP;
    
    RETURN NUEVA_CADENA;
END;
/

DECLARE
    CADENA VARCHAR2(30);
    NUEVA_CADENA VARCHAR2(30);
BEGIN
    CADENA := '&CADENA';
    
    NUEVA_CADENA := CARACTERES(CADENA);
    
    DBMS_OUTPUT.PUT_LINE(CADENA || ' --> ' || NUEVA_CADENA);
END;
/

/* Ejercicio 11: Realizar un procedimiento que incremente 
el salario de los empleados que tengan una comisión superior
al 5% del salario, en un x%.
El valor de x lo debe especificar el usuario. */

CREATE OR REPLACE PROCEDURE INCREMENTAR_SALARIO(
PORCENTAJE NUMBER
) AS
BEGIN
    UPDATE EMP2
    SET SAL = SAL+SAL*PORCENTAJE/100
    WHERE COMM > SAL*0.05;
END;
/

BEGIN
    INCREMENTAR_SALARIO(10);
END;
/

/* Ejercicio 12: Insertar un empleado en la tabla EMP. Su número
será superior a los existentes y la fecha de incorporaron en 
la empresa será la actual. */

INSERT INTO EMP2 VALUES (8013,'NUEVO','BARRENDERO',7369,SYSDATE,5000,NULL,30,NULL);

/* Ejercicio 13: Codificar un procedimiento que permita borrar
un empleado cuyo número se pasará en la llamada. */

CREATE OR REPLACE PROCEDURE BORRAR_EMPLEADO(
NUM_EMP EMP2.EMPNO%TYPE
) AS
BEGIN
    DELETE FROM EMP2 WHERE EMPNO = NUM_EMP;
END;
/

BEGIN
    BORRAR_EMPLEADO(8013);
END;
/

/* Ejercicio 14: Escribir un procedimiento que modifique la 
localidad de un departamento. El procedimiento recibirá como 
parámetros el número del departamento y la localidad nueva. */

CREATE OR REPLACE PROCEDURE MOD_LOCALIDAD(
NUM_DEPT DEPT2.DEPTNO%TYPE,
NUEVA_LOC DEPT2.LOC%TYPE
) AS
BEGIN
    UPDATE DEPT2
    SET LOC = NUEVA_LOC
    WHERE DEPTNO = NUM_DEPT;
END;
/

BEGIN
    MOD_LOCALIDAD(50,'MADRID');
END;
/

/* Ejercicio 15: Visualizar todos los procedimientos y funciones 
del usuario almacenados en la base de datos y su situación 
(valid o invalid). */

SELECT OBJECT_NAME, OBJECT_TYPE, STATUS 
FROM USER_OBJECTS 
WHERE OBJECT_TYPE IN ('PROCEDURE', 'FUNCTION');


