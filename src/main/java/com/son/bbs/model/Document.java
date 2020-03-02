package com.son.bbs.model;

import lombok.Data;

@Data
public class Document {
	// 1) 기본 컬럼
	private int docno;			// 기본키
	private String regdate;		// 등록 일자
	private String editdate;	// 수정 일자
	private String subject;		// 제목
	private String content;		// 내용
	private int hits;			// 조회수
	private int comment;		// 댓글 수
	private String img;			// 이미지 경로
	
	// 2) 외래키
	private int memno;			// 회원 기본키
	
	// 3) Join절에 따른 추가 컬럼
	private String name;		// 회원 닉네임
	
	// 4) 페이지 구현을 위한 static 변수
	private static int offset;		/** LIMIT 절에서 사용할 조회 시작 위치 */
	private static int listCount; 	/** LIMIT 절에서 사용할 조회 데이터 수 */
	
	public static int getOffset() {
		return offset;
	}
	
	public static void setOffset(int offset) {
		Document.offset = offset;
	}
	
	public static int getListCount() {
		return listCount;
	}
	
	public static void setListCount(int listCount) {
		Document.listCount = listCount;
	}
}
