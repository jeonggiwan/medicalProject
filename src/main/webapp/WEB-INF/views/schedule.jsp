<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="sidebar">
    <h1 class="sidebar-title">일정</h1>
    <div class="calendar-container">
        <div id="calendar" class="calendar"></div>
    </div>
    <button id="saveButton" class="save-button">저장</button>
    <div class="memo-container">
        <textarea id="memoTextarea" class="memo-textarea" placeholder="메모를 입력하세요..."></textarea>
    </div>
</div>

<script>
function getScheduleDates() {
    return new Promise((resolve, reject) => {
        $.ajax({
            url: 'getScheduleDates',
            type: 'GET',
            success: function(dates) {
                const adjustedDates = dates.map(date => {
                    const d = new Date(date);
                    d.setDate(d.getDate() - 1);
                    return d.toISOString().split('T')[0];
                });
                resolve(adjustedDates);
            },
            error: function(xhr, status, error) {
                console.error('Error loading schedule dates:', error);
                reject(error);
            }
        });
    });
}

function initializeCalendar() {
    const calendarEl = document.getElementById('calendar');
    
    getScheduleDates().then(dates => {
        const fp = flatpickr(calendarEl, {
            inline: true,
            mode: "single",
            dateFormat: "Y-m-d",
            defaultDate: 'today',
            onChange: function(selectedDates, dateStr, instance) {
                if (selectedDates.length > 0) {
                    loadMemo(dateStr);
                } else {
                    console.log("No date selected.");
                }
            },
            onDayCreate: function(dObj, dStr, fp, dayElem) {
                const currentDate = dayElem.dateObj.toISOString().split('T')[0];
                if (dates.includes(currentDate)) {
                    dayElem.innerHTML += "<span class='event-dot'></span>";
                }
                
                if (dayElem.classList.contains('today')) {
                    dayElem.classList.remove('today');
                }
            }
        });

        loadMemo(fp.formatDate(new Date(), "Y-m-d"));
    }).catch(error => {
        console.error('Failed to initialize calendar:', error);
        flatpickr(calendarEl, {
            inline: true,
            mode: "single",
            dateFormat: "Y-m-d",
            defaultDate: 'today',
            onChange: function(selectedDates, dateStr, instance) {
                if (selectedDates.length > 0) {
                    loadMemo(dateStr);
                } else {
                    console.log("No date selected.");
                }
            }
        });
    });
}

function loadMemo(dateStr) {
    console.log("Loading memo for date:", dateStr);
    $.ajax({
        url: 'getSchedule',
        type: 'GET',
        data: { day: dateStr },
        success: function(response) {
            console.log("Server response:", response);
            if (response && response.detail) {
                $('#memoTextarea').val(response.detail);
            } else {
                console.log("No memo found for this date");
                $('#memoTextarea').val('');
            }
        },
        error: function(xhr, status, error) {
            console.error('Error loading memo:', error);
            alert('메모 로딩 중 오류가 발생했습니다. 상태: ' + status + ', 오류: ' + error);
            $('#memoTextarea').val('');
        }
    });
}

function handleMemoSave() {
    const calendarEl = document.getElementById('calendar');
    const flatpickr = calendarEl._flatpickr;

    if (!flatpickr || !flatpickr.selectedDates.length) {
        alert('날짜를 선택해주세요.');
        return;
    }

    const selectedDate = flatpickr.selectedDates[0];
    const memo = $('#memoTextarea').val();

    if (selectedDate) {
        console.log("Saving memo for date:", selectedDate, "Content:", memo);
        saveMemo(selectedDate, memo).then(() => {
            initializeCalendar();
        });
    } else {
        alert('유효한 날짜가 선택되지 않았습니다.');
    }
}

function saveMemo(dateStr, memo) {
    return new Promise((resolve, reject) => {
        console.log("Saving memo for date:", dateStr, "Content:", memo);
        $.ajax({
            url: 'saveSchedule',
            type: 'POST',
            data: {
                day: dateStr,
                detail: memo
            },
            success: function(response) {
                console.log("Server response:", response);
                if (response === 'success') {
                    alert('메모가 저장되었습니다.');
                    resolve();
                } else {
                    alert('메모 저장에 실패했습니다. 서버 응답: ' + response);
                    reject();
                }
            },
            error: function(xhr, status, error) {
                console.error('Error saving memo:', error);
                alert('메모 저장 중 오류가 발생했습니다. 상태: ' + status + ', 오류: ' + error);
                reject();
            }
        });
    });
}

$(document).ready(function() {
    initializeCalendar();
    $('#saveButton').click(handleMemoSave);
});

$('<style>')
    .prop('type', 'text/css')
    .html(`
        .event-dot {
            width: 5px;
            height: 5px;
            border-radius: 50%;
            background-color: #3788d8;
            position: absolute;
            bottom: 2px;
            left: 50%;
            transform: translateX(-50%);
        }
    `)
    .appendTo('head');
</script>