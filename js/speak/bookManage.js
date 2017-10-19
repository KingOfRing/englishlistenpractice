var manager;
var categoryId;
var rowData={};
$(f_initTree);
$(f_initGrid);
function f_initTree(){
    //布局
    $("#layout").ligerLayout({ leftWidth: 200, height: '100%'});
    var height = $(".l-layout-center").height();
    $("#accordion").ligerAccordion({ height: height - 31, speed: null });
    $("#tree").ligerTree({
        url:"/api/speak/Book.php?action=getCategoryMenu",
        idFieldName: 'id',
        slide: false,
        parentIDFieldName: 'pid',
        checkbox: false,
        nodeWidth: 200,
        onSelect:function(node)
        {
            if(typeof(node.data.children) =="undefined"){  //选择是叶子节点
                categoryId = node.data.id;
                getBookByCategoryId();
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
        { display: '课本编号', name: 'id', minWidth: 50, type: 'int' },
        { display: '书  名', name: 'bookName', minWidth: 200, type: 'string' },
        { display: '作  者', name: 'authorName', minWidth: 200, type: 'string' },
        { display: '书  号', name: 'bookIsbn', minWidth: 200,type: 'string',align:"center" },
        { display: '介  绍', name: 'description', minWidth: 200, type: 'string' },
        {display: '封  面', name: 'imageUrl', align: 'left', width: 100, minWidth: 60, 
            validate: { required: true }, 
            render: function (item) {
                return "<div style='width:100%;height:100%;'><img height='100' width='100' src='http://" + item.imageUrl + "' /></div>";
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
        }
    });
    manager.toggleCol('id', false);
}
function getBookByCategoryId() {
    var response;
    $.ajax({
        async: true,
        dataType: "json",
        type: 'GET',
        url: "/api/speak/Book.php?action=getBookList&categoryId="+categoryId,
        success: function (data,status) {
           if(data['resCode'] == 'S456'){
                rowData.Rows = data.bookList;
                manager.loadData(rowData);
           }
           else{
               // $("#maingrid").find("tbody").children().remove();
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
        url: 'BookEdit.html?operation=insert&categoryId='+categoryId,
        height: 450,
        width: 700,
        title: '新增课本',
        buttons: [{
            text: '确定', onclick: function (item, dialog) {
                var flag = document.getElementById('insertPage').contentWindow.submit_Update();
                if (flag) {
                    dialog.close();
                    getBookByCategoryId();
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
            url: 'BookEdit.html?operation=update&bookId='+selected.id,
            height: 450,
            width: 700,
            title: '修改课本信息',
            buttons: [{
                text: '确定', onclick: function (item, dialog) {
                    var flag = document.getElementById('updatePage').contentWindow.submit_Update();
                    if (flag) {
                        dialog.close();
                        getBookByCategoryId();
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
                    url: "/api/speak/Book.php?action=deleteBook",
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