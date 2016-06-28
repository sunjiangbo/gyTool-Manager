using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Web;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using Newtonsoft.Json;

using Newtonsoft.Json.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Runtime.Serialization;

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        String txtUserName = "", txtPassword = "", json = "{}";


        StringWriter sw = new StringWriter();
        JsonWriter jWrite = new JsonTextWriter(sw);

        StreamReader reader = new StreamReader(Request.InputStream);

        json = reader.ReadToEnd();

        try
        {
            JObject JO = JObject.Parse(json);

            txtUserName = "{"+JO["username"].ToString()+"}";

            txtPassword = "{"+JO["pwd"].ToString()+"}";

            /*Response.Write("dat:" +json+"\n");
             Response.Write("parse:" + txtUserName + txtPassword + "\n");
             Response.Write("response:");*/
            if (txtUserName == "" || txtPassword == "")
            {
                json = "{\"status\":\"failed\",\"Msg\":\"请输入用户名和密码!\"}";
                Response.Write(json);
                return;
            }
            DataTable dt = new DataTable();
            SqlConnection myConn = new SqlConnection(System.Configuration.ConfigurationSettings.AppSettings["ConnStr"]);
            //Response.Write("h1\n");
            SqlCommand cmd = new SqlCommand("SELECT UserList.*, Corps.CorpName,Corps.CorpType,Corps.ParentID FROM UserList left join Corps on UserList.CorpID = Corps.CorpID Where UserName = @UserName AND Pwd = @Pwd", myConn);
            cmd.Parameters.AddWithValue("@Username", txtUserName);
            cmd.Parameters.AddWithValue("@Pwd", txtPassword);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            //DataTable dt = MyManager.GetDataSet("SELECT UserList.*, Corps.CorpName,Corps.CorpType,Corps.ParentID FROM UserList left join Corps on UserList.CorpID = Corps.CorpID Where UserName = '" + txtUserName + "' And Pwd = '" + /*System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(txtPassword, "MD5").ToUpper()*/ + "'");

            //  Response.Write("h2\n");
            if (dt.Rows.Count ==0)
            {
                json = "{\"status\":\"failed\",\"Msg\":\"密码错误!\"}";
                Response.Write(json);
            }
            //  Response.Write("h3\n")


            Session["UserID"] = dt.Rows[0]["ID"];
            Session["Name"] = dt.Rows[0]["Name"];
            Session["LoginTime"] = DateTime.Now.ToString("HH:mm:ss");
            Session["UserType"] = dt.Rows[0]["UserType"];
            Session["CorpName"] = dt.Rows[0]["CorpName"];
            Session["CorpID"] = dt.Rows[0]["CorpID"];
            Session["CorpType"] = dt.Rows[0]["CorpType"];
            Session["CorpParentID"] = dt.Rows[0]["ParentID"];
            json = "{\"status\":\"success\",\"url\":\"Main.aspx\"}";
            Response.Write(json);
        }
        catch (Exception ee)
        {
            json = "{\"status\":\"failed\",\"Msg\":\"" + ee.ToString() + "\"}";
        }
        //Response.Redirect("RealMain.aspx");
    }
}