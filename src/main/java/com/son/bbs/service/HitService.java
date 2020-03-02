package com.son.bbs.service;

import com.son.bbs.model.Hit;

public interface HitService {
	
	public int getHitCount(Hit input) throws Exception;

	public int deleteAllHit() throws Exception;
}
