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
						<button class="search-button" onclick="filterByPeriod('all')">전체</button>
						<button class="search-button" onclick="filterByPeriod('1d')">1일</button>
						<button class="search-button" onclick="filterByPeriod('3d')">3일</button>
						<button class="search-button" onclick="filterByPeriod('1w')">1주일</button>
						<button class="search-button" onclick="filterByPeriod('1m')">1개월</button>
						<button class="search-button" onclick="filterByPeriod('3m')">3개월</button>
						<button class="search-button" onclick="filterByPeriod('custom')">설정</button>
						<button class="search-button search-button-red" onclick="searchPatients()">검색</button>
					</div>
					<div class="table-container">
						<table class="table" id="studyTable">
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
							<tbody id="studyTableBody">
								<!-- 정보 불러오는 곳 -->
							</tbody>
						</table>
					</div>
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
							$('#studyTableBody').on('click', '.patient-row', function() {
								var pid = $(this).data('pid');
								var pName = $(this).data('pname');

								$('#selectedPatientId').val(pid);
								$('#selectedPatientName').val(pName);

								// AJAX 호출로 과거 검사 이력 가져오기
								$.ajax({
									url: '/getPatientHistory',
									type: 'GET',
									data: { pid: pid },
									success: function(response) {
										if (typeof response === 'string') {
											$('#historyTable tbody').html('<tr><td colspan="6">' + response + '</td></tr>');
										} else if (response && response.length > 0) {
											updateHistoryTable(response);
										} else {
											$('#historyTable tbody').html('<tr><td colspan="6">자료가 없습니다.</td></tr>');
										}
									},
									error: function(xhr, status, error) {
										console.error('과거 검사 이력 조회 중 오류 발생:', error);
										$('#historyTable tbody').html('<tr><td colspan="6">이력 로딩 중 오류가 발생했습니다.</td></tr>');
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
			tbody.empty(); // 기존 내용을 지웁니다

			if (historyData && historyData.length > 0) {
				historyData.forEach(function(study) {
					var row = $('<tr>');
					row.append($('<td>').text(study.studyDate || '-'));
					row.append($('<td>').text(study.studyTime || '-'));
					row.append($('<td>').text(study.modality || '-'));
					row.append($('<td>').text(study.studyDesc || '-'));
					row.append($('<td>').text(study.seriesCnt || '-'));
					row.append($('<td>').text(study.imageCnt || '-'));
					tbody.append(row);
				});
			} else {
				// 데이터가 없을 경우 메시지 표시
				tbody.append('<tr><td colspan="6">과거 검사 이력이 없습니다.</td></tr>');
			}
		}

		let currentPage = 1;
		const itemsPerPage = 5;
		let allStudies = [];

		function filterByPeriod(period) {
			$.ajax({
				url: '/getDay',
				type: 'GET',
				data: { period: period },
				success: function(response) {
					if (typeof response === 'string') {
						$('#studyTableBody').html('<tr><td colspan="10">' + response + '</td></tr>');
						$('.pagination').remove(); // 페이지네이션 제거
					} else if (response && response.length > 0) {
						allStudies = response;
						currentPage = 1;
						displayStudies();
						setupPagination();
					} else {
						$('#studyTableBody').html('<tr><td colspan="10">자료가 없습니다.</td></tr>');
						$('.pagination').remove(); // 페이지네이션 제거
					}
				},
				error: function(xhr, status, error) {
					console.error('Error fetching studies:', error);
					$('#studyTableBody').html('<tr><td colspan="10">Error loading studies</td></tr>');
					$('.pagination').remove(); // 페이지네이션 제거
				}
			});
		}

		function displayStudies() {
			const start = (currentPage - 1) * itemsPerPage;
			const end = start + itemsPerPage;
			const pageStudies = allStudies.slice(start, end);

			let tableContent = '';
			$.each(pageStudies, function(index, study) {
				tableContent += '<tr class="patient-row" data-pid="' + (study.pid || '') + '" data-pname="' + (study.pName || '') + '">';
				tableContent += '<td class="table-cell text-center"><input type="checkbox"></td>';
				tableContent += '<td class="table-cell">' + (study.pid || '-') + '</td>';
				tableContent += '<td class="table-cell">' + (study.pName || '-') + '</td>';
				tableContent += '<td class="table-cell">' + (study.studyDate || '-') + '</td>';
				tableContent += '<td class="table-cell">' + (study.studyTime || '-') + '</td>';
				tableContent += '<td class="table-cell">' + (study.modality || '-') + '</td>';
				tableContent += '<td class="table-cell">' + (study.studyDesc || '-') + '</td>';
				tableContent += '<td class="table-cell">' + (study.seriesCnt || '-') + '</td>';
				tableContent += '<td class="table-cell">' + (study.imageCnt || '-') + '</td>';
				tableContent += '</tr>';
			});
			$('#studyTableBody').html(tableContent);
		}

		function setupPagination() {
			const totalPages = Math.ceil(allStudies.length / itemsPerPage);
			let paginationHtml = '<div class="pagination">';
			for (let i = 1; i <= totalPages; i++) {
				paginationHtml += '<button onclick="changePage(' + i + ')">' + i + '</button>';
			}
			paginationHtml += '</div>';
			
			// 기존 페이지네이션 제거 후 새로 추가
			$('.pagination').remove();
			$('#studyTable').after(paginationHtml);
		}

		function changePage(page) {
			currentPage = page;
			displayStudies();
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