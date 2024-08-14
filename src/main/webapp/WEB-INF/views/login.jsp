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
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap"
	rel="stylesheet">
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
				<label for="username" class="input-label">아이디</label> <input
					type="text" id="username" name="username" class="input-field"
					required>
			</div>
			<div class="input-group">
				<label for="password" class="input-label">비밀번호</label> <input
					type="password" id="password" name="password" class="input-field"
					required>
			</div>
			<button type="submit" class="login-button">로그인</button>
		</form>
		<div class="forgot-password">
			<a href="<c:url value='/forgot-password'/>"
				class="forgot-password-link">비밀번호 찾기</a>
		</div>
	</div>
	<script>
		$(function() {
			// AJAX 설정
			$.ajaxSetup({
				beforeSend : function(xhr) {
					var token = localStorage.getItem('accessToken');
					if (token) {
						xhr
								.setRequestHeader('Authorization', 'Bearer '
										+ token);
					}
				}
			});

			$('#loginForm')
					.submit(
							function(event) {
								event.preventDefault();
								$
										.ajax({
											type : 'POST',
											url : '/login',
											data : {
												id : $('#username').val(),
												password : $('#password').val()
											},
											success : function(data) {
												console.log('Login response:',
														data); // 응답 로깅
												if (data.accessToken) {
													localStorage.setItem(
															'accessToken',
															data.accessToken);
													console
															.log(
																	'Stored access token:',
																	data.accessToken); // 저장된 토큰 로깅
													window.location.href = '/';
												} else {
													console
															.error('No access token in response');
												}
											},
											error : function(xhr, status, error) {
												console.error('로그인 실패:', error);
												alert('로그인에 실패했습니다. 아이디와 비밀번호를 확인해주세요.');
											}
										});
							});

			// 페이지 로드 시 토큰 확인
			$(document).ready(
					function() {
						console.log('Current stored token:', localStorage
								.getItem('accessToken'));
					});
		});
	</script>
</body>
</html>