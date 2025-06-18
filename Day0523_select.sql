/*
 *  2025. 5. 23.
 * 1. hr 데이터베이스 생성 후 작업을 완료
 */  

USE hr;

SELECT * FROM hr.employees e ;
SELECT first_name FROM employees;
SELECT first_name, last_name  FROM employees;
SELECT first_name, last_name, salary  FROM employees;

-- 모든 레코드를 전부 조회 = ALL (생략가능)
SELECT ALL department_id  FROM employees;

-- 중복 제거 = DISTINCT 
SELECT DISTINCT  first_name, department_id  FROM employees;

-- 정렬(문장의 마지막에) , 오름차순으로 = ORDER BY + ASC 생략 가능
SELECT DISTINCT  first_name, department_id  FROM employees ORDER BY first_name;

-- 정렬(문장의 마지막에) , 내림차순으로 = ORDER BY + DESC 생략 불능
SELECT DISTINCT  first_name, department_id  FROM employees ORDER BY first_name DESC;

-- [연습] employees 테이블에서 이름(first_name), 급여, 부서 번호(department_id) 급여의 내림차순으로 조회
SELECT first_name, salary, department_id FROM employees ORDER BY salary  DESC;