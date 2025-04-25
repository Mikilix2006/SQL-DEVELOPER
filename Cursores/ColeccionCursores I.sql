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

CREATE OR REPLACE PROCEDURE NUEVO_EMP(
NUM_EMP EMP2.EMPNO%TYPE,
NOMBRE EMP2.ENAME%TYPE,
TRABAJO EMP2.JOB%TYPE,
JEFE EMP2.MGR%TYPE,
FECHA EMP2.HIREDATE%TYPE,
SALARIO EMP2.SAL%TYPE,
COMISION EMP2.COMM%TYPE,
NUM_DEPT EMP2.DEPTNO%TYPE
) IS
    -- VARIABLES QUE FUNCIONAN COMO TRIGGERS
    HAY_JEFE BOOLEAN DEFAULT FALSE;
    HAY_DEPTNO BOOLEAN DEFAULT FALSE;
    -- CREACION DE EXCEPCIONES
    EXCEP_VAR_VACIA EXCEPTION;
    EXCEP_NUM_INVALIDO EXCEPTION;
    EXCEP_FECHA_INVALIDA EXCEPTION;
    /* CREACION DE LISTAS */
    -- LISTA PARA EMPNOS
    TYPE EMPNOS IS RECORD (
        EMPNO EMP.EMPNO%TYPE
    );
    TYPE TABLA_EMPNOS IS TABLE OF EMPNOS INDEX BY BINARY_INTEGER;
    LISTA_EMPNOS TABLA_EMPNOS;
    -- LISTA PARA DEPTNOS
    TYPE DEPTNOS IS RECORD (
        DEPTNO EMP.DEPTNO%TYPE
    );
    TYPE TABLA_DEPTNOS IS TABLE OF DEPTNOS INDEX BY BINARY_INTEGER;
    LISTA_DEPTNOS TABLA_DEPTNOS;
BEGIN
    -- VOLCADO DE DATOS EN LISTAS
    SELECT EMPNO
    BULK COLLECT INTO LISTA_EMPNOS
    FROM EMP2;
    
    SELECT DEPTNO
    BULK COLLECT INTO LISTA_DEPTNOS
    FROM EMP2;

    /* CONTROL DE EXCEPCIONES */
    -- TRATAR ENAME Y JOB
    IF LENGTH(NOMBRE)=0 OR LENGTH(TRABAJO)=0 THEN
        RAISE EXCEP_VAR_VACIA;
    END IF;
    -- TRATAR EMPNO
    IF NUM_EMP IS NULL THEN
        RAISE EXCEP_NUM_INVALIDO;
    ELSE
        FOR I IN LISTA_EMPNOS.FIRST .. LISTA_EMPNOS.LAST LOOP
            IF NUM_EMP = LISTA_EMPNOS(I).EMPNO OR NUM_EMP < 0 THEN
                RAISE EXCEP_NUM_INVALIDO;
            END IF;
        END LOOP;
    END IF;
    -- TRATAR MGR
    IF JEFE IS NOT NULL THEN
        FOR I IN LISTA_EMPNOS.FIRST .. LISTA_EMPNOS.LAST LOOP
            IF JEFE = LISTA_EMPNOS(I).EMPNO THEN
                HAY_JEFE := TRUE;
            END IF;
        END LOOP;
        IF NOT HAY_JEFE THEN
            RAISE EXCEP_NUM_INVALIDO;
        END IF;
    END IF;
    -- TRATAR SAL
    IF SALARIO IS NOT NULL THEN
        IF SALARIO < 0 THEN
            RAISE EXCEP_NUM_INVALIDO;
        END IF;
    END IF;
    -- TRATAR COMM
    IF COMISION IS NOT NULL THEN
        IF COMISION < 0 THEN
            RAISE EXCEP_NUM_INVALIDO;
        END IF;
    END IF;
    -- TRATAR DEPTNO
    IF NUM_DEPT IS NOT NULL THEN
        FOR I IN LISTA_DEPTNOS.FIRST .. LISTA_DEPTNOS.LAST LOOP
            IF NUM_DEPT = LISTA_DEPTNOS(I).DEPTNO THEN
                HAY_DEPTNO := TRUE;
            END IF;
        END LOOP;
        IF NOT HAY_DEPTNO THEN
            RAISE EXCEP_NUM_INVALIDO;
        END IF;
    END IF;
    -- TRATAR HIREDATE
    IF FECHA IS NOT NULL THEN
        IF FECHA > SYSDATE THEN
            RAISE EXCEP_FECHA_INVALIDA;
        END IF;
    END IF;
    
    -- TODO CORRECTO SIN ERRORES
    -- INSETRAR LOS DATOS
    INSERT INTO EMP2 VALUES (NUM_EMP,NOMBRE,TRABAJO,JEFE,FECHA,SALARIO,COMISION,NUM_DEPT,SALARIO+COMISION);
    DBMS_OUTPUT.PUT_LINE('TODO CORRECTO');
