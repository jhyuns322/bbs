package com.son.bbs.model;

import lombok.Data;

@Data
public class Recommend {
	// 1) 기본 컬럼
	private int reno;
	
	// 2) 외래키
	private int memno;			// 회원 기본키
	private int cono;			// 댓글 기본키

}
