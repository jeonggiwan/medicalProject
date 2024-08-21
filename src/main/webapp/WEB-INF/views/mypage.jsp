<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="mypage-container">
    <h1 class="search-title">My Page</h1>
    <div class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4">
        <div class="mypage-item">
            <span class="mypage-label">이름:</span>
            <span class="mypage-value">${member.name}</span>
        </div>
        <div class="mypage-item">
            <span class="mypage-label">권한:</span>
            <span class="mypage-value">${member.role}</span>
        </div>
        <div class="mypage-item">
            <span class="mypage-label">분야:</span>
            <span class="mypage-value">${member.specialty}</span>
        </div>
        <div class="mypage-item">
            <span class="mypage-label">핸드폰 번호:</span>
            <span class="mypage-value">${member.phoneNumber}</span>
        </div>
        <div class="mypage-item">
            <span class="mypage-label">이메일:</span>
            <span class="mypage-value">${member.email}</span>
        </div>
        <div class="mypage-item">
            <span class="mypage-label">직업:</span>
            <span class="mypage-value">${member.job}</span>
        </div>
    </div>
</div>