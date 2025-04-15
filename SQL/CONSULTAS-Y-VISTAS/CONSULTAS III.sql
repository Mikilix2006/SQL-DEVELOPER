/* ===== CONSULTAS III ===== */

/* 1. Escribir una consulta para visualizar el nombre, número de 
departamento y nombre de departamento de todos los empleados. */

SELECT ENAME, E.DEPTNO, DNAME
FROM EMP E
JOIN DEPT D ON(E.DEPTNO=D.DEPTNO);

/* 2. Crear un listado único de todos los puestos de trabajo (JOB)
que hay en el departamento 30. Incluya la localidad del departamento
30 en el resultado. */

SELECT DISTINCT JOB, LOC
FROM EMP E
JOIN DEPT D ON (E.DEPTNO=D.DEPTNO);

/* 3. Escribir una consulta para visualizar el nombre del empleado, nombre 
del departamento y localidad de todos los empleados que ganan comisión. */

SELECT ENAME, DNAME, LOC
FROM EMP E
JOIN DEPT D ON (D.DEPTNO=E.DEPTNO)
WHERE COMM IS NOT NULL;

/* 4. Visualizar el nombre del empleado y nombre del departamento de 
todos los empleados que tienen una A en su nombre. */

SELECT ENAME, DEPTNO FROM EMP WHERE ENAME LIKE '%A%';

/* 5. Escribir una consulta para visualizar el nombre, puesto de trabajo, 
número del departamento y nombre del departamento de todos los empleados que 
trabajan en DALLAS. */

SELECT ENAME, JOB, E.DEPTNO, DNAME
FROM EMP E
JOIN  DEPT D ON (D.DEPTNO=E.DEPTNO)
WHERE JOB LIKE 'DALLAS';

/* 6. Visualizar el nombre del empleado y el número de empleado junto con 
el nombre de su jefe y número de jefe. Etiquetar las columnas con Empleado, 
Num_empleado, Jefe, Num_jefe respectivamente. */

SELECT E.ENAME AS EMPLEADO, E.EMPNO AS NUM_EMPLEADO, E2.ENAME AS JEFE, E.MGR AS NUM_JEFE
FROM EMP E
JOIN EMP E2 ON (E.MGR=E2.EMPNO);

/* 7. Modificar la consulta anterior para visualizar todos los empleados 
incluyendo a KING, que no tiene jefe. */

SELECT E.ENAME AS EMPLEADO, E.EMPNO AS NUM_EMPLEADO, E2.ENAME AS JEFE, E.MGR AS NUM_JEFE
FROM EMP E
LEFT OUTER JOIN EMP E2 ON (E.MGR=E2.EMPNO);

/* 8. Crear una consulta que visualice el nombre del empleado, número de 
departamento y nombre de los empleados que trabajan en el mismo departamento 
que un empleado dado. */

SELECT E.ENAME, E.DEPTNO, E2.ENAME
FROM EMP E
LEFT JOIN EMP E2 ON (E.DEPTNO=E2.DEPTNO)
WHERE E.ENAME<>E2.ENAME ORDER BY E.ENAME;

/* 9. Mostrar la estructura de la tabla SALGRADE. Crear una consulta que 
visualice el nombre, puesto de trabajo, nombre de departamento, salario y 
grado de todos los empleados. */

SELECT ENAME, JOB, DNAME, SAL, GRADE
FROM EMP E
LEFT JOIN DEPT D ON D.DEPTNO=E.DEPTNO
LEFT JOIN SALGRADE S ON SAL BETWEEN LOSAL AND HISAL;

/* 10. Crear una consulta para visualizar el nombre y fecha de contratación 
de cualquier empleado contratado después de BLAKE. */

SELECT ENAME, HIREDATE
FROM EMP
WHERE HIREDATE > (SELECT HIREDATE FROM EMP E WHERE E.ENAME LIKE 'BLAKE');

/* 11. Visualizar todos los nombres de los empleados y fechas de contratación 
junto con los nombres de sus jefes y fecha de contratación de todos los 
empleados que fueron contratados antes que sus jefes. */

SELECT E.ENAME AS EMPLEADO, E.HIREDATE AS "CONTRATACION EMPLEADO", E2.ENAME AS JEFE, E2.HIREDATE AS "CONTRATACION JEFE"
FROM EMP E
LEFT JOIN EMP E2 ON E.MGR=E2.EMPNO
WHERE E.HIREDATE<E2.HIREDATE;

