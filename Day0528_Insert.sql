-- 2025년 5월 27일(Insert, Create, Select)
/*

** 연산자
1) 비교 연산자  : > | < | >= | <= | = | != ( <>)
2) 논리 연산자 : and, or, not
						   	컬럼명 BETWEEN A AND B
						   	컬럼 IN (값1, 값2,  ...)					
 3) NULL 연산자 : 컬럼 IS NULL, 컬럼 IS NOT NULL
 4) LIKE 연산자 :  % _(문자열 내에 포함된 특별한 문자값을 찾아서 조회)
     % : 0개 이상의 글자를 의미
     _ : _ 한 개 당 글자 하나를 의미 함
5) 산술 연산자 : + - * /  % 
6) LIMIT 연산자 : 조회된 결과의 일부만 재추출해서 조회할 때

	LIMIT 개수 : 조회된 결과의 앞에서 N개 민큼 조회
	LIMIT n1 , n2 : n1개를 건너뛰고 n2개를 조회 
*/
USE hr;
SHOW tables;

-- [연습1] 커미션을 받는 직원의 이름, 부서번호, 급여, 커미션 비율
SELECT first_name, department_id, salary, commission_pct FROM employees
WHERE commission_pct IS NOT NULL;

-- [연습2] 커미션을 받는 직원의 이름, 부서번호, 급여, 커미션 비율을 값으로 조회하시오 
-- 특수 문자로 컬럼명 지정할 때에는 큰 따옴표 사용
SELECT first_name, department_id, salary, salary * commission_pct AS 커미션
FROM employees
WHERE commission_pct IS NOT NULL;

-- [연습3] 커미션을 받는 직원의 이름, 부서번호, 급여, 커미션 비율을 값으로 조회하시오
SELECT first_name, department_id, salary, salary * commission_pct AS 커미션, salary + (commission_pct * salary) AS "총 수령액" 
FROM employees
WHERE commission_pct IS NOT NULL;

-- [연습4] 위 코드 3번에서 총 수령액이 15000이상인 사람만 조회하시오
SELECT first_name, department_id, salary, salary * commission_pct AS 커미션, salary + (commission_pct * salary) AS "총 수령액" 
FROM employees
WHERE commission_pct IS NOT NULL AND salary + (commission_pct * salary) >= 15000;

-- 직원의 이름과 입사연도를 조회
SELECT first_name, hire_date
FROM employees;

-- 2007년 이전에 입사한 직원의 이름과 입사연도를 조회
-- 날짜 타입은 비교연산, Like
SELECT first_name, hire_date
FROM employees
WHERE hire_date < '2007-01-01' -- 날짜를 문자열 처리
ORDER BY hire_date;

-- [연습] 연도와 상관없이 1월에 입사한 직원의 이름, 입사일, 급여를 조회
SELECT first_name, hire_date, salary
FROM employees
WHERE hire_date LIKE '_____01___' -- '_____01%' 이렇게 써도 됨
ORDER BY hire_date;

-- [연습] 2007년도에 입사한 직원의 이름, 입사일, 급여를 조회
SELECT first_name, hire_date, salary
FROM employees
WHERE hire_date LIKE '2007%' 
ORDER BY hire_date;

/* LIMIT : 출력되는 레코드의 개수를 제한할 때 */
-- 조회된 전체 결과의 앞에서 10개만 출력
SELECT first_name, hire_date, salary
FROM employees
LIMIT 10;

-- 전체 조회된 결과에서 10개를 건너 뛰고 11번째부터 5개만 출력
SELECT first_name, hire_date, salary
FROM employees
LIMIT 10, 5;

-- [연습] 직원의 이름, 입사일, 급여를 급여 순으로 내림차순 후 상단 15개 조회
SELECT first_name, hire_date, salary
FROM employees
ORDER BY salary DESC
LIMIT 15;

-- 10을 3으로 나눈 나머지 값을 조회하시오 			10%3
SELECT 10 % 3 
FROM DUAL; -- 더미테이블

-- ----------------------------------------------------------------------------------------
/* SQL 명령어의 종류
 *    1) DDL  :  create, alter, drop
 *    2) DML :  select, update, delete, insert
 *    3) TQL   :  commit, rollback, savepoint
 *    4) DCL  : grant, revoke
 * 
 * 
 */

-- 테이블 생성하기 : CREATE
/*
 * CREATE TABLE 테이블명
 * ( 
 * 		컬럼명 타입 [제약조건] ,             -- 제약조건 :  PK, FK, NOT NULL, CHECK(CK), UQ(UNIQUE), [DEFALUT]
 * 		컬럼명 타입,
 * 		컬럼명 타입
 * );
 */
