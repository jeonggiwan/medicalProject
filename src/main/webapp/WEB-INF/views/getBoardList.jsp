<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="search-section">
    <h2 class="search-title">공지사항</h2>
    <div class="table-container">
        <table class="table" id="boardTable">
            <colgroup>
                <col style="width: 5%;">  <!-- 글번호 -->
                <col style="width: 50%;">  <!-- 제목 -->
                <col style="width: 10%;">  <!-- 작성자 -->
                <col style="width: 20%;">  <!-- 등록일 -->
            </colgroup>
            <thead class="table-header">
                <tr>
                    <th class="table-cell">글번호</th>
                    <th class="table-cell">제목</th>
                    <th class="table-cell">작성자</th>
                    <th class="table-cell">등록일</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="board" items="${boardList}" varStatus="status">
                    <c:if test="${status.index < 6}">
                        <tr class="board-row" onclick="loadBoardDetail(${board.seq});">
                            <td class="table-cell" style="text-align: center;">${board.seq}</td>
                            <td class="table-cell" style="text-align: left; cursor: pointer;">
                                <span style="color: black;">${board.title}</span>
                            </td>
                            <td class="table-cell" style="text-align: center;">${board.writer}</td>
                            <td class="table-cell" style="text-align: center;"><fmt:formatDate pattern="yyyy/MM/dd HH:mm:ss" value="${board.regDate}" /></td>
                        </tr>
                    </c:if>
                </c:forEach>
            </tbody>
        </table>
    </div>
    <div class="search-buttons" style="text-align: right; margin-top: 10px;">
        <sec:authorize access="hasRole('ROLE_ADMIN')">
            <button class="search-button search-button-blue" onclick="loadInsertBoardPage()">글쓰기</button>
        </sec:authorize>
    </div>
</div>

<script>
function loadBoardDetail(seq) {
    $.ajax({
        url: '/getBoard',
        type: 'GET',
        data: { seq: seq },
        success: function(response) {
            $('#content').html(response);
        },
        error: function(xhr, status, error) {
            console.error('게시글 상세 정보 로딩 중 오류:', error);
            alert('게시글 로딩 중 오류가 발생했습니다.');
        }
    });
}

function loadInsertBoardPage() {
    $.ajax({
        url: '/insertBoardPage',
        type: 'GET',
        success: function(response) {
            $('#content').html(response);
        },
        error: function(xhr, status, error) {
            console.error('글쓰기 페이지 로딩 중 오류:', error);
            alert('글쓰기 페이지를 불러오는 중 오류가 발생했습니다.');
        }
    });
}

function loadPage(page) {
    $.ajax({
        url: '/getBoardList',
        type: 'GET',
        data: { page: page },
        success: function(response) {
            $('#content').html(response);
        },
        error: function(xhr, status, error) {
            console.error('페이지 로딩 중 오류:', error);
            alert('페이지를 불러오는 중 오류가 발생했습니다.');
        }
    });
}
</script>