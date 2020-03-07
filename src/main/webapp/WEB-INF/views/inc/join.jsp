<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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