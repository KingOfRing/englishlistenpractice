var operation = $.getUrlParam("operation");
var bookId =  $.getUrlParam("bookId");
var articleId = $.getUrlParam("articleId");
var requestUrl = "";
$(document).ready(function () {
    if(operation == "insert"){
        requestUrl = "/api/speak/Article.php?action="+operation+"Article&bookId="+bookId;
    }
    if (operation == "update") {
        requestUrl = "/api/speak/Article.php?action="+operation+"Article&bookId="+bookId+"&articleId="+articleId;
        $.ajax({
            async:true,
            dataType:"json",
            type:"GET",
            url:"/api/speak/Article.php?action=getArticleList&articleId="+articleId,
            success: function (data,status) {
                $("#articleTitle").val(data['articleList'][0]['articleTitle']);
                $("#authorName").val(data['articleList'][0]['authorName']);
                $("#description").val((data['articleList'][0]['description']).replace(/<br\s*\/?>/g, "\n"));
            },
            error:function(XMLHttpRequest, textStatus, errorThrown){
                alert("请求失败");
            }
        });
    }
});
function submit_Update(dialog, sxtab) {
    var articleTitle = $("#articleTitle").val();
    var authorName = $("#authorName").val();
    var description = $("#description").val();
    if (articleTitle == "") {
        openalert('标题不能为空!', 'warn');
        $("#articleTitle").focus();
        return;
    }
    if (authorName == "") {
        openalert('作者不能为空！', 'warn');
        $("#authorName").focus();
        return;
    } 
    if (description == "") {
        openalert('介绍不能为空!', 'warn');
        $("#description").focus();
        return;
    }
    var response = null;
    var formData = new FormData($("#articleForm")[0]); 
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
