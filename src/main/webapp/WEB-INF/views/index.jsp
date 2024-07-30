<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Main Page</title>
</head>
<body>
    <h1>게시판 프로그램</h1>
    <sec:authorize access="isAuthenticated()">
        <p>Welcome, <sec:authentication property="name" />!</p>
        <a href="<c:url value='/getBoardList'/>">글 목록 바로가기</a><br><br>
        <form action="<c:url value='/logout'/>" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <button type="submit">Logout</button>
        </form>
    </sec:authorize>
    <sec:authorize access="!isAuthenticated()">
        <a href="<c:url value='/login'/>">Login</a>
    </sec:authorize>
</body>
</html>