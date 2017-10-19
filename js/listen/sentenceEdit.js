var operation = $.getUrlParam("operation");
var bookId = $.getUrlParam('bookId');
var unitId =  $.getUrlParam("unitId");
var sectionId = $.getUrlParam("sectionId");
var sentenceId = $.getUrlParam("sentenceId");
var orderId=$.getUrlParam("orderId");
var requestUrl = "";
var response = null;
var task = null;
$(document).ready(function () {
    if(operation == "insert"){
        requestUrl = "/api/listen/Sentence.php?action="+operation+"Sentence&bookId="+bookId
                                              +"&unitId="+unitId
        									  +"&sectionId="+sectionId+"&orderId="+orderId;
    }
    if (operation == "update") {
        requestUrl = "/api/listen/Sentence.php?action="+operation+"Sentence&bookId="+bookId
        									  +"&unitId="+unitId
        									  +"&sentenceId="+sentenceId;
        $.ajax({
            async:true,
            dataType:"json",
            type:"GET",
            url:"/api/listen/Sentence.php?action=getSentenceList&sentenceId="+sentenceId,
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
    var response = null;
    var formData = new FormData($("#sentenceForm")[0]); //支持文件流，serialize不支持文件流
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
        if(response.resCode=="E234"){
            alert(response.resMsg);
        }
        return false;
    }
}