<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<script src="https://unpkg.com/hammerjs@2.0.8/hammer.js"></script>
    <script src="https://unpkg.com/dicom-parser/dist/dicomParser.js"></script>
    <script src="https://unpkg.com/cornerstone-core"></script>
    <script src="https://unpkg.com/cornerstone-math"></script>
    <script src="https://unpkg.com/cornerstone-wado-image-loader"></script>
    <script src="https://unpkg.com/cornerstone-tools"></script>
    <link rel="stylesheet" href="resources/css/style.css">
<title>Annotation</title>
</head>
<body>
    <div id="dicom" class="cornerstone-element" oncontextmenu="return false" style="width:512px;height:512px;border:1px solid black;margin:0 auto"></div>

    <div>
        <!-- Button to activate the FreehandRoiTool -->
        <button id="activateTool">Activate Brush</button>
    </div>
    <a href="cornerstone">Main</a>
    
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
    
    	cornerstoneTools.external.cornerstoneMath = cornerstoneMath;
    	cornerstoneTools.external.cornerstone = cornerstone;
    	cornerstoneTools.external.Hammer = Hammer;
    
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
	
	const imageIds = [];
	dicomFiles.forEach(function(dicomFile) {
        const imageId = 'wadouri:http://localhost:8080/resources/dicom/' + dicomFile.fileName;
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
	    cornerstoneTools.addToolForElement(
	      element,
	      cornerstoneTools["BrushTool"],
	      {configuration : { radius:10 }}
	    ); 
		
	    cornerstoneTools.setToolActive("StackScrollMouseWheel", {});
	    //cornerstoneTools.setToolActiveForElement(element, "BrushTool",{ mouseButtonMask: 1})
	    return Promise.all(
	      imageIds.map((imageId) => cornerstone.loadAndCacheImage(imageId)),
	    )
	} 
	
	;(async function () {
	    _init()
	    const dicom = document.querySelector("#dicom")
	    const images = await display(dicom, imageIds)
	    
	  })();
	  
	  document.getElementById('activateTool').addEventListener('click', () => {
		  const BrushTool = cornerstoneTools.BrushTool;
		  cornerstoneTools.addTool(BrushTool);
		  
		  cornerstoneTools.setToolActive('Brush', {
			  mouseButtonMask: 1,
		  });
	  });
    </script>
</body>
</html>