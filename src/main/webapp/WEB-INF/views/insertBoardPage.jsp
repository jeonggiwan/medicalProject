<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>새글 등록</title>
</head>
<body>
<c:out value="${_csrf.token}"/>
	<h1>글 등록</h1>
	<hr>
	<form action="insertBoard" method="post">
		<table border="1">
			<tr>
				<td>제목</td>
				<td><input type="text" name="title"></td>
			</tr>
			<tr>
				<td>작성자</td>
				<td><sec:authentication property="principal.username"
						var="userId" /> <input type="text" name="writer"
					value="${userId}" readonly></td>
			</tr>
			<tr>
				<td>내용</td>
				<td><textarea name="content" cols="40" rows="10"></textarea></td>
			</tr>
		</table>
		<input type="hidden" name="${_csrf.parameterName}"
			value="${_csrf.token}" /> <input type="submit" value=" 새글 등록 " />
	</form>
	<hr>
	<a href="getBoardList">글 목록 가기</a>
</body>
</html>