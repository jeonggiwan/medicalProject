<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<header class="header">
	<div class="header-left">
		<h1 class="header-title">Mercy</h1>
		<a href="/getBoardList" class="header-link">공지사항</a>
	</div>
	<div class="header-right">
		<span id="accessTokenInfo">로그인 만료까지: <span
			id="accessTokenExpiration"></span></span>
		<button id="extendTokenButton" class="header-link">시간 연장</button>
		<a href="/mypage" class="header-link">마이페이지</a> <a href="#"
			class="header-link" id="logoutButton">로그아웃</a>
		<sec:authorize access="hasRole('ROLE_ADMIN')">
<<<<<<< HEAD
			<a href="#" class="header-link" id="memberManagementMenu">회원관리</a>
=======
			<a href="${pageContext.request.contextPath}/memberList">회원관리</a>
			<a href="${pageContext.request.contextPath}/sign" class="header-link">회원추가</a>
>>>>>>> main
		</sec:authorize>
		<a href="${pageContext.request.contextPath}/getBoardList" class="header-link">공지사항</a>
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
															alert('시간이 연장되었습니다.');
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
																alert('시간 연장에 실패했습니다. 페이지를 새로고침하거나 다시 로그인해주세요.');
															}
														}
													});
										});
					});

	// SSE 연결 및 알림 처리
	var eventSource = new EventSource("${pageContext.request.contextPath}/sse");

	eventSource.onmessage = function(event) {
		showNotification(event.data);
	};

	function showNotification(content) {
		var notification = $('<div class="notification">' + content + '</div>');
		$('body').append(notification);
		
		setTimeout(function() {
			notification.fadeOut('slow', function() {
				$(this).remove();
			});
		}, 10000);
	}
</script>

<style>
	.notification {
		position: fixed;
		bottom: 20px;
		right: 20px;
		background-color: #f8f9fa;
		border: 1px solid #dee2e6;
		padding: 10px;
		border-radius: 5px;
		box-shadow: 0 2px 5px rgba(0,0,0,0.1);
		z-index: 1000;
	}
</style>