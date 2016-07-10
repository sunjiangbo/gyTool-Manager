<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="Main.aspx.cs" Inherits="Main" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
       <link id="easyuiTheme" rel="stylesheet" type="text/css" href="themes/gray/easyui.css"/>
	<link rel="stylesheet" type="text/css" href="themes/icon.css">
	<link rel="stylesheet" type="text/css" href="demo/demo.css">
	<script type="text/javascript" src="jquery.min.js"></script>
	    <script type="text/javascript" src="jquery.easyui.min.js"></script>
    <script type="text/javascript" src="JS/MyJS.js"></script>
    <script>
        function ItemClick(a) {
            var c = $("#cc");
            var p = c.layout('panel', 'center');

            if ($.trim($(a).text()) == '模型管理') {
                $(p).panel("setTitle", $(a).text());
                main.window.location = 'ModelManage.aspx';
            }
            if ($.trim($(a).text()) == '创建任务') {
                $(p).panel("setTitle", $(a).text());
                main.window.location = 'CreateTask.aspx';
            }
            if ($.trim($(a).text()) == '工具入库') {
                $(p).panel("setTitle", $(a).text());
                main.window.location = 'StoreTool.aspx';
            }
            if ($.trim($(a).text()) == '当前任务') {
                $(p).panel("setTitle", $(a).text());
                main.window.location = 'TaskManage.aspx';
            }
            if ($.trim($(a).text()) == '打号任务') {
                $(p).panel("setTitle", $(a).text());
                main.window.location = 'HitTask.aspx';
            }
            if ($.trim($(a).text()) == '工具入编') {
                $(p).panel("setTitle", $(a).text());
                main.window.location = 'CreateBag.aspx';
            }
            if ($.trim($(a).text()) == '库存查询') {
                $(p).panel("setTitle", $(a).text());
                main.window.location = 'Query.aspx';
            }
            if ($.trim($(a).text()) == '工具管理') {
                $(p).panel("setTitle", $(a).text());
                main.window.location = 'ToolQuery.aspx';
            }
             if ($.trim($(a).text()) == '借还历史') {
                $(p).panel("setTitle", $(a).text());
                main.window.location = 'BorrowHistory.aspx';
            }

        }       
    </script>
    <style>
       .panelItem
        {
             margin-top:5px;
         }
    </style>
</head>

 <body id ="cc" class="easyui-layout">
 <form id="form1" runat="server">

<div region="north"  
         style=" overflow:visible;  height:90px;padding:0; background-repeat: repeat; background-image: url('Img/123.png');">
    <div style="margin:30px 0px 10px 150px;padding:0"><img style="height:50px;" src="Img/logo.png"/></div></div>


<div region="west"  title="综合任务管理系统" split="true" style="width:160px;" >
<div id="accordion" class="easyui-accordion" data-options="fit:true"> 
     <div title="任务管理" data-options="selected:true" style="overflow:auto;">   
        <div style="width:100%;">
		<div class = "panelItem"><a href="#" style="width:80%"class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'" onclick="ItemClick(this);">创建任务</a></div>
		<div class = "panelItem"><a href="#" style="width:80%"class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-reload'" onclick="ItemClick(this);">当前任务</a></div>
		<div class = "panelItem"><a href="#" style="width:80%"class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'" onclick="ItemClick(this);">历史任务</a></div>
		</div>
    </div>   
    <div title="  工具管理" data-options="" style="padding:10px;">   
        <div style="width:100%;">
		<div class = "panelItem"><a href="#" style="width:80%" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-model'"  onclick="ItemClick(this);">模型管理</a></div>
		<div class = "panelItem"><a href="#" style="width:80%" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-reload'"  onclick="ItemClick(this);">工具入库</a></div>
		<div class = "panelItem"><a href="#" style="width:80%" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'"  onclick="ItemClick(this);">库存查询</a></div>
        <div class = "panelItem"><a href="#" style="width:80%" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-reload'"  onclick="ItemClick(this);">工具入编</a></div>
        <div class = "panelItem"><a href="#" style="width:80%" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'"  onclick="ItemClick(this);">打号任务</a></div>
        <div class = "panelItem"><a href="#" style="width:80%" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search1'"  onclick="ItemClick(this);">工具管理</a></div>
        <div class = "panelItem"><a href="#" style="width:80%" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-reload'"  onclick="ItemClick(this);">借还历史</a></div>
		</div>
    </div>      
    </div>   
    <div title="  账户管理" style="">   
          
    </div>   

</div>  


<div id= "Center" region="center" title = "">
  <iframe id="main" name="main" scrolling="auto" frameborder="0" scrolling="yes" width="100%"
                    height="100%" src="">
                    </iframe>
</div>


<div id="cc1"  style="width:100%;height:400px;">  
   <p>panel content.</p>
<p>panel content.</p>
</div>  




<div region="south" style="height:30px;text-align:center;padding-top:6px;">中国民用航空飞行学院洛阳分院</div>

 </form>
</body>
   

</html>

