package com.springbook.biz.member;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.springbook.biz.VO.MemberVO;
import com.springbook.biz.security.JwtTokenProvider;

@Service
public class MemberServiceImpl implements MemberService {

    private final JwtTokenProvider jwtTokenProvider;
    private AuthenticationManager authenticationManager;
    private final MemberDAOMybatis memberDAO;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public MemberServiceImpl(JwtTokenProvider jwtTokenProvider, MemberDAOMybatis memberDAO, PasswordEncoder passwordEncoder) {
        this.jwtTokenProvider = jwtTokenProvider;
        this.memberDAO = memberDAO;
        this.passwordEncoder = passwordEncoder;
    }

    @Autowired
    public void setAuthenticationManager(AuthenticationManager authenticationManager) {
        this.authenticationManager = authenticationManager;
    }
    @Override
    public ResponseEntity<Map<String, String>> login(String id, String password, HttpServletResponse response) {
        try {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(id, password));
            SecurityContextHolder.getContext().setAuthentication(authentication);
            
            String accessToken = jwtTokenProvider.createAccessToken(id);
            String refreshToken = jwtTokenProvider.createRefreshToken(id);
            
            setRefreshTokenCookie(response, refreshToken);
            
            Map<String, String> tokens = new HashMap<>();
            tokens.put("accessToken", accessToken);
            tokens.put("refreshToken", refreshToken);  // 추가된 부분
            
            return ResponseEntity.ok(tokens);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
    }
    @Override
    public ResponseEntity<String> logout(HttpServletResponse response) {
        removeRefreshTokenCookie(response);
        return ResponseEntity.ok("Logged out successfully");
    }

    @Override
    public ResponseEntity<Void> refreshToken(HttpServletRequest request, HttpServletResponse response) {
        String refreshToken = jwtTokenProvider.resolveToken(request);
        if (refreshToken != null && jwtTokenProvider.validateToken(refreshToken)) {
            String username = jwtTokenProvider.getUsername(refreshToken);
            String newAccessToken = jwtTokenProvider.createAccessToken(username);
            response.setHeader("Authorization", "Bearer " + newAccessToken);
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        MemberVO member = memberDAO.getMemberById(username);
        if (member == null) {
            throw new UsernameNotFoundException("User not found with username: " + username);
        }
        return new User(member.getId(), member.getPassword(),
                new ArrayList<SimpleGrantedAuthority>() {{
                    add(new SimpleGrantedAuthority("ROLE_USER"));
                }});
    }
    
    private void setRefreshTokenCookie(HttpServletResponse response, String refreshToken) {
        Cookie refreshTokenCookie = new Cookie("REFRESH_TOKEN", refreshToken);
        refreshTokenCookie.setHttpOnly(true);
        refreshTokenCookie.setPath("/");
        refreshTokenCookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
        response.addCookie(refreshTokenCookie);
    }

    private void removeRefreshTokenCookie(HttpServletResponse response) {
        Cookie cookie = new Cookie("REFRESH_TOKEN", null);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(0);
        response.addCookie(cookie);
    }
}