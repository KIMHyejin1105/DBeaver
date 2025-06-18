/* 2025년 5월 30일
   if함수, 다중행 함수(= 집계함수, 그룹함수)
   서브쿼리
 */

-- 날짜함수
SELECT makedate(2025, 100); -- 2025.1.1에서 100일 후 날짜변환
SELECT maketime(10, 23, 30); -- 정수 3개를 입력받아 날짜로(시간인거 같은데) 변환. 데이터 타입이 다른 타입으로 바뀌어서 반환. datetime 타입?

-- null 관련 함수
USE sakila;

-- if(조건, 참, 거짓)
SELECT * FROM payment; -- payment 테이블 확인

SELECT count(*) FROM payment; -- 전체 레코드 개수가 몇 개인지 확인.

SELECT if(amount >= 5, '5이상', '5미만') FROM payment; -- amount 컬럼이 5이상이면 5이상, 5미만이 나오도록 하고 싶음. payment 테이블의 amount 컬럼을 사용할 거라고 FROM payment 를 통해서 알려줌.

-- case~when~then~end
SELECT * FROM film_actor; -- film_actor 테이블 확인. -> actor_id는 PRIMARY KEY가 아님 -> 중복되어 있으니까.. ? 근데 확인해보면 actor_id, film_id 두 개가 다 PRIMARY KEY임. => 복합키라고 함..? -> 복합키는 그걸 합쳐서 유일하면 됨. 각각은 유일하지 않더라도, 합쳤을 때 유일하면 됨.

SELECT DISTINCT -- 중복되지 않도록 distinct 키워드 작성. 가독성을 위해 들여쓰기. 안해도 되긴 함.
   CASE film_id
      WHEN 1 THEN 'Drama' -- film_id가 1이면 'Drama' 나오도록
      WHEN 2 THEN 'Adventure'
      WHEN 3 THEN 'Horor'
      ELSE 'Everything' -- 1,2,3이 아닌 것들은 Everything.
   END -- 마지막에 end를 씀
FROM film_actor; -- 어느 테이블을 사용할 것인지 알려줌? film_id는 컬럼명이니까 어느 테이블의 film_id 컬럼을 사용할 것인지 알려준다는 것 같음

-- ifnull(수식1, 수식2)
USE world;
SELECT * FROM country;
SELECT name, region, gnpold FROM country; -- 오잉 컬럼명 대소문자 안 맞춰서 그냥 나오나보구만.

-- ifnull(컬럼, 값) : 컬럼의 값이 null인지 확인후 null이면 2번째 값(2번째 전달인자), null이 아니면 원래 값 그대로.
SELECT name, region, ifnull(gnpold, '없음') FROM country; -- gnpold 컬럼의 값이 null이면 없음이 나옴.

-- nullif(컬럼1, 컬럼2) : 컬럼1과 컬럼2가 같으면 null 반환, 다르면 첫번째값(첫 번째 전달인자) 반환.
SELECT name, localname FROM country;
SELECT name, localname, nullif(name, localname) FROM country; -- name, localname이 같으면 NULL 반환, 같으면 name 값 반환.

-- [문제] if함수를 이용해서 name, localname 같으면 '같다', 같지 않으면 '같지않다'
USE world;
SELECT name, localname, if(name = localname, '같다', '같지않다') FROM country;

-- [연습] ifnull()을 이용
-- hr.employees 테이블에 직원들 중
-- manager_id가 null인 사람은 "최고 경영자"이라고 출력,
-- maneger_id가 있는 사람은 manager_id 출력
-- 조회 컬럼: 이름, 급여, 매니저아이디
-- 조회 조건: 급여순으로 내림차순 정렬, 상위 30명만 출력
USE hr;
SELECT first_name, salary, ifnull(manager_id, "최고 경영자") AS "Manager"
FROM employees
ORDER BY salary DESC
LIMIT 30; -- LIMIT는 결과물이 나온 것이 있어야 제한할 수 있기 때문에 밑에 나옴. 얘는 select 명령문이 아님...?

