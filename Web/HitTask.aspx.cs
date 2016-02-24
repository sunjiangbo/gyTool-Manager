using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.OleDb;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Configuration;
using System.Web.Security;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls.WebParts;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Runtime.Serialization;
using System.Net;
using System.IO;
using System.Text;
using Aspose;
using Aspose.Cells;
public partial class HitTask : System.Web.UI.Page
{
    public String TaskID = "";
    public void CreateReport(String HitTaskID)
    {
        int i,j,k,iCount = 1,t ;
        String Type,Note = "",mTableName,subTableName,zdName,State,pxzd,ToolName;/*批注*/
        DataRow[] dr,dr1;
        DataTable dt2;
        dt2  = MyManager.GetDataSet("SELECT * From [HitTool] Where State = 1 AND TaskID = '" + HitTaskID + "'");
        if (dt2.Rows.Count == 0) { return; }
        Type = dt2.Rows[0]["Type"].ToString();

        if (Type == "1")
        { mTableName = "StoredTool"; subTableName = "StoredToolValue"; zdName = "StoredID"; State = "4"; pxzd = "rkID";ToolName= "StoredName"; }
        else
        { mTableName = "CoreTool"; subTableName = "CoreToolValue"; zdName = "CoreID"; State = "1"; pxzd = "ToolID"; ToolName= "ToolName"; }

        Aspose.Cells.Workbook workbook = new Aspose.Cells.Workbook(Server.MapPath("./") + "Template\\mb.xls");
        Aspose.Cells.Worksheet sheet = workbook.Worksheets["独立工具"]; //指向独立工具表
        Aspose.Cells.Cells cells = sheet.Cells;
        
        DataTable dt = MyManager.GetDataSet("SELECT *,ID as StoredID FROM "+mTableName+" where [State] = "+State+" AND [RelatedTask] = '" + HitTaskID + "' ORDER BY "+pxzd+" ASC");
        //先处理独立工具
        DataRow[] tdr = dt.Select("ModelType = 0");
        for (i = 0; i < tdr.Length; i++)
        {
            DataTable tdt = MyManager.GetDataSet("SELECT A.*,B.Name FROM " + subTableName + " AS A join [CLassPropertys] AS B on A.PropertyID = B.ID  WHERE " + zdName + "=" + tdr[i]["ID"].ToString());
            cells[1 + i, 0].PutValue(i + 1);
            cells[1 + i, 1].PutValue(tdr[i][ToolName].ToString());
            for (j = 0,Note=""; j < tdt.Rows.Count; j++)
            {
                Note += tdt.Rows[j]["Name"].ToString().Trim() + ":" + tdt.Rows[j]["Value"].ToString().Trim() + "\n\r";
            }
            sheet.Comments.Add(1 + i, 1);
            sheet.Comments[1 + i, 1].Note = Note;
           
            cells[1 + i, 2].PutValue(tdr[i]["rkID"].ToString());
            if (Type == "2") {
                cells[1 + i, 3].PutValue(tdr[i]["ToolID"].ToString());    
            }
        }
        tdr = dt.Select("ModelType = 1");
        if (tdr.Length >= 0)
        {
            for (i = 0, iCount = 1; i < dt.Rows.Count; i++)
            {

                DataTable dt1 = MyManager.GetDataSet("SELECT A.*,B.Name FROM " + subTableName + " AS A join [CLassPropertys] AS B on A.PropertyID = B.ID Where " + zdName + " = '" + dt.Rows[i]["ID"].ToString() + "'" + " ORDER BY " + pxzd + " ASC");
                sheet = workbook.Worksheets[workbook.Worksheets.AddCopy("Bak")];
                cells = sheet.Cells;
                dr = dt1.Select("ValueType = 3 ");
                for (j = 0; j < dr.Length; j++)
                {

                    t = j % 44;//t始终在0-51内变化
                    if (t == 0 && j != 0)/*证明本页已经填完，需要加页*/
                    {
                        sheet = workbook.Worksheets[workbook.Worksheets.AddCopy("Bak")];
                        cells = sheet.Cells;
                    }
                    if (j % 22 == 0)/*页内或者页间表格切换*/
                    {
                        cells[2, (t / 22) * 6].PutValue("      工具箱序号:" + dt.Rows[i]["rkID"].ToString() + (Type == "2" ? "   编号:" + dt.Rows[i]["ToolID"].ToString() : "") + "   名称:" + dt.Rows[i][Type == "1" ? "StoredName" : "ToolName"].ToString());
                        //------------------增加批注-----------------------

                        dr1 = dt1.Select("ValueType = 2 AND ParentID = " + dt.Rows[i]["ID"].ToString());
                        for (k = 0, Note = ""; k < dr1.Length; k++)
                        {
                            Note += dr1[k]["Name"].ToString().Trim() + ":" + dr1[k]["Value"].ToString() + "\n\r";
                        }
                        sheet.Comments.Add(2, (t / 22) * 6);
                        sheet.Comments[2, (t / 22) * 6].Note = Note;
                        //------------------------------------------------
                    }

                    cells[4 + t % 22, (t / 22) * 6].PutValue(j + 1);
                    cells[4 + t % 22, (t / 22) * 6 + 1].PutValue(dr[j]["Value"].ToString());
                    cells[4 + t % 22, (t / 22) * 6 + 2].PutValue(dr[j]["rkID"].ToString());
                    if (Type == "2")
                    {
                        cells[4 + t % 22, (t / 22) * 6 + 3].PutValue(dr[j]["ToolID"].ToString());
                    }
                    //------------------增加批注-----------------------
                    dr1 = dt1.Select("ValueType = 4 AND ParentID = " + dr[j]["ID"].ToString());
                    for (k = 0, Note = ""; k < dr1.Length; k++)
                    {
                        Note += dr1[k]["Name"].ToString().Trim() + ":" + dr1[k]["Value"].ToString() + "\n\r";
                    }
                    sheet.Comments.Add(4 + t % 22, (t / 22) * 6 + 1);
                    sheet.Comments[4 + t % 22, (t / 22) * 6 + 1].Note = Note;
                    //------------------------------------------------

                    iCount++;

                }

            }
        }
        workbook.Worksheets.RemoveAt("Bak");
        XlsSaveOptions saveOptions = new XlsSaveOptions();
        workbook.Save(Response, "工具清单.xls", ContentDisposition.Inline, saveOptions);
       
    }
    protected void GV1Bind()
    {
        GridView1.DataSource = MyManager.GetDataSet("SELECT * FROM HitTool Where State = 1 ");
        GridView1.DataBind();
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["TaskID"] != null) { TaskID = Request["TaskID"].ToString();  }
       if (IsPostBack) return;
       GV1Bind();
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
    }
    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header) return;

        Button bhBtn = (Button)e.Row.FindControl("Button2");
        Button OkBtn = (Button)e.Row.FindControl("Button3"); 
       if (bhBtn != null) bhBtn.CommandArgument = e.Row.Cells[1].Text;
       if (OkBtn != null)
       {
           OkBtn.CommandArgument = e.Row.Cells[1].Text;
       }
       e.Row.Cells[0].Text = (e.Row.RowIndex + 1).ToString(); ;
       if (e.Row.Cells[1].Text == TaskID) {
           e.Row.BackColor = System.Drawing.Color.Yellow;
       }
            
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        Button Btn = (Button)sender;
        CreateReport(Btn.CommandArgument);
    }
    protected void Button3_Click(object sender, EventArgs e)
    {
        Button Btn = (Button)sender;
        String SQL,SQL1,Type = MyManager.GetFiledByInput("SELECT Type From HitTool Where TaskID='" +Btn.CommandArgument+"'", "Type");
        if (Type == "1")
        {
            SQL = "UPDATE [StoredTool] SET State = 0 WHERE [RelatedTask] = '" + Btn.CommandArgument + "';UPDATE HitTool Set State = 0 Where TaskID = '" + Btn.CommandArgument + "';";
            MyManager.ExecSQL(SQL);
        }
        else {
            MyManager.ExecSQL("UPDATE [CoreTool] SET State = 0 WHERE [RelatedTask] = '" +Btn.CommandArgument + "';UPDATE HitTool Set State = 0 Where TaskID = '" +Btn.CommandArgument +"';");
            MyManager.ExecSQL("UPDATE [CoreToolValue] SET State = 0 WHERE (ValueType =1 or Valuetype = 3) AND  CoreID IN(SELECT ID FROM CoreTool WHERE [RelatedTask] = '" + Btn.CommandArgument + "')");
        }
        
        GV1Bind();
    }
    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
}
