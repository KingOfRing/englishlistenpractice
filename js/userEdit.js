var urlParts = decodeURI(document.URL).split("?"); //把1.aspx?id=123&op=321  看做字符串,将以?拆开此字符串 
var paramParts = urlParts[1].split("&");
var operation = paramParts[0].split("=")[1];
var requestUrl = "";
$(document).ready(function () {
    if(operation =="insert"){
        requestUrl = "api/User.php?action=register";
        $("#password").val("12345678");
        $("#password").attr("readonly","readonly");
        $("#password").attr("disabled",true)//将input元素设置为disabled
    }
});
function submit_Update(dialog, sxtab) {
    var account = $("#account").val();
    var gender = $("#gender").val(); 
    var email = $("#email").val();
    var password = $("#password").val();
    if (account == "") {
        openalert('学号不能为空!', 'warn');
        $("#account").focus();
        return;
    }
    if (gender == "") {
        openalert('请选择性别!', 'warn');
        $("#gender").focus();
        return;
    }
    if (email == "") {
        openalert('请填写邮箱!', 'warn');
        $("#email").focus();
        return;
    }
    if (password == "") {
        openalert('请填写登录密码!', 'warn');
        $("#password").focus();
        return;
    }
    var response = null;
    $.ajax({
        async: false,
        dataType: 'json',
        type: 'POST',
        url:requestUrl,
        data: $("#studentForm").serialize(),
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
