<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login2.aspx.cs" Inherits="Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">

        .style1
        {
            width: 92px;
        }
    </style>
</head>
<body style= "background:url(img/fm.jpg)" background="Img/fm.jpg">
    <form id="form1" runat="server">
    <div style="height: 80px; width: 162px;">
   
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
   
        <table align="center" border="0" 
            style="width: 261px; height: 97px; margin-left: 0px;">
            <tr>
                <td class="style1" height="29">
                    &nbsp; 工&nbsp; 号</td>
                <td align="left" width="126">
                    <asp:TextBox ID="txtUserName" runat="server" Width="100px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="style1" height="29">
                    &nbsp; 密 &nbsp;码</td>
                <td align="left">
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Width="100px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="style1" height="30">
                    &nbsp;</td>
                <td>
<%--            <a href="#"><img src="images/login.jpg" width="52" height="25" border="0" id="Image2" onmouseover="MM_swapImage('Image2','','images/loginreturn.jpg',1)" onmouseout="MM_swapImgRestore()" /></a> 
            <a href="#"><img src="images/exit.jpg" width="52" height="25" border="0" id="Image1" onmouseover="MM_swapImage('Image1','','images/exitreturn.jpg',1)" onmouseout="MM_swapImgRestore()" /></a>
--%>            
                    <asp:ImageButton ID="btnLogin" runat="server" height="25" 
                        ImageUrl="img/login.jpg" onclick="btnLogin_Click" width="52" />
                    <asp:ImageButton ID="btnExit" runat="server" height="25px" 
                        ImageUrl="img/exit.jpg" OnClientClick="window.close();" width="52px" 
                        onclick="btnExit_Click" />
                </td>
            </tr>
        </table>
    
    </div>
    </form>
</body>
</html>
