var manager;
var bookId;
var articleId;
var rowData={};
$(f_initGrid);
$(f_initTree);
function f_initTree(){
    //布局
    $("#layout").ligerLayout({ leftWidth: 200, height: '100%'});
    var height = $(".l-layout-center").height();
    $("#accordion").ligerAccordion({ height: height - 31, speed: null });
    $("#tree").ligerTree({
        url:"/api/speak/Sentence.php?action=getArticleMenu",
        idFieldName: 'id',
        slide: false,
        parentIDFieldName: 'pid',
        checkbox: false,
        nodeWidth: 200,
        onSelect:function(node)
        {
            if(typeof(node.data.children) =="undefined"){  //选择是叶子节点
                bookId = node.data.pid;
                articleId = node.data.id;
                getSentenceByArticleId(articleId);
            }
            else{                               //选择的不是叶子节点
                 alert("请重新选择节点");
            }
        },
    });
}
function f_initGrid() {
        manager = $("#maingrid").ligerGrid({
        columns: [
        { display: '语句编号', name: 'id', minWidth: 50, type: 'text' },
        { display: '文章编号', name: 'articleId', minWidth: 200, type: 'text' },
        { display: '英文原文', name: 'english', minWidth: 200, type: 'text' },
        { display: '中文翻译', name: 'chinese', minWidth: 200, type: 'text' },
        { display: '语音文件', name: 'voiceUrl', minWidth: 300,type: 'text',align:"left", 
            validate: { required: true }, 
            render: function (item) {
                return "<div><audio preload='none' controls='controls'><source src='http://"+item.voiceUrl+"' type='audio/mpeg'></audio></div>";
            } 
        },
        { display: '时  间', name: 'updateTime', minWidth: 200, type: 'text' }
        ], 
        rowHeight: 40,
        pageSize: 20, width: '100%', height: "99%",enabledEdit: true, clickToEdit: false, isScroll: true, checkbox: false, rownumbers: true, enabledSort: false,
        toolbar: {
            items: [
                    { text: '增加', click: itemclick, img: "../../img/add.gif" },
                    { line: true },
                    { text: '修改', click: itemclick, img: "../../img/edit.gif" },
                    { line: true },
                    { text: '删除', click: itemclick, img: "../../img/delete.png" },
                    { line: true },
            ]
        },
        onAfterShowData:function()  
        {                                  
            $(".l-grid-row-cell-inner").css("height","auto"); //单元格高度自动化，撑开  
            var i=0;  
            $("tr",".l-grid2","#maingrid").each(function ()  
            {                                              
                $($("tr",".l-grid1","#maingrid")[i]).css("height",$(this).height()); //2个表格的tr高度一致  
                i++;                          
            });                                              
        },  
    });
    manager.toggleCol('id', false);
    manager.toggleCol('articleId', false);
}
function getSentenceByArticleId(articleId) {
    var response;
    $.ajax({
        async: true,
        dataType: "json",
        type: 'GET',
        url: "/api/speak/Sentence.php?action=getSentenceList&articleId="+articleId,
        success: function (data,status) {
           if(data['resCode'] == 'S456'){
                rowData.Rows = data.sentenceList;
                manager.loadData(rowData);
           }
           else{
               manager.loadData({});
           }
        },
        error:function(XMLHttpRequest, textStatus, errorThrown){
            alert("请求失败");
        }
    });
}

function itemclick(item) {
    switch (item.text) {
        case "修改": getEdit();
            break;
        case "增加": getInsert();
            break;
        case "删除": getDelete();
            break;
    }
}
function getInsert() { 
    var tree = $("#tree").ligerGetTreeManager();
    var bookName = tree.getTextByID(bookId);
    var articleTitle = tree.getTextByID(articleId);
    $.ligerDialog.open({
        name: 'insertPage',
        url: 'SentenceEdit.html?operation=insert&bookId='+bookId
                                             +'&articleId='+articleId,
        height: 400,
        width: 700,
        title: '新增语句',
        buttons: [{
            text: '确定', onclick: function (item, dialog) {
                var flag = document.getElementById('insertPage').contentWindow.submit_Update();
                if (flag) {
                    dialog.close();
                    getSentenceByArticleId(articleId);
                    openalert('新增成功', 'success');
                }
            }
        },
        {
            text: '取消', onclick: function (item, dialog) { dialog.close(); }
        }
        ], isResize: true, isHidden: false
    });
}
function getEdit() {
    var checkedRows = manager.getCheckedRows();
    var selected = manager.getSelected();
    if (!selected) {
        openalert('请选择行!');
    }
    else if (checkedRows.length > 1) {
        openalert('请选择一行!');
    }
    else {
       $.ligerDialog.open({
            name: 'updatePage',
            url: 'SentenceEdit.html?operation=update&bookId='+bookId
                                                  +'&articleId='+articleId
                                                  +'&sentenceId='+selected.id,
            height: 400,
            width: 700,
            title: '修改语句信息',
            buttons: [{
                text: '确定', onclick: function (item, dialog) {
                    var flag = document.getElementById('updatePage').contentWindow.submit_Update();
                    if (flag) {
                        dialog.close();
                        getSentenceByArticleId(articleId);
                        openalert('编辑成功', 'warn');
                    }
                }
            },
               {
                   text: '取消', onclick: function (item, dialog) { dialog.close(); }
               }
            ], isResize: true, isHidden: false
        });
    }
}
function getDelete()  {
    var checkedRows = manager.getCheckedRows();
    var selected = manager.getSelected();
    var selectedRows = " ";
    if (!selected) {
        openalert('请选择行!');
    }
    else {
        for(i = 0;i<checkedRows.length;i++)
            selectedRows += checkedRows[i].id + ",";
        selectedRows = selectedRows.substring(0, selectedRows.length - 1);
        $.ligerDialog.confirm('确定删除?', function (flag) {
            if (flag) {
                var response;
                $.ajax({
                    async: false,
                    dataType: 'json',
                    type: 'POST',
                    url: "/api/speak/Sentence.php?action=deleteSentence",
                    loading: '正在进行删除...',
                    data: {id:selectedRows},
                    success: function (data, textStatus) {
                        response = data;
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                    }
                });
                if (response.resCode=="S456") {
                    openalert('删除成功');
                    var deleteManager = $("#maingrid").ligerGetGridManager();
                    deleteManager.deleteSelectedRow();
                }
                else {
                    openalert("删除失败");
                }
            }
        });
    }
}