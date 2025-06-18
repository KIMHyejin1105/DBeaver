/* JOIN *
 * 
 * 1) Cross Join 
 * 2) Inner Join 
 * 			: 서로 관계를 맺고 있는 둘 이상의 테이블들로부터 데이터를 조회
 * 			: FK값이 NULL인 경우에는 조회 대상에서 제외된다.
 * 			: inner 키워드 생략 가능
 * 3) Outer Join
 * 			: FK값이 NULL인 경우에도 조회
 * 			: LEFT OUTER JOIN, RIGHT OUTER JOIN 
 *  4) Self Join
 * 			: 하나의 테이블 안에 PK, FK 를 같이 가지고 있는 경우
 */
 
USE hr;

SELECT * FROM employees;			-- 107 (fk : department_id)
SELECT * FROM departments;     -- 27  (pk : department_id)

-- Cross Join
SELECT *
FROM employees e CROSS JOIN departments d;

-- Inner Join (모든 컬럼)
SELECT *
FROM employees e INNER JOIN departments d
ON e.department_id	= d.department_id;

-- 1) 특정 컬럼만 추출(이름, 부서명, 업무, 급여)
SELECT e.first_name, d.department_name, e.job_id, e.salary
FROM employees e INNER JOIN departments d
ON e.department_id	= d.department_id
ORDER BY e.first_name; -- 컬럼 순서대로 숫자를 입력해도 가능함 

-- 2) 특정 컬럼만 추출 - USING(사원번호, 이름, 부서명, 급여)
SELECT e.first_name, d.department_name, e.job_id, e.salary
FROM employees e INNER JOIN departments d
USING (department_id)  -- 컬럼명이 동일할 때 사용
ORDER BY 1;

-- 3) 이름, 급여, 부서명을 조회, 급여가 5000을 초과하는 직원들 조회
SELECT e.first_name, d.department_name, e.salary
FROM employees e INNER JOIN departments d
USING (department_id)  -- 컬럼명이 동일할 때 사용 (= ON e.department_id	= d.department_id)
WHERE e.salary > 5000
ORDER BY 3 DESC;

-- 3-1) 이름, 급여, 부서명을 조회, 급여가 5000을 초과하는 직원들 조회 [JOIN ON 사용]
SELECT e.first_name, d.department_name, e.salary
FROM employees e INNER JOIN departments d
ON e.department_id	= d.department_id  -- 컬럼명이 동일할 때 사용 (= USING (department_id))
WHERE e.salary > 5000
ORDER BY 3 DESC;

-- 테이블명 확인
SHOW tables;
SELECT * FROM locations;
SELECT * FROM departments;

-- 4) 부서명과 도시를 조회하시오. 단 manager가 없는 부서는 제외
SELECT d.department_id, l.city, d.manager_id
FROM departments d JOIN locations l
USING (location_id)
WHERE d.manager_id IS NOT NULL;
ORDER BY 1;

-- [연습문제] 테이블 3개를 조인해보기
-- employees, department, locations [employees e department d locations l]
-- 직원명, 급여, 부서명, 근무하는 도시명을 조회하시오
SELECT e.first_name, e.salary, d.department_name, l.city
FROM employees e INNER JOIN departments d
USING (department_id)
INNER JOIN  locations l
USING (location_id);

-- [연습문제-2] 테이블 3개를 조인해보기
-- employees, department, locations [employees e department d locations l]
-- 직원명, 급여, 부서명, 근무하는 도시명을 조회하시오
-- salary가 5000이상, salary 순으로 내림차순
SELECT e.first_name, e.salary, d.department_name, l.city
FROM employees e INNER JOIN departments d
USING (department_id)
INNER JOIN  locations l
USING (location_id)
WHERE e.salary >= 5000
ORDER BY e.salary DESC; 

-- [연습문제] 부서명과 부서가 속한 도시와 해당 도시가 있는 나라를 조회
-- 		manager_id 가 없는 부서를 제외하면 11개
--    		manager_id 가 없는 부서를 제외하면 27개
SELECT department_name, city, country_name
FROM departments
INNER JOIN locations
USING (location_id)
INNER JOIN countries
USING (country_id)
WHERE manager_id IS NOT NULL;  -- manager_id 유무에 따라서 판단
ORDER BY department_name

-- [연습문제] 부서명과 부서장의 이름, 부서가 속한 도시와 해당 도시가 있는 나라를 조회하시오
-- Manager가 없는 부서는 조회 조건에서 제외됨 [11개]
SELECT department_name, first_name, city, country_name
FROM departments d INNER JOIN employees e
ON d.manager_id = e.employee_id			-- 매니저가 없는 부서도 있음
INNER JOIN locations 
USING (location_id)
INNER JOIN countries 
USING (country_id)
ORDER BY department_name;

