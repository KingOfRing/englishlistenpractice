var manager;
$(f_initGrid);
function getStudentList() {
    var response;
    $.ajax({
        async: true,
        dataType: "json",
        type: 'GET',
        url: "api/User.php?action=getUserList",
        success: function (data,status) {
           if(data['resCode'] == 'S456'){
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
        columns: [
            { display: '编  号', name: 'id', minWidth: 50, type: 'text' },
            { display: '账  号', name: 'account', minWidth: 200, type: 'text' },
            { display: '性  别', name: 'gender', minWidth: 200,type: 'text'},
            { display: '邮  箱', name: 'email', minWidth: 200,type: 'text'},
            { display: '时  间', name: 'updateTime', minWidth: 200,type: 'text'}
        ], rowHeight: 40,
        pageSize: 20, width: '100%', height: "99%",enabledEdit: true, clickToEdit: false, isScroll: true, checkbox: false, rownumbers: true, enabledSort: false,
        toolbar: {
            items: [
                    { text: '增加', click: itemclick, img: "img/add.gif" },
                    { line: true },
                    { text: '删除', click: itemclick, img: "img/delete.png" },
                    { line: true },
            ]
        }
    });
    manager.toggleCol('id', false);
    getStudentList();
}
function itemclick(item) {
    switch (item.text) {
        case "增加": getInsert();
            break;
        case "删除": getDelete();
            break;
    }
}
function getInsert() {
    $.ligerDialog.open({
        name: 'insertPage',
        url: 'UserEdit.html?opertion=insert',
        height: 380,
        width: 500,
        title: '添加用户',
        buttons: [{
            text: '确定', onclick: function (item, dialog) {
                var flag = document.getElementById('insertPage').contentWindow.submit_Update();
                if (flag) {
                    dialog.close();
                    getStudentList();
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
                    url: "api/User.php?action=deleteUser",
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