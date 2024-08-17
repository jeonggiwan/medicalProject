<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<header class="header">
	<div class="header-left">
		<h1 class="header-title">Mercy</h1>
	</div>
	<div class="header-right">
		<span id="accessTokenInfo">로그인 만료까지: <span
			id="accessTokenExpiration"></span></span>
		<button id="extendTokenButton" class="header-button">시간 연장</button>
		<a href="#" class="header-link">마이페이지</a> <a href="#"
			class="header-link" id="logoutButton">로그아웃</a>
		<sec:authorize access="hasRole('ROLE_ADMIN')">
			<a href="${pageContext.request.contextPath}/memberList">회원관리</a>
			<a href="#" class="header-link">회원추가</a>
		</sec:authorize>
	</div>
</header>
<script>
	let countdownInterval;

	function updateAccessTokenInfo() {
		$.ajax({
			url : '/tokenInfo',
			type : 'GET',
			success : function(response) {
				if (response.remainingTime > 0) {
					startCountdown(response.remainingTime);
				} else {
					$('#accessTokenExpiration').text('토큰 만료됨');
					clearInterval(countdownInterval);
				}
			},
			error : function(xhr, status, error) {
				console.error('토큰 정보 가져오기 실패:', error);
				$('#accessTokenExpiration').text('정보 가져오기 실패');
			}
		});
	}

	function startCountdown(remainingTime) {
		clearInterval(countdownInterval);

		function updateCountdown() {
			if (remainingTime <= 0) {
				$('#accessTokenExpiration').text('토큰 만료됨');
				clearInterval(countdownInterval);
				return;
			}

			const minutes = Math.floor(remainingTime / (60 * 1000));
			const seconds = Math.floor((remainingTime % (60 * 1000)) / 1000);
			$('#accessTokenExpiration').text(minutes + '분 ' + seconds + '초');
			remainingTime -= 1000;
		}

		updateCountdown();
		countdownInterval = setInterval(updateCountdown, 1000);
	}

	$(document)
			.ready(
					function() {
						updateAccessTokenInfo();

						$('#extendTokenButton')
								.click(
										function() {
											$
													.ajax({
														url : '/refreshToken',
														type : 'POST',
														success : function(
																response) {
															updateAccessTokenInfo();
															alert('토큰이 연장되었습니다.');
														},
														error : function(xhr,
																status, error) {
															console
																	.error(
																			'토큰 연장 실패:',
																			xhr.responseText,
																			status,
																			error);
															if (xhr.status === 401) {
																alert('세션이 만료되었습니다. 다시 로그인해주세요.');
																window.location.href = '/login';
															} else {
																alert('토큰 연장에 실패했습니다. 페이지를 새로고침하거나 다시 로그인해주세요.');
															}
														}
													});
										});
					});
</script>