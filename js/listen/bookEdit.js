var operation = $.getUrlParam("operation");
var categoryId =  $.getUrlParam("categoryId");
var bookId = $.getUrlParam("bookId");
var requestUrl = "";
$(document).ready(function () {
    if(operation == "insert"){
        requestUrl = "/api/listen/Book.php?action="+operation+"Book&categoryId="+categoryId;
    }
    if (operation == "update") {
        requestUrl = "/api/listen/Book.php?action="+operation+"Book&bookId="+bookId;
        $.ajax({
            async:true,
            dataType:"json",
            type:"GET",
            url: "/api/listen/Book.php?action=getBookList&bookId="+bookId,
            success: function (data,status) {
                //alert(data);
                $("#bookName").val(data['bookList'][0]['bookName']);
                $("#authorName").val(data['bookList'][0]['authorName']);
                $("#bookIsbn").val(data['bookList'][0]['bookIsbn']);
                $("#description").val((data['bookList'][0]['description']).replace(/<br\s*\/?>/g, "\n"));
                $("#imagePath").val(data['bookList'][0]['imageUrl']);
            },
            error:function(XMLHttpRequest, textStatus, errorThrown){
                alert("请求失败");
            }
        });
    }
});
function submit_Update(dialog, sxtab) {
    var bookName = $("#bookName").val();
    var authorName = $("#authorName").val();
    var bookIsbn = $("#bookIsbn").val();
    var description = $("#description").val();
    if (bookName == "") {
        openalert('书名不能为空!', 'warn');
        $("#bookName").focus();
        return;
    }
    if (authorName == "") {
        openalert('作者不能为空！', 'warn');
        $("#authorName").focus();
        return;
    } 
    if (bookIsbn == "") {
        openalert('编号不能为空!', 'warn');
        $("#bookIsbn").focus();
        return;
    }
    if (description == "") {
        openalert('编号不能为空!', 'warn');
        $("#description").focus();
        return;
    }
    if(!isCorrectFormat("image",$('#imagePath').val())){
        openalert("文件类型不合法,只能是jpg、gif、bmp、png、jpeg类型！",'warn');
        $('#imagePath').focus();
        return ;
    }
    var response = null;
    var formData = new FormData($("#bookForm")[0]); 
    $.ajax({  
        url: requestUrl ,  
        type: 'POST',  
        data: formData,
        dataType:"json",  
        async: false,   //
        cache: false,     //上传文件不需要缓存
        contentType: false,  //由<form>表单构造的FormData对象
        processData: false,  //因为data值是FormData对象，不需要对数据做处理
        success: function (data,status) { 
            //alert(data);
            response = data;
        },  
        error: function () {  
            alert("上传失败");  
        }  
     });  
    if (response!=null && response.resCode=="S456") {
        return true;
    }
    else {
        return false;
    }
}
