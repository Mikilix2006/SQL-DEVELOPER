/* ===== BLOQUES ANÓNIMOS I ===== */

/* Ejercicio 1: Realizar nuestro primer bloque pl/sql , que los 
visualiza, dis, mes y año actual, El mes será con nombre. */

DECLARE
    V_DIA VARCHAR2(15);
    V_MES VARCHAR2(15);
    V_ANIO VARCHAR2(15);
BEGIN
    SELECT TO_CHAR(SYSDATE,'DD'),TO_CHAR(SYSDATE,'MONTH'),TO_CHAR(SYSDATE,'YYYY')
    INTO V_DIA, V_MES, V_ANIO
    FROM DUAL;
    
    DBMS_OUTPUT.PUT_LINE('DIA ' || V_DIA || ' DE ' || V_MES || 'DEL ' || V_ANIO);
END;
/

/* Ejercicio 2: Crear un bloque de PL/SQL que permite visualizar 
el salario de KING ,utilizando las tablas de empleados. */

DECLARE
    V_SAL EMP.SAL%TYPE;
BEGIN
    SELECT SAL
    INTO V_SAL
    FROM EMP
    WHERE ENAME LIKE 'KING';
    
    DBMS_OUTPUT.PUT_LINE('SALARIO DE KING: ' || V_SAL);
    
    EXCEPTION WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('NOMBRE DE EMPLEADO NO ENCONTRADO');
END;
/

/* Ejercicio 3: Crear un bloque de PL/SQL que permite visualizar 
el salario que dese eel usaurio utilizando las tablas de empleados. */

DECLARE
    V_SAL EMP.SAL%TYPE;
    V_EMPLEADO EMP.EMPNO%TYPE;
BEGIN
    V_EMPLEADO := '&EMPNO';
    
    SELECT SAL
    INTO V_SAL
    FROM EMP
    WHERE V_EMPLEADO = EMPNO;
     
    DBMS_OUTPUT.PUT_LINE('SALARIO DEL EMPLEADO ' || V_EMPLEADO || ': ' || V_SAL);
    
    EXCEPTION WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('EMPLEADO NO ENCONTRADO');
END;
/

/* Ejercicio 4: Realizar un bloque Pl/SQL que reciba una 
cadena y la escriba al revés */

DECLARE
    V_CADENA VARCHAR2(20);
    V_CAD_INV VARCHAR2(20) DEFAULT '';
BEGIN
    V_CADENA := '&CADENA';
    
    FOR I IN REVERSE 1 .. LENGTH(V_CADENA) LOOP
        V_CAD_INV := V_CAD_INV || SUBSTR(V_CADENA,I,1);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('CADENA: ' || V_CADENA);
    DBMS_OUTPUT.PUT_LINE('CADENA INVERTIDA: ' || V_CAD_INV);
END;
/

