package com.springbook.biz.member;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
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

        // 기본 역할 설정
        memberVO.setRole(UserRole.USER);

        // 회원 정보 저장
        memberDAO.insertMember(memberVO);
    }

    @Override
    public void signUp(MemberVO memberVO) throws Exception {
        registerMember(memberVO);
    }
    
    @Override
    public MemberVO getMemberById(String id) {
        return memberDAO.getMemberById(id);
    }

    @Override
    public Map<String, Boolean> checkDuplication(String id, String email, String phoneNumber) {
        Map<String, Boolean> result = new HashMap<>();
        result.put("idExists", memberDAO.getMemberById(id) != null);
        result.put("emailExists", memberDAO.getMemberByEmail(email) != null);
        result.put("phoneExists", memberDAO.getMemberByPhoneNumber(phoneNumber) != null);
        return result;
    }
    
    @Override
    public boolean verifyCurrentPassword(String userId, String currentPassword) {
        MemberVO member = memberDAO.getMemberById(userId);
        if (member != null) {
            return passwordEncoder.matches(currentPassword, member.getPassword());
        }
        return false;
    }

    @Override
    public boolean changePassword(String userId, String newPassword) {
        MemberVO member = memberDAO.getMemberById(userId);
        if (member != null) {
            String encodedPassword = passwordEncoder.encode(newPassword);
            member.setPassword(encodedPassword);
            return memberDAO.updateMember(member) > 0;
        }
        return false;
    }
    @Override
    public ResponseEntity<String> logout(HttpServletRequest request, HttpServletResponse response) {
        jwtTokenProvider.removeAccessTokenCookie(response);
        SecurityContextHolder.clearContext();
        return ResponseEntity.ok("로그아웃 성공");
    }

    @Override
    public ResponseEntity<String> deleteAccount(String userId, HttpServletResponse response) {
        MemberVO member = memberDAO.getMemberById(userId);
        if (member != null && member.getRole() != UserRole.ADMIN) {
            int result = memberDAO.deleteMember(userId);
            if (result > 0) {
                jwtTokenProvider.removeAccessTokenCookie(response);
                SecurityContextHolder.clearContext();
                return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body("{\"message\": \"계정이 성공적으로 삭제되었습니다.\"}");
            }
        }
        return ResponseEntity.badRequest()
            .contentType(MediaType.APPLICATION_JSON)
            .body("{\"message\": \"계정 삭제에 실패했습니다.\"}");
    }
    
    @Override
    public boolean findIdAndSendEmail(String email, String name) {
        MemberVO member = memberDAO.findMemberByEmailAndName(email, name);
        if (member != null) {
            // 이메일 전송 로직
            String subject = "아이디 찾기 결과";
            String content = "회원님의 아이디는 " + member.getId() + " 입니다.";
            try {
                EmailUtil.sendEmail(email, subject, content);
                return true;
            } catch (Exception e) {
                logger.error("Failed to send email", e);
                return false;
            }
        }
        return false;
    }
    
    @Override
    public boolean resetPasswordAndSendEmail(String email, String id) {
        MemberVO member = memberDAO.findMemberByEmailAndId(email, id);
        if (member != null) {
            // 새 비밀번호 생성 (10자리 랜덤 문자열)
            String newPassword = generateRandomPassword(10);
            
            // 비밀번호 암호화
            String encodedPassword = passwordEncoder.encode(newPassword);
            member.setPassword(encodedPassword);
            
            // DB에 암호화된 새 비밀번호 저장
            int updateResult = memberDAO.updateMember(member);
            
            if (updateResult > 0) {
                // 이메일 전송 로직
                String subject = "비밀번호 재설정";
                String content = "회원님의 새로운 임시 비밀번호는 " + newPassword + " 입니다. 보안을 위해 로그인 후 즉시 비밀번호를 변경해주세요.";
                try {
                    EmailUtil.sendEmail(email, subject, content);
                    return true;
                } catch (Exception e) {
                    logger.error("Failed to send email", e);
                    return false;
                }
            }
        }
        return false;
    }

    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()";
        StringBuilder sb = new StringBuilder();
        Random random = new Random();
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }
}

