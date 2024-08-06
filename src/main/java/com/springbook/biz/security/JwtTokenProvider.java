package com.springbook.biz.security;

import java.util.Date;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Component;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

@Component
public class JwtTokenProvider {
    @Value("${jwt.secret}")
    private String secretKey;

    private long accessTokenValidMillisecond = 1000L * 5 ; // 
    private long refreshTokenValidMillisecond = 1000L * 60 * 60 * 24 * 7; // 7일

    private final UserDetailsService userDetailsService;

    public JwtTokenProvider(@Qualifier("memberService") UserDetailsService userDetailsService) {
        this.userDetailsService = userDetailsService;
    }

    public String createAccessToken(String userPk) {
        return createToken(userPk, accessTokenValidMillisecond);
    }

    public String createRefreshToken(String userPk) {
        return createToken(userPk, refreshTokenValidMillisecond);
    }

    private String createToken(String userPk, long validMillisecond) {
        Claims claims = Jwts.claims().setSubject(userPk);
        Date now = new Date();
        Date expiration = new Date(now.getTime() + validMillisecond);
        System.out.println("Creating token - Now: " + now + ", Expiration: " + expiration);
        return Jwts.builder()
                .setClaims(claims)
                .setIssuedAt(now)
                .setExpiration(expiration)
                .signWith(SignatureAlgorithm.HS256, secretKey)
                .compact();
    }

    // Jwt 토큰으로 인증 정보를 조회
    public Authentication getAuthentication(String token) {
        UserDetails userDetails = userDetailsService.loadUserByUsername(this.getUserPk(token));
        return new UsernamePasswordAuthenticationToken(userDetails, "", userDetails.getAuthorities());
    }

    // Jwt 토큰에서 회원 구별 정보 추출
    public String getUserPk(String token) {
        return Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token).getBody().getSubject();
    }

    // jwt토큰

    
    public String resolveRefreshToken(HttpServletRequest req) {
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("REFRESH_TOKEN".equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    // Jwt 토큰의 유효성 + 만료일자 확인
    public boolean validateToken(String jwtToken) {
        try {
            Jws<Claims> claims = Jwts.parser().setSigningKey(secretKey).parseClaimsJws(jwtToken);
            Date expiration = claims.getBody().getExpiration();
            Date now = new Date();
            boolean isExpired = expiration.before(now);
            System.out.println("Token expiration: " + expiration);
            System.out.println("Current time: " + now);
            System.out.println("Token expired: " + isExpired);
            
            return !isExpired;
        } catch (Exception e) {
            System.out.println("Token validation failed: " + e.getMessage());
            return false;
        }
    }
}
