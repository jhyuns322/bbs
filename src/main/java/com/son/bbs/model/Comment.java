package com.son.bbs.model;

import lombok.Data;

@Data
public class Comment {
	// 1) 기본 컬럼
	private int comno;			// 기본키
	private int parent;			// 부모 댓글
	private String regdate;		// 등록 일자
	private String content;		// 내용
	private String img;			// 이미지 경로
	private int recommend;		// 추천 수
	
	// 2) 외래키
	private int docno;			// 게시글 기본키
	private int memno;			// 회원 기본키
	
	// 3) Join절에 따른 추가 컬럼
	private String name;		// 회원 닉네임
}
