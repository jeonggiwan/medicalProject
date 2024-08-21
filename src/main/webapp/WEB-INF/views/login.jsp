<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap" rel="stylesheet">
    <link href="\CSS\login.css" rel="stylesheet" type="text/css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">
    <div class="login-container">
        <h1 class="login-title">로그인</h1>
        <c:if test="${not empty error}">
            <p class="error-message">${error}</p>
        </c:if>
        <form id="loginForm">
            <div class="input-group">
                <label for="username" class="input-label">아이디</label>
                <input type="text" id="username" name="username" class="input-field" required>
            </div>
            <div class="input-group">
                <label for="password" class="input-label">비밀번호</label>
                <input type="password" id="password" name="password" class="input-field" required>
            </div>
            <button type="submit" class="login-button">로그인</button>
        </form>
        <div class="footer-links">
            <a href="<c:url value='/forgot-password'/>" class="footer-link">비밀번호 찾기</a>
            <span class="link-separator">|</span>
            <a href="<c:url value='/sign'/>" class="footer-link">회원가입</a>
        </div>
    </div>
    <script>
        $(function() {
            $('#loginForm').submit(function(event) {
                event.preventDefault();
                $.ajax({
                    type: 'POST',
                    url: '/login',
                    data: {
                        id: $('#username').val(),
                        password: $('#password').val()
                    },
                    success: function(response) {
                        console.log('Login response:', response);
                        if (response.message === "Login successful") {
                            console.log('Login successful');
                            window.location.href = '/';
                        } else {
                            console.error('Unexpected response:', response);
                            alert('로그인 처리 중 오류가 발생했습니다.');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('Login error:', xhr.responseText);
                        alert('로그인에 실패했습니다. 아이디와 비밀번호를 확인해주세요.');
                    }
                });
            });
        });
    </script>
</body>
</html>