function addDocument() {
	$("#boardForm").ajaxForm({
		method : "POST",
		success : function(json) {
			if (json.rt == "OK") {
				alert("게시글 등록 완료");
				location.href = "view?docno="+json.item.docno;
			}
		}
	});	
}

function editDocument() {
	$("#boardEditForm").ajaxForm({
		method : "PUT",
		success : function(json) {
			if (json.rt == "OK") {
				alert("게시글 수정 완료");
				location.href = "view?docno="+json.item.docno;
			}
		}
	});
}