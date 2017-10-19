var manager;
var rowData={};
$(f_initGrid);
function getCategoryList() {
    var response;
    $.ajax({
        async: true,
        dataType: "json",
        type: 'GET',
        url: "/api/listen/Category.php?action=getCategoryList",
        success: function (data,status) {
           if(data['resCode'] == 'S456'){
                rowData.Rows = data.categoryList;
                manager.loadData(rowData);
           }
           else{
                //alert(data.resMsg);
           }
        },
        error:function(XMLHttpRequest, textStatus, errorThrown){
            alert("请求失败");
        }
    });
}
function f_initGrid() {
        manager = $("#maingrid").ligerGrid({
        columns: [
        { display: '分类编号', name: 'categoryId', minWidth: 50, type: 'text' },
        { display: '分 类 名', name: 'categoryName', minWidth: 200, type: 'text' },
        { display: '描  述', name: 'description', minWidth: 200, type: 'text' },
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
        }
    });
    manager.toggleCol('id', false);
    getCategoryList();
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
        url: 'CategoryEdit.html?operation=insert',
        height: 200,
        width: 500,
        title: '新增课本',
        buttons: [{
            text: '确定', onclick: function (item, dialog) {
                var flag = document.getElementById('insertPage').contentWindow.submit_Update();
                if (flag) {
                    dialog.close();
                    getCategoryList();
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
            url: 'CategoryEdit.html?operation=update&categoryId='+selected.categoryId,
            height: 200,
            width: 500,
            title: '修改课本信息',
            buttons: [{
                text: '确定', onclick: function (item, dialog) {
                    var flag = document.getElementById('updatePage').contentWindow.submit_Update();
                    if (flag) {
                        dialog.close();
                        getCategoryList();
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
            selectedRows += checkedRows[i].categoryId + ",";
        selectedRows = selectedRows.substring(0, selectedRows.length - 1);
        $.ligerDialog.confirm('确定删除?', function (flag) {
            if (flag) {
                var response;
                $.ajax({
                    async: false,
                    dataType: 'json',
                    type: 'POST',
                    url: "/api/listen/Category.php?action=deleteCategory",
                    loading: '正在进行删除...',
                    data: {categoryId:selectedRows},
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