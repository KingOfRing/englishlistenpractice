//中间弹出
function openalert(text, type) {
    $.ligerDialog.alert(text, '提示', type);
}

function openalert2(text, type) {
    switch (type) {
        case "success":
            $.ligerDialog.success(text);
            break;
        case "warn":
            $.ligerDialog.warn(text);
            break;
        case "question":
            $.ligerDialog.question(text);
            break;
        case "error":
            $.ligerDialog.error(text);
            break;
    }
}
//判断弹出
function openconfirm(text) {
    $.ligerDialog.confirm(text, function (yes) {
        if (yes) {
            return true;
        }
        else {
            return false;
        }
    });
}
//判断上传文件格式是否满足条件
function isCorrectFormat(type,fileName){
    if(fileName!=null && fileName !=""){
    //lastIndexOf如果没有搜索到则返回为-1
        if (fileName.lastIndexOf(".")!=-1) {
            var fileType = (fileName.substring(fileName.lastIndexOf(".")+1,fileName.length)).toLowerCase();
            var suppotFile = new Array();
            if(type=="voice"){
                suppotFile[0] = "mp3";
                suppotFile[1] = "wma";
                suppotFile[2] = "wav";
            }
            else if(type=="image")
            {
                suppotFile[0] = "jpg";
                suppotFile[1] = "gif";
                suppotFile[2] = "bmp"
                suppotFile[3] = "png";
                suppotFile[4] = "jpeg";
            }
            for (var i =0;i<suppotFile.length;i++) {
                if (suppotFile[i]==fileType) {
                    return true;
                } 
                else{
                    continue;
                }
            }
            return false;
        } 
        else{
            return false;
        }
    }
}
//解析get请求的参数
(function ($) {
    $.getUrlParam = function (name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if (r != null) return unescape(r[2]); return null;
    }
})(jQuery);
//字符串转换
function obj2str(o) {
    var r = [];
    if (typeof o == "string" || o == null) {
        return o;
    }
    if (typeof o == "object") {
        if (!o.sort) {
            r[0] = "{"
            for (var i in o) {

                r[r.length] = i;
                r[r.length] = ":";
                r[r.length] = obj2str(o[i]);
                r[r.length] = ",";
            }

            r[r.length - 1] = "}"
        } else {
            r[0] = "["
            for (var i = 0; i < o.length; i++) {

                r[r.length] = obj2str(o[i]);

                r[r.length] = ",";
            }
            r[r.length - 1] = "]"
        }
        return r.join("");
    }
    return o.toString();
}

function isSession() {
    var status = -1;
    $.ajax({
        type:"GET",
        url: "/api/Login.php?action=getSession",
        async: false,
        success: function (data) {
            status = data;
        },
        error:function(XMLHttpRequest, textStatus, errorThrown){
            alert("请求失败");
        }
    })
    if (status == "yes") {
        return true;
    }
    else { 
        return false; 
    }
}

function delSession() {
    $.ajax({
        type:"GET",
        url: "/api/Login.php?action=delSession",
        async: false,
        success: function (data) {
        },
        error:function(XMLHttpRequest, textStatus, errorThrown){
            alert("请求失败");
        }
    })
}
function getUserName() {
    var userName = "";
    $.ajax({
        type:"GET",
        url: "/api/Login.php?action=getUserName",
        async: false,
        success: function (data) {
            userName = data;
        },
        error:function(XMLHttpRequest, textStatus, errorThrown){
            alert("请求失败");
        }
    })
    return userName;
}
