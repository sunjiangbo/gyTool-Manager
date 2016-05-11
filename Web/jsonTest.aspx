<%@ Page Language="C#" AutoEventWireup="true" CodeFile="jsonTest.aspx.cs" Inherits="Default3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
       <link id="easyuiTheme" rel="stylesheet" type="text/css" href="themes/gray/easyui.css"/>
	<link rel="stylesheet" type="text/css" href="themes/icon.css">
	<link rel="stylesheet" type="text/css" href="demo/demo.css">
	<script type="text/javascript" src="jquery.min.js"></script>
	    <script type="text/javascript" src="jquery.easyui.min.js"></script>
    <script type="text/javascript" src="JS/MyJS.js"></script>
    <script language="javascript" type="text/javascript">
// <![CDATA[

        function Button3_onclick() {
            ax = {};
            ax.cmd = "test";
            $.ajax(
                    {
                        url: 'AJAX/Handler.ashx',
                        type: "POST",
                        data: JSON.stringify(ax),
                        dataType: 'json',
                        success: function (data) {
                            alert(data.data);
                        },
                        error: function (xhr, s, e) {
                            alert(e.toString() + s.toString());
                        }
                    });
        }

// ]]>
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        cmd:
        <asp:TextBox ID="TextBox2" runat="server" Height="176px" TextMode="MultiLine" 
            Width="675px">{&quot;cmd&quot;:&quot;getModelTree&quot;}</asp:TextBox>
        <br />
        GoIt:<asp:Button ID="Button1" runat="server" onclick="Button1_Click" 
            Text="测试" />
        <asp:Button ID="Button2" runat="server" onclick="Button2_Click" Text="Button" />
        <input id="Button3" type="button" value="button" onclick="return Button3_onclick()" /><br />
        relt:<asp:TextBox ID="TextBox3" runat="server" Height="328px" 
            TextMode="MultiLine" Width="884px"></asp:TextBox>
    
    </div>
    </form>
</body>
</html>
