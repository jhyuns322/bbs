<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
		<!-- 로그인/로그아웃/회원가입 -->	
		<header class="loginSection">
			<c:choose>
				<c:when test="${empty sessionUserid}">
					<form id="loginForm" method="post" action="${pageContext.request.contextPath}/login">
						<div class="col-xs-9 col-md-6">	
							<div class="row">
								<div class="col-xs-3 col-md-1"><strong>ID</strong></div>
								<div class="col-xs-9 col-md-3"><input type=text name=userid placeholder="ID = member"></div>
								<div class="col-xs-3 col-md-1 col-md-offset-2"><strong>P/W</strong></div>
								<div class="col-xs-9 col-md-3"><input type=password name=password placeholder="P/W = 123qwe"></div>
							</div>
						</div>
						<div class="col-xs-3 col-md-2">
							<div class="col-xs-12 col-md-1"><button type="submit" class="login btn btn-primary">로그인</button></div>
						</div>
						<div class="col-xs-3 col-xs-offset-9 col-md-2 col-md-offset-1">
							<div class="col-md-1"><button id="open_modal_btn" type="button" class="joinBtn btn btn-success">회원가입</button></div>
						</div>
					</form>
				</c:when>
				<c:otherwise>
					<span><strong>${sessionName}</strong>님 접속 중</span>
					<div class="logout"><button id="logoutBtn" type="button" class="btn btn-danger">로그아웃</button></div>
				</c:otherwise>
			</c:choose>
		</header>