<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
        }
    </style>
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">
    <div class="bg-white p-8 rounded-lg shadow-lg w-80">
        <h1 class="text-2xl font-bold mb-6 text-center">로그인</h1>
        <c:if test="${not empty error}">
            <p class="text-red-500 text-sm mb-4">${error}</p>
        </c:if>
        <form action="<c:url value='/login'/>" method="post">
            <div class="mb-4">
                <label for="username" class="block text-lg mb-2">아이디</label>
                <input type="text" id="username" name="username" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" required>
            </div>
            <div class="mb-6">
                <label for="password" class="block text-lg mb-2">비밀번호</label>
                <input type="password" id="password" name="password" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" required>
            </div>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <button type="submit" class="w-full bg-blue-500 text-white py-2 rounded-lg text-lg font-bold hover:bg-blue-600 transition duration-200">로그인</button>
        </form>
        <div class="mt-4 text-center">
            <a href="<c:url value='/forgot-password'/>" class="text-sm text-gray-600 hover:underline">비밀번호 찾기</a>
        </div>
    </div>
</body>
</html>