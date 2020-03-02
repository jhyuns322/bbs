function addComment() {
	$("#commentForm").ajaxForm({
		method : "POST",
		success : function(json) {
			if (json.rt == "OK") {
				alert("댓글 작성 완료");
				location.reload(true);
			}
		}
	});	
}

function deleteComment(contextPath) {
	$(".comDelete").click(function(e) {
		e.preventDefault();
		
		let current = $(this);
		let comno = current.data("comno");
		let docno = current.data("docno");
		
		$.delete(contextPath + "/commentDelete", {"comno" : comno, "docno" : docno},
				function(json) {
					if (json.rt == "OK") {
						alert("댓글 삭제 완료");
						location.reload(true);
				}
			});
		});
}

function deleteDocument(contextPath) {
	$(".docDelete").click(function() {

		let current = $(this);
		let docno = current.data("docno");
		
		$.delete(contextPath + "/documentDelete", {"docno" : docno},
				function(json) {
					if (json.rt == "OK") {
						alert("게시글 삭제 완료");
						location.href = "list";
				}
			});
		});
}

function addRecommend() {
	$(".addRecommend").click(function(e) {
		e.preventDefault();
		
		let current = $(this);
		let memno = current.data("memno");
		let comno = current.data("comno");
		
		if (memno == "") {
			alert("로그인 후 이용 가능합니다.");
		} else {
			// 1) memno와 comno의 값을 addReco 컨트롤러에 전송
			$.ajax({
				url : "addReco",
				data : { "memno": memno, "comno": comno },
				type : "POST",
				success : function(json) {
					// 7) recOutput의 값에 따라 다르게 처리
					if (json.item == 0) {
						alert("추천 완료");
						location.reload(true);
					} else if (json.item == 1) {
						alert("추천 취소");
						location.reload(true);								
					}
				}
			});
		}
	})	
}