package com.springbook.biz.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.http.ResponseEntity;

import com.springbook.biz.VO.BoardVO;
import com.springbook.biz.VO.StudyVO;
import com.springbook.biz.board.impl.BoardService;
import com.springbook.biz.security.JwtTokenProvider;
import com.springbook.biz.study.StudyService;

@Controller
public class StudyController {
    @Autowired
    private StudyService studyService;
    
    @Autowired
    private BoardService boardService;
    
    @Autowired
    private JwtTokenProvider jwtTokenProvider;
    
    @GetMapping("/public/home")
    public String publicHome() {
        return "public/home";
    }
    
    
    //메인페이지(환자 목록 페이지)
    @GetMapping("/")
    public String index(Model model, HttpServletRequest request, @RequestParam(defaultValue = "1") int page) {
        String token = jwtTokenProvider.resolveToken(request);
        if (token != null && jwtTokenProvider.validateToken(token)) {
            Authentication auth = jwtTokenProvider.getAuthentication(token);
            SecurityContextHolder.getContext().setAuthentication(auth);
            
            model.addAttribute("username", auth.getName());
            model.addAttribute("isIndexPage", true);  // 이 줄을 추가합니다.
            
            int pageSize = 6;
            List<StudyVO> allStudies = studyService.getStudyList();
            int totalStudies = allStudies.size();
            int totalPages = (int) Math.ceil((double) totalStudies / pageSize);
            
            int start = (page - 1) * pageSize;
            int end = Math.min(start + pageSize, totalStudies);
            List<StudyVO> pagedStudies = allStudies.subList(start, end);
            
            model.addAttribute("studyList", pagedStudies);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            return "index";
        } else {
            return "redirect:/login";
        }
    }
    
    //환자기록 페이지
    @GetMapping("/getPatientHistory")
    @ResponseBody
    public List<StudyVO> getPatientHistory(@RequestParam String pid) {
        return studyService.getPatientHistory(pid);
    }
    

    //환자찾기
    @GetMapping("/searchPatients")
    @ResponseBody
    public Map<String, Object> searchPatients(@RequestParam String searchKeyword, 
                                              @RequestParam String searchType,
                                              @RequestParam(defaultValue = "1") int page,
                                              @RequestParam(defaultValue = "6") int pageSize) {
       
    	List<StudyVO> patients;
        if (searchType.equals("pid")) {
            patients = studyService.searchPatientsByPid(searchKeyword);
        } else {
            patients = studyService.searchPatientsByName(searchKeyword);
        }

        int totalPatients = patients.size();
        int totalPages = (int) Math.ceil((double) totalPatients / pageSize);

        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalPatients);
        List<StudyVO> pagedPatients = patients.subList(start, end);

        Map<String, Object> result = new HashMap<>();
        result.put("patients", pagedPatients);
        result.put("currentPage", page);
        result.put("totalPages", totalPages);

        System.out.println(result);
        return result;
    }
}