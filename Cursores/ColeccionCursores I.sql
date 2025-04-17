/* CURSORES I */

/* Ejercicio 1: Desarrollar un procedimiento que visualice el apellido
y la fecha de alta de todos los empleados ordenados por apellido. */

CREATE OR REPLACE PROCEDURE APE_FECHA_EMP AS
    CURSOR CUR_EMP IS
        SELECT ENAME, HIREDATE
        FROM EMP
        ORDER BY ENAME;
    V_EMP CUR_EMP%ROWTYPE;
BEGIN
    OPEN CUR_EMP;
    FETCH CUR_EMP INTO V_EMP;
    WHILE (CUR_EMP%FOUND) LOOP
        DBMS_OUTPUT.PUT_LINE(V_EMP.ENAME || ' - ' || V_EMP.HIREDATE);
        FETCH CUR_EMP INTO V_EMP;
    END LOOP;
    CLOSE CUR_EMP;
END;
/

BEGIN
    APE_FECHA_EMP;
END;
/

/* Ejercicio 2: Codificar un procedimiento que muestre el nombre de
cada departamento y el número de empleados que tiene. */

CREATE OR REPLACE PROCEDURE DEPT_EMPS AS
    CURSOR CUR_DEPT_EMP IS
        SELECT DNAME, COUNT(EMPNO) AS EMPNO
        FROM EMP E
        LEFT JOIN DEPT D ON E.DEPTNO=D.DEPTNO
        GROUP BY DNAME;
    V_DEPT_EMP CUR_DEPT_EMP%ROWTYPE;
BEGIN
    OPEN CUR_DEPT_EMP;
    FETCH CUR_DEPT_EMP INTO V_DEPT_EMP;
    WHILE (CUR_DEPT_EMP%FOUND) LOOP
        DBMS_OUTPUT.PUT_LINE('EN '||V_DEPT_EMP.DNAME||' HAY: '||V_DEPT_EMP.EMPNO||' EMPLEADOS');
        FETCH CUR_DEPT_EMP INTO V_DEPT_EMP;
    END LOOP;
    CLOSE CUR_DEPT_EMP;
END;
/

BEGIN
    DEPT_EMPS;
END;
/

/* Ejercicio 3: Escribir un procedimiento que reciba una cadena y
visualice el apellido y el número de empleado de todos los empleados
cuyo apellido contenga la cadena especificada. Al finalizar visualizar
el número de empleados mostrados. */

CREATE OR REPLACE PROCEDURE CADENA_EMP (
CADENA VARCHAR2
) IS
    CURSOR CUR_EMPLES IS
        SELECT ENAME, EMPNO
        FROM EMP
        WHERE ENAME LIKE '%'||UPPER(CADENA)||'%';
    V_EMPLES CUR_EMPLES%ROWTYPE;
    
    CONT NUMBER DEFAULT 0;
BEGIN
    OPEN CUR_EMPLES;
    FETCH CUR_EMPLES INTO V_EMPLES;
    WHILE (CUR_EMPLES%FOUND) LOOP
        CONT := CONT + 1;
        DBMS_OUTPUT.PUT_LINE('APE: '||V_EMPLES.ENAME||' NUM: '||V_EMPLES.EMPNO);
        FETCH CUR_EMPLES INTO V_EMPLES;
    END LOOP;
    CLOSE CUR_EMPLES;
    DBMS_OUTPUT.PUT_LINE('CANTIDAD DE EMPLEADOS: '||CONT);
END;
/

BEGIN
    CADENA_EMP('LL');
END;
/

/* Ejercicio 4: Escribir un programa que visualice el apellido y
el salario de los cinco empleados que tienen el salario más alto. */

DECLARE
    CURSOR CUR_EMPLES IS
        SELECT ENAME, SAL
        FROM EMP
        ORDER BY SAL DESC;
    V_EMPLES CUR_EMPLES%ROWTYPE;
    
    CONT NUMBER DEFAULT 5;
BEGIN
    OPEN CUR_EMPLES;
    FETCH CUR_EMPLES INTO V_EMPLES;
    WHILE (CUR_EMPLES%FOUND AND CONT>0) LOOP
        DBMS_OUTPUT.PUT_LINE('APE: '||V_EMPLES.ENAME||' SAL: '||V_EMPLES.SAL);
        FETCH CUR_EMPLES INTO V_EMPLES;
        CONT := CONT -1;
    END LOOP;
    CLOSE CUR_EMPLES;