-- IF NOT EXISTS : 없을 때만 스키마 생성
CREATE DATABASE IF NOT EXISTS `dima5` DEFAULT CHARACTER SET UTF8MB3;
USE dima5;
SELECT DATABASE(); -- 무슨 데이터베이스를  쓰고 있는 지 확인하는 코드
/*
 데이터 타입 : 
 		1) 수치(정수, 실수) 								: decimal(, 2) , integer, float
 		2) 문자열(고정길이형), 가변길이형    : char(10), varchar(10)
 				'korea'   ---> char(10)      --> 'korea     '
 				'korea'   ---> varchar(10) --> 'korea'
 		3) 날짜 타입                                           : date
 */
USE dima5
DROP TABLE IF EXISTS mytable;
CREATE TABLE IF NOT EXISTS mytable
(
	id integer PRIMARY KEY, 
	name varchar(20)	
);

SELECT * FROM mytable; 

-- 레코드 넣는 코드
INSERT INTO dima5.mytable 
(id, name)
 VALUES
 (1, '김홍도');

INSERT INTO dima5.mytable 
(id, name)
 VALUES
 (2, '신윤복');

-- 모든 컬럼에 데이터를 전부 넣을 때 values 앞 괄호를 생략 가능
INSERT INTO dima5.mytable 
 VALUES
 (2, '신윤복');


-- 새로운 테이블 생성
CREATE TABLE IF NOT EXISTS  mytable2
(
	id int PRIMARY KEY AUTO_INCREMENT, -- 아이디에 해당하는 값은 자동 증가됨
	name varchar(20) NOT NULL,
	phone varchar(20) UNIQUE, -- 동일 값 넣으면 안됨
	age int DEFAULT 20, -- 값을 넣지 않으면 20으로 자동 대입
	gender char(1) CHECK (gender IN ('M', 'F'))
);

-- 데이터 삽입하기
INSERT INTO mytable2
(name, phone, age, gender)
VALUES
('전우치', '1234', '29', 'M');

INSERT INTO mytable2
(name, phone, gender)
VALUES
('손오공', '1235', 'M');

SELECT * FROM mytable2;

-- -------------------------------------------------------------
USE dima5;

SHOW DATABASE;
SHOW tables;

DESC mytable2;

--  ----------------   컬럼 레벨의 제약조건과 테이블레벨의 제약조건
DROP TABLE IF EXISTS mytable3;
CREATE TABLE IF NOT EXISTS  mytable3
(
	id int AUTO_INCREMENT, 
	name varchar(20) NOT NULL,  -- nn은 테이블 레벨 제약 조건을 줄 수 없다.
	phone varchar(20) UNIQUE, 
	age int DEFAULT 20, 
	gender char(1) 
	,PRIMARY KEY(id)
	,UNIQUE (phone)
	,CHECK (gender IN ('M', 'F')),
);

--  제약 조건명 지정하기 (테이블명_컬럼명_제약조건)
CREATE TABLE  mytable4
(
	id int  PRIMARY KEY AUTO_INCREMENT, -- 아이디에 해당하는 값은 자동 증가됨
	name varchar(20) NOT NULL,
	phone varchar(20) CONSTRAINT mytable4_phone_uq UNIQUE, -- 동일 값 넣으면 안됨
	age int DEFAULT 20, -- 값을 넣지 않으면 20으로 자동 대입
	gender char(1) CONSTRAINT mytable4_gender_ck CHECK (gender IN ('M', 'F'))
);

USE dima5;
DROP TABLE mytable5;
CREATE TABLE mytable5 
(
  id int AUTO_INCREMENT,
  name varchar(20) NOT NULL,
  phone varchar(20) UNIQUE,
  age int DEFAULT 20,
  gender char(1)
  , CONSTRAINT mytable5_id_pk PRIMARY KEY (id)
  , CONSTRAINT mytable5_phone_uq UNIQUE  (phone)
  , CONSTRAINT mytable5_gender_ck CHECK (gender IN ('M', 'F'))
  );

-- [연습] 제약 조건은 테이블 레벨로 만드시오. 제약조건명은 임의로
/*
 *  피트니스 회원의 정보를 저장하는 테이블을 생성하시오
 * 테이블명 : fitness
 * id : 자동증가, 정수 + 자동정렬 pk
 * gender : 성별, 문자 1개 체크, '남', '여' (IN)
 * height : 키 숫자형(5, 2) + ck 150 ~ 200 between 150 and 200
 * weight : 몸무게 숫자형(5, 2)
 * std_weight : 표준체중 숫자형(5, 2)
 * bmi :숫자형(4, 2)
 * bmi_result :가변길이 문자열(30)
 * 
 */
USE dima5;
CREATE TABLE dima5.fitness
(
	id int AUTO_INCREMENT,
	name varchar(20) NOT NULL,
	gender char(1),
	height decimal(5, 2),
	weight decimal(5, 2),
	std_weight decimal(5, 2),
	bmi decimal(4, 2),
	bmi_result varchar(30)
	, CONSTRAINT fitness_id_pk PRIMARY KEY (id)
	, CONSTRAINT fitness_gender_ck CHECK (gender IN ('남', '여'))
	, CONSTRAINT fitness_height_ck CHECK (height BETWEEN 150 AND 200)
);

