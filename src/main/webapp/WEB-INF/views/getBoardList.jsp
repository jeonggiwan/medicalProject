<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>


<div class="search-section">
	<h2 class="search-title">공지사항</h2>
	<div class="search-inputs">
		<input type="text" id="searchKeyword" placeholder="검색어 입력"
			class="search-input"> <select id="searchType"
			class="search-input">
			<option value="TITLE">제목</option>
			<option value="CONTENT">내용</option>
		</select>
		<button class="search-button" onclick="searchBoards()">검색</button>
	</div>
	<div class="search-buttons">
		<sec:authorize access="hasRole('ROLE_ADMIN')">
			<button class="search-button search-button-blue"
				onclick="location.href='insertBoardPage'">글쓰기</button>
		</sec:authorize>
	</div>
	<div class="table-container">
		<table class="table" id="boardTable">
			<colgroup>
				<col class="col-seq">
				<col class="col-title">
				<col class="col-writer">
				<col class="col-regDate">
				<col class="col-cnt">
			</colgroup>
			<thead class="table-header">
				<tr>
					<th class="table-cell">번호</th>
					<th class="table-cell">제목</th>
					<th class="table-cell">작성자</th>
					<th class="table-cell">등록일</th>
					<th class="table-cell">조회수</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="board" items="${boardList}">
					<tr class="board-row">
						<td class="table-cell">${board.seq}</td>
						<td class="table-cell"><a href="getBoard?seq=${board.seq}">${board.title}</a></td>
						<td class="table-cell">${board.writer}</td>
						<td class="table-cell"><fmt:formatDate pattern="yyyy/MM/dd HH:mm:ss" value="${board.regDate}" /></td>
						<td class="table-cell">${board.cnt}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>

<script>
function searchBoards() {
    var searchKeyword = $('#searchKeyword').val();
    var searchType = $('#searchType').val();
    
    $.ajax({
        url: '/searchBoards',
        type: 'GET',
        data: {
            searchKeyword: searchKeyword,
            searchType: searchType
        },
        success: function(response) {
            updateBoardTable(response);
        },
        error: function(xhr, status, error) {
            console.error('Error searching boards:', error);
            alert('공지사항 검색 중 오류가 발생했습니다.');
        }
    });
}

function updateBoardTable(boards) {
    var tbody = $('#boardTable tbody');
    tbody.empty();

    boards.forEach(function(board) {
        var row = $('<tr>').addClass('board-row');
        row.append($('<td>').addClass('table-cell').text(board.seq));
        row.append($('<td>').addClass('table-cell').append($('<a>').attr('href', 'getBoard?seq=' + board.seq).text(board.title)));
        row.append($('<td>').addClass('table-cell').text(board.writer));
        row.append($('<td>').addClass('table-cell').text(new Date(board.RegDate).toLocaleString()));
        row.append($('<td>').addClass('table-cell').text(board.cnt));
        tbody.append(row);
    });
}
</script>