SELECT * FROM departments;

-- Outer Join 연습
-- 문제: 부서명이 없는 직원을 포함하여 직원명, 급여, 부서명 조회
-- left outer join
SELECT e.first_name, e.salary, d.department_name
FROM employees e LEFT OUTER JOIN departments d -- PK 를 가지고 있는 쪽을 지정하면 될 듯?
ON e.department_id = d.department_id;

SELECT e.first_name, e.salary, d.department_name
FROM departments d RIGHT OUTER JOIN  employees e  -- FK 를 가지고 있는 쪽이 PK 가지고 있는 쪽에 묶임
USING (department_id);

-- [연습문제] RIGHT OUTER JOIN을 이용해서 부서명과 부서가 위치한 도시, 나라명을 조회하시오
SELECT d.department_name ,  l.city , c.country_name
FROM hr.countries c 
RIGHT JOIN hr.locations l 
USING (country_id)
RIGHT OUTER JOIN departments d
USING (location_id);

-- Self Join
-- [문제] 사원번호, 이름, 상관의 사원번호, 상관의 이름을 조회 
-- 101 니나는 100 steven
-- 104 브루스 103 알렉산더

SELECT e1.employee_id AS '사원번호', e1.first_name AS '직원명', e1.manager_id AS '상관의 사원번호', e2.first_name AS '상관의 이름'
FROM employees e1 INNER JOIN  employees e2 						-- manager_id를 가진 테이블을 자식 테이블로 지정, e1이 자식(LEFT OUTER JOIN 써도 되느가?) 
																										-- e1 = 현재 조회하고 싶은 직원 / e2 = 그 직원의 상관을 불러오는 테이블
ON e1.manager_id = e2.employee_id;

-- [문제] 사원번호, 이름, 상관의 사원번호, 상관의 이름을 조회
-- steven king도 조회하시오

SELECT e1.employee_id AS '사원번호', e1.first_name AS '직원명', e1.manager_id AS '상관의 사원번호', e2.first_name AS '상관의 이름'
FROM employees e1 LEFT OUTER JOIN  employees e2 			-- OUTER 빼도 됨
ON e1.manager_id = e2.employee_id;

-- [연습문제] 
-- 1. JOIN을 이용하여 사원ID가 100번인 사원의 부서번호와 부서이름을 출력하시오
SELECT  e.employee_id, d.department_id, d.department_name
FROM employees e INNER JOIN departments d
USING (department_id)
WHERE e.employee_id = 100;

-- 2. INNER JOIN을 이용하여 사원이름과 함께 그 사원이 소속된 도시이름과 지역명을 출력하시오
SELECT e.first_name, l.city, r.region_name
FROM employees e, departments d, locations l, countries c, regions r
WHERE 
	e.department_id = d.department_id
	AND				
	d.location_id = l.location_id
	AND
	l.country_id = c.country_id
	AND 
	c.region_id = r.region_id;

-- 3. INNER JOIN과 USING 연산자를 사용하여 100번 부서에 속하는 직원명과 
--    직원의 담당 업무명, 속한 부서의 도시명을 출력하시오.
--   (100번 부서에는 직원 6명있음)
SELECT e.first_name,j. job_title, l.city
FROM
	employees e, departments d, jobs j, locations l
where
	e.department_id = 100
	AND
	e.job_id = j.job_id	
	AND
	e.department_id = d.department_id
	AND
	d.location_id = l.location_id;

-- 4. JOIN을 사용하여 커미션을 받는 모든 사원의 이름, 부서ID, 도시명을 출력하시오.
SELECT e.first_name, d.department_id, l.city
FROM employees e INNER JOIN departments d
ON e.department_id = d.department_id
INNER JOIN locations l
ON d.location_id = l.location_id
WHERE e.commission_pct IS NOT NULL;
 
-- ---------------------------------
-- 4.
SELECT 
	e.first_name, d.department_name, l.city
FROM
	employees e
    LEFT OUTER JOIN
	departments d
    ON d.department_id = d.department_id
	LEFT OUTER JOIN locations l
	ON d.location_id = l.location_id
WHERE
	e.commission_pct IS NOT NULL;
	

