using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
public partial class Borrow : System.Web.UI.Page
{
    public String TaskID = "", Type = "0", reBack = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        int Count = 0;

        if (Session["UserID"] == null)
        {
            Response.Redirect("Login.htm");
        }
        //if (Request["TaskID"] == null || Session["UserID"]==null) { Response.Write("非法访问!"); Response.End(); return; }

        if (Request["reBack"] != null) { reBack = Request["reBack"].ToString(); }
        
        TaskID = Request["TaskID"].ToString();

        //开始判断当前状态  1：借用者在提交申请 2：管理者在处理申请 (借出或者归还)
        //看Taskprocess中是否有该任务，有的话证明提交过 否则看工具申请任务创建者是否为本人 。
        
        Count = MyManager.SELCount("SELECT Count(ID) AS ct FROM TaskProcess Where State = 2 AND TaskID = " +TaskID+ " AND RecvUser = " + Session["UserID"].ToString(),"ct");
        if (Count > 0) {
            Type = "2"; //管理者在处理申请 (借出或者归还)
            return;
        }

        DataTable dt = MyManager.GetDataSet("SELECT * FROM Tasks Where ID = " + TaskID);

        if (dt.Rows[0]["State"].ToString() == "10")
        {
            Type = "10";//任务已经关闭;
            return;
        }
       

        if (dt.Rows[0]["CreateUser"].ToString() == Session["UserID"].ToString())
        {
            Type = "1";//借用者在提交申请
            return;
        }
 

        if (Type == "0") { Response.Write("任务目前未被分配和领取，无法操作数据，请领取任务或者待领导分配任务后，再访问本页面 ！"); Response.End(); return; }
    }
}