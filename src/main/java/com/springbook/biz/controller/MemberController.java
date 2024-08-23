package com.springbook.biz.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springbook.biz.VO.MemberVO;
import com.springbook.biz.member.EmailUtil;
import com.springbook.biz.member.MemberService;
import com.springbook.biz.member.VerificationUtil;


@Controller
public class MemberController {
    
    private final MemberService memberService;

    public MemberController(MemberService memberService) {
        this.memberService = memberService;
    }

    
    //로그인 페이지
    @GetMapping("/login")
    public String loginPage(@RequestParam(value = "error", required = false) String error, Model model) {
        if (error != null) {
            model.addAttribute("error", "Invalid username or password");
        }
        return "login";
    }
    
    //로그인 시도
    @PostMapping("/login")
    @ResponseBody
    public ResponseEntity<Map<String, String>> login(@RequestParam String id, @RequestParam String password, HttpServletResponse response) {
        return memberService.login(id, password, response);
    }

    //로그아웃
    @PostMapping("/logout")
    @ResponseBody
    public ResponseEntity<String> logout(HttpServletRequest request, HttpServletResponse response) {
        return memberService.logout(request, response);
    }
    
    //회원 목록
    @GetMapping("/memberList")
    public String getMemberList(Model model) {
        List<MemberVO> memberList = memberService.getAllMembers();
        model.addAttribute("memberList", memberList);
        return "memberDetail";
    }
    
    //회원 목록 검색
    @GetMapping("/searchMembers")
    @ResponseBody
    public List<MemberVO> searchMembers(@RequestParam(required = false) String searchKeyword,
                                        @RequestParam(required = false) String searchType) {
        return memberService.searchMembers(searchKeyword, searchType);
    }
    

    //회원 삭제
    @PostMapping("/deleteMembers")
    @ResponseBody
    public ResponseEntity<String> deleteMembers(@RequestBody List<String> memberIds) {
        try {
            memberService.deleteMembers(memberIds);
            return ResponseEntity.ok("Members deleted successfully");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body("Error deleting members: " + e.getMessage());
        }
    }
  
    @PostMapping("/verifyCurrentPassword")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> verifyCurrentPassword(@RequestBody Map<String, String> request, Principal principal) {
        String currentPassword = request.get("currentPassword");
        String userId = principal.getName();
        boolean isValid = memberService.verifyCurrentPassword(userId, currentPassword);
        Map<String, Boolean> response = new HashMap<>();
        response.put("isValid", isValid);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/changePassword")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> changePassword(@RequestBody Map<String, String> request, Principal principal) {
        String newPassword = request.get("newPassword");
        String userId = principal.getName();
        boolean success = memberService.changePassword(userId, newPassword);
        Map<String, Boolean> response = new HashMap<>();
        response.put("success", success);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/deleteAccount")
    @ResponseBody
    public ResponseEntity<String> deleteAccount(Principal principal, HttpServletResponse response) {
        String userId = principal.getName();
        System.out.println(userId);
        System.out.println(response);
        return memberService.deleteAccount(userId, response);
    }
    
    //회원가입 페이지 경로
    @GetMapping("/sign")
    public String signPage() {
        return "sign";
    }

    //회원가입 시도
    @PostMapping("/sign")
    @ResponseBody
    public ResponseEntity<String> signUp(@RequestBody MemberVO memberVO) {
        try {
            memberService.signUp(memberVO);
            return ResponseEntity.ok("회원가입이 완료되었습니다.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("회원가입 중 오류가 발생했습니다: " + e.getMessage());
        }
    }

    //이메일 인증코드 보내기
    @PostMapping("/sendVerification")
    @ResponseBody
    public ResponseEntity<String> sendVerification(@RequestParam String email) {
        System.out.println(email);
    	String code = VerificationUtil.generateVerificationCode();
        VerificationUtil.saveVerificationCode(email, code);
        System.out.println(code);

        try {
            EmailUtil.sendEmail(email, "회원가입 인증코드", "인증코드: " + code);
            return ResponseEntity.ok("success");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("error");
        }
    }

    //코드 확인
    @PostMapping("/verifyCode")
    @ResponseBody
    public ResponseEntity<String> verifyCode(@RequestParam String email, @RequestParam String code) {
        boolean isVerified = VerificationUtil.verifyCode(email, code);
        return ResponseEntity.ok(isVerified ? "success" : "failure");
    }

    //아이디, 이메일. 핸드폰 번호 중복 확인
    @PostMapping("/checkDuplication")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> checkDuplication(@RequestBody Map<String, String> request) {
        String id = request.get("id");
        String email = request.get("email");
        String phoneNumber = request.get("phoneNumber");
        
        Map<String, Boolean> result = memberService.checkDuplication(id, email, phoneNumber);
        System.out.println("Duplication check result: " + result);
        return ResponseEntity.ok(result);
    }
    

    //마이페이지 경로 접근
    @GetMapping("/mypage")
    public String myPage(Model model, Principal principal) {
        String userId = principal.getName();
        MemberVO member = memberService.getMemberById(userId);
        model.addAttribute("member", member);
        return "mypage";
    }
    
    //아이디 찾기 페이지 경로
    @GetMapping("/forgot-id")
    public String forgot() {
    	return "forgot-id";
    }
    // 아이디 찾기
    @PostMapping("/find-id")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> findId(@RequestParam String email, @RequestParam String name) {
        boolean isSuccess = memberService.findIdAndSendEmail(email, name);
        Map<String, Object> response = new HashMap<>();
        
        if (isSuccess) {
            response.put("found", true);
            response.put("message", "아이디가 이메일로 전송되었습니다.");
        } else {
            response.put("found", false);
            response.put("message", "일치하는 회원 정보를 찾을 수 없습니다.");
        }
        return ResponseEntity.ok(response);
    }

    //비밀번호 찾기 페이지 경로
    @GetMapping("/forgot-pw")
    public String forgotPassword() {
        return "forgot-pw";
    }

    // 비밀번호 재설정
    @PostMapping("/reset-password")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> resetPassword(@RequestParam String email, @RequestParam String id) {
        boolean isSuccess = memberService.resetPasswordAndSendEmail(email, id);
        Map<String, Object> response = new HashMap<>();
        
        if (isSuccess) {
            response.put("reset", true);
            response.put("message", "새로운 비밀번호가 이메일로 전송되었습니다.");
        } else {
            response.put("reset", false);
            response.put("message", "일치하는 회원 정보를 찾을 수 없습니다.");
        }
        return ResponseEntity.ok(response);
    }
}