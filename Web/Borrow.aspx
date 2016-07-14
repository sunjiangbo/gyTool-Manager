<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Borrow.aspx.cs" Inherits="Borrow" %>

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
        var reBack = '<%= reBack %>';
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
            //alert(rowDat.WantToolName + rowDat.WantToolID);
            $("#Frm1").attr("src", "ToolBag.aspx?Type=2&BagID=" + rowDat.coreid);
            if (Type == "1") { return; }
           
            if (rowDat.status == "已提交") {
                $("#Table_Type3").css("display", "none");
                $("#Table_Type2").css("display", "");
                $("#Table_Type1").css("display", "none");
                $("#WantToolID").text(rowDat.WantToolID);
                $("#WantToolName").text(rowDat.WantToolName);
                jdat = {};
                jdat.cmd = "GetIdenticalTool";
                jdat.cmpoption = 0;//只比较匹配属性
                jdat.toolstate = 0; //在库
                jdat.toolid = rowDat.WantToolID;
                MyAjax(jdat, function (data) {
                    $("#CanBorrow").combobox({ editable: false, textField: "toolid", valueField: "coreid", data: data.data });
                }, null);
                jdat.cmd = "GetToolState";
                MyAjax(jdat, function (data) {
                    $("#StatusSpan").text(data.toolstate);
                    if (data.toolstate == '在库') {
                        $("#ToBorrow").text(rowDat.WantToolID);
                    }
                }, null);
            }
            if (rowDat.status == "已借出") {
                $("#Table_Type3").css("display", "");
                $("#Table_Type2").css("display", "none");
                $("#Table_Type1").css("display", "none");
                $("#rToolID").text(rowDat.BorrowedToolID);
                $("#rToolName").text(rowDat.BorrowedToolName);
            }
            if (rowDat.status == "已归还") {
                $("#Table_Type3").css("display", "none");
                $("#Table_Type2").css("display", "none");
                $("#Table_Type1").css("display", "none");
                $("#RefunderName").val();
            }
          

        }
        function LoadTable() {
            json = {};
            json.cmd = "GetBorrowInfo";
            json.taskid = TaskID;
            MyAjax(json, function (dat) {
                if (dat.status == "success") {
                    $("#tb").datagrid({ data: dat.data, onClickRow: function (rowIndex, rowData) { RowClick(rowIndex, rowData); } });
                }
            });
        }
        function DelBorrowApp() {
            var rowDat = $('#tb').datagrid('getSelected');
            if (rowDat == null) { $.messager.alert("提示", "没有选择任何行呢！"); return; }
            $.messager.confirm('提醒', "确定要删除件号为" + rowDat.WantToolID + "的" + rowDat.WantToolName+ "吗？", function (r) {
                if (r) {
                    json = {};
                    json.cmd = "DelBorrowApp";
                    json.appid = rowDat.id;
                    json.taskid = TaskID;
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
        function Borrow() {
            var rowDat = $('#tb').datagrid('getSelected');
            var ToolID = $.trim($("#ToBorrow").text());
            var BorrowerName = $.trim($("#Borrower").val());

            if (ToolID == "" || rowDat == null) { $.messager.alert("提示", "没有选择要借出的工具"); }
            if (BorrowerName == "") { $.messager.alert("提示", "请输入借用人");return;}

            json = {};
            json.cmd = "BorrowToolByID";
            json.appid = rowDat.id;
            json.taskid = TaskID;
            json.toolid = ToolID;
            json.borrowername = BorrowerName;
            MyAjax(json, function (dat) {
                if (dat.status == "success") {
                    $.messager.alert("提示", dat.msg);
                    LoadTable();
                    $("#Table_Type3").css("display", "none");
                    $("#Table_Type2").css("display", "none");
                    $("#Table_Type1").css("display", "none");
                } else {
                    $.messager.alert("提示", dat.msg);
                    LoadTable();
                }
            });
        }
        function Quejian() { 
            
        }
        function ClassChange(record) {
            $("#Frm2").attr("src", "ToolBag.aspx?Type=2&BagID="+record.coreid);
            jdat = {};
            jdat.toolid = record.toolid;
            jdat.cmd = "GetToolState";
            MyAjax(jdat, function (data) {
                // $("#StatusSpan").text(data.toolstate);
                if (data.toolstate == '在库') {
                    $("#ToBorrow").text(record.toolid);
                } else {
                    $.messager.alert("提示", "件号为" + record.toolid + "的工具，状态为" + data.toolstate + ",不可借出，请刷新!");
                }
            }, null);
            
        }
        function Refund() {
            var rowDat = $('#tb').datagrid('getSelected');
            //var ToolID = $.trim($("#ToBorrow").text());
            var RefunderName = $.trim($("#RefunderName").val());

            if (rowDat == null) { $.messager.alert("提示", "没有选择要借出的工具!"); return; }
            if (RefunderName == "") { $.messager.alert("提示", "请输入归还人!");return; }

            json = {};
            json.cmd = "RefundToolByAppID";
            json.appid = rowDat.id;
            json.refundername = RefunderName;
            MyAjax(json, function (dat) {
                if (dat.status == "success") {
                    $.messager.alert("提示", dat.msg);
                    LoadTable();
                    $("#Table_Type3").css("display", "none");
                    $("#Table_Type2").css("display", "none");
                    $("#Table_Type1").css("display", "none");
                } else {
                    $.messager.alert("提示", dat.msg);
                    LoadTable();
                }
            });
        }
        function GetbrwerCount()
        {
            o={};
            o.cmd="GetbrwerCount";
            o.taskid=TaskID;
            MyAjax(o,function(count){
                $("#brwerCount").text("(" + count+")");
                $("#brwerCount").val("(" + count+")");
            });
        }
        function ShowBrwWin() {
            $('#Win').window({
                width: 450,
                height: 350,
                modal: true,
            });
            
            $("#Win").window({ title: "工具领用人管理", closed: false,onClose:function(){
                GetbrwerCount();
            }});
            $("#Win").window({ closed: false });
        }

        function CloseTheTask()
        {
            
             $.messager.confirm('确认','您确认想要关闭任务？',function(r){    
                if (r){    
                     var json = {};
                    json.cmd = "CloseTheTask";
                    json.taskid = TaskID; 
                    json.content = "手动关闭"; 
                    MyAjax(json, function (data) {
                        $.messager.progress('close');
                        if (data.status == "success") {
                             $.messager.alert('提示', data.msg);
                        
                        } else {
                             $.messager.alert('错误', data.msg);
                        }
                        }, null);
                }    
            });  
                   
       
        }

        $(function () {
            LoadTable();
            if (reBack == "") {
                $("#retBtn").hide();
            }
            if (Type == "1") {
                $("#Table_Type1").css("display", "");
            }
            if (Type == "10") {
                $("#Table_Type1").css("display", "none");
            }
            $("#fr1").attr("src", "preBrowerList.aspx?TaskID="+TaskID);
             $("#Win").window({ closed: true });
            $("#brwerCount").bind("click", function () { ShowBrwWin(); });
             // $("#Win").window({ closed: true });
             GetbrwerCount();
        });
    </script>
</head>
<body class="easyui-layout">
    <form id="form1" runat="server">
		<div data-options="region:'north'" style=" float:left; overflow:hidden;padding:10px">
			<a id = "retBtn"  style = "margin-right:20px;" class="easyui-linkbutton" onclick = "GoBack();"><--返回</a>
            领用人:
             <a id = "brwerCount" style = "cursor:pointer;text-decoration:underline; color:Blue;font-weight:bold; margin-right:20px;margin-left:5px;">(0)</a>
		      &nbsp;&nbsp;&nbsp;<a id = "BtnClose"  style = "margin-right:20px;" class="easyui-linkbutton" onclick = "CloseTheTask();">关闭任务</a>
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
                        <th data-options="field:'status'" width="50">状态</th>
						<th data-options="field:'WantToolID'" width="60">欲借件号</th>
						<th data-options="field:'WantToolName'" width="100">工具名称</th>
						<th data-options="field:'UserName'" width="80">添加人</th>
						<th data-options="field:'createtime'" width="150">添加时间</th>
                        <th data-options="field:'BorrowedToolID'" width="80">已借出件号</th>
                        <th data-options="field:'BorrowedToolName'" width="120">借出工具名称</th>
						<th data-options="field:'BorrowerName'" width="80">借用人</th>
                        <th data-options="field:'BorrowAdminName'" width="80">借出人</th>
                        <th data-options="field:'BorrowTime'" width="80">借出时间</th>
                        <th data-options="field:'RefunderName'" width="80">归还人</th>
                        <th data-options="field:'RefundAdminName'" width="100">入库检验人</th>
                        <th data-options="field:'RefundTime'" width="80">归还时间</th>
					</tr>
				</thead>
			</table>
            </div>
            <div  >
            <table class = "MyTable"id="Table_Type1" border="0" cellpadding="0" cellspacing="0" style = "width:100%; display:none;">
          
             <tr>
                <td>
                    操作
                </td>
                <td>
                <a id = "DelBtn"  style = "margin-right:20px;" class="easyui-linkbutton" onclick = "DelBorrowApp();">删除</a>
                </td>
                </tr>
            </table>
             <table class = "MyTable"id="Table_Type2" border="0" cellpadding="0" cellspacing="0" style = "width:100%; display:none;">
            <tr>
                <td>
                    欲借工具名
                </td>
                <td>
                    <span id= "WantToolName" style = "color :Blue; font-weight:bold;"></span>
                </td>
                </tr>
             <tr>
             <tr>
                <td>
                    欲借件号
                </td>
                <td>
                    <span id= "WantToolID" style = "color :Blue; font-weight:bold;"></span>
                </td>
                </tr>
             <tr>
                <td>
                    工具状态
                </td>
                <td>
                    <span id= "StatusSpan" style = "color:blue; font-weight:bold;"></span>
                </td>

                </tr>
                             <tr>
                <td>
                    相同工具(可借)
                </td>
                <td>
                    <select id ="CanBorrow" class="easyui-combobox" data-options="onSelect: function(record) { ClassChange(record); }"></select>
                </td>
                </tr>
                             <tr>
                <td>
                   <span id= "Span1" style = "color:blue; font-weight:bolder;">当前选择</span>
                </td>
                <td>
                    <span id= "ToBorrow" style = "color:red; font-weight:bold;"></span>
                </td>

                </tr>
                <tr>
                <td>
                   借用人
                </td>
                <td>
                    <input id= "Borrower" style = " text-align:center; font-weight:bolder;"/>
                </td>

                </tr>
             <tr>
                <td>
                    操作
                </td>
                <td>
                    <a id = "BorrowBtn"  style = "margin-right:20px;" class="easyui-linkbutton" onclick = "Borrow();">借出</a>&nbsp;
                     <a id = "Quejian"  style = "margin-right:20px;" class="easyui-linkbutton" onclick = "Quejian();">登记缺件</a>
                </td>

                </tr>
            </table>
                  <table class = "MyTable"id="Table_Type3" border="0" cellpadding="0" cellspacing="0" style = "width:100%; display:none;">
           <tr>
                <td>
                   <span id= "Span4" style = "color:blue; font-weight:bolder;">在借件号</span>
                </td>
                <td>
                    <span id= "rToolID" style = "color:red; font-weight:bold;"></span>
                </td>

                </tr>
          <tr>
                <td>
                   <span id= "Span2" style = "color:blue; font-weight:bolder;">在借工具名</span>
                </td>
                <td>
                    <span id= "rToolName" style = "color:red; font-weight:bold;"></span>
                </td>

                </tr>
             <tr>
                <td>
                  归还人
                </td>
                <td>
                    <input id= "RefunderName" style = " text-align:center; font-weight:bolder;"/>
                </td>

                </tr>
             <tr>
                <td>
                    操作
                </td>
                <td>
                <a id = "A1"  style = "margin-right:20px;" class="easyui-linkbutton" onclick = "Refund();">归还</a>
                </td>
                </tr>
            </table>
            </div>
		</div>
             <div id="Win" class="easyui-window"  style = "padding:0px; width:300px; height:500px;" data-options="maximizable:false,minimizable:false,collapsible:false,closed:true" >
               <iframe id ="fr1"  width="97%" height="97%" frameborder="0"></iframe>
            </div>
    </form>
</body>
</html>
