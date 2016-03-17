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

public partial class CorpsSelect : System.Web.UI.Page
{
    static String TaskID = "", RecvUserName = "";

    public void FlowTask(String TaskID, String RecvCorpID)//转发任务函数，默认转发给科队的0和1组
    {
        String sTxt = "";

        DataTable dt = MyManager.GetDataSet("SELECT * FROM UserList WHERE UserType <>2 AND CorpID IN (SELECT CorpID FROM Corps WHERE ParentID = (SELECT ParentID FROM Corps WHERE CorpID = " + RecvCorpID + "))");
        DataRow[] dr = dt.Select(" 1=1 ");


        RecvUserName = "";

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
    Boolean VerifyTask(String TaskID)//审核权限是否为0组 且任务当前部门和本部门一致
    {
        if (Session["UserType"].ToString() != "0") return false;  //非0组，无转出权限 

        if (Session["CorpID"].ToString() != MyManager.GetFiledByInput("SELECT ParentID FROM Corps WHERE CorpID =  (SELECT RecvCorpID From Tasks WHERE ID = " + TaskID + ")", "ParentID")) return false;

        return true;
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["TaskID"] == null || IsPostBack || Session["UserID"]==null)
        {
            return;
        }
        TaskID = Request["TaskID"].ToString();
        if (false == VerifyTask(TaskID)) {
            TextBox1.Enabled = false;
            DropDownList1.Enabled = false;
            Button1.Visible  = false;
            lb.Text = "无权限转出!请关闭窗口!";
            return; 
        }
        
        MyManager.FillList(DropDownList1, "SELECT CorpName,CorpID From Corps Where CorpType = 1 ", "CorpName", "CorpID", true);
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
       
        if (false == VerifyTask(TaskID))
        {
            Button1.Visible = false;
            lb.Text = "无权限转出!请关闭窗口!";
            return;
        }
        
        if (DropDownList1.Text == "") return;
       
      
        String RecvCorpID = DropDownList1.SelectedItem.Value;
        MyManager.ExecSQL("DELETE FROM TaskProcess WHERE TaskID=" + TaskID + " AND RecvCorpID IN (SELECT CorpID FROM Corps WHERE ParentID = " + Session["CorpParentID"].ToString() + ") ");
       FlowTask(TaskID, RecvCorpID);
       MyManager.WriteTaskFlow(TaskID, Session["UserID"].ToString(), Session["CorpID"].ToString(), RecvCorpID, TextBox1.Text, DateTime.Now.ToString());
       MyManager.ExecSQL("UPDATE Tasks Set Memo='" + TextBox1.Text + "',State = 1,SendCorpID=" + Session["CorpParentID"].ToString() + ",RecvCorpID=" + RecvCorpID + " WHERE ID = " + TaskID);
       MyManager.ExecSQL("INSERT INTO TaskLog (TaskID,CreateUserName,CreateUserID,Title,Content,DateTime) Values ('"
           + TaskID + "','"
           + Session["Name"].ToString() + "',"
           + Session["UserID"].ToString() + ",'任务转发','接收部门:" + DropDownList1.SelectedItem.Text  + RecvUserName + "','" + DateTime.Now.ToString() + "')");
       lb.Text = "任务已转发至->"+ DropDownList1.SelectedItem.Text + "!";
       Label1.Visible = false;
       Label2.Visible = false;
       TextBox1.Visible = false;
       DropDownList1.Visible = false;
       Button1.Visible = false;
        //Page.ClientScript.RegisterStartupScript(Page.GetType(), "message", "<script language='JavaScript'>art.dialog({ id: 'dg_test34243' }).close();</script>");
      
        // Page.ClientScript.RegisterStartupScript(Page.GetType(), "message", "<script language='JavaScript'>tDialog();</script>");
    }
}
