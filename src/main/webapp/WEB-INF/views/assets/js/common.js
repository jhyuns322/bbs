function login() {
	$("#loginForm").ajaxForm({
		method : "POST",
		success : function(json) {
			if (json.rt == "OK") {
				alert("로그인 완료");
				location.reload(true);
			}
		}
	});
}

function join() {
	$("#joinForm").ajaxForm({
		method : "POST",
		success : function(json) {
			if (json.rt == "OK") {
				alert("회원가입 완료");
				location.reload(true);
			}
		}
	});
}

function logout() {
	$("#logoutBtn").click(function() {
		$.ajax({
			url : "logout",
			success : function() {
				alert("로그아웃 완료");
				location.href = "list";
			}
		});
	});
}

function idCheck() {
	$("#useridChk").click(function() {
		var vaild = $("#userid").valid();

		if (vaild == true) {
			var userid = $("#userid").val();
		} else {
			alert("아이디를 입력하세요.");
		}

		$.ajax({
			url : "useridChk?userid=" + userid,
			method : "GET",
			success : function(json) {
				if (json.item == 0) {
					alert("사용 가능한 아이디입니다.");
				} else {
					alert("이미 존재하는 아이디입니다.");
				}
			}
		});
	});
}

function nameCheck () {
	$("#nameChk").click(function() {
		var vaild = $("#name").valid();
		var name = "";
		if (vaild == true) {
			name = $("#name").val();
			name = encodeURI(name);
		} else {
			alert("닉네임을 입력하세요.");
		}
		
		$.ajax({
			url : "nameChk?name=" + name,
			method : "GET",
			success : function(json) {
				if (json.item == 0) {
					alert("사용 가능한 닉네임입니다.");
				} else {
					alert("이미 존재하는 닉네임입니다.");
				}
			}
		});
	});	
}

function modal() {
	$("#open_modal_btn").click(function(e) {
		$("#joinModal").modal('show');
	});
	
	$('.modal').on('hidden.bs.modal', function (e) {
		$(this).removeData('bs.modal');
	});
}