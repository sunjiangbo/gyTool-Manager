using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.OleDb;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Configuration;
using System.Linq;
using System.Web.Security;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;


public partial class CreateTask : System.Web.UI.Page
{
    static String TaskCode = "";
    
    protected void MyFillListByUserType(String TaskType, String UserType)
    {
        if (TaskType == "1")
        {
            MyManager.FillList(DropDownList2, "SELECT CorpName,CorpID From Corps Where CorpName='工具房' ", "CorpName", "CorpID", true);
            return;
        }
        if (UserType == "0")
        {
            MyManager.FillList(DropDownList2, "SELECT CorpName,CorpID From Corps Where CorpType = 1 ", "CorpName", "CorpID", true);
        }
        else if (UserType == "1")//小组长
        {
            MyManager.FillList(DropDownList2, "SELECT CorpName,CorpID From Corps Where CorpType =1 AND  ParentID =" + Session["CorpParentID"].ToString(), "CorpName", "CorpID", true);
        }
        else
        {
            MyManager.FillList(DropDownList2, "SELECT CorpName,CorpID From Corps Where CorpID = " + Session["CorpID"].ToString(), "CorpName", "CorpID", true);
        }
    }


    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack) return;
        

        MyManager.FillList(DropDownList1, "SELECT TypeName,(Convert(varchar(4),TypeID) + '|' + TypeCode) AS Value FROM [TaskTypes]", "TypeName", "Value", true);
      
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        Response.Redirect("ToolApp.aspx");
    }
    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (DropDownList1.Text == "")
        {
            TaskCode = "";
            Label1.Text = "";
            return;
        }
        String[] Arr = DropDownList1.SelectedItem.Value.Split('|');  //获取任务TypeID 和 TypeCode

        TaskCode = Arr[1] + string.Format("{0:yyMMddHHmmss}", DateTime.Now);
        MyFillListByUserType(Arr[0], Session["UserType"].ToString());
        Label1.Text = TaskCode;

    }
    protected void Button3_Click(object sender, EventArgs e)
    {
 
        String TaskID = "",RecvCorpID = "";

        if (DropDownList1.Text == "")
        {
            Label2.Text = "未选择任务类型!";
            return;
        }

        if (TextBox1.Text == "" || !MyManager.FuckSQLInject(TextBox1.Text))
        {
            Label2.Text = "请输入任务名称,并不可带有非法字符。";
            return;
        }

        if (DropDownList2.Text == "")
        {
            Label2.Text = "未选择任务接受部门!";
            return;
        }

        if (Session["CorpID"] == null || Session["UserID"] == null)
        {
            Label2.Text = "会话状态读取失败，请重新登陆!";
            return;
        }

        RecvCorpID = DropDownList2.SelectedItem.Value;

        String[] Arr = DropDownList1.SelectedItem.Value.Split('|');

        TaskID = MyManager.CreateTask(Arr[0], TextBox1.Text, TaskCode, Session["UserID"].ToString(), Session["CorpID"].ToString(), DropDownList2.SelectedItem.Value,TextBox2.Text);

       

        MyManager.ExecSQL("INSERT INTO TaskLog (TaskID,CreateUserName,CreateUserID,Title,Content,DateTime) Values ('"
            + TaskID+ "','"
            + Session["Name"].ToString() + "',"
            + Session["UserID"].ToString() + ",'创建任务','创建任务','" +DateTime.Now.ToString() + "')");



        TaskCode = "";
        Label1.Text = "";
        TextBox1.Text = "";
        DropDownList1.Text = DropDownList2.Text = "";

        Response.Redirect("TaskDetails.aspx?TaskID="+TaskID);

        
    }
}
