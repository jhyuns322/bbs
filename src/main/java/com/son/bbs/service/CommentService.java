package com.son.bbs.service;

import java.util.List;

import com.son.bbs.model.Comment;

public interface CommentService {

	public List<Comment> getCommentList(int input) throws Exception;
	
	public int getCommentCount(int input) throws Exception;
	
	public int addComment(Comment input) throws Exception;
	
	public int deleteComment(Comment input) throws Exception;
}
