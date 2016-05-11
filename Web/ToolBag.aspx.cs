
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
using System.Net;
public partial class ToolBag : System.Web.UI.Page
{

     public String JSON = "[]";
     public String gID = "";
     public String Type = "";
     public String WorkType = "0";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserID"] == null)
        {
            Response.Redirect("Login.htm");
        }
        if (Request["BagID"] == null)
        {
            Response.Write("请求参数不全!!");
            return;
        }
        if (Request["Type"] == null)
        {
            Response.Write("请求参数不全!!");
            return;
        }
       if (Request["WorkType"] != null)
        {
            WorkType = Request["WorkType"].ToString();
        }
        Type = Request["Type"].ToString();
        gID = Request["BagID"].ToString();
        /*
        try
        {

            BagID = Convert.ToInt32(Request["BagID"].ToString());
            Type  = Convert.ToInt32(Request["Type"].ToString());
            gID = BagID.ToString();
            JSON = MyManager.Post(Request.Url.ToString().Substring(0, Request.Url.ToString().LastIndexOf('/') + 1) + "AJAX/Handler.ashx", "{\"cmd\":\"getToolBagModel\",\"bagid\":\"" + BagID + "\",\"type\":\"" + Type + "\"}");
         
        } 
        catch (Exception ee)
        {
          // Response.Write(ee.ToString());
        }
        */

    }
}