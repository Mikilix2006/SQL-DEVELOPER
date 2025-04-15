/* ===== COLECCION FUNCIONES Y PROCEDIMIENTOS I ===== */

/* Ejercicio 2: Realizar un procedimiento cambiar_oficio al que le 
pasamos el numero de empleado y el nuevo oficio, y actualizara dicho
dato en la base de datos. La ejecución de este procedimiento se debe
hacer de dos formas:
1. Desde la linea de comandos pasándole 2 valorescualesquier
2. Desde otro bloque que nos pide los datos porteclado. */

CREATE OR REPLACE PROCEDURE CAMBIAR_OFICIO (
NUM_EMP EMP.EMPNO%TYPE,
NUEVO_OFICIO EMP.JOB%TYPE
)
AS
BEGIN
    UPDATE EMP
    SET JOB = NUEVO_OFICIO
    WHERE EMPNO = NUM_EMP;
    
    -- TRATAMIENTO DE EXCEPCIONES
    IF SQL%ROWCOUNT=0 THEN
        RAISE_APPLICATION_ERROR(-20001,'EL NUM_EMP NO EXISTE O EL OFICIO ES DEMASIADO LARGO');
    ELSE
        DBMS_OUTPUT.PUT_LINE('PROCEDIMIENTO TERMINADO CORRECTAMENTE');
    END IF;
END;
/

-- APARTADO 1
BEGIN
    CAMBIAR_OFICIO(7839,'PRESIDENT');
END;
/


-- APARTADO 2
DECLARE
    V_NUM_EMP EMP.EMPNO%TYPE;
    V_OFICIO EMP.JOB%TYPE;
BEGIN
    V_NUM_EMP := '&EMPNO';
    V_OFICIO := '&OFICIO';
    
    CAMBIAR_OFICIO(V_NUM_EMP,V_OFICIO);
END;
/



