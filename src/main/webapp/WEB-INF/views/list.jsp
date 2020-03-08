<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<title>List</title>

<link rel="shortcut icon" href="#">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css" />
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/list.css" />

</head>

<body>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

	<div class="container">
	<%@ include file="./inc/header.jsp"%>
	
		<!-- 게시글 리스트 -->
		<form method="get" action="${pageContext.request.contextPath}/list">
			<div class="searchForm col-xs-12 col-md-offset-7 col-md-5 text-center">
				<div class="col-xs-2 col-md-3">
					<select name="subKeyword">
						<option value="">전체</option>
						<option value="name" <c:if test="${subKeyword eq 'name'}"> selected</c:if>>작성자</option>
						<option value="subject" <c:if test="${subKeyword eq 'subject'}"> selected</c:if>>제목</option>
					</select>
				</div>
				<span class="col-xs-8 col-md-6"><input type="search" name="keyword" value="${keyword}" placeholder="검색어를 입력해 주세요."/></span>
				<span class="col-xs-2 col-md-3"><button type="submit" class="btn btn-primary">검색</button></span>
			</div>
		</form>
		<table class="table table-hover">
			<thead>
				<tr>
					<th class="col-md-1 visible-md visible-lg text-center">번호</th>
					<th class="col-xs-5 col-md-5 text-center">제목</th>
					<th class="col-xs-2 col-md-2 text-center">작성자</th>
					<th class="col-xs-3 col-md-3 text-center">작성일</th>
					<th class="col-xs-2 col-md-1 text-center">조회</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<%-- 조회결과가 없는 경우 --%>
					<c:when test="${docOutput == null || fn:length(docOutput) == 0}">
						<tr>
							<td class="text-center" colspan="5">조회된 결과가 없습니다.</td>
						</tr>
					</c:when>
					
					<c:otherwise>
						<c:forEach var="doc" items="${docOutput}" varStatus="status">
							<%-- 상세페이지로 이동하기 위한 URL --%>
							<c:url value="view" var="viewUrl">
								<c:param name="docno" value="${doc.docno}" />
							</c:url>
							<tr class="text-center">
								<td class="visible-md visible-lg">${doc.docno}</td>
									<c:choose>
										<c:when test="${doc.comment > 0}">
											<td><a href="${viewUrl}">${doc.subject}</a><span style="color:red;"> &#40;${doc.comment}&#41;</span></td>
										</c:when>
										<c:otherwise>
											<td><a href="${viewUrl}">${doc.subject}</a></td>
										</c:otherwise>
									</c:choose>
								<td>${doc.name}</td>
								<td>${doc.regdate}</td>
								<td>${doc.hits}</td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
		<div class="col-xs-offset-10 col-md-offset-11"><button type="button" onclick="location.href='write'" class="btn btn-primary">글 쓰기</button></div>
		
		<div class="text-center">
			<!-- 페이지네이션 -->
			<ul class="pagination pagination-sm">
				<!-- 이전 그룹 링크 -->
				<c:choose>
					<c:when test="${pageData.prevPage > 0 }">
						<c:url value="list" var="prevPageUrl">
							<c:param name="page" value="${pageData.prevPage}" />
							<c:param name="keyword" value="${keyword}" />
							<c:param name="subKeyword" value="${subKeyword}" />
						</c:url>
					</c:when>
				</c:choose>
				<li><a href="${prevPageUrl}" aria-label="Previous"><span aria-hidden="true">&laquo;</span> </a></li>
				<!-- 페이지번호 -->
				<c:forEach var="i" begin="${pageData.startPage}" end="${pageData.endPage}" varStatus="status">
					<c:url value="list" var="pageUrl">
						<c:param name="page" value="${i}" />
						<c:param name="keyword" value="${keyword}" />
						<c:param name="subKeyword" value="${subKeyword}" />
					</c:url>
					<c:choose>
						<c:when test="${pageData.nowPage == i}">
							<li class="active"><a href="${pageUrl}">${i}</a></li>
						</c:when>
						<c:otherwise>
							<li><a href="${pageUrl}">${i}</a></li>
						</c:otherwise>
					</c:choose>
				</c:forEach>
				<!-- 다음 그룹 링크 -->
				<c:choose>
					<c:when test="${pageData.nextPage > 0 }">
						<c:url value="list" var="nextPageUrl">
							<c:param name="page" value="${pageData.nextPage}" />
							<c:param name="keyword" value="${keyword}" />
							<c:param name="subKeyword" value="${subKeyword}" />
						</c:url>
					</c:when>
				</c:choose>
				<li><a href="${nextPageUrl}" aria-label="Next"><span aria-hidden="true">&raquo;</span> </a></li>
			</ul>
		</div>
	
	<%@ include file="./inc/join.jsp"%>
	</div>


	<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.form/4.2.2/jquery.form.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.1/jquery.validate.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/plugins/ajax/ajax_helper.js"></script>
	<script src="assets/js/common.js"></script>
		
	<script type="text/javascript">
	$(function() {
		login();		// 로그인
		join();			// 회원가입
		logout();		// 로그아웃
		idCheck();		// 아이디 중복검사
		nameCheck ();	// 닉네임 중복검사
		modal();		// 회원가입 모달창
	});	
	</script>
</body>
</html>
