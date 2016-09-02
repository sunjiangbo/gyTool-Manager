using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using Aspose;
using Aspose.Cells;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Generic;

public partial class LoadToolFromExcel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    public String JsonSafe(String theString)
    {
        theString = theString.Replace(">", "&gt;");
        theString = theString.Replace("<", "&lt;");
        theString = theString.Replace(" ", "&nbsp;");
        theString = theString.Replace("\"", "&quot;");
        theString = theString.Replace("\'", "&#39;");
        theString = theString.Replace("\\", "\\\\");//对斜线的转义  
        theString = theString.Replace("\n", "\\n");
        theString = theString.Replace("\r", "\\r");
        return theString;
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        String FullPath = "";
        int i=0;
        if (!FileUpload1.HasFile)
            Response.Write("请选择文件");
         HttpPostedFile file = Request.Files[0];
         if (!FileUpload1.FileName.ToUpper().EndsWith("XLS"))
         {
             Response.Write("请上传XLS文件");
             return;
         }
         FullPath = MapPath("\\ExcelUpload\\") + file.FileName;
         FileUpload1.SaveAs(FullPath);

         if (CID.Text.Trim() == "")
         {
             Response.Write("请输入类ID");
         }

         Aspose.Cells.Workbook workbook = new Aspose.Cells.Workbook(FullPath);
         Aspose.Cells.Worksheet sheet = workbook.Worksheets[0];
         Aspose.Cells.Cells cells = sheet.Cells;
         //Response.Write(cells[0, 100].StringValue.Trim());
      // return;
        //先看Excel表中属性是否超出数据库中属性列表,超出则添加
         DataTable dt = MyManager.GetDataSet("SELECT * FROM CLassPropertys WHERE ID=" + CID.Text + " OR ParentID= "+CID.Text);
         if (dt.Rows.Count == 0)
         {
             Response.Write("该类不存在!");
         }

        int ColCount = 2,curRow=0;

        int curCol=2;
        String PName,VID;
        Dictionary<int, int> ColDict = new Dictionary<int, int>();

        do
        {
            PName = cells[0, ColCount].StringValue.Trim();
            Response.Write(PName);
            if (PName != "")
            {
                DataRow[] dr = dt.Select(" Name='" + PName + "' ");
                if (dr.Length == 0)//该属性不存在
                {
                    DataRow dr1 = dt.NewRow();
                    dr1["Name"] = PName;
                    dt.Rows.Add(dr1);
                    VID = MyManager.GetFiledByInput("INSERT INTO CLassPropertys (Name,NodeType,ParentID,Necessary,pType) Values ('" + PName + "',3," + CID.Text +
                        ",0,1);SELECT IDENT_CURRENT('CLassPropertys') AS CurID", "CurID");
                    ColDict.Add(ColCount,Convert.ToInt32(VID));
                }else{//该属性存在
                    ColDict.Add(ColCount, Convert.ToInt32(dr[0]["ID"].ToString()));
                }
               
                ColCount++;
            }
            
        } while (PName != "");
        


        String ToolName = "", ToolID = "" ;
        int rkIDOV;//用户提供的入库编号已经存在  2:无预制序列号 1：重复 0：不重复
        String rkID = "",CoreID="";
        int rkIDCol = 9;
        for (curRow = 1; cells[curRow, 1].StringValue.Trim() != ""; curRow++)
        {
            ToolName = cells[curRow, 1].StringValue.Trim();

            rkID = cells[curRow, rkIDCol].StringValue.Trim();
            rkIDOV=2;
            if (rkID == "")
            {
                rkID = MyManager.GetNextFlowID();
            }
            else
            {
                rkIDOV = 0;
                if (MyManager.CheckSNExist(rkID))
                {
                    rkID = MyManager.GetNextFlowID();
                    rkIDOV = 1;
                }
            }
            ToolID = MyManager.GetNextID();
            CoreID = MyManager.GetFiledByInput("INSERT INTO CoreTool(EPC,rkID,ModelType,ModelID,ToolID,ToolName,[ModifyTime],State,[RelatedTask]) Values( '" + MyManager.GenerateEPC(ToolID) + "','"+rkID+"',0," + CID.Text + ",'"
                                                                        + ToolID + "','" + ToolName + "','" + DateTime.Now.ToString() + "',0,'Excel导入');SELECT IDENT_CURRENT('CoreTool') AS CurID", "CurID");
            cells[curRow, 0].PutValue(ToolID);
           
            for (curCol = 2; curCol < ColCount; curCol++)
            {
                String Val = cells[curRow, curCol].StringValue.Trim();
                if (Val != "")
                {//ColDict
                    Val = JsonSafe(Val);
                    MyManager.ExecSQL("INSERT INTO CoreToolValue(CoreID,State,PropertyID,Value,ValueType,ParentID) Values(" +CoreID+",-1,"+ColDict[curCol]+",'" +Val+"',0,"+CoreID+")");
                }
         
            }
            if (rkIDOV == 0 )
            {
                //
            }
            else if(rkIDOV == 1)
            {
                cells[curCol, rkIDCol].PutValue("新号为:" + rkID + ",原号重复!");
            }
            else if (rkIDOV == 2)
            {
                cells[curCol, rkIDCol].PutValue("新号:"+rkID);
            }
        }

 XlsSaveOptions saveOptions = new XlsSaveOptions();
 String ExcelName = DateTime.Now.Ticks + ".xls";
 String Path = Server.MapPath("~") + "\\Report\\" + ExcelName;
 workbook.Save(Path, saveOptions);
 String ExcelURL = "http://" + Request.Url.Host + ":" + Request.Url.Port + Request.ApplicationPath + "Report/" + ExcelName;
 Response.Write(ExcelURL);


    }
}
