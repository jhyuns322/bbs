package com.son.bbs.service;

import java.util.List;

import com.son.bbs.model.Recommend;

public interface RecommendService {
	
	public int getRecommendCount(Recommend input) throws Exception;
	
	public int addRecommend(Recommend input) throws Exception;
	
	public int deleteRecommend(Recommend input) throws Exception;

	public List<Recommend> getRecommendList(int input) throws Exception;
 
}