EXCEPTION
    WHEN EXCEP_VAR_VACIA THEN
        DBMS_OUTPUT.PUT_LINE('UNO DE LOS PARAMETROS ESTÁ VACÍO');
    WHEN EXCEP_NUM_INVALIDO THEN
        DBMS_OUTPUT.PUT_LINE('UNO DE LOS NÚMEROS ES INVÁLIDO');
    WHEN EXCEP_FECHA_INVALIDA THEN
        DBMS_OUTPUT.PUT_LINE('LA FECHA NO ES CORRECTA');
END;
/

BEGIN
    NUEVO_EMP(8013,'NUEVO','BAR',7369,'01/01/2020',2500,300,30);
END;
/

ROLLBACK;


/* Ejercicio 9: Codificar un procedimiento reciba como parámetros
un numero de departamento, un importe y un porcentaje; y suba el 
salario a todos los empleados del departamento indicado en la llamada. 
La subida será el porcentaje o el importe indicado en la llamada 
(el que sea más beneficioso para el empleado en cada caso). */

CREATE OR REPLACE PROCEDURE SUBIR_SAL(
NUM_DEPT EMP2.DEPTNO%TYPE,
IMPORTE NUMBER,
PORCENTAJE NUMBER
) IS
    CURSOR CUR_SALARIOS IS
        SELECT E.EMPNO AS EMPNO, E.SAL AS SAL
        FROM EMP2 E
        WHERE E.DEPTNO = NUM_DEPT;
    V_SALARIOS CUR_SALARIOS%ROWTYPE;
    
    SAL_PORCENT NUMBER DEFAULT 0;
    SAL_IMPORTE NUMBER DEFAULT 0;
    NUEVO_SAL NUMBER DEFAULT 0;
BEGIN
    OPEN CUR_SALARIOS;
    FETCH CUR_SALARIOS INTO V_SALARIOS;
    WHILE (CUR_SALARIOS%FOUND) LOOP
        SAL_PORCENT := ROUND(V_SALARIOS.SAL+V_SALARIOS.SAL*PORCENTAJE/100,4);
        SAL_IMPORTE := V_SALARIOS.SAL+IMPORTE;
        DBMS_OUTPUT.PUT_LINE('EMPNO:' || V_SALARIOS.EMPNO);
        DBMS_OUTPUT.PUT_LINE('ORIGINAL:' || V_SALARIOS.SAL);
        DBMS_OUTPUT.PUT_LINE('SAL CON PORCENTAJE:' || SAL_PORCENT);
        DBMS_OUTPUT.PUT_LINE('SAL CON IMPORTE:' || SAL_IMPORTE);
        DBMS_OUTPUT.PUT_LINE('==================================');
        IF SAL_PORCENT >= SAL_IMPORTE THEN
            NUEVO_SAL := SAL_PORCENT;
        ELSE
            NUEVO_SAL := SAL_IMPORTE;
        END IF;
        
        UPDATE EMP2
        SET SAL = NUEVO_SAL
        WHERE EMPNO = V_SALARIOS.EMPNO;
        
        FETCH CUR_SALARIOS INTO V_SALARIOS;
    END LOOP;
    CLOSE CUR_SALARIOS;
END;
/

BEGIN
    SUBIR_SAL(20,300,20);
END;
/

ROLLBACK;

/* Ejercicio 10: Escribir un procedimiento que suba el sueldo de todos 
los empleados que ganen menos que el salario medio de su oficio. La subida
será de el 50% de la diferencia entre el salario del empleado y la media
de su oficio. Se deberá asegurar que la transacción no se quede a medias,
y se gestionarán los posibles errores. */

