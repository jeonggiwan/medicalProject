<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>글 등록</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap" rel="stylesheet">
    <link href="\CSS\insertBoardPage.css" rel="stylesheet" type="text/css">
</head>
<body class="bg-gray-100 p-6">
    <div class="container">
        <h1 class="title">글 등록</h1>
<<<<<<< HEAD
        <form action="insertBoard" method="post" name="board">
=======

        <form action="insertBoard" method="post" name="board">

>>>>>>> 9e04bc8d9092f5fbebf37e94c2de150ac72b7e11
            <div class="form-group">
                <label for="title" class="form-label">제목</label>
                <input type="text" id="title" name="title" class="form-input">
            </div>
            <div class="form-group">
                <label for="writer" class="form-label">작성자</label>
                <input type="text" id="writer" name="writer" class="form-input">
            </div>
            <div class="form-group">
                <label for="content" class="form-label">내용</label>
                <textarea id="content" name="content" rows="6" class="form-textarea"></textarea>
            </div>

            <div class="form-group">
                <button type="submit" class="submit-button">새글 등록</button>
            </div>
        </form>
        <div class="mt-4">
            <a href="getBoardList" class="list-link">글 목록 가기</a>
        </div>
    </div>
</body>
</html>