-- 5. INNER JOIN과 와일드카드를 사용하여 이름에 A가 포함된
-- 모든 사원의 이름과 부서명을 출력하시오(단, 대소문자 구분 없음)
SELECT first_name, department_name
FROM employees e INNER JOIN departments d
USING (department_id)
WHERE first_name LIKE '%a%';

-- ---------------------------------
-- 5.
SELECT e.first_name, d.department_name
FROM employees e INNER JOIN departments d
ON e.department_id = d.department_id
AND e.first_name LIKE '%A%';

-- 6. JOIN을 사용하여 Seattle에 근무하는 모든 사원의 이름, 업무, 부서번호 및  부서명을
--  출력하시오
SELECT e.first_name, j.job_title,  d.department_id, d.department_name
FROM employees e JOIN departments d
USING (department_id)
JOIN locations l
USING (location_id)
JOIN jobs j
USING (job_id)
WHERE l.city = 'Seattle';

-- ---------------------------------
-- 6.
SELECT e.first_name, j.job_title, e.department_id,  d.department_name, l.city
FROM employees e JOIN departments d
USING (department_id)
JOIN jobs j
USING (job_id)
JOIN locations l
USING (location_id)
WHERE l.city = 'Seattle';

-- 7. OUTER JOIN, SELF JOIN을 사용하여 관리자가 없는 사원을 포함한 모든 직원을 조회
-- (사원번호를 기준으로 내림차순 정렬)
SELECT *
FROM employees e1 LEFT OUTER JOIN  employees e2
ON e1.manager_id = e2.employee_id;

-- ---------------------------------
-- 7.
SELECT 
e1.employee_id, e1.first_name AS "직원명",
e1.manager_id, e2.first_name AS "매니저"
FROM employees e1 LEFT OUTER JOIN employees e2
ON e1.manager_id = e2.employee_id 
ORDER BY 1 DESC;

-- 8. SELF JOIN을 사용하여 관리자보다 먼저 입사한 모든 사원의 이름 및 입사일을
--  매니저 이름 및 입사일과 함께 출력하시오
SELECT
e1.first_name AS "직원명", e1.hire_date AS "직원입사일",
e2.first_name AS "매니저", e1.hire_date AS "관리자입사일"
FROM employees e1 LEFT OUTER JOIN employees e2
ON e1.manager_id = e2.employee_id 
AND e1.hire_date < e2.hire_date;
 

-- 9. Last name이 ‘King’을 Manager로 둔 사원의 이름과 급여를 조회하시오.
SELECT e1.first_name, e1.salary
FROM employees e1 LEFT OUTER JOIN employees e2
ON e1.manager_id = e2.employee_id
WHERE e2.last_name LIKE 'King'

 -- ---------------------------------
-- 9. 
SELECT e1.first_name, e1.salary
FROM employees e1 JOIN employees e2
ON e1.manager_id = e2.employee_id
WHERE e2.last_name = 'King';

SELECT * FROM employees
WHERE last_name = 'king';
 


-- 10. Finance부서의 사원에 대한 부서번호, 사원이름 및 담당 업무를 표시하시오
SELECT e.department_id, e.first_name, j.job_title
FROM employees e JOIN departments d
USING (department_id)
JOIN jobs j
USING (job_id)
WHERE d.department_name = 'Finance';


/*
 * view 만들기 
 * 
 */
DROP TABLE emp_view;
CREATE VIEW emp_view
AS
	SELECT e.first_name, d.department_name, e.job_id, e.salary
	FROM employees e INNER JOIN departments d
	USING (department_id)  -- 컬럼명이 동일할 때 사용
	ORDER BY 1;

-- VIEW 사용
SELECT * FROM emp_view;

/*
 *  함수(Function)
 *      - 단일행 함수 : 모든 레코드 각각에 함수를 적용시켜 결과를 얻는 함수
 * 								   조건을 where절에 부여         
 * 		- 그룹행 함수 : 레코드들을 특정 그룹으로 묶어서 처리한 후에 결과를 얻는 함수  ,
								  조건을 HAVING 절그룹에 부여할 때 주의해야 한다.
 * 
 */

-- 1. 문자열 함수​ 'Everybody loves the things you do'
SELECT ascii('A') , char(97) FROM dual; -- DUAL은 dummy 테이블

SELECT concat('Database', ' ','MySQL');

USE hr;
SELECT concat(first_name, ' ', last_name, '입니다.') AS "Full Name"FROM employees;

-- length(문자열)
SELECT length('Everybody loves the things you do') AS "글자수"

SELECT reverse ('Everybody loves the things you do');

SELECT repeat('*', 10);

