package com.son.bbs.service;

import java.util.List;

import com.son.bbs.model.Document;

public interface DocumentService {

	public List<Document> getDocumentList(Document input) throws Exception;
	
	public Document getDocumentView(Document input) throws Exception;
	
	public int getDocumentCount(Document input) throws Exception;
	
	public int addDocument(Document input) throws Exception;
	
	public int editDocument(Document input) throws Exception;
	
	public int deleteDocument(Document input) throws Exception;
	
}
