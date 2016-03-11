<%@ Page Language="C#" AutoEventWireup="true" CodeFile="preBrowerList.aspx.cs" Inherits="preBrowerList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <link id="easyuiTheme" rel="stylesheet" type="text/css" href="themes/gray/easyui.css"/>
	<link rel="stylesheet" type="text/css" href="themes/icon.css">
	<link rel="stylesheet" type="text/css" href="demo/demo.css">
	<script type="text/javascript" src="jquery.min.js"></script>
	<script type="text/javascript" src="jquery.easyui.min.js"></script>
    <script>
        //function ()
        $(function () { 
                      $("#tb").datagrid({
                        title: '',
                        columns: [
                            [{field: 'id', title: '编号', width: 50, sortable: true },
                            { field: 'name', title: '姓名', width: 50, sortable: true },
                        ]]
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
    <div>
        <table id="tb"></table>
    </div>
    </form>
</body>
</html>
