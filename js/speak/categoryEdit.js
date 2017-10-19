var operation = $.getUrlParam("operation");
var categoryId =  $.getUrlParam("categoryId");
var requestUrl ="";
$(document).ready(function () {
    requestUrl = "/api/speak/Category.php?action="+operation+"Category";
    if (operation == "update") {
        requestUrl += "&categoryId="+categoryId;
        $.ajax({
            async:true,
            dataType:"json",
            type:"GET",
            url:"/api/speak/Category.php?action=getCategoryList&categoryId="+categoryId,
            success: function (data,status) {
                $("#categoryName").val(data['categoryList'][0]['categoryName']);
                $("#description").val(data['categoryList'][0]['description']);
            },
            error:function(XMLHttpRequest, textStatus, errorThrown){
                alert("请求失败");
            }
        });
    }
});
function submit_Update(dialog, sxtab) {
    var categoryName = $("#categoryName").val();
    var description = $("#description").val();
    if (categoryName == "") {
        openalert('书名不能为空!', 'warn');
        $("#categoryName").focus();
        return;
    }
    else {
        var reg = /^[^\'\"]*$/;
        var r = categoryName.match(reg);
        if (r == null) {
            openalert('不能输入单引号和双引号', 'warn');
            $("#categoryName").focus();
            return;
        }
    }
    if (description == "") {
        openalert('作者不能为空！', 'warn');
        $("#description").focus();
        return;
    } else {
        var reg = /^[^\'\"]*$/;
        var r = description.match(reg);
        if (r == null) {
            openalert('不能输入单引号和双引号', 'warn');
            $("#description").focus();
            return;
        }
    }
    var response = null;
    $.ajax({
        async: false,
        dataType: 'json',
        type: 'POST',
        url:requestUrl,
        data: $("#categoryForm").serialize(),
        success: function (result) {
            response = result;
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            alert("请求失败");
        }
    });
    if (response!=null && response.resCode=="S456") {
        return true;
    }
    else {
        return false;
    }
}
