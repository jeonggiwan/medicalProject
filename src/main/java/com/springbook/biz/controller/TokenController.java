package com.springbook.biz.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.springbook.biz.member.MemberService;
import com.springbook.biz.security.JwtTokenProvider;

@RestController
public class TokenController {
    
    private final MemberService memberService;
    private final JwtTokenProvider jwtTokenProvider;
    
    public TokenController(MemberService memberService, JwtTokenProvider jwtTokenProvider) {
        this.memberService = memberService;
        this.jwtTokenProvider = jwtTokenProvider;
    }
    
    @PostMapping("/refreshToken")
    @ResponseBody
    public ResponseEntity<Void> refreshToken(HttpServletRequest request, HttpServletResponse response) {
        return memberService.refreshToken(request, response);
    }
    
    @GetMapping("/tokenInfo")
    @ResponseBody
    public ResponseEntity<TokenInfo> getTokenInfo(HttpServletRequest request) {
        String token = jwtTokenProvider.resolveToken(request);
        if (token != null && jwtTokenProvider.validateToken(token)) {
            long expirationTime = jwtTokenProvider.getExpiration(token);
            long currentTime = System.currentTimeMillis();
            long remainingTime = expirationTime - currentTime;
            return ResponseEntity.ok(new TokenInfo(remainingTime));
        }
        return ResponseEntity.ok(new TokenInfo(0));
    }

    private static class TokenInfo {
        private final long remainingTime;

        public TokenInfo(long remainingTime) {
            this.remainingTime = remainingTime;
        }

        public long getRemainingTime() {
            return remainingTime;
        }
    }
}