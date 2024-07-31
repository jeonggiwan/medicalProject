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
    <link href="\CSS\login.css" rel="stylesheet" type="text/css">
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">
    <div class="login-container">
        <h1 class="login-title">로그인</h1>
        <c:if test="${not empty error}">
            <p class="error-message">${error}</p>
        </c:if>
        <form action="<c:url value='/login'/>" method="post">
            <div class="input-group">
                <label for="username" class="input-label">아이디</label>
                <input type="text" id="username" name="username" class="input-field" required>
            </div>
            <div class="input-group">
                <label for="password" class="input-label">비밀번호</label>
                <input type="password" id="password" name="password" class="input-field" required>
            </div>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <button type="submit" class="login-button">로그인</button>
        </form>
        <div class="forgot-password">
            <a href="<c:url value='/forgot-password'/>" class="forgot-password-link">비밀번호 찾기</a>
        </div>
    </div>
</body>
</html>