-- [연습] hr.departments 테이블에서 매니저가 null인 경우 처리
-- 매니저번호가 없는 경우 "No Manager"이라고 출력,
-- 매니저가 있으면 매니저 이름
-- 조회 컬럼: 부서번호, 부서명, 매니저명
-- hint: join 사용
SELECT * -- join을 하면 어떻게 되는지 확인, 어떤 컬럼들이 나오는지, 몇 개가 나오는지 등등
FROM departments d JOIN employees e -- employees 테이블 안에 매니저 이름이 들어있음. -- INNER JOIN을 하면 NULL값을 제외하기 때문에 OUTER JOIN을 해야 함
ON d.manager_id = e.employee_id; -- 매니저 아이디랑 사원번호가 같을 때 join하라고 하는 것..?

SELECT
   d.department_id
   , d.department_name
   , ifnull(e.first_name, 'No Manager') AS "Manager Name"
FROM departments d LEFT OUTER JOIN employees e -- NULL 값을 가지고 있는 쪽이 자식임. LEFT에 있는 departments가 자식.
ON d.manager_id = e.employee_id;

SELECT * FROM departments;

/* 그룹함수 */
-- count(컬럼명): null은 세지 않는다! -- 함수니까 괄호를 써야 함
SELECT count(employee_id) FROM employees;    -- 107 -- employee_id가 몇 개니?
SELECT count(commission_pct) FROM employees; -- 35 -- null이 포함됨. 값이 있는 개수만 세기 때문에 NULL은 못 셈.

-- max(컬럼명), min(컬럼명) -- 숫자가 들어있는 컬럼의 최대값, 최소값
SELECT max(salary), min(salary) FROM employees; -- 숫자로 되어있는 salary의 최대, 최소값

-- sum(컬럼명), avg(컬럼명) -- 합계, 평균
SELECT sum(salary) "급여합계", round(avg(salary),2) "급여평균" FROM employees; -- AS 생략 가능 -- round() -> 여기서는 소수점 이하 2자리 나오도록 함.

-- group by 명령을 이용해서 특정 컬럼을 그룹화함 ==> 그룹함수 -- 그룹함수는 보통 group by랑 많이 사용합니다? ~별 이런 말이 나오면 그룹화하라는 이야기
-- 각 부서별 인원수
SELECT department_id, count(*) AS "부서인원" -- 그룹화 된 것의 각각을 셈..? -- 보통 그룹함수(집계함수)를 많이 넣음 -- department_id는 GROUP BY에 사용한 그룹 기준이 되기 때문에 사용 가능. 그룹 기준이 아니면 쓸 수 없음.
FROM employees
GROUP BY department_id;
-- SELECT first_name -- 이렇게 하면 에러가 남. 그룹화할 수 없는 컬럼이라서?
-- FROM employees
-- GROUP BY department_id; -- department_id로 그룹화.

-- 부서별 평균급여, 총급여, 최대급여, 최소급여
SELECT 
   department_id, count(*) AS "부서인원"
   , avg(salary), sum(salary)
   , max(salary), min(salary)
FROM employees
GROUP BY department_id; -- 그룹화를 하면 그룹함수를 쓰거나 그룹의 기준이 되는 것만 SELECT 할 수 있음?

-- [문제] 직무별 직무아이디, 평균급여를 조회하시오
SELECT
   job_id, avg(salary) AS "평균급여"
FROM employees
GROUP BY job_id
ORDER BY 2; -- 2번째 컬럼을 기준으로 정렬

-- [문제] 부서별 평균급여와 인원수를 조회
--        부서별로 값이 NULL이거나 1명인 경우는 제외 -> '부서별로'라서 조건을 HAVING에 줘야 함.
SELECT
   department_id, avg(salary), count(*) AS "부서인원"
FROM employees
GROUP BY department_id
HAVING
   department_id IS NOT NULL
   AND
   count(*) >= 2;

-- [문제] 입사년도별 입사인원을 조회하시오
--        년도 4자리, 입사인원 !! 주말에 관련 문제 더 주니깐 잘 풀기~~><!
SELECT YEAR(hire_date) AS "입사년도", count(*) AS "입사인원"
FROM hr.employees e
GROUP BY YEAR(hire_date) -- group by는 별칭을 안 주는 것이 좋나봄. 가끔 오류가 날 때가 있어서.
ORDER BY 입사년도; -- 오 별칭을 줘도 되는구나. ORDER BY는 결과가 나왔기 때문에 이미 입사년도 컬럼이 있어서 별칭을 써도 되나봄.

SELECT * FROM employees;

