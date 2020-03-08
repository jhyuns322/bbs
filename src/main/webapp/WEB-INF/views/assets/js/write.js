function addDocument() {
	$('#newBoardBtn').on('click', function() {

		var queryString = $("form[id=boardForm]").serialize();

		$.ajax({
			data : queryString,
			type : 'POST',
			url : 'newBoard',
			success : function(json) {
				alert("게시글 저장 완료");
				location.href = "view?docno=" + json.item.docno;
			}
		});
	})
}

function editDocument() {
	$('#editBoardBtn').on('click', function() {

		var queryString = $("form[id=boardEditForm]").serialize();

		$.ajax({
			data : queryString,
			type : 'PUT',
			url : 'editBoard',
			success : function(json) {
				alert("게시글 수정 완료");
				location.href = "view?docno=" + json.item.docno;
			}
		});
	})
}

function summerNote() {
	$('#summernote').summernote({
		minHeight : 420,
		maxHeight : 420,
		toolbar: [
	        ['style', ['style']],
	        ['style', ['bold', 'italic', 'underline', 'strikethrough', 'clear']],
	        ['textsize', ['fontsize']],
	        ['color', ['color']],
	        ['alignment', ['paragraph', 'lineheight']],
	        ['height', ['height']],
	        ['table', ['table']],
	        ['insert', ['picture','link']]
	    ],
		callbacks : {
			onImageUpload : function(files) {
				sendFile(files[0], this);
			}
		}
	});
}

function sendFile(file, editor) {
	data = new FormData();
	data.append("file", file);
	$.ajax({
		data : data,
		type : "POST",
		url : 'imgUpload',
		cache : false,
		contentType : false,
		enctype : 'multipart/form-data',
		processData : false,
		success : function(json) {

			$(editor).summernote('insertImage', json.item);
		}
	});
}