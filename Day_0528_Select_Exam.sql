/*
[연습문제] Select문의 기초 (아래 주어진 문제를 해결하시오)
*/

USE hr;                    -- hr 스키마를 사용하겠다고 선언
SHOW tables;
SELECT DATABASE();        -- 현재 사용 중인 스키마 확인

-- 1) 이름이 ‘Hazel’인 사람의 성, 이메일, 전화번호를 조회하라. (2명)
SELECT last_name, email, phone_number 
FROM  employees
WHERE first_name = 'Hazel';

-- 2) 매니저가 103인 직원의 정보(아이디, 이름, 부서, 매니저번호)를 조회하시오.
SELECT job_id, first_name, department_id, manager_id 
FROM employees
WHERE manager_id = 103;

DESC hr.employees;   -- employees 테이블의 컬럼 타입 확인

-- 3) 어느 부서에도 속하지 않은 직원의 정보 (이름, 전화번호, 부서)를 조회하시오
SELECT first_name, phone_number, department_id 
FROM employees
WHERE department_id IS NULL;


-- 4) 급여가 5000을 초과하면서 JOB_ID가 'xxxREP'이고 매니저가 101번인 직원의 이메일,
--    이름, 전화번호, JOB_ID 정보를 조회하시오.
SELECT email, first_name, phone_number, job_id 
FROM employees
WHERE salary > 5000 AND job_id LIKE  '___REP' AND manager_id = 101;
-- where job_id like '%REP' and salary >5000 and manager_id = 101;


-- 5) 부서가 60이거나 이름이 A로 시작하는 직원의 정보
--    (이름, 급여, 부서)를 조회하시오.
SELECT first_name, salary, department_id 
FROM employees
WHERE department_id = 60 OR first_name LIKE 'A%';


-- 6) 부서가 10이거나 50이거나 60번 부서의 직원의 정보(이름, 급여, 부서)를 조회하시오
SELECT first_name, department_id , salary
FROM employees
WHERE department_id IN (10, 50, 60);


-- 7) 이름이 3글자인 모든 사람의 정보를 조회하시오.
SELECT *
FROM hr.employees e
WHERE first_name LIKE '___';


-- 8) 전체 직원들중 직급이 'CLERK' 들의 이름과 직급을 조회 (종류가 많음) - 모르겟음
SELECT first_name, job_id
FROM employees
WHERE job_id LIKE '%CLERK';


-- 9) 커미션(COMMISSION_PCT)을 받는 사람들의 이름과 이메일, 커미션을 조회(35명)
SELECT first_name, email, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL;


-- 10) 이메일이 'KGEE'인 사람의 풀네임은?
SELECT first_name, last_name
FROM employees
WHERE email = "KGEE";


-- 11) SALARY(급여)가 10000달러 초과하면서, JOB_ID(직업번호)가 'SA_REP' 인 사람의
--     EMAIL, LAST_NAME, PHONE_NUMBER를 EMPLOYEES 테이블에서 조회
SELECT email, last_name, phone_number
FROM employees
WHERE salary > 10000 AND job_id = 'SA_REP';


-- 12) SALARY(급여)가 3000달러 미만이거나, 14000달러를 초과하는 직원의
--     EMPLOYEE_ID를 조회 (27명)
SELECT employee_id
FROM employees
WHERE salary < 3000 OR  salary > 14000;

-- 13) 모든 직원의 업무와 부서번호를 중복되는 값이 없도록 조회하시오. (20명)
SELECT DISTINCT  job_id, department_id
FROM employees


-- 14) 80번 부서에 속한 직원의 사원번호, 이름, 급여, 입사일을 조회하시오.
--     이때 입사일이 빠른순으로 정렬
SELECT employee_id, first_name, salary, hire_date
FROM employees
WHERE department_id = 80
ORDER BY hire_date ASC;


-- 15) 전체 직원의 사원번호, 이름, 급여, 부서번호를 조회하시오.
--     이때 부서번호 오름차순, 같은 부서의 경우 급여의 내림차순으로 정렬하시오
SELECT employee_id, first_name, salary, department_id
FROM employees
ORDER BY department_id ASC, salary DESC;




