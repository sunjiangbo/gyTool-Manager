<%@ Page Language="C#" AutoEventWireup="true" CodeFile="preBrowerList.aspx.cs" Inherits="preBrowerList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <link id="easyuiTheme" rel="stylesheet" type="text/css" href="themes/gray/easyui.css"/>
	<link rel="stylesheet" type="text/css" href="themes/icon.css">
	<link rel="stylesheet" type="text/css" href="demo/demo.css">
	<script type="text/javascript" src="jquery.min.js"></script>
	<script type="text/javascript" src="jquery.easyui.min.js"></script>
    <script type="text/javascript" src="js/Myjs.js"></script>
    <script>
        //function ()
        var TaskID = '<%= TaskID %>';
        function LoadTaskPersonList() {
            cmd = { "cmd": "GetBorrowPeronListByTaskID", "TaskID": TaskID };
            MyAjax(cmd, BindGrid, null);
        }

        function ModifyBorrowPersonDel(json) {
            if (json.status == "success") {
                LoadTaskPersonList();
            } else {
                $.messager.alert('提示', json.msg);
            }
        }

        function ModifyBorrowPerson(type, userid) {
            o = {};
            o.cmd = "ModifyBorrowPerson";
            o.type = type;
            o.taskid = TaskID;
            o.userid = userid;
            MyAjax(o, ModifyBorrowPersonDel, null);
        }

        function BindPersonList(data)
        {
            $("#PersonList").combobox({ editable: false, data: data, valueField: "id", textField: "name" });
        }
        function formatOper(val, row, index) {
            return '<a href= "#" onclick="ModifyBorrowPerson(\'Del\',' + row.id +')">删除</a>'          
        }
        function BindGrid(data) {
            $("#tb").datagrid({ data: data}); 
        }
        

       

        $(function () {
            $("#tb").datagrid({
                title: '',
                columns: [
                            [{ field: 'id', title: '编号', width: 100, sortable: true },
                            { field: 'name', title: '姓名', width: 200, sortable: true },
                            { field: "_operate", title: '删除', width: 100, sortable: true, formatter: formatOper },
                        ]]
            });

            cmd = { "cmd": "GetPeronList", "TaskID": TaskID };
            MyAjax(cmd, BindPersonList, null);

            LoadTaskPersonList();

            $("#Add").bind("click", function () {
                var userid = $("#PersonList").combobox("getValue");
                if (userid == null || userid == "") {
                    $.messager.alert('提示', '未选取人员!');
                    return;
                }
                ModifyBorrowPerson("Add", userid);
            });
        }); 
    </script>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="margin:10px;">
        
        <span style="" >所有人员:</span>
        <select id ="PersonList" class="easyui-combobox" style = "width:150px; float:left; " ></select>
        <a  id = "Add" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" style="" onclick= "javascript:UserLogin();">
				<span style="" >添加</span>
			</a>
    </div>
    <div >
        <table id="tb" style=" width:402px"></table>
    </div>
    </form>
</body>
</html>
