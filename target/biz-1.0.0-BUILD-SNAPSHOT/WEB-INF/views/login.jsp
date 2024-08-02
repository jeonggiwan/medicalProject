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
        <div class="forgot-password">
            <a href="<c:url value='/forgot-password'/>" class="forgot-password-link">비밀번호 찾기</a>
        </div>
    </div>
     <script>
        $(function () {
            // AJAX 요청에 토큰을 자동으로 포함시키는 설정
            $.ajaxSetup({
                beforeSend: function(xhr) {
                    var token = localStorage.getItem('token');
                    if (token) {
                        xhr.setRequestHeader('X-AUTH-TOKEN', token);
                    }
                }
            });

            $('#loginForm').submit(function (event) {
                event.preventDefault();
                $.ajax({
                    type: 'POST',
                    url: '/login',
                    data: {
                        id: $('#username').val(),
                        password: $('#password').val()
                    },
                    success: function (data) {
                        localStorage.setItem('token', data);
                        // 토큰을 쿠키에도 저장 (서버에서 읽을 수 있도록)
                        document.cookie = "X-AUTH-TOKEN=" + data + "; path=/";
                        // 로그인 성공 후 직접 홈페이지로 이동
                        window.location.href = '/';
                    },
                    error: function (xhr, status, error) {
                        console.error(error);
                        alert('Login failed. Please check your username and password.');
                    }
                });
            });
        });
    </script>
</body>
</html>