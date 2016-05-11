using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    static String TaskID = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserID"] == null)
        {
            Response.Redirect("Login.htm");
        }
        if (Request["TaskID"] == null) return;

        TaskID = Request["TaskID"].ToString();
    }
   
    protected void Button2_Click1(object sender, EventArgs e)
    {
        String Content = Server.HtmlEncode(Request.Form["content1"].ToString());

        if (TextBox1.Text == "")
        {
            Page.ClientScript.RegisterStartupScript(Page.GetType(), "message", "<script language='JavaScript'>showDlg('还没有输入标题呢。。');</script>");
            return;
        }

        if (MyManager.ExecSQL("INSERT INTO TaskComments ([TargetID],[TaskID],[UserID] ,[Type] ,[Title],[Content] ,[DateTime]) Values ('"
                            + "0','"
                            + TaskID + "','"
                            + Session["UserID"].ToString() + "','1','"
                            + TextBox1.Text + "','"
                            + Content.Replace("'", "&apos;") + "','"
                            + DateTime.Now.ToString() + "')") == 1)
        {

           
//            Page.ClientScript.RegisterStartupScript(Page.GetType(), "message", "<script language='JavaScript'>CloseArtDialog();</script>");
            Page.ClientScript.RegisterStartupScript(Page.GetType(), "message", "<script language='JavaScript'>CloseMeOnshowDlg('发布成功!');</script>");
        }
        else {
            Page.ClientScript.RegisterStartupScript(Page.GetType(), "message", "<script language='JavaScript'>showDlg('发布失败!');</script>");

        }
            
                            
    }
    protected void Button1_Click(object sender, EventArgs e)
    {

    }
}
