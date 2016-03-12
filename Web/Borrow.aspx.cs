using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Borrow : System.Web.UI.Page
{
    public String TaskID = "", Type = "0", reBack = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        int Count = 0;

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

        Count = MyManager.SELCount("SELECT Count(ID) AS ct FROM Tasks Where ID = " + TaskID + " AND CreateUser = " + Session["UserID"].ToString(), "ct");

        if (Count > 0)
        {
            Type = "1";//借用者在提交申请
            return;
        }

        if (Type == "0") { Response.Write("非法访问!"); Response.End(); return; }
    }
}