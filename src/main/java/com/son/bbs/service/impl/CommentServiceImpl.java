package com.son.bbs.service.impl;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.son.bbs.model.Comment;
import com.son.bbs.service.CommentService;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class CommentServiceImpl implements CommentService  {

	@Autowired
	SqlSession sqlSession;
	
	@Override
	public int addComment(Comment input) throws Exception {
		int result = 0;
		try {
			result = sqlSession.insert("CommentMapper.insertComItem", input);
			sqlSession.update("DocumentMapper.upDocComment", input);
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
	public List<Comment> getCommentList(int input) throws Exception {
		List<Comment> result = null;
		try {
			result = sqlSession.selectList("CommentMapper.selectComList", input);
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

	@Override
	public int getCommentCount(int input) throws Exception {
		int result = 0;
		try {
			result = sqlSession.selectOne("CommentMapper.selectComCount", input);
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			throw new Exception("데이터 조회에 실패했습니다.");
		}
		return result;
	}

	@Override
	public int deleteComment(Comment input) throws Exception {
		int result = 0;
		try {
			result = sqlSession.delete("CommentMapper.deleteCom", input);
			sqlSession.update("DocumentMapper.downDocComment", input);
			if (result == 0) {
				throw new NullPointerException("result=0");
			}
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
