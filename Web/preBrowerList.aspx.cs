using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class preBrowerList : System.Web.UI.Page
{
    public String TaskID = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserID"] == null)
        {
            Response.Redirect("Login.htm");
        }
        //if (Request["TaskID"] == null || Session["UserID"] == null) { Response.Write("非法访问!"); Response.End(); return; }
        TaskID = Request["TaskID"].ToString();
    }
}