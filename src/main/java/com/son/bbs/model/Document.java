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
	private String img;			// 이미지 경로
	
	// 2) 외래키
	private int memno;			// 회원 기본키
	
}
