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
	
		<!-- 로그인/로그아웃/회원가입 -->	
		<header class="loginSection">
			<c:choose>
				<c:when test="${empty sessionUserid}">
					<form id="loginForm" method="post" action="${pageContext.request.contextPath}/login">
						<div class="row">
							<div class="col-md-9">
								<span class="col-md-1"><label>ID</label></span>
								<span class="col-md-3"><input type=text name=userid placeholder="ID = member"></span>
								<span class="col-md-1"><label>P/W</label></span>
								<span class="col-md-3"><input type=password name=password placeholder="P/W = 123qwe"></span>
								<span class="col-md-1"><button type="submit" class="btn btn-primary">로그인</button></span>
							</div>
							<div class="col-md-3">
								<span class="col-md-offset-2 col-md-1"><button id="open_modal_btn" type="button" class="btn btn-success">회원가입</button></span>
							</div>
						</div>
					</form>
				</c:when>
				<c:otherwise>
			<strong>${sessionName}</strong>님 접속 중
			<div class="logout">
				<button id="logoutBtn" type="button" class="btn btn-danger">로그아웃</button>
			</div>
				</c:otherwise>
			</c:choose>
		</header>
		
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
										<span class="red">
										</c:when>
									</c:choose>	
								</c:forEach>
								<span class="connect col-md-1"><a href="#" data-comno="${com.comno}" data-memno="${sessionMemno}" class="addRecommend glyphicon glyphicon-heart"></a>&nbsp;&nbsp;&nbsp;${com.recommend}</span></span>					
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
	</div>
	
	<!-- 회원가입 모달창 -->
	<div class="modal fade" id="joinModal">
		<div class="modal-dialog modal-l">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">회원 가입</h4>
				</div>
				<form id="joinForm" class="form-horizontal" action="${pageContext.request.contextPath}/join">
				<div class="modal-body">	
					<div class="form-group">
						<!-- 아이디 입력 -->
						<span class="col-md-3"><label>아이디</label></span> 
						<span class="col-md-7"><input type="text" id="userid" name="userid" maxlength="12" placeholder="아이디를 입력하세요."></span>
						<!-- 아이디 중복 검사 버튼 -->
						<span class="col-md-2"><button type="button" id="useridChk" class="btn btn-primary">중복검사</button></span>
					</div>
					<br>					
					<div class="form-group">
						<!-- 비밀번호 입력 -->
						<span class="col-md-3"><label>비밀번호</label></span> 
						<span class="col-md-7"><input type="password" name="password" maxlength="16" placeholder="비밀번호를 입력하세요."></span>
					</div>
					<div class="form-group">
						<!-- 비밀번호 확인 입력 -->
						<span class="col-md-3"><label>비밀번호 확인</label></span>
						<span class="col-md-7"><input type="password" name="passwordChk" maxlength="16" placeholder="비밀번호를 한 번 더 입력하세요."></span>
					</div>
					<br>
					<div class="form-group">
						<!-- 닉네임 입력 -->
						<span class="col-md-3"><label>닉네임</label></span>
						<span class="col-md-7"><input type="text" id="name" name="name" maxlength="8" placeholder="닉네임을 입력하세요."></span>
						<!-- 닉네임 중복 검사 버튼 -->
						<span class="col-md-2"><button type="button" id="nameChk" class="btn btn-primary">중복검사</button></span>
						</div>	
					</div>
				<div class="modal-footer">
					<!-- 가입 완료 버튼 -->
					<span class="col-md-offset-10 col-md-2"><button type="submit" class="btn btn-success">가입 완료</button></span>
				</div>
				</form>
			</div>
		</div>
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

		addComment();		// 댓글 작성
		deleteComment(contextPath);	// 댓글 삭제
		deleteDocument(contextPath);	// 게시글 삭제
		addRecommend();		// 추천
	});
	</script>
</body>
</html>