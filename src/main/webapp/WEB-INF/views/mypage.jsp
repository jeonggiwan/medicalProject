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
        <div class="mypage-actions mt-6">
            <button id="changePasswordBtn" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded mr-2">
                비밀번호 변경
            </button>
            <button id="deleteAccountBtn" class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded">
                계정 삭제
            </button>
        </div>
    </div>
</div>

<!-- 비밀번호 변경 모달 -->
<div id="passwordModal" class="modal hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full">
    <div class="modal-content relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
        <div id="currentPasswordStep">
            <h2 class="text-xl mb-4">현재 비밀번호 확인</h2>
            <input type="password" id="currentPassword" class="border rounded w-full py-2 px-3 mb-4" placeholder="현재 비밀번호">
            <button id="confirmCurrentPassword" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                확인
            </button>
        </div>
        <div id="newPasswordStep" class="hidden">
            <h2 class="text-xl mb-4">새 비밀번호 설정</h2>
     <input type="password" id="newPassword" class="border rounded w-full py-2 px-3 mb-2" placeholder="새 비밀번호 (8자리 이상)">
<input type="password" id="confirmNewPassword" class="border rounded w-full py-2 px-3 mb-4" placeholder="새 비밀번호 확인 (8자리 이상)">
            <button id="changePassword" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                변경
            </button>
        </div>
        <button id="closeModal" class="absolute top-3 right-3 text-gray-600 hover:text-gray-900">
            &times;
        </button>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        const modal = $("#passwordModal");
        const changePasswordBtn = $("#changePasswordBtn");
        const deleteAccountBtn = $("#deleteAccountBtn");
        const closeModal = $("#closeModal");
        const confirmCurrentPassword = $("#confirmCurrentPassword");
        const changePassword = $("#changePassword");
        const currentPasswordStep = $("#currentPasswordStep");
        const newPasswordStep = $("#newPasswordStep");

        changePasswordBtn.on('click', function() {
            modal.removeClass('hidden');
            currentPasswordStep.removeClass('hidden');
            newPasswordStep.addClass('hidden');
        });

        closeModal.on('click', function() {
            modal.addClass('hidden');
        });

        confirmCurrentPassword.on('click', function() {
            const currentPassword = $("#currentPassword").val();
            $.ajax({
                url: '/verifyCurrentPassword',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ currentPassword: currentPassword }),
                success: function(data) {
                    if (data.isValid) {
                        currentPasswordStep.addClass('hidden');
                        newPasswordStep.removeClass('hidden');
                    } else {
                        alert('현재 비밀번호가 올바르지 않습니다.');
                    }
                },
                error: function() {
                    alert('비밀번호 확인 중 오류가 발생했습니다.');
                }
            });
        });

        changePassword.on('click', function() {
            const newPassword = $("#newPassword").val();
            const confirmNewPassword = $("#confirmNewPassword").val();

            if (newPassword.length < 8 || confirmNewPassword.length < 8) {
                alert('새 비밀번호는 8자리 이상이어야 합니다.');
                return;
            }
            
            if (newPassword !== confirmNewPassword) {
                alert('새 비밀번호가 일치하지 않습니다.');
                return;
            }

            $.ajax({
                url: '/changePassword',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ newPassword: newPassword }),
                success: function(data) {
                    if (data.success) {
                        alert('비밀번호가 성공적으로 변경되었습니다.');
                        modal.addClass('hidden');
                    } else {
                        alert('비밀번호 변경에 실패했습니다.');
                    }
                },
                error: function() {
                    alert('비밀번호 변경 중 오류가 발생했습니다.');
                }
            });
        });
        deleteAccountBtn.on('click', function() {
            if (confirm('정말로 계정을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
                $.ajax({
                    url: '/deleteAccount',
                    type: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    success: function(response) {
                        console.log("Success response:", response);
                        alert(response.message);
                        window.location.href = '/login';
                    },
                    error: function(xhr, status, error) {
                        console.log("Error status:", status);
                        console.log("Error:", error);
                        console.log("Response Text:", xhr.responseText);
                        var errorMessage = '계정 삭제 중 오류가 발생했습니다.';
                        try {
                            var responseJson = JSON.parse(xhr.responseText);
                            errorMessage = responseJson.message || errorMessage;
                        } catch (e) {
                            console.log("Error parsing JSON:", e);
                        }
                        alert(errorMessage);
                    }
                });
            }
        });
    });
</script>