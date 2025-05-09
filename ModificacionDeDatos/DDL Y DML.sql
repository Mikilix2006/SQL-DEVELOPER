/* ===== DDL Y DML ===== */

CREATE TABLE DEPT2 AS SELECT * FROM DEPT;
CREATE TABLE EMP2 AS SELECT * FROM EMP;
CREATE TABLE SALGRADE2 AS SELECT * FROM SALGRADE;

/* EJERCICIO 1 */

INSERT INTO DEPT2 VALUES (50,'DESARROLLO','MADRID');

/* EJERCICIO 2 */

ALTER TABLE EMP2 MODIFY JOB VARCHAR2(20);

/* EJERCICIO 3 */

INSERT INTO EMP2 VALUES (8010,'GARCIA','JEFE PROYECTO',7839,'16/11/2004',3000,NULL,50);
INSERT INTO EMP2 VALUES (8011,'GARRIDO','PROGRAMADOR SENIOR',8010,'17/11/2004',1500,NULL,50);
INSERT INTO EMP2 VALUES (8012,'ORTEGA','PROGRAMADOR JUNIOR',8010,'17/11/2004',1000,NULL,50);
INSERT INTO EMP2 VALUES (8013,'ROJAS','PROGRAMADOR JUNIOR',8010,'17/11/2004',1000,NULL,50);

/* EJERCICIO 4 Y 5 */

COMMIT;

/* EJERCICIO 6 */

UPDATE EMP2
SET ENAME = 'VELASCO'
WHERE EMPNO = 8011;

/* EJERCICIO 7 */

DELETE FROM EMP2 WHERE ENAME LIKE 'ROJAS';

COMMIT;

/* PARA A�ADIR UNA COLUMNA: ALTER TABLE <NOM_TABLA> ADD <NOM_COLUM> <TIPO_COLUM> */

