using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class BorrowHistory : System.Web.UI.Page
{
    public String toolid = "";
    public String toolname = "";
    public String borrowername = "";
    public String borrowstime = ""; 
    public String borrowetime = "";
    public String refundername = "";
    public String refundstime = "";
    public String refundetime = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        //if (Request["TaskID"] == null || Session["UserID"] == null) { Response.Write("非法访问!"); Response.End(); return; }

        toolid = Request["toolid"] == null ? "" : Request["toolid"].ToString();
        toolname = Request["toolname"] == null ? "" : Request["toolname"].ToString();
        borrowername = Request["borrowername"] == null ? "" : Request["borrowername"].ToString();
        borrowstime = Request["borrowstime"] == null ? "" : Request["borrowstime"].ToString();
        borrowetime = Request["borrowetime"] == null ? "" : Request["borrowetime"].ToString();
        refundername = Request["refundername"] == null ? "" : Request["refundername"].ToString();
        refundstime = Request["refundstime"] == null ? "" : Request["refundstime"].ToString();
        refundetime = Request["refundetime"] == null ? "" : Request["refundetime"].ToString();
    }
}