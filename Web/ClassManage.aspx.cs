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

     public String JSON = "[]";
     public String CID = "";
     public static string Post(string url, string postContent) 
     {
            HttpWebRequest req = (HttpWebRequest)HttpWebRequest.Create(url);
           
            req.Method = "POST";
            
            if (!string.IsNullOrEmpty(postContent)) {
               using(StreamWriter sw = new StreamWriter(req.GetRequestStream(), Encoding.UTF8)){
                   sw.Write(postContent);
                   sw.Flush();
               }
            }

            using (HttpWebResponse res = (HttpWebResponse)req.GetResponse())
            {
                Stream response = res.GetResponseStream();
               
                using (StreamReader sr = new StreamReader(response))
                {
                    string content = sr.ReadToEnd();
                    return content;
                }
            }
        }


    protected void Page_Load(object sender, EventArgs e)
    {
        int ClassID = 0;

        if (Session["UserID"] == null)
        {
            Response.Redirect("Login.htm");
        }

        if (Request["ClassID"] == null)
        {
            Response.Write("failed");
            return;
        }
        try
        {
           
           ClassID = Convert.ToInt32(Request["ClassID"].ToString());
           CID = ClassID.ToString();
           JSON = Post( Request.Url.ToString().Substring(0, Request.Url.ToString().LastIndexOf('/') + 1) + "AJAX/Handler.ashx", "{\"cmd\":\"getClassTree\",\"classid\":\"" + ClassID + "\"}");
          //Response.Write("</br>" + JSON);
        } 
        catch (Exception ee)
        {
          // Response.Write(ee.ToString());
        }


    }
}