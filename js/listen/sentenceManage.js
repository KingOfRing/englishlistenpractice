var manager;
var bookId;
var unitId;
var sectionId;
var rowData={};
$(f_initGrid);
$(f_initTree);
function f_initTree(){
    //布局
    $("#layout").ligerLayout({ leftWidth: 200, height: '100%'});
    var height = $(".l-layout-center").height();
    $("#accordion").ligerAccordion({ height: height - 31, speed: null });

    $("#layout1").ligerLayout({ leftWidth: 200, height: '100%'});
    var height = $(".l-layout-center").height();
    $("#accordion1").ligerAccordion({ height: height - 31, speed: null });
    $("#tree").ligerTree({
        url:"/api/listen/Sentence.php?action=getUnitMenu",
        idFieldName: 'id',
        slide: false,
        parentIDFieldName: 'pid',
        checkbox: false,
        nodeWidth: 600,
        onSelect:function(node)
        {
           if(typeof(node.data.children) =="undefined"){  //选择是叶子节点
                unitId = node.data.id;
                bookId = node.data.pid;
                loadSection();
            }
            else{                               //选择的不是叶子节点
                 alert("请重新选择节点");
            }
        },
    });
}
function loadSection(){
    $("#tree1").ligerTree({
        url: '/api/listen/Section.php?action=getSectionList&unitId='+unitId,
        checkbox: false,
        slide: false,
        nodeWidth: 620,
        attribute: ['text', 'id'],
        onSelect: function (node) {
            if(typeof(node.data.children) =="undefined"){  //选择是叶子节点
                sectionId = node.data.id;
                getSentenceList();
            }
            else{                               //选择的不是叶子节点
                 alert("请重新选择节点");
            }
        }
    });
}
function f_initGrid() {
        manager = $("#maingrid").ligerGrid({
        columns: [
        { display: '语句编号', name: 'sentenceId', minWidth: 50, type: 'int' },
        { display: '单元编号', name: 'unitId', minWidth: 200, type: 'int' },
        { display: '章节编号', name: 'sectionId', minWidth: 200, type: 'int' },
        { display: '英文原文', name: 'english', minWidth: 200, type: 'string' },
        { display: '中文翻译', name: 'chinese', minWidth: 200, type: 'string' },
        { display: '语音文件', name: 'voiceUrl', minWidth: 300,type: 'string',align:"center", 
            validate: { required: true }, 
            render: function (item) {
                return "<div><audio preload='none' controls='controls'><source src='http://"+item.voiceUrl+"' type='audio/mpeg'></audio></div>";
            } 
        },
        { display: '时  间', name: 'updateTime', minWidth: 200, type: 'text' }
        ], 
        rowDraggable:true,
        rowHeight: 40,
        pageSize: 20, width: '100%', height: "99%",enabledEdit: true, clickToEdit: false, isScroll: true, checkbox: false, rownumbers: true, enabledSort: false,
       onRowDragDrop: function (parm)
        {   
                updateOrderId();
    },
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
    manager.toggleCol('sentenceId', false);
    manager.toggleCol('unitId', false);
    manager.toggleCol('sectionId', false);
}
function getSentenceList() {
    var response;
    $.ajax({
        async: false,
        dataType: "json",
        type: 'GET',
        url: "/api/listen/Sentence.php?action=getSentenceList&unitId="
                                       +unitId+"&sectionId="+sectionId,
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
function updateOrderId(){
   //var data=JSON.stringify(manager.getData());
    //alert(data);
   var data=manager.getData();
   var json=new Array();
    for(var i in data)
    {   var sentenceId=data[i].sentenceId;
        json[i]={sentenceId:sentenceId,orderId:(Number(i)+1)};
    }
     //alert(JSON.stringify(json));
            $.ajax({
                    async: false,
                    dataType: 'json',
                    type: 'POST',
                    url: "/api/listen/Sentence.php?action=updateOrderId",
                    data: JSON.stringify(json),
                      success: function (data) {
                        if(data.resCode=="E234"){
                            alert("排序失败");
                    }

                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert("请求失败");

    }

})
}

function getOrderId(){
    var orderId;
    var data=manager.getData();
    orderId=(data=="{}")?1:data.length+1;
   return orderId;
}
function getInsert() { 
   var orderId= getOrderId();
    $.ligerDialog.open({
        name: 'insertPage',
        url: 'SentenceEdit.html?operation=insert&bookId='+bookId
                                             +'&unitId='+unitId
                                             +'&sectionId='+sectionId+'&orderId='+orderId,
        height: 400,
        width: 700,
        title: '新增语句',
        buttons: [{
            text: '确定', onclick: function (item, dialog) {
                var flag = document.getElementById('insertPage').contentWindow.submit_Update();
                if (flag) {
                    dialog.close();
                    getSentenceList();
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
                                                  +'&unitId='+unitId
                                                  +'&sentenceId='+selected.sentenceId,
            height: 400,
            width: 700,
            title: '修改语句信息',
            buttons: [{
                text: '确定', onclick: function (item, dialog) {
                    var flag = document.getElementById('updatePage').contentWindow.submit_Update();
                    if (flag) {
                        dialog.close();
                        getSentenceList();
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
            selectedRows += checkedRows[i].sentenceId + ",";
        selectedRows = selectedRows.substring(0, selectedRows.length - 1);
        $.ligerDialog.confirm('确定删除?', function (flag) {
            if (flag) {
                var response;
                $.ajax({
                    async: false,
                    dataType: 'json',
                    type: 'POST',
                    url: "/api/listen/Sentence.php?action=deleteSentence"+"&sectionId="+sectionId+"&unitId="+unitId,
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
                    // var deleteManager = $("#maingrid").ligerGetGridManager();
                    // deleteManager.deleteSelectedRow();
                    manager.deleteSelectedRow();
                    //getSentenceList();
                    //updateOrderId();
                }
                else {
                    openalert("删除失败");
                }
            }
        });
    }
}
