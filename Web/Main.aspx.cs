using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Main : System.Web.UI.Page
{
    public String Corp = "";
    public String IsManager = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserID"] == null)
        {
            Response.Redirect("Login.htm");
        }
        Corp = Session["CorpID"].ToString();
        if (Corp == "15" || Corp == "22" || Corp == "21")
        {
            IsManager = "1";
        }
    }
}