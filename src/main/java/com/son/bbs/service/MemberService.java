package com.son.bbs.service;

import com.son.bbs.model.Member;

public interface MemberService {

	public Member getMemberInfo(Member input) throws Exception;
	
	public int getMemberCount(Member input) throws Exception;
	
	public int addMember(Member input) throws Exception;
}
