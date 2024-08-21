package com.springbook.biz.controller;

import com.springbook.biz.handler.NotificationHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Controller
public class NotificationController {

    @Autowired
    private NotificationHandler notificationHandler;

    @PostMapping("/insertBoard")
    public String insertBoard(@RequestBody BoardVO board) {
        // 공지사항 저장 로직
        // ...

        // 알림 전송
        try {
            notificationHandler.sendNotificationToAll("새 공지사항: " + board.getTitle());
        } catch (IOException e) {
            e.printStackTrace();
        }

        return "redirect:getBoardList";
    }
}