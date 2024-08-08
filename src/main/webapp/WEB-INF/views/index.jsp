<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>PACSPLUS</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.tailwindcss.com"></script>
<link
	href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<link href="${pageContext.request.contextPath}/CSS/index.css"
	rel="stylesheet">
</head>

<body class="bg-gray-100 text-gray-900">
	<div class="container">
		<!-- Main Content -->
		<div class="main-content">
			<header class="header">
				<div class="header-left">
					<h1 class="header-title">Mercy</h1>
					<span class="notification-icon"> 🔔 알림창</span>
				</div>
				<div class="header-right">
					<a href="#" class="header-link">마이페이지</a> <a href="#"
						class="header-link" id="logoutButton">로그아웃</a>
				</div>
			</header>
			<div class="content">
				<div class="search-section">
					<h2 class="search-title">검색</h2>
					<div class="search-inputs">
						<input type="text" placeholder="환자 아이디" class="search-input">
						<input type="text" placeholder="환자 이름" class="search-input">
						<select class="search-input">
							<option>판독 상태</option>
						</select>
					</div>
					<div class="search-buttons">
						<button class="search-button">전체</button>
						<button class="search-button">1일</button>
						<button class="search-button">3일</button>
						<button class="search-button">1주일</button>
						<button class="search-button">1개월</button>
						<button class="search-button">3개월</button>
						<button class="search-button">설정</button>
						<button class="search-button search-button-red">검색</button>
					</div>
					<div class="table-container">
						<table class="table" id="patientTable">
							<colgroup>
								<col class="col-checkbox">
								<col class="col-id">
								<col class="col-name">
								<col class="col-date">
								<col class="col-time">
								<col class="col-modality">
								<col class="col-desc">
								<col class="col-series">
								<col class="col-images">
							</colgroup>
							<thead class="table-header">
								<tr>
									<th class="table-cell">선택</th>
									<th class="table-cell">환자 ID</th>
									<th class="table-cell">환자 이름</th>
									<th class="table-cell">검사 날짜</th>
									<th class="table-cell">검사 시간</th>
									<th class="table-cell">모달리티</th>
									<th class="table-cell">검사 설명</th>
									<th class="table-cell">시리즈 수</th>
									<th class="table-cell">이미지 수</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="study" items="${studyList}">
									<tr class="patient-row" data-pid="${study.pid}"
										data-pname="${study.pName}">
										<td class="table-cell text-center"><input type="checkbox"></td>
										<td class="table-cell">${study.pid}</td>
										<td class="table-cell">${study.pName}</td>
										<td class="table-cell">${study.studyDate}</td>
										<td class="table-cell">${study.studyTime}</td>
										<td class="table-cell">${study.modality}</td>
										<td class="table-cell">${study.studyDesc}</td>
										<td class="table-cell">${study.seriesCnt}</td>
										<td class="table-cell">${study.imageCnt}</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>

				<!-- 페이지네이션 추가 -->
				<div class="pagination">
					<c:if test="${currentPage > 1}">
						<a href="?page=${currentPage - 1}">&laquo; 이전</a>
					</c:if>

					<c:forEach begin="1" end="${totalPages}" var="i">
						<c:choose>
							<c:when test="${currentPage eq i}">
								<span class="current-page">${i}</span>
							</c:when>
							<c:otherwise>
								<a href="?page=${i}">${i}</a>
							</c:otherwise>
						</c:choose>
					</c:forEach>

					<c:if test="${currentPage < totalPages}">
						<a href="?page=${currentPage + 1}">다음 &raquo;</a>
					</c:if>
				</div>
				<div class="grid-container">
					<div>
						<h2 class="search-title">과거 검사 이력</h2>
						<div class="search-inputs">
							<input type="text" id="selectedPatientId" placeholder="환자 아이디"
								class="search-input" readonly> <input type="text"
								id="selectedPatientName" placeholder="환자 이름"
								class="search-input" readonly>
						</div>
						<div class="table-container">
							<table class="table" id="historyTable">
								<colgroup>
									<col class="col-date">
									<col class="col-time">
									<col class="col-modality">
									<col class="col-desc">
									<col class="col-series">
									<col class="col-images">
								</colgroup>
								<thead class="table-header">
									<tr>
										<th class="table-cell">검사 날짜</th>
										<th class="table-cell">검사 시간</th>
										<th class="table-cell">모달리티</th>
										<th class="table-cell">검사 설명</th>
										<th class="table-cell">시리즈</th>
										<th class="table-cell">이미지</th>
									</tr>
								</thead>
								<tbody>
									<!-- 동적으로 채워질 내용 -->
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="sidebar">
			<h1 class="sidebar-title">일정</h1>
			<div class="calendar-container">
				<div id="calendar" class="calendar"></div>
			</div>
            <button id="saveButton" class="save-button">저장</button>
            <div class="memo-container">
                <textarea id="memoTextarea" class="memo-textarea" placeholder="메모를 입력하세요..."></textarea>
            </div>
		</div>
