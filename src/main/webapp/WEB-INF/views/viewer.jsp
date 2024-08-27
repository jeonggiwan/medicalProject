<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://unpkg.com/hammerjs@2.0.8/hammer.js"></script>
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
<title>DICOM Viewer</title>
</head>
<body>
<%@ include file="menu.jsp"%>
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
            <button id="windowCanvas" class="tool-button"><img alt="none" src="images/contrast.png"></button>  
             <button id="activateBrush" class="tool-button"><img alt="none" src="images/paintbrush.png"></button>
            <button id="dragCanvas" class="tool-button"><img alt="none" src="images/drag-and-drop.png"></button>
            <button id="zoomCanvas" class="tool-button"><img alt="none" src="images/zoom-in.png"></button>
            <button id="rotateCanvas" class="tool-button"><img alt="none" src="images/refresh.png"></button>
            <button id="lengthCanvas" class="tool-button"><img alt="none" src="images/length.png"></button>
            <button id="angleCanvas" class="tool-button"><img alt="none" src="images/angle.png"></button>
            <button id="probeCanvas" class="tool-button"><img alt="none" src="images/post-it.png"></button>
            <button id="preprocess" class="tool-button"><img alt="none" src="images/python.png"></button>
            <button id="edgeDetection" class="tool-button"><img alt="none" src="images/corner.png"></button>
            <button id="downloadImage" class="tool-button" style="display:none"><img alt="none" src="images/downloads.png"></button>
         </div>

      <div id="dicomImages">
         <div id="dicom" class="cornerstone-element"
            oncontextmenu="return false"
            style="width: 512px; height: 512px; border: 1px solid black;"></div>
      </div>
         
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
         <p>
            Patient Name: <span id="modalPname"></span>
         </p>
         <p>
            Patient ID: <span id="modalPid"></span>
         </p>
         <p>
            Doctor: <span id="modalDoctor"></span>
         </p>
         <textarea id="modalReport" rows="10" cols="50"></textarea>
         <br>
         <button id="saveReport">Save</button>
         <button id="closeModal">Close</button>
      </div>
   </div>

    <script>
    let currentPage = 1;
    const itemsPerPage = 5;

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

        cornerstoneTools.external.cornerstoneMath = cornerstoneMath;
        cornerstoneTools.external.cornerstone = cornerstone;
        cornerstoneTools.external.Hammer = Hammer;
        
        cornerstoneTools.init({
            showSVGCursors: false,
        })
    }

    const dicomFiles = [];
    <c:forEach var="file" items="${dicomFileNames}" varStatus="status">
        dicomFiles.push({
            fileName: '${file}',
            elementId: 'dicomImage${status.index}'
        });
    </c:forEach>

    const imageIds = [];
    dicomFiles.forEach(function(dicomFile) {
        const imageId = 'wadouri:${pageContext.request.contextPath}/dicom/' + 
        '${study.studyDate.substring(0,6)}/${study.studyDate.substring(6,8)}/${study.pid}/${study.modality}/${study.seriesNum}/' + 
        dicomFile.fileName;
        imageIds.push(imageId);
    });

    const display = async(element, imageIds) => {
        cornerstone.enable(element)
        const image = await cornerstone.loadAndCacheImage(imageIds[0])
        cornerstone.displayImage(element, image)
        cornerstoneTools.addStackStateManager(element, [
            "stack",
        ])
        cornerstoneTools.addToolState(element, "stack", {
            imageIds: [...imageIds],
            currentImageIdIndex: 0,
        })
        cornerstoneTools.addToolForElement(
            element,
            cornerstoneTools["StackScrollMouseWheelTool"],
            {configuration: {loop:true}}
        )
        
        cornerstoneTools.setToolActive("StackScrollMouseWheel", {});
        
        return Promise.all(
            imageIds.map((imageId) => cornerstone.loadAndCacheImage(imageId)),
        )
    }

    ;(async function () {
        _init()
        const dicom = document.querySelector("#dicom")
        const images = await display(dicom, imageIds)
    })();

    // Event Listeners
    document.getElementById('button1').addEventListener('click', function() {
        window.location.href = "/";
    });

    let showThumbnails = false;
    document.getElementById('button2').addEventListener('click', async function() {
        showThumbnails = !showThumbnails;
        const imageContainerWrapper = document.getElementById('imageContainerWrapper');
        
        if(showThumbnails){
            imageContainerWrapper.style.visibility = 'visible';
            const imageContainer = document.getElementById('imageContainer');
            await displayMultipleImages(imageContainer, imageIds, currentPage, itemsPerPage);
        } else {
            imageContainerWrapper.style.visibility = 'hidden';
        }
    });

    document.getElementById('button3').addEventListener('click', function() {
        openReportModal();
    });  

    const displayMultipleImages = async (container, imageIds, page = 1, itemsPerPage = 5) => {
        container.innerHTML = ''; // Clear previous content
        const startIndex = (page - 1) * itemsPerPage;
        const endIndex = Math.min(startIndex + itemsPerPage, imageIds.length);
        
        for (let i = startIndex; i < endIndex; i++) {
            const imgElement = document.createElement('div');
            imgElement.className = 'thumbnail-image';
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
        document.getElementById('paginationText').textContent = page.toString() + "/" + totalPages.toString();
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

    const element = document.getElementById('dicom');
    const segmentationModule = cornerstoneTools.getModule('segmentation');

    // Reset to initial position
    function resetImagePosition(element) {
        const defaultViewport = cornerstone.getDefaultViewportForImage(element, cornerstone.getImage(element));
        // Reset the viewport to its default values
        cornerstone.setViewport(element, defaultViewport);
    }

    function toggleButtonState(button, isActive) {
        if (isActive) {
            button.classList.add('active');
        } else {
            button.classList.remove('active');
        }
    }

    let brush = false;
    document.getElementById('activateBrush').addEventListener('click', () => {
        brush = !brush;
        const button = document.getElementById('activateBrush');
        toggleButtonState(button, brush);
        
        if (brush) {
            cornerstoneTools.addToolForElement(
                element,
                cornerstoneTools.BrushTool,
                {
                    configuration: {
                        radius: 10,  
                    }
                }
            );
            cornerstoneTools.setToolActive("Brush", { mouseButtonMask: 1 });
        } else {
            cornerstoneTools.setToolDisabled('Brush', {});
        }
    });

    let windowLevel = false;
    document.getElementById('windowCanvas').addEventListener('click', () => {
        windowLevel = !windowLevel;
        const button = document.getElementById('windowCanvas');
        toggleButtonState(button, windowLevel);
        
        if(windowLevel) {
            const WwwcTool = cornerstoneTools.WwwcTool;
            cornerstoneTools.addTool(WwwcTool);
            cornerstoneTools.setToolActive('Wwwc', { mouseButtonMask: 1});
        } else {
            cornerstoneTools.setToolDisabled('Wwwc', {});  
        }
    });

    let drag = false;
    document.getElementById('dragCanvas').addEventListener('click', () => {
        drag = !drag;
        const button = document.getElementById('dragCanvas');
        toggleButtonState(button, drag);
        
        if(drag) {
            const panTool = cornerstoneTools.PanTool;
            cornerstoneTools.addTool(panTool);
            cornerstoneTools.setToolActive("Pan", { mouseButtonMask: 1 });   
        } else {
            cornerstoneTools.setToolDisabled('Pan', {});
        }
    });

    let zoom = false;
    document.getElementById('zoomCanvas').addEventListener('click', () => {
        zoom = !zoom;
        const button = document.getElementById('zoomCanvas');
        toggleButtonState(button, zoom);
        
        if(zoom) {
            const ZoomTool = cornerstoneTools.ZoomTool;
            cornerstoneTools.addTool(cornerstoneTools.ZoomTool, {
                configuration: {
                    invert: false,
                    preventZoomOutsideImage: false,
                    minScale: .1,
                    maxScale: 20.0,
                }
            });
            cornerstoneTools.setToolActive('Zoom', { mouseButtonMask: 1 })
        } else {
            cornerstoneTools.setToolDisabled('Zoom', {});
        }
    });

    let rotate = false;
    document.getElementById('rotateCanvas').addEventListener('click', () => {
        rotate = !rotate;
        const button = document.getElementById('rotateCanvas');
        toggleButtonState(button, rotate);
        
        if(rotate) {
            const RotateTool = cornerstoneTools.RotateTool;
            cornerstoneTools.addTool(cornerstoneTools.RotateTool);
            cornerstoneTools.setToolActive('Rotate', { mouseButtonMask: 1 })
        } else {
            cornerstoneTools.setToolDisabled('Rotate', {});
        }
    });

    let length = false;
    document.getElementById('lengthCanvas').addEventListener('click', () => {
        length = !length;
        const button = document.getElementById('lengthCanvas');
        toggleButtonState(button, length);
        
        if(length) {
            const LengthTool = cornerstoneTools.LengthTool;
            cornerstoneTools.addTool(cornerstoneTools.LengthTool);
            cornerstoneTools.setToolActive('Length', { mouseButtonMask: 1 })
        } else {
            cornerstoneTools.clearToolState(element, 'Length');
            cornerstone.updateImage(element);
            cornerstoneTools.setToolDisabled('Length', {});
        }
    });

    let angle = false;
    document.getElementById('angleCanvas').addEventListener('click', () => {
        angle = !angle;
        const button = document.getElementById('angleCanvas');
        toggleButtonState(button, angle);
        
        if(angle) {
            const AngleTool = cornerstoneTools.AngleTool;
            cornerstoneTools.addTool(cornerstoneTools.AngleTool);
            cornerstoneTools.setToolActive('Angle', { mouseButtonMask: 1 })
        } else {
            cornerstoneTools.clearToolState(element, 'Angle');
            cornerstone.updateImage(element);
            cornerstoneTools.setToolDisabled('Angle', {});
        }
    });

    let probe = false;
    document.getElementById('probeCanvas').addEventListener('click', () => {
        probe = !probe;
        const button = document.getElementById('probeCanvas');
        toggleButtonState(button, probe);
        
        if(probe) {
            const ProbeTool = cornerstoneTools.ProbeTool;
            cornerstoneTools.addTool(cornerstoneTools.ProbeTool);
            cornerstoneTools.setToolActive('Probe', { mouseButtonMask: 1 })
        } else {
            cornerstoneTools.clearToolState(element, 'Probe');
            cornerstone.updateImage(element);
            cornerstoneTools.setToolDisabled('Probe', {});
        }
    });

    // Restore position when scrolled 
    element.addEventListener('cornerstonetoolsmousewheel', () => {
        resetImagePosition(element);
    });

    let preprocess = false;
    // preprocess와 edgeDetection 버튼에 대한 이벤트 리스너 수정
    document.getElementById('preprocess').addEventListener('click', function() {
        this.classList.toggle('active');
        toggleProcessedImage('preprocess');
    });

    let edgeDetection = false;
    document.getElementById('edgeDetection').addEventListener('click', function() {
        this.classList.toggle('active');
        toggleProcessedImage('edgeDetection');
    });
    
    function toggleProcessedImage(action) {
        let processedImageDiv = document.getElementById('processedImage');
        const dicomDiv = document.querySelector('#dicomImages');

        if (!processedImageDiv) {
            processedImageDiv = document.createElement('div');
            processedImageDiv.id = 'processedImage';
            processedImageDiv.classList.add('cornerstone-element');
            dicomDiv.appendChild(processedImageDiv);
        }

        const isVisible = processedImageDiv.style.display === 'block';

        if (isVisible) {
            // If visible, hide and reset dicom div
            processedImageDiv.style.display = 'none';
            dicomDiv.style.width = '100%';
        } else {
            // If hidden, display and adjust sizes
            processedImageDiv.style.display = 'block';
            dicomDiv.style.width = '100%';

            // Load the processed image into the processedImage div
            fetchProcessedImage(action, processedImageDiv);
        }
        
        // Update the download button visibility
        updateDownloadButtonVisibility();
    }

    function fetchProcessedImage(action, processedImageDiv) {
        const dicomCanvas = document.querySelector('#dicom canvas');
        if (!dicomCanvas) {
            console.error('DICOM canvas not found');
            return;
        }
        const base64Image = dicomCanvas.toDataURL('image/png');

        const requestData = {
            image: base64Image,
        };

        if (action === 'edgeDetection') {
            requestData.edge = true;
        }

        fetch('http://localhost:5000', { 
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(requestData)
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            processedImageDiv.innerHTML = "";
            
            const canvas = document.createElement('canvas');
            const ctx = canvas.getContext('2d');
            const img = new Image();
            
            img.src = action === 'edgeDetection' ? data.edgeDetection : data.processedImage;
            
            img.onload = () => {
                canvas.width = img.width;
                canvas.height = img.height;
                ctx.drawImage(img, 0, 0);
                processedImageDiv.appendChild(canvas);
                
                // Show download button
                const downloadButton = document.getElementById('downloadImage');
                downloadButton.style.display = 'block';
                downloadButton.onclick = () => downloadImage(canvas);
            }
        })
        .catch((error) => {
            console.error('Error:', error);
        });
    }

 // 도구 상태를 추적하는 객체
    const toolStates = {
        window: false,
        brush: false,
        drag: false,
        zoom: false,
        rotate: false,
        length: false,
        angle: false,
        probe: false
    };

    // 모든 도구를 비활성화하는 함수
    function deactivateAllTools() {
        const tools = ['windowCanvas', 'activateBrush', 'dragCanvas', 'zoomCanvas', 'rotateCanvas', 'lengthCanvas', 'angleCanvas', 'probeCanvas'];
        tools.forEach(toolId => {
            const button = document.getElementById(toolId);
            button.classList.remove('active');
            const toolName = toolId.replace('Canvas', '');
            cornerstoneTools.setToolDisabled(toolName);
            toolStates[toolName] = false;
        });
    }

    // 각 도구 버튼에 이벤트 리스너 추가
    const tools = ['windowCanvas', 'activateBrush', 'dragCanvas', 'zoomCanvas', 'rotateCanvas', 'lengthCanvas', 'angleCanvas', 'probeCanvas'];
    tools.forEach(toolId => {
        document.getElementById(toolId).addEventListener('click', function() {
            const toolName = toolId.replace('Canvas', '');
            if (toolStates[toolName]) {
                // 이미 활성화된 도구를 클릭한 경우
                this.classList.remove('active');
                cornerstoneTools.setToolDisabled(toolName);
                toolStates[toolName] = false;
            } else {
                // 비활성화된 도구를 클릭한 경우
                deactivateAllTools();
                this.classList.add('active');
                cornerstoneTools.setToolActive(toolName, { mouseButtonMask: 1 });
                toolStates[toolName] = true;
            }
        });
    });
    
    // 이미지 다운로드
    function downloadImage(canvas) {
       const link = document.createElement('a');
       link.href = canvas.toDataURL('image/png');
       link.download = '${study.modality}' + '-' + '${study.studyDate}' + '-' + '${study.pid}' + '.png';
       link.click();
   }
    
    // Function to update the visibility of the download button
    function updateDownloadButtonVisibility() {
        const downloadButton = document.getElementById('downloadImage');
        if (preprocess || edgeDetection) {
            downloadButton.style.display = 'block';
        } else {
            downloadButton.style.display = 'none';
        }
    }
    
    </script>
</body>
</html>