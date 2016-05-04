<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BorrowHistory.aspx.cs" Inherits="BorrowHistory" %>

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
        var toolid = '<%= toolid %>';
         var toolname = '<%= toolname %>';
          var borrowername = '<%= borrowername %>';
           var borrowstime = '<%= borrowstime %>';
            var borrowetime = '<%= borrowetime %>';
            var refundername = '<%= refundername %>';
             var refundstime = '<%= refundstime %>';
              var refundetime = '<%= refundetime %>';

        function BindGrid(data) {
         
           $("#tb").datagrid({ data: data}); 
        }
              
        function MyAjax(jsondat, SuccessFun, ErrorFun) {
            $.messager.progress({ title: '提示', msg: '正在处理，请稍候!' });
            $.ajax(
                    {
                        url: 'AJAX/Handler.ashx',
                        type: "POST",
                        data: JSON.stringify(jsondat),
                        dataType: 'json',
                        success: function(data) {
                            SuccessFun(data);
                            $.messager.progress('close');
                        },
                        error: function(xhr, s, e) {
                            if (ErrorFun == undefined || ErrorFun == null) {
                                ErrorFun(xhr, s, e);
                            } else {
                                $.messager.progress('close');
                                $.messager.alert('数据加载错误', e);
                            }
                        }
                    });
        }
        function ShowBrwWin(url) {
            $('#Win').window({
                width: 1024,
                height: 768,
                modal: true,
                shadow:true,
            });
            
            
            $("#fr1").attr("src",url);
            $("#Win").window({ title: "照片查看", closed: false});
            $("#Win").window({ closed: false });
        }
        function ShowTask(TaskID) {
            $('#Win1').window({
                width: 1024,
                height: 600,
                modal: true,
                shadow:true,
            });
            
            
            $("#TaskFR").attr("src","TaskDetails.aspx?TaskID=" + TaskID);
            $("#Win1").window({ title: "任务查看", closed: false});
            $("#Win1").window({ closed: false });
        }
        function LoadBorrowData()
        {
            cmd = { "cmd": "GetToolBorrowHistory", "toolid": toolid , "toolname": toolname ,"borrowername": borrowername,"borrowstime": borrowstime,"borrowetime": borrowetime,"refundername": refundername,"refundstime": refundstime,"refundetime": refundetime};
            MyAjax(cmd, BindGrid, null);
        }
        
         function formatLookBPic(val, row, index) {
            return '<a href= "#" onclick="ShowBrwWin(\''+row.BorrowPic+'\')">查看</a>';                  
        }
        function formatTask(val, row, index) {
           return '<a href= "#" onclick="ShowTask(\''+row.TaskID+'\')">'+row.TaskID+'</a>';                   
        }
        function formatLookRPic(val, row, index) {
           return '<a href= "#" onclick="ShowBrwWin(\''+row.RefundPic+'\')">查看</a>';      
        }
        
        $(function () {
            $("#tb").datagrid({
                title: '工具借还记录',
                columns: [
                            [{ field: 'ID', title: '编号', width: 40, sortable: true },
                            { field: 'TaskID', title: '任务编号', width: 55, sortable: true,formatter: formatTask  },
                            { field: 'WantToolID', title: '申请件号', width: 55, sortable: true },
                            { field: 'UserName', title: '申请人', width: 55, sortable: true },
                            { field: 'BorrowedToolID', title: '借出件号', width: 55, sortable: true },
                            { field: 'BorrowedToolName', title: '工具名称', width: 100, sortable: true },
                            { field: 'BorrowerName', title: '借用人', width: 50, sortable: true },
                            { field: 'BorrowTime', title: '借用时间', width: 150, sortable: true },
                            { field: 'BorrowPic', title: '借用快照', width: 55, sortable: true,formatter: formatLookBPic },
                            { field: 'RefunderName', title: '归还人', width: 50, sortable: true },
                            { field: 'RefundTime', title: '归还时间', width: 150, sortable: true },
                            { field: 'RefundPic', title: '归还快照', width: 55, sortable: true ,formatter: formatLookRPic }
                        ]]
            });

            });
      
    </script>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">

    <div >
    <a  id = "Add" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" style="" onclick= "javascript:LoadBorrowData();">
				<span style="" >加载</span>
			</a>
        <table id="tb" style=" "></table>
    </div>
    <div id="Win" class="easyui-window"  style = "padding:0px; width:300px; height:500px;" data-options="maximizable:false,minimizable:false,collapsible:false,closed:true" >
               <img id ="fr1"  width="100%" src="";></img>
            </div>
            <div id="Win1" class="easyui-window"  style = "padding:0px; width:300px; height:500px;" data-options="maximizable:false,minimizable:false,collapsible:false,closed:true" >
                <iframe id ="TaskFR"  width="97%" height="97%" frameborder="0"></iframe>
            </div>
    </form>
</body>
</html>
