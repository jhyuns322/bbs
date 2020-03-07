<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<title>View</title>

<link rel="shortcut icon" href="#">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css" />
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/view.css" />

</head>

<body>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

	<div class="container">
	<%@ include file="./inc/header.jsp"%>
		
		<!-- 게시글 머리 -->
		<section>
			<article class="row">
				<h2>${docOutput.subject}</h2>
				<span class= "col-md-3">작성자 : ${docOutput.name}</span>
				<span class= "col-md-3">등록일 : ${docOutput.regdate}</span>
				<c:choose>
					<c:when test='${docOutput.editdate ne null}'>
						<span class= "col-md-3">수정일 : ${docOutput.editdate}</span>
						<span class= "col-md-2">조회수 : ${docOutput.hits}</span>
						<a href="list"><span class= "glyphicon glyphicon-home"></span></a>
					</c:when>
					<c:otherwise>
						<span class= "col-md-2">조회수 : ${docOutput.hits}</span>
						<span class= "col-md-offset-3"><a class="glyphicon glyphicon-home" href="list"></a></span>
					</c:otherwise>
				</c:choose>
			</article>
			
			<!-- 게시글 본문 -->
			<article class="row contentSection">
				<p>${docOutput.content}</p>	
			</article>
			<c:choose>
				<c:when test="${docOutput.memno eq sessionMemno}">
					<div class="row">
						<span class="col-md-offset-10 col-md-1"><button type="button" data-docno="${docOutput.docno}" class="docDelete btn btn-danger">삭제</button></span>
						<span class="col-md-1"><button type="button" onclick="location.href='write?docno=${docOutput.docno}'" class="btn btn-success">수정</button></span>
					</div>
				</c:when>
			</c:choose>
		</section>
		
		<!-- 댓글 입력 영역 -->
		<div> 댓글 수 <strong>${comCountOutput}</strong> 개</div>
		<section class="commentSection">
			<form id="commentForm" method="post" action="${pageContext.request.contextPath}/newComment">
				<div class="row">
					<c:choose>
						<c:when test="${empty sessionUserid}">					
						<span>로그인  후 댓글 쓰기가 가능합니다.</span>
						</c:when>
						<c:otherwise>
						<span class= "col-md-2"><label>${sessionName}</label></span>
						<span class= "col-md-8 commentInput"><input type="text" name="content" maxlength="200"></span>
						<span class= "col-md-1"><button type="submit" class="btn btn-primary">작성</button></span>
						<input type="hidden" name="memno" value="${sessionMemno}">
						<input type="hidden" name="docno" value="${docOutput.docno}">
						</c:otherwise>	
					</c:choose>
				</div>
			</form>
			
				<!-- 댓글 리스트 영역 -->
				<c:choose>
					<%-- 조회결과가 없는 경우 --%>
					<c:when test="${comOutput == null || fn:length(comOutput) == 0}">
						<div>아직 등록된 댓글이 없습니다.</div>
					</c:when>
					<c:otherwise>
						<c:forEach var="com" items="${comOutput}" varStatus="status">
						<div class="row">
							<div class="comments col-md-offset-1">
								<span class="col-md-2">${com.name}</span>
								<span class="col-md-5 text-left">${com.content}</span>
								<span class="col-md-2">${com.regdate}</span>
								<c:forEach var="rec" items="${recOutput}" varStatus="status">
									<c:choose>
										<c:when test="${com.comno eq rec.comno}">
										<span class="recommend">
										</c:when>
									</c:choose>	
								</c:forEach>
								<span class="heart col-md-1"><a href="#" data-comno="${com.comno}" data-memno="${sessionMemno}" class="addRecommend glyphicon glyphicon-heart"></a>&nbsp;&nbsp;&nbsp;${com.recommend}</span></span>					
								<c:choose>
									<c:when test="${com.memno eq sessionMemno}">
										<span class="col-md-1"><a href="#" data-comno="${com.comno}" data-docno="${docOutput.docno}" class="comDelete glyphicon glyphicon-remove"></a></span>
									</c:when>
								</c:choose>
							</div>
						</div>
						</c:forEach>
					</c:otherwise>
				</c:choose>
		</section>
		
	<%@ include file="./inc/join.jsp"%>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.form/4.2.2/jquery.form.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.1/jquery.validate.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/plugins/ajax/ajax_helper.js"></script>
	<script src="assets/js/common.js"></script>
	<script src="assets/js/view.js"></script>
	
	<script type="text/javascript">
	$(function() {
		var contextPath = "${pageContext.request.contextPath}";
		
		modal();		// 회원가입 모달창	
		join();			// 회원가입	
		idCheck();		// 아이디 중복검사
		nameCheck ();	// 닉네임 중복검사		
		login();		// 로그인
		logout();		// 로그아웃

		addComment();					// 댓글 작성
		deleteComment(contextPath);		// 댓글 삭제
		deleteDocument(contextPath);	// 게시글 삭제
		addRecommend();					// 추천
	});
	</script>
</body>
</html>