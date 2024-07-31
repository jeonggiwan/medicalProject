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
	<link href="\CSS\getBoardList.css" rel="stylesheet" type="text/css">

</head>
<body class="bg-gray-100 p-6">
    <div class="container">
        <h1 class="title">문의 게시판</h1>
        
        <!-- 검색 시작 -->
        <form action="getBoardList" method="post" class="search-form">
            <div class="search-container">
                <select name="searchCondition" class="search-select">
                    <option value="TITLE">제목</option>
                    <option value="CONTENT">내용</option>
                </select>
                <input name="searchKeyword" type="text" placeholder="Search" class="search-input">
                <svg class="search-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-4.35-4.35m0 0A7.5 7.5 0 1116.65 16.65z"></path>
                </svg>
                <button type="submit" class="search-button">검색</button>
            </div>
        </form>
        <!-- 검색 종료 -->
        
        <table class="board-table">
            <thead>
                <tr>
                    <th class="table-header">번호</th>
                    <th class="table-header">제목</th>
                    <th class="table-header">작성자</th>
                    <th class="table-header">등록일</th>
                    <th class="table-header">조회수</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${boardList}" var="board">
                    <tr>
                        <td class="table-cell">${board.seq}</td>
                        <td class="table-cell">
                            <a href="getBoard?seq=${board.seq}" class="table-link">${board.title}</a>
                        </td>
                        <td class="table-cell">${board.writer}</td>
                        <td class="table-cell">
                            <fmt:formatDate pattern="yyyy/MM/dd HH:mm:ss" value="${board.regDate}"/>
                        </td>
                        <td class="table-cell">${board.cnt}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <div class="write-button">
            <a href="insertBoardPage.jsp" class="write-link">글쓰기</a>
        </div>
    </div>
</body>
</html>
