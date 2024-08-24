
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<header class="header">
    <div class="header-left">
        <a href="/" class="header-title">Mercy</a>
        <c:if test="${isIndexPage}">
            <a href="#" class="header-link" id="noticeLink">공지사항</a>
        </c:if>
    </div>
    <div class="header-right">
        <span id="accessTokenInfo">로그인 만료까지: <span id="accessTokenExpiration"></span></span>
        <button id="extendTokenButton" class="header-link">시간 연장</button>
        <c:if test="${isIndexPage}">
            <a href="#" class="header-link" id="mypageButton">마이페이지</a>
        </c:if>
        <a href="#" class="header-link" id="logoutButton">로그아웃</a>
        <sec:authorize access="hasRole('ROLE_ADMIN')">
            <c:if test="${isIndexPage}">
                <a href="#" class="header-link" id="memberManagementMenu">회원관리</a>
            </c:if>
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

				        $('#logoutButton').click(handleLogout);
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

    function handleLogout() {
        $.ajax({
            url: '/logout',
            type: 'POST',
            xhrFields: {
                withCredentials: true
            },
            success: function (response) {
                console.log('Logout successful');
                window.location.href = '/login';
            },
            error: function (xhr, status, error) {
                console.error('Logout failed:', error);
                alert('로그아웃 중 오류가 발생했습니다. 다시 시도해주세요.');
            }
        });
    }
</script>
