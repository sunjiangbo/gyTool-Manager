<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Tmp_HitTool.aspx.cs" Inherits="Borrow" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
      <link id="easyuiTheme" rel="stylesheet" type="text/css" href="themes/gray/easyui.css"/>
	<link rel="stylesheet" type="text/css" href="themes/icon.css"/>
	<link rel="stylesheet" type="text/css" href="demo/demo.css"/>
	<script type="text/javascript" src="jquery.min.js"></script>
	<script type="text/javascript" src="jquery.easyui.min.js"></script>
    <link href="Css/MyCSS.css" rel="stylesheet" type="text/css" />
    <script>
        var TaskID = '<%= TaskID %>';
        var Type = '<%= Type %>';
        var reBack = '<%= reBack %>'
        var CurrkID= "";
        function GoBack() {
            location.href = reBack;
        }
        function MyAjax(jsondat, SuccessFun) {
            $.messager.progress({ title: '提示', msg: '正在处理，请稍候!' });
            $.ajax(
                    {
                        url: 'AJAX/Handler.ashx',
                        type: "POST",
                        data: JSON.stringify(jsondat),
                        dataType: 'json',
                        success: function (data) {
                            $.messager.progress('close');
                            SuccessFun(data);
                        },
                        error: function (xhr, s, e) {
                           
                                $.messager.progress('close');
                                $.messager.alert('数据加载错误', e);
                            
                        }
                    });
        }
        function RowClick(index, rowDat) {

            var rowDat = $('#tb').datagrid('getSelected');
            if (rowDat == null) return;
            $("#Frm1").attr("src", "ToolBag.aspx?Type=1&BagID="+rowDat.id);
            
            json = {};
            json.cmd = "GetToolPosID";
            json.rkid = rowDat.rkid;
            CurrkID = rowDat.rkid;
            MyAjax(json, function(dat) {
                if (dat.status == "success") {
                     $("#POSID").val(dat.posid);
                 }
            });
        }
        function LoadTable() {
            json = {};
            json.cmd = "GetTmpHitToolInfobyTaskID";
            json.taskid = TaskID;
            MyAjax(json, function(dat) {
                if (dat.status == "success") {
                     $("#tb").datagrid({ data: dat.data, onClickRow: function(rowIndex, rowData) { RowClick(rowIndex, rowData); } });
                }
            });
        }
        function DelBorrowApp() {
            var rowDat = $('#tb').datagrid('getSelected');
            if (rowDat == null) { $.messager.alert("提示", "没有选择任何行呢！"); return; }
            $.messager.confirm('提醒', "确定要删除件号为" + rowDat.rkid + "的" + rowDat.toolname+ "吗？", function (r) {
                if (r) {
                    json = {};
                    json.cmd = "DelTmpHitToolByrkID";
                    json.rkid = rowDat.rkid;
                    MyAjax(json, function (dat) {
                        if (dat.status == "success") {
                            $.messager.alert("提示", dat.msg);
                            LoadTable();                            
                        } else {
                            $.messager.alert("提示", dat.msg);
                        }
                    });
                } 
            });

        }
        function tijiao() {//工具入编
            if ($("#KeyPerson").val() == "") {
                $.messager.alert("提示", "请输入打号负责人!");
                return;
            }
            $.messager.progress({ title: '提示', msg: '正在处理，请稍候!' });
            json = {};
            json.cmd = "tijiao";
            json.coreperson = $("#KeyPerson").val();
            json.taskid = TaskID;
            MyAjax(json, function(dat) {
                if (dat.status == "success") {
                    TaskID = "";
                    LoadTable();
                    reBack = "Query.aspx";                    
                }
                $.messager.alert("提示", dat.msg);
            });
        }
        $(function() {
            $("#tID").text(TaskID);
            LoadTable();
            if (reBack == "") {
                $("#retBtn").hide();
            }
            if (Type == "1") {
                $("#Table_Type1").css("display", "");
            }
            $("#POSID").focusout(function()
            {
                    if(CurrkID=="")
                    {
                        return;
                    }
                    
                    if($("#POSID").val()=="")
                    {
                        $.messager.alert("提示", "师傅，货位编号不能为空哦！否则后面货物盘点功能咋个用呢？");
                        return;
                    }
                   
                    json = {};
                    json.cmd = "SetToolPosID";
                    json.rkid = CurrkID;
                    json.posid = $("#POSID").val();
                    MyAjax(json, function(dat) {
                        if (dat.status != "success") {
                             $.messager.alert("提示", "货位编号设定失败!请重试，如果还不行，联系李光耀!");
                         }else{
                             CurrkID = "";
                             LoadTable();
                         }
                    }); 
            });
        });
    </script>
</head>
<body class="easyui-layout">
    <form id="form1" runat="server">
		<div data-options="region:'north'" style=" float:left; overflow:hidden;padding:10px">
			<a id = "retBtn"  style = "margin-right:20px;" class="easyui-linkbutton" onclick = "GoBack();"><--返回</a>
			任务编号:<span id ="tID" style = "color:Blue; font-weight:bolder;"></span>
			打号负责人<input id = "KeyPerson" style = " text-align:center; font-weight:bolder; width:100px;"/>
			<a id = "tijiao"  style = "margin-right:20px;" class="easyui-linkbutton" onclick = "tijiao();">提交</a>
		</div>
		<div id = "tBags"data-options="region:'east',iconCls:'icon-reload',split:true" title="工具预览" style="width:700px;">
             <iframe  id = "Frm1" frameborder="no" border="0" style="width:100%;height:100%;" src=""></iframe>
              <iframe  id = "Frm2" frameborder="no" border="0" style="width:100%;height:100%;" src=""></iframe>
        </div>
		<div data-options="region:'center',title:'借用信息'" style="background:#fafafa;overflow:hidden">
			<div style = " height:350px;">
            <table id = "tb" class="easyui-datagrid"
					data-options="border:false,fit:true,singleSelect:true">
				<thead>
					<tr>
						<th data-options="field:'xh'" width="30">序号</th>
                        <th data-options="field:'rkid'" width="50">工具号</th>
						<th data-options="field:'toolname'" width="200">工具名称</th>
						<th data-options="field:'posid'" width="150">货位编码</th>
					</tr>
				</thead>
			</table>
            </div>
            <div  >
            <table class = "MyTable"id="Table_Type1" border="0" cellpadding="0" cellspacing="0" style = "width:100%; ">
          
             <tr>
                <td>
                    操作
                </td>
                <td>
                <a id = "DelBtn"  style = "margin-right:20px;" class="easyui-linkbutton" onclick = "DelBorrowApp();">删除条目</a>
                </td>
                </tr>
            <tr>   
               <td>
                    货位编号
                </td>
                <td>
                <input id = "POSID" style = " text-align:center; font-weight:bolder; width:100px;"/>
                </td>
                </tr>   
            </table>
            
            </div>
		</div>
    </form>
</body>
</html>
