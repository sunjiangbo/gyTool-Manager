<%@ Page Language="C#" AutoEventWireup="true" CodeFile="unSafe.aspx.cs" Inherits="unSafe" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
           <link id="easyuiTheme" rel="stylesheet" type="text/css" href="themes/gray/easyui.css"/>
	<link rel="stylesheet" type="text/css" href="themes/icon.css">
	<link rel="stylesheet" type="text/css" href="demo/demo.css">
	<script type="text/javascript" src="jquery.min.js"></script>
	    <script type="text/javascript" src="jquery.easyui.min.js"></script>
    <script type="text/javascript" src="JS/MyJS.js"></script><title></title>
</head>
 <body id = "cc" class="easyui-layout">
    <form id="form1" runat="server">
   <div id= "MContent" title = "不安全及不诚信记录" region="center">
    <div id="tt" class="easyui-tabs" style="width:99%;"  data-options="border:false,fit:true">
    <div title="不安全事件记录" style="padding:10px;">
    
    </div>
    <div title="不诚信事件记录" style="padding:10px;">
    
    </div>
    </div>
    </div>
    </form>
</body>
</html>
