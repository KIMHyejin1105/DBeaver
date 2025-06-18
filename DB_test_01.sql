USE hr;

-- 1. 보너스(급여 + 커미션 비율)을 계산하여 사원번호, 이름, 급여, 커미션 비율, 보너스 금액을 사원 번호 순으로 출력한다.
-- 해당 사항 없는 영업부 이외의 사원은 0으로 처리한다. 
SELECT employee_id, first_name, salary, commission_pct, 
CASE WHEN commission_pct IS NULL THEN 0 ELSE salary * commission_pct END AS bonus
FROM employees
ORDER BY employee_id;

-- 교수님 풀이
SELECT employee_id, FIRST_name, last_name, salary, commission_pct, salary * IFnull(commission_pct, 0) 
FROM employees
ORDER BY employee_id;

-- 2. 모든 사원들의 이름과 소속 부서명을 다음과 같이 출력하시오. (subquery 사용)
SELECT e.first_name, (SELECT d.department_name
									 FROM departments d
									 WHERE d.department_id = e.department_id) AS department_name
FROM employees e;

-- 교수님 풀이
SELECT concat(first_name, ' ', last_name) AS '이름'
, (SELECT department_name FROM  departments d WHERE d.department_id = e.department_id) AS "부서"
FROM employees e;

-- 3)
SELECT c. country_name AS "국가명", 
(SELECT r.region_name from regions r WHERE r.region_id = c.region_id) AS "지역명"
FROM countries c;

-- 4. 
SELECT * FROM employees WHERE hire_date >= '2007-11-1' AND hire_date < '2008-2-11';

-- 5.
SELECT * FROM employees WHERE commission_PCT IS NOT NULL AND salary >= 10000;

-- 6.
SELECT * FROM employees
WHERE department_id in(50, 80, 100)
AND salary between 7000 AND 8000;

-- 7.
-- join
SELECT region_name, country_name
FROM regions, countries 
WHERE regions.region_id = countries.region_id
ORDER BY region_name, country_name;

-- subquery
SELECT 
		(SELECT region_name FROM regions 
		WHERE regions.region_ID = countries.region_id) region_name,
		country_name
FROM countries
ORDER BY region_name, country_name;

-- 8.
SELECT region_name 지역, count(*) 국가수
FROM regions r INNER JOIN countries c
ON r.region_ID = c.region_id
GROUP BY region_name
ORDER BY region_name

-- 9.
SELECT city, country_name, region_name
FROM locations l JOIN countries c
ON l.country_ID = c. country_id
JOIN regions r
ON c.region_id = c.region_id
ORDER BY city;

-- 10.
SELECT c.country_name, count(*)
FROM departments d join locations l
ON d.location_id = l.location_id
JOIN countries c
ON l.country_id = c.country_id
GROUP BY c.country_name;

-- 11. 
SELECT l.city, count(*)
FROM employees e JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON d.location_id = L.location_id
GROUP BY l.city
ORDER BY l.city;

-- 12.
SELECT l.city, avg(salary)
FROM employees e JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON d.location_id = L.location_id
GROUP BY l.city
ORDER BY l.city;

-- 13. 
SELECT d.department_name "부서명", count(*) "사원수", avg(salary) "평균 급여"
FROM employees e JOIN departments d
ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING  count(*) >= 3;

-- 14.
SELECT employee_id "사번", first_name "이름", last_name "성", 
              (SELECT e2.last_name
              FROM employees e2
              WHERE e1.manager_id = e2.employee_id) as"관리자"
FROM employees e1
ORDER BY 4;