SHOW DATABASES;
USE information_schema;
SHOW tables;

SELECT table_name FROM table_constraints;

USE dima5;

-- 다음 회원의 정보를 입력하시오
/*
 * 사오정, 남, 175.05, 65,  bmi 값을 계산해서 넣으시오
*/
INSERT INTO dima5.fitness
(name, gender,height,weight, bmi )
VALUES
('사오정', '남', 175.05, 65 , 65 /  ((175.05 / 100)*(175.05 / 100)));   -- weight / (height * height * 0.0001)
COMMIT;

SELECT * FROM dima5.fitness;

INSERT INTO dima5.fitness
(name, gender,height,weight, bmi )
VALUES
('장원영', '여', 171, 45 , weight / (height * height * 0.0001));   -- weight / (height * height * 0.0001)
COMMIT;

-- 날짜 데이터 다루기
USE dima5;
SELECT * FROM dima5.fitness

DROP TABLE IF EXISTS mytable6;
CREATE TABLE IF NOT EXISTS mytable6
(
	userid int PRIMARY KEY AUTO_INCREMENT,
	username varchar(20) NOT NULL,
	birthday date,
	join_date datetime DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO mytable6
(username, birthday)
VALUES
('삼장법사', '1980-01-01');

SELECT * FROM mytable6

-- 3명의 정보를 더 넣으시오
INSERT INTO mytable6
(username, birthday, join_date)
VALUES
('사오정', '1991-12-05', '2021-10-01');

INSERT INTO mytable6
(username, join_date)
VALUES
('저팔계', '2024-05-30');

INSERT INTO mytable6
(username, birthday)
VALUES
('손오공', '2000-12-31');

COMMIT;

-- 저팔계 생일 추가
UPDATE mytable6
SET birthday = '2025-01-01'
WHERE userid = 3;

-- 삼장법사 지우기
DELETE FROM mytable6
WHERE userid = 5;

SELECT * FROM mytable6

ROLLBACK;

/* 둘 이상의 테이블 관계 설정하기
* PK(부모), FK(자식)
* 자바의 부모 / 자식간의 관계와는 다르다!!
* 
* 부모 테이블의PK, UQ --> 자식 테이블에서 참조
* 생성은 부모 --> 자식테이블을 생성
* 삭제는 자식 --> 부모 테이블을 삭제
* 
* 부모 테이블의 특정 레코드를 삭제하면 자식에서 오류발생
* ----> 자식 테이블을 생성할 때 on delete cascade를 설정한다. -> 자식 테이블도 같이 삭제됨
* 
* 부모 테이블의 특정 레코드의 PK를 삭제하면 자식에서 오류발생
* ----> 자식 테이블을 생성할 때 on delete cascade를 설정한다. -> 자식 테이블도 같이 삭제됨
*/

USE dima5;
-- 학생의 신상정보를 넣기 위한 것임
CREATE TABLE parent1
(
	id int AUTO_INCREMENT
	, name varchar(30) NOT NULL
	, phone varchar(20) UNIQUE
	, age decimal(3) DEFAULT 20
		, CONSTRAINT parent_id_pk PRIMARY KEY(id)
);
-- 학생의 학과 정보
DROP TABLE child1;
CREATE TABLE child1
(
	cid int AUTO_INCREMENT
	, id int  -- 타입 유지 필요
	, major varchar(30) NOT NULL
	, grade decimal(2)
		, CONSTRAINT child1_cid_pk PRIMARY KEY(cid)
		, CONSTRAINT child1_id_fk FOREIGN KEY (id) REFERENCES parent1(id) ON DELETE CASCADE  ON UPDATE CASCADE-- 어떤 테이블을 참조하냐면?
);


-- 데이터 삽입하기(부모)
INSERT INTO parent1(name, phone) VALUES ('이몽룡', '1234');
INSERT INTO parent1(name, phone) VALUES ('성춘향', '1212');
INSERT INTO parent1(name, phone) VALUES ('심청이', '0012');
INSERT INTO parent1(name, phone) VALUES ('뺑덕이', '5544');

SELECT * FROM parent1;

-- 자식테이블에 데이터 삽입하기
INSERT INTO child1(id, major, grade) VALUES (1, '컴퓨터 공학', 4);
INSERT INTO child1(id, major, grade) VALUES (2, '한국학', 3);
INSERT INTO child1(id, major, grade) VALUES (3, '영어1 영문학', 1);
INSERT INTO child1(id, major, grade) VALUES (5, '응용미술학과', 4);

SELECT * FROM child1;

COMMIT;

-- 1. 몽룡이의 id를 7번으로 수정하고 자식 테이블에서 수정되었는지 확인하시오
UPDATE dima5.parent1
SET id = 7
WHERE id =5;

-- 2. 뺑덕이 정보를 삭제하고 자식테이블에서 삭제되었는지 확인
DELETE  FROM  dima5.parent1
WHERE id = 1;