SELECT locate('YOU', 'Everybody loves the things you do'); -- 대소문자 구분 X

SELECT locate ('you', 'I love you!')
SELECT INSERT('I love you!', 3, 4, 'miss'); -- 바꾸기 you를 me로
SELECT INSERT ('I love you', 8, 3, 'me')

-- 하나로 합치기
SELECT INSERT ('I love you', locate ('you', 'I love you!'), 3, 'me')

-- substirng (문자열, 위치, 개수)
SELECT substring('Everybody loves the things you do' , 11 , 4) AS "부분문자"; 

-- 대소문자 변환
SELECT upper('Everybody loves the things you do' ), lower('Everybody loves the things you do' );

-- 공백 자르기
SELECT length('  Everybody loves the things you do   '), LENGTH(trim('  Everybody loves the things you do   ')); -- 앞뒤 공백 자르기
SELECT length('  Everybody loves the things you do   '), 
			  LENGTH(trim('  Everybody loves the things you do   ')),
			  LENGTH(ltrim('  Everybody loves the things you do  ')),
			  LENGTH(rtrim('  Everybody loves the things you do   ')); 

SELECT trim(LEADING '~' FROM '~~~Everybody loves the things you do~~~~'),
			  trim(TRAILING  '~' FROM '~~~Everybody loves the things you do~~~~'),
              trim(BOTH '~' FROM '~~~Everybody loves the things you do~~~~');

-- [문제] employees, departments 테이블의 정보를 이용해서 아래와 같이 출력하시오
--			   부서가 없는 사람의 정보는 제외시킨다.
/*
 * steave는 Administration 부서에서 XXXX 일을 합니다. 
 */
SELECT concat(e.first_name, ' 의 부서는', ' ' , d.department_name, '입니다.') AS "사원정보"
FROM employees e INNER JOIN departments d
USING (department_id)
ORDER BY first_name;

SELECT concat(e.first_name, '는', ' ' , d.department_name, '부서에서 ', j.job_title ,' 일을 합니다.' ) AS "사원정보"
FROM employees e INNER JOIN departments d
USING (department_id)
JOIN jobs j
USING (job_id)
ORDER BY first_name;

-- 2. 수학 관련 함수
SELECT abs(-45.34), abs(45.34);

SELECT floor(-45.653), floor(45.653);  -- 음의 방향에서 만나는 첫번째 정수 값을 반환함

SELECT ceil(-45.653), ceil(45.653);   -- 양의 방향에서 만나는 첫번째 정수 값을 반환함

SELECT round(-45.653, 1), round(45.653, 1);
SELECT round(-45.653, 0), round(45.653, 0);
SELECT round(-45.653, -1), round(45.653, -1);

-- truncate : 절삭
SELECT truncate(-45.653, 1), truncate(45.653, 1);
SELECT truncate(-45.653, 0), truncate(45.653, 0);
SELECT truncate(-45.653, -1), truncate(45.653, -1);

-- 최대값, 최소값 구하기
SELECT greatest(2, 5, 8, 1), least(2, 5, 8, 1);

-- 파이
SELECT pi();

-- 제곱근
SELECT sqrt(81), pow(2.5, 3), power(2.5, 3);

-- (3) 날짜 / 시간 함수
SELECT now(), sysdate();

SELECT curdate(), curtime();

SELECT year(now()), month(now()), DAY(now());

SELECT hour(now()), minute(now()), second(now());

SELECT date(now()), time(now());

SELECT curdate(), curtime(), date(now()), time(now()); -- 같은 표현

-- datediff(미래날짜, 과거 날짜) : 경과일
SELECT DATEDIFF()('2025-05-30', '2001-11-05');

-- timediff(미래시간, 과거과거시간) : 경과시간
SELECT timediff(curtime(), '10:00:00');

-- [문제] 오늘부터 수료일(8.27)까지 며칠이 남았나요?
SELECT datediff('2025-08-27', curdate());
SELECT concat('오늘부터 수료일까지 ', datediff('2025-08-27', curdate()) , '일 남았습니다.');

-- dayofweek(), monthname(), dayofyear()
SELECT dayofweek(sysdate()), monthname(sysdate()), dayofyear(sysdate());

-- [문제] 경과일과 경과시간을 구하시오
-- 나는 태어난지 XX일 , 시간은 XX 시간이 지났다!
SELECT concat('나는 태어난지 ', datediff('2025-05-29', '2001-11-05'), ' 일, 시간은 ', timediff(now(), '2001-11-05 00:00:00') , ' 시간이 지났다!!') AS "경과일";
