<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DICOM Viewer</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/hammerjs@2.0.8/hammer.js"></script>
    <script src="https://unpkg.com/dicom-parser/dist/dicomParser.js"></script>
    <script src="https://unpkg.com/cornerstone-core"></script>
    <script src="https://unpkg.com/cornerstone-math"></script>
    <script src="https://unpkg.com/cornerstone-wado-image-loader"></script>
    <script src="https://unpkg.com/cornerstone-tools"></script>
    <link rel="stylesheet" href="../CSS/dicom.css">
    <link rel="stylesheet" href="../CSS/viewer.css">
</head>
<body>
	<div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <button id="button1" class="sidebar-button">Button 1</button>
            <button id="button2" class="sidebar-button">Button 2</button>
            <button id="button3" class="sidebar-button">Button 3</button>
        </div>
        <!-- Main Content -->
        <div class="main-content">
            <h1>DICOM Viewer</h1>
            <!-- Top Bar -->
            <div class="top-bar">
                <a href="edge?pid=${pid}&studyDate=${studyDate}" class="top-bar-button">Edge Detection</a>
                <a href="annotation?pid=${pid}&studyDate=${studyDate}" class="top-bar-button">Annotation</a>
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
            container.appendChild(imgElement);
            
            cornerstone.enable(imgElement); // Enable the cornerstone element
            const image = await cornerstone.loadAndCacheImage(imageIds[i]);
            cornerstone.displayImage(imgElement, image); // Display the image
        }
        updatePaginationControls(page, imageIds.length);
    };

    const updatePaginationControls = (page, totalItems) => {
        const totalPages = Math.ceil(totalItems / itemsPerPage);
        document.getElementById('prevPageBtn').disabled = page <= 1;
        document.getElementById('nextPageBtn').disabled = page >= totalPages;
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

 // Initialize and display the first page of images
    (async function () {
        _init(); // Initialize cornerstone and cornerstoneTools
        const dicom = document.querySelector("#dicom");
        await display(dicom, imageIds); // Ensure main DICOM image is displayed
    })();

 	document.getElementById('button1').addEventListener('click', function() {
 		window.location.href = "/";
 	});
 	
    // Show imageContainer when Button 2 is clicked
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
    </script>
</body>
</html>