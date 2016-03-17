<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HitTask.aspx.cs" Inherits="HitTask"  %>

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
<script>

    $(function() {
       $('input[name$="Button3"]').removeAttr('onclick');
       $('input[name$="Button3"]').bind('click',function(){
            $.messager.confirm('提示','确定打号完毕并且入编吗？',function(b){
                               if (b){
                                    __doPostBack('GridView1$ctl02$Button3','');
                                }
            });
       });
        
    });
</script>
</head>

<body id = "cc" class="easyui-layout">
    <form id="form2" runat="server">
   <div id= "MContent" title = "入编" region="center">

    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
        BackColor="White" BorderColor="#3366CC" BorderStyle="None" BorderWidth="1px" 
        CellPadding="4" Width="622px" onrowdatabound="GridView1_RowDataBound" 
            onselectedindexchanged="GridView1_SelectedIndexChanged">
        <RowStyle BackColor="White" ForeColor="#003399" />
        <Columns>
            <asp:BoundField HeaderText="序号" />
            <asp:BoundField DataField="TaskID" HeaderText="任务编号" />
            <asp:BoundField DataField="TaskName" HeaderText="任务名称" />
            <asp:BoundField DataField="CorePerson" HeaderText="打号负责人" />
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:Button ID="Button2" runat="server" onclick="Button2_Click" Text="编号表下载" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:Button ID="Button3" runat="server" UseSubmitBehavior="false" Text="完成打号" onclick="Button3_Click" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <FooterStyle BackColor="#99CCCC" ForeColor="#003399" />
        <PagerStyle BackColor="#99CCCC" ForeColor="#003399" HorizontalAlign="Left" />
        <SelectedRowStyle BackColor="#009999" Font-Bold="True" ForeColor="#CCFF99" />
        <HeaderStyle BackColor="#003399" Font-Bold="True" ForeColor="#CCCCFF" />
    </asp:GridView>

    </div>

    </form>
    <p>
      
    </p>
</body>
</html>
