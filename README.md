1. 스프링 시큐리티 설정 사용(로그인이 안되있다면 index.jsp, login.jsp를 제외한 페이지 접근 불가능
2. Bcypte로 비밀번호 암호화
<<<<<<< Updated upstream
=======


2024/08/06 추가본 로그인 시도 시 loginController bean 어쩌구 에러가 뜨면: JwtSecretGenerator를 실행하면 뜨는 긴 코드를 복사해서 cmd 창을 열고 set JWT_SECRET = 붙여넣기 하면 됨 그리고 환경변수 확인해서 ~에 대한 사용자 변수 창에 아까 복붙한 값 나오면 일단 환경변수 설정 완료

이제 이 값을 SPRING 프로젝트로 가져오는데 아무 문제 없으면 서버 실행했을 때 제대로 로그인 화면이 뜸 만약 서버 실행하는 데 에러 뜨면 상단 바에서 PROJECT > CLEAN 한 후 프로젝트 이름에서 우클릭하고 MAVEN > UPDATE PROJECT 하면 됨

로그인 화면이 뜨면 아이디 비밀번호 입력하는 곳에 아이디 비밀번호 입력하면 됨 이 때 비밀번호는 PasswordGenerator에 들어가서 생성하면 되는데 rawPassword에 내가 직접 입력할 값을 넣고 encodedPassword에 인코딩된 비밀번호 값이 나옴 이 때 나온 값을 복사해서 db에 붙여 넣으면 됨

db에 테이블 만들고 아이디, 비밀번호를 넣고 돌리면 일단은 연동하는 데 까지 문제는 없을 것 같음 모든 토큰이 무사히 다 만들어지고 로그인이 완료되면 메인 화면이 보임

공지사항 게시판 sql

-- 기존 BOARD 테이블 (변경 없음)
CREATE TABLE BOARD (
    seq INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    writer VARCHAR(100) NOT NULL,
    content TEXT,
    regDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    cnt INT DEFAULT 0,
    searchCondition VARCHAR(100),
    searchKeyword VARCHAR(255),
    uploadFile VARCHAR(255)
);

-- 사용자별 공지사항 읽음 상태를 저장할 새 테이블
CREATE TABLE USER_BOARD_READ (
    userId INT,
    boardSeq INT,
    readDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (userId, boardSeq),
    FOREIGN KEY (boardSeq) REFERENCES BOARD(seq)
);
>>>>>>> Stashed changes

2024/08/06 추가본 로그인 시도 시 loginController bean 어쩌구 에러가 뜨면: JwtSecretGenerator를 실행하면 뜨는 긴 코드를 복사해서 cmd 창을 열고 set JWT_SECRET = 붙여넣기 하면 됨 그리고 환경변수 확인해서 ~에 대한 사용자 변수 창에 아까 복붙한 값 나오면 일단 환경변수 설정 완료

이제 이 값을 SPRING 프로젝트로 가져오는데 아무 문제 없으면 서버 실행했을 때 제대로 로그인 화면이 뜸 만약 서버 실행하는 데 에러 뜨면 상단 바에서 PROJECT > CLEAN 한 후 프로젝트 이름에서 우클릭하고 MAVEN > UPDATE PROJECT 하면 됨

로그인 화면이 뜨면 아이디 비밀번호 입력하는 곳에 아이디 비밀번호 입력하면 됨 이 때 비밀번호는 PasswordGenerator에 들어가서 생성하면 되는데 rawPassword에 내가 직접 입력할 값을 넣고 encodedPassword에 인코딩된 비밀번호 값이 나옴 이 때 나온 값을 복사해서 db에 붙여 넣으면 됨

db에 테이블 만들고 아이디, 비밀번호를 넣고 돌리면 일단은 연동하는 데 까지 문제는 없을 것 같음 모든 토큰이 무사히 다 만들어지고 로그인이 완료되면 메인 화면이 보임
