<%@ WebHandler Language="C#" Class="ExcelHandler" %>

using System;
using System.Web;
using System.IO;
using System.Text;

public class ExcelHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        string fn = DateTime.Now.ToString("yyyyMMddHHmmssfff") + ".xls";
        string data = context.Request.Form["data"];
        File.WriteAllText(context.Server.MapPath(fn), data, Encoding.UTF8);//如果是gb2312的xml申明，第三个编码参数修改为Encoding.GetEncoding(936)

    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}