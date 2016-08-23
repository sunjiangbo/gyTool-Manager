using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web;
using System.Data.SqlClient;
public partial class Query : System.Web.UI.Page
{
    public String Corp = "";
    public String IsManager = "0",curCheckCode = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        int i = 0;
        if (Session["UserID"] == null)
        {
            Response.Redirect("Login.htm");
        }
        Corp = Session["CorpID"].ToString();
        if (Corp == "15" || Corp == "22" || Corp == "21")
        {
            IsManager = "1";
        }

        DataTable dt = MyManager.GetDataSet("SELECT CheckList.CheckCode  FROM CoreTool,CheckList WHERE CoreTool.CheckCode= CheckList.CheckCode AND UserID = '" + Session["UserID"].ToString() + "' AND CoreTool.CheckStatus <> '0'");

        if (dt.Rows.Count >= 1)
        {
            for (i = 0; i < dt.Rows.Count - 1; i++)
            {
                MyManager.ExecSQL("UPDATE CoreTool SET CheckStatus = '0' WHERE CheckCode='" + dt.Rows[i]["CheckCode"].ToString() + "'");
            }
            curCheckCode = dt.Rows[i]["CheckCode"].ToString();
            Response.Write(curCheckCode);
        }
        else {
            Response.Write("木有");
        }
        

    }
}
