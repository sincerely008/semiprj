<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/PreparedKitchen/css/recipecomment.css">
<script type="text/javascript" src="js/jquery-3.4.1.min.js"></script>
<script type="text/javascript">

$(function() {
	
	$.ajax({
        url:"recipeComment.do?command=cmtread&recipeBoard_no=${recipeBoardDto.recipeBoard_no }",
        dataType:"text",
        success:function(data) {
			
        		var jdata =JSON.parse(data);
        		var jdata2 = jdata.comments;
				showAllCmt(jdata2);
				if(!$.isEmptyObject(jdata2)){
					pageNum(jdata);
				}
			
        },error:function(request, error){
			alert("code:"+request.status+"\n"+"message:"+request.reponseText+"\n"+"error:"+error);
		}
    });

	$("#commentWrite").click(function() {
		var str = $("#insertform").serialize();
		
	    $.ajax({
	        url:"recipeComment.do",
	        data:str,
	        dataType:"text",
	        success:function(data) {
				if(data == "comment null"){
					alert("댓글을 입력해주세요.")
				}else if(data > 0){
					cmtList();
				}
	        },error:function(request, error){
				alert("code:"+request.status+"\n"+"message:"+request.reponseText+"\n"+"error:"+error);
			}
	        
	    });
	});
	
});

function cmtList() {
	var iscmt = $("#iscmt");

	if(iscmt != null) {
		iscmt.remove();
	}
	$.ajax({
        url:"recipeComment.do?command=cmtread&recipeBoard_no=${recipeBoardDto.recipeBoard_no }",
        dataType:"text",
        success:function(data) {
        		var jdata =JSON.parse(data);
        		var jdata2 = jdata.comments;
				$("#comment_content").val("");
				showAllCmt(jdata2);
				if(!$.isEmptyObject(jdata2)){
					pageNum(jdata);
				}
        },error:function(request, error){
			alert("code:"+request.status+"\n"+"message:"+request.reponseText+"\n"+"error:"+error);
		}
        
    });
}

function pageNum(paging) {

	var html = "";
		if(paging.currentPageNo != paging.firstPageNo){
			html += "<a id='cmtPageNum' onclick='goPage("+paging.prevPageNo+","+paging.recordsPerPage+")'>이전</a>&nbsp;";
		}
        for(var i = paging.startPageNo; i<=paging.endPageNo; i++){
        	if(i == paging.currentPageNo){
        		html += "<b><font size=+1>";
                html += "<a id='cmtPageNum' onclick='goPage("+i+","+paging.recordsPerPage+")'>"+i+"</a>&nbsp;";
                html += "</font></b>";
        	}else{
        		html += "<a id='cmtPageNum' onclick='goPage("+i+","+paging.recordsPerPage+")'>"+i+"</a>&nbsp;";
        	}
        }
        if(paging.currentPageNo != paging.finalPageNo){
        	 html += "&nbsp;<a id='cmtPageNum' onclick='goPage("+paging.nextPageNo+","+paging.recordsPerPage+")'>다음</a>";
        }
		
		$("#showPageNum").html(html);
}

function goPage(pages, lines) {
	
	var url = "&pages=" + pages + "&lines=" + lines + "&recipeBoard_no=${recipeBoardDto.recipeBoard_no }";
	
	$.ajax({
        url:'recipeComment.do?command=cmtread'+url,
        dataType:"text",
        success:function(data) {
			
        		var jdata =JSON.parse(data);
        		var jdata2 = jdata.comments;
				showAllCmt(jdata2);
				pageNum(jdata);
        },error:function(request, error){
			alert("code:"+request.status+"\n"+"message:"+request.reponseText+"\n"+"error:"+error);
		}
        
    });
}

function cmtcmt(cmtno) {
	
	var iscmt = $("#iscmt");
	
	if(iscmt != null) {
		iscmt.remove();
	}
	var html = "<tr id='iscmt'>";
	html += "<td colspan='3'><textarea rows='3' id='cmtcmtcontent' placeholder='댓글을 입력하세요.'></textarea></td>";
	html += "<td colspan='3'><input type='button' value='저장' onclick='cmtcmtUpdate("+cmtno+","+"$(\""+"#cmtcmtcontent\""+").val()"+")'/>";
	html += "<input type='button' value='취소' onclick='cmtList()'/></td>";
	html += "</tr>";
	
	$('#'+cmtno).after(html);
}

function cmtcmtUpdate(cmtno,cmtcmtcontent) {
	
	$.ajax({
        url:"recipeComment.do?command=cmtcmtupdate&recipeBoard_no=${recipeBoardDto.recipeBoard_no }&comment_no="+cmtno+"&comment_content="+cmtcmtcontent,
        dataType:"text",
        success:function(data) {
				if(data > 0){
					cmtList();
				}else{
					alert("저장 실패");					
				}
			
        },error:function(request, error){
			alert("code:"+request.status+"\n"+"message:"+request.reponseText+"\n"+"error:"+error);
		}
    });
	
}