</div>
		<script>
		$(document)
				.ready(
						function() {
							$('#patientTable')
									.on(
											'click',
											'.patient-row',
											function() {
												var pid = $(this).data('pid');
												var pName = $(this).data(
														'pname');

												$('#selectedPatientId')
														.val(pid);
												$('#selectedPatientName').val(
														pName);

												// AJAX 호출로 과거 검사 이력 가져오기
												$
														.ajax({
															url : '/getPatientHistory',
															type : 'GET',
															data : {
																pid : pid
															},
															success : function(
																	response) {
																if (response
																		&& response.length > 0) {
																	updateHistoryTable(response);
																} else {
																	$(
																			'#historyTable tbody')
																			.html(
																					'<tr><td colspan="7">No history found</td></tr>');
																}
															},
															error : function(
																	xhr,
																	status,
																	error) {
																console
																		.error(
																				'Error fetching patient history:',
																				error);
																$(
																		'#historyTable tbody')
																		.html(
																				'<tr><td colspan="7">Error loading history</td></tr>');
															}
														});
											});

							 // 달력 초기화
				            const calendarEl = document.getElementById('calendar');
				            const fp = flatpickr(calendarEl, {
				                inline: true,
				                mode: "multiple",
				                dateFormat: "Y-m-d",
				                onChange: function(selectedDates, dateStr, instance) {
				                    loadMemo(dateStr);
				                }
				            });

				            const memoTextarea = document.getElementById('memoTextarea');
				            const saveButton = document.getElementById('saveButton');

				            saveButton.addEventListener('click', function() {
				                const selectedDates = fp.selectedDates;
				                const memo = memoTextarea.value;
				                if (selectedDates.length > 0) {
				                    const dateStr = formatDate(selectedDates[selectedDates.length - 1]);
				                    saveMemo(dateStr, memo);
				                } else {
				                    alert('날짜를 선택해주세요.');
				                }
				            });

				            function loadMemo(dateStr) {
				                const memo = localStorage.getItem(dateStr) || '';
				                memoTextarea.value = memo;
				            }

				            function saveMemo(dateStr, memo) {
				                localStorage.setItem(dateStr, memo);
				                alert('메모가 저장되었습니다.');
				            }

				            function formatDate(date) {
				                const year = date.getFullYear();
				                const month = String(date.getMonth() + 1).padStart(2, '0');
				                const day = String(date.getDate()).padStart(2, '0');
				                return `${year}-${month}-${day}`;
				            }

						});

		function updateHistoryTable(historyData) {
			var tbody = $('#historyTable tbody');
			tbody.empty();

			historyData.forEach(function(item) {
				var row = $('<tr>');
				row.append($('<td>').text(item.studyDate));
				row.append($('<td>').text(item.studyTime));
				row.append($('<td>').text(item.modality));
				row.append($('<td>').text(item.studyDesc));
				row.append($('<td>').text(item.seriesCnt));
				row.append($('<td>').text(item.imageCnt));
				tbody.append(row);
			});
		}

		$('#logoutButton')
				.click(
						function() {
							$
									.ajax({
										url : '/logout',
										type : 'POST',
										xhrFields : {
											withCredentials : true
										},
										success : function(response) {
											console.log('Logout successful');
											document.cookie = "REFRESH_TOKEN=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
											localStorage
													.removeItem('accessToken'); // 액세스 토큰 제거
											window.location.href = '/login';
										},
										error : function(xhr, status, error) {
											console.error('Logout failed:',
													error);
											alert('로그아웃 중 오류가 발생했습니다.');
										}
									});
						});
	</script>
</body>

</html>