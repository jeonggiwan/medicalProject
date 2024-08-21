package com.springbook.biz.member;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
            
            // Set access token as a cookie
            jwtTokenProvider.setAccessTokenCookie(response, accessToken);
            
            // Calculate expiry date
            Date expiryDate = new Date(System.currentTimeMillis() + jwtTokenProvider.getRefreshTokenValidMillisecond());
            
            // Save or update refresh token in database
            MemberVO member = memberDAO.getMemberById(id);
            if (member.getRefreshToken() == null) {
                memberDAO.saveRefreshToken(id, refreshToken, expiryDate);
            } else {
                memberDAO.updateRefreshToken(id, refreshToken, expiryDate);
            }
            
            Map<String, String> result = new HashMap<>();
            result.put("message", "Login successful");
            
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
    }
    private static final Logger logger = LoggerFactory.getLogger(MemberServiceImpl.class);
    @Override
    public ResponseEntity<Void> refreshToken(HttpServletRequest request, HttpServletResponse response) {
        String accessToken = jwtTokenProvider.resolveToken(request);
        logger.info("Received access token: {}", accessToken);

        if (accessToken != null) {
            String userId;
            try {
                userId = jwtTokenProvider.getUsername(accessToken);
                logger.info("Extracted user ID: {}", userId);
            } catch (Exception e) {
                logger.error("Error extracting user ID from token: {}", e.getMessage());
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }

            MemberVO member = memberDAO.getRefreshTokenByUserId(userId);
            logger.info("Retrieved member: {}", member);

            if (member != null) {
                logger.info("Member refresh token: {}", member.getRefreshToken());
                logger.info("Member refresh token expiry date: {}", member.getRefreshTokenExpiryDate());

                if (member.getRefreshToken() != null && member.getRefreshTokenExpiryDate() != null) {
                    String storedRefreshToken = member.getRefreshToken();
                    Date expiryDate = member.getRefreshTokenExpiryDate();
                    
                    logger.info("Stored refresh token: {}", storedRefreshToken);
                    logger.info("Refresh token expiry date: {}", expiryDate);

                    if (expiryDate.after(new Date()) && jwtTokenProvider.validateToken(storedRefreshToken)) {
                        String newAccessToken = jwtTokenProvider.createAccessToken(userId);
                        jwtTokenProvider.setAccessTokenCookie(response, newAccessToken);
                        
                        logger.info("New access token created and set in cookie");
                        return ResponseEntity.ok().build();
                    } else {
                        logger.error("Refresh token expired or invalid");
                    }
                } else {
                    logger.error("Refresh token or expiry date is null");
                }
            } else {
                logger.error("Member is null");
            }
        } else {
            logger.error("Access token is null");
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
    }
    private String extractRefreshTokenFromCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("REFRESH_TOKEN".equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }
    public ResponseEntity<String> logout(HttpServletRequest request, HttpServletResponse response) {
        // 액세스 토큰 쿠키 삭제
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("ACCESS_TOKEN".equals(cookie.getName())) {
                    cookie.setValue("");
                    cookie.setPath("/");
                    cookie.setMaxAge(0);
                    cookie.setHttpOnly(true);
                    cookie.setSecure(true); // HTTPS를 사용하는 경우
                    response.addCookie(cookie);
                    break;
                }
            }
        }

        // 시큐리티 컨텍스트 초기화
        SecurityContextHolder.clearContext();

        return ResponseEntity.ok("로그아웃 성공");
    }
    
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        MemberVO member = memberDAO.getMemberById(username);
        if (member == null) {
            throw new UsernameNotFoundException("User not found with username: " + username);
        }
        
        List<SimpleGrantedAuthority> authorities = new ArrayList<>();
        if (member.getRole() != null) {
            // UserRole enum을 String으로 변환
            authorities.add(new SimpleGrantedAuthority("ROLE_" + member.getRole().name()));
        } else {
            // 기본 역할 설정 (사용자에게 역할이 없는 경우)
            authorities.add(new SimpleGrantedAuthority("ROLE_USER"));
        }
        
        return new User(member.getId(), member.getPassword(), authorities);
    }
    
    @Override
    public List<MemberVO> getAllMembers() {
        return memberDAO.getAllMembers();
    }

    @Override
    public List<MemberVO> searchMembers(String searchKeyword, String searchType) {
        return memberDAO.searchMembers(searchKeyword, searchType);
    }
    
    @Override
    public void deleteMembers(List<String> memberIds) {
        memberDAO.deleteMembers(memberIds);
    }

    public void registerMember(MemberVO memberVO) throws Exception {
        // 아이디 중복 체크
        if (memberDAO.getMemberById(memberVO.getId()) != null) {
            throw new Exception("이미 존재하는 아이디입니다.");
        }

        // 비밀번호 암호화
        String encodedPassword = passwordEncoder.encode(memberVO.getPassword());
        memberVO.setPassword(encodedPassword);

        // 회원 정보 저장
        memberDAO.insertMember(memberVO);
    }

    @Override
    public void signUp(MemberVO memberVO) throws Exception {
        registerMember(memberVO);
    }
}