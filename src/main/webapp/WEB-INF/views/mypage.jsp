<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="container mx-auto px-4 py-8">
    <h1 class="search-title">My Page</h1>
    <div class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4">
        <div class="mb-4">
            <label class="block text-gray-700 text-sm font-bold mb-2" for="name">
                이름
            </label>
            <p class="text-gray-900">${member.name}</p>
        </div>
        <div class="mb-4">
            <label class="block text-gray-700 text-sm font-bold mb-2" for="role">
                권한
            </label>
            <p class="text-gray-900">${member.role}</p>
        </div>
        <div class="mb-4">
            <label class="block text-gray-700 text-sm font-bold mb-2" for="specialty">
                분야
            </label>
            <p class="text-gray-900">${member.specialty}</p>
        </div>
        <div class="mb-4">
            <label class="block text-gray-700 text-sm font-bold mb-2" for="phoneNumber">
                핸드폰 번호
            </label>
            <p class="text-gray-900">${member.phoneNumber}</p>
        </div>
        <div class="mb-4">
            <label class="block text-gray-700 text-sm font-bold mb-2" for="email">
                이메일
            </label>
            <p class="text-gray-900">${member.email}</p>
        </div>
        <div class="mb-4">
            <label class="block text-gray-700 text-sm font-bold mb-2" for="job">
                직업
            </label>
            <p class="text-gray-900">${member.job}</p>
        </div>
    </div>
</div>