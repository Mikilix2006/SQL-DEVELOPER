/* EJERCICIOS COLECCIONES I */

/* 1. Crear un registro con el nombre , oficio, 
salario y lugar donde trabaja cada empleado. Coger
en una colección, todos aquellos que ganen más de 1000 euros.
Visualizar los datos de la colección y si no tuviese datos, 
nos lo debe indicar. */

DECLARE
    TYPE INFO_EMPLEADO IS RECORD (
    NOMBRE EMP.ENAME%TYPE,
    OFICIO EMP.JOB%TYPE,
    SALARIO EMP.SAL%TYPE,
    LUGAR DEPT.LOC%TYPE
    );

    -- CREO ESTRUCTURA EN BASE AL REGISTRO
    TYPE TABLA_EMP IS TABLE OF INFO_EMPLEADO INDEX BY BINARY_INTEGER;
    
    -- CREO LA VARIABLE PARA ALMACENAR LOS DATOS
    LISTA_EMP TABLA_EMP;
    
    TOTAL NUMBER;
BEGIN
    SELECT ENAME,JOB,SAL,LOC
    BULK COLLECT INTO LISTA_EMP
    FROM EMP E
    LEFT JOIN DEPT D ON D.DEPTNO=E.DEPTNO
    WHERE SAL > 1000;
    
    SELECT COUNT(*)
    INTO TOTAL
    FROM EMP E
    LEFT JOIN DEPT D ON D.DEPTNO=E.DEPTNO
    WHERE SAL > 1000;
    
    IF TOTAL = 0 THEN
        FOR I IN LISTA_EMP.FIRST .. LISTA_EMP.LAST LOOP
            DBMS_OUTPUT.PUT_LINE('NOMBRE: ' || LISTA_EMP(I).NOMBRE);
            DBMS_OUTPUT.PUT_LINE('OFICIO: ' || LISTA_EMP(I).OFICIO);
            DBMS_OUTPUT.PUT_LINE('SALARIO: ' || LISTA_EMP(I).SALARIO);
            DBMS_OUTPUT.PUT_LINE('LOCALIDAD: ' || LISTA_EMP(I).LUGAR);
            DBMS_OUTPUT.PUT_LINE('================================');
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('NO HAY EMPLEADOS QUE CUMPLAN LA CONDICION');
    END IF;    
END;
/

/* 2. Crear una colección cuyo índice sea el numero de
empleado de la tabla emp y que guarde toda la información
de los empleados del departamento 20. A continuación 
visualizaremos la colección. */

DECLARE
    TYPE REG_EMP IS RECORD (
        NUM_EMP EMP.EMPNO%TYPE,
        NOMBRE EMP.ENAME%TYPE,
        TRABAJO EMP.JOB%TYPE,
        JEFE EMP.MGR%TYPE,
        FECHA EMP.HIREDATE%TYPE,
        SALARIO EMP.SAL%TYPE,
        COMISION EMP.COMM%TYPE,
        NUM_DEPT EMP.DEPTNO%TYPE
    );
    
    TYPE TABLA_EMP IS TABLE OF REG_EMP INDEX BY BINARY_INTEGER;
    
    LISTA_EMP TABLA_EMP;
BEGIN
    SELECT EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO
    BULK COLLECT INTO LISTA_EMP
    FROM EMP
    WHERE DEPTNO = 20;
    
    FOR I IN LISTA_EMP.FIRST .. LISTA_EMP.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('EMPNO: ' || LISTA_EMP(I).NUM_EMP);
        DBMS_OUTPUT.PUT_LINE('NOMBRE: ' || LISTA_EMP(I).NOMBRE);
        DBMS_OUTPUT.PUT_LINE('JOB: ' || LISTA_EMP(I).TRABAJO);
        DBMS_OUTPUT.PUT_LINE('MGR: ' || LISTA_EMP(I).JEFE);
        DBMS_OUTPUT.PUT_LINE('HIREDATE: ' || LISTA_EMP(I).FECHA);
        DBMS_OUTPUT.PUT_LINE('SALARIO: ' || LISTA_EMP(I).SALARIO);
        DBMS_OUTPUT.PUT_LINE('COMISION: ' || LISTA_EMP(I).COMISION);
        DBMS_OUTPUT.PUT_LINE('DEPTNO: ' || LISTA_EMP(I).NUM_DEPT);
        DBMS_OUTPUT.PUT_LINE('===================================');
    END LOOP;
END;
/







