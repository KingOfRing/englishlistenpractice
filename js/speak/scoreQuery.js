var manager;
$(f_initGrid);
var rowData = null;

function getAllScore() {
   
    $.ajax({
        async: true,
        dataType: "json",
        type: 'GET',
        url: "api/Score.php?action=queryAllScore",
        success: function (data,status) {
           if(data['resCode'] == 'succeed'){
                rowData  = data;
                manager.loadData(data);
           }
           else{
                alert('resMsg');
           }
        },
        error:function(XMLHttpRequest, textStatus, errorThrown){
            alert("请求失败");
        }
    });
}
function f_initGrid() {
        manager = $("#maingrid").ligerGrid({
        title:'学生口语练习成绩信息表',
        showTitle:true,
        columns: [
            { display: '编  号', name: 'id', minWidth: 50, type: 'text' },
            { display: '学  号', name: 'account', minWidth: 200, type: 'text' },
            { display: '课  本', name: 'bookName', minWidth: 200, type: 'text' },
            { display: '文  章', name: 'articleTitle', minWidth: 200,type: 'text' },
            { display: '成  绩', name: 'score', minWidth: 200,type: 'text' }
        ], 
        rowHeight: 40,
        pageSize: 20, width: '100%', height: "99%",enabledEdit: true, clickToEdit: false, isScroll: true, checkbox: false, rownumbers: true, enabledSort: false,
        toolbar: {
                items: [
                    { text: '按学号查询', click: itemclick, icon: 'search' },
                    { line: true },
                    { text: '按课本查询', click: itemclick, icon: 'search' },
                    { line: true },
                    { text: '按文章查询', click: itemclick, icon: 'search' }
                ]
        },
        autoFilter: true
       
    });
    manager.toggleCol('id', false);
    getAllScore();
}
 function itemclick(item)
{
    switch(item.text){
        case "按学号查询":{
           $.ligerDialog.prompt('请输入要查询的学号',true, function (yes,value) 
            { 
                if(yes) 
                f_search("account",value); 
            });
        };
        break;
        case "按课本查询":{
            $.ligerDialog.prompt('请输入要查询的课本',true, function (yes,value) 
            { 
                if(yes) 
                f_search("bookName",value); 
            });
        };
        break;
        case "按文章查询":{
            $.ligerDialog.prompt('请输入要查询的文章',true, function (yes,value) 
            { 
                if(yes) 
                f_search("articleTitle",value); 
            });
        };
        break;
    }
}
function f_search(type,key)
{
    manager.options.data = $.extend(true, {}, rowData);
    manager.loadData(f_getWhere(type,key));
}
function f_getWhere(type,key)
{
    if (!manager) return null;
    var clause = function (rowdata, rowindex)
    {
        if(type=="account"){
            return rowdata.account.indexOf(key) > -1;
        }
        else if(type=="bookName"){
            return rowdata.bookName.indexOf(key) > -1;
        }
        else if(type=="articleTitle"){
            return rowdata.articleTitle.indexOf(key) > -1;
        }
    };
    return clause; 
}