using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
public partial class AJAX_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        DataSet ds=new DataSet();
        SqlConnection myConn = new SqlConnection(System.Configuration.ConfigurationSettings.AppSettings["ConnStr"]);
        myConn.Open();
        if (myConn.State == System.Data.ConnectionState.Open)
        {
            SqlDataAdapter da = new SqlDataAdapter("Select * from ToolApp", myConn);
            da.Fill(dt);
            myConn.Close();

           
            SqlCommandBuilder cmd = new SqlCommandBuilder(da);
            dt.Rows[0]["TaskID"] = 456;
            da.Update(dt);

        }

        
    }
}