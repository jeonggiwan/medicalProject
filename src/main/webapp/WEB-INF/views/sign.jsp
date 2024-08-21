<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html lang="kr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원추가</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/sign.css">
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    $("#signForm").submit(function(event) {
        event.preventDefault();
 
        var password = $("#password").val();
        var passwordConfirm = $("#passwordConfirm").val();
        
        if (password !== passwordConfirm) {
            alert("비밀번호가 일치하지 않습니다. 다시 확인해주세요.");
            return;
        }
        
        var formData = {
            id: $("#id").val(),
            password: password,

            name: $("#name").val(),
            role: $("#role").val().toUpperCase(), // 대문자로 변환
            specialty: $("#specialty").val(),
            phoneNumber: $("#phone").val(),
            email: $("#email").val(),
            job: $("#job").val()
        };

        $.ajax({
            type: "POST",
            url: "${pageContext.request.contextPath}/sign",
            data: JSON.stringify(formData),
            contentType: "application/json",
            success: function(response) {
                alert("회원추가가 완료되었습니다.");
                window.location.href = "${pageContext.request.contextPath}/memberList";
            },
            error: function(xhr, status, error) {
                alert("회원가입 중 오류가 발생했습니다: " + xhr.responseText);
            }
        });
    });
});
</script>
</head>
<body class="page-container">
    <div class="form-container">

        <button class="back-button" onclick="history.back()">뒤로</button>
        <h1 class="form-title">회원추가</h1>
        <form id="signForm">
            <div class="form-group">
                <label for="id" class="form-label">회원아이디</label>
                <input type="text" id="id" class="form-input" placeholder="아이디">
            </div>
            <div class="form-group">
                <label for="password" class="form-label">패스워드</label>
                <input type="password" id="password" class="form-input" placeholder="패스워드">
            </div>
            <div class="form-group">
                <label for="passwordConfirm" class="form-label">패스워드 확인</label>
                <input type="password" id="passwordConfirm" class="form-input" placeholder="패스워드 확인">
            </div>
            <div class="form-group">
                <label for="name" class="form-label">이름</label>
                <input type="text" id="name" class="form-input" placeholder="이름">
            </div>
            <div class="form-group">
                <label for="role" class="form-label">권한</label>
                <select id="role" class="form-input">
                    <option value="ADMIN">어드민</option>
                    <option value="USER">유저</option>
                </select>
            </div>
            <div class="form-group">
                <label for="specialty" class="form-label">분야</label>
                <input type="text" id="specialty" class="form-input" placeholder="분야">
            </div>
            <div class="form-group">
                <label for="phoneNumber" class="form-label">핸드폰번호</label>
                <input type="text" id="phone" class="form-input" placeholder="-빼고 번호만 입력해주세요">
            </div>
            <div class="form-group">
                <label for="email" class="form-label">이메일</label>
                <input type="email" id="email" class="form-input" placeholder="이메일">
            </div>
            <div class="form-group">
                <label for="job" class="form-label">직업</label>
                <input type="text" id="job" class="form-input" placeholder="직업">
            </div>
            <button type="submit" class="submit-button">가입완료</button>
        </form>
    </div>
</body>
</html>