<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<title>Write</title>

<link rel="shortcut icon" href="#">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css" />
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/write.css" />

</head>

<body>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

	<div class="container">
		<!-- 로그아웃 -->		
		<header class="loginSection">
			<strong>${sessionName}</strong>님 접속 중
			<div class="logout">
				<button id="logoutBtn" type="button" class="btn btn-danger">로그아웃</button>
			</div>
		</header>
		
		
		<c:choose>
			<c:when test="${sessionMemno eq docOutput.memno}">
				<!-- 글 수정 -->
				<form id="boardEditForm" action="${pageContext.request.contextPath}/editBoard">
					<div class="row">
						<input type="hidden" name="docno" value="${docOutput.docno}">
						<span class="col-md-1 text-center"><label>제목</label></span>
						<span class="subjectInput col-md-11"><input type="text" name="subject" maxlength="32" value="${docOutput.subject}"></span>
					</div>
				<textarea name="content" id="editor">${docOutput.content}</textarea>
					<div class="row">
						<span class="col-md-offset-10 col-md-1"><button type="button" class="btn btn-primary" onclick="history.back()" >취소</button></span>
						<span class="col-md-1"><button type="submit" class="btn btn-success">등록</button></span>
					</div>
				</form>
			</c:when>
			<c:otherwise>
				<!-- 새 글 작성 -->
				<form id="boardForm" method="post" action="${pageContext.request.contextPath}/newBoard">
					<div class="row">
						<span class="col-md-1 text-center"><label>제목</label></span>
						<span class="subjectInput col-md-11"><input type="text" name="subject" maxlength="32"></span>
					</div>
				<textarea name="content" id="editor"></textarea>
					<div class="mb row">
						<span class="col-md-offset-10 col-md-1"><button type="button" class="btn btn-primary" onclick="location.href='list'" >목록</button></span>
						<span class="col-md-1"><button type="submit" class="btn btn-success">등록</button></span>
					</div>
				</form>
			</c:otherwise>
		</c:choose>
	</div>

	<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.form/4.2.2/jquery.form.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.1/jquery.validate.min.js"></script>
	<script src="https://cdn.ckeditor.com/ckeditor5/17.0.0/classic/ckeditor.js"></script>
	<script src="${pageContext.request.contextPath}/assets/plugins/ajax/ajax_helper.js"></script>
	<script src="assets/js/common.js"></script>	
	<script src="assets/js/write.js"></script>	
	
	<script type="text/javascript">
	$(function() {
		ClassicEditor.create( document.querySelector( '#editor' ), {
	   		toolbar: ['bold', 'italic', 'link']
	    }).catch( error => { console.error( error ); });	
		
		logout();		// 로그아웃
		
		addDocument();	// 게시글 등록
		editDocument(); // 게시글 수정
	});
	</script>
</body>
</html>