package com.son.bbs.controllers;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.son.bbs.helper.PageData;
import com.son.bbs.helper.WebHelper;
import com.son.bbs.model.Comment;
import com.son.bbs.model.Document;
import com.son.bbs.model.Hit;
import com.son.bbs.model.Recommend;
import com.son.bbs.service.CommentService;
import com.son.bbs.service.DocumentService;
import com.son.bbs.service.HitService;
import com.son.bbs.service.RecommendService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ViewControllers {

	@Autowired
	WebHelper webHelper;

	@Autowired
	DocumentService documentService;
	@Autowired
	CommentService commentService;
	@Autowired
	RecommendService recommendService;
	@Autowired
	HitService hitService;	

	/** 목록 */
	@RequestMapping(value = { "/", "list" }, method = RequestMethod.GET)
	public ModelAndView list(Model model) {

		String keyword = webHelper.getString("keyword", ""); 		// 사용자의 입력값
		String subKeyword = webHelper.getString("subKeyword", "");  // 작성자 또는 제목+내용 중 선택 입력값
		int nowPage = webHelper.getInt("page", 1); // 페이지 번호 (기본값 1)
		int totalCount = 0; // 전체 게시글 수
		int listCount = 10; // 한 페이지당 표시할 목록 수
		int pageCount = 5; // 한 그룹당 표시할 페이지 번호 수
		
		Document docInput = new Document();
		
		// subKeyword의 값에 따라 각각 다르게 처리
		if (subKeyword.equals("name")) {
			docInput.setName(keyword);
		} else if (subKeyword.equals("subject")) {
			docInput.setSubject(keyword);
		} else {
			docInput.setName(keyword);
			docInput.setSubject(keyword);
		}
		
		List<Document> docOutput = null;
		PageData pageData = null;     // 페이지 번호를 계산한 결과가 저장될 객체
		
		try {
			// 전체 게시글 수 조회
			totalCount = documentService.getDocumentCount(docInput);
			pageData = new PageData(nowPage, totalCount, listCount, pageCount);

			// SQL의 LIMIT절에서 사용될 값을 Beans의 static 변수에 저장
			Document.setOffset(pageData.getOffset());
			Document.setListCount(pageData.getListCount());
			
			docOutput = documentService.getDocumentList(docInput);
		} catch (Exception e) {
			return webHelper.redirect(null, e.getLocalizedMessage());
		}
		

		model.addAttribute("docOutput", docOutput);
		model.addAttribute("keyword", keyword);
		model.addAttribute("pageData", pageData);
		model.addAttribute("subKeyword", subKeyword);
		
		return new ModelAndView("list");
	}
	
	/** 상세 */
	@RequestMapping(value = "view", method = RequestMethod.GET)
	public ModelAndView view(Model model) {
		
		// client ip 가져오기
        HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
        String ip = req.getHeader("X-FORWARDED-FOR");
        
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getRemoteAddr();
        }
        if ("0:0:0:0:0:0:0:1".equals(ip)) {
        	ip = "127.0.0.1";
        }
        
		int docno = webHelper.getInt("docno");

		if (docno == 0) {
			return webHelper.redirect(null, "존재하지 않는 게시글입니다.");
		}
		
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar time = Calendar.getInstance();
		String regdate = f.format(time.getTime());
			
		Document docInput = new Document();
		docInput.setDocno(docno);
		
		Hit hitInput = new Hit();
		hitInput.setIp(ip);
		hitInput.setRegdate(regdate);
		hitInput.setDocno(docno);
		
		Document docOutput = null;
		int hitOutput = 0;
		List<Comment> comOutput = null;
		List<Recommend> recOutput = null;
		int comCountOutput = 0;
		
		HttpSession session = webHelper.getSession();

		try {
			docOutput = documentService.getDocumentView(docInput);
			comOutput = commentService.getCommentList(docno);
			comCountOutput = commentService.getCommentCount(docno);
			hitOutput = hitService.getHitCount(hitInput);
			
			if (session.getAttribute("sessionMemno") != null) {
					int memno = (int) session.getAttribute("sessionMemno");
					recOutput = recommendService.getRecommendList(memno);
			}
		} catch (Exception e) {
			return webHelper.redirect(null, e.getLocalizedMessage());
		}
		
		model.addAttribute("docOutput", docOutput);
		model.addAttribute("comCountOutput", comCountOutput);
		model.addAttribute("comOutput", comOutput);
		model.addAttribute("recOutput", recOutput);
		model.addAttribute("hitOutput", hitOutput);
		
		return new ModelAndView("view");
	}
	
	/** 쓰기 */
	@RequestMapping(value = "write", method = RequestMethod.GET)
	public ModelAndView write(Model model) {
		
		int docno = webHelper.getInt("docno");
		
		if (docno != 0) {
			
			Document docInput = new Document();
			docInput.setDocno(docno);
			
			Document docOutput = null;
			
			try {
				docOutput = documentService.getDocumentView(docInput);
				
				HttpSession session = webHelper.getSession();
				int sessionMemno = (int) session.getAttribute("sessionMemno");
				int memno = docOutput.getMemno();
				if (sessionMemno != memno) {
					return webHelper.redirect(null, "접근 권한이 없습니다.");
				}
				
			} catch (Exception e) {
				return webHelper.redirect(null, e.getLocalizedMessage());
			}
			model.addAttribute("docOutput", docOutput);
		}
		return new ModelAndView("write");
	}

	// 매일 자정 hit 테이블 데이터 전체 삭제
	@Scheduled(cron="0 0 0 * * ?")
	public void deleteHit() {
		try {
			log.debug("============================"+hitService.deleteAllHit());
		} catch (Exception e) {
			return;
		}
	}
}
