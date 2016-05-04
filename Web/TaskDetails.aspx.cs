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

public partial class TaskDetail : System.Web.UI.Page
{

    static String TaskID = "";
    static String TaskType = "";
    static String RecvCorpName = "";
    static String TaskState = "0";
    static String RecvUserName = "";
    static String RecvCorpID = "";

    
    public void WriteTaskProcess(String TaskID,String TaskType, String RecvCorpID)//转发任务函数，默认转发给科队的0和1组
    {
        String sTxt = "";

        DataTable dt = MyManager.GetDataSet("SELECT * FROM UserList WHERE CorpID IN (SELECT CorpID FROM Corps WHERE ParentID = (SELECT ParentID FROM Corps WHERE CorpID = " + RecvCorpID + "))");
        DataRow[] dr =dt.Select (" 1=1 ");

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
        
        RecvUserName = "";
        
        for (int i = 0; i < dr.Length; i++)
        {
            RecvUserName += " " + dr[i]["Name"].ToString();

            sTxt = "INSERT INTO TaskProcess(TaskID,SendUser,SendCorpID,RecvCorpID,RecvUser,State,Content,DateTime) VALUES ("
            + TaskID + ","
            + Session["UserID"].ToString() + ","
            + Session["CorpID"].ToString() + ","
            + RecvCorpID + ","
            + dr[i]["ID"].ToString() + ",1,'待领取','"+DateTime.Now.ToString()+"')";
            MyManager.ExecSQL(sTxt);
        }

    }
    public void FillTaskBlanks(String TaskID)
    {
        DataRow[] dr;
        DataTable dt = MyManager.GetDataSet("SELECT A.*,B.TypeName FROM Tasks as A Left Join  TaskTypes AS B on A.Type = B.TypeID where A.ID = " + TaskID);
        
        DataTable Corpsdt = MyManager.GetDataSet("SELECT * FROM Corps");

        DataTable UserListdt = MyManager.GetDataSet("SELECT * FROM UserList");

        dr = Corpsdt.Select(" CorpID = " + dt.Rows[0]["RecvCorpID"].ToString());
       
        RecvCorpName = dr[0]["CorpName"].ToString();
        RecvCorpID =   dr[0]["CorpID"].ToString();
        TaskState    = dt.Rows[0]["State"].ToString();
        TaskType = dt.Rows[0]["Type"].ToString();
        label1.Text = dt.Rows[0]["TaskCode"].ToString();
        Label2.Text = dt.Rows[0]["TypeName"].ToString();
        Label3.Text = dt.Rows[0]["Name"].ToString();
        Label4.Text = dt.Rows[0]["CreateTime"].ToString();
        Label18.Text = dt.Rows[0]["Memo"].ToString();
        dr = UserListdt.Select(" ID = " + dt.Rows[0]["CreateUser"].ToString());
        Label5.Text = dr[0]["Name"].ToString();

        dr = Corpsdt.Select("  CorpID = " + dt.Rows[0]["CreateCorpID"].ToString());
        Label14.Text = dr[0]["CorpName"].ToString();

        if (dt.Rows[0]["DealCorpID"].ToString() != "")
        {
            dr = Corpsdt.Select("  CorpID = " + dt.Rows[0]["DealCorpID"].ToString());
            Label13.Text = dr[0]["CorpName"].ToString();

            dr = UserListdt.Select(" [UserType] = 1  AND  CorpID = " + dt.Rows[0]["DealCorpID"].ToString());
            
            Label17.Text = dr[0]["Name"].ToString();

            dr = UserListdt.Select(" [UserType] = 2  AND CorpID = " + dt.Rows[0]["DealCorpID"].ToString());

            for (int i = 0; i < dr.Length; i++)
            {
                Label16.Text = Label16.Text + " " + dr[i]["Name"].ToString();
            }

        }
        else {
            Label13.Text = "待领导分配";
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {

        
        if (Request["TaskID"] == null) return;

        TaskID = Request["TaskID"].ToString();
        FillTaskBlanks(TaskID);
        if (TaskState != "0")
        {
            Button1.Visible = false;

        }
        if (TaskState != "1")
        {
            

            

        }
        else
        {
           // RecvLB.Visible = false;
          //  ImageButton1.Visible = false;
        }

        

       
        
       
    }
    protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
    {
        

     
    }
    protected void TabContainer1_ActiveTabChanged(object sender, EventArgs e)
    {
        if (TabContainer1.ActiveTab.ID == "TabPanel3")
        {
            Page.ClientScript.RegisterStartupScript(Page.GetType(), "message", "<script language='JavaScript'>Jump('" + MyManager.GetDealPage(Convert.ToInt32(TaskType), TaskID) + "','TaskDATA')</script>");
           
        }
        if (TabContainer1.ActiveTab.ID == "TabPanel6")
        {
            Page.ClientScript.RegisterStartupScript(Page.GetType(), "message", "<script language='JavaScript'>Jump('TaskComments.aspx?TaskID="+TaskID+"','TaskComments')</script>");

        }
        if (TabContainer1.ActiveTab.ID == "TabPanel4")
        {
            TaskLogGV.DataSource = MyManager.GetDataSet("SELECT * FROM TaskLog WHERE TaskID = " + TaskID + " ORDER BY DateTime ASC");
            TaskLogGV.DataBind();
        }
        if (TabContainer1.ActiveTab.ID == "TabPanel5")
        {
            TaskFlowGV.DataSource = MyManager.GetDataSet("SELECT A.* ,B.CorpName as fsbm,c.CorpName as jsbm,D.Name as fsz FROM TaskFlow as A left join  corps as B on A.SendCorp = B.CorpID left join corps AS C ON A.RecvCorp = C.CorpID left Join UserList as D On A.Senduser= D.ID where A.taskid =" + TaskID + " ORDER BY A.DateTime ASC");
            TaskFlowGV.DataBind();
        }
    }
    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void TaskLogGV_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType != DataControlRowType.Header)
        {
            e.Row.Cells[0].Text = (e.Row.RowIndex + 1).ToString();
        }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        if (TaskState != "0")
        {
            Button1.Visible = false;
        }
        WriteTaskProcess(TaskID, TaskType, RecvCorpID);
        MyManager.WriteTaskFlow(TaskID, Session["UserID"].ToString(), Session["CorpID"].ToString(), RecvCorpID, "任务创建", DateTime.Now.ToString());
        MyManager.ExecSQL("UPDATE Tasks Set State = 1 WHERE ID = " + TaskID);
        MyManager.ExecSQL("INSERT INTO TaskLog (TaskID,CreateUserName,CreateUserID,Title,Content,DateTime) Values ('"
          + TaskID + "','"
          + Session["Name"].ToString() + "',"
          + Session["UserID"].ToString() + ",'任务提交','接收部门:" + RecvCorpName + RecvUserName + "','" + DateTime.Now.ToString() + "')");

        TaskState = "1";//任务状态变成1，屏蔽提交任务按钮。
        Button1.Visible = false;
        Page.ClientScript.RegisterStartupScript(Page.GetType(), "message", "<script language='JavaScript'>$.alert.messager('提示','任务转发成功!');</script>");
    }
}
