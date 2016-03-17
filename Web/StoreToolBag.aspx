<%@ Page Language="C#" AutoEventWireup="true" CodeFile="StoreToolBag.aspx.cs" Inherits="StoreToolBag" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
      <link id="easyuiTheme" rel="stylesheet" type="text/css" href="themes/gray/easyui.css"/>
	<link rel="stylesheet" type="text/css" href="themes/icon.css"/>
	<link rel="stylesheet" type="text/css" href="demo/demo.css"/>
	<script type="text/javascript" src="jquery.min.js"></script>
	<script type="text/javascript" src="jquery.easyui.min.js"></script>
    <script type="text/javascript" src="JS/MyJS.js"></script>
    <link href="Css/MyCSS.css" rel="stylesheet" type="text/css" />
    
</head>
<script>
    
</script>


<body>
    <form id="form1" runat="server">
    <div>
    <table class = "MyTable"id="table1" border="0" cellpadding="0" cellspacing="0">
         <tr>
            <td>模板类</td>
            <td colspan="3" style="text-align:left;"><select style = "width:150px; " id ="drClass" ></select></td>
            
         </tr>
         <tr>
             <td>名称</td>
             <td><input id = "t_ToolName" type="text" /></td>
             <td >数量</td>
             <td><input id = "Count" type="text" value ="1"/></td>
         </tr>
         </table>
    </div>
    <div>
        
    </div>
    </form>
</body>
</html>
