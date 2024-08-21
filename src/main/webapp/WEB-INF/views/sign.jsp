<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</head>
<body>
	<h2>회원가입</h2>
	<form id="signForm">
		<div>
			<label for="id">아이디:</label> <input type="text" id="id" name="id"
				required>
		</div>
		<div>
			<label for="password">비밀번호:</label> <input type="password"
				id="password" name="password" required>
		</div>
		<div>
			<label for="name">이름:</label> <input type="text" id="name"
				name="name" required>
		</div>
		<div>
			<label for="specialty">분야:</label> <input type="text" id="specialty"
				name="specialty">
		</div>
		<div>
			<label for="phone">전화번호:</label> <input type="tel" id="phone"
				name="phone">
		</div>
		<div>
			<label for="email">이메일:</label> <input type="email" id="email"
				name="email" required>
			<button type="button" id="sendVerification">인증코드 전송</button>
		</div>
		<div>
			<label for="verificationCode">인증코드:</label> <input type="text"
				id="verificationCode" name="verificationCode">
			<button type="button" id="verifyCode">인증코드 확인</button>
		</div>
		<div>
			<label for="job">직업:</label> <input type="text" id="job" name="job">
		</div>
		<div>
			<button type="submit">가입하기</button>
		</div>
	</form>
	<script>
		$(document)
				.ready(
						function() {
							var isEmailVerified = false;

							$("#sendVerification")
									.click(
											function() {
												var email = $("#email").val();

												// 즉시 사용자에게 피드백 제공
												alert("인증코드가 전송되었습니다. 이메일을 확인해주세요.");

												// 버튼 비활성화 및 텍스트 변경
												$("#sendVerification").prop(
														'disabled', true).text(
														"전송됨");

												$
														.ajax({
															type : "POST",
															url : "${pageContext.request.contextPath}/sendVerification",
															data : {
																email : email
															},
															success : function(
																	response) {
																console
																		.log("이메일 전송 성공");
															},
															error : function(
																	xhr,
																	status,
																	error) {
																console
																		.error(
																				"이메일 전송 실패:",
																				error);
																}
														});
											});

							$("#verifyCode")
									.click(
											function() {
												var email = $("#email").val();
												var code = $(
														"#verificationCode")
														.val();
												$
														.ajax({
															type : "POST",
															url : "${pageContext.request.contextPath}/verifyCode",
															data : {
																email : email,
																code : code
															},
															success : function(
																	response) {
																if (response === "success") {
																	alert("이메일이 인증되었습니다.");
																	isEmailVerified = true;
																} else {
																	alert("인증코드가 일치하지 않습니다.");
																}
															}
														});
											});

							$("#signForm")
									.submit(
											function(event) {
												event.preventDefault();
												if (!isEmailVerified) {
													alert("이메일 인증이 필요합니다.");
													return;
												}

												var formData = {
													id : $("#id").val(),
													password : $("#password")
															.val(),
													name : $("#name").val(),
													specialty : $("#specialty")
															.val(),
													phoneNumber : $("#phone")
															.val(),
													email : $("#email").val(),
													job : $("#job").val()
												};

												$
														.ajax({
															type : "POST",
															url : "${pageContext.request.contextPath}/sign",
															data : JSON
																	.stringify(formData),
															contentType : "application/json",
															success : function(
																	response) {
																alert("회원가입이 완료되었습니다.");
																window.location.href = "${pageContext.request.contextPath}/login";
															},
															error : function(
																	xhr,
																	status,
																	error) {
																alert("회원가입 중 오류가 발생했습니다: "
																		+ xhr.responseText);
															}
														});
											});
						});
	</script>
</body>
</html>