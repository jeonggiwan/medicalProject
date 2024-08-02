<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>    
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>글 상세</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap" rel="stylesheet">
	<link href="\CSS\getBoard.css" rel="stylesheet" type="text/css">

</head>
<body class="bg-gray-100 p-6">
    <div class="container">
        <h1 class="title">글 상세</h1>
        <form action="updateBoard" method="post">
            <input name="seq" type="hidden" value="${board.seq}" />
            <div class="form-grid">
                <div class="form-row">
                    <label for="title" class="form-label">제목</label>
                    <input type="text" id="title" name="title" value="${board.title}" class="form-input">
                </div>
                <div class="form-row">
                    <label for="writer" class="form-label">작성자</label>
                    <input type="text" id="writer" name="writer" value="${board.writer}" class="form-input form-input-readonly" readonly>
                </div>
                <div class="form-row">
                    <label for="content" class="form-label">내용</label>
                    <textarea id="content" name="content" rows="10" class="form-textarea">${board.content}</textarea>
                </div>
                <div class="form-row">
                    <label for="regDate" class="form-label">등록일</label>
                    <input type="text" id="regDate" value="<fmt:formatDate pattern='yyyy/MM/dd HH:mm:ss' value='${board.regDate}'/>" class="form-input form-input-readonly" readonly>
                </div>
                <div class="form-row">
                    <label for="cnt" class="form-label">조회수</label>
                    <input type="text" id="cnt" value="${board.cnt}" class="form-input form-input-readonly" readonly>
                </div>
                <div class="form-row">
                    <button type="submit" class="submit-button">글 수정</button>
                </div>
            </div>
        </form>
        <div class="button-container">
            <a href="deleteBoard?seq=${board.seq}" class="delete-button">글삭제</a>
            <a href="getBoardList" class="list-button">글목록</a>
        </div>
    </div>
</body>
</html>