END;
/

/* Ejercicio 5: Codificar un programa que visualice los dos
empleados que ganan menos de cada oficio. */

DECLARE
    CURSOR CUR_EMPLE IS
        SELECT JOB, ENAME, SAL
        FROM EMP
        ORDER BY JOB, SAL ASC;
    V_EMPLE CUR_EMPLE%ROWTYPE;
    
    CONT NUMBER DEFAULT 2;
    JOB_ANTERIOR VARCHAR2(50) DEFAULT ' ';
BEGIN
    OPEN CUR_EMPLE;
    FETCH CUR_EMPLE INTO V_EMPLE;
    WHILE (CUR_EMPLE%FOUND) LOOP
        IF (CONT>0) THEN
            IF (JOB_ANTERIOR NOT LIKE V_EMPLE.JOB) THEN
                CONT := 2;
            END IF;
            DBMS_OUTPUT.PUT_LINE('JOB: '||V_EMPLE.JOB||' </\> NOM: '||V_EMPLE.ENAME||' </\> SAL: '||V_EMPLE.SAL);
            CONT := CONT -1;
            JOB_ANTERIOR := V_EMPLE.JOB;
            FETCH CUR_EMPLE INTO V_EMPLE;
        ELSE
            IF (JOB_ANTERIOR NOT LIKE V_EMPLE.JOB) THEN
                CONT := 2;
            ELSE
                JOB_ANTERIOR := V_EMPLE.JOB;
                FETCH CUR_EMPLE INTO V_EMPLE;
            END IF;
        END IF;
    END LOOP;
    CLOSE CUR_EMPLE;
END;
/

/* Ejercicio 6: Escribir un programa que muestre. El listado 
será utilizando rupturas de control.
	
•	Para cada empleado: apellido y salario.
•	Para cada departamento: Número de empleados y suma de los salarios
    del departamento.
•	Al final del listado: Número total de empleados y suma de todos 
    los salarios. */

DECLARE
    CURSOR CUR_EMP IS
        SELECT ENAME, SAL
        FROM EMP;
    V_EMP CUR_EMP%ROWTYPE;
    
    CURSOR CUR_DEPT IS
        SELECT DNAME, COUNT(EMPNO) AS CANT, SUM(SAL) AS SUMA
        FROM DEPT D
        LEFT JOIN EMP E ON D.DEPTNO=E.DEPTNO
        GROUP BY DNAME;
    V_DEPT CUR_DEPT%ROWTYPE;
    
    CANT NUMBER;
    SUMA NUMBER;
BEGIN
    SELECT COUNT(EMPNO), SUM(SAL)
    INTO CANT, SUMA
    FROM EMP;
    DBMS_OUTPUT.PUT_LINE('=== EMPLEADOS ===');
    OPEN CUR_EMP;
    FETCH CUR_EMP INTO V_EMP;
    WHILE (CUR_EMP%FOUND) LOOP
        DBMS_OUTPUT.PUT_LINE('APE: '||V_EMP.ENAME||' SAL: '||V_EMP.SAL);
        FETCH CUR_EMP INTO V_EMP;
    END LOOP;
    CLOSE CUR_EMP;
    DBMS_OUTPUT.PUT_LINE('=== DEPARTAMENTOS ===');
    OPEN CUR_DEPT;
    FETCH CUR_DEPT INTO V_DEPT;
    WHILE (CUR_DEPT%FOUND) LOOP
        DBMS_OUTPUT.PUT_LINE('NOM: '||V_DEPT.DNAME||' TOTAL EMPLEADOS: '||V_DEPT.CANT||' TOTAL SALARIOS: '||V_DEPT.SUMA);
        FETCH CUR_DEPT INTO V_DEPT;
    END LOOP;
    CLOSE CUR_DEPT;
    DBMS_OUTPUT.PUT_LINE('=== FINAL ===');
    DBMS_OUTPUT.PUT_LINE('CANTIDAD EMPLEADOS: '||CANT);
    DBMS_OUTPUT.PUT_LINE('SUMA TOTAL SALARIOS: '||SUMA);
