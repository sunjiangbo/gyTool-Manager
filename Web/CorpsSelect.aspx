<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CorpsSelect.aspx.cs" Inherits="CorpsSelect" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="themes/gray/easyui.css"/>
	<link rel="stylesheet" type="text/css" href="themes/icon.css"/>
	<link rel="stylesheet" type="text/css" href="demo/demo.css"/>
	<script type="text/javascript" src="jquery.min.js"></script>
	<script type="text/javascript" src="jquery.easyui.min.js"></script>
    <link href="Css/MyCSS.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="JS/MyJS.js"></script>
<script src="artDialog/artDialog.js?skin=green"></script>
<script src="artDialog/plugins/iframeTools.js"></script>

<script language="javascript">
    function tDialog() {

        art.dialog({
            title: '提示',
            lock: true,
            background: '#600',
            opacity: 0.87,
            content: 'fuck',
            window: 'top'
        });
    }
    function CloseArtDialog() {

        art.dialog({ id: 'dg_test34243' }).close();
    }

    </script>
    
</head>
<body>
    <form id="form1" runat="server">
    <div align="top" style="width: 304px">
    
        <asp:Label ID="Label1" runat="server" Text="流转说明："></asp:Label>
    
        <asp:TextBox ID="TextBox1" runat="server" Height="117px" Width="205px" 
            TextMode="MultiLine"></asp:TextBox>
    
    </div>
    <div style="width: 305px">
    
        <asp:Label ID="Label2" runat="server" Text="选择部门："></asp:Label>
    
        <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" 
            Height="22px" Width="211px">
        </asp:DropDownList>
    
    </div>
    <div style = "float :left;">
    <asp:Label ID="lb" runat="server" ForeColor="Red" Font-Bold="True" 
            Font-Size="Medium"></asp:Label>
    <div align="right" style="width: 304px"> 
           
           &nbsp;<asp:Button ID="Button1" runat="server" onclick="Button1_Click" Text="转发" />
    
    </div>
    </div>
    
    </form>
</body>
</html>
