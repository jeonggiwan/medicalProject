package com.springbook.biz.security;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.springbook.biz.member.MemberDAOMybatis;

@Component
public class TokenCleanupScheduler {
    private static final Log logger = LogFactory.getLog(TokenCleanupScheduler.class);
    private final MemberDAOMybatis memberDAO;

    public TokenCleanupScheduler(MemberDAOMybatis memberDAO) {
        this.memberDAO = memberDAO;
        logger.info("TokenCleanupScheduler initialized");
    }

    @Scheduled(cron = "0 1 11 * * ?") // 매일 오전 11시 1분에 실행
    public void cleanupExpiredTokens() {
        logger.info("Cleaning up expired tokens at " + new Date());
        memberDAO.removeExpiredRefreshTokens();
    }
}