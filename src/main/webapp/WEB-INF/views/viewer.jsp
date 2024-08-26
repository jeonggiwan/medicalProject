<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DICOM Viewer</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="../CSS/viewer.css">
    <script src="https://unpkg.com/hammerjs@2.0.8/hammer.js"></script>
    <script src="https://unpkg.com/dicom-parser/dist/dicomParser.js"></script>
    <script src="https://unpkg.com/cornerstone-core"></script>
    <script src="https://unpkg.com/cornerstone-math"></script>
    <script src="https://unpkg.com/cornerstone-wado-image-loader"></script>
    <script src="https://unpkg.com/cornerstone-tools"></script>
    <link rel="stylesheet" href="../CSS/dicom.css">
    <link rel="stylesheet" href="../CSS/menu.css">
</head>
<body>
    <%@ include file="menu.jsp" %>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <button id="button1" class="sidebar-button">BACK</button>
            <button id="button2" class="sidebar-button">THUMBNAIL</button>
            <button id="button3" class="sidebar-button">REPORT</button>
        </div>
        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Bar -->
            <div class="top-bar">
                <a href="edge?pid=${pid}&studyDate=${studyDate}" class="top-bar-button">Edge Detection</a>
                <button id="activateBrush" class="top-bar-button">Activate Brush</button>
            </div>
            <div id="dicom" class="cornerstone-element" oncontextmenu="return false" style="width:512px;height:512px;border:1px solid black;"></div>
        </div>
        <!-- Image Container with Pagination -->
        <div class="image-container-wrapper" id="imageContainerWrapper">
            <!-- Pagination Controls -->
            <div class="pagination-controls">
                <button id="prevPageBtn" onclick="prevPage()">&#9664;</button>
                <div id="paginationText">Page 1</div>
                <button id="nextPageBtn" onclick="nextPage()">&#9654;</button>
            </div>
            <!-- Image Container -->
            <div id="imageContainer" class="image-container"></div>
        </div>
    </div>
    
        <!-- Report Modal -->
    <div id="reportModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>Patient Report</h2>
            <p>Patient Name: <span id="modalPname"></span></p>
            <p>Patient ID: <span id="modalPid"></span></p>
            <p>Doctor: <span id="modalDoctor"></span></p>
            <textarea id="modalReport" rows="10" cols="50"></textarea>
            <br>
            <button id="saveReport">Save</button>
            <button id="closeModal">Close</button>
        </div>
    </div>
 <script>
let currentPage = 1;
const itemsPerPage = 5;
let element; // 전역 변수로 선언

$(document).ready(function() {
    _init();
});

function _init(){
    cornerstoneWADOImageLoader.external.dicomParser = dicomParser;
    cornerstoneWADOImageLoader.external.cornerstone = cornerstone;
    const config = {
        webWorkerPath: `https://tools.cornerstonejs.org/examples/assets/image-loader/cornerstoneWADOImageLoaderWebWorker.js`,
        taskConfiguration: {
            decodeTask: {
                codecsPath: `https://tools.cornerstonejs.org/examples/assets/image-loader/cornerstoneWADOImageLoaderCodecs.js`,
            },
        },
    }
    cornerstoneWADOImageLoader.webWorkerManager.initialize(config);

    cornerstoneTools.external.cornerstone = cornerstone;

    const segModule = cornerstoneTools.getModule("segmentation");
    segModule.configuration.fillAlpha = 0.5;
    segModule.configuration.fillAlphaInactive = 0;
    segModule.configuration.renderOutline = true;
    cornerstoneTools.init({
        showSVGCursors: true,
    })

    cornerstoneTools.toolStyle.setToolWidth(2)
    cornerstoneTools.toolColors.setToolColor("rgb(255, 255, 0)")
    cornerstoneTools.toolColors.setActiveColor("rgb(0, 255, 0)")
    cornerstoneTools.store.state.touchProximity = 40

    element = document.getElementById("dicom");
    if (!element) {
        console.error("DICOM element not found");
        return;
    }
    
    if (imageIds && imageIds.length > 0) {
        display(element, imageIds);
    } else {
        console.error("No image IDs available");
    }
    
    cornerstoneTools.addToolForElement(
        element,
        cornerstoneTools.BrushTool,
        {configuration : { radius: 10 }}
    );
}

function activateBrushTool() {
    const BrushTool = cornerstoneTools.BrushTool;
    cornerstoneTools.addTool(BrushTool);
    
    cornerstoneTools.setToolActive('Brush', {
        mouseButtonMask: 1,
    });
}

const dicomFiles = [];
<c:forEach var="file" items="${dicomFileNames}" varStatus="status">
    dicomFiles.push({
        fileName: '${file}',
        elementId: 'dicomImage${status.index}'
    });
</c:forEach>

const imageIds = dicomFiles.map(dicomFile => {
    return 'wadouri:${pageContext.request.contextPath}/dicom/' + 
        '${study.studyDate.substring(0,6)}/${study.studyDate.substring(6,8)}/${study.pid}/${study.modality}/${study.seriesNum}/' + 
        dicomFile.fileName;
});

