package com.springbook.biz.security;

import java.util.Base64;
import java.util.Date;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

@Component
public class JwtTokenProvider {

    private String secretKey;

    private long accessTokenValidMillisecond = 1000L * 60 * 30; // 30분
    private long refreshTokenValidMillisecond = 1000L * 60 * 60 * 24 * 7; // 7일

    private final UserDetailsService userDetailsService;

    public JwtTokenProvider(@Value("${jwt.secret}") String secretKey, @Lazy UserDetailsService userDetailsService) {
        this.secretKey = Base64.getEncoder().encodeToString(secretKey.getBytes());
        this.userDetailsService = userDetailsService;
    }

    public String createAccessToken(String username) {
        return createToken(username, accessTokenValidMillisecond);
    }

    public String createRefreshToken(String username) {
        return createToken(username, refreshTokenValidMillisecond);
    }

    private String createToken(String username, long validityInMilliseconds) {
        Claims claims = Jwts.claims().setSubject(username);
        Date now = new Date();
        Date validity = new Date(now.getTime() + validityInMilliseconds);

        return Jwts.builder()
                .setClaims(claims)
                .setIssuedAt(now)
                .setExpiration(validity)
                .signWith(SignatureAlgorithm.HS256, secretKey)
                .compact();
    }

    public Authentication getAuthentication(String token) {
        UserDetails userDetails = this.userDetailsService.loadUserByUsername(getUsername(token));
        return new UsernamePasswordAuthenticationToken(userDetails, "", userDetails.getAuthorities());
    }

    public String getUsername(String token) {
        return Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token).getBody().getSubject();
    }


    public String resolveToken(HttpServletRequest req) {
        String bearerToken = req.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        
        // Check for token in cookies
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
    public boolean validateToken(String token) {
        try {
            Jws<Claims> claims = Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token);
            boolean isValid = !claims.getBody().getExpiration().before(new Date());
            System.out.println("Token validation result: " + isValid);
            System.out.println("Token expiration: " + claims.getBody().getExpiration());
            return isValid;
        } catch (JwtException | IllegalArgumentException e) {
            System.out.println("Invalid JWT token: " + e.getMessage());
            return false;
        }
    }
}