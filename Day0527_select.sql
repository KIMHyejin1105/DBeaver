-- 2025년 5월 27일(SELECT)
/* 
 * 
 ***** SQL(Structured Query Language)
 - DBMS에 접근해서 처리하는 모든 명령어
 - 국제 표준이지만 각 벤더별로 명령문이 조금씩 다르다
 - 명령어의 종류
 
 1) DDL(Database Definition Language) : 객체를 다루는 명령어
 	Create(생성), Alter(변환), Drop(삭제),  
 
 2) DML(Database Manupulation Language) : 테이블의 레코드를 다루는 명령어
 	Insert(삽입), Update(수정), Delete(삭제), Select(조회)
 	
 3) TCL(Transaction Control Language) : 트랜잭션을 다루는 명령어
 	Commit(저장), Rollback(전체 되돌림), Savepoint(되돌릴 위치까지 되돌림)
 	
 4) DCL(Database Control Language) : 권한을 다루는 명령어
 	Grant(권한 부여), Revoke(권한 회수)

*** SQL 명령은 ; 으로 끝나야 한다.	 	 
*/

/* Select문 :  조회 

SELECT [DISTINCT | ALL ] 컬럼명 FROM 테이블 명 -> 대문자 
ORDER BY 컬럼명 [ASC | DESC ]  -> 가장 마지막!
*/

USE hr;

SHOW DATABASES;

SELECT * FROM regions;
SELECT * FROM locations;
SELECT * FROM countries;
SELECT * FROM departments;
SELECT * FROM jobs;
SELECT * FROM employees;			-- 직원 정보를 알려주는 컬럼
SELECT * FROM job_history;

SELECT * FROM employees;

SELECT first_name, salary FROM employees;

SELECT  DISTINCT department_id  FROM employees; -- DISTINCT : 중복을 제거하고 도출해라.

-- [연습] 이름(first_name)과 급여, 부서 번호를 급여 기준으로 내림차순 조회하시오.
SELECT first_name, salary, department_id FROM employees
ORDER BY salary DESC;

-- [연습] 이름(first_name)과 급여, 부서 번호를 부서 기준으로 오름순 조회하시오.
-- ASC : 오름차순. DESC : 내림차순
SELECT first_name, salary, department_id FROM employees
ORDER BY department_id ASC, salary DESC, first_name  ASC; -- ASC 생략 가능 ,급여가 같을 경우 높은 순대로 작성, + 급여도 똑같을 경우 이름순

-- [연습] employees 테이블에서 이름, 입사일, 업무를 조회하시오 + 입사일 기준 오름차순
SELECT first_name, hire_date, job_id FROM employees
ORDER BY hire_date ASC;

-- 데이터 베이스 조회 , 메타정보를 보기 위할 때 사용함 
SHOW DATABASES;

-- 테이블을 조회
SHOW tables;

USE world;
SHOW tables;

USE sakila;
SHOW tables;

USE hr;
SHOW tables;
-- ------------------ 조건을 이용한 조회
/*
 *  
SELECT [DISTINCT | ALL ] 컬럼명 FROM 테이블 명 -> 대문자 
WHERE 조건 -> true, false로 도출되어야 함 
ORDER BY 컬럼명 [ASC | DESC ]  -> 가장 마지막!

<비교 연산자?
> | < | >= | <=  | = | !=

<null 비교>
	컬럼명 is null
	컬럼명 is not null
	
<논리연산>
	and, or, not
	조건 and 조건
	조건 or 조건
	
< 문자열 비교 연산 >
- 문자열을 표시할 때에는 ' '로 표시해야 한다
- 문자열을 비교를 할 때 비교연산자를 사용하면 !!! 정확히 해야 한다.
- like를 이용하여 연산을 할 수 있다.
- 와일드카드 : %(0개이상),  _(_ 하나 당 글자 하나로 글자 수 제한)

컬럼명 LIKE 'W%' : W로 시작하는 !
컬럼명 LIKE '%s' : s로 끝나는
컬럼명 LIKE '%i%' : i가 포함되는 !
컬럼명 LIKE '%%' : 모든 글자 !

< 산술 연산자?
+ - * / %
 */

-- [문제] 급여가 5000 이상인 사람을 모두 조회하시오
SELECT * FROM employees
WHERE salary >= 5000;

-- 매니저 번호가 103번인 직원의 사원번호, 이름 , 부서, 매니저 번호를 조회하시오
SELECT employee_id, first_name, department_id, manager_id FROM employees
WHERE manager_id = 103;

-- 이름이 'William' 인 사람의 이름, 성, 급여, 입사일을 조회하시오
SELECT first_name, last_name, salary, hire_date FROM employees
WHERE first_name = 'William';

-- 이름, 성, 급여, 부서번호를 조회하시오
SELECT first_name, last_name, salary, department_id FROM employees;

-- 이름, 성, 급여, 부서번호를 조회하시오 (부서 오름차순)
SELECT first_name, last_name, salary, department_id FROM employees
ORDER BY department_id;

-- 이름, 성, 급여, 부서번호를 조회하시오 (부서번호가 null인 사람)
SELECT first_name, last_name, salary, department_id FROM employees
WHERE department_id IS NOT NULL;

-- [연습] 이름, 성, 급여, 부서번호, 커미션(을 받는 사람만)을 조회
SELECT first_name, last_name, salary, commission_pct FROM employees
WHERE commission_pct IS NOT NULL;

-- [연습]  매니저가 없는 직원의 이름, 성, 급여, 부서번호
SELECT first_name, last_name, salary  FROM employees
WHERE manager_id IS NOT NULL;

-- 논리 연산을 이용한 조회
-- 급여가 10000을 초과하면서 직급이 'SA_REP'인 직원의 정보(이름, 이메일, 전화번호, 직급)를 조회하시오
SELECT first_name, salary, email, phone_number, job_id FROM employees
WHERE salary > 10000 AND job_id = 'SA_REP';

-- [연습] 부서가 60번 이거나 급여가 15000이상인 직원의 정보
SELECT first_name, salary, email, phone_number, job_id, department_id FROM employees
WHERE salary >= 15000 OR  department_id = 60;

-- 급여가 5000 이상 10000이하인 직원 정보 조회
SELECT first_name, salary FROM employees
WHERE salary BETWEEN 5000 AND 10000
ORDER BY salary DESC;

-- 부서 10, 20, 30 인 정보 조회
SELECT first_name, salary, department_id FROM employees
WHERE department_id IN (10, 20, 30);

-- 이름이 W로 시작하는 사람의 정보(이름, 급여)
SELECT first_name, salary FROM employees
WHERE first_name LIKE 'W%';

-- 이름이 n으로  끝나는 사람의 정보(이름, 급여)
SELECT first_name, salary FROM employees
WHERE first_name LIKE '%n';

-- 이름이 S로 시작해서 n으로  끝나는 사람의 정보(이름, 급여)
SELECT first_name, salary FROM employees
WHERE first_name LIKE 'S%n';

-- 이름이 K로 시작해 5글자인 직원의 정보(이름, 급여)
SELECT first_name, salary FROM employees
WHERE first_name LIKE 'K____';





