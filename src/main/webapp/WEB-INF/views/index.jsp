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
<link href="${pageContext.request.contextPath}/CSS/index.css" rel="stylesheet">
</head>

<body class="bg-gray-100 text-gray-900">
	<div class="container">
		<!-- Main Content -->
		<div class="main-content">
			<jsp:include page="menu.jsp" />
			<div id="content" class="content">
				<div class="search-section">
					<h2 class="search-title">검색</h2>
					<div class="search-inputs">
						<input type="text" id="searchKeyword" placeholder="검색어 입력"
							class="search-input"> <select id="searchType"
							class="search-input">
							<option value="pid">환자 ID</option>
							<option value="pName">환자 이름</option>
						</select>
						<button class="search-button search-button-red"
							onclick="searchPatients()">검색</button>
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
				<textarea id="memoTextarea" class="memo-textarea"
					placeholder="메모를 입력하세요..."></textarea>
			</div>
		</div>
	</div>
	<script>

    let currentPage = 1;
    let totalPages = 1;
    
    $(document).ready(function () {
        setupAjaxInterceptor();
        setupEventListeners();
        initializeCalendar();
        
    });
    // 더블클릭 이벤트 리스너 수정
    $('#patientTable').on('dblclick', '.patient-row', function() {
        var pid = $(this).find('td:eq(1)').text(); // 환자 ID
        var studyDate = $(this).find('td:eq(3)').text(); // 검사 날짜
        
        // 뷰어로 이동
        window.location.href = '/viewer?pid=' + pid + '&studyDate=' + studyDate;
    });
    function setupAjaxInterceptor() {
        $.ajaxSetup({
            beforeSend: function (xhr) {
                var token = localStorage.getItem('accessToken');
                if (token) {
                    xhr.setRequestHeader('Authorization', 'Bearer ' + token);
                }
            }
        });

        $(document).ajaxError(function (event, jqXHR, ajaxSettings, thrownError) {
            if (jqXHR.status === 401) {
                refreshToken().then(function () {
                    $.ajax(ajaxSettings);
                }).catch(function () {
                    window.location.href = '/login';
                });
            }
        });
    }

    function setupEventListeners() {
        $('#patientTable').on('click', '.patient-row', handlePatientRowClick);
        $('#logoutButton').click(handleLogout);
        $('#saveButton').click(handleMemoSave);
        $('#memberManagementMenu').click(loadMemberManagement);
        $('#searchButton').click(searchPatients);
        $('#mypageButton').click(loadMyPage);
    }

    function loadMyPage() {
        $.ajax({
            url: '/mypage',
            type: 'GET',
            success: function(response) {
                $('#content').html(response);
            },
            error: function(xhr, status, error) {
                console.error('Error loading mypage:', error);
                alert('마이페이지 로딩 중 오류가 발생했습니다.');
            }
        });
    }

    
    function handlePatientRowClick() {
        var pid = $(this).data('pid');
        var pName = $(this).data('pname');
        $('#selectedPatientId').val(pid);
        $('#selectedPatientName').val(pName);
        fetchPatientHistory(pid);
    }

    function fetchPatientHistory(pid) {
        $.ajax({
            url: '/getPatientHistory',
            type: 'GET',
            data: { pid: pid },
            success: function (response) {
                if (response && response.length > 0) {
                    updateHistoryTable(response);
                } else {
                    $('#historyTable tbody').html('<tr><td colspan="7">No history found</td></tr>');
                }
            },
            error: function (xhr, status, error) {
                console.error('Error fetching patient history:', error);
                if (xhr.status !== 401) {
                    $('#historyTable tbody').html('<tr><td colspan="7">Error loading history</td></tr>');
                }
            }
        });
    }

    function searchPatients() {
        var searchKeyword = $('#searchKeyword').val();
        var searchType = $('#searchType').val();
        
        $.ajax({
            url: '/searchPatients',
            type: 'GET',
            data: {
                searchKeyword: searchKeyword,
                searchType: searchTy`pe
            },
            success: function(response) {
                updatePatientTable(response);
            },
            error: function(xhr, status, error) {
                console.error('Error searching patients:', error);
                alert('환자 검색 중 오류가 발생했습니다.');
            }
        });
    }

    function updatePatientTable(patients) {
        var tbody = $('#patientTable tbody');
        tbody.empty();

        patients.forEach(function(patient) {
            var row = $('<tr>').addClass('patient-row').attr('data-pid', patient.pid).attr('data-pname', patient.pName);
            row.append($('<td>').addClass('table-cell text-center').append($('<input>').attr('type', 'checkbox')));
            row.append($('<td>').addClass('table-cell').text(patient.pid));
            row.append($('<td>').addClass('table-cell').text(patient.pName));
            row.append($('<td>').addClass('table-cell').text(patient.studyDate));
            row.append($('<td>').addClass('table-cell').text(patient.studyTime));
            row.append($('<td>').addClass('table-cell').text(patient.modality));
            row.append($('<td>').addClass('table-cell').text(patient.studyDesc));
            row.append($('<td>').addClass('table-cell').text(patient.seriesCnt));
            row.append($('<td>').addClass('table-cell').text(patient.imageCnt));
            tbody.append(row);
        });
    }
    
    function updateHistoryTable(historyData) {
        var tbody = $('#historyTable tbody');
        tbody.empty();

        historyData.forEach(function (item) {
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

    function initializeCalendar() {
        const calendarEl = document.getElementById('calendar');
        flatpickr(calendarEl, {
            inline: true,
            mode: "single",
            dateFormat: "Y-m-d",
            onChange: function(selectedDates, dateStr, instance) {
                if (selectedDates.length > 0) {
                    loadMemo(dateStr);
                } else {
                    console.log("No date selected.");
                }
            }
        });
    }

    function loadMemo(dateStr) {
        console.log("Loading memo for date:", dateStr);
        $.ajax({
            url: 'getSchedule',
            type: 'GET',
            data: { day: dateStr },
            success: function(response) {
                console.log("Server response:", response);
                if (response && response.detail) {
                    $('#memoTextarea').val(response.detail);
                } else {
                    console.log("No memo found for this date");
                    $('#memoTextarea').val('');
                }
            },
            error: function(xhr, status, error) {
                console.error('Error loading memo:', error);
                alert('메모 로딩 중 오류가 발생했습니다. 상태: ' + status + ', 오류: ' + error);
                $('#memoTextarea').val('');
            }
        });
    }

    function handleMemoSave() {
        const calendarEl = document.getElementById('calendar');
        const flatpickr = calendarEl._flatpickr;

        if (!flatpickr || !flatpickr.selectedDates.length) {
            alert('날짜를 선택해주세요.');
            return;
        }

        const selectedDate = flatpickr.selectedDates[0];
        const memo = $('#memoTextarea').val();

        console.log(selectedDate);
        const dateStr = formatDate(selectedDate);
        
        if (dateStr) {
            console.log("Saving memo for date:", selectedDate, "Content:", memo);
            saveMemo(dateStr, memo);
        } else {
            alert('유효한 날짜가 선택되지 않았습니다.');
        }
    }

    function saveMemo(dateStr, memo) {
        console.log("Saving memo for date:", dateStr, "Content:", memo);
        $.ajax({
            url: 'saveSchedule',
            type: 'POST',
            data: {
                day: dateStr,
                detail: memo
            },
            success: function(response) {
                console.log("Server response:", response);
                if (response === 'success') {
                    alert('메모가 저장되었습니다.');
                } else {
                    alert('메모 저장에 실패했습니다. 서버 응답: ' + response);
                }
            },
            error: function(xhr, status, error) {
                console.error('Error saving memo:', error);
                alert('메모 저장 중 오류가 발생했습니다. 상태: ' + status + ', 오류: ' + error);
            }
        });
    }

    function formatDate(date) {
        if (!(date instanceof Date) || isNaN(date)) {
            console.error("Invalid date object:", date);
            return null;
        }
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }

    function refreshToken() {
        return new Promise(function(resolve, reject) {
            $.ajax({
                url: '/refreshToken',
                type: 'POST',
                xhrFields: {
                    withCredentials: true
                },
                success: function(response) {
                    console.log('Token refreshed successfully');
                    resolve();
                },
                error: function(xhr, status, error) {
                    console.error('Token refresh failed:', error);
                    reject();
                }
            });
        });
    }

    function loadMemberManagement() {
        $.ajax({
            url: '/memberList',
            type: 'GET',
            success: function(response) {
                $('#content').html(response);
            },
            error: function(xhr, status, error) {
                console.error('Error loading member management:', error);
                alert('회원 관리 페이지 로딩 중 오류가 발생했습니다.');
            }
        });
    }


    function searchPatients() {
        var searchKeyword = $('#searchKeyword').val();
        var searchType = $('#searchType').val();
        
        $.ajax({
            url: '/searchPatients',
            type: 'GET',
            data: {
                searchKeyword: searchKeyword,
                searchType: searchType,
                page: currentPage
            },
            success: function(response) {
                updatePatientTable(response.patients);
                updatePagination(response.currentPage, response.totalPages);
            },
            error: function(xhr, status, error) {
                console.error('Error searching patients:', error);
                alert('환자 검색 중 오류가 발생했습니다.');
            }
        });
    }

    function updatePagination(currentPage, totalPages) {
        var paginationHtml = '';
        if (currentPage > 1) {
            paginationHtml += '<a href="#" onclick="changePage(' + (currentPage - 1) + ')">&laquo; 이전</a>';
        }
        for (var i = 1; i <= totalPages; i++) {
            if (i === currentPage) {
                paginationHtml += '<span class="current-page">' + i + '</span>';
            } else {
                paginationHtml += '<a href="#" onclick="changePage(' + i + ')">' + i + '</a>';
            }
        }
        if (currentPage < totalPages) {
            paginationHtml += '<a href="#" onclick="changePage(' + (currentPage + 1) + ')">다음 &raquo;</a>';
        }
        $('.pagination').html(paginationHtml);
    }

    function changePage(page) {
        currentPage = page;
        searchPatients();
    }
    
    function searchMembers() {
        var memberId = $('#memberId').val();
        var memberName = $('#memberName').val();
        
        $.ajax({
            url: '/searchMembers',
            type: 'GET',
            data: { id: memberId, name: memberName },
            success: function(response) {
                updateMemberTable(response);
            },
            error: function(xhr, status, error) {
                console.error('Error searching members:', error);
                alert('회원 검색 중 오류가 발생했습니다.');
            }
        });
    }

    function updateMemberTable(members) {
        var tbody = $('#memberTable tbody');
        tbody.empty();

        members.forEach(function(member) {
            var row = $('<tr>').addClass('member-row');
            row.append($('<td>').addClass('table-cell text-center').append($('<input>').attr('type', 'checkbox')));
            row.append($('<td>').addClass('table-cell').text(member.id));
            row.append($('<td>').addClass('table-cell').text(member.name));
            row.append($('<td>').addClass('table-cell').text(member.specialty));
            row.append($('<td>').addClass('table-cell').text(member.job));
            row.append($('<td>').addClass('table-cell').text(member.phoneNumber));
            row.append($('<td>').addClass('table-cell').text(member.email));
            row.append($('<td>').addClass('table-cell').text(member.role));
            tbody.append(row);
        });
    }
    </script>
</body>
</html>