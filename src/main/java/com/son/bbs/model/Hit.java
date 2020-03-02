package com.son.bbs.model;

import lombok.Data;

@Data
public class Hit {
	// 1) 기본 컬럼
	private int hitno;			// 기본키
	private String ip;			// 아이피
	private String regdate;		// 등록 일자
	
	// 2) 외래키
	private int docno;			// 게시글 기본키
}
