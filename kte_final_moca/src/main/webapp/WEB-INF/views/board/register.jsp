<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang='ko'>
<!-- 헤더에 제이쿼리, 부트스트랩, 우리가 개별 적용할 css를 위한 custom.css 파일까지 다 적용되어 있음 -->
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<style>
	.fileDrop{
		width:100%;
		height:150px;
		border:1px solid gray;
		background-color:lightgray;
		margin:auto;
	}
</style>
<section class="bg-light">
	<div class="container pt-3">
		<div class="row">
			<div class="col-2"></div>
			<div class="col-8">
				<div class="row mt-5 mb-4">
					<div class="col mt-5">
<!-- 					페이지 제목 및 설명 헤더 부분(작성) -->
						<p class="text-center display-5">NOTICE &amp; REVIEW</p>
						<p class="text-center lead">공지사항 &amp; 리뷰</p>
					</div>
				</div>
<%@ include file="/WEB-INF/views/common/btnHeader.jsp" %>
				<div class="row mt-5">
					<div class="col">
						<hr />
<!-- 					페이지 소제목 부분(작성) -->
						<p class="lead"><i class="bi bi-chat-right-heart"></i>글 작성</p>
					</div>
				</div>
				
<!-- 			여기서부터 본문 영역 -->
	<form id="registerForm" action="register" method="POST">
		<input type="hidden" name="cafe_no" value="${cafe_no}" />
		<table>
			<tr>
				<td>카테고리</td>
				<td>
					<select id="category" 
										name="category">
									<option value="공지사항">공지사항</option>
									<option value="이벤트">이벤트</option>
									</select>
				</td>
			</tr>
			<tr>
				<td>제목</td>
				<td><input type="text" name="title" required/></td>
			</tr>
			<tr>
				<td>작성자</td>
				<td>
					${sessionScope.memberInfo.name}
				</td>
			</tr>
			<tr>
				<td>내용</td>
				<td>
					<textarea name="content" rows="30" cols="50"></textarea>
				</td>
			</tr>
			<tr>
				<th colspan="2">
					<input type="submit" id="saveBtn" value="등록"/>
				</th>
			</tr>
		</table>
		<!-- <div>
			<label>FILE DROP HERE</label>
			<div class="fileDrop">
				
			</div>
		</div>
		<div>
			<ul class="uploadList">
			
			</ul>
		</div> -->
	</form>
<!-- 			row클래스로 하나의 행을 생성 -->
<!--			여기 위까지 본문 영역 -->
			</div>
			<div class="col-2">
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
			</div>
		</div>
	</div>
<!-- end of container -->
</section>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	/* $("#saveBtn").click(function(){
		location.href="register";
	}); */

/* // dragenter dragover , drop
	$(".fileDrop").on("dragenter dragover", function(e){
		e.preventDefault();
	});
	
	var contextPath = '${pageContext.request.contextPath}';
	
	$(".fileDrop").on("drop", function(e){
		e.preventDefault();
		var files = e.originalEvent.dataTransfer.files;
		console.log(files);
		
		var maxSize = 10485760;
		var fileSize = 0;
		var formData = new FormData();
		
		for(var i=0; i<files.length; i++){
			fileSize += files[i].size;
			if(fileSize > maxSize){
				alert("업로드 할 수 없는 크기입니다. 10MB 이하만 가능합니다.");
				return false;
			}
			formData.append("file",files[i]);
		} // end for
		console.log("server upload 실행");
		$.ajax({
			type : "POST",
			url : contextPath+'/uploadfile',
			data : formData,
			processData : false,
			contentType : false,
			dataType : "json",
			success : function(result){
				console.log(result);
				for(var i=0; i < result.length; i++){
					var fileInfo = getFileInfo(result[i]);
					console.log(fileInfo);
					var html = "<li>";
					html += "<img src='"+fileInfo.imgSrc+"' alt='attachment' />";
					html +="<div>"
					html +="<a href='"+fileInfo.getLink+"' >"
					html += fileInfo.fileName;
					html +="</a>"
					html +="</div>";
					html +="<div>";
					html +="<a href='"+fileInfo.fullName+"' class='delBtn'>X</a>";
					html +="</div>";
					html +="</li>";
					$(".uploadList").append(html);
				}
			},
			error : function(res){
				alert(res.responseText);
			}
		}); // ajax end
	}); // drop event end

	function getFileInfo(fullName){
		var imgSrc, fileName, getLink;
		// 이미지 인지 확인
		if(fullName.indexOf("s_") >= 0){
			// 이미지 파일
			imgSrc = contextPath+"/displayFile?fileName="+fullName;
			// 다운로드 요청
			getLink = contextPath+"/displayFile?fileName="+fullName.replace("s_","");
		}else{
			// 일반 파일
			imgSrc = contextPath+"/resources/img/file.png";
			// 다운로드 요청
			getLink = contextPath+"/displayFile?fileName="+fullName;
		}
		// 업로드 원본파일 이름
		fileName = fullName.substr(fullName.lastIndexOf("_")+1);
		return {
			fileName : fileName,
			imgSrc : imgSrc,
			fullName : fullName,
			getLink : getLink
		};
	} 
	
	$(".uploadList").on("click",".delBtn",function(e){
		e.preventDefault();
		var target = $(this);
		$.ajax({
			type : "POST",
			url : contextPath+"/deleteFile",
			data : {
				fileName : target.attr("href")
			},
			success : function(data){
				console.log(data);
				// closest : 가장 가까운
				target.closest("li").remove();
			}
		});
	});
	
	// 게시글 등록
	$("#saveBtn").click(function(){
		var str = "";
		var fileList = $(".uploadList .delBtn");
		$(fileList).each(function(index){
			// this == .delBtn
			var fullName = $(this).attr("href");
			str += "<input type='hidden' name='files["+index+"]' value='"+fullName+"' />";
		});
		$("#registerForm").append(str);
		$("#registerForm").submit();
	});
	
	*/
	
</script>
</html>