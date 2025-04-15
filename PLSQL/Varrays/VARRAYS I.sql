/* CCOLECCIONES VARRAY I */

/* 1. Ejercicio: Realizar una función ver_departamento, que 
recibe el numero de empleado y nos devuelve su nombre y su 
nombre de departamento.Hacer un bloque anónimo que utilice 
esta función y visualice sus datos */

CREATE OR REPLACE FUNCTION VER_DEPARTAMENTO (
NUM_EMP EMP.EMPNO%TYPE
) RETURN VARCHAR2
AS
    NOM_EMP EMP.ENAME%TYPE;
    NOM_DEPT DEPT.DNAME%TYPE;
BEGIN
    SELECT ENAME,DNAME
    INTO NOM_EMP,NOM_DEPT
    FROM EMP E
    LEFT JOIN DEPT D ON E.DEPTNO=D.DEPTNO
    WHERE EMPNO = NUM_EMP;
    
    RETURN 'NOMBRE: ' || NOM_EMP || ', DEPARTAMENTO: ' || NOM_DEPT;
END;
/

BEGIN   
    DBMS_OUTPUT.PUT_LINE(VER_DEPARTAMENTO(7839));
END; 
/

/* 2. Utilizar una colección para incluir datos de departamento
nuevos. Incluiremos tantos departamentos como desee el 
usuario. Después recorremos  la colección e insertamos los
datos en la tabla DEPT. */

DECLARE
    -- CANTIDAD REQUERIDA DE DEPTS
    CANT_DEPT NUMBER;
    -- CREACION DE VARRAY
    TYPE REG_DEPT IS RECORD (
        DEPTNO DEPT.DEPTNO%TYPE,
        DNAME DEPT.DNAME%TYPE,
        LOC DEPT.LOC%TYPE
    );
    TYPE TABLA_DEPT IS VARRAY(CANT_DEPT) OF REG_DEPT;
    VARRAY_DEPT TABLA_DEPT := TABLA_DEPT();
    -- DATOS USUARIO
    NUM_DEPT DEPT.DEPTNO%TYPE DEFAULT NULL;
    NOM_DEPT DEPT.DNAME%TYPE DEFAULT NULL;
    LUGAR DEPT.LOC%TYPE DEFAULT NULL;
BEGIN
    CANT_DEPT := &CANT_DEPTs;
    IF CANT_DEPT > 0 THEN
        FOR I IN 1 .. CANT_DEPT LOOP
            NUM_DEPT := '&NUM_DEPT';
            NOM_DEPT := '&NOM_DEPT';
            LUGAR := '&LUGAR';
            DBMS_OUTPUT.PUT_LINE('DEPTNO: ' || NUM_DEPT);
            DBMS_OUTPUT.PUT_LINE('DNAME: ' || NOM_DEPT);
            DBMS_OUTPUT.PUT_LINE('LOC: ' || LUGAR);
            VARRAY_DEPT(I).DEPTNO := NUM_DEPT;
            VARRAY_DEPT(I).DNAME := NOM_DEPT;
            VARRAY_DEPT(I).LOC := LUGAR;
            DBMS_OUTPUT.PUT_LINE('DATOS INSERTADOS EN VARRAY');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('== INSERCION DE DEPARTAMENTOS ==');
        FOR I IN 1 .. CANT_DEPT LOOP
            INSERT INTO DEPT2 VALUES(VARRAY_DEPT(I).DEPTNO,VARRAY_DEPT(I).DNAME,VARRAY_DEPT(I).LOC);
            DBMS_OUTPUT.PUT_LINE('DEPARTAMENTO INSERTADO');
        END LOOP;
        ELSE
            DBMS_OUTPUT.PUT_LINE('0 DEPARTAMENTOS INSERTADOS');
    END IF;
END; 
/

DECLARE
    -- CREACION DE VARRAY
    TYPE REG_DEPT IS RECORD (
        DEPTNO DEPT.DEPTNO%TYPE,
        DNAME DEPT.DNAME%TYPE,
        LOC DEPT.LOC%TYPE
    );
    VARRAY_DEPT TABLA_DEPT := TABLA_DEPT();
BEGIN
    FOR I IN VARRAY_DEPT.FIRST .. VARRAY_DEPT.LAST LOOP
        VARRAY_DEPT.EXTEND
        DBMS_OUTPUT.PUT_LINE('DATOS: ' || VARRAY_DEPT(I).DEPTNO || VARRAY_DEPT(I).DNAME || VARRAY_DEPT(I).LOC);
    END LOOP;
END; 
/