const display = async(element, imageIds) => {
    cornerstone.enable(element);
    const image = await cornerstone.loadAndCacheImage(imageIds[0]);
    cornerstone.displayImage(element, image);      
    
    cornerstoneTools.addStackStateManager(element, ["stack"]);
    cornerstoneTools.addToolState(element, "stack", {
        imageIds: [...imageIds],
        currentImageIdIndex: 0,
    });
    cornerstoneTools.addToolForElement(
        element,
        cornerstoneTools["StackScrollMouseWheelTool"],
        {configuration: {loop:true}}
    );
    
    cornerstoneTools.setToolActive("StackScrollMouseWheel", {});
    return Promise.all(
        imageIds.map((imageId) => cornerstone.loadAndCacheImage(imageId)),
    );
} 

const displayMultipleImages = async (container, imageIds, page = 1, itemsPerPage = 5) => {
    container.innerHTML = ''; // Clear previous content
    const startIndex = (page - 1) * itemsPerPage;
    const endIndex = Math.min(startIndex + itemsPerPage, imageIds.length);
    
    for (let i = startIndex; i < endIndex; i++) {
        const imgElement = document.createElement('div');
        imgElement.style.width = '150px';
        imgElement.style.height = '150px';
        imgElement.style.border = '1px solid black';
        imgElement.style.marginBottom = '5px';
        imgElement.style.cursor = 'pointer';
        container.appendChild(imgElement);
        
        cornerstone.enable(imgElement);
        const image = await cornerstone.loadAndCacheImage(imageIds[i]);
        cornerstone.displayImage(imgElement, image);

        imgElement.addEventListener('click', function() {
            displayMainImage(imageIds[i]);
        });
    }
    updatePaginationControls(page, imageIds.length);
};

const displayMainImage = async (imageId) => {
    const mainViewer = document.getElementById('dicom');
    const image = await cornerstone.loadAndCacheImage(imageId);
    cornerstone.displayImage(mainViewer, image);
};

const updatePaginationControls = (page, totalItems) => {
    const totalPages = Math.ceil(totalItems / itemsPerPage);
    document.getElementById('prevPageBtn').disabled = page <= 1;
    document.getElementById('nextPageBtn').disabled = page >= totalPages;
    document.getElementById('paginationText').textContent = page.toString();
};

const prevPage = async () => {
    if (currentPage > 1) {
        currentPage--;
        const imageContainer = document.getElementById('imageContainer');
        await displayMultipleImages(imageContainer, imageIds, currentPage);
    }
};

const nextPage = async () => {
    const totalPages = Math.ceil(imageIds.length / itemsPerPage);
    if (currentPage < totalPages) {
        currentPage++;
        const imageContainer = document.getElementById('imageContainer');
        await displayMultipleImages(imageContainer, imageIds, currentPage);
    }
};

function openReportModal() {
    const modal = document.getElementById('reportModal');
    const span = document.getElementsByClassName("close")[0];
    const closeButton = document.getElementById("closeModal");

    const studyKey = '${study.studyKey}';
    const studyDate = '${study.studyDate}';

    console.log('studyKey:', studyKey);
    console.log('studyDate:', studyDate);

    if (!studyKey || !studyDate) {
        console.error('studyKey or studyDate is missing');
        alert('Unable to fetch patient report. Missing information.');
        return;
    }

    $.ajax({
        url: '/getPatientReport',
        method: 'GET',
        data: {
            studyKey: studyKey,
            studyDate: studyDate
        },
        success: function(data) {
            console.log('Received data:', data);
            document.getElementById('modalPname').textContent = data.pname;
            document.getElementById('modalPid').textContent = data.pid;
            document.getElementById('modalDoctor').textContent = data.doctor;
            document.getElementById('modalReport').value = data.report;
            modal.style.display = "block";
        },
        error: function(jqXHR, textStatus, errorThrown) {
            console.error('AJAX error:', textStatus, errorThrown);
            alert('Failed to fetch patient report');
        }
    });

    span.onclick = function() {
        modal.style.display = "none";
    }

    closeButton.onclick = function() {
        modal.style.display = "none";
    }

    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }

    document.getElementById('saveReport').addEventListener('click', function() {
        const updatedReport = document.getElementById('modalReport').value;
        $.ajax({
            url: '/updateReport',
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                studyKey: studyKey,
                studyDate: studyDate,
                report: updatedReport
            }),
            success: function(data) {
                if (data.success) {
                    alert('저장되었습니다.');
                    modal.style.display = "none"; // 모달 창닫기
                } else {
                	console.log(data);
                    alert('Failed to save report');
                }
            },
            error: function() {
                alert('Error occurred while saving the report');
            }
        });
    });
}

// Event Listeners
document.getElementById('button1').addEventListener('click', function() {
    window.location.href = "/";
});

let showThumbnails = false;
document.getElementById('button2').addEventListener('click', async function() {
    showThumbnails = !showThumbnails;

    if(showThumbnails){
        const imageContainerWrapper = document.getElementById('imageContainerWrapper');
        imageContainerWrapper.style.visibility = 'visible';
        const imageContainer = document.getElementById('imageContainer');
        await displayMultipleImages(imageContainer, imageIds, currentPage, itemsPerPage);
    }
    else {
        const imageContainerWrapper = document.getElementById('imageContainerWrapper');
        imageContainerWrapper.style.visibility = 'hidden';
    }
});

document.getElementById('button3').addEventListener('click', function() {
    openReportModal();
});

document.getElementById('activateBrush').addEventListener('click', activateBrushTool);
</script>
</body>
</html>