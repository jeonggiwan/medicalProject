<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="search-section">
	<h2 class="search-title">회원 목록</h2>
	<div class="search-inputs">
		<input type="text" id="searchKeyword" placeholder="검색어 입력"
			class="search-input"> <select id="searchType"
			class="search-input">
			<option value="id">회원 아이디</option>
			<option value="name">회원 이름</option>
		</select>
		<button class="search-button" onclick="searchMembers()">검색</button>
	</div>
	<div class="search-buttons">
		<button class="search-button search-button-red"
			onclick="deleteSelectedMembers()">회원삭제</button>
	</div>
	<div class="table-container">
		<table class="table" id="memberTable">
			<colgroup>
				<col class="col-checkbox">
				<col class="col-id">
				<col class="col-name">
				<col class="col-specialty">
				<col class="col-job">
				<col class="col-phone">
				<col class="col-email">
				<col class="col-role">
			</colgroup>
			<thead class="table-header">
				<tr>
					<th class="table-cell">선택</th>
					<th class="table-cell">회원 ID</th>
					<th class="table-cell">이름</th>
					<th class="table-cell">분야</th>
					<th class="table-cell">직업</th>
					<th class="table-cell">전화번호</th>
					<th class="table-cell">이메일</th>
					<th class="table-cell">권한</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="member" items="${memberList}">
					<tr class="member-row">
						<td class="table-cell text-center"><input type="checkbox"
							class="member-checkbox" data-id="${member.id}"
							data-role="${member.role}"></td>
						<td class="table-cell">${member.id}</td>
						<td class="table-cell">${member.name}</td>
						<td class="table-cell">${member.specialty}</td>
						<td class="table-cell">${member.job}</td>
						<td class="table-cell">${member.phoneNumber}</td>
						<td class="table-cell">${member.email}</td>
						<td class="table-cell">${member.role}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>

<script>
function searchMembers() {
    var searchKeyword = $('#searchKeyword').val();
    var searchType = $('#searchType').val();
    
    $.ajax({
        url: '/searchMembers',
        type: 'GET',
        data: {
            searchKeyword: searchKeyword,
            searchType: searchType
        },
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

function deleteSelectedMembers() {
    var selectedIds = [];
    $('.member-checkbox:checked').each(function() {
        if ($(this).data('role') !== 'ADMIN') {
            selectedIds.push($(this).data('id'));
        }
    });

    if (selectedIds.length === 0) {
        alert('삭제할 회원을 선택해주세요. (ADMIN은 삭제할 수 없습니다)');
        return;
    }

    if (confirm('선택한 회원을 삭제하시겠습니까?')) {
        $.ajax({
            url: '/deleteMembers',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(selectedIds),
            success: function(response) {
                alert('선택한 회원이 삭제되었습니다.');
                searchMembers(); // 회원 목록 새로고침
            },
            error: function(xhr, status, error) {
                console.error('Error deleting members:', error);
                alert('회원 삭제 중 오류가 발생했습니다.');
            }
        });
    }
}
</script>