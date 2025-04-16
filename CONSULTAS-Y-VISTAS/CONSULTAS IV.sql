/* ===== CONSULTAS IV ===== */

/* 1. Visualice sobre el salario el máximo, el mínimo, 
la suma y la media aritmética, para todos los empleados. 
Redondee los resultados de tal manera que muestre números 
enteros (sin decimales). */

SELECT MAX(SAL) AS MAXIMO, MIN(SAL) AS MINIMO, SUM(SAL) AS SUMA, ROUND(AVG(SAL)) AS MEDIA
FROM EMP;

/* 2. Visualice el máximo, el mínimo, la suma y la media 
aritmética de los salarios por puesto de trabajo (JOB). */

SELECT JOB, MAX(SAL) AS MAXIMO, MIN(SAL) AS MINIMO, SUM(SAL) AS SUMA, ROUND(AVG(SAL)) AS MEDIA
FROM EMP 
GROUP BY JOB;

/* 3. Escriba una consulta que visualice el número de 
personas que tiene el mismo puesto de trabajo. */

SELECT JOB, COUNT(JOB) FROM EMP GROUP BY JOB;

/* 4. Determine el número total de directores. Etiquete 
la columna con el nombre num_directores. */

SELECT COUNT(DISTINCT(MGR)) AS NUM_DIRECTORES FROM EMP;

/* 5. Escriba una consulta que visualice la diferencia 
entre el salario más alto y el más bajo de la empresa. 
Etiquete la columna con el nombre diferencia. */

SELECT MAX(SAL)-MIN(SAL) AS DIFERENCIA FROM EMP;

/* 6. Visualice el número de jefe y salario del empleado 
con menor salario con dependencia de ese jefe. Excluya a 
cualquier empleado cuyo jefe no se identifique. Excluya 
cualquier grupo cuyo mínimo salario sea menor que 1000. 
Clasifique el resultado en orden descendiente de salarios. */

SELECT MGR, MIN(SAL) AS MINIMO
FROM EMP
WHERE MGR IS NOT NULL AND
      MGR IN (SELECT E2.EMPNO FROM EMP E2)
GROUP BY MGR;

/* 7. Escriba una consulta que visualice el nombre del 
departamento, localidad, número de empleados y la media 
de salarios, para todos los empleados de cada departamento. */

SELECT DNAME, LOC, COUNT(ENAME) AS "CANTIDAD EMPLEADOS", ROUND(AVG(SAL)) AS "SALARIO MEDIO"
FROM EMP E
RIGHT JOIN DEPT D USING (DEPTNO)
GROUP BY D.DNAME, LOC;

/* 8. Cree una consulta que visualice el número total de 
empleados y de ese total, el número de los que fueron contratados 
en 1980, 1981, 1982 y 1983. Etiquete las columnas como Total, 1980, 
1981, 1982 y 1983 */

SELECT COUNT(*) AS TOTAL,
    SUM(DECODE(TO_CHAR(HIREDATE,'YY'),80,1,0)) AS "1980",
    SUM(DECODE(TO_CHAR(HIREDATE,'YY'),81,1,0)) AS "1981",
    SUM(DECODE(TO_CHAR(HIREDATE,'YY'),82,1,0)) AS "1982",
    SUM(DECODE(TO_CHAR(HIREDATE,'YY'),83,1,0)) AS "1983"
FROM EMP;

/* 9. Cree una matriz que visualice el empleo (JOB), salario 
correspondiente según departamento y el salario total para 
ese empleo de todos los departamentos */

SELECT E.JOB, 
    SUM(DECODE(DEPTNO,10,SAL,0)) AS "DEPT 10",
    SUM(DECODE(DEPTNO,20,SAL,0)) AS "DEPT 20",
    SUM(DECODE(DEPTNO,30,SAL,0)) AS "DEPT 30",
    SUM(DECODE(JOB,E.JOB,SAL,0)) AS "TOTAL"
FROM EMP E
GROUP BY E.JOB
ORDER BY E.JOB;

