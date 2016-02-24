<%@ Page Language="C#" AutoEventWireup="true" CodeFile="test.aspx.cs" Inherits="test" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
       <link rel="stylesheet" type="text/css" href="themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="themes/icon.css">
	<link rel="stylesheet" type="text/css" href="demo/demo.css">
	<script type="text/javascript" src="jquery.min.js"></script>
	<script type="text/javascript" src="jquery.easyui.min.js"></script>
    <script type="text/javascript" src="JS/MyJS.js"></script>
    <style>
*{
    font-family: 微软雅黑, 宋体, Arial;  
  }
table{
    
    padding: 0px;
    margin: 0px;   
    border-collapse:collapse;
    width:70%;
}

table td.attrtd {
 border: 1px solid #C1DAD7;  
    background: #ECF1EF;
    font-size:11px;
    padding: 6px 6px 6px 12px;
    color: blue;
    text-align:left;
    width:170px;
}
table td.valuetd {
border: 1px solid #C1DAD7;  
    font-size:11px;
    padding: 6px 6px 6px 12px;
    color: #4f6b72;
    text-align:left;
     width:170;
}
table td.tool
{
    border: 1px solid #C1DAD7;  
   background: #FFEFDB;
    font-size:12px;
    padding: 6px 6px 6px 12px;
    color: #4f6b72;
    text-align:left;
    font-weight:bold;
}
table td.toolbag
{
    border: 1px solid #C1DAD7;  
   background: #8EE5EE;
    font-size:12px;
    padding: 6px 6px 6px 12px;
    color: #4f6b72;
    text-align:left;
    font-weight:bold;
}
        .style1
        {
            height: 29px;
        }
    </style>
</head>
<body background="Img/fm.jpg">
<script>
    $(function() {
        $('#dd').tooltip({
            position: 'right',
            content: function() {
                div = $("<div></div>").load("main.aspx");
                return div;
            },

            onShow: function() {

            }
        });
    });
</script>
    <form id="form1" runat="server">
    <p/>
    <p/>
        <asp:Button ID="Button1" runat="server" onclick="Button1_Click" Text="Button" />
    <p/>
    <p/>
    <p/>
    
    <p/>
    <p/>
    <p/>
    <p/>
    <div>
    <a id="dd" href="javascript:void(0)">Click here</a>
    <a href="#" title="This is the tooltip message." class="easyui-tooltip">Hover me</a>
    </div>
    </form>
</body>
</html>