-- [문제] 모든 사원의 이름과, 전화번호 첫 3자리를 출력하시오.
SELECT
   first_name
   , substring(phone_number, 1, 3) phone_number -- AS 생략
FROM employees;

-- [문제] 모든 사원의 이름과 성, 그리고 (이름과 성을 합한 글자수)를 출력하시오.
SELECT first_name, last_name
      , concat(first_name, last_name)
      , length(concat(first_name, last_name)) 글자수 -- AS 생략. 특수문자 없어서 큰 따옴표 없어도 되나봐요.
FROM employees;

/*
 * 서브쿼리(Subquery)
 * - 서브쿼리 -- 안쪽
 * - 메인쿼리 -- 바깥쪽. 내가 보는 결과.
 * 
 * 서브쿼리의 종류
 *  1) 단일행 서브쿼리
 *  2) 다중행 서브쿼리
 *  3) 다중컬럼 서브쿼리
 */

-- 사원번호가 162번의 급여가 얼마인가?
SELECT salary
FROM employees
WHERE employee_id = 162; -- 하나의 값으로 똑 떨어짐 => 단일 행 서브쿼리로 사용 가능.

-- [연습] 사원번호가 162번의 급여와 같은 액수의 급여를 받는 직원의 이름, 급여, 부서번호를 조회하시오
-- 10500 -- 첫 번째 쿼리에서 얻은 결과
-- 1) 두 번 작업
SELECT salary
FROM employees
WHERE employee_id = 162;

SELECT first_name, salary, department_id
FROM employees
WHERE salary = 10500;

-- 2) 서브쿼리로 한번에
SELECT first_name, salary, department_id -- 내가 보고 싶은 것.
FROM employees
WHERE salary = (SELECT salary
            FROM employees
            WHERE employee_id = 162); -- 여기서 나온 결과를 비교에 사용.
            
-- [연습] 'Oliver'라는 직원과 같은 부서에서 근무하는 동료직원의 부서번호, 이름을 조회
SELECT department_id
FROM employees
WHERE first_name = 'Oliver'; -- 이걸 통해서 부서번호를 앎.

SELECT department_id, first_name
FROM employees
WHERE department_id = 80;

-- 서브쿼리로 해결하기
SELECT department_id, first_name
FROM employees
WHERE department_id = (SELECT department_id
                  FROM employees
                  WHERE first_name = 'Oliver'); -- 괄호를 꼭 해줘야 함

-- [연습] 위와 동일 - 부서명과 직원명으로 조회하시오
SELECT department_name, first_name
FROM employees e INNER JOIN departments d -- INNER 생략 가능.
    USING (department_id) -- department_id가 같을 때 join
WHERE department_id = (SELECT department_id -- 여기는 USING까지 한 결과를 가지고 하는 것?
                  FROM employees
                  WHERE first_name = 'Oliver'); -- 이런걸 단일행 서브 쿼리라고 함
                  
-- 2) 다중행 서브쿼리
-- 30번 부서에서 근무하는 직원들의 직급과 동일한 직급이 다른 부서에도 있는지 조회하자
--  (1)
SELECT DISTINCT job_id
FROM employees
WHERE department_id = 30;

SELECT job_id, department_id
FROM employees
WHERE job_id IN (SELECT DISTINCT job_id
              FROM employees
              WHERE department_id = 30); -- 쿼리의 결과가 여러 개 나오기 때문에 IN 연산자로 비교해야 함. =로 비교할 수 없음.

-- [문제] world 스키마에서 제공하는 데이터베이스를 확인한 후 
-- 공식언어를 'Spanish'로 사용하는 나라의 이름과 공식언어를 조회하는 코드를 서브쿼리로 작성하시오.
USE world;

SHOW tables; - 테이블 개수 확인

SELECT * FROM city; -- city 테이블 조회. 어떤 것이 있는지 확인.
SELECT * FROM country; -- country 테이블 조회.
SELECT * FROM countrylanguage;

-- 국민 모두(100%)가 스페인어를 사용하는 나라 코드 
SELECT countrycode
FROM countrylanguage
WHERE
   percentage = 100 -- 전체 인구
AND
   `LANGUAGE` = 'Spanish'; -- LANGUAGE -> 키워드가 아니고 컬럼명인 것을 알려주기 위해 ``사용

SELECT name, population
FROM country
WHERE code IN (SELECT countrycode
            FROM countrylanguage
               WHERE
                   percentage = 100
               AND
                 `LANGUAGE` = 'Spanish');

