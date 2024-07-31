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
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
        }
    </style>
</head>
<body class="bg-gray-100 p-6">
    <div class="max-w-4xl mx-auto bg-white p-6 rounded-lg shadow-lg">
        <h1 class="text-2xl font-bold mb-6">글 상세</h1>
        <form action="updateBoard" method="post">
            <input name="seq" type="hidden" value="${board.seq}" />
            <div class="grid grid-cols-1 gap-4">
                <div class="grid grid-cols-4 gap-4 items-center">
                    <label for="title" class="col-span-1 font-semibold">제목</label>
                    <input type="text" id="title" name="title" value="${board.title}" class="col-span-3 border border-gray-300 p-2 rounded">
                </div>
                <div class="grid grid-cols-4 gap-4 items-center">
                    <label for="writer" class="col-span-1 font-semibold">작성자</label>
                    <input type="text" id="writer" name="writer" value="${board.writer}" class="col-span-3 border border-gray-300 p-2 rounded bg-gray-100" readonly>
                </div>
                <div class="grid grid-cols-4 gap-4 items-start">
                    <label for="content" class="col-span-1 font-semibold">내용</label>
                    <textarea id="content" name="content" rows="10" class="col-span-3 border border-gray-300 p-2 rounded">${board.content}</textarea>
                </div>
                <div class="grid grid-cols-4 gap-4 items-center">
                    <label for="regDate" class="col-span-1 font-semibold">등록일</label>
                    <input type="text" id="regDate" value="<fmt:formatDate pattern='yyyy/MM/dd HH:mm:ss' value='${board.regDate}'/>" class="col-span-3 border border-gray-300 p-2 rounded bg-gray-100" readonly>
                </div>
                <div class="grid grid-cols-4 gap-4 items-center">
                    <label for="cnt" class="col-span-1 font-semibold">조회수</label>
                    <input type="text" id="cnt" value="${board.cnt}" class="col-span-3 border border-gray-300 p-2 rounded bg-gray-100" readonly>
                </div>
                <div class="grid grid-cols-4 gap-4 items-center">
                    <button type="submit" class="col-span-4 bg-blue-500 text-white p-2 rounded hover:bg-blue-600">글 수정</button>
                </div>
            </div>
        </form>
        <div class="mt-6 flex justify-between">
            <a href="deleteBoard?seq=${board.seq}" class="bg-red-500 text-white p-2 rounded hover:bg-red-600">글삭제</a>
            <a href="getBoardList" class="bg-gray-200 text-black p-2 rounded hover:bg-gray-300">글목록</a>
        </div>
    </div>
</body>
</html>
