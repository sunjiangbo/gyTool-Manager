<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TaskManage.aspx.cs" Inherits="TaskManage" enableEventValidation="false" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

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
    function showDialogByUrl(newURL, oldURL) {
        art.dialog.open(newURL, {
            lock: true,
            id: 'dg_test34243',
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
    var postback = true;
    function OntabSelect(title) {
        if (postback) {  return; }
        window.location = 'TaskManage.aspx?'+(title=='待处理'?'reFrashGV1=1':'reFrashGV2=2');
        
    }

    $(document).ready(function() {
        $("#tt").tabs({ onSelect: function(t) { OntabSelect(t); } });

        if ($("#Hidden1").val() == "1") {

            $("#tt").tabs('select', '待处理');
            postback = true;
        }
        if ($("#Hidden1").val() == "2") {
            postback = true;
            $("#tt").tabs('select', '处理中');
        }
        $.query.remove('reFrashGV1');
        $.query.remove('reFrashGV2');
        postback = false;
    });
</script>


</head>
<body id = "cc" class="easyui-layout">
    <form id="form1" runat="server">
 
         <div id= "MContent" title = "当前任务" region="center">
           <div id="tt" class="easyui-tabs" style="width:99%;"  data-options="border:false,fit:true">
    <div title="待处理" style="padding:20px;">
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
                        CellPadding="4" ForeColor="#333333" OnRowCreated="GridView1_RowCreated" 
                        OnRowDataBound="GridView1_RowDataBound" 
                        OnSelectedIndexChanged="GridView3_SelectedIndexChanged" ><RowStyle BackColor="#F7F6F3" ForeColor="#333333" /><AlternatingRowStyle BackColor="White" ForeColor="#284775" /><Columns><asp:BoundField DataField="TaskID" HeaderText="TaskID" /><asp:BoundField DataField="State" HeaderText="State" /><asp:BoundField HeaderText="序号" /><asp:BoundField DataField="TaskCode" HeaderText="任务编号" /><asp:BoundField DataField="TypeName" HeaderText="任务类型" /><asp:BoundField DataField="TaskName" /><asp:TemplateField><ItemTemplate><asp:LinkButton ID="LinkButton1" runat="server" onclick="LinkButton1_Click"></asp:LinkButton></ItemTemplate></asp:TemplateField><asp:BoundField DataField="TaskStatus" HeaderText="状态" /><asp:BoundField DataField="SendCropName" HeaderText="来自" /><asp:BoundField DataField="DateTime" HeaderText="流转时间" /><asp:BoundField DataField="Content" HeaderText="备注" /><asp:TemplateField HeaderText="选择小组"><ItemTemplate><asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True"></asp:DropDownList><asp:Button ID="Button1" runat="server" data-align="top right" 
                                        data-event="test" onclick="Button1_Click" Text="任务分配" /></ItemTemplate></asp:TemplateField><asp:TemplateField HeaderText="退回"><ItemTemplate>
                    <asp:Button ID="Button2" runat="server" Text="退回" onclick="Button2_Click" /></ItemTemplate></asp:TemplateField><asp:TemplateField><ItemTemplate>
                    <asp:Button ID="Button3" runat="server" Text="转出" onclick="Button3_Click" /></ItemTemplate></asp:TemplateField></Columns><EditRowStyle BackColor="#999999" /><FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" /><HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" /><PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" /><SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" /></asp:GridView>
    </div>
    <div title="处理中" data-options="border:false" style="overflow:auto;padding:20px;">
        <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" 
                        CellPadding="4" ForeColor="#333333" OnRowCreated="GridView2_RowCreated" 
                        OnRowDataBound="GridView2_RowDataBound"><RowStyle BackColor="#F7F6F3" ForeColor="#333333" /><AlternatingRowStyle BackColor="White" ForeColor="#284775" /><Columns><asp:BoundField DataField="TaskID" HeaderText="TaskID" /><asp:BoundField DataField="State" HeaderText="State" /><asp:BoundField HeaderText="序号" /><asp:BoundField DataField="TaskCode" HeaderText="任务编号" /><asp:BoundField DataField="TypeName" HeaderText="任务类型" />
                <asp:BoundField DataField="TaskName" HeaderText="TaskName" />
                <asp:TemplateField HeaderText="任务名称">
                    <ItemTemplate>
                        <asp:LinkButton ID="LinkButton2" runat="server" onclick="LinkButton1_Click"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="TaskStatus" HeaderText="状态" /><asp:BoundField DataField="SendCropName" HeaderText="来自" /><asp:BoundField DataField="DateTime" HeaderText="流转时间" /><asp:BoundField DataField="Content" HeaderText="备注" /><asp:TemplateField><ItemTemplate><asp:Button ID="DealBtn" runat="server" data-align="top right" 
                                        data-event="test" Text="处理" /></ItemTemplate></asp:TemplateField><asp:TemplateField><ItemTemplate>
                            <asp:Button ID="RollBackBtn" runat="server" Text="撤回" 
                                        onclick="RollBackBtn_Click1" style="height: 26px; width: 40px" /></ItemTemplate></asp:TemplateField><asp:TemplateField><ItemTemplate><asp:Button ID="OutBtn" runat="server" Text="转出" onclick="OutBtn_Click" /></ItemTemplate></asp:TemplateField></Columns><EditRowStyle BackColor="#999999" /><FooterStyle BackColor="#5D7B9D" ForeColor="White" Font-Bold="True" /><HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" /><PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" /><SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" /></asp:GridView><br />
         
        <input id="Hidden1" runat="server" type="hidden" />
         
    </div>
    
            </div>
                
      </div>
        
     </form>

</body>
</html>
