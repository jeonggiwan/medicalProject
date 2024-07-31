<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"  %>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>문의 게시판</title>
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
        <h1 class="text-2xl font-bold mb-4">문의 게시판</h1>
        
        <!-- 검색 시작 -->
        <form action="getBoardList" method="post" class="flex items-center mb-4">
            <div class="ml-auto relative flex items-center">
                <select name="searchCondition" class="px-4 py-2 border rounded">
                    <option value="TITLE">제목</option>
                    <option value="CONTENT">내용</option>
                </select>
                <input name="searchKeyword" type="text" placeholder="Search" class="px-4 py-2 border rounded pl-10 ml-2">
                <svg class="w-5 h-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-4.35-4.35m0 0A7.5 7.5 0 1116.65 16.65z"></path>
                </svg>
                <button type="submit" class="ml-2 px-4 py-2 text-blue-500 border border-blue-500 rounded">검색</button>
            </div>
        </form>
        <!-- 검색 종료 -->
        
        <table class="min-w-full bg-white border rounded-lg">
            <thead>
                <tr>
                    <th class="py-2 px-4 border-b">번호</th>
                    <th class="py-2 px-4 border-b">제목</th>
                    <th class="py-2 px-4 border-b">작성자</th>
                    <th class="py-2 px-4 border-b">등록일</th>
                    <th class="py-2 px-4 border-b">조회수</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${boardList}" var="board">
                    <tr>
                        <td class="py-2 px-4 border-b text-center">${board.seq}</td>
                        <td class="py-2 px-4 border-b text-blue-500">
                            <a href="getBoard?seq=${board.seq}">${board.title}</a>
                        </td>
                        <td class="py-2 px-4 border-b text-center">${board.writer}</td>
                        <td class="py-2 px-4 border-b text-center">
                            <fmt:formatDate pattern="yyyy/MM/dd HH:mm:ss" value="${board.regDate}"/>
                        </td>
                        <td class="py-2 px-4 border-b text-center">${board.cnt}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <div class="mt-4 text-right">
            <a href="insertBoardPage.jsp" class="px-4 py-2 bg-blue-500 text-white rounded">글쓰기</a>
        </div>
    </div>
</body>
</html>