function deleteCmtfn(cmtno) {
	
	 if (confirm("삭제하시겠습니까?") == true){
		$.ajax({
	        url:"recipeComment.do?command=deleteCmt&comment_no="+cmtno,
	        dataType:"text",
	        success:function(data) {
	        	if(data > 0){
	        		cmtList();
	        	}else{
	        		alert("삭제 실패");
	        	}
	        },error:function(request, error){
				alert("code:"+request.status+"\n"+"message:"+request.reponseText+"\n"+"error:"+error);
			}
	    });
	 }else{ 
	     return false;
	 }
	
}

function updateCmtfn(cmtno,cmtcontent) {
	var iscmt = $("#iscmt");
	
	if(iscmt != null) {
		iscmt.remove();
	}
	var html = "<tr id='iscmt'>";
	html += "<td colspan='3'><textarea rows='3' id='updatecnt'>"+cmtcontent+"</textarea></td>";
	html += "<td colspan='3'><input type='button' value='저장' onclick='update("+cmtno+","+"$(\""+"#updatecnt\""+").val()"+")'/>";
	html += "<input type='button' value='취소' onclick='cmtList()'/></td>";
	html += "</tr>";

	$('#'+cmtno).empty();
	$('#'+cmtno).unwrap().wrap(html);
	
			
}

function update(cmtno,cmtcontent) {
	if (confirm("저장하시겠습니까?") == true){
	 	$.ajax({
	        url:"recipeComment.do?command=updateCmt&comment_no="+cmtno+"&comment_content="+cmtcontent,
	        dataType:"text",
	        success:function(data) {
	        	if(data > 0){
	        		cmtList();
	        	}else{
	        		alert("저장 실패");
	        		cmtList();
	        	}
	        },error:function(request, error){
				alert("code:"+request.status+"\n"+"message:"+request.reponseText+"\n"+"error:"+error);
			}
	    });
	}else{
		return false;
	}
}	

function showAllCmt(data) {
		if($.isEmptyObject(data)){
			
			$("#showAllComment").html("<p style='text-align:center;'>작성된 댓글이 없습니다</p>");
			$("#commentContent").val("");
			$("#commentContent").focus();
		}else{
		var	html = "<table id='cmttable'>";
		
		for (var i = 0; i < data.length; i++) {
			
			var id = "${memberDto.id}";
			var cmtId = data[i].id;
			var boo = (id == cmtId);
			html += "<tr class='cmtonebox' id='"+data[i].comment_no+"'>"
			html += "<td class='leftbox'>";
			for(var j = 0; j<data[i].comment_tab; j++){
				html += "<div class='nbsp'>&nbsp;</div>";
				if(j+1==data[i].comment_tab){
					html += "<div>ㄴ</div>";
				}
			}
			html += "<div class='cmtidbox'>"+data[i].id + "</div>";
			html += "</td>";
			html += "<td class='cmtcntbox'><a class='cmtcnt' onclick='cmtcmt("+data[i].comment_no+")'>" + data[i].comment_content + "</a></td>";
			html += "<td class='rightbox'>";
			html += "<div class='cmtdatebox'>" + data[i].comment_regdate + "</div>";
			html += "</td>";
			if(boo){
				html += "<td class='btnbox'><input class='btnud' type='button' value='수정' onclick='updateCmtfn("+data[i].comment_no+",\""+data[i].comment_content+"\")'/></td>";
				html += "<td class='btnbox'><input class='btnud' type='button' value='삭제' onclick='deleteCmtfn("+data[i].comment_no+")'/></td>";
			}
			html += "</tr>";
		}
		html += "</table>";

		$("#showAllComment").html(html);
		$("#commentContent").val("");
		$("#commentContent").focus();
		
	}
}



</script>
</head>
<body>
	
	<div style="margin-top: 10px; width: 100%;">
		<form action="recipeComment.do" method="post" id="insertform">
			<input type="hidden" name="command" value="insertcmt"/>
			<input type="hidden" name="comment_order" value="1"/>
			<input type="hidden" name="comment_tab" value="0"/>
			<input type="hidden" name="recipeBoard_no" value="${recipeBoardDto.recipeBoard_no }"/>
		    <textarea rows="3" id="comment_content" name="comment_content" placeholder="댓글을 입력하세요." style="width: 100%;"></textarea>
	        <c:if test="${memberDto.id != null}">
	            <input type="button" value="댓글 쓰기" id="commentWrite">
	        </c:if>
        </form>
	</div>
	<div style="margin-top: 10px; width: 100%;">
	    <hr/>
	    <div id="showAllComment"></div>
	</div>
	<div id="showPageNum" style="text-align: center;"></div>

</body>
</html>