CREATE OR REPLACE PROCEDURE SUBIR_SUELDO 
IS
    CURSOR CUR_EMP IS
        SELECT EMPNO, SAL, JOB
        FROM EMP2
        ORDER BY JOB;
    V_EMP CUR_EMP%ROWTYPE;
    
    CURSOR CUR_SAL_JOB IS
        SELECT JOB, ROUND(AVG(SAL)) AS SAL
        FROM EMP2
        GROUP BY JOB
        ORDER BY JOB;
    V_SAL_JOB CUR_SAL_JOB%ROWTYPE;
    
    SUBIDA_SAL NUMBER DEFAULT 0;
BEGIN    
    OPEN CUR_EMP;
    OPEN CUR_SAL_JOB;
    
    FETCH CUR_EMP INTO V_EMP;
    FETCH CUR_SAL_JOB INTO V_SAL_JOB;
    
    WHILE CUR_EMP%FOUND AND CUR_SAL_JOB%FOUND LOOP
        IF V_EMP.JOB NOT LIKE V_SAL_JOB.JOB THEN
            FETCH CUR_SAL_JOB INTO V_SAL_JOB;
        END IF;
        
        IF V_EMP.SAL < V_SAL_JOB.SAL THEN
            SUBIDA_SAL := (V_SAL_JOB.SAL - V_EMP.SAL) * 0.5;
            DBMS_OUTPUT.PUT_LINE('EMPLEADO: '||V_EMP.EMPNO||'OBTIENE SUBIDA DE SALARIO, ENHORABUENA!');
            DBMS_OUTPUT.PUT_LINE('SAL MEDIO DE SU OFICIO: '||V_SAL_JOB.SAL);
            DBMS_OUTPUT.PUT_LINE('ANTIGUO SALARIO: '||V_EMP.SAL);
            DBMS_OUTPUT.PUT_LINE('NUEVO SALARIO: '||(V_EMP.SAL+SUBIDA_SAL));
            DBMS_OUTPUT.PUT_LINE('==================================');
        END IF;
        
        UPDATE EMP2
        SET SAL = SAL + SUBIDA_SAL
        WHERE EMPNO = V_EMP.EMPNO;
        
        FETCH CUR_EMP INTO V_EMP;
    END LOOP;
    
    CLOSE CUR_SAL_JOB;
    CLOSE CUR_EMP;
END;
/

BEGIN
    SUBIR_SUELDO();
END;
/

ROLLBACK;

/* Ejercicio 11: Diseñar una aplicación que simule un listado de liquidación de los empleados según las siguientes especificaciones:
•	El listado tendrá el siguiente formato para cada empleado:
**********************************************************************
Liquidación del empleado:.........(1)	Dpto.:.............(2)	Oficio:................(3)

Salario			:.............(4)
Trienios		:.............(5)
Comp. responsabilidad:.............(6)
Comisión		:.............(7)
			---------------
Total			:..............(8)
**********************************************************************
•	Donde:
?	1 ,2, 3 y 4 corresponden al apellido, departamento, oficio y salario del empleado.
?	5 es el importe en concepto de trienios. Cada trienio son tres años completos desde la fecha de alta hasta la de emisión y supone 500 €. 
?	6 es el complemento por responsabilidad. Será de 1000€ por cada empleado que se encuentre directamente a cargo del empleado en cuestión.
?	7 es la comisión. Los valores nulos serán sustituidos por ceros.
?	8 suma de todos los conceptos anteriores.
•	El listado irá ordenado por ename. */

DECLARE
    CURSOR CUR_EMP IS
        SELECT EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DNAME
        FROM EMP E
        LEFT JOIN DEPT D ON D.DEPTNO=E.DEPTNO
        ORDER BY ENAME;
    V_EMP CUR_EMP%ROWTYPE;
    
    COMP_RESP NUMBER DEFAULT 0;
    TOT_COMP_RESP NUMBER DEFAULT 0;
    TRIENIOS NUMBER DEFAULT 0;
    TOT_TRIEN NUMBER DEFAULT 0;
    TOTAL NUMBER DEFAULT 0;
