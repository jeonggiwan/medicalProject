package com.springbook.biz.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springbook.biz.VO.ScheduleVO;
import com.springbook.biz.schedule.ScheduleService;
import com.springbook.biz.security.JwtTokenProvider;

@Controller
public class ScheduleController {

	@Autowired
	private ScheduleService scheduleService;

	@Autowired
	private JwtTokenProvider jwtTokenProvider;

	//메모 저장
	@PostMapping("/saveSchedule")
	@ResponseBody
	public ResponseEntity<String> saveSchedule(@RequestParam String day, @RequestParam String detail,
			HttpServletRequest request) {
		try {

			String token = jwtTokenProvider.resolveToken(request);
			if (token != null && jwtTokenProvider.validateToken(token)) {
				String id = jwtTokenProvider.getUsername(token);

				//yyyy-MM-dd로 변경
				SimpleDateFormat inputFormat = new SimpleDateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'Z", Locale.ENGLISH);
				Date date = inputFormat.parse(day);

				//yyyyMMdd로 변경
				SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
				String dateStr = outputFormat.format(date);


				ScheduleVO schedule = new ScheduleVO();
				schedule.setId(id);
				schedule.setDay(dateStr);
				schedule.setDetail(detail);

				// 기존 일정 확인
				ScheduleVO existingSchedule = scheduleService.getSchedule(schedule);

				if (existingSchedule != null) {
					// 기존 일정이 있으면 업데이트
					scheduleService.updateSchedule(schedule);
				} else {
					// 새로운 일정이면 삽입
					scheduleService.insertSchedule(schedule);
				}

				return ResponseEntity.ok("success");
			} else {
				return ResponseEntity.status(401).body("인증이 필요합니다.");
			}
		} catch (ParseException e) {
			return ResponseEntity.badRequest().body("Invalid date format: " + e.getMessage());
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(500).body("Error: " + e.getMessage());
		}
	}

	//메모 불러오기
	@GetMapping("/getSchedule")
	@ResponseBody
	public ResponseEntity<ScheduleVO> getSchedule(@RequestParam String day, HttpServletRequest request) {
		try {
			System.out.println("Received request for day: " + day);

			String token = jwtTokenProvider.resolveToken(request);
			if (token != null && jwtTokenProvider.validateToken(token)) {
				String id = jwtTokenProvider.getUsername(token);

				ScheduleVO schedule = new ScheduleVO();
				schedule.setId(id);
				schedule.setDay(day);
				ScheduleVO result = scheduleService.getSchedule(schedule);

				return ResponseEntity.ok(result);
			} else {
				return ResponseEntity.status(401).body(null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(500).body(null);
		}
	}
}
