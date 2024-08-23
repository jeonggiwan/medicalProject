<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DICOM Viewer</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="../CSS/viewer.css"> <!-- CSS 파일 링크 추가 -->
    <script src="https://unpkg.com/hammerjs@2.0.8/hammer.js"></script>
    <script src="https://unpkg.com/dicom-parser/dist/dicomParser.js"></script>
    <script src="https://unpkg.com/cornerstone-core"></script>
    <script src="https://unpkg.com/cornerstone-math"></script>
    <script src="https://unpkg.com/cornerstone-wado-image-loader"></script>
    <script src="https://unpkg.com/cornerstone-tools"></script>
    <link rel="stylesheet" href="../CSS/dicom.css">
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <button class="sidebar-button">Button 1</button>
            <button class="sidebar-button">Button 2</button>
            <button class="sidebar-button">Button 3</button>
        </div>
        <!-- Main Content -->
        <div class="main-content">
            <h1 style="display:flex; justify-content:center">DICOM Viewer</h1>
            <!-- Top Bar -->
            <div class="top-bar">
                <a href="edge" class="top-bar-button">Edge Detection</a>
                <a href="annotation" class="top-bar-button">Annotation</a>
                <button class="top-bar-button"></button>
                <button class="top-bar-button"></button>
                <button class="top-bar-button"></button>
                <button class="top-bar-button"></button>
                <button class="top-bar-button"></button>
                <button class="top-bar-button"></button>
                <button class="top-bar-button"></button>
                <button class="top-bar-button ml-auto"></button>
                <button class="top-bar-button"></button>
                <button class="top-bar-button"></button>
            </div>
            <div id="dicom" class="cornerstone-element" oncontextmenu="return false" style="width:512px;height:512px;border:1px solid black;margin:0 auto"></div>
            <div class="content-area">
                <!-- Main content goes here -->
                <div id="imageContainer"></div> <!-- 이미지 표시를 위한 컨테이너 추가 -->
            </div>
        </div>
    </div>
    
    <script>
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
            elementId: 'dicomImage${status.index}',
            checkboxId: 'checkbox${status.index}'
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
        
        // 이미지 표시를 위한 추가 코드
        const imageContainer = document.getElementById("imageContainer");
        imageContainer.innerHTML = ""; // 기존 이미지 초기화
        imageIds.forEach(imageId => {
            const imgElement = document.createElement("img");
            imgElement.src = imageId; // 이미지 ID를 src로 설정
            imgElement.style.width = "100%"; // 이미지 크기 조정
            imageContainer.appendChild(imgElement); // 컨테이너에 이미지 추가
        });
        
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
    
    ;(async function () {
        _init()
        const dicom = document.querySelector("#dicom")
        const images = await display(dicom, imageIds)
        console.log(images)
        
    })()
    </script>
</body>
</html>