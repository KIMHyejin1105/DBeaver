-- 종합실습: 아이돌 관리 테이블 설계하기

/*
 * [문제]
 * 아이돌 그룹과 팬클럽, 그리고 그룹 소속사를 관리하는 데이터베이스를 설계하려고 한다.
 * 필요하다고 판단되는 모든 테이블과 컬럼을 ERD로 그리고, 코드 설계하시오. *
 * 조건) 'idol' 이라는 이름의 데이터베이스를 생성한 후 작업을 하시오
 * [ 필수 테이블 ] 소속사, 아이돌그룹, 아이돌 멤버, 팬클럽
 *
 * [ 옵션 ] 추가적으로 필요하다고 판단되는 테이블은 추가할 수 있다.
*/
CREATE DATABASE idol;

USE idol;

DROP TABLE agency;
DROP TABLE idol_group;
DROP TABLE idol_member;
DROP TABLE fanclub;


CREATE TABLE agency 
(
  agency_id 						INT 						AUTO_INCREMENT PRIMARY KEY
  ,agency_name 				VARCHAR(100)  NOT NULL
  ,ceo_name 					VARCHAR(50)
  ,founded_date 				DATE
  ,location 						VARCHAR(100)
);
CREATE TABLE idol_group
(
	group_id 				int					PRIMARY KEY  AUTO_INCREMENT
	, group_name 	varchar(20) 	NOT NULL
	, agency_id 			int 					REFERENCES agency(agency_id)
	, debut					date
);

CREATE TABLE idol_member
(
	member_id 		   int 				   		PRIMARY KEY AUTO_INCREMENT
	,member_name  varchar(20)	   	NOT NULL
	, birthday				date					
	, m_position			varchar(50)		
	, group_id			int						REFERENCES idol_group(group_id)
);

CREATE TABLE fanclub
( 
	fanclub_id			int 					NOT NULL PRIMARY KEY AUTO_INCREMENT
	, fanclub_name 	varchar(100)	NOT NULL
	, join_fanclub		datetime 		DEFAULT CURRENT_TIMESTAMP
	, group_id 			int 					REFERENCES idol_group(group_id)
);

-- 테이블에 데이터 넣기 -----------------------------------------------------------------------------------------------------------------------------
INSERT INTO agency (agency_name, ceo_name, founded_date, location) VALUES ('SM Ent', '이수만' , '1997-12-04', '서울시 성동구');
INSERT INTO agency (agency_name, ceo_name, founded_date, location) VALUES ('YG Ent', '양현석' , '1998-11-08', '서울시 마포구');
INSERT INTO agency (agency_name, ceo_name, founded_date, location) VALUES ('HYBE Ent', '방시혁' , '2005-01-24', '서울시 용산구');
SELECT * FROM agency;

INSERT INTO idol_group (group_name, agency_id, debut)  VALUES ('라이즈', 1, '2022-11-13');
INSERT INTO idol_group (group_name, agency_id, debut)  VALUES ('트레저', 2, '2020-05-13');
INSERT INTO idol_group (group_name, agency_id, debut)  VALUES ('아일릿', 3, '2013-06-13');
SELECT * FROM idol_group;

INSERT INTO idol_member (member_name, birthday, m_position, group_id) VALUES ('성찬', '2001-09-04', '댄서', 1);
INSERT INTO idol_member (member_name, birthday, m_position, group_id) VALUES ('은석', '2002-03-11', '래퍼', 1);
INSERT INTO idol_member (member_name, birthday, m_position, group_id) VALUES ('원빈', '2000-04-21', '댄서', 1);

INSERT INTO idol_member (member_name, birthday, m_position, group_id) VALUES ('아사히', '2001-08-20', '보컬', 2);
INSERT INTO idol_member (member_name, birthday, m_position, group_id) VALUES ('준규', '2000-09-09', '리더', 2);
INSERT INTO idol_member (member_name, birthday, m_position, group_id) VALUES ('지훈', '2000-03-19', '메인보컬', 2);

INSERT INTO idol_member (member_name, birthday, m_position, group_id) VALUES ('원희', '2006-06-26', '메인보컬', 3);
INSERT INTO idol_member (member_name, birthday, m_position, group_id) VALUES ('모카', '2005-07-17', '리더', 3);
INSERT INTO idol_member (member_name, birthday, m_position, group_id) VALUES ('민주', '2001-05-22', '댄서', 3);
SELECT * FROM idol_member;

INSERT INTO fanclub (fanclub_name, group_id) VALUES ('브리즈', 1);
INSERT INTO fanclub (fanclub_name, group_id) VALUES ('트레저메이커', 2);
INSERT INTO fanclub (fanclub_name, group_id) VALUES ('글릿', 3);
SELECT * FROM fanclub;

-- FK 설정 ------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE idol_group ADD CONSTRAINT fk_group_agency
FOREIGN KEY (agency_id) REFERENCES agency(agency_id);

ALTER TABLE idol_member ADD CONSTRAINT fk_member_group
FOREIGN KEY (group_id) REFERENCES idol_group(group_id);

ALTER TABLE fanclub ADD CONSTRAINT fk_fanclub_group
FOREIGN KEY (group_id) REFERENCES idol_group(group_id);
