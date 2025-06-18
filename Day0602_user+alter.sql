/* 6월 2일 사용자 생성 */

-- 사용자를 생성, 삭제, 권한 부여, 권한 회수는 root 권한을 가진 사용자만 가능함 

-- 1. 사용자 생성 (관리자 계정만 가능)
-- 새로운 사용자를 생성하면서 비밀번호를 설정
CREATE USER 'ogong'@'localhost' identified BY 'ogong';
CREATE USER 'newuser'@'localhost' identified BY 'newuser';

-- 2. 사용자 삭제
DROP USER 'ogong'@'localhost';
DROP USER 'newuser'@'localhost';

-- 3. 권한 수정
CREATE USER 'newuser'@'localhost' identified BY 'newuser';

-- 4. 권한 일부 부여
 -- newuser가 dima5.fitness테이블에 SELECT와 insert만 할 수 있음
GRANT SELECT, INSERT ON dima5.fitness TO 'newuser'@'localhost';

-- user 새롭게 재접속 
USE dima5;
SELECT * FROM fitness;
INSERT INTO fitness
(name, gender, height, weight)
VALUES
('손오공', '남', 20,178, 70)

COMMIT;

-- newuser는 이 명령을 사용할 수 없다. 권한이 없음
UPDATE fitness
SET bmi = 23.5
WHERE id = 3;

-- root로 재접속
SELECT user(); -- 현재 접속한 사용자 확인

-- 5. 전체 권한 부여 및 적용
-- newuser에게 dima5스키마의 fitness 테이블에 모든 권한을 부여
GRANT ALL PRIVILEGES ON dima5.fitness TO 'newuser'@'localhost' ;

flush PRIVILEGES;

-- 6. 부여된 권한 확인
SHOW grants FOR 'newuser'@'localhost';

-- 7. 새로운 유저를 다시 생성한 후 권한 확인
CREATE USER 'ogong'@'localhost' identified BY 'ogong';
SHOW grants FOR 'ogong'@'localhost';

-- 8. 권한 회수
REVOKE SELECT, INSERT ON dima5.fitness TO 'newuser'@'localhost';
SHOW grants FOR 'newuser'@'localhost' ;

--  9. 모든 권한 회수
REVOKE ALL PRIVILEGES ON dima5.fitness TO 'newuser'@'localhost' ;

-- 10. 사용자 삭제
DROP USER 'newuser'@'localhost' ;

-- 11. 모든 사용자의 정보(유저명, 호스트, 권한 등)를 전부 조회할 수 있음
SELECT * FROM mysql.USER;
GRANT ALL PRIVILEGES IN dima5.fitness TO 'ogong'@'localhost';

-- 12. gildong 유저를 생성하시오.
CREATE USER 'gildong'@'localhost';

-- 13. gildong 유저의 비번을 수정하시오
ALTER USER 'gildong'@'localhost' identified BY 'gildong';

-- 14. gildong에게 모든 권한을 부여하시오.
GRANT ALL PRIVILEGES ON hr.* TO 'gildong'@'localhost' ;

-- 15. gildong 으로 접속하시오

-- 16. 길동 유저를 삭제
DROP USER 'gildong'@'localhost' ;

-- -----------------------------------------------------alter 명령문
USE dima5;

-- 1) 테이블 삭제
DROP TABLE contract;
DROP TABLE customers;
DROP TABLE product;

-- 2) 고객의 정보를 저장하는 테이블
CREATE TABLE customer
(
	customer_id         char(3) 		   NOT NULL PRIMARY KEY 
	, customer_name varchar(50) NOT NULL
	, phone_number  varchar(30) NOT NULL
	, adress				  varchar(100) 
);

-- 3) product : 제품 정보를 저장하는 테이블
CREATE TABLE product
(
	product_id 		   char(5) 		  NOT NULL PRIMARY KEY 
	, product_name varchar(100) NOT NULL 
	, manufact_date datetime      DEFAULT CURRENT_TIMESTAMP
	, unit_price			int 				  DEFAULT 0
);

-- 4) contract : 계약 정보를 저장하는 테이블 (복합키 설정)
CREATE TABLE contract
(
	customer_id     char(3) 	   REFERENCES customer(customer_id)
	, product_id      char(5)     REFERENCES product(product_id)
	, contract_date datetime DEFAULT CURRENT_TIMESTAMP
	, count 			  int			   
		, CONSTRAINT contract_pk PRIMARY KEY (customer_id, product_id) -- 제약 조건 명 + 복합 키
);

-- alter 명령을 이용
-- 1) 테이블 이름 변경(rename to)
ALTER TABLE customer RENAME TO customers;

-- 2) 컬럼을 맨 뒤에 추가(add)
ALTER TABLE customers ADD email varchar(20);

-- 3) product 컬럼을 추가
ALTER TABLE product ADD product_grade char(1) CHECK (product_grade IN ('A', 'B', 'C')) AFTER manufact_date;

-- 4) 컬럼 삭제 (contract 테이블의 count - drop)
ALTER TABLE contract DROP count;

-- 5) 컬럼의 타입을 수정(modify: address 1-00 ->80)
ALTER TABLE customers MODIFY adress varchar(80);

-- 6) 컬럼의 타입을 다른 타입으로 수정(change)
ALTER TABLE customers CHANGE unit_price price decimal(10, 2);

-- review
/*
 *  정의어(DDL) - create, alter, drop
 *  조작어(DML) - insert, update, delete, select
 *  제어어(DCL) - commit, rollback, savepoint, grant, revoke
 */




