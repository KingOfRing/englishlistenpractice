var operation = $.getUrlParam("operation");
var bookId =  $.getUrlParam("bookId");
var unitId = $.getUrlParam("unitId");
var requestUrl = "";
$(document).ready(function () {
    if(operation == "insert"){
        requestUrl = "/api/listen/Unit.php?action="+operation+"Unit&bookId="+bookId;
    }
    if (operation == "update") {
        requestUrl = "/api/listen/Unit.php?action="+operation+"Unit&bookId="+bookId+"&unitId="+unitId;
        $.ajax({
            async:true,
            dataType:"json",
            type:"GET",
            url:"/api/listen/Unit.php?action=getUnitList&unitId="+unitId,
            success: function (data,status) {
                $("#unitNum").val(data['unitList'][0]['unitNum']);
                $("#unitName").val(data['unitList'][0]['unitName']);
                $("#unitDetail").val((data['unitList'][0]['unitDetail']).replace(/<br\s*\/?>/g, "\n"));
            },
            error:function(XMLHttpRequest, textStatus, errorThrown){
                alert("请求失败");
            }
        });
    }
});
function submit_Update(dialog, sxtab) {
    var unitNum = $("#unitNum").val();
    var unitName = $("#unitName").val();
    var unitDetail = $("#unitDetail").val();
    if (unitNum == "") {
        openalert('编号不能为空!', 'warn');
        $("#unitNum").focus();
        return;
    }
    if (unitName == "") {
        openalert('名称不能为空！', 'warn');
        $("#unitName").focus();
        return;
    } 
    if (unitDetail == "") {
        openalert('介绍不能为空!', 'warn');
        $("#unitDetail").focus();
        return;
    }
    var response = null;
    var formData = new FormData($("#unitForm")[0]); 
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
