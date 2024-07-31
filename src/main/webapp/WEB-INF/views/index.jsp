<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PACSPLUS</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
        }
        .container {
            display: flex;
            height: 100vh;
        }
        .sidebar {
            background-color: #1F2937;
            color: white;
            width: 4rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-top: 1rem;
            padding-bottom: 1rem;
        }
        .sidebar-logo {
            margin-bottom: 1rem;
        }
        .sidebar-buttons {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }
        .sidebar-button {
            width: 2.5rem;
            height: 2.5rem;
            background-color: #EF4444;
            border-radius: 9999px;
        }
        .main-content {
            flex: 1;
            padding: 1rem;
        }
        .header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1rem;
        }
        .header-title {
            font-size: 1.5rem;
            font-weight: bold;
        }
        .header-buttons {
            display: flex;
            gap: 1rem;
        }
        .header-button {
            width: 2rem;
            height: 2rem;
            background-color: #D1D5DB;
            border-radius: 9999px;
        }
        .content {
            background-color: white;
            padding: 1rem;
            border-radius: 0.5rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
        }
        .search-section {
            margin-bottom: 1rem;
        }
        .search-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        .search-inputs {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
        }
        .search-input {
            border: 1px solid #D1D5DB;
            border-radius: 0.25rem;
            padding: 0.25rem 0.5rem;
        }
        .search-buttons {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }
        .search-button {
            padding: 0.5rem 1rem;
            background-color: #E5E7EB;
            border-radius: 0.25rem;
        }
        .search-button-red {
            background-color: #EF4444;
            color: white;
        }
        .table {
            width: 100%;
            border: 1px solid #D1D5DB;
        }
        .table-header {
            background-color: #E5E7EB;
        }
        .table-cell {
            border: 1px solid #D1D5DB;
            padding: 0.25rem 0.5rem;
        }
        .verify-button {
            background-color: #3B82F6;
            color: white;
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
        }
        .grid-container {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
        }
        .textarea {
            border: 1px solid #D1D5DB;
            border-radius: 0.25rem;
            padding: 0.25rem 0.5rem;
            margin-bottom: 0.5rem;
            width: 100%;
            height: 6rem;
        }
        .select {
            border: 1px solid #D1D5DB;
            border-radius: 0.25rem;
            padding: 0.25rem 0.5rem;
            margin-bottom: 0.5rem;
            width: 100%;
        }
        .button-container {
            display: flex;
            justify-content: flex-end;
            gap: 0.5rem;
        }
    </style>
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
                                <th class="table-cell">환자 아이디</th>
                                <th class="table-cell">환자 이름</th>
                                <th class="table-cell">검사실</th>
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
                                <td class="table-cell text-center"><input type="checkbox"></td>
                                <td class="table-cell">12345</td>
                                <td class="table-cell">홍길동</td>
                                <td class="table-cell">A</td>
                                <td class="table-cell">검사실1</td>
                                <td class="table-cell">검사실2</td>
                                <td class="table-cell">완료</td>
                                <td class="table-cell">3</td>
                                <td class="table-cell">5</td>
                                <td class="table-cell"><button class="verify-button">Verify</button></td>
                            </tr>
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
</body>

</html>
