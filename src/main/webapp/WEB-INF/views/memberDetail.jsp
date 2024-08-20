<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 목록</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/memberDetail.css">
</head>
<body>
    <div class="container">
        <h1>회원 목록</h1>
        <div class="search-section">
            <input type="text" id="memberId" placeholder="아이디" class="search-input">
            <input type="text" id="memberName" placeholder="이름" class="search-input">
            <button class="search-button" onclick="searchMembers()">검색</button>
        </div>
        <div class="table-container">
            <table class="member-table">
                <thead>
                    <tr>
                        <th>선택</th>
                        <th>회원 ID</th>
                        <th>이름</th>
                        <th>분야</th>
                        <th>직업</th>
                        <th>전화번호</th>
                        <th>이메일</th>
                        <th>권한</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="member" items="${memberList}">
                        <tr>
                            <td><input type="checkbox" name="selectedMember" value="${member.id}"></td>
                            <td>${member.id}</td>
                            <td>${member.name}</td>
                            <td>${member.specialty}</td>
                            <td>${member.job}</td>
                            <td>${member.phoneNumber}</td>
                            <td>${member.email}</td>
                            <td>${member.role}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        <div class="pagination">
            <!-- 페이지네이션 버튼들을 여기에 추가 -->
        </div>
    </div>
    
    <script>
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
            }
        });
    }
    </script>
</body>
</html>