BEGIN
    OPEN CUR_EMP;
    FETCH CUR_EMP INTO V_EMP;
    WHILE CUR_EMP%FOUND LOOP
        TRIENIOS := TRUNC((MONTHS_BETWEEN(SYSDATE,V_EMP.HIREDATE)/12)/3);
        TOT_TRIEN := TRIENIOS*500;
        SELECT COUNT(EMPNO)
        INTO COMP_RESP
        FROM EMP
        WHERE MGR = V_EMP.EMPNO;
        TOT_COMP_RESP := COMP_RESP*1000;
        TOTAL := V_EMP.SAL+TOT_TRIEN+TOT_COMP_RESP+NVL(V_EMP.COMM,0);
        DBMS_OUTPUT.PUT_LINE('Liquidación del empleado:'||V_EMP.ENAME||' Dpto.:'||V_EMP.DNAME||' Oficio:'||V_EMP.JOB);
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE(RPAD('Salario',15,'.')||': '||V_EMP.SAL||'€');
        DBMS_OUTPUT.PUT_LINE(RPAD('Trienios',15,'.')||': '||TRIENIOS||' ('||TOT_TRIEN||'€)');
        DBMS_OUTPUT.PUT_LINE(RPAD('Comp. responsabilidad',15,'.')||': '||COMP_RESP||' ('||TOT_COMP_RESP||'€)');
        DBMS_OUTPUT.PUT_LINE(RPAD('Comisión',15,'.')||': '||NVL(V_EMP.COMM,0)||'€');
        DBMS_OUTPUT.PUT_LINE(RPAD('              ',30,'-'));
        DBMS_OUTPUT.PUT_LINE(RPAD('Total',15,'.')||': '||TOTAL||'€');
        DBMS_OUTPUT.PUT_LINE(RPAD('*',50,'*'));
        FETCH CUR_EMP INTO V_EMP;
    END LOOP;
    CLOSE CUR_EMP;
END;
/

/* Ejercicio 12: Crear la tabla T_liquidacion con las columnas apellido, 
departamento, oficio, salario, trienios, comp_responsabilidad, comisión y 
total; y modificar la aplicación anterior para que en lugar de realizar el 
listado directamente en pantalla, guarde los datos en la tabla. Se controlarán 
todas las posibles incidencias que puedan ocurrir durante el proceso. */

CREATE TABLE T_LIQUIDACION (
EMPNO NUMBER(4) PRIMARY KEY,
APELL VARCHAR2(20),
DEPTNO NUMBER(4),
OFICIO VARCHAR2(20),
SALARIO NUMBER,
TRIENIOS NUMBER,
COMP_RESPONSABILIDAD NUMBER,
COMISION NUMBER,
TOTAL NUMBER
);

DROP TABLE T_LIQUIDACION;

DECLARE
   CURSOR CUR_EMP IS
        SELECT EMPNO,ENAME,D.DEPTNO,JOB,SAL,COMM,HIREDATE,MGR
        FROM EMP E
        LEFT JOIN DEPT D ON E.DEPTNO=D.DEPTNO;
    V_EMP CUR_EMP%ROWTYPE;
    
    TRIENIOS NUMBER;
    COMP_RESP NUMBER;
    TOTAL NUMBER;
BEGIN
    OPEN CUR_EMP;
    FETCH CUR_EMP INTO V_EMP;
    WHILE CUR_EMP%FOUND LOOP
        TRIENIOS := TRUNC(((MONTHS_BETWEEN(SYSDATE,V_EMP.HIREDATE)/12)/3)*500);
        SELECT COUNT(EMPNO)*1000
        INTO COMP_RESP
        FROM EMP
        WHERE MGR = V_EMP.EMPNO;
        TOTAL := V_EMP.SAL+TRIENIOS+COMP_RESP+NVL(V_EMP.COMM,0);
        INSERT INTO T_LIQUIDACION VALUES(V_EMP.EMPNO,V_EMP.ENAME,V_EMP.DEPTNO,V_EMP.JOB,V_EMP.SAL,TRIENIOS,COMP_RESP,V_EMP.COMM,TOTAL);
        FETCH CUR_EMP INTO V_EMP;
    END LOOP;
    CLOSE CUR_EMP;
END;
/
















