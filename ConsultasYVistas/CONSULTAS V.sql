/* ===== CONSULTAS V ===== */

/* 1. Escribir una consulta que visualice el nombre y fecha
de alta de todos los empleados que trabajan en el mismo 
departamento que Blake. Excluir a Blake. */

SELECT ENAME, HIREDATE
FROM EMP
WHERE DEPTNO=30 AND ENAME<>'BLAKE';

/* 2. Cree una subconsulta que visualice el número y nombre 
de todos los empleados que ganan más que la media de salarios. 
Clasifique el resultado en orden descendiente de salarios. */

SELECT EMPNO, ENAME
FROM EMP
WHERE SAL>(SELECT AVG(SAL) FROM EMP);

/* 3. Escriba una consulta que visualice el número y nombre 
de todos los empleados que trabajan en un departamento con 
algún empleado cuyo nombre contenga una “T”. */

SELECT EMPNO, ENAME
FROM EMP E
WHERE E.ENAME IN (SELECT E2.ENAME FROM EMP E2 WHERE E.DEPTNO=E2.DEPTNO AND E2.ENAME LIKE '%T%');

/* 4. Visualice el nombre, número de departamento y puesto 
de trabajo de todos los empleados cuyo departamento se 
encuentre en Dallas. */

SELECT ENAME, E.DEPTNO, JOB
FROM EMP E
LEFT JOIN DEPT D ON E.DEPTNO=D.DEPTNO
WHERE LOC LIKE 'DALLAS';

/* 5. Visualice el nombre y salario de todos los empleados 
que dependan de King. */

SELECT ENAME, SAL
FROM EMP
WHERE MGR=7839;

/* 6. Visualice el número, nombre y puesto de trabajo de
todos los empleados del departamento “Sales” */

SELECT EMPNO, ENAME, JOB
FROM EMP E
LEFT JOIN DEPT D ON E.DEPTNO=D.DEPTNO
WHERE DNAME LIKE 'SALES';

/* 7. Visualice el número, nombre y salario de todos los 
empleados que ganen más que la media de  salarios y que 
trabajen en un departamento en el que algún empleado 
contenga una T en su nombre. */

SELECT EMPNO, ENAME, SAL
FROM EMP E
WHERE SAL>(SELECT AVG(SAL) FROM EMP) AND
      DEPTNO IN (SELECT DEPTNO FROM DEPT WHERE DNAME LIKE '%T%');

/* 8. Escriba una consulta para visualizar el nombre, 
número de departamento y salario de cualquier empleado, 
cuyo nº de departamento y salario se correspondan (ambos) 
con el nº de departamento y salario de cualquier empleado 
que tenga comisión. */

SELECT ENAME, DEPTNO, SAL
FROM EMP E
WHERE E.DEPTNO IN (SELECT E2.DEPTNO FROM EMP E2 -- MISMOS DEPARTAMENTOS
                   WHERE E2.COMM IS NOT NULL AND -- COMISION NO NULA
                         E2.COMM<>0 AND -- COMISION NO 0
                         E.SAL=E2.SAL AND -- SALARIOS IGUALES
                         E.EMPNO<>E2.EMPNO); -- PERSONAS DISTINTAS

/* 9. Visualice el nombre, número de departamento y salario 
de cualquier empleado cuyo salario y  comisión coincidan 
(los dos) con el salario y comisión de cualquier empleado 
de Dallas. */

SELECT ENAME, E.DEPTNO, SAL
FROM EMP E
LEFT JOIN DEPT D ON D.DEPTNO=E.DEPTNO
WHERE LOC LIKE 'DALLAS' AND -- LOCALIZADO EN DALLAS
E.SAL IN (SELECT E2.SAL FROM EMP E2 WHERE E.COMM=E2.COMM AND -- COMISIONES IGUALES
                                          E.EMPNO<>E2.EMPNO); -- DIFERENTES PERSONAS
                                          
-- CUANDO LAS COMISIONES SON NULAS, NO LAS COMPARA Y DA FALSE --

/* 10. Cree una consulta para visualizar el nombre, fecha 
de alta y salario de todos los empleados que tengan el mismo 
salario y comisión que Scott. */

SELECT ENAME,HIREDATE,SAL
FROM EMP E
WHERE SAL = (SELECT E2.SAL FROM EMP E2 WHERE E2.ENAME LIKE 'SCOTT' AND E.ENAME<>E2.ENAME) AND
      COMM = (SELECT E2.COMM FROM EMP E2 WHERE E2.ENAME LIKE 'SCOTT' AND E.ENAME<>E2.ENAME);
      
-- CUANDO LAS COMISIONES SON NULAS, NO LAS COMPARA Y DA FALSE --
      
/* 11. Cree una consulta para visualizar a los empleados 
que ganan un salario superior al salario de cualquier empleado 
con oficio CLERK. Ordene el resultado por salario descendentemente. */

SELECT ENAME
FROM EMP E
WHERE SAL > (SELECT MIN(E2.SAL) FROM EMP E2 WHERE E2.JOB LIKE 'CLERK')
ORDER BY SAL DESC;