--
USE hr;

/* 1) ANY 연산자 */
-- "< ANY"는 서브쿼리에서 나온 그 어떤 값보다 작은 값 -- 모든 경우의 수에서 작아야 함. -> 모든 경우의 수에서 제일 큰 값보다 작으면 됨? ANY 연산자는 비교 연산자와 함께 사용함.
-- (즉, 서브쿼리의 가장 큰 값보다 작으면 됨.)
SELECT first_name, salary
FROM employees
WHERE salary < ANY( -- 어떤 값보다 작아야 함.
               SELECT salary
               FROM employees
               WHERE job_id = 'ST_MAN'
               ORDER BY salary) -- 5800 ~ 8200(salary 최소, 최대)
ORDER BY salary; -- salary로 정렬

-- "> ANY"는 서브쿼리에서 나온 가장 적은 값보다 큰값들 
SELECT first_name, salary
FROM employees
WHERE salary > ANY( -- ANY는 OR 연산과 비슷. salary가 서브 쿼리에 있는 어떤 값보다 크면...?
               SELECT salary
               FROM employees
               WHERE job_id = 'ST_MAN'
               ORDER BY salary) -- 5800 ~ 8200
ORDER BY salary; 

-- "= ANY"
SELECT first_name, salary
FROM employees
WHERE salary = ANY( 
               SELECT salary
               FROM employees e INNER JOIN jobs j
               USING (job_id)
               WHERE job_title LIKE '%Manager')
ORDER BY salary; 

/* ALL 연산자 */
-- = ALL은 서브쿼리에서 나온 모든 값과 같은 값을 가진 SALARY를 조회함
-- 없음!!!
SELECT employee_id, first_name, salary
FROM employees
WHERE salary < ALL ( -- 조회된 모든 값보다 작은 것. -- ALL은 AND 연산과 비슷
                SELECT salary
                FROM employees e INNER JOIN jobs j
                USING (job_id)
                WHERE job_title LIKE '%Manager' ORDER BY 1);

SELECT employee_id, first_name, job_id, salary
FROM employees
WHERE salary > ALL (
                SELECT e.salary
                FROM employees e INNER JOIN jobs j
                USING (job_id)
                WHERE job_title LIKE '%Manager')
 ORDER BY salary;

-- 다중 컬럼 서브쿼리
-- [문제]
-- 1) 단계
SELECT department_id, max(salary)
FROM employees
GROUP BY department_id; -- 부서별로 최고 금액을 받는 salary

-- 2) 단계
SELECT * FROM employees
WHERE
department_id = 30
AND
salary = 11000; -- 30번 부서에서 가장 급여를 많이 받는 사람의 전체 데이터를 조회.

-- 위 두 쿼리를 합쳐서 하나의 서브쿼리로 작성
SELECT *
FROM employees
WHERE
(department_id, salary) IN (SELECT department_id, max(salary) -- WHERE절을 쓸 때, 컬럼명이 여러 개이면 () 괄호를 꼭 써야함.
                     FROM employees
                     GROUP BY department_id); -- 결과가 여러 줄 나와서? IN 연산자를 사용해야 함.

-- [문제] 각 부서별로 급여를 가장 많이 받는 직원의 사번, 이름, 급여, 부서명, 직급명을 조회
-- join과 서브쿼리를 함께 사용 -- 각 부서별로 최고금액을 수령하는 직원의 이름, 급여, 부서명, 직무명을 조회하는 코드?
SELECT
   employee_id, concat(first_name, ' ', last_name) AS "name",
   salary, department_name, job_title
FROM employees e INNER JOIN departments d
ON e.department_id = d.department_id
INNER JOIN jobs j
ON e.job_id = j.job_id
WHERE (e.department_id, e.salary) IN (SELECT department_id, max(salary)
                               FROM employees e
                               GROUP BY department_id); -- 다중컬럼 서브쿼리임.(단일행 서브쿼리랑 비슷하게 생김)

/* 스칼라 서브쿼리 : 서브쿼리의 사용위치가 select from 사이에! */
SELECT
   (SELECT last_name FROM employees WHERE first_name='Bruce') AS "Bruce의 성", -- 결과 값이 컬럼처럼 나오는데, 컬럼명이 기니까 별칭을 지어줌?
   (SELECT last_name FROM employees WHERE first_name='Daniel') AS "Daniel의 성"
