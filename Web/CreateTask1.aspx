<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CreateTask1.aspx.cs" Inherits="CreateTask" EnableEventValidation="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link id="easyuiTheme" rel="stylesheet" type="text/css" href="themes/gray/easyui.css"/>
	<link rel="stylesheet" type="text/css" href="themes/icon.css"/>
	<link rel="stylesheet" type="text/css" href="demo/demo.css"/>
	<script type="text/javascript" src="jquery.min.js"></script>
	<script type="text/javascript" src="jquery.easyui.min.js"></script>
    <link href="Css/MyCSS.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="JS/MyJS.js"></script>
    <style type="text/css">
        #form1
        {
            margin-bottom: 19px;
        }
        .style1
        {
            height: 34px;
        }
    </style>
</head>
<body id = "cc" class="easyui-layout">
<script>
    var newURL = '<%= newURL %>';
    function PostBack(eventTarget, eventArgument) {
        var theForm = document.forms['form1'];
        if (!theForm) {
            theForm = document.form1;
        }
        
            if (!theForm.onsubmit || (theForm.onsubmit() != false)) {
                theForm.__EVENTTARGET.value = eventTarget;
                theForm.__EVENTARGUMENT.value = eventArgument;
                theForm.submit();
            }
     }
    function ComChange(record) {
        PostBack('DropDownList1', '');
    }
    
    $(function() {
       if(newURL!="")
       {
            $("#tgFrm").attr("src",newURL);
       }
    });
</script>
    <form id="form1" runat="server">
    <div id= "MContent" title = "借用工具" region="center">
           <div id="tt" class="easyui-tabs" style="width:99%;"  data-options="border:false,fit:true">
    <div title="创建任务" style="padding:20px;">
        <table style="width:100%;" align="center">
        <tr>
            <td>
                &nbsp;任务编号：<asp:Label ID="Label1" runat="server" 
                    ForeColor="Black"></asp:Label>
            &nbsp;
                任务名称：<asp:TextBox class="easyui-textbox" ID="TextBox1" runat="server" 
                    Width="141px"></asp:TextBox>
                &nbsp; <asp:Button ID="Button3" runat="server" Text="创建任务" onclick="Button3_Click" />
            &nbsp; 
                <asp:Button ID="Button4" runat="server" Text="提交任务(OK)" 
                     onclick="Button4_Click" />
            &nbsp;
                <asp:Label ID="Label2" runat="server" ForeColor="Red"></asp:Label>
                </td>
        </tr>
        <tr>
        <td>
          <div style="width:100%;height:5000px;">
            <iframe   id = "tgFrm" scrolling="auto" frameborder="no" border="0" style="width:100%;height:100%;" src=""></iframe>
         </div>
         </td>
        </tr>
    </table>

      
    
    </form>
</body>
</html>
