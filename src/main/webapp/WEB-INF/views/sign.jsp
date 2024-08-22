<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/CSS/sign.css">
<style>
.error {
	color: red;
	display: none;
}
</style>
</head>
<body>
	<div class="page-container">
		<a href="${pageContext.request.contextPath}/login"
			class="login-button">로그인으로</a>
		<div class="form-container">
			<h2 class="form-title">회원가입</h2>
			<form id="signForm">
				<div class="form-group">
					<label class="form-label" for="id">아이디</label> <input
						class="form-input" type="text" id="id" name="id" required>
					<span class="error" id="idError">아이디는 8~20자의 알파벳과 숫자만 가능합니다.</span>
				</div>
				<div class="form-group">
					<label class="form-label"
					 for="password">비밀번호</label> <input
						class="form-input" type="password" id="password" name="password"
						required> <span class="error" id="passwordError">비밀번호는
						8자 이상이어야 합니다.</span>
				</div>
				<div class="form-group">
					<label class="form-label" for="confirmPassword">비밀번호 확인</label> <input
						class="form-input" type="password" id="confirmPassword"
						name="confirmPassword" required> <span class="error"
						id="confirmPasswordError">비밀번호가 일치하지 않습니다.</span>
				</div>
				<div class="form-group">
					<label class="form-label" for="name">이름</label> <input
						class="form-input" type="text" id="name" name="name" required>
				</div>
				<div class="form-group">
					<label class="form-label" for="specialty">분야</label> <input
						class="form-input" type="text" id="specialty" name="specialty">
				</div>
				<div class="form-group">
					<label class="form-label" for="phoneNumber">전화번호</label> <input
						class="form-input" type="tel" id="phoneNumber" name="phoneNumber" required>
					<span class="error" id="phoneNumberError">유효한 전화번호를 입력해주세요.</span>
				</div>
				<div class="form-group">
					<label class="form-label" for="email">이메일</label> <input
						class="form-input" type="email" id="email" name="email" required>
					<button type="button" id="sendVerification" class="verify-button">인증코드
						전송</button>
					<span class="error" id="emailError">유효한 이메일 주소를 입력해주세요.</span>
				</div>
				<div class="form-group">
					<label class="form-label" for="verificationCode">인증코드</label> <input
						class="form-input" type="text" id="verificationCode"
						name="verificationCode">
					<button type="button" id="verifyCode" class="verify-button">인증코드
						확인</button>
				</div>
				<div class="form-group">
					<label class="form-label" for="job">직업</label>
					<select class="form-input" id="job" name="job" required>
						<option value="">선택하세요</option>
						<option value="의사">의사</option>
						<option value="간호사">간호사</option>
						<option value="기타">기타</option>
					</select>
				</div>
				<div class="form-group">
					<button type="submit" class="submit-button">가입하기</button>
				</div>
			</form>
		</div>
	</div>
	<script>
		$(document).ready(function() {
			var isEmailVerified = false;
			var debounceTimer;
			var isEmailDuplicate = false;

			function validateId() {
				var id = $("#id").val();
				var idRegex = /^[a-zA-Z0-9]{8,20}$/;
				if (!idRegex.test(id)) {
					$("#idError").text("아이디는 8~20자의 알파벳과 숫자만 가능합니다.").show();
					return false;
				}
				$("#idError").hide();
				return true;
			}

			function validatePassword() {
				var password = $("#password").val();
				if (password.length < 8) {
					$("#passwordError").show();
					return false;
				}
				$("#passwordError").hide();
				return true;
			}

			function validateConfirmPassword() {
				var password = $("#password").val();
				var confirmPassword = $("#confirmPassword").val();
				if (password !== confirmPassword) {
					$("#confirmPasswordError").show();
					return false;
				}
				$("#confirmPasswordError").hide();
				return true;
			}

			function validatePhoneNumber() {
				var phoneNumber = $("#phoneNumber").val();
				var phoneNumberRegex = /^[0-9]{10,11}$/;
				if (!phoneNumberRegex.test(phoneNumber)) {
					$("#phoneNumberError").text("유효한 전화번호를 입력해주세요.").show();
					return false;
				}
				$("#phoneNumberError").hide();
				return true;
			}

			function validateEmail() {
				var email = $("#email").val();
				var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
				if (!emailRegex.test(email)) {
					$("#emailError").text("유효한 이메일 주소를 입력해주세요.").show();
					return false;
				}
				$("#emailError").hide();
				return true;
			}
			function checkDuplication(field) {
			    var value = $("#" + field).val();
			    if (!value) return;

			    var data = {};
			    data[field] = value;

			    console.log("Checking duplication for field:", field, "with value:", value);

			    $.ajax({
			        type: "POST",
			        url: "${pageContext.request.contextPath}/checkDuplication",
			        contentType: "application/json",
			        data: JSON.stringify(data),
			        success: function(response) {
			            console.log("Duplication check response:", response);

			            var errorField = field;
			            var existsKey = field === "phoneNumber" ? "phoneExists" : field + "Exists";
			            if (response[existsKey] === true) {  // true means the value already exists (is duplicate)
			                $("#" + errorField + "Error").text("이미 사용 중인 " + field + "입니다.").show();
			                if (field === "email") {
			                    isEmailDuplicate = true;
			                    $("#sendVerification").prop('disabled', true);
			                }
			            } else {  // false means the value is available (not duplicate)
			                $("#" + errorField + "Error").hide();
			                if (field === "email") {
			                    isEmailDuplicate = false;
			                    $("#sendVerification").prop('disabled', false);
			                }
			            }
			        },
			        error: function(xhr, status, error) {
			            console.error("중복 확인 중 오류 발생:", error);
			        }
			    });
			}

			function debounce(func, delay) {
				clearTimeout(debounceTimer);
				debounceTimer = setTimeout(func, delay);
			}

			$("#id").on("input", function() {
				if (validateId()) {
					debounce(function() {
						checkDuplication("id");
					}, 500);
				}
			});

			$("#email").on("input", function() {
				if (validateEmail()) {
					debounce(function() {
						checkDuplication("email");
					}, 500);
				}
			});

			$("#phoneNumber").on("input", function() {
				debounce(function() {
					if (validatePhoneNumber()) {
						checkDuplication("phoneNumber");
					}
				}, 500);
			});

			$("#password").on("input", validatePassword);
			$("#confirmPassword").on("input", validateConfirmPassword);

			$("#sendVerification").click(function() {
				if (!validateEmail() || isEmailDuplicate)
					return;

				var email = $("#email").val();
				alert("인증코드가 전송되었습니다. 이메일을 확인해주세요.");
				$("#sendVerification").prop('disabled', true).text("전송됨");

				$.ajax({
					type: "POST",
					url: "${pageContext.request.contextPath}/sendVerification",
					data: {
						email: email
					},
					success: function(response) {
						console.log("이메일 전송 성공");
					},
					error: function(xhr, status, error) {
						console.error("이메일 전송 실패:", error);
						$("#sendVerification").prop('disabled', false).text("인증코드 전송");
					}
				});
			});

			$("#verifyCode").click(function() {
				var email = $("#email").val();
				var code = $("#verificationCode").val();
				$.ajax({
					type: "POST",
					url: "${pageContext.request.contextPath}/verifyCode",
					data: {
						email: email,
						code: code
					},
					success: function(response) {
						if (response === "success") {
							alert("이메일이 인증되었습니다.");
							isEmailVerified = true;
						} else {
							alert("인증코드가 일치하지 않습니다.");
						}
					}
				});
			});

			$("#signForm").submit(function(event) {
				event.preventDefault();

				if (!validateId() || !validatePassword() || !validateConfirmPassword() ||
					!validatePhoneNumber() || !validateEmail()) {
					alert("입력 정보를 확인해주세요.");
					return;
				}

				if (!isEmailVerified) {
					alert("이메일 인증이 필요합니다.");
					return;
				}

				if ($("#idError").is(":visible") || $("#emailError").is(":visible") ||
					$("#phoneNumberError").is(":visible")) {
					alert("중복된 정보가 있습니다. 확인 후 다시 시도해주세요.");
					return;
				}

				var selectedJob = $("#job").val();
				if (!selectedJob) {
					alert("직업을 선택해주세요.");
					return;
				}
				
				var formData = {
					id: $("#id").val(),
					password: $("#password").val(),
					name: $("#name").val(),
					specialty: $("#specialty").val(),
					phoneNumber: $("#phoneNumber").val(),
					email: $("#email").val(),
					job: selectedJob
				};

				$.ajax({
					type: "POST",
					url: "${pageContext.request.contextPath}/sign",
					data: JSON.stringify(formData),
					contentType: "application/json",
					success: function(response) {
						alert("회원가입이 완료되었습니다.");
						window.location.href = "${pageContext.request.contextPath}/login";
					},
					error: function(xhr, status, error) {
						alert("회원가입 중 오류가 발생했습니다: " + xhr.responseText);
					}
				});
			});
		});
	</script>
</body>
</html>