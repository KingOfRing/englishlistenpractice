var pid = $.getUrlParam("pid");
var bookId = $.getUrlParam("bookId");
var unitId = $.getUrlParam("unitId");
var updateId = $.getUrlParam("updateId");
var nodeId = null; 
var nodeText =null;
var response = null;
function submit_Insert(dialog, sxtab) {
    var text = $("#nodeText").val();
    var remark = $("#nodeRemark").val();
    if (text == "") {
        openalert('章节名称不能为空!', 'warn');
        $("#nodeText").focus();
        return;
    }
    else {
        var reg = /^[^\'\"]*$/;
        var r = text.match(reg);
        if (r == null) {
            openalert('不能输入单引号和双引号', 'warn');
            $("#nodeText").focus();
            return;
        }
    }
    $.ajax({
        async: false,
        dataType: 'json',
        type: 'POST',
        url: "/api/listen/Section.php?action=insertSection",
        data: {unitId:unitId,text:text, remark:remark,pid:pid },
        success: function (data) {
             response = data;
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            alert("请求失败");
        }
    });
    if(response != null){
        if(response.resCode=="S456"){
            nodeId = response.id;
            nodeText = text;
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
}
function submit_Update(dialog, sxtab) {
    var text = $("#nodeText").val();
    var remark = $("#nodeRemark").val();
    if (text == "") {
        openalert('章节名称不能为空!', 'warn');
        $("#nodeText").focus();
        return;
    }
    else {
        var reg = /^[^\'\"]*$/;
        var r = text.match(reg);
        if (r == null) {
            openalert('不能输入单引号和双引号', 'warn');
            $("#nodeText").focus();
            return;
        }
    }
    $.ajax({
        async: false,
        dataType: 'json',
        type: 'POST',
        url: "/api/listen/Section.php?action=updateSection",
        data: { id:updateId,text:text,remark:remark},
        success: function (data) {
             response = data;
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            alert("请求失败");
        }
    });
    if(response != null){
        if(response.resCode=="S456"){
            nodeText = text;
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
}
function getNodeId() {
    return nodeId;
}
function getNodeText() {
    return nodeText;
}