END;
/

/* Ejercicio 7: Desarrollar un procedimiento que permita insertar 
nuevos departamentos según las siguientes especificaciones:
•	Se pasará al procedimiento el nombre del departamento y la localidad.
•	El procedimiento insertará la fila nueva asignando como número
    de departamento la decena siguiente al número mayor de la  tabla. 
•	Se incluirá gestión de posibles errores. */

CREATE OR REPLACE PROCEDURE INSERT_DEPT (
NOM_DEP DEPT.DNAME%TYPE DEFAULT '',
LOC_DEP DEPT.LOC%TYPE DEFAULT ''
) IS
    CURSOR CUR_DEPTNO IS
        SELECT DEPTNO
        FROM DEPT;
    V_DEPTNO CUR_DEPTNO%ROWTYPE;

    MAYOR_DEPTNO DEPT.DEPTNO%TYPE DEFAULT 0;
BEGIN
    -- LANZAMIENTO Y CONTROL DE EXCEPCIONES
    IF (NOM_DEP LIKE '' OR LOC_DEP LIKE '') THEN
        RAISE NO_DATA_FOUND;
    ELSE
        IF (NOM_DEP IS NULL OR LOC_DEP IS NULL) THEN
            RAISE NO_DATA_FOUND;
        END IF;
    END IF;
    
    -- COMIENZO SIN EXCEPCIONES
    OPEN CUR_DEPTNO;
    FETCH CUR_DEPTNO INTO V_DEPTNO;
    WHILE (CUR_DEPTNO%FOUND) LOOP
        IF (MAYOR_DEPTNO<V_DEPTNO.DEPTNO) THEN
            MAYOR_DEPTNO := V_DEPTNO.DEPTNO;
        END IF;
        FETCH CUR_DEPTNO INTO V_DEPTNO;
    END LOOP;
    CLOSE CUR_DEPTNO;
    
    MAYOR_DEPTNO := MAYOR_DEPTNO +10;
    
    INSERT INTO DEPT VALUES (MAYOR_DEPTNO,NOM_DEP,LOC_DEP);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('LOS PARÁMETROS HAN SIDO INTRODUCIDOS ERRÓNEAMENTE');
END;
/

BEGIN
    INSERT_DEPT('MADIRD');
END;
/

ROLLBACK;

/* Ejercicio 8: Escribir un procedimiento que reciba todos los datos
de un nuevo empleado procese la transacción de alta, gestionando posibles errores. */

/*
CREATE OR REPLACE PROCEDURE NUEVO_EMP(
NUM_EMP EMP.EMPNO%TYPE,
NOMBRE EMP.ENAME%TYPE,
TRABAJO EMP.JOB%TYPE,
JEFE EMP.MGR%TYPE,
FECHA EMP.HIREDATE%TYPE,
SALARIO EMP.SAL%TYPE,
COMISION EMP.COMM%TYPE,
NUM_DEPT EMP.DEPTNO%TYPE
) IS
    EXCEP_VAR_VACIA EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE(NUM_EMP);
EXCEPTION
    WHEN EXCEP_VAR_VACIA THEN
        DBMS_OUTPUT.PUT_LINE('UNO DE LOS PARAMETROS ESTÁ VACÍO');
END;
/

BEGIN
    NUEVO_EMP(8013,'NUEVO','BAR',7369,SYSDATE,5000,NULL,30,NULL);
END;
/
*/

/* Ejercicio 9: Codificar un procedimiento reciba como parámetros
un numero de departamento, un importe y un porcentaje; y suba el 
salario a todos los empleados del departamento indicado en la llamada. 
La subida será el porcentaje o el importe indicado en la llamada 
(el que sea más beneficioso para el empleado en cada caso). */

/* Ejercicio 10: Escribir un procedimiento que suba el sueldo de todos 
los empleados que ganen menos que el salario medio de su oficio. La subida
será de el 50% de la diferencia entre el salario del empleado y la media
de su oficio. Se deberá asegurar que la transacción no se quede a medias,
y se gestionarán los posibles errores. */

/* Ejercicio 11 *CONSULTAR ENUNCIADO* */

/* Ejercicio 12 *CONSULTAR ENUNCIADO* */

