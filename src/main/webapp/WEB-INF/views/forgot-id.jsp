<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>아이디 찾기</title>
<script src="https://cdn.tailwindcss.com"></script>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap"
	rel="stylesheet">
<link href="/CSS/login.css" rel="stylesheet" type="text/css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
.forgot-id-container {
	background-color: white;
	padding: 2rem;
	border-radius: 0.5rem;
	box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px
		rgba(0, 0, 0, 0.05);
	width: 20rem;
}

.forgot-id-title {
	font-size: 1.5rem;
	font-weight: bold;
	margin-bottom: 1.5rem;
	text-align: center;
}

.find-id-button {
	width: 100%;
	background-color: #3B82F6;
	color: white;
	padding: 0.5rem;
	border-radius: 0.5rem;
	font-size: 1.125rem;
	font-weight: bold;
}

.find-id-button:hover {
	background-color: #2563EB;
}

.find-id-button:disabled {
	background-color: #9CA3AF;
	cursor: not-allowed;
}
</style>
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">
	<div class="forgot-id-container">
		<h1 class="forgot-id-title">아이디 찾기</h1>
		<form id="forgotIdForm">
			<div class="input-group">
				<label for="email" class="input-label">이메일</label> <input
					type="email" id="email" name="email" class="input-field" required>
			</div>
			<div class="input-group">
				<label for="name" class="input-label">이름</label> <input type="text"
					id="name" name="name" class="input-field" required>
			</div>
			<button type="submit" id="findIdButton" class="find-id-button">아이디
				찾기</button>
		</form>
		<div class="footer-links">
			<a href="<c:url value='/login'/>" class="footer-link">로그인</a> <span
				class="link-separator">|</span> <a
				href="<c:url value='/forgot-password'/>" class="footer-link">비밀번호
				찾기</a> <span class="link-separator">|</span> <a
				href="<c:url value='/sign'/>" class="footer-link">회원가입</a>
		</div>
	</div>
	<script>
        $(function() {
            $('#forgotIdForm').submit(function(event) {
                event.preventDefault();
                var $button = $('#findIdButton');
                $button.prop('disabled', true);
                
                $.ajax({
                    type: 'POST',
                    url: '/find-id',
                    data: {
                        email: $('#email').val(),
                        name: $('#name').val()
                    },
                    success: function(response) {
                        if (response.found) {
                            alert('아이디를 이메일로 성공적으로 보냈습니다.');
                            window.location.href = '/login';
                        } else {
                            alert('일치하는 사용자 정보를 찾을 수 없습니다.');
                            $button.prop('disabled', false);
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('Error:', xhr.responseText);
                        alert('아이디 찾기 중 오류가 발생했습니다.');
                        $button.prop('disabled', false);
                    }
                });
            });
        });
    </script>
</body>
</html>