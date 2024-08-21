package com.springbook.biz.controller;

import java.util.List;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import com.springbook.biz.dicom.dicomService.DicomFileService;
import com.springbook.biz.VO.StudyVO;
import com.springbook.biz.study.StudyService;

@Controller
public class StorageController {
    @Autowired
    private DicomFileService dicomFileService;
    
    @Autowired
    private StudyService studyService;
    
    @Value("${python.script.url}")
    private String pythonScriptUrl;
    
    @GetMapping("/viewer")
    public String viewer(@RequestParam String pid, 
                         @RequestParam String studyDate, 
                         Model model,
                         HttpSession session) {
        
        System.out.println(pid);
        StudyVO study = studyService.getStudyDetails(pid, studyDate);
        System.out.println(studyDate);
        if (study != null) {
            // 파일 경로 생성
            String yearMonth = studyDate.substring(0, 6);
            String day = studyDate.substring(6, 8);
            String filePath = String.format("student/%s/%s/%s/%s/%s", 
                    yearMonth, day, study.getPid(), study.getModality(), study.getSeriesNum());
            model.addAttribute("filePath", filePath);
            System.out.println(filePath);
            model.addAttribute("message", "데이터를 성공적으로 불러왔습니다.");
            model.addAttribute("filePath", filePath);
            model.addAttribute("study", study);
            
            // 세션에 filePath 저장
            session.setAttribute("filePath", filePath);
            
            // DICOM 파일 목록 가져오기
            List<String> dicomFileNames = dicomFileService.getDicomFiles(filePath);
            model.addAttribute("dicomFileNames", dicomFileNames);
        } else {
            model.addAttribute("message", "해당 검사 데이터를 찾을 수 없습니다.");
        }
        
        return "viewer"; // viewer.jsp로 이동
    }

    // 새로 추가된 DICOM 파일 제공 엔드포인트
    @GetMapping("/dicom/{yearMonth}/{day}/{pid}/{modality}/{seriesNum}/{fileName}")
    public ResponseEntity<Resource> getDicomFile(
            @PathVariable String yearMonth,
            @PathVariable String day,
            @PathVariable String pid,
            @PathVariable String modality,
            @PathVariable String seriesNum,
            @PathVariable String fileName) {
        String filePath = String.format("c:/student/%s/%s/%s/%s/%s/%s", 
            yearMonth, day, pid, modality, seriesNum, fileName);
        Resource file = new FileSystemResource(filePath);
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType("application/dicom"))
                .body(file);
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
    public String getAnnotation(Model model, HttpSession session) {
        String filePath = (String) session.getAttribute("filePath");
        
        if (filePath != null) {
            List<String> dicomFileNames = dicomFileService.getDicomFiles(filePath);
            model.addAttribute("dicomFileNames", dicomFileNames);
        }
         
        return "annotation";
    }
    
    // 파이썬 
    @RequestMapping("/edge")
    public String getEdges(Model model, HttpSession session) {
        String filePath = (String) session.getAttribute("filePath");
        
        if (filePath != null) {
            List<String> dicomFileNames = dicomFileService.getDicomFiles(filePath);
            model.addAttribute("dicomFileNames", dicomFileNames);
        }
         
        return "edge";
    }
}