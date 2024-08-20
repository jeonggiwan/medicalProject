<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Send to Python</title>
    <script src="https://unpkg.com/hammerjs@2.0.8/hammer.js"></script>
    <script src="https://unpkg.com/dicom-parser/dist/dicomParser.js"></script>
    <script src="https://unpkg.com/cornerstone-core"></script>
    <script src="https://unpkg.com/cornerstone-math"></script>
    <script src="https://unpkg.com/cornerstone-wado-image-loader"></script>
    <script src="https://unpkg.com/cornerstone-tools"></script>
    <link rel="stylesheet" href="resources/css/style.css">
</head>
<body>
	<h1 style="display:flex; justify-content:center">Send to Python</h1>
	<div>
		<input type="checkbox" id="edge">Edge Detection
		<input type="checkbox" id="cnn">CNN<br>
	</div>
	<button id="sendImages">Send Image</button>
	<a href="cornerstone">Return to Main</a>
	
    <div style="display:flex;flex-direction:row;font-size: 25px; text-align: left"> 
      	<div id="dicom" class="cornerstone-element" oncontextmenu="return false" style="width:512px;height:512px;border:1px solid black;margin:10px"></div>
    	<div id="python" style="width:512px;height:512px;border:1px solid black;margin:10px"></div>
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
        		elementId: 'dicomImage${status.index}'
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
			
		// 파이썬으로 이미지 보내고 다시 받음 
        document.getElementById('sendImages').addEventListener('click', function() {
            const dicomCanvas = document.querySelector('#dicom canvas');
            const base64Image = dicomCanvas.toDataURL('image/png');
            
            var edge = document.getElementById('edge').checked;
            var cnn = document.getElementById('cnn').checked;
            
            const requestData = {
                edge: edge,
                cnn: cnn,
                image: base64Image
            };
        	
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
            	const pythonDiv = document.getElementById('python');
            	console.log('Success:', data);
            	pythonDiv.innerHTML = "";
            	
            	const canvas = document.createElement('canvas');
            	const ctx = canvas.getContext('2d');
            	const img = new Image();
            	
            	img.src = data.processedImage;
            	
            	img.onload = () => {
            		canvas.width = img.width;
            		canvas.height = img.height;
            		ctx.drawImage(img, 0, 0);
            		pythonDiv.appendChild(canvas);
            	}
            })
            .catch((error) => {
                console.error('Error:', error);
            });
        }); 
	
		if(document.getElementById('edge')) { 
			const pythonCanvas = document.querySelector('#python canvas');
	        const base64Image = pythonCanvas.toDataURL('image/png');
	            
	        var edge = document.getElementById('edge').checked;
	        var cnn = document.getElementById('cnn').checked;
	            
	        const requestData = {
	            edge: edge,
	            cnn: cnn,
	            image: base64Image
	        };
	        	
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
	        	const pythonDiv = document.getElementById('python');
            	console.log('Success:', data);
            	pythonDiv.innerHTML = "";
            	
            	const canvas = document.createElement('canvas');
            	const ctx = canvas.getContext('2d');
            	const img = new Image();
            	
            	img.src = data.edgeDetection;
            	
            	img.onload = () => {
            		canvas.width = img.width;
            		canvas.height = img.height;
            		ctx.drawImage(img, 0, 0);
            		pythonDiv.appendChild(canvas);
            	}
	        })
	        .catch((error) => {
	            console.error('Error:', error);
	        });
		}
		
    </script>
</body>
</html>