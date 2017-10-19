var manager;
var bookId;
var rowData={};
$(f_initTree);
$(f_initGrid);
function f_initTree(){
    //布局
    $("#layout").ligerLayout({ leftWidth: 200, height: '100%'});
    var height = $(".l-layout-center").height();
    $("#accordion").ligerAccordion({ height: height - 31, speed: null });
    $("#tree").ligerTree({
        url:"/api/listen/Unit.php?action=getBookMenu",
        idFieldName: 'id',
        slide: false,
        parentIDFieldName: 'pid',
        checkbox: false,
        nodeWidth: 200,
        onSelect:function(node)
        {
            if(typeof(node.data.children) =="undefined"){  //选择是叶子节点
                bookId = node.data.id;
                getUnitByBookId();
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
        { display: '单元编号', name: 'unitId', minWidth: 50, type: 'text' },
        { display: '课本编号', name: 'bookId', minWidth: 200, type: 'text' },
        { display: '单元序号', name: 'unitNum', minWidth: 200, type: 'text' },
        { display: '单元名称', name: 'unitName', minWidth: 200, type: 'text' },
        { display: '单元介绍', name: 'unitDetail', minWidth: 200, type: 'text' },
        { display: '时  间', name: 'updateTime', minWidth: 200, type: 'text' }
        ], rowHeight: 40,
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
    manager.toggleCol('bookId', false);
    manager.toggleCol('unitId', false);
}
function getUnitByBookId() {
    var response;
    $.ajax({
        async: true,
        dataType: "json",
        type: 'GET',
        url: "/api/listen/Unit.php?action=getUnitList&bookId="+bookId,
        success: function (data,status) {
           if(data['resCode'] == 'S456'){
                rowData.Rows = data.unitList;
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
    $.ligerDialog.open({
        name: 'insertPage',
        url: 'UnitEdit.html?operation=insert&bookId='+bookId,
        height: 300,
        width: 600,
        title: '新增单元',
        buttons: [{
            text: '确定', onclick: function (item, dialog) {
                var flag = document.getElementById('insertPage').contentWindow.submit_Update();
                if (flag) {
                    dialog.close();
                    getUnitByBookId();
                    openalert('新增成功', 'warn');
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
            url: 'UnitEdit.html?operation=update&bookId='+bookId+'&unitId='+selected.unitId,
            height: 300,
            width: 600,
            title: '修改文章信息',
            buttons: [{
                text: '确定', onclick: function (item, dialog) {
                    var flag = document.getElementById('updatePage').contentWindow.submit_Update();
                    if (flag) {
                        dialog.close();
                        getUnitByBookId();
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
            selectedRows += checkedRows[i].unitId + ",";
        selectedRows = selectedRows.substring(0, selectedRows.length - 1);
        $.ligerDialog.confirm('确定删除?', function (flag) {
            if (flag) {
                var response;
                $.ajax({
                    async: false,
                    dataType: 'json',
                    type: 'POST',
                    url: "/api/listen/Unit.php?action=deleteUnit",
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
