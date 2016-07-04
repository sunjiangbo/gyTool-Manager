<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="ModelManage.aspx.cs" Inherits="Default3" %>


<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
 <link id="easyuiTheme" rel="stylesheet" type="text/css" href="themes/gray/easyui.css"/>
	<link rel="stylesheet" type="text/css" href="themes/icon.css"/>
	<link rel="stylesheet" type="text/css" href="demo/demo.css"/>
	<script type="text/javascript" src="jquery.min.js"></script>
	<script type="text/javascript" src="jquery.easyui.min.js"></script>
    <link href="Css/MyCSS.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="JS/MyJS.js"></script>
    <script>

        var treeDat;
        function TreeItemClick(node) {

            var NodeType = node.attributes.nodetype;
            var title = node.text;
            var p = $("body").layout("panel", "center");

            $(p).panel("setTitle", node.text);

            var pNode = $("#tt").tree('getParent', node.target);

            if (pNode.text != "模型列表") {
                title = pNode.text + " ==> " + node.text;                
            }

            var p = $("#classtab").tabs("getTab", title);

            if ($(p).length > 0) {
                $("#classtab").tabs("select", title);
                return;
            }

            $('#classtab').tabs('add', {
                title: title,
               // href:'ClassManage.aspx?ClassID=' + node.id,
                iconCls: 'icon-save',
                closable: true,
                tools: [{
                        handler: function () {
                           
                    }
                }]
            });
                var src ;

                if (NodeType == 3) {
                    src = 'ClassManage.aspx?ClassID=' + node.id;
                } else if (NodeType == 1) {
                    src = 'ToolBag.aspx?Type=0&BagID=' + node.id;
                } else if (NodeType == 2) {

                    if (node.attributes.vtype == "1") {
                        src = "ToolContentManage.aspx?Type=3&ToolID=" + node.attributes.id + "&ClassID=" + node.attributes.propertyid + "&ToolName=" + node.text;
                    } else if (node.attributes.vtype == "3") {
                        src = "ToolContentManage.aspx?Type=4&ToolID=" + node.attributes.id + "&BagID=" + node.attributes.bagid + "&BagName=" + node.attributes.bagname + "&ClassID=" + node.attributes.propertyid + "&ToolName=" + node.text;
                    }
                }

                var pp = $('#classtab').tabs('getSelected');
                $(pp).append('<iframe  frameborder="no" border="0" style="width:100%;height:100%;"src="'+src+'"></iframe>');
        }
        function LoadTree() 
        {
            $.messager.progress({
                title: '请稍后',
                msg: '数据加载中……'
            });
            $.ajax({
                url: 'AJAX/Handler.ashx',
                type: "POST",
                data: JSON.stringify({ "cmd": "getModelTree" }),
                dataType: 'json',
                success: function (data) {
                    if (data.status == "success") {
                        treeDat = data.data;
                        $("#tt").tree({ data: data.data, onClick: TreeItemClick, lines: true });
                        $.messager.progress('close');
                    } else {
                        $.messager.progress('close');
                        $.messager.alert('提示', '加载模型树失败!');
                        
                    }
                },
                error: function (xhr, s, e) {
                    $.messager.progress('close');
                    $.messager.alert('数据加载错误', e);
                }
            });

            var p = $("#cc").layout("panel", "west");
            $(p).panel({ tools: [{
                iconCls: 'icon-add',
                handler: function () {
                    // 
                    $("#tWin").window({ title: "新窗口", modal: true, closed: false, onClose: function () { LoadTree(); } });

                }
            }]
            });
        }

        $(function () {
            LoadTree();
        });

    function tAdd() /*添加工具模型 或者 工具包模型*/
    {
        var type = $('#tCom').combobox('getValue');
        var Name = $("#tClassName").val();

        if (type==1 && Name == '') { alert('名称不可为空');return;}

        if (type == 2) {
            $("#fr1").attr("src", "ToolContentManage.aspx?Type=1&BagName=" + Name);
            $("#Win1").window({ title: "工具箱本体模型选择", modal: true, closed: false, onClose: function() { LoadTree(); } });
            $("#tWin").window({ closed: true });
            return;
        }

        $.messager.confirm('Confirm', '确定要添加名称为：' + Name + (type == 1 ? '-->工具模型' : '-->工具包模型'), function (r) {
            if (r) {
                if (type == 1) {
                    $.messager.progress({ title: '提示', msg: '正在处理，请稍候!' });
                    $.ajax(
                    {
                        url: 'AJAX/Handler.ashx',
                        type: "POST",
                        data: JSON.stringify({ "cmd": "AddClass", "name": Name }),
                        dataType: 'json',
                        success: function (data) {
                            $("#tWin").window({ closed: true });
                            if (data.status == "success") {
                                $.messager.alert('提示', '成功！');
                                $.messager.progress('close');
                                LoadTree();
                            } else {
                                $.messager.progress('close');
                                $.messager.show({
                                    title: '提示',
                                    msg: data.msg,
                                    timeout: 3000,
                                    showType: 'fade'
                                });
                            }


                        },
                        error: function (xhr, s, e) {
                            $.messager.progress('close');
                            $.messager.alert('数据加载错误', e);
                        }
                    });
                } 
            }

        });
    }
    </script>
    <style>
       .panelItem
        {
             margin-top:5px;
         }
    </style>
</head>

 <body id = "cc" class="easyui-layout">
 <form id="form1" runat="server">
 
          
                <div id= "left" title = "模型列表" region="west"  style="width:200px;">
                 <ul id="tt"/>

            </div>
            <div id= "right" title = "模型管理" region="center">
                <div id="classtab" class="easyui-tabs" data-options = "fit:true">

                </div>
                
            </div>
            <div id="tWin" class="easyui-window"  style = "padding:10px;" data-options="maximizable:false,minimizable:false,collapsible:false,closed:true,modal:true,title:'Test Window'" style="width:300px;height:100px;" >
                <select id = "tCom"class="easyui-combobox" name="state" style = "width:170px;" >
                <option value="1">工具模型(包括工具箱)</option>
                <option value="2">工具包模型</option>
                </select>
                <input id = "tClassName" type="text"/>
                <a id  = "tAddBtn" type ="button" onclick = "tAdd();" class="easyui-linkbutton" >添加</a>
            </div>

             <div id="Win1" class="easyui-window"  style = "padding:0px;width:550px;height:450px;" data-options="maximizable:false,minimizable:false,collapsible:false,closed:true,modal:true,title:'Test Window'" >
               <iframe id ="fr1"  width="97%" height="97%" frameborder="0"></iframe>
            </div>

 </form>
</body>
   

</html>

