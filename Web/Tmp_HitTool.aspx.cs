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

        if (Request["TaskID"] == null || Session["UserID"]==null) { Response.Write("非法访问!"); Response.End(); return; }

        if (Request["reBack"] != null) { reBack = Request["reBack"].ToString(); }
        
        TaskID = Request["TaskID"].ToString();

      
     
    }
}