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
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/summernote@0.8.16/dist/summernote.min.css">

</head>

<body>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

	<div class="container">
	<%@ include file="./inc/header.jsp"%>
		
		<c:choose>
			<c:when test="${sessionMemno eq docOutput.memno}">
				<!-- 글 수정 -->
				<form id="boardEditForm" action="${pageContext.request.contextPath}/editBoard">
					<div class="row">
						<input type="hidden" name="docno" value="${docOutput.docno}">
						<div class="col-md-1 text-center"><label>제목</label></div>
						<div class="subjectInput col-md-11"><input type="text" name="subject" maxlength="32" value="${docOutput.subject}"></div>
					</div>
				<textarea id="summernote" name="content">${docOutput.content}</textarea>
					<div class="row">
						<div class="col-md-offset-10 col-md-1"><button type="button" class="btn btn-primary" onclick="history.back()" >취소</button></div>
						<div class="col-md-1"><button type="submit" class="btn btn-success">등록</button></div>
					</div>
				</form>
			</c:when>
			<c:otherwise>
				<!-- 새 글 작성 -->
				<form id="boardForm" method="post" action="${pageContext.request.contextPath}/newBoard">
					<div class="row">
						<div class="col-md-1 text-center"><label>제목</label></div>
						<div class="subjectInput col-md-11"><input type="text" name="subject" maxlength="32"></div>
					</div>
				<textarea id="summernote" name="content"></textarea>
					<div class="row">
						<div class="col-md-offset-10 col-md-1"><button type="button" class="btn btn-primary" onclick="location.href='list'" >목록</button></div>
						<div class="col-md-1"><button type="submit" class="btn btn-success">등록</button></div>
					</div>
				</form>
			</c:otherwise>
		</c:choose>
	</div>

	<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.form/4.2.2/jquery.form.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.1/jquery.validate.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.16/dist/summernote.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/plugins/ajax/ajax_helper.js"></script>
	<script src="assets/js/common.js"></script>	
	<script src="assets/js/write.js"></script>	
	
	<script type="text/javascript">
	$(function() {

		$('#summernote').summernote({
	        minHeight: 400,
	        maxHeight: 400,
	        lang: "ko-KR",
	        callbacks: {
	        	onImageUpload : function(files) {
	        				uploadSummernoteImageFile(files[0],this);
	        		 }
	        	}
	      });
		
		function uploadSummernoteImageFile(file, editor) {
			data = new FormData();
			data.append("file", file);
			$.ajax({
				data : data,
				type : "POST",
				url : "imgUpload",
				contentType : false,
				processData : false,
				success : function(data) {
	            	//항상 업로드된 파일의 url이 있어야 한다.
					$(editor).summernote('insertImage', data.url);
				}
			});
		}

		logout();		// 로그아웃
		
		addDocument();	// 게시글 등록
		editDocument(); // 게시글 수정
	});
	</script>
</body>
</html>