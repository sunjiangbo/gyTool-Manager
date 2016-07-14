using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
public partial class Query : System.Web.UI.Page
{
    public String TaskID;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserID"] == null)
        {
            Response.Redirect("Login.htm");
        }
        if (Request["TaskID"] != null)
        {
            TaskID = Request["TaskID"].ToString();
        }
        else
        {
            Response.Write("非法访问!");
            Response.End();
        }
        DataTable dt = MyManager.GetDataSet("SELECT * FROM Tasks WHERE ID=" + TaskID);
        if (dt.Rows.Count == 0)
        {
            Response.Write("任务不存在!");
            Response.End();
        }
        if (dt.Rows[0]["State"].ToString() == "1")
        {
            Response.Redirect("Borrow.aspx?TaskID=" + TaskID + "&reBack=");
        }
    }
}
