<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TaskDetails.aspx.cs" Inherits="TaskDetail"  validateRequest="false"  %>
 <%@ Register Assembly= "AjaxControlToolkit" Namespace =  "AjaxControlToolkit" TagPrefix = "ajax" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<!DOCTYPE HTML>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<script src="artDialog/artDialog.js?skin=green"></script>
<script src="artDialog/plugins/iframeTools.js"></script>
      <link id="easyuiTheme" rel="stylesheet" type="text/css" href="themes/gray/easyui.css"/>
	<link rel="stylesheet" type="text/css" href="themes/icon.css"/>
	<link rel="stylesheet" type="text/css" href="demo/demo.css"/>
	<script type="text/javascript" src="jquery.min.js"></script>
	<script type="text/javascript" src="jquery.easyui.min.js"></script>
    <link href="Css/MyCSS.css" rel="stylesheet" type="text/css" />
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
    function showDialogByUrl( newURL,oldURL) {
        /* art.dialog({
        title: stitle,
        lock: true,
        content: '<iframe ID="i1" runat="server" src = "'+URL+'"></iframe>',
        window: 'top',
        ok:false,
        padding: 0,
        width:400,
        height:400
        });*/

        art.dialog.open(newURL, {
            lock: true,
            id:'dg_test34243',
            close: function() {
            art.dialog.open.origin.location.href = oldURL;
            }
        });
    }
    function showDlg(Msg) {
        art.dialog({
            title: '提示',
            content: Msg,
            cancel: false,
            ok: function() { }
        });
    }
</script>
<script   language=javascript>

    function Jump(URL,TargetID) {
        var xx = document.getElementById(TargetID);
        xx.src = URL;
        
  }
   
 </script>  
    <title></title>

    <style type="text/css">
        td
        {
           border:solid 1px ;
           font-size :medium;
            border-color:#00FFCC;
         }
                
    </style>

</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <cc1:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0" 
             Height="1100px"  Width="100%" Font-Size="Large" AutoPostBack="True" 
            onactivetabchanged="TabContainer1_ActiveTabChanged">
            <ajax:TabPanel runat="server" HeaderText="任务信息" ID="TabPanel1">
                <HeaderTemplate>
                任务信息</HeaderTemplate>
                <ContentTemplate><table class ="MyTable" width="99%" border="0" cellpadding="0" cellspacing="0"  ><tr><td>任务编号:</td><td class="style10"><asp:Label ID="label1" runat="server"></asp:Label></td><td class="style8">任务类型：</td><td class="style1"><asp:Label ID="Label2" runat="server"></asp:Label></td></tr><tr><td class="style3">任务名称:</td><td class="style7"><asp:Label ID="Label3" runat="server"></asp:Label></td><td class="style9">创建时间：</td><td class="style4"><asp:Label ID="Label4" runat="server"></asp:Label></td></tr><tr><td>任务创建人：</td><td class="style10"><asp:Label ID="Label5" runat="server"></asp:Label></td><td class="style8">任务创建部门:</td><td class="style1"><asp:Label ID="Label14" runat="server"></asp:Label></td></tr><tr><td>处理小组：</td><td class="style10"><asp:Label ID="Label13" runat="server"></asp:Label></td><td class="style8">任务状态：</td><td class="style1"><asp:Label ID="Label15" runat="server" ForeColor="Blue"></asp:Label></td></tr><tr><td>任务组长：</td><td class="style10"><asp:Label ID="Label17" runat="server"></asp:Label></td><td class="style8">任务成员：</td><td class="style1"><asp:Label ID="Label16" runat="server"></asp:Label></td></tr><tr><td class="style1">任务描述：</td><td class="style6" colspan="3"><asp:Label ID="Label18" runat="server"></asp:Label></td></tr></table><div style="padding:20px;text-align:center;">
                    <asp:Button ID="Button1" runat="server" onclick="Button1_Click" Text="提交任务" />
                    </div>
                </ContentTemplate>
            </ajax:TabPanel>
            <cc1:TabPanel ID="TabPanel2" runat="server" HeaderText="文档信息">
                <HeaderTemplate>
                文档信息</HeaderTemplate>
            </cc1:TabPanel>
                        <cc1:TabPanel ID="TabPanel6" runat="server" HeaderText="任务评审">
                        <HeaderTemplate>任务评审</HeaderTemplate>
                        <ContentTemplate> <iframe ID="TaskComments"  width="100%" frameborder="0" scrolling="yes"  height = "1000px"  scrolling ="auto" ></iframe></ContentTemplate>
                       
            </cc1:TabPanel>
            <cc1:TabPanel ID="TabPanel3" runat="server" HeaderText="任务数据">
                <HeaderTemplate>
                任务数据</HeaderTemplate>
            <ContentTemplate><iframe ID="TaskDATA"  width="100%" frameborder="0" scrolling="yes"  height = "1000px"  scrolling ="auto" ></iframe>
               
           
            </ContentTemplate>
            </cc1:TabPanel>
            <cc1:TabPanel ID="TabPanel4" runat="server" HeaderText="处理日志">
                <HeaderTemplate>
                处理日志</HeaderTemplate>
                <ContentTemplate><asp:GridView ID="TaskLogGV" runat="server" AllowSorting="True" 
                        AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" 
                        GridLines="None" onselectedindexchanged="GridView1_SelectedIndexChanged" 
                        onrowdatabound="TaskLogGV_RowDataBound" ><AlternatingRowStyle BackColor="White" ForeColor="#284775" /><Columns><asp:BoundField HeaderText="序号" /><asp:BoundField DataField="DateTime" HeaderText="生成时间" /><asp:BoundField DataField="CreateUserName" HeaderText="创建人" /><asp:BoundField DataField="Title" HeaderText="标题" /><asp:BoundField DataField="Content" HeaderText="内容" /></Columns><EditRowStyle BackColor="#999999" /><FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" /><HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" /><PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" /><RowStyle BackColor="#F7F6F3" ForeColor="#333333" /><SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" /></asp:GridView>
                </ContentTemplate>
            </cc1:TabPanel>
            <cc1:TabPanel ID="TabPanel5" runat="server" HeaderText="流转历史">
                <ContentTemplate><asp:GridView ID="TaskFlowGV" runat="server" AutoGenerateColumns="False" 
                        CellPadding="4" ForeColor="#333333" GridLines="None" Width="640px" 
                        onrowdatabound="TaskFlowGV_RowDataBound" ><AlternatingRowStyle BackColor="White" ForeColor="#284775" /><Columns><asp:BoundField HeaderText="序号" /><asp:BoundField DataField="fsbm" HeaderText="发送部门" /><asp:BoundField DataField="fsz" HeaderText="发送者" /><asp:BoundField DataField="jsbm" HeaderText="接收部门" /><asp:BoundField DataField="DateTime" HeaderText="流转时间" /><asp:BoundField HeaderText="内容" /></Columns><EditRowStyle BackColor="#999999" /><FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" /><HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" /><PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" /><RowStyle BackColor="#F7F6F3" ForeColor="#333333" /><SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" /></asp:GridView>
                </ContentTemplate>
            </cc1:TabPanel>

        </cc1:TabContainer>
    
    </div>
    <p>
        &nbsp;</p>
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    </form>
</body>
</html>
