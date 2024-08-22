<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="content">
    <div class="search-section">
        <h2 class="search-title">글 등록</h2>
        <form action="insertBoard" method="post" name="board" id="insertBoardForm">
            <div class="search-inputs">
                <label for="title" class="search-title" style="width: 100px;">제목</label>
                <input type="text" id="title" name="title" class="search-input" style="flex: 1;">
            </div>
            <div class="search-inputs">
                <label for="writer" class="search-title" style="width: 100px;">작성자</label>
                <input type="text" id="writer" name="writer" class="search-input" style="flex: 1;">
            </div>
            <div class="search-inputs">
                <label for="content" class="search-title" style="width: 100px;">내용</label>
                <textarea id="content" name="content" rows="6" class="search-input" style="flex: 1;"></textarea>
            </div>

            <div class="search-buttons">
                <button type="submit" class="search-button search-button-blue">새글 등록</button>
                <a href="#" onclick="loadBoardList()" class="search-button">글 목록 가기</a>
            </div>
        </form>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    $('#insertBoardForm').submit(function(e) {
        e.preventDefault();
        var formData = {
            title: $('#title').val(),
            writer: $('#writer').val(),
            content: $('#content').val()
        };

        $.ajax({
            type: 'POST',
            url: 'insertBoard',
            contentType: 'application/json',
            data: JSON.stringify(formData),
            success: function(response) {
                if(response.success) {
                    alert('글이 성공적으로 등록되었습니다.');
                    loadBoardList();
                } else {
                    alert('글 등록에 실패했습니다.');
                }
            },
            error: function(xhr, status, error) {
                console.error('Error:', error);
                alert('오류가 발생했습니다.');
            }
        });
    });
});

function loadBoardList() {
    fetch('getBoardList')
    .then(response => response.text())
    .then(html => {
        document.getElementById('content').innerHTML = html;
    })
    .catch(error => {
        console.error('Error:', error);
        alert('글 목록을 불러오는 데 실패했습니다.');
    });
}
</script>