; -- 이 뒤에 FROM 절이 오는데, 사실상 필요 없음?

/* Inline VIEW : 쿼리의 결과가 다중 행 + 다중 컬럼일 경우 where에 사용하기 어려우므로(못 쓴다는 건 아닌데, 처리하기 어려움)
 *              서브쿼리의 위치를 from 절에 두어서 그 결과를 마치 하나의 가상 테이블로 처리하는 개념
 */ 

SELECT employee_id, first_name, salary, department_id
FROM employees
WHERE department_id = 80; -- 80번 부서에 근무하는 직원의 정보 조회. 테이블 형태로 나옴.

SET @rownum := 0; -- 변수를 선언하고 초기화 -- SET으로 만든 변수는 프로그램이 동작하는 동안에만 사용 가능. 지역변수처럼 프로그램을 껐다가 키면 날아감. 초기화하는 방법이 여기서 이걸 실행 시켜야 함. 저기 SELECT 문 안에서 초기화할 수 있는 방법이 없다는 것 같음.

SELECT @rownum := @rownum + 1; -- 변수의 값을 조회 -- 실행할 때마다 값이 증가함. 오라클에는 없고 MySQL에만 있는 코드

-- select 사이에 넣기
SELECT @rownum := @rownum + 1 AS seq, tbl.* -- tbl 테이블에서 전체 다 조회? -- 일련번호처럼 앞에 나옴. 일련번호를 넣고 싶을 때 사용하는 방법. -> 테이블 만들 때는 자동증가하면 되는데, 기존에 있는 테이블은 그런 거 못하니까 하는 것?
FROM 
   (SELECT employee_id, first_name
         , salary, department_id
   FROM employees
   WHERE department_id = 80) tbl -- 쿼리 결과로 나온 테이블에 이름을 붙여줌 -> tbl이라고. FROM 절에 인라인 뷰 서브쿼리로 사용?
WHERE salary > 9000; -- tbl 테이블에서 다시 조건을 걸고 조회.

-- inline view에 넣기
SELECT tbl.* 
FROM 
   (SELECT @rownum := @rownum + 1 AS seq, employee_id, first_name
         , salary, department_id
   FROM employees
   WHERE department_id = 80) tbl -- tbl이라는 가상테이블에 하나의 컬럼이 추가되는 특이한 문법. 흠.. 무슨 소리지. 안에서 만든 일련 번호를 가지고 그 중에서 salary > 9000을 뽑아서 seq가 1~15로 늘어나는 것이 아니라 뒤죽박죽 늘어난 것인가.. 흠.. 그런 것 같군..
WHERE salary > 9000;

-- [문제] 서브쿼리를 이용하여 아래 문제를 해결하시오
-- 각 부서별로 해당 부서의 급여 평균 미만의 급여를 수령하는 직원 명단 조회
-- (부서번호, 사원번호, 이름, 급여, 부서별 평균급여를 조회한 결과가 출력되어야 함)
-- avg(salary) --> 그룹함수이므로 사원번호나 이름과 같이 그룹화되지 않은 컬럼과 함께 사용할 수 없다!
-- 각 부서별 평균급여
SELECT department_id AS "부서번호", avg(salary) AS "부서평균" -- department_id는 그룹화 키이고, avg는 그룹함수라서 쓸 수 있음. employee_id 이런 건 쓸 수 없음.
FROM employees
GROUP BY department_id;

USE hr;
-- 각 부서별 평균급여를 서브쿼리 안으로!
SELECT e.department_id, e.employee_id, e.first_name, e.salary, round(부서평균) -- 반올림
FROM 
   (SELECT department_id AS "부서번호", avg(salary) AS "부서평균"
   FROM employees
   GROUP BY department_id) tbl -- 테이블에 별칭을 줄 때에는 AS를 사용하면 안됨. -- 이게 테이블이니까 FROM절에 넣어줌?
   , employees e -- tbl 테이블과 e 테이블을 조인하는 것? (콤마를 쓰면 where을 쓰는 건가봐. 아닌가?)
WHERE tbl.부서번호 = e.department_id
AND e.salary < tbl.부서평균
ORDER BY 5 ASC; -- 부서번호 별로 정렬하고, 같은 부서일 경우에는 salary 별로 오름차순 정렬하겠다