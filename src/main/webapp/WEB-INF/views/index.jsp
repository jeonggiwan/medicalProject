<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PACSPLUS</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/CSS/index.css" rel="stylesheet">
</head>

<body class="bg-gray-100 text-gray-900">
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-logo">
                <img src="https://via.placeholder.com/40" alt="Logo" class="rounded-full">
            </div>
            <div class="sidebar-buttons">
                <button class="sidebar-button"></button>
                <button class="sidebar-button"></button>
                <button class="sidebar-button"></button>
                <button class="sidebar-button"></button>
            </div>
            <div class="sidebar-logout">
                <button id="logoutButton" class="logout-button">로그아웃</button>
            </div>
        </div>
        <!-- Main Content -->
        <div class="main-content">
            <header class="header">
                <h1 class="header-title">Mercy</h1>
                <div class="header-buttons">
                    <button class="header-button"></button>
                    <button class="header-button"></button>
                    <button class="header-button"></button>
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
                    <table class="table">
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
                                <th class="table-cell">Verify</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="study" items="${studyList}">
                                <tr>
                                    <td class="table-cell text-center"><input type="checkbox"></td>
                                    <td class="table-cell">${study.pid}</td>
                                    <td class="table-cell">${study.pName}</td>
                                    <td class="table-cell">${study.studyDate}</td>
                                    <td class="table-cell">${study.studyTime}</td>
                                    <td class="table-cell">${study.modality}</td>
                                    <td class="table-cell">${study.studyDesc}</td>
                                    <td class="table-cell">${study.seriesCnt}</td>
                                    <td class="table-cell">${study.imageCnt}</td>
                                    <td class="table-cell"><button class="verify-button">Verify</button></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="grid-container">
                    <div>
                        <h2 class="search-title">과거 검사 이력</h2>
                        <div class="search-inputs">
                            <input type="text" placeholder="환자 아이디" class="search-input">
                            <input type="text" placeholder="환자 이름" class="search-input">
                        </div>
                        <table class="table">
                            <thead class="table-header">
                                <tr>
                                    <th class="table-cell">검사실비</th>
                                    <th class="table-cell">검사실명</th>
                                    <th class="table-cell">검사실실</th>
                                    <th class="table-cell">판독상태</th>
                                    <th class="table-cell">시리즈</th>
                                    <th class="table-cell">이미지</th>
                                    <th class="table-cell">Verify</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="table-cell">12345</td>
                                    <td class="table-cell">홍길동</td>
                                    <td class="table-cell">A</td>
                                    <td class="table-cell">완료</td>
                                    <td class="table-cell">3</td>
                                    <td class="table-cell">5</td>
                                    <td class="table-cell"><button class="verify-button">Verify</button></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div>
                        <h2 class="search-title">리포트</h2>
                        <div>
                            <textarea placeholder="코멘트" class="textarea"></textarea>
                            <textarea placeholder="문제" class="textarea"></textarea>
                            <textarea placeholder="결론" class="textarea"></textarea>
                        </div>
                        <div>
                            <select class="select">
                                <option>Common</option>
                            </select>
                            <select class="select">
                                <option>Report Code</option>
                            </select>
                            <input type="text" placeholder="에디터아이디" class="search-input">
                            <input type="text" placeholder="판독의" class="search-input">
                            <input type="text" placeholder="판독시간" class="search-input">
                        </div>
                        <div class="button-container">
                            <button class="search-button">취소</button>
                            <button class="search-button search-button-red">저장</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
    $('#logoutButton').click(function() {
        $.ajax({
            url: '/logout',
            type: 'POST',
            xhrFields: {
                withCredentials: true
            },
            success: function(response) {
                console.log('Logout successful');
                document.cookie = "REFRESH_TOKEN=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
                localStorage.removeItem('accessToken'); // 액세스 토큰 제거
                window.location.href = '/login';
            },
            error: function(xhr, status, error) {
                console.error('Logout failed:', error);
                alert('로그아웃 중 오류가 발생했습니다.');
            }
        });
    });
    </script>
</body>

</html>