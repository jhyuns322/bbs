package com.son.bbs.controllers;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.son.bbs.helper.RegexHelper;
import com.son.bbs.helper.WebHelper;
import com.son.bbs.model.Comment;
import com.son.bbs.model.Document;
import com.son.bbs.model.Member;
import com.son.bbs.model.Recommend;
import com.son.bbs.service.CommentService;
import com.son.bbs.service.DocumentService;
import com.son.bbs.service.MemberService;
import com.son.bbs.service.RecommendService;

@RestController
public class RestControllers {

	@Autowired
	WebHelper webHelper;
	@Autowired
	RegexHelper regexHelper;
	
	@Autowired
	MemberService memberService;
	@Autowired
	CommentService commentService;
	@Autowired
	DocumentService documentService;
	@Autowired
	RecommendService recommendService;

/* *************************** 로그인, 로그아웃 *************************** */
	
	/** 로그인 */
	@RequestMapping(value = "login", method = RequestMethod.POST)
	public Map<String, Object> login() {
		
		String userid = webHelper.getString("userid");
		String password = webHelper.getString("password");
		
		// 필수 항목에 대한 유효성 검사
		if (userid == null || userid.equals("")) {
			return webHelper.getJsonWarning("아이디를 입력하세요.");
		}
		if (password == null || password.equals("")) {
			return webHelper.getJsonWarning("비밀번호를 입력하세요.");
		}
		
		Member memInput = new Member();
		memInput.setUserid(userid);
		
		Member memOutput = null;
		
		HttpSession session = webHelper.getSession();
		
		try {
			memOutput = memberService.getMemberInfo(memInput);
			
			// 입력 값과 memOutput에 담긴 값의 일치 여부 검사
			if (userid.equals(memOutput.getUserid()) && password.equals(memOutput.getPassword())) {
				session.setAttribute("sessionUserid", userid);
				session.setAttribute("sessionMemno", memOutput.getMemno());
				session.setAttribute("sessionName", memOutput.getName());
			} else {
				return webHelper.getJsonWarning("아이디 또는 비밀번호가 일치하지 않습니다.");
			}
		} catch (Exception e) {
			return webHelper.getJsonError(e.getLocalizedMessage());
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("item", memOutput);
		return webHelper.getJsonData(map);
	}
	
	/** 로그아웃 */
	@RequestMapping(value = "logout", method = RequestMethod.GET)
	public Map<String, Object> logout() {

		// session 모두 초기화
		webHelper.removeAllSession();

		return webHelper.getJsonData();
	}

/* ****************** 아이디 중복검사, 닉네임 중복검사, 회원가입 ****************** */
	
	/** 아이디 중복 검사 */
	@RequestMapping(value = "useridChk", method = RequestMethod.GET)
	public Map<String, Object> useridChk() {

		String userid = webHelper.getString("userid");

		// 필수 항목에 대한 유효성 검사
		if (userid == null || userid.equals("")) {
			return webHelper.getJsonWarning("아이디를 입력하세요.");
		}
		if (!regexHelper.isEngNum(userid)) {
			return webHelper.getJsonWarning("아이디는 영어와 숫자로만 입력 가능합니다.");
		}
		if (userid.length() < 6) {
			return webHelper.getJsonWarning("아이디는 6글자 이상 입력하셔야 합니다.");
		}
		if (userid.length() > 16) {
			return webHelper.getJsonWarning("아이디는 최대 12자까지 입력 가능합니다.");
		}
		
		Member memInput = new Member();
		memInput.setUserid(userid);
		
		int memOutput = 0;
		
		try {
			memOutput = memberService.getMemberCount(memInput);
			
			HttpSession session = webHelper.getSession();
			
			session.setAttribute("sessionUseridChk", userid);
			if (memOutput != 0) {
				return webHelper.getJsonWarning("이미 존재하는 아이디입니다.");
			}
		} catch (Exception e) {
			return webHelper.getJsonError(e.getLocalizedMessage());
		}

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("item", memOutput);
		return webHelper.getJsonData(map);
	}
	
	/** 닉네임 중복 검사 */
	@RequestMapping(value = "nameChk", method = RequestMethod.GET)
	public Map<String, Object> nameChk() {

		String name = webHelper.getString("name");

		// 필수 항목에 대한 유효성 검사
		if (name == null || name.equals("")) {
			return webHelper.getJsonWarning("닉네임을 입력하세요.");
		}
		if (!regexHelper.isKor(name)) {
			return webHelper.getJsonWarning("닉네임은 한글로만 입력 가능합니다.");
		}
		if (name.length() < 2) {
			return webHelper.getJsonWarning("닉네임은 2글자 이상 입력하셔야 합니다.");
		}
		if (name.length() > 8) {
			return webHelper.getJsonWarning("닉네임은 최대 8자까지 입력 가능합니다.");
		}
		
		Member memInput = new Member();
		memInput.setName(name);
		
		int memOutput = 0;
		
		try {
			memOutput = memberService.getMemberCount(memInput);
			
			HttpSession session = webHelper.getSession();
			
			session.setAttribute("sessionNameChk", name);
			if (memOutput != 0) {
				return webHelper.getJsonWarning("이미 존재하는 닉네임입니다.");
			}
		} catch (Exception e) {
			return webHelper.getJsonError(e.getLocalizedMessage());
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("item", memOutput);
		return webHelper.getJsonData(map);
	}
	
	/** 회원 가입 */
	@RequestMapping(value = "join", method = RequestMethod.POST)
	public Map<String, Object> join() {
		
		HttpSession session = webHelper.getSession();
			
		String userid = webHelper.getString("userid");
		String password = webHelper.getString("password");
		String passwordChk = webHelper.getString("passwordChk");
		String name = webHelper.getString("name");
		
		// 필수 항목에 대한 유효성 검사
		if (session.getAttribute("sessionUseridChk") == null) {
			return webHelper.getJsonWarning("아이디 중복 검사가 필요합니다.");
		} else {
			String sessionUserid = (String) session.getAttribute("sessionUseridChk");
			if (!sessionUserid.equals(userid)) {
				return webHelper.getJsonWarning("아이디 중복 검사가 필요합니다.");
			}
		}
		if (password == null || password.equals("")) {
			return webHelper.getJsonWarning("비밀번호를 입력하세요.");
		}
		if (password.length() < 6) {
			return webHelper.getJsonWarning("비밀번호는 6글자 이상 입력하셔야 합니다.");
		}
		if (!password.equals(passwordChk)) {
			return webHelper.getJsonWarning("비밀번호가 일치하지 않습니다.");
		}
		if (session.getAttribute("sessionNameChk") == null) {
			return webHelper.getJsonWarning("닉네임 중복 검사가 필요합니다.");
		} else {
			String sessionName = (String) session.getAttribute("sessionNameChk");
			if (!sessionName.equals(name)) {
				return webHelper.getJsonWarning("닉네임 중복 검사가 필요합니다.");
			}
		}
		webHelper.removeSession("sessionUseridChk");
		webHelper.removeSession("sessionNameChk");
		
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar time = Calendar.getInstance();
		String regdate = f.format(time.getTime());
		
		Member memInput = new Member();
		memInput.setUserid(userid);
		memInput.setPassword(password);
		memInput.setRegdate(regdate);
		memInput.setName(name);
		
		int memOutput = 0;
		
		try {
			memOutput = memberService.addMember(memInput);
		} catch (Exception e) {
			return webHelper.getJsonError(e.getLocalizedMessage());
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("item", memOutput);
		return webHelper.getJsonData(map);
	}

/* ***************************** 댓글 CRUD ***************************** */	
	
	/** 댓글 작성 */
	@RequestMapping(value = "newComment", method = RequestMethod.POST)
	public Map<String, Object> newComment() {
		
		String content = webHelper.getString("content");
		int memno = webHelper.getInt("memno");
		int docno = webHelper.getInt("docno");
		
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar time = Calendar.getInstance();
		String regdate = f.format(time.getTime());
		
		// 필수 항목에 대한 유효성 검사
		if (content == null || content.equals("")) {
			return webHelper.getJsonWarning("덧글 내용을 입력하세요.");
		}
		if (memno == 0) {
			return webHelper.getJsonWarning("로그인 후 이용 가능합니다.");
		}
		if (docno == 0) {
			return webHelper.getJsonWarning("존재하지 않는 게시글입니다.");
		}
		
		Comment comInput = new Comment();
		comInput.setContent(content);
		comInput.setDocno(docno);
		comInput.setMemno(memno);
		comInput.setRegdate(regdate);
		
		int comOutput = 0;
		
		try {
			comOutput = commentService.addComment(comInput);
		} catch (Exception e) {
			return webHelper.getJsonError(e.getLocalizedMessage());
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("item", comOutput);
		return webHelper.getJsonData(map);
	}
	
	/** 댓글 삭제 */
	@RequestMapping(value = "commentDelete", method = RequestMethod.DELETE)
	public Map<String, Object> commentDelete() {
		
		int comno = webHelper.getInt("comno");
		int docno = webHelper.getInt("docno");

		int recommend = 0;
		
		Comment comInput = new Comment();
		comInput.setComno(comno);
		comInput.setDocno(docno);
		comInput.setRecommend(recommend);
		
		try {
			commentService.deleteComment(comInput);
		} catch (Exception e) {
			return webHelper.getJsonError(e.getLocalizedMessage());
		}
		Map<String, Object> map = new HashMap<String, Object>();
		return webHelper.getJsonData(map);
	}

	/** 댓글 추천 */
	@RequestMapping(value = "addReco", method = RequestMethod.POST)
	public Map<String, Object> addReco() {
		
		int memno = webHelper.getInt("memno");
		int comno = webHelper.getInt("comno");
		
		Recommend recInput = new Recommend();
		recInput.setComno(comno);
		recInput.setMemno(memno);
		
		int recOutput = 0;
		
		try {
			// 2) comno와 memno의 값을 조건으로 recommend 테이블에 값이 조회되는지 검사.
			recOutput = recommendService.getRecommendCount(recInput);
			
			// 4) tempOutput의 값
			// 0 = 추천하지 않은 댓글 / 1 = 이미 추천한 댓글
			if (recOutput == 0) {
				// 5-1) 추천하지 않았다면 addRecommend 진입 후 처리
				recommendService.addRecommend(recInput);
			} else {
				// 6-1) 이미 추천하였다면 deleteRecommend 진입
				recOutput = recommendService.deleteRecommend(recInput);
				// 6-4) 처리 성공
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("item", recOutput);
				return webHelper.getJsonData(map);	
			}
		} catch (Exception e) {
			return webHelper.getJsonError(e.getLocalizedMessage());
		}
		// 5-4) 처리 성공
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("item", recOutput);
		return webHelper.getJsonData(map);	
	}
	
/* ***************************** 게시글 CRUD ***************************** */
	
	/** 게시글 작성 */	
	@RequestMapping(value = "newBoard", method = RequestMethod.POST)
	public Map<String, Object> newBoard() {
		
		HttpSession session = webHelper.getSession();
		
		int memno = (int) session.getAttribute("sessionMemno");
		String subject = webHelper.getString("subject");
		String content = webHelper.getString("content");

		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar time = Calendar.getInstance();
		String regdate = f.format(time.getTime());
		
		int comment = 0;
		int hits = 0;
		
		// 필수 항목에 대한 유효성 검사
		if (subject == null || subject.equals("")) {
			return webHelper.getJsonWarning("게시글 제목을 입력하세요.");
		}		
		if (content == null || content.equals("")) {
			return webHelper.getJsonWarning("게시글 내용을 입력하세요.");
		}
		if (memno == 0) {
			return webHelper.getJsonWarning("로그인 후 이용 가능합니다.");
		}
		
		Document docInput = new Document();
		docInput.setContent(content);
		docInput.setSubject(subject);
		docInput.setRegdate(regdate);
		docInput.setHits(hits);
		docInput.setComment(comment);
		docInput.setMemno(memno);

		try {
			documentService.addDocument(docInput);
		} catch (Exception e) {
			return webHelper.getJsonError(e.getLocalizedMessage());
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("item", docInput);
		return webHelper.getJsonData(map);
	}
	
	/** 게시글 수정 */	
	@RequestMapping(value = "editBoard", method = RequestMethod.PUT)
	public Map<String, Object> editBoard() {
		
		String subject = webHelper.getString("subject");
		String content = webHelper.getString("content");
		int docno = webHelper.getInt("docno");

		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar time = Calendar.getInstance();
		String editdate = f.format(time.getTime());
		
		// 필수 항목에 대한 유효성 검사
		if (subject == null || subject.equals("")) {
			return webHelper.getJsonWarning("게시글 제목을 입력하세요.");
		}		
		if (content == null || content.equals("")) {
			return webHelper.getJsonWarning("게시글 내용을 입력하세요.");
		}
		
		Document docInput = new Document();
		docInput.setDocno(docno);
		docInput.setContent(content);
		docInput.setSubject(subject);
		docInput.setEditdate(editdate);

		try {
			documentService.editDocument(docInput);
		} catch (Exception e) {
			return webHelper.getJsonError(e.getLocalizedMessage());
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("item", docInput);
		return webHelper.getJsonData(map);
	}
	
	/** 게시글 삭제 */
	@RequestMapping(value = "documentDelete", method = RequestMethod.DELETE)
	public Map<String, Object> documentDelete() {
		
		int docno = webHelper.getInt("docno");

		Document docInput = new Document();
		docInput.setDocno(docno);
		
		try {
			documentService.deleteDocument(docInput);
		} catch (Exception e) {
			return webHelper.getJsonError(e.getLocalizedMessage());
		}
		Map<String, Object> map = new HashMap<String, Object>();
		return webHelper.getJsonData(map);
	}

/* ***************************** 이미지 업로드 ***************************** */
	
	/** 이미지 업로드 */	
//	@RequestMapping(value = "imgUpload", method = RequestMethod.POST)
//	public Map<String, Object> imgUpload(@RequestParam("file") MultipartFile multipartFile) {
//		
//		String originalFileName = multipartFile.getOriginalFilename();
//		String extension = originalFileName.substring(originalFileName.lastIndexOf("."));
//		
//		System.out.println(originalFileName);
//		System.out.println(extension);
//
//		Map<String, Object> map = new HashMap<String, Object>();
//		map.put("item", originalFileName);
//		return webHelper.getJsonData(map);
//	}

}