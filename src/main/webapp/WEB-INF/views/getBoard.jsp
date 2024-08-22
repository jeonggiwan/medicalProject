<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>    


    <div class="container">
        <div class="main-content">
            <div class="content">
                <h1 class="search-title">글 상세</h1>
                <form action="updateBoard" method="post">
                    <input name="seq" type="hidden" value="${board.seq}" />
                    <div class="search-section">
                        <div class="search-inputs">
                            <label for="title" class="search-title">제목</label>
                            <input type="text" id="title" name="title" value="${board.title}" class="search-input">
                        </div>
                        <div class="search-inputs">
                            <label for="writer" class="search-title">작성자</label>
                            <input type="text" id="writer" name="writer" value="${board.writer}" class="search-input" readonly>
                        </div>
                        <div class="search-inputs">
                            <label for="content" class="search-title">내용</label>
                            <textarea id="content" name="content" rows="10" class="search-input">${board.content}</textarea>
                        </div>
                        <div class="search-inputs">
                            <label for="regDate" class="search-title">등록일</label>
                            <input type="text" id="regDate" value="<fmt:formatDate pattern='yyyy/MM/dd HH:mm:ss' value='${board.regDate}'/>" class="search-input" readonly>
                        </div>
                        <div class="search-inputs">
                            <label for="cnt" class="search-title">조회수</label>
                            <input type="text" id="cnt" value="${board.cnt}" class="search-input" readonly>
                        </div>
                        <div class="search-buttons">
                            <button type="submit" class="search-button search-button-blue">글 수정</button>
                        </div>
                    </div>
                </form>
                <div class="search-buttons">
                    <a href="deleteBoard?seq=${board.seq}" class="search-button search-button-red">글삭제</a>
                    <a href="getBoardList" class="search-button">글목록</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
