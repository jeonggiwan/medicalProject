package com.dicom.test;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import com.dicom.controller.DicomFileService;

@Controller
public class HomeController {

	@Autowired
    private DicomFileService dicomFileService;
	
	@Value("${python.script.url}")
	private String pythonScriptUrl;
	
	@RequestMapping(value = "/")
	public String home() {
		return "index";
	}
	
	@RequestMapping(value="/cornerstone")
	public String cornerstone(Model model) {
		String directoryPath = "C:/Users/user/Downloads/202304/04/14162/CT/602"; 
		
		List<String> dicomFileNames = dicomFileService.getDicomFiles(directoryPath);
		
		model.addAttribute("dicomFileNames", dicomFileNames);
		
		return "cornerstone";
	}

	// 파이썬 
    @RequestMapping(value="/upload")
    public ResponseEntity<String> handleFileUpload(@RequestParam("file") MultipartFile file) {
    	System.out.println(pythonScriptUrl);
        try {
            // Create the headers
            HttpHeaders headers = new HttpHeaders();
            headers.set("Content-Type", "multipart/form-data");

         // Create the body with the file as a ByteArrayResource
            ByteArrayResource fileAsResource = new ByteArrayResource(file.getBytes()) {
                @Override
                public String getFilename() {
                    return file.getOriginalFilename();
                }
            };

            // Create the request entity
            HttpEntity<ByteArrayResource> requestEntity = new HttpEntity<>(fileAsResource, headers);

            // Create the RestTemplate
            RestTemplate restTemplate = new RestTemplate();

            // Send the request to the Python script
            ResponseEntity<String> response = restTemplate.exchange(pythonScriptUrl, HttpMethod.POST, requestEntity, String.class);

            return response;
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error uploading file: " + e.getMessage());
        }
    }
    
    @RequestMapping("/annotation")
	public String getAnnotation(Model model) {
		
		String directoryPath = "C:/Users/user/Downloads/202304/04/14162/CT/602";
		List<String> dicomFileNames = dicomFileService.getDicomFiles(directoryPath);
		model.addAttribute("dicomFileNames", dicomFileNames);
		 
    	return "annotation";
    }
    
    // 파이썬 
    @RequestMapping("/edge")
	public String getEdges(Model model) {
		
    	String directoryPath = "C:/Users/user/Downloads/202304/04/14162/CT/602";
		List<String> dicomFileNames = dicomFileService.getDicomFiles(directoryPath);
		model.addAttribute("dicomFileNames", dicomFileNames);
		 
    	return "edge";
    }
}
