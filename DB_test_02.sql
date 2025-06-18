USE dima5;

-- 테이블 삭제
DROP TABLE comment;
DROP TABLE bbs;
DROP TABLE userinfo;

CREATE TABLE userinfo
(
	id 				varchar(20) NOT NULL PRIMARY KEY
	, name 		varchar(20) NOT NULL
	, password 	varchar(20) NOT NULL
);

CREATE TABLE bbs
(
	bbs_num 			int 						PRIMARY KEY AUTO_INCREMENT
	, id 						varchar(20) 		NOT NULL
	, title 					varchar(20)
	, bbs_text 			varchar(2000)
	, regdate 				datetime 			DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE comment
(
	comment_num 			int 								PRIMARY KEY AUTO_INCREMENT
	, bbs_num					int 								REFERENCES bbs(bbs_num) ON DELETE CASCADE -- 같이 지우기 위해서 ON DELETE CASCADE
	, id 								varchar(20)				
	, comment_text 			varchar(200)				NOT NULL
	, regdate 						datetime 					DEFAULT CURRENT_TIMESTAMP
);

-- 2. 테스트 데이터의 입력
INSERT INTO USERINFO VALUES ('AAA', '홍길동', '1234');
INSERT INTO USERINFO VALUES ('BBB', '박찬호', '5678');
SELECT * FROM userinfo;

INSERT INTO BBS (ID, TITLE, BBS_TEXT) VALUES ('AAA', '글제목1', '글내용11');
INSERT INTO BBS (ID, TITLE, BBS_TEXT) VALUES ('AAA', '글제목2', '글내용22');
INSERT INTO BBS (ID, TITLE, BBS_TEXT) VALUES ('BBB', '글제목3', '글내용33');
SELECT * FROM BBS;

INSERT INTO COMMENT (BBS_NUM, ID, comment_text) VALUES (1, 'AAA', '리플내용');
INSERT INTO COMMENT (BBS_NUM, ID, comment_text) VALUES (1, 'BBB', '리플내용');
INSERT INTO COMMENT (BBS_NUM, ID, comment_text) VALUES (1, 'BBB', '리플내용');
INSERT INTO COMMENT (BBS_NUM, ID, comment_text) VALUES (2, 'AAA', '리플내용');
INSERT INTO COMMENT (BBS_NUM, ID, comment_text) VALUES (2, 'BBB', '리플내용');
SELECT * FROM COMMENT;

COMMIT;
-- 1. 게시판의 글번호와 작성자의 ID, 이름 그리고 글제목을 다음과 같이 출력하시오
-- join 방식
SELECT b.bbs_num AS "글번호"
			  , concat(concat( u.id, ' (' ), concat(u.name, ')')) AS "작성자"
			  , b.title AS "제목"
FROM bbs b INNER JOIN userinfo u 
USING (id);

-- 1) join 교수님 방식
SELECT bbs_num AS 글번호, 
			concat(B.id, ' (' , u.name, ')') 작성자, title AS 제목
FROM userinfo u, bbs b 
WHERE u.id= b.id;

-- 서브쿼리 방식
SELECT b.bbs_num AS "글번호",
			  concat(b.id, ' (',
			  (SELECT name FROM userinfo u WHERE u.id = b.id), ')') AS "작성자"
			  , b.title AS "제목"					
FROM bbs b;

-- 1) 서브쿼리 교수님 방식
SELECT bbs_num 글번호, 
			  concat(Id, ' (' , (SELECT name FROM userinfo WHERE bbs.id = userinfo.id), ')') 작성자,
			  title 제목
FROM bbs;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2. 1번 글에 달린 리플 목록을 다음과 같이 출력하시오.
SELECT c .bbs_num AS "BNUM" , c.id, u.name, c.comment_text
FROM comment c JOIN userinfo u
USING (id)
WHERE c.bbs_num = 1;

-- 2) 교수님 풀이
SELECT r.bbs_num, r.id, name, comment_text
FROM comment r, userinfo u
WHERE r.id = u.id AND r.bbs_num = 1;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3. 모든 글과 모든 리플 정보를 다음과 같은 형식으로 출력한다.
SELECT b.bbs_num AS "본문글번호"
			  ,u.name AS "본문작성자"
			  ,c.comment_num AS "리플번호"
              ,uc.name AS "리플작성자"
FROM bbs b JOIN userinfo u
ON b.id = u.id
JOIN comment c
ON b.bbs_num = c.bbs_num
JOIN userinfo uc 
ON c.id = uc.id;

-- 3) 교수님 풀이
SELECT b.bbs_num 본문글번호 , u.name 본문작성자, r.comment_num 리플번호, u2.name 리플작성자
FROM userinfo u, userinfo u2, bbs b, comment r
WHERE b.bbs_num = r.bbs_num AND u.id = b.id AND u2.id = r.id
ORDER BY b.bbs_num, r.comment_num;

-- 4) 각 보문에 ㄷ글에 달ㅇ리플의 개수를 다음과 같이 출력하시오
SELECT b.bbs_num 본문글번호, count(*) 리플개수
from bbs b, comment r
WHERE b.bbs_num = r.bbs_num
GROUP BY b.bbs_num;






