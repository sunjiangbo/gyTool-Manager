
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
using Aspose;
using Aspose.Cells;
public partial class HitTool : System.Web.UI.Page
{
    public int BagID;
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Request["BagID"] != null)
            {
                BagID = Convert.ToInt32(Request["BagID"].ToString());
            }
        }
        catch (Exception ee)
        {
            Response.Write("请求参数错误!");
        }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        Aspose.Cells.Workbook workbook = new Aspose.Cells.Workbook(Server.MapPath("./") + "Template\\mb.xls");
        Aspose.Cells.Worksheet sheet = workbook.Worksheets[0];
        Aspose.Cells.Cells cells = sheet.Cells;
        cells[4, 1].PutValue("50H工具箱") ;
        XlsSaveOptions saveOptions = new XlsSaveOptions();
        workbook.Save(Response, "result.xls", ContentDisposition.Inline, saveOptions);
    }
}
