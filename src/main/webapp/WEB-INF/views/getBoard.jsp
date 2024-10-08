<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<div class="search-section">
	<div class="search-inputs">
		<label class="search-title"
			style="width: 80px; display: inline-block;">제목</label> <span
			style="margin-left: 10px; margin-top: 5px;">${board.title}</span>
	</div>
	<div class="search-inputs">
		<label class="search-title"
			style="width: 80px; display: inline-block;">작성자</label> <span
			style="margin-left: 10px; margin-top: 5px;">${board.writer}</span>
	</div>
	<div class="search-inputs">
		<div
			style="border: 1px solid #ccc; padding: 10px; margin-left: 10px; display: inline-block; width: calc(100% - 20px); overflow-wrap: break-word; word-wrap: break-word; word-break: break-all; max-height: 300px; overflow-y: auto;">
			${board.content}</div>
	</div>
	<div class="search-inputs">
		<label>등록시간</label> <span
			style="margin-left: 10px;"><fmt:formatDate
				pattern='yyyy/MM/dd HH:mm:ss' value='${board.regDate}' /></span>
	</div>
</div>
<div class="search-buttons">
	<a href="#" onclick="loadBoardList(); return false;"
		class="search-button search-button-blue">글목록</a> 
	<sec:authorize access="hasRole('ROLE_ADMIN')">
		<a href="#" onclick="deleteBoard(); return false;"
		class="search-button search-button-red">글 삭제</a>
	</sec:authorize>
</div>

<script>
function loadBoardList() {
    $.ajax({
        url: '/getBoardList',
        type: 'GET',
        success: function(response) {
            $('#content').html(response);
        },
        error: function(xhr, status, error) {
            console.error('Error loading board list:', error);
            alert('공지사항 목록 로딩 중 오류가 발생했습니다.');
        }
    });
}

function deleteBoard() {
    if (confirm('정말로 이 글을 삭제하시겠습니까?')) {
        $.ajax({
            url: '/deleteBoard',
            type: 'POST',
            data: { seq: '${board.seq}' },
            success: function(response) {
                alert('글이 성공적으로 삭제되었습니다.');
                loadBoardList(); // 글 목록을 로드하는 함수 호출
            },
            error: function(xhr, status, error) {
                console.error('글 삭제 중 오류 발생:', error);
                alert('글 삭제 중 오류가 발생했습니다.');
            }
        });
    }
}
</script>