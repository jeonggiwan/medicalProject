<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>DICOM Viewer</title>
    <script src="https://unpkg.com/hammerjs@2.0.8/hammer.js"></script>
    <script src="https://unpkg.com/dicom-parser/dist/dicomParser.js"></script>
    <script src="https://unpkg.com/cornerstone-core"></script>
    <script src="https://unpkg.com/cornerstone-math"></script>
    <script src="https://unpkg.com/cornerstone-wado-image-loader"></script>
    <script src="https://unpkg.com/cornerstone-tools"></script>
    <link rel="stylesheet" href="../CSS/dicom.css">
</head>
<body>
    <h1 style="display:flex; justify-content:center">DICOM Viewer</h1>
    
    <div id="dicom" class="cornerstone-element" oncontextmenu="return false" style="width:512px;height:512px;border:1px solid black;margin:0 auto"></div>
    <div>
        <a href="edge" style="margin-left:40%">Edge Detection</a>
        <a href="annotation">Annotation</a>
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
        console.log(images)
        
    })()
    </script>
</body>
</html>