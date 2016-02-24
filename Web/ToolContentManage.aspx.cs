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
public partial class ClassManage : System.Web.UI.Page
{
    public String Type = "";
    public String BagID = "";
    public String BagName= "";
    public String ToolID = "";
    public String ClassID = "";
    public String ToolName = "";
     protected void Page_Load(object sender, EventArgs e)
     {
         if (Request["Type"] ==null)
         {
             Type = "";
         }
         else
         {
             Type= Request["Type"].ToString();
         }
         if (Request["BagID"]   != null) { BagID   = Request["BagID"].ToString(); }
         if (Request["BagName"] != null) { BagName = Request["BagName"].ToString(); }
         if (Request["ToolID"] != null) { ToolID = Request["ToolID"].ToString(); }
         if (Request["ClassID"] != null) { ClassID = Request["ClassID"].ToString(); }
         if (Request["ToolName"] != null) { ToolName = Request["ToolName"].ToString(); }
                 try
                 {
                    
                 }
                 catch (Exception ee)
                 {

                 }


             
   }
}
