<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<link rel="stylesheet" type="text/css" href="themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="themes/icon.css">
	<link rel="stylesheet" type="text/css" href="demo/demo.css">
	<script type="text/javascript" src="jquery.min.js"></script>
	<script type="text/javascript" src="jquery.easyui.min.js"></script>
    <script>

        var treeDat = [{ id: 1, text: '操作系统', state: 'open', 'children': [{ 'id': "2", 'text': 'Windows', 'checked': true }, { 'id': "3", 'text': "linux", 'checked': true}] },
                       { id: 4, text: ' 编辑器', state: 'open', 'children': [{ 'id': "5", 'text': 'VIM', 'checked': true }, { 'id': "6", 'text': "EditPlus", 'checked': false}] }
        ];


        function fun(a, b) {
       
            $.ajax({
                url: 'Server.aspx',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: {'json':{ a: b }},
                success: function (data) {
                     $("#right").html(data);
                }
            });

        }

        $(function () {
            $('#sd').datagrid({
                                    columns: [[
		                    { field: 'userId', title: 'User', width: 80,
		                        formatter: function (value, row, index) {
		                            if (row.user) {
		                                return row.user.name;
		                            } else {
		                                return value;
		                            }
		                        }
		                    }
	                    ]]
            });


            $("#right").panel({title:"CAAC2015"});
            $("#tt").tree({ onlyLeafCheck:true,checkbox: true, data: treeDat, onSelect: function (node) { fun(node.id, node.text); } });

        });

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div style="width:100%;height:150px;border:1px solid gray"></div>
        <div style="width:100%;padding:0;margin:0;">
            <div style="float:left;width:15%;height:700px;border:1px solid gray;padding:10px 0 0 0;border-bottom:0px;">
                <ul id= "tt"></ul>
            </div>
            <div id = "right" style="height:700px;border:0 solid">
                <div id= "sd"></div>
            </div>
        </div>
    </form>
</body>
</html>
