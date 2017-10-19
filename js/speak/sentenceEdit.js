var operation = $.getUrlParam("operation");
var bookId =  $.getUrlParam("bookId");
var articleId = $.getUrlParam("articleId");
var sentenceId = $.getUrlParam("sentenceId");
var requestUrl = "";
var response = null;
var task = null;
$(document).ready(function () {
    if(operation == "insert"){
        requestUrl = "/api/speak/Sentence.php?action="+operation+"Sentence&bookId="+bookId
        									  +"&articleId="+articleId;
    }
    if (operation == "update") {
        requestUrl = "/api/speak/Sentence.php?action="+operation+"Sentence&bookId="+bookId
        									  +"&articleId="+articleId
        									  +"&sentenceId="+sentenceId;
        $.ajax({
            async:true,
            dataType:"json",
            type:"GET",
            url:"/api/speak/Sentence.php?action=getSentenceList&sentenceId="+sentenceId,
            success: function (data,status) {
                $("#english").val(data['sentenceList'][0]['english']);
                $("#chinese").val(data['sentenceList'][0]['chinese']);
                $("#voicePath").val(data['sentenceList'][0]['voiceUrl']);
            },
            error:function(XMLHttpRequest, textStatus, errorThrown){
                alert("请求失败");
            }
        });
    }
});
function submit_Update(dialog, sxtab) {
    var progress = $(".progress"); 
    var progress_bar = $(".progress-bar");
    var percent = $('.percent');
    var english = $("#english").val();
    var chinese = $("#chinese").val();
   
    if (english == "") {
        openalert('英文不能为空！', 'warn');
        $("#english").focus();
        return;
    } 
    if (chinese == "") {
        openalert('中文不能为空!', 'warn');
        $("#chinese").focus();
        return;
    }
    if(!isCorrectFormat("voice",$('#voicePath').val())){
        openalert("文件类型不合法,只能是mp3,wma,wav类型！",'warn');
        $('#voicePath').focus();
        return ;
    }
    $("#loading").css("display",'block');
    $("#sentenceForm").ajaxSubmit({ 
        url: requestUrl ,  
        async:false,   //同步操作
        type: 'POST',
        dataType:  'json', //数据格式为
        jsonbeforeSend: function() { //开始上传 
            progress.show();
            var percentVal = '0%';
            progress_bar.width(percentVal);
            percent.html(percentVal);
        }, 
        uploadProgress: function(event, position, total, percentComplete) { 
            var percentVal = percentComplete + '%'; //获得进度 
            progress_bar.width(percentVal); //上传进度条宽度变宽 
            percent.html(percentVal); //显示上传进度百分比 
        }, 
        success: function(data) {
            $("#loading").css("display",'none');
            response = data;
        }, 
        error:function(xhr){ //上传失败 
           alert("上传失败"); 
           progress.hide(); 
        } 
    }); 
    if(response != null){
        if(response.resCode=="S456"){
            return true;
        }
        else if(response.resCode=="E234"){
            alert(response.resMsg);
            return false;
        }
        else{
            return false;
        }
    }
    // var task;
    //task = setInterval(timeTask,1000);
    // var response = null;
    // var formData = new FormData($("#sentenceForm")[0]); 
    // $.ajax({  
    //     url: requestUrl ,  
    //     type: 'POST',  
    //     data: formData,
    //     dataType:"json",  
    //     async: false,   //
    //     cache: false,     //上传文件不需要缓存
    //     contentType: false,  //由<form>表单构造的FormData对象
    //     processData: false,  //因为data值是FormData对象，不需要对数据做处理
    //     success: function (data,status) { 
    //         response = data;
    //     },  
    //     error: function () {  
    //         alert("上传失败");  
    //     }  
    //  });  
    // if (response!=null && response.resCode=="S456") {
    //     return true;
    // }
    // else {
    //     if(response.resCode=="E234"){
    //         alert(response.resMsg);
    //     }
    //     return false;
    // }
}
function timeTask(){
    if(response != null){
        if(response.resCode=="S456"){
            return true;
        }
        else if(response.resCode=="E234"){
            alert(response.resMsg);
            return false;
        }
        else{
            return false;
        }
        clearInterval(task);
    }
}