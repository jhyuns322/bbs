package com.son.bbs.service.impl;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.son.bbs.model.Recommend;
import com.son.bbs.service.RecommendService;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class RecommendServiceImpl implements RecommendService {

	@Autowired
	SqlSession sqlSession;

	@Override
	public int getRecommendCount(Recommend input) throws Exception {
		int result = 0;
		try {
			// 3) memno와 comno가 일치하는 데이터 조회 결과
			// 0 = 추천하지 않은 댓글 / 1 = 이미 추천한 댓글
			result = sqlSession.selectOne("RecommendMapper.selectRecCount", input);
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			throw new Exception("데이터 조회에 실패했습니다.");
		}
		return result;
	}
	
	@Override
	public int addRecommend(Recommend input) throws Exception {
		int result = 0;
		try {
				// 5-2) comment 테이블의 recommend 컬럼에 +1
				sqlSession.selectOne("CommentMapper.upRecCount", input);
				// 5-3) 추천 데이터 저장
				result = sqlSession.insert("RecommendMapper.insertRecItem", input);
			if (result == 0) {
				throw new NullPointerException("result=0");
			}
		} catch (NullPointerException e) {
			log.error(e.getLocalizedMessage());
			throw new Exception("저장된 데이터가 없습니다.");
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			throw new Exception("데이터 저장에 실패했습니다.");
			}
		return result;
	}

	@Override
	public int deleteRecommend(Recommend input) throws Exception {
		int result = 0;
		try {
				// 6-2) comment 테이블의 recommend 컬럼에 -1
				sqlSession.selectOne("CommentMapper.downRecCount", input);
				// 6-3) 추천 데이터 삭제
				result = sqlSession.insert("RecommendMapper.deleteRecItem", input);
			if (result == 0) {
				throw new NullPointerException("result=0");
			}
		} catch (NullPointerException e) {
			log.error(e.getLocalizedMessage());
			throw new Exception("저장된 데이터가 없습니다.");
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			throw new Exception("데이터 저장에 실패했습니다.");
			}
		return result;
	}

	@Override
	public List<Recommend> getRecommendList(int input) throws Exception {
		List<Recommend> result = null;
		try {
			result = sqlSession.selectList("RecommendMapper.selectRecList", input);
			if (result == null) {
				throw new NullPointerException("result == null");
			}
		} catch (NullPointerException e) {
			log.error(e.getLocalizedMessage());
			throw new Exception("조회된 데이터가 없습니다.");
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			throw new Exception("데이터 조회에 실패했습니다.");
		}
		return result;
	}
}
