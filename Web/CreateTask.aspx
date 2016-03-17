<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CreateTask.aspx.cs" Inherits="CreateTask" EnableEventValidation="false" %>

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
      //$("#DropDownList1").combobox({ editable: false, onSelect: function(record) { ComChange(record); } });
    });
</script>
    <form id="form1" runat="server">
    <div id= "MContent" title = "入库" region="center">
           <div id="tt" class="easyui-tabs" style="width:99%;"  data-options="border:false,fit:true">
    <div title="待处理" style="padding:20px;">
        <table style="width:100%;" align="center">
        <tr>
            <td>
                任务类型：<asp:DropDownList class="easyui-combobox"  data-options="onSelect:function(record) { ComChange(record); }"  ID="DropDownList1" runat="server" 
                    Width="255px" AutoPostBack="True" 
                    onselectedindexchanged="DropDownList1_SelectedIndexChanged">
                </asp:DropDownList>
&nbsp;
                </td>
        </tr>
        <tr>
            <td>
                任务编号：<asp:Label ID="Label1" runat="server" 
                    ForeColor="Black"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                任务名称：<asp:TextBox class="easyui-textbox" ID="TextBox1" runat="server" Width="258px"></asp:TextBox>
                <span style='color:red'> * </spanstyle></span>简单描述任务内容</td>
        </tr>
        <tr>
            <td>
                任务描述：<asp:TextBox class="easyui-textbox" ID="TextBox2" runat="server" Height="167px" Width="256px" 
                    TextMode="MultiLine"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                接收部门：<asp:DropDownList ID="DropDownList2"  class="easyui-combobox" runat="server" Width="257px" 
                    AutoPostBack="True" Height="22px">
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td class="style1" >
                &nbsp;
                &nbsp;<asp:Button ID="Button3" runat="server" Text="创建任务" class="easyui-linkbutton" onclick="Button3_Click" />
            &nbsp;</td>
        </tr>
        <tr>
            <td class="style1" >
                <asp:Label ID="Label2" runat="server" ForeColor="Red"></asp:Label>
            </td>
        </tr>
    </table>

      </div>
    
    </form>
</body>
</html>
