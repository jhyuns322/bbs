package com.son.bbs.model;

import lombok.Data;

@Data
public class Member {
	// 1) 기본 컬럼
	private int memno;			// 기본키
	private String userid;		// 아이디
	private String password;	// 비밀번호
	private String name;		// 닉네임
	private String regdate;		// 등록 일자

}
