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
    static public String newURL = "", TaskID = "";
    static public String TaskType = "1",RecvCorpID = "";
    static public String RecvUserName = "";
    protected void MyFillListByUserType(String TaskType, String UserType)
    {
       
    }


    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserID"] == null)
        {
            Response.Redirect("Login.htm");
        }
        if (IsPostBack) return;
        TextBox1.Text = Session["Name"].ToString().Trim() + "  " + string.Format("{0:MM-dd HH:mm}", DateTime.Now);
        TaskCode = "GJ-" + string.Format("{0:yyMMddHHmmss}", DateTime.Now);
        Label1.Text = TaskCode;
       // MyManager.FillList(DropDownList1, "SELECT TypeName,(Convert(varchar(4),TypeID) + '|' + TypeCode) AS Value FROM [TaskTypes]", "TypeName", "Value", true);
        Button4.Enabled = false;
        newURL = "";
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        Response.Redirect("ToolApp.aspx");
    }
    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
       
        

    }
    protected void Button3_Click(object sender, EventArgs e)
    {
 
  
             

        if (TextBox1.Text == "" || !MyManager.FuckSQLInject(TextBox1.Text))
        {
            Label2.Text = "请输入任务名称,并不可带有非法字符。";
            return;
        }

      

        if (Session["CorpID"] == null || Session["UserID"] == null)
        {
            Label2.Text = "会话状态读取失败，请重新登陆!";
            return;
        }

        RecvCorpID = "15";

        

        TaskID = MyManager.CreateTask("1", TextBox1.Text, TaskCode, Session["UserID"].ToString(), Session["CorpID"].ToString(), RecvCorpID,"");

        

        MyManager.ExecSQL("INSERT INTO TaskLog (TaskID,CreateUserName,CreateUserID,Title,Content,DateTime) Values ('"
            + TaskID+ "','"
            + Session["Name"].ToString() + "',"
            + Session["UserID"].ToString() + ",'创建任务','创建任务','" +DateTime.Now.ToString() + "')");

        newURL = "ToolApp.aspx?TaskID=" + TaskID;

        Button3.Enabled = false;
        Button4.Enabled = true;

        //Response.Redirect("TaskDetails.aspx?TaskID="+TaskID);

        
    }
    public void WriteTaskProcess(String TaskID, String TaskType, String RecvCorpID)//转发任务函数，默认转发给科队的0和1组
    {
        String sTxt = "";

        DataTable dt = MyManager.GetDataSet("SELECT * FROM UserList WHERE CorpID IN (SELECT CorpID FROM Corps WHERE ParentID = (SELECT ParentID FROM Corps WHERE CorpID = " + RecvCorpID + "))");
        DataRow[] dr = dt.Select(" 1=1 ");

        if (TaskType != "1")//如果是借工具则，发给工具房所有人。
        {

            if (Session["UserType"].ToString() == "0")//科队领导创建任务，发给当前部门的0组
            {
                dr = dt.Select("  UserType <> 2 ");

            }
            else if (Session["UserType"].ToString() == "1") //小组长创建任务，只发给转发部门0组
            {
                dr = dt.Select("  UserType = 0  ");
            }
            else
            {
                dr = dt.Select(" [UserType] = 1  AND CorpID = " + Session["CorpID"].ToString());
            }
        }

       

        for (int i = 0; i < dr.Length; i++)
        {
            RecvUserName += " " + dr[i]["Name"].ToString();

            sTxt = "INSERT INTO TaskProcess(TaskID,SendUser,SendCorpID,RecvCorpID,RecvUser,State,Content,DateTime) VALUES ("
            + TaskID + ","
            + Session["UserID"].ToString() + ","
            + Session["CorpID"].ToString() + ","
            + RecvCorpID + ","
            + dr[i]["ID"].ToString() + ",1,'待领取','" + DateTime.Now.ToString() + "')";
            MyManager.ExecSQL(sTxt);
        }

    }
    protected void Button4_Click(object sender, EventArgs e)
    {
        WriteTaskProcess(TaskID, TaskType, RecvCorpID);
        MyManager.WriteTaskFlow(TaskID, Session["UserID"].ToString(), Session["CorpID"].ToString(), RecvCorpID, "任务创建", DateTime.Now.ToString());
        MyManager.ExecSQL("UPDATE Tasks Set State = 1 WHERE ID = " + TaskID);
        MyManager.ExecSQL("INSERT INTO TaskLog (TaskID,CreateUserName,CreateUserID,Title,Content,DateTime) Values ('"
          + TaskID + "','"
          + Session["Name"].ToString() + "',"
          + Session["UserID"].ToString() + ",'任务提交','接收部门:工具房 " + RecvUserName + "','" + DateTime.Now.ToString() + "')");

        
        Button4.Enabled = false;
        Label2.Text = "任务已经提交到工具房，直接去那领吧!";
        //Response.Redirect("CreateTask1.aspx");
        newURL = "";
    }
}
