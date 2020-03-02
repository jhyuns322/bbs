package com.son.bbs.service.impl;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.son.bbs.model.Hit;
import com.son.bbs.service.HitService;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class HitServiceImpl implements HitService {

	@Autowired
	SqlSession sqlSession;

	@Override
	public int getHitCount(Hit input) throws Exception {
		int result = 0;
		try {
			result = sqlSession.selectOne("HitMapper.selectHitCount", input);
			
			if (result == 0) {
				sqlSession.insert("HitMapper.insertHitItem", input);
				sqlSession.update("DocumentMapper.upHitComment", input);
			}
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			throw new Exception("데이터 조회에 실패했습니다.");
		}
		return result;
	}

	@Override
	public int deleteAllHit() throws Exception {
		int result = 0;
		try {
			result = sqlSession.delete("CommentMapper.deleteCom");
		} catch (NullPointerException e) {
			log.error(e.getLocalizedMessage());
			throw new Exception("삭제된 데이터가 없습니다.");
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			throw new Exception("데이터 삭제에 실패했습니다.");
		}
		return result;
	}
	
}
