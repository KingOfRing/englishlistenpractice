var tree;
//var bookId;
var unitId;
$(f_initTree);
//$(selecttree);
function f_initTree(){
    //工具条
    $("#toptoolbar").ligerToolBar({
        items: [
                { text: '新增章节', click: itemclick, img: "../../img/add.gif" },
                { line: true },
                { text: '编辑章节', click: itemclick, img: "../../img/edit.gif" },
                { line: true },
                { text: '删除章节', click: itemclick, img: "../../img/delete.png" },
        ]
    });
    // //布局
    // $("#layout").ligerLayout({ leftWidth: 200, height: '100%'});
    // var height = $(".l-layout-center").height();
    // $("#accordion").ligerAccordion({ height: height - 31, speed: null });

    // $("#tree").ligerTree({
    //     url:"/api/listen/Unit.php?action=getBookMenu",
    //     idFieldName: 'id',
    //     slide: false,
    //     parentIDFieldName: 'pid',
    //     checkbox: false,
    //     nodeWidth: 200,
    //     onSelect:function(node)
    //     {
    //         if(typeof(node.data.children) =="undefined"){  //选择是叶子节点
    //             bookId = node.data.id;
    //             selecttree();
    //         }
    //         else{                               //选择的不是叶子节点
    //              alert("请重新选择节点");
    //         }
    //     },
    // });
     //布局
    $("#layout").ligerLayout({ leftWidth: 200, height: '100%'});
    var height = $(".l-layout-center").height();
    $("#accordion").ligerAccordion({ height: height - 31, speed: null });
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
                //bookId = node.data.pid;
                 selecttree();

            }
            else{                               //选择的不是叶子节点
                 alert("请重新选择节点");
            }
        },
    });
    //右击菜单
    menu = $.ligerMenu({
        top: 100, left: 100, width: 120, items:
              [
              { text: '新增章节', click: itemclick, icon: "../../img/add.gif" },

              { text: '编辑章节', click: itemclick, icon: "../../img/edit.gif" },

              { text: '删除章节', click: itemclick, icon: "../../img/delete.png" }
              ]
    });
}
function itemclick(item){
    switch(item.text){
        case "新增章节": addNode();
                break;
        case "编辑章节": updateNode();
                break;
        case "删除章节": deleteNode();
    }
}
function selecttree() {
    tree = $("#tree1").ligerTree({
        url: '/api/listen/Section.php?action=getSectionList&unitId='+unitId,
        checkbox: false,
        slide: false,
        nodeWidth: 620,
        attribute: ['text', 'id'],
        onSelect: function (node) {
            var tabid = $(node.target).attr("tabid");
            if (!tabid) {
                tabid = new Date().getTime();
                $(node.target).attr("tabid", tabid)
            }
        },
        onContextmenu: function (node, e) {//右击菜单
            menu.show({ top: e.pageY, left: e.pageX });
            return false;
        }

    });
}

//返回新增节点
function addnode(Name, NameID) {
    var node = tree.getSelected();
    var nodes = [];
    nodes.push({ text: Name, id: NameID });
    if (node)
        tree.append(node.target, nodes);
}
//新增校区（弹出窗口）
function addNode() {
    var pid = 0 ,nodes = [];
    var node = tree.getSelected();
    if(node){
        pid = node.data.id;
    }
    parent.$.ligerDialog.open({
        name: 'insertPage',
        url: '/html/listen/SectionEdit.html?unitId=' + unitId+'&pid=' + pid,
        height: 200,
        width: 400,
        title: '新增节点',
        buttons: [{
            text: '确定', onclick: function (item, dialog) {
                var flag = parent.document.getElementById('insertPage').contentWindow.submit_Insert();
                if (flag) {
                    var nodeText = parent.document.getElementById('insertPage').contentWindow.getNodeText();
                    var nodeId = parent.document.getElementById('insertPage').contentWindow.getNodeId();
                    dialog.close();
                    nodes.push({ text: nodeText, id: nodeId });
                    if(node)
                        tree.append(node.target, nodes);
                    else
                        tree.append(null,nodes);
                    openalert2('新增成功', 'success');
                }

            }
        },
           { text: '取消', onclick: function (item, dialog) { dialog.close(); } }
        ], isResize: true, isHidden: false
        });
}
//编辑窗口
function updateNode() {
    var node = tree.getSelected();
    if (node) {
        var nodeId = node.data.id;
        parent.$.ligerDialog.open({
            name: 'updatePage',
            url: '/html/listen/SectionEdit.html?updateId='+nodeId,
            height: 200,
            width: 400,
            title: '编辑节点',
            buttons: [{
                text: '确定', onclick: function (item, dialog) {
                    var flag = parent.document.getElementById('updatePage').contentWindow.submit_Update();
                    if (flag) {
                        var nodeText = parent.document.getElementById('updatePage').contentWindow.getNodeText();
                        dialog.close();
                        if (node)
                            tree.update(node.target, { text: nodeText });
                        openalert2('编辑成功', 'success');
                    }
                }
            },
               { text: '取消', onclick: function (item, dialog) { dialog.close(); } }
            ], isResize: true, isHidden: false
        });
    }

    else {
        openalert2('请选择校区', 'warn');
    }
}
function deleteNode() {
    var node = tree.getSelected();
    if (node) {
        parent.$.ligerDialog.confirm('确定删除?', function (yes) {
            if (yes) {
                var response = null;
                $.ajax({
                    async: false,
                    dataType: 'json',
                    type: 'POST',
                    url: "/api/listen/Section.php?action=deleteSection",
                    loading: '正在进行删除...',
                    data: {id:node.data.id},
                    success: function (data) {
                        response = data;
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert("请求失败");
                    }
                });
                if (response != null &&response.resCode == "S456") {
                    tree.remove(node.target);
                    openalert2('删除成功', 'success');

                }
                else {
                    openalert2("删除失败",'warn');
                }
            }
        });
    }
    else {
        openalert2("请选择章节", 'warn');
    }
}

