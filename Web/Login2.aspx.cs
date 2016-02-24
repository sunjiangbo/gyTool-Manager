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


public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnLogin_Click(object sender, ImageClickEventArgs e)
    {


        if (txtUserName.Text== "" || txtPassword.Text == "")
        {
            ClientScript.RegisterStartupScript(GetType(), "message", "<script>alert('输入信息完整!');</script>");
            return;
        }


        DataTable dt = MyManager.GetDataSet("SELECT UserList.*, Corps.CorpName,Corps.CorpType,Corps.ParentID FROM UserList left join Corps on UserList.CorpID = Corps.CorpID Where UserName = '" + txtUserName.Text + "' And Pwd = '" + System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(txtPassword.Text, "MD5").ToUpper() + "'");


        if (dt.Rows.Count == 0 )
        {
            ClientScript.RegisterStartupScript(GetType(), "message", "<script>alert('认证失败！');</script>");
            return;
        }

        Session["UserID"] = dt.Rows[0]["ID"];
        Session["Name"] = dt.Rows[0]["Name"];
        Session["LoginTime"] = DateTime.Now.ToString("HH:mm:ss");
        Session["UserType"] = dt.Rows[0]["UserType"];
        Session["CorpName"] = dt.Rows[0]["CorpName"];
        Session["CorpID"] = dt.Rows[0]["CorpID"];
        Session["CorpType"] = dt.Rows[0]["CorpType"];
        Session["CorpParentID"] = dt.Rows[0]["ParentID"];
        Response.Redirect("Main.aspx");
    }
    protected void btnExit_Click(object sender, ImageClickEventArgs e)
    {

    }
}
