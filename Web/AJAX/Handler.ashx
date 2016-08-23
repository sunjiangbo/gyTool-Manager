<%@ WebHandler Language="C#" Class="Handler"Debug="true" %>

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
using System.Web.SessionState;
using Newtonsoft.Json.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Runtime.Serialization;
using Aspose;
using Aspose.Cells;
using System.Drawing;
using Newtonsoft.Json.Linq;

public class Handler : IHttpHandler, IRequiresSessionState
{
    HttpContext gCtx;
const int TOOL_BAG_TYPE          = 1;
const int TOOL_BAG_PROPERTY      = 2;
const int TOOL_IN_BAG            = 3;
const int TOOL_IN_BAG_PROPERTY   = 4;
public String GetGeneralJSONRetBySQL(String SQLTxt)
{
    String ColName;
    StringWriter sw = new StringWriter();
    JsonWriter jWrite = new JsonTextWriter(sw);
    DataTable dt = MyManager.GetDataSet(SQLTxt);
    jWrite.WriteStartArray();

    for (int i = 0; i < dt.Rows.Count; i++)
    {

        jWrite.WriteStartObject();
        for (int j = 0; j < dt.Columns.Count; j++)
        {
            ColName = dt.Columns[j].ColumnName;
            jWrite.WritePropertyName(ColName);
            jWrite.WriteValue(dt.Rows[i][ColName].ToString());
        }
        jWrite.WriteEndObject();

    }

    jWrite.WriteEndArray();
    return sw.ToString();
}  
public String Test(HttpContext ctx)
{


    if (ctx.Session["a1"] != null)
        return ctx.Session["a1"].ToString();
    else
        return "12323";
}
    public String GetClassProperty(int ClassID)
    {
    

        String ValueName = "", ValueID = "";
        StringWriter sw = new StringWriter();
        JsonWriter jWrite = new JsonTextWriter(sw);
        DataTable dt = MyManager.GetDataSet("SELECT  A.ID,A.Name,A.necessary,A.pType,B.value FROM CLassPropertys AS A  left join [PropertyValues] as B on (B.propertyID = A.ID AND B.ValueType = 0 AND (B.ParentID  = 0 or B.ParentID is NULL) ) where A.ParentID =" + ClassID + " Order By A.ID");

        jWrite.WriteStartArray();

        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (dt.Rows[i]["ID"].ToString() != ValueID)
            {
                if (ValueID != "")
                {
                    jWrite.WriteEndArray();
                    jWrite.WriteEndObject();
                }
                jWrite.WriteStartObject();

                jWrite.WritePropertyName("id");
                ValueID = dt.Rows[i]["ID"].ToString();
                jWrite.WriteValue(ValueID);

                jWrite.WritePropertyName("valuename");
                jWrite.WriteValue(dt.Rows[i]["Name"].ToString().Trim());

                jWrite.WritePropertyName("necessary");
                jWrite.WriteValue(dt.Rows[i]["necessary"].ToString().Trim());

                jWrite.WritePropertyName("ptype");
                jWrite.WriteValue(dt.Rows[i]["pType"].ToString().Trim());

                jWrite.WritePropertyName("values");
                jWrite.WriteStartArray();
            }

            jWrite.WriteValue(dt.Rows[i]["VALUE"].ToString().Trim());
        }

        if (ValueID != "")
        {
            jWrite.WriteEndArray();
            jWrite.WriteEndObject();
        }

        jWrite.WriteEndArray();

        return sw.ToString();

    }

    public String GetClassAndProperty(int ClassID, int Type/* 任务类型 1:添加工具包 2:添加包内工具 3:修改工具箱模型 4:修改包内工具模型
              * 6:修改包内工具
                7:修改工具箱本体
                8:修改独立工具*/,String ToolID)
    {
        String ValueName = "", PropertyID = "",ValueID="",Num="1",SQL="";
        int ValueType = 0;//是该工具属性的ValueType
        StringWriter sw = new StringWriter();
        JsonWriter jWrite = new JsonTextWriter(sw);
        DataTable dt1 = null, dt = MyManager.GetDataSet("SELECT  A.ID,A.Name,A.necessary,B.value,B.ID AS vID,A.pType FROM CLassPropertys AS A  left join [PropertyValues] as B on (B.propertyID = A.ID AND B.ValueType = 0 AND (B.ParentID  = 0 or B.ParentID is NULL) ) where A.ParentID=" + ClassID + " order by A.ID");
        //字段中的vID代表属性某个取值的ID
        DataRow[] dr;
        jWrite.WriteStartArray();
        if (Type == 3)//修改工具箱
        {
            ValueType = TOOL_BAG_PROPERTY;
            SQL= "SELECT  [ID],[PropertyID],[Value],[ValueType],[Num],[ParentID] FROM [PropertyValues] WHERE (ValueType =" + ValueType + " ) AND (ParentID = " + ToolID + " OR ID=" + ToolID + ")";
        }
        else if (Type == 4)//修改包内工具
        {
            ValueType = TOOL_IN_BAG_PROPERTY ;
            SQL = "SELECT  [ID],[PropertyID],[Value],[ValueType],[Num],[ParentID] FROM [PropertyValues] WHERE (ValueType =" + TOOL_IN_BAG + " OR ValueType = "+TOOL_IN_BAG_PROPERTY+" ) AND (ParentID = " + ToolID + " OR ID=" + ToolID + ")";
        }
        else if (Type == 6)//修改包内工具
        {
            ValueType = 4;//CoreToolValue  
            SQL = "SELECT  [ID],[PropertyID],[Value],[ValueType] FROM CoreToolValue WHERE   ParentID =( SELECT ID FROM CoreToolValue WHERE ValueType = 3 AND ToolID='" + ToolID + "')";
        }
        else if (Type == 7)//7:修改工具箱本体
        {
            ValueType = 2;//CoreToolValue
            SQL = "SELECT  [ID],[PropertyID],[Value],[ValueType] FROM CoreToolValue WHERE ParentID =( SELECT ID FROM CoreToolValue WHERE ValueType = 1 AND ToolID='" + ToolID + "')";
        }
        else if (Type == 8)//8:修改独立工具
        {
            ValueType = 0;//CoreTool.ModelType=0
            SQL = "SELECT  [ID],[PropertyID],[Value],[ValueType] FROM CoreToolValue WHERE CoreID = (SELECT ID FROM CoreTool WHERE ModelType = 0 AND ToolID='"+ToolID+"')";
        }
        if (Type != 5 && Type != 1 &&Type != 2) 
        {
            dt1 = MyManager.GetDataSet(SQL);
        }
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (dt.Rows[i]["ID"].ToString() != PropertyID)
            {
                if (PropertyID != "")
                {
                    jWrite.WriteEndArray();
                    jWrite.WriteEndObject();
                }
                jWrite.WriteStartObject();

                jWrite.WritePropertyName("id");
                PropertyID = dt.Rows[i]["ID"].ToString();
                jWrite.WriteValue(PropertyID);

                if (dt1 == null)
                {
                    jWrite.WritePropertyName("selected");
                    jWrite.WriteValue("0");
                    jWrite.WritePropertyName("curvalue");
                    jWrite.WriteValue("");
                }
                else
                {
                    dr = dt1.Select(" ValueType =" + ValueType + " AND PropertyID = " + dt.Rows[i]["ID"].ToString());
                    jWrite.WritePropertyName("selected");
                    jWrite.WriteValue(dr.Length>0?"1":"0");
                    jWrite.WritePropertyName("curvalue");
                    jWrite.WriteValue(dr.Length>0?dr[0]["Value"].ToString():"");
                }
                
                jWrite.WritePropertyName("valuename");
                jWrite.WriteValue(dt.Rows[i]["Name"].ToString().Trim());

                jWrite.WritePropertyName("necessary");
                jWrite.WriteValue(dt.Rows[i]["necessary"].ToString().Trim());
                
                jWrite.WritePropertyName("compare");
                jWrite.WriteValue(dt.Rows[i]["pType"].ToString().Trim());                              

                jWrite.WritePropertyName("values");
                jWrite.WriteStartArray();
            }
            if ((dt.Rows[i]["vID"] == null) || (dt.Rows[i]["vID"].ToString() == "")) continue;
            jWrite.WriteStartObject();
            jWrite.WritePropertyName("vid");
            jWrite.WriteValue(dt.Rows[i]["vID"].ToString().Trim());
            jWrite.WritePropertyName("value");
            jWrite.WriteValue(dt.Rows[i]["VALUE"].ToString().Trim());
            jWrite.WriteEndObject();
        }

        if (PropertyID != "")
        {
            jWrite.WriteEndArray();
            jWrite.WriteEndObject();
        }

        jWrite.WriteEndArray();

        return sw.ToString();

    }
    
    public String GetToolBagModelJSON(int BagClassID/*也有可能是bagID或Coreid*/,int Type /*0:展现模型工具包 1:展现库存工具包 2:展现已入编工具包*/)
    {
        String ToolID = "", SQL = "PropertyValues";
           StringWriter sw = new StringWriter();
           JsonWriter jWrite = new JsonTextWriter(sw);

           if (Type == 0) { SQL = "select A.*,'' AS ToolID,B.Name,B.pType  from PropertyValues AS A left join classpropertys as B on(A.propertyid = B.ID) where A.parentid in (SELECT  ID FROM PropertyValues  where parentid = " + BagClassID + " AND valuetype <>2) order by valuetype,pType asc "; }
           else if (Type == 1) { SQL = "select A.*,A.rkID AS ToolID,B.Name,B.pType,C.Rank  from storedtoolvalue AS A left join classpropertys as B on( A.propertyid = B.ID) join StoredTool AS C on A.StoredID = C.ID where  storedid = " + BagClassID + " order by valuetype,pType asc"; }
           else if (Type == 2) { SQL = "select A.*,B.Name,B.pType,C.Rank  from coretoolvalue AS A left join classpropertys as B on(A.propertyid = B.ID) join CoreTool AS C on (A.CoreID = C.ID) where  coreid = "+BagClassID+" order by valuetype,pType asc"; }
           DataTable dt = MyManager.GetDataSet(SQL);
           int i = 0, j = 0,k=0 ;
           DataRow[] TBdr/*工具包ID集合*/ = dt.Select(" ValueType = 1");
           DataRow[] Tmpdr, Tmpdr_sub;
           if (TBdr.Length ==0){//Tbdr中行数为0，则证明这个是独立工具，需要从StoredTool或者CoreTool中伪造工具
               if (Type == 1) { SQL = "select A.ID,A.ID AS ParentID,A.rkID,A.ID AS StoredID ,A.ModelID AS  PropertyID,A.rkID AS ToolID,A.StoredName as Value,1 AS ValueType,B.Name,B.pType,Rank  From StoredTool AS A left join CLassPropertys AS B On (A.ModelID = B.ID) Where A.ID = " + BagClassID; }
               else { SQL = "select A.ID,A.rkID,A.ToolID,A.State,A.ModifyTime,A.ID as ParentID,A.ModelID as PropertyID ,A.ToolName as Value,1 AS ValueType ,A.ID AS CoreID,B.Name,B.pType,Rank  from coretool AS A left join classpropertys as B on(A.ModelID = B.ID)  where  A.id =" + BagClassID; }
               
                   DataTable t_dt = MyManager.GetDataSet(SQL);
                   if (t_dt.Rows.Count > 0)
                   {
                       dt.ImportRow(t_dt.Rows[0]);
                   } 
               TBdr/*工具包ID集合*/ = dt.Select(" ValueType = 1");
           }
              
           jWrite.WriteStartArray();    //[
            for (i= 0;i<TBdr.Length;i++){
                jWrite.WriteStartObject();
                jWrite.WritePropertyName("id");
                jWrite.WriteValue(TBdr[i]["ID"].ToString());
                jWrite.WritePropertyName("name");
                jWrite.WriteValue(TBdr[i]["Value"].ToString());
                jWrite.WritePropertyName("toolid");
                jWrite.WriteValue(TBdr[i]["ToolID"].ToString());
               if (Type == 0) { //如果是展现模型工具，则将每个工具的类也输入，可能是在组包
                    jWrite.WritePropertyName("propertyid");
                    jWrite.WriteValue(TBdr[i]["PropertyID"].ToString());
                }
                //jWrite.WritePropertyName("num");
               // jWrite.WriteValue(TBdr[i]["Num"].ToString());
                jWrite.WritePropertyName("tooltype");
                jWrite.WriteValue(TBdr[i]["ValueType"].ToString());
                jWrite.WritePropertyName("rank");
                jWrite.WriteValue(TBdr[i]["rank"].ToString());
                jWrite.WritePropertyName("propertys");
                jWrite.WriteStartArray();
                //开始写该工具或者工具包的属性
                Tmpdr = dt.Select(" ParentID = " + TBdr[i]["ID"].ToString() + " AND (ValueType = 2 Or ValueType = 0)");
                for (j = 0; j < Tmpdr.Length; j++)
                {
                    jWrite.WriteStartObject();
                    jWrite.WritePropertyName("name");
                    jWrite.WriteValue(Tmpdr[j]["name"].ToString());
                    jWrite.WritePropertyName("value");
                    jWrite.WriteValue(Tmpdr[j]["value"].ToString());
                    jWrite.WritePropertyName("compare");
                    jWrite.WriteValue(Tmpdr[j]["pType"].ToString());
                    jWrite.WriteEndObject();
                }
                jWrite.WriteEndArray();
                //tmpdr 中为子工具
                Tmpdr = dt.Select(" ParentID = " + TBdr[i]["ID"].ToString() + " AND ValueType = 3");
                jWrite.WritePropertyName("children");
                jWrite.WriteStartArray();
                for (j = 0; j < Tmpdr.Length; j++)
                {
                    jWrite.WriteStartObject();
                    jWrite.WritePropertyName("id");
                    jWrite.WriteValue(Tmpdr[j]["id"].ToString());
                    jWrite.WritePropertyName("toolid");
                    jWrite.WriteValue(Tmpdr[j]["ToolID"].ToString());
                    jWrite.WritePropertyName("name");
                    jWrite.WriteValue(Tmpdr[j]["value"].ToString());
                    if (Type == 0)
                    { //如果是展现模型工具，则将每个工具的类也输入，可能是在组包
                        jWrite.WritePropertyName("propertyid");
                        jWrite.WriteValue(Tmpdr[j]["PropertyID"].ToString());
                    }
                   // jWrite.WritePropertyName("num");
                    //jWrite.WriteValue(Tmpdr[j]["num"].ToString());
                    jWrite.WritePropertyName("tooltype");
                    jWrite.WriteValue(Tmpdr[j]["ValueType"].ToString());
                    jWrite.WritePropertyName("propertys");
                    jWrite.WriteStartArray();
                    Tmpdr_sub = dt.Select(" ParentID = " + Tmpdr[j]["ID"].ToString() + " AND ValueType = 4");
                    //Tmpdr_sub为某子工具的属性集合 
                    for (k = 0; k < Tmpdr_sub.Length; k++)
                    {
                        jWrite.WriteStartObject();
                        jWrite.WritePropertyName("name");
                        jWrite.WriteValue(Tmpdr_sub[k]["name"].ToString());
                        jWrite.WritePropertyName("value");
                        jWrite.WriteValue(Tmpdr_sub[k]["value"].ToString());
                        jWrite.WritePropertyName("compare");
                        jWrite.WriteValue(Tmpdr_sub[k]["pType"].ToString());
                        jWrite.WriteEndObject();
                    }
                    jWrite.WriteEndArray();
                    jWrite.WriteEndObject(); ;
                }
                jWrite.WriteEndArray();
                
                jWrite.WriteEndObject(); 
            }
           jWrite.WriteEndArray();      //]

           return sw.ToString();
    }
    public String GetClassTreeJSON()
    {
        String BagID = "", BagName = "";
        StringWriter sw = new StringWriter();
        JsonWriter jWrite = new JsonTextWriter(sw);
        DataTable dt = MyManager.GetDataSet("select A.ID,A.ParentID ,A.valueType,A.propertyid,A.Value as Name from [PropertyValues] AS A  where (A.valueType =1 or A.valueType =3 )  AND A.parentid in (SELECT  ID FROM [PropertyValues]  where valuetype=1) order by A.parentid,valuetype asc");

        jWrite.WriteStartArray();

        jWrite.WriteStartObject();
        jWrite.WritePropertyName("text");
        jWrite.WriteValue("工具包模型");
        jWrite.WritePropertyName("children");
        jWrite.WriteStartArray();
        //开始列取工具包及其报内工具
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (dt.Rows[i]["ParentID"].ToString() != BagID)
            {
                if (BagID != "")
                {
                    jWrite.WriteEndArray();
                    jWrite.WriteEndObject();
                }
                jWrite.WriteStartObject();

                jWrite.WritePropertyName("id");

                BagID = dt.Rows[i]["ParentID"].ToString();

                jWrite.WriteValue(BagID);
                jWrite.WritePropertyName("text");
                BagName = dt.Rows[i]["Name"].ToString().Trim();
                jWrite.WriteValue(BagName);
                jWrite.WritePropertyName("iconCls");
                jWrite.WriteValue("icon-toolbag");
                jWrite.WritePropertyName("attributes");
                jWrite.WriteStartObject();
                jWrite.WritePropertyName("nodetype");
                jWrite.WriteValue("1");//1：工具包 2：工具包内工具(包含工具箱本身) 3：通用工具模型
                jWrite.WritePropertyName("id");//propertyvalue 的id
                jWrite.WriteValue(dt.Rows[i]["ID"].ToString().Trim());// 
                jWrite.WritePropertyName("vtype");//propertyvalue 的valueType
                jWrite.WriteValue(dt.Rows[i]["valueType"].ToString().Trim());//  
                jWrite.WriteEndObject();
                jWrite.WritePropertyName("children");
                jWrite.WriteStartArray();
                //------------------------------------添加工具箱本身
                /*& jWrite.WriteStartObject();
                  jWrite.WritePropertyName("id");
                  jWrite.WriteValue(dt.Rows[i]["ID"].ToString().Trim());
                   
                  jWrite.WritePropertyName("text");
                  jWrite.WriteValue("工具箱");
                   
                  jWrite.WritePropertyName("attributes");
                   
                  jWrite.WriteStartObject();
                   
                  jWrite.WritePropertyName("nodetype");
                  jWrite.WriteValue("2");//1：工具包 2：工具包内工具(包含工具箱本身) 3：通用工具模型
                   
                  jWrite.WritePropertyName("id");//propertyvalue 的id
                  jWrite.WriteValue(dt.Rows[i]["ID"].ToString().Trim());// 

                  jWrite.WritePropertyName("bagid");//
                  jWrite.WriteValue(BagID);// 

                  jWrite.WritePropertyName("propertyid");//
                  jWrite.WriteValue(dt.Rows[i]["propertyid"].ToString().Trim());// 
                   
                  jWrite.WritePropertyName("bagname");//propertyvalue 的id
                  jWrite.WriteValue(BagName);// 
                   
                  jWrite.WritePropertyName("vtype");//propertyvalue 的valueType
                  jWrite.WriteValue(dt.Rows[i]["valueType"].ToString().Trim());// 
                    
                  jWrite.WriteEndObject();

                  jWrite.WriteEndObject();*/
                //------------------------------------
            }
            jWrite.WriteStartObject();
            jWrite.WritePropertyName("text");
            jWrite.WriteValue(dt.Rows[i]["Name"].ToString().Trim());
            jWrite.WritePropertyName("attributes");
            jWrite.WriteStartObject();
            jWrite.WritePropertyName("nodetype");
            jWrite.WriteValue("2");//1：工具包 2：工具包内工具 3：通用工具模型 

            jWrite.WritePropertyName("id");//propertyvalue 的id
            jWrite.WriteValue(dt.Rows[i]["ID"].ToString().Trim());// 
            jWrite.WritePropertyName("vtype");//propertyvalue 的valueType
            jWrite.WriteValue(dt.Rows[i]["valueType"].ToString().Trim());//  
            jWrite.WritePropertyName("bagid");//
            jWrite.WriteValue(BagID);// 
            jWrite.WritePropertyName("propertyid");//
            jWrite.WriteValue(dt.Rows[i]["propertyid"].ToString().Trim());// 
            jWrite.WritePropertyName("bagname");//propertyvalue 的id
            jWrite.WriteValue(BagName);// 
            jWrite.WriteEndObject();
            jWrite.WriteEndObject();

        }

        if (BagID != "")
        {
            jWrite.WriteEndArray();
            jWrite.WriteEndObject();
        }
        jWrite.WriteEndArray();
        jWrite.WriteEndObject();


        jWrite.WriteStartObject();
        jWrite.WritePropertyName("text");
        jWrite.WriteValue("工具模型");
        jWrite.WritePropertyName("children");
        jWrite.WriteStartArray();
        dt = MyManager.GetDataSet("SELECT [ID],[Name]FROM [CLassPropertys] where nodetype = 2 ");

        for (int i = 0; i < dt.Rows.Count; i++)
        {
            jWrite.WriteStartObject();
            jWrite.WritePropertyName("id");
            jWrite.WriteValue(dt.Rows[i]["ID"].ToString());
            jWrite.WritePropertyName("text");
            jWrite.WriteValue(dt.Rows[i]["Name"].ToString().Trim());
            jWrite.WritePropertyName("iconCls");
            jWrite.WriteValue("icon-tool");
            jWrite.WritePropertyName("attributes");
            jWrite.WriteStartObject();

            jWrite.WritePropertyName("nodetype");
            jWrite.WriteValue("3");//1：工具包 2：工具包内工具 3：通用工具模型
            jWrite.WriteEndObject();
            jWrite.WriteEndObject();

        }
        jWrite.WriteEndArray();
        jWrite.WriteEndObject();

        jWrite.WriteEndArray();
        return sw.ToString();
            
    }

    public String addProperty(int ClassID, String Name,int Necessary,int Compare)
    {
        String json = "";
        DataTable dt = MyManager.GetDataSet("SELECT ID  FROM [CLassPropertys] where Name ='" + Name + "' AND NodeType = 3 AND  ParentID="+ ClassID);

        if (dt.Rows.Count > 0)
        {
            json = "{\"status\":\"failed\",\"msg\":\"该属性已经存在!\"}";
            return json;
        }

        int iRet = MyManager.ExecSQL("INSERT INTO CLassPropertys (Name,NodeType,ParentID,Necessary,pType) VALUES ('" + Name + "',3,"+ClassID+","+Necessary+","+Compare+")");
        if (iRet == 1)
        {
            String CurID = MyManager.GetFiledByInput("SELECT IDENT_CURRENT('[CLassPropertys]') AS CurID", "CurID");
            json = "{\"status\":\"success\",\"propertyid\":\""+CurID+"\"}";
        }
        else
        {
            json = "{\"status\":\"failed\",\"msg\":\"添加属性失败!\"}";
        }
        return json;
    }
    
    public String addPropertyValue(int PropertyID,String Value)
    {
        String json = "";
        DataTable dt = MyManager.GetDataSet("SELECT ID  FROM [PropertyValues] where PropertyID =" + PropertyID + " AND Value = '"+Value+"' AND (ParentID is NULL or ParentID=0)");

        if (dt.Rows.Count > 0)
        {
            json = "{\"status\":\"failed\",\"msg\":\"该值已经存在!\"}";
            return json;
        }

        int iRet = MyManager.ExecSQL("INSERT INTO PropertyValues (PropertyID,Value,ValueType) VALUES (" + PropertyID + ",'" + Value + "',0)");
        if (iRet == 1)
        {
            json = "{\"status\":\"success\"}";
        }
        else {
            json = "{\"status\":\"failed\",\"msg\":\"添加属性取值失败!\"}";
        }
        return json;
    }
    public String DelPropertyValue1(int PropertyID, String Value)
    {
        String json = "";
        DataTable dt = MyManager.GetDataSet("SELECT ID  FROM [PropertyValues] where PropertyID =" + PropertyID + " AND Value = '" + Value + "' AND (ParentID is NULL or ParentID=0)");

        if (dt.Rows.Count > 0)
        {
            json = "{\"status\":\"failed\",\"msg\":\"该值已经存在!\"}";
            return json;
        }

        int iRet = MyManager.ExecSQL("INSERT INTO PropertyValues (PropertyID,Value,ValueType) VALUES (" + PropertyID + ",'" + Value + "',0)");
        if (iRet == 1)
        {
            json = "{\"status\":\"success\"}";
        }
        else
        {
            json = "{\"status\":\"failed\",\"msg\":\"添加属性取值失败!\"}";
        }
        return json;
    }
    public String ChangePropertyNecessary(int PropertyID ,int Necessary)
    {
        String json = "{\"status\":\"failed\",\"msg\":\"改变属性失败!\"}";
        int iRet = MyManager.ExecSQL("Update [CLassPropertys] Set Necessary = " + Necessary + " WHERE ID=" + PropertyID);
        if (iRet == 1)
        {
            json =  "{\"status\":\"success\"}"; 
        }
        return json;
    }

    public String ChangePropertyCompare(int PropertyID, int Compare)
    {
        String json = "{\"status\":\"failed\",\"msg\":\"改变属性失败!\"}";
        int iRet = MyManager.ExecSQL("Update [CLassPropertys] Set pType = " + Compare + " WHERE ID=" + PropertyID);
        if (iRet == 1)
        {
            json = "{\"status\":\"success\"}";
        }
        return json;
    }
    
    public String addClass(String Name)
    {
        String json = "{\"status\":\"failed\",\"msg\":\"属性名已存在!\"}";
        int iRet = 0;

    
            DataTable dt = MyManager.GetDataSet("SELECT ID FROM [CLassPropertys] WHERE NodeType = 2  AND Name = '" + Name.Trim() + "'");
            if (dt.Rows.Count > 0)
            {
                return json;
            }

            iRet = MyManager.ExecSQL("INSERT INTO [CLassPropertys] (Name,NodeType,ParentID,Necessary,pType) VALUEs('"
                                     + Name + "',2,0,0,0)");
            if (iRet == 1)
            {
                return "{\"status\":\"success\",\"msg\":\"\"}";
            }
            else
            {
                return "{\"status\":\"failed\",\"msg\":\"添加属性失败，未知原因！\"}";
            }
   
    }
    public String GetClassList()
    {
        StringWriter sw = new StringWriter();
        JsonWriter jWrite = new JsonTextWriter(sw);
        DataTable dt = MyManager.GetDataSet("SELECT ID,Name FROM CLassPropertys WHERE NodeType = 2 ORDER BY NAME");
        jWrite.WriteStartArray();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            jWrite.WriteStartObject();
            jWrite.WritePropertyName("name");
            jWrite.WriteValue(dt.Rows[i]["Name"].ToString());
            jWrite.WritePropertyName("id");
            jWrite.WriteValue(dt.Rows[i]["ID"].ToString());
            jWrite.WriteEndObject(); 
        }
        jWrite.WriteEndArray();

        return sw.ToString();
    }

    public String GetToolBagList()
    {
        StringWriter sw = new StringWriter();
        JsonWriter jWrite = new JsonTextWriter(sw);
        DataTable dt = MyManager.GetDataSet("SELECT ID,Value AS Name FROM [PropertyValues] WHERE ValueType = 1 ORDER BY NAME");
        jWrite.WriteStartArray();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            jWrite.WriteStartObject();
            jWrite.WritePropertyName("name");
            jWrite.WriteValue(dt.Rows[i]["Name"].ToString());
            jWrite.WritePropertyName("id");
            jWrite.WriteValue(dt.Rows[i]["ID"].ToString());
            jWrite.WriteEndObject();
        }
        jWrite.WriteEndArray();

        return sw.ToString();
    }
    public String GetValuesByPropertyID(int PropertyID)
    {
        StringWriter sw = new StringWriter();
        JsonWriter jWrite = new JsonTextWriter(sw);
        DataTable dt = MyManager.GetDataSet("SELECT ID,Value AS Name FROM [PropertyValues] WHERE ValueType = 0 AND PropertyID = " + PropertyID + " ORDER BY NAME");
        jWrite.WriteStartArray();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            jWrite.WriteStartObject();
            jWrite.WritePropertyName("name");
            jWrite.WriteValue(dt.Rows[i]["Name"].ToString());
            jWrite.WritePropertyName("id");
            jWrite.WriteValue(dt.Rows[i]["ID"].ToString());
            jWrite.WriteEndObject();
        }
        jWrite.WriteEndArray();

        return sw.ToString();
    }
    public String GetPropertysByClassID(int ClassID)
    {
        StringWriter sw = new StringWriter();
        JsonWriter jWrite = new JsonTextWriter(sw);
        DataTable dt = MyManager.GetDataSet("SELECT ID,Name  FROM [CLassPropertys] WHERE NodeType = 3 AND ParentID = " + ClassID + " ORDER BY NAME");
        jWrite.WriteStartArray();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            jWrite.WriteStartObject();
            jWrite.WritePropertyName("name");
            jWrite.WriteValue(dt.Rows[i]["Name"].ToString());
            jWrite.WritePropertyName("id");
            jWrite.WriteValue(dt.Rows[i]["ID"].ToString());
            jWrite.WriteEndObject();
        }
        jWrite.WriteEndArray();

        return sw.ToString();
    }
    public String addFun(JObject JO)/*用来增加工具包addToolBag或者工具包内工具 */
    {
        String json = "{\"status\":\"failed\",\"msg\":\"\"}",tmp="",txt = "";
        int i=0,Type, ClassID,CurBagID=0;
        String ToolName = "", SQL = "", nID = "" ;
        try{
            
            Type     = Convert.ToInt32(JO["type"].ToString());
            ClassID  = Convert.ToInt32(JO["classid"].ToString());
            
            if (JO["toolname"].ToString().IndexOf("'") != -1 || JO["toolname"].ToString().IndexOf(" ") != -1)
            {
                 return "{\"status\":\"failed\",\"msg\":\"不允许含有分号(')或者空格!\"}" ;
            }
            
            ToolName = JO["toolname"].ToString();

            if (Type ==1 /*增加工具箱，看是否有重名。*/) {
                if ("0" != MyManager.GetFiledByInput("SELECT Count(ID) as Num FROM PropertyValues WHERE valueType =1 AND value = '" + ToolName + "'", "Num"))
                {
                    return "{\"status\":\"failed\",\"msg\":\"该工具包名已存在，请更换！\"}";
                }
            }
            else if (Type == 2)/*增加包内工具，看是否有重名。*/
            {
                if ("0" != MyManager.GetFiledByInput("SELECT Count(ID) as Num FROM PropertyValues WHERE ParentID = " + Convert.ToInt32(JO["parentbagid"].ToString()) + " AND valueType =3 AND value = '" + ToolName + "'", "Num"))
                {
                    return "{\"status\":\"failed\",\"msg\":\"该工具名在工具包内已存在，请更换！\"}";
                }
            }
            
            //检查所有必要属性是否填写完整.
            JArray JA = JArray.FromObject(JO["values"]);
            tmp = "(";
            SQL = "";           
            
            foreach(JToken jt in JA)
            {
                JObject jobj = (JObject)jt;
                tmp += (tmp == "(" ? Convert.ToInt32(jobj["propertyid"].ToString()).ToString() : "," + Convert.ToInt32(jobj["propertyid"].ToString()).ToString());
                if (jobj["value"].ToString().IndexOf("'") != -1 || jobj["value"].ToString().IndexOf(" ") != -1) { return "{\"status\":\"failed\",\"msg\":\"属性取值不允许含有分号(')或者空格!\"}"; }
                int  iRet = Convert.ToInt32(MyManager.GetFiledByInput("SELECT Count(*) AS Count FROM [PropertyValues] where PropertyID =" + jobj["propertyid"].ToString() + " AND Value = '" + jobj["value"].ToString() + "' AND (ParentID is NULL or ParentID=0)", "Count"));
                if (iRet == 0)//该属性值之前不存在，现在添加到属性值列表中
                {
                    MyManager.ExecSQL("INSERT INTO PropertyValues (PropertyID,Value,ValueType) VALUES (" + jobj["propertyid"].ToString() + ",'" + jobj["value"].ToString() + "',0)");
                }
                SQL += "INSERT INTO PropertyValues ([PropertyID],[ValueType],Value,ParentID) VALUES (" + jobj["propertyid"].ToString() + "," + ( (Type==1 || Type ==3) ?TOOL_BAG_PROPERTY:TOOL_IN_BAG_PROPERTY) + ",'" + jobj["value"].ToString() + "',sToolPID);";
            }

            tmp += ")";

            if ("0" != MyManager.GetFiledByInput("SELECT Count(ID) as Num FROM [CLassPropertys] WHERE  ParentID = " + ClassID + "  AND NodeType = 3 AND  [Necessary] =1 AND ID NOT IN " + tmp, "Num"))
            {
                return "{\"status\":\"failed\",\"msg\":\"必要属性未填写完整！\"}"; 
            }

            if (Type == 1)/*添加工具包！*/
            {
               CurBagID = Convert.ToInt32( MyManager.GetFiledByInput("INSERT INTO [PropertyValues] (PropertyID,Value,ValueType,ParentID,Num) VALUES (" + ClassID + ",'" + ToolName + "'," + TOOL_BAG_TYPE + ",IDENT_CURRENT('PropertyValues'),1);SELECT IDENT_CURRENT('PropertyValues') AS CurID", "CurID"));
               MyManager.ExecSQL("UPDATE PropertyValues Set Rank = '" + CurBagID + "' WHERE ID = " + CurBagID);
               if (CurBagID <= 0) return "{\"status\":\"faild\",\"msg\":\"插入工具包失败！\"}";
               SQL = SQL.Replace("sToolPID", CurBagID.ToString()); 
               MyManager.ExecSQL(SQL);
            }
            else if (Type == 2)/*添加包内工具！*/
            {
                CurBagID = Convert.ToInt32(JO["parentbagid"].ToString());
               
                nID = MyManager.GetFiledByInput("INSERT INTO [PropertyValues] (PropertyID,Value,ValueType,ParentID,Num) VALUES (" + ClassID + ",'" + ToolName + "'," + TOOL_IN_BAG + "," + CurBagID + "," + Convert.ToInt32(JO["num"].ToString()) + ");SELECT IDENT_CURRENT('PropertyValues') AS CurID", "CurID");
                String RankTxt = ""; //Rank字段内容，格式为 1|2|5…………
                for (int j = 0;j < Convert.ToInt32(JO["num"].ToString()) ; j++)
                {
                    RankTxt += "|" + nID;
                }
                String OldRank = MyManager.GetFiledByInput("SELECT Rank FROM PropertyValues WHERE ID = " + CurBagID, "Rank");
                MyManager.ExecSQL("Update PropertyValues Set Rank =  '"+  OldRank + RankTxt + "' WHERE ID = " + CurBagID);
                SQL = SQL.Replace("sToolPID", nID);
                MyManager.ExecSQL(SQL);
            }
            else if (Type == 3) //修改工具箱
            {
                MyManager.ExecSQL("UPDATE PropertyValues SET Value = '" + ToolName + "' WHERE ID=" + Convert.ToInt32(JO["toolid"].ToString()));
               // MyManager.ExecSQL("UPDATE PropertyValues SET Value = '" + ToolName + "',Num=" + Convert.ToInt32(JO["num"].ToString()) + " WHERE ID=" + Convert.ToInt32(JO["toolid"].ToString()));
                MyManager.ExecSQL("DELETE FROM PropertyValues WHERE ValueType = 2 AND ParentID= " + Convert.ToInt32(JO["toolid"].ToString()));//删除该工具原有属性
                SQL = SQL.Replace("sToolPID", JO["toolid"].ToString());
                MyManager.ExecSQL(SQL);
            }
            else if (Type == 4)//修改工具包内工具
            {
                String RankTxt = MyManager.GetFiledByInput("SELECT Rank FROM PropertyValues Where ID = " + JO["toolid"].ToString(), "Rank");
                int OldNum = Convert.ToInt32(MyManager.GetFiledByInput("SELECT Num FROM PropertyValues Where ID = " + JO["toolid"].ToString(), "Num"));
                int CurNum = Convert.ToInt32(JO["num"].ToString());
                CurBagID =Convert.ToInt32( JO["parentbagid"].ToString());
                if (CurNum != OldNum)
                {
                    txt = "不相等bagid:"+CurBagID;
                    String OldRank = MyManager.GetFiledByInput("SELECT Rank FROM PropertyValues WHERE ID = " + CurBagID, "Rank");
                    
                    if (CurNum > OldNum)//工具个数增加，
                    {
                        for (int j = 0; j < CurNum - OldNum; j++)
                        {
                            OldRank += "|" + JO["toolid"].ToString();
                        }
                        txt += "增加后:" + OldRank;
                    }
                    else//工具个数减少，
                    {
                        String[] arr = OldRank.Split('|');
                        List<System.String> listS=new List<System.String>(arr);
                        
                        int Num = OldNum - CurNum,t =0;
                        for (int j = listS.Count-1; j>=0&& t<Num;j-- )
                        {
                            if (listS[j] == JO["toolid"].ToString() && t<Num){
                                listS.RemoveAt(j);
                                t++;
                            }
                        }
                        
                        OldRank = String.Join("|", listS.ToArray());
                        txt += "减少后:" + OldRank;
                      }
                    //更新工具包的Rank字段
                    MyManager.ExecSQL("UPDATE PropertyValues SET Rank = '" +OldRank+ "' WHERE ID=" + CurBagID);
                }

                
                MyManager.ExecSQL("UPDATE PropertyValues SET Value = '" + ToolName + "',Num=" + Convert.ToInt32(JO["num"].ToString()) + " WHERE ID=" + Convert.ToInt32(JO["toolid"].ToString()));
                MyManager.ExecSQL("DELETE FROM PropertyValues WHERE ValueType = 4 AND ParentID= " + Convert.ToInt32(JO["toolid"].ToString()));//删除该工具原有属性
                if (CurNum != 0)
                {
                    SQL = SQL.Replace("sToolPID", JO["toolid"].ToString());
                    MyManager.ExecSQL(SQL);
                }
                else
                {
                    MyManager.ExecSQL("DELETE FROM PropertyValues WHERE ID=" + Convert.ToInt32(JO["toolid"].ToString()) + " OR ParentID = " + JO["toolid"].ToString());
                }
            }
            else
            {
                return "{\"status\":\"failed\",\"msg\":\"任务类型不存在!\"}";
            }

           return "{\"status\":\"success\",\"msg\":\"成功！"+txt+"\"}";
        }
       catch (Exception ee){
           return  "{\"status\":\"failed\",\"msg\":\""+ee.ToString()+"\"}";
        }
        
    }
    public String StoreTool(JObject JO)
    {
        String json = "", StoredID = "", txt = "";
        int tRet = 1/*先认为库存中存在属性和取值相同的该工具*/, j = 0, bFind = 0, iRet = 0;
        JArray JA;
        try
        {
            int ValCount = Convert.ToInt32(JO["valuecount"].ToString()), i = 0;

            if (ValCount == 0)
            {
                return "{\"status\":\"failed\",\"msg\":\"没有任何属性，添加失败！\"}";
            }

            int ClassID = Convert.ToInt32(JO["classid"].ToString());
            int num = Convert.ToInt32(JO["num"].ToString());
            DataTable dt = MyManager.GetDataSet("SELECT StoredID,Count(ID) AS [Count] FROM [StoredToolValue]  WHERE StoredID IN (SELECT ID FROM StoredTool WHERE ModelID = " + ClassID + ")  Group By  StoredID ");
            JA = JArray.Parse(JO["values"].ToString());
            if (dt.Rows.Count == 0)
            {
                tRet = 0;//库存中没有该工具存在。
            }
            else
            {
                DataRow[] dr;
                dr = dt.Select(" Count = " + ValCount);
                if (dr.Length == 0)
                {
                    tRet = 0;//虽然有该类工具，但是属性没有完全匹配该工具。
                }
                else
                {
                    //工具类和属性数目匹配，开始匹配计算
                    tRet = 0;
                    for (i = 0; i < dr.Length; i++)
                    {
                        DataTable dt1 = MyManager.GetDataSet("SELECT [PropertyID],[Value] FROM [StoredToolValue]  WHERE StoredID =" + dr[i]["StoredID"].ToString());
                        bFind = 1; //默认相信当前工具符合要求，在检查中排除。
                        foreach (JToken jt in JA)
                        {
                            JObject jobj = (JObject)jt;

                            //if (jobj["compare"].ToString() == "0") continue; //compare=0 证明该属性为非比较类属性。

                            DataRow[] dr1 = dt1.Select(" PropertyID = " + jobj["propertyid"].ToString() + " AND Value = '" + jobj["value"].ToString().Trim() + "'");
                            if (dr1.Length <= 0)
                            {
                                txt = "没找到";
                                bFind = 0;
                                break;  //有任意一个属性不匹配，就退出。
                            }
                        }
                        /****!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
                         * 不再考虑有库存中多个工具一模一样的情况，默认不应该存在！
                         * **/

                        if (bFind == 1)
                        {
                            txt += "找到啦";
                            StoredID = dr[i]["StoredID"].ToString();
                            tRet = 1;
                            break;
                        }
                    }


                }

            }
            txt += "bFind:" + bFind + " tRet:" + tRet;
            if (tRet == 1)//找到了,修改改工具数量即可！
            {
                MyManager.ExecSQL("UPDATE [StoredTool] Set Num = Num + " + num + " WHERE ID = " + StoredID);
                json = "{\"status\":\"ok\",\"msg\":\"添加成功(修改库存)，该工具当前库存为:" + Convert.ToInt32(MyManager.GetFiledByInput("SELECT Num From [StoredTool] WHERE ID = " + StoredID, "Num")) + "\"}";
            }
            else //库存中未发现和该工具具有完全相同属性的工具
            {
                String SQL = "";
                StoredID = MyManager.GetFiledByInput("INSERT INTO StoredTool ([StoredName],[ModelID],[ModelType],[Num],[StoreTime]) VALUES ( " + "'"
                                                     + JO["toolname"].ToString() + "',"
                                                     + JO["classid"].ToString() + ",0,"
                                                     + num + ","
                                                     + "'" + DateTime.Now.ToString() + "');select @@IDENTITY as CurID;", "CurID");

                foreach (JToken jt in JA)
                {
                    JObject jobj = (JObject)jt;
                    if (jobj["value"].ToString().IndexOf("'") != -1 || jobj["value"].ToString().IndexOf(" ") != -1) { return "{\"status\":\"failed\",\"msg\":\"属性取值不允许含有分号(')或者空格!\"}"; }
                    //查看该属性值之前是否存在SELECT ID  
                    iRet = Convert.ToInt32(MyManager.GetFiledByInput("SELECT Count(*) AS Count FROM [PropertyValues] where PropertyID =" + jobj["propertyid"].ToString() + " AND Value = '" + jobj["value"].ToString() + "' AND (ParentID is NULL or ParentID=0)", "Count"));
                    if (iRet == 0)//该属性值之前不存在，现在添加到属性值列表中
                    {
                        MyManager.ExecSQL("INSERT INTO PropertyValues (PropertyID,Value,ValueType) VALUES (" + jobj["propertyid"].ToString() + ",'" + jobj["value"].ToString() + "',0)");
                    }
                    SQL += "INSERT INTO [StoredToolValue] ([StoredID],[PropertyID],[Value],[ValueType],[ParentID],Num) VALUES (" + StoredID + "," + jobj["propertyid"].ToString() + ",'" + jobj["value"].ToString() + "',0,0" + ",0);";
                }

                json = "{\"status\":\"ok\",\"msg\":\"添加成功，该工具当前库存为:" + num + "\"}";

                MyManager.ExecSQL(SQL);

            }

        }
        catch (Exception ee)
        {
            json = "{\"status\":\"failed\",\"msg\":\"" + txt + ee.ToString() + "\"}";
        }



        return json;
    }
    public String StoreTool_old(JObject JO)
   {
       String json = "",StoredID="",txt= "";
       int tRet = 1/*先认为库存中存在属性和取值相同的该工具*/,j=0,bFind = 0,iRet=0;
       JArray JA;
       try
       {
           int ValCount = Convert.ToInt32(JO["valuecount"].ToString()),i=0;

           if (ValCount == 0) {
               return  "{\"status\":\"failed\",\"msg\":\"没有任何属性，添加失败！\"}";
           }
           
           int ClassID  = Convert.ToInt32(JO["classid"].ToString());
           int num      = Convert.ToInt32(JO["num"].ToString());
           DataTable dt = MyManager.GetDataSet("SELECT StoredID,Count(ID) AS [Count] FROM [StoredToolValue]  WHERE StoredID IN (SELECT ID FROM StoredTool WHERE ModelID = " + ClassID + ")  Group By  StoredID ");
           JA = JArray.Parse(JO["values"].ToString());
           if (dt.Rows.Count == 0)
           {
               tRet = 0;//库存中没有该工具存在。
           }
           else
           {
               DataRow[] dr;
               dr = dt.Select(" Count = " + ValCount);
               if (dr.Length == 0)
               {
                   tRet = 0;//虽然有该类工具，但是属性没有完全匹配该工具。
               }
               else { 
                   //工具类和属性数目匹配，开始匹配计算
                   tRet = 0;                   
                   for (i = 0; i < dr.Length; i++)
                   {
                       DataTable dt1 = MyManager.GetDataSet("SELECT [PropertyID],[Value] FROM [StoredToolValue]  WHERE StoredID ="+dr[i]["StoredID"].ToString() );
                       bFind = 1; //默认相信当前工具符合要求，在检查中排除。
                       foreach (JToken jt in JA)
                       {
                           JObject jobj = (JObject)jt;
                           
                           //if (jobj["compare"].ToString() == "0") continue; //compare=0 证明该属性为非比较类属性。
                               
                               DataRow[] dr1 = dt1.Select(" PropertyID = " + jobj["propertyid"].ToString() + " AND Value = '" + jobj["value"].ToString().Trim()+"'");
                               if (dr1.Length <= 0)
                               {
                                   txt = "没找到";
                                   bFind = 0;
                                   break;  //有任意一个属性不匹配，就退出。
                               }
                       }
                      /****!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
                       * 不再考虑有库存中多个工具一模一样的情况，默认不应该存在！
                       * **/
                                                                     
                       if (bFind == 1 ){
                           txt += "找到啦";
                           StoredID = dr[i]["StoredID"].ToString();
                           tRet = 1;
                           break;
                       }                                  
                   }
                   
                   
               }             
               
           }
           txt += "bFind:" + bFind + " tRet:" + tRet;
           if (tRet == 1)//找到了,修改改工具数量即可！
           {
               MyManager.ExecSQL("UPDATE [StoredTool] Set Num = Num + " + num + " WHERE ID = " + StoredID);
               json = "{\"status\":\"ok\",\"msg\":\"添加成功(修改库存)，该工具当前库存为:" + Convert.ToInt32( MyManager.GetFiledByInput("SELECT Num From [StoredTool] WHERE ID = " + StoredID ,"Num")) + "\"}";
           }
           else //库存中未发现和该工具具有完全相同属性的工具
           {
               String SQL = "";
               StoredID = MyManager.GetFiledByInput("INSERT INTO StoredTool ([StoredName],[ModelID],[ModelType],[Num],[StoreTime]) VALUES ( "+ "'"
                                                    + JO["toolname"].ToString()+"'," 
                                                    + JO["classid"].ToString() + ",0,"
                                                    + num +","
                                                    + "'" + DateTime.Now.ToString() + "');select @@IDENTITY as CurID;", "CurID"); 
                                                     
               foreach (JToken jt in JA)
               {
                   JObject jobj = (JObject)jt;
                   if (jobj["value"].ToString().IndexOf("'") != -1 || jobj["value"].ToString().IndexOf(" ") != -1) { return "{\"status\":\"failed\",\"msg\":\"属性取值不允许含有分号(')或者空格!\"}"; }
                   //查看该属性值之前是否存在SELECT ID  
                   iRet = Convert.ToInt32( MyManager.GetFiledByInput("SELECT Count(*) AS Count FROM [PropertyValues] where PropertyID =" + jobj["propertyid"].ToString() + " AND Value = '"+jobj["value"].ToString()+"' AND (ParentID is NULL or ParentID=0)", "Count"));
                   if (iRet == 0)//该属性值之前不存在，现在添加到属性值列表中
                   {
                       MyManager.ExecSQL("INSERT INTO PropertyValues (PropertyID,Value,ValueType) VALUES (" + jobj["propertyid"].ToString() + ",'" + jobj["value"].ToString() + "',0)"); 
                   }
                   SQL += "INSERT INTO [StoredToolValue] ([StoredID],[PropertyID],[Value],[ValueType],[ParentID],Num) VALUES (" + StoredID + "," + jobj["propertyid"].ToString() + ",'" + jobj["value"].ToString() + "',0,0" + ",0);";
               }
               
               json = "{\"status\":\"ok\",\"msg\":\"添加成功，该工具当前库存为:" + num+ "\"}";
               
               MyManager.ExecSQL(SQL);
               
           }

       }
       catch (Exception ee)
       {
           json = "{\"status\":\"failed\",\"msg\":\"" + txt + ee.ToString() + "\"}";
       }
        
       
        
       return json;
   }
    public String StoreToolBag1(JObject JO)
    {
        String json = "", StoredID = "", test = "";
        int tRet = 0/*先认为库存中存在该工具*/, i = 0, j = 0, bFind = 1, num, ModelID, FoundStoreID = 0;
        try
        {
            ModelID = Convert.ToInt32(JO["modelid"].ToString());
            num = Convert.ToInt32(JO["num"].ToString());
            DataTable dt = MyManager.GetDataSet("SELECT ID FROM [StoredTool] WHERE ModelType =1 AND ModelID = " + Convert.ToInt32(JO["modelid"].ToString()));
            if (dt.Rows.Count == 0)
            {
                tRet = 0;
            }
            else
            {
                DataTable dt1 = MyManager.GetDataSet("SELECT *  FROM [PropertyValues] where (parentid in (select ID FROM [PropertyValues] where parentid = " + ModelID + " ) or parentid = " + ModelID + ")");
                for (i = 0, bFind = 0; i < dt.Rows.Count && bFind == 0; i++)
                {
                    DataTable dt2 = MyManager.GetDataSet("SELECT *  FROM [StoredToolValue] where StoredID = " + dt.Rows[i]["ID"].ToString());
                    bFind = 1;
                    if (dt2.Rows.Count != dt1.Rows.Count) { test += "2:行数不一致"; bFind = 0; continue; } //行数不一致的直接略过
                    else
                    {
                        test += "进入3";
                        for (j = 0, bFind = 0; j < dt1.Rows.Count; j++)
                        {
                            
                            String sNum = "";
                            sNum = dt1.Rows[j]["Num"].ToString() == "" ? "0" : dt1.Rows[j]["Num"].ToString();
                            DataRow[] dr = dt2.Select(" [PropertyID] =" + dt1.Rows[j]["PropertyID"].ToString()
                                                     + "  AND [Value] = '" + dt1.Rows[j]["Value"].ToString()
                                                     + "' AND [ValueType] = " + dt1.Rows[j]["ValueType"].ToString()
                                                     + "  AND [Num] = " + sNum
                                                     );
                            bFind = 1;

                            test += dr.Length + " ";

                            if (dr.Length == 0)
                            {
                                bFind = 0;

                                test += "不存在:" + dt1.Rows[j]["ID"].ToString() + " ";

                                break;
                            }
                            else
                            {

                                test += "删除" + dr[0]["ID"].ToString() + " ";
                                dt2.Rows.Remove(dr[0]);
                            }
                        }

                        if (bFind == 1)
                        {
                            FoundStoreID = Convert.ToInt32(dt.Rows[i]["ID"].ToString());
                            tRet = 1;
                        }
                        else
                        {
                            tRet = 0;
                        }
                    }
                }
            }

            if (tRet == 1)
            {
                MyManager.ExecSQL("UPDATE [StoredTool] Set Num = Num + " + num + " WHERE ID = " + FoundStoreID);
                json = "{\"status\":\"ok\",\"test\":\"" + test + "\",\"fid\":" + FoundStoreID + ",\"msg\":\"添加成功(修改库存)，该工具工具包当前库存为:" + MyManager.GetFiledByInput("SELECT Num From [StoredTool] WHERE ID = " + FoundStoreID, "Num") + "\"}";
            }
            else
            {
                DataTable dt1 = MyManager.GetDataSet("SELECT *  FROM [PropertyValues] where parentid in (select ID FROM [PropertyValues] where parentid = " + ModelID + " ) or parentid = " + ModelID);

                DataRow[] dr1, dr = dt1.Select(" ID = " + ModelID);
                String ID = MyManager.GetFiledByInput("INSERT INTO [StoredTool] ([StoredName],[ModelID],[ModelType],[Num],[StoreTime]) VALUES ("
                                 + "'" + dr[0]["Value"] + "',"
                                 + ModelID + ",1,"
                                 + num + ",'"
                                 + DateTime.Now.ToString() + "');SELECT IDENT_CURRENT('StoredTool') AS CurID", "CurID");
                /*******************开始添加工具箱本体属性********************/
                dr = dt1.Select(" ValueType = 1");
                for (i = 0; i < dr.Length; i++)
                {
                    String gID = MyManager.GetFiledByInput("INSERT INTO [StoredToolValue] ([StoredID],[PropertyID],[Value],[ValueType],[Num],[ParentID]) VALUES ("
                              + ID + ","
                              + dr[i]["PropertyID"].ToString() + ",'"
                              + dr[i]["Value"].ToString() + "',"
                              + dr[i]["ValueType"].ToString() + ","
                              + (dr[i]["num"].ToString() == "" ? "1" : dr[i]["num"].ToString()) + ","
                              + ID + ");SELECT IDENT_CURRENT('StoredToolValue') AS CurID", "CurID");
                    dr1 = dt1.Select(" ValueType = 2 AND ParentID = " + dr[i]["ID"].ToString());
                    for (j = 0; j < dr1.Length; j++)
                    {
                        MyManager.ExecSQL("INSERT INTO [StoredToolValue] ([StoredID],[PropertyID],[Value],[ValueType],[Num],[ParentID]) VALUES ("
                                  + ID + ","
                                  + dr1[j]["PropertyID"].ToString() + ",'"
                                  + dr1[j]["Value"].ToString() + "',"
                                  + dr1[j]["ValueType"].ToString() + ","
                                  + "0,"
                                  + gID + ")");
                    }

                }


                /***********************************************************/

                /*******************开始工具箱内工具及其属性********************/
                dr = dt1.Select(" ValueType = 3");
                for (i = 0; i < dr.Length; i++)
                {


                    String mID = MyManager.GetFiledByInput("INSERT INTO [StoredToolValue] ([StoredID],[PropertyID],[Value],[ValueType],[Num],[ParentID]) VALUES ("
                                  + ID + ","
                                  + dr[i]["PropertyID"].ToString() + ",'"
                                  + dr[i]["Value"].ToString() + "',"
                                  + dr[i]["ValueType"].ToString() + ",'"
                                  + dr[i]["num"].ToString() + "',"
                                  + ID + ");SELECT IDENT_CURRENT('StoredToolValue') AS CurID", "CurID");
                    //添加工具属性
                    dr1 = dt1.Select(" ValueType = 4 AND ParentID = " + dr[i]["ID"].ToString());
                    for (j = 0; j < dr1.Length; j++)
                    {
                        MyManager.ExecSQL("INSERT INTO [StoredToolValue] ([StoredID],[PropertyID],[Value],[ValueType],[Num],[ParentID]) VALUES ("
                                  + ID + ","
                                  + dr1[j]["PropertyID"].ToString() + ",'"
                                  + dr1[j]["Value"].ToString() + "',"
                                  + dr1[j]["ValueType"].ToString() + ",'"
                                  + dr1[j]["num"].ToString() + "',"
                                  + mID + ")");
                    }
                }
                /***********************************************************/

                json = "{\"status\":\"ok\","/*\"test\":\"" + test + "\"*/+"\"msg\":\"入库成功，该工具工具包当前库存为:" + num + "\"}";
            }
        }
        catch (Exception ee)
        {
            json = "{\"status\":\"failed\",\"msg\":\"" + ee.ToString() + "\"}";
        }



        return json;
    }
    public String StoreToolBag(JObject JO)
    {
        String json = "", StoredID = "",test = "";
        String gID = "";
        int tRet = 0/*先认为库存中存在该工具*/, i=0,j = 0, bFind = 1,num,ModelID,FoundStoreID = 0;
        try
        {
            ModelID = Convert.ToInt32(JO["modelid"].ToString());
            num = Convert.ToInt32( JO["num"].ToString());
            DataTable dt = MyManager.GetDataSet("SELECT ID FROM [StoredTool] WHERE ModelType =1 AND ModelID = " + Convert.ToInt32( JO["modelid"].ToString()));
            if (dt.Rows.Count == 0)
            {
                tRet = 0;
            }
            else
            {
                DataTable dt1 = MyManager.GetDataSet("SELECT *  FROM [PropertyValues] where (parentid in (select ID FROM [PropertyValues] where parentid = " + ModelID + " ) or parentid = " + ModelID + ") " );
                for (i = 0,bFind=0; i < dt.Rows.Count && bFind == 0; i++)
                {
                    DataTable dt2 = MyManager.GetDataSet("SELECT *  FROM [StoredToolValue] where StoredID = " +dt.Rows[i]["ID"].ToString() );
                    bFind = 1;
                    if (dt2.Rows.Count != dt1.Rows.Count) {  bFind = 0; continue; } //行数不一致的直接略过
                    else
                    {
                        for ( j = 0,bFind=0; j < dt1.Rows.Count ; j++)
                        {
                            String sNum = "";
                            sNum = dt1.Rows[j]["Num"].ToString() == "" ? "0" : dt1.Rows[j]["Num"].ToString();
                            DataRow[] dr = dt2.Select(" [PropertyID] =" + dt1.Rows[j]["PropertyID"].ToString()
                                                     + "  AND [Value] = '" + dt1.Rows[j]["Value"].ToString()
                                                     + "' AND [ValueType] = " + dt1.Rows[j]["ValueType"].ToString()
                                                     + "  AND [Num] = " + sNum
                                                     );
                            bFind = 1;

                            test += dr.Length + " ";
                            
                            if (dr.Length == 0){
                                bFind = 0;                                                             
                                break;
                            }
                            else{
                                dt2.Rows.Remove(dr[0]);
                            }
                        }

                        if (bFind == 1)
                        {
                            FoundStoreID = Convert.ToInt32(dt.Rows[i]["ID"].ToString());
                            tRet = 1;
                        }
                        else {
                            tRet = 0;
                        }
                    }
                }
            }

            if (tRet == 1)
            {
                MyManager.ExecSQL("UPDATE [StoredTool] Set Num = Num + " + num + " WHERE ID = " + FoundStoreID);
                json = "{\"status\":\"ok\",\"test\":\""+test+"\",\"fid\":"+FoundStoreID+",\"msg\":\"添加成功(修改库存)，该工具工具包当前库存为:" + MyManager.GetFiledByInput("SELECT Num From [StoredTool] WHERE ID = " + FoundStoreID, "Num") + "\"}";
            }
            else
            {
                DataTable dt1 = MyManager.GetDataSet("SELECT *  FROM [PropertyValues] where parentid in (select ID FROM [PropertyValues] where parentid = " + ModelID + " ) or parentid = " + ModelID);
                
                DataRow[] dr1,dr = dt1.Select(" ID = " +ModelID);
                String  ID = MyManager.GetFiledByInput("INSERT INTO [StoredTool] ([StoredName],[ModelID],[ModelType],[Num],[StoreTime]) VALUES (" 
                                 +"'" + dr[0]["Value"] + "',"
                                 + ModelID + ",1,"
                                 + num + ",'"
                                 + DateTime.Now.ToString() + "');SELECT IDENT_CURRENT('StoredTool') AS CurID", "CurID");
                /*******************开始添加工具箱本体以及其属性********************/
                    dr = dt1.Select(" ValueType = 1");
                    for (i = 0; i < dr.Length; i++)
                    {
                            gID = MyManager.GetFiledByInput("INSERT INTO [StoredToolValue] ([StoredID],[PropertyID],[Value],[ValueType],[Num],[ParentID]) VALUES ("
                                  + ID + ","
                                  + dr[i]["PropertyID"].ToString() + ",'"
                                  + dr[i]["Value"].ToString() + "',"
                                  + dr[i]["ValueType"].ToString() + ","
                                  + (dr[i]["num"].ToString() == "" ? "1" : dr[i]["num"].ToString()) + ",IDENT_CURRENT('StoredToolValue'));SELECT IDENT_CURRENT('StoredToolValue') AS CurID", "CurID");
                        
                        dr1 = dt1.Select(" ValueType = 2 AND ParentID = " +dr[i]["ID"].ToString() );
                        for (j = 0; j < dr1.Length; j++)
                        {
                            MyManager.ExecSQL("INSERT INTO [StoredToolValue] ([StoredID],[PropertyID],[Value],[ValueType],[Num],[ParentID]) VALUES ("
                                      + ID + ","
                                      + dr1[j]["PropertyID"].ToString() + ",'"
                                      + dr1[j]["Value"].ToString() + "',"
                                      + dr1[j]["ValueType"].ToString() + ","
                                      + "0,"
                                      + gID + ")");
                        }
                    
                    }
                    
                  
                /***********************************************************/

                   /*******************开始工具箱内工具及其属性********************/
                   dr = dt1.Select(" ValueType = 3");
                   for (i = 0; i < dr.Length; i++)
                   {
                       

                       String mID = MyManager.GetFiledByInput("INSERT INTO [StoredToolValue] ([StoredID],[PropertyID],[Value],[ValueType],[Num],[ParentID]) VALUES ("
                                     + ID + ","
                                     + dr[i]["PropertyID"].ToString() + ",'"
                                     + dr[i]["Value"].ToString() + "',"
                                     + dr[i]["ValueType"].ToString() + ",'"
                                     + dr[i]["num"].ToString() + "',"
                                     + gID + ");SELECT IDENT_CURRENT('StoredToolValue') AS CurID", "CurID");
                       //添加工具属性
                       dr1 = dt1.Select(" ValueType = 4 AND ParentID = " + dr[i]["ID"].ToString());
                       for (j = 0; j < dr1.Length; j++)
                       {
                           MyManager.ExecSQL("INSERT INTO [StoredToolValue] ([StoredID],[PropertyID],[Value],[ValueType],[Num],[ParentID]) VALUES ("
                                     + ID + ","
                                     + dr1[j]["PropertyID"].ToString() + ",'"
                                     + dr1[j]["Value"].ToString() + "',"
                                     + dr1[j]["ValueType"].ToString() + ",'"
                                     + dr1[j]["num"].ToString() + "',"
                                     + mID + ")");
                       }
                   }
                /***********************************************************/

                   json = "{\"status\":\"ok\",\"test\":\""+test+"\",\"msg\":\"入库成功，该工具工具包当前库存为:" +num + "\"}";
            }
        }
        catch (Exception ee)
        {
            json = "{\"status\":\"failed\",\"msg\":\"" + ee.ToString() + "\"}";
        }



        return json;
    }
    public String ToolSearchToExcel(JObject JO)/*对coretable中的工具进行查询，已经编号的*/
    {
        /*{ range: -1, name: "所有", ret:返回范围 "all"所有 "tool"工具 "bag"工具包, specific:[
         *                                                                              { tid: ToolClassID, name: ToolClassName, vals: [
         *                                                                                                                                  { name: PropertyName, pid: PropertyID, val: Value }
         * ] }
         * ] };*/

        /*这里返回的json中ToolType含义                  查询界面中按钮功能 
         *                  0:独立工具(ModeType)        修改属性、进包        
         *                  1:工具箱(CoreToolValue)     只能修改其属性 不能出包
         *                  3:工具箱中的工具            修改属性、独立、改包 
         *                  5:工具包                    修改其名称、拆包
         */
        String json = "";
        int i, j, k, fw = 0/*范围：0所有 1工具包 2 工具*/;
        String txt, SQL = "", SQL1 = "";
        String IDdlfw="", IDdl = "", IDbn = "";//独立 和 包内 CoreID
        DataTable dt, dt1, dt2;
        DataRow[] dr, dr1;
        String Note="";
        JObject Filter = (JObject)JO["Filter"];
        JArray Specific = (JArray)Filter["specific"];
        String rkID = JO["rkid"].ToString().Trim();
        String ToolID = JO["toolid"].ToString().Trim();
        String ToolName = JO["name"].ToString().Trim();
        if (Filter["range"].ToString() == "-1")
        {

            txt = Filter["ret"].ToString();
            if (txt == "all")
            {
                fw = 0;
            }
            else if (txt == "tool")
            {
                fw = 2;
            }
            else if (txt == "bag")
            {
                fw = 1;
            }

        }
        else
        {
            fw = 1;
        }
        String NameLike1 = " OR ToolName like'%" + ToolName + "%' ", NameLike2 = " OR (ValueType in(1,3) AND Value like'%" + ToolName + "%') ";
        if(ToolName=="")
        {
            NameLike1 = NameLike2 = "";
        }
        String t_SQL = "SELECT distinct ID AS CoreID FROM CoreTool WHERE rkID ='" + rkID + "' OR ToolID ='" + ToolID + "' " + NameLike1 + "UNION SELECT distinct CoreID FROM CoreToolValue WHERE rkID='" + rkID + "' " + NameLike2 + " OR ToolID ='" + ToolID + "'";
        dt = MyManager.GetDataSet("SELECT distinct ID AS CoreID FROM CoreTool WHERE rkID ='" + rkID + "' OR ToolID ='" + ToolID +"' "+ NameLike1+ "UNION SELECT distinct CoreID FROM CoreToolValue WHERE rkID='" + rkID + "' "+NameLike2+" OR ToolID ='" + ToolID + "'");
        for (k = 0, IDdl="",IDbn = ""/*每次需将IDbn清空，获取最新集合，然后继续筛选*/; k < dt.Rows.Count; k++)
        {
            IDbn += (IDbn == "" ? dt.Rows[k]["CoreID"].ToString() : "," + dt.Rows[k]["CoreID"].ToString());
            //IDdlfw += (IDdlfw == "" ? dt.Rows[k]["CoreID"].ToString() : "," + dt.Rows[k]["CoreID"].ToString());
        }
        
        if (IDbn != "")
        {
            IDdlfw = " AND ID IN(" + IDbn + ") ";
        }
        else if (rkID != "" || ToolName != "" || ToolID != "")//搜索条件不全为空，而搜索结果为空，证明根据搜索条件搜到的结果为空
        {
            IDdlfw = " AND ID IN('') ";
            IDbn = "''";
        }

        
        if (fw == 0 || fw == 1)
        {//所有 或 工具包
          
            
            for (i = 0; i < Specific.Count; i++)
            {
                SQL1 = "(SELECT distinct CoreID FROM CoreToolValue WHERE (ValueType = 3 or ValueType = 1) AND PropertyID = " + Specific[i]["tid"].ToString()
                        + (IDbn == "" ? "" : " AND CoreID IN(" + IDbn + ")") + ")";

                JArray JV = (JArray)Specific[i]["vals"];
                for (j = 0; j < JV.Count; j++)
                {
                    SQL1 += " Intersect ( SELECT CoreID FROM CoreToolValue WHERE ParentID IN(" + " SELECT ID FROM CoreToolValue WHERE (ValueType = 3 or ValueType = 1) AND PropertyID = " + Specific[i]["tid"].ToString() + (IDbn == "" ? "" : " AND CoreID IN(" + IDbn + ")") + ")" + " AND (ValueType = 4 OR ValueType = 2) AND PropertyID = " + JV[j]["pid"].ToString() + (JV[j]["val"].ToString() != "zkgy-1" ? " AND Value = '" + JV[j]["val"].ToString() + "')" : ")");
                 }

                dt1 = MyManager.GetDataSet(SQL1);//工具包，将StoreID集合
                
                if (dt1.Rows.Count == 0)//count = 0 说明到这已经没有符合要求的工具包啦！！！直接退出循环.
                {
                    IDbn = "";
                    break;
                }
                   
                    for (k = 0, IDbn = ""/*每次需将IDbn清空，获取最新集合，然后继续筛选*/; k < dt1.Rows.Count; k++)
                    {
                        IDbn += (IDbn == "" ? dt1.Rows[k]["CoreID"].ToString() : "," + dt1.Rows[k]["CoreID"].ToString());
                    }
            }

        }

        if (fw == 2 || fw == 0)//独立工具或所有
        {
            for (i = 0; i < Specific.Count; i++)
            {
                SQL = "(SELECT distinct ID AS CoreID FROM CoreTool WHERE ModelType = 0 AND ModelID = " + Specific[i]["tid"].ToString() +IDdlfw+" )";

                JArray JV = (JArray)Specific[i]["vals"];
                for (j = 0; j < JV.Count; j++)
                {
                    SQL += " Intersect (SELECT distinct CoreID FROM [CoreToolValue] WHERE CoreID IN " + "(SELECT distinct ID AS StoredID FROM CoreTool WHERE ModelType = 0 AND ModelID = " + Specific[i]["tid"].ToString() + ")" + " AND ValueType = 0 AND PropertyID = " + JV[j]["pid"].ToString() + (JV[j]["val"].ToString() != "zkgy-1" ? " AND Value = '" + JV[j]["val"].ToString() + "')" : ")");
                }

                dt1 = MyManager.GetDataSet(SQL); //独立工具，将CoreID集合

                for (k = 0; k < dt1.Rows.Count; k++)
                {
                    IDdl += (IDdl == "" ? dt1.Rows[k]["CoreID"].ToString() : "," + dt1.Rows[k]["CoreID"].ToString());
                }
            }
        }
        Aspose.Cells.Workbook workbook = new Aspose.Cells.Workbook(gCtx.Server.MapPath("~") + "\\Template\\kb.xls");
        Aspose.Cells.Worksheet sheet = workbook.Worksheets[0];
        Aspose.Cells.Cells cells = sheet.Cells;
        
        cells[0, 0].PutValue("CoreID");
        cells[0, 1].PutValue("入库编号");
        cells[0, 2].PutValue("识别号");
        cells[0, 3].PutValue("工具名");
        cells[0, 4].PutValue("子工具名");
        
        Dictionary<String,int> PropertyNameDict =  new Dictionary<String,int>();
        String PropertyName;
        String ProprtryArrStr="";

        int curRow=1, curCol=5;
    
        if ((fw == 1 || fw == 0) && IDbn != "")
        {
            dt = MyManager.GetDataSet("SELECT rkID,A.*,B.StateName,C.StateName as RStateName FROM CoreTool AS A left join ToolState AS B on A.State = B.StateID left join ToolState AS C on A.RealState = C.StateID WHERE ModelType=1 AND  ID IN(" + IDbn + ") ORDER BY A.ToolName");//工具包
            dt1 = MyManager.GetDataSet("SELECT rkID,StateName,('V' + convert(varchar(10) ,A.ID)) as ID,A.ID as rID,[CoreID],[PropertyID],[Value] as name ,[ValueType],[ParentID],ToolID  FROM [CoreToolValue] AS A left join ToolState AS B on A.State = B.StateID WHERE (ValueType = 3 OR ValueType = 1) AND  CoreID IN(" + IDbn + ") ORDER BY ToolID ASC");//包内工具集合
            dt2 = MyManager.GetDataSet("SELECT rkID,B.Name,[Value],A.[ParentID] FROM [CoreToolValue] as A join ClassPropertys as B on A.propertyID = B.ID  where (ValueType = 4 or ValueType = 2) AND  CoreID IN(" + IDbn + ")");//属性集合
            for (i = 0; i < dt.Rows.Count; i++)
            {
               
                cells[curRow, 0].PutValue(dt.Rows[i]["ID"].ToString());
                cells[curRow, 1].PutValue(dt.Rows[i]["rkID"].ToString());
                cells[curRow, 2].PutValue(dt.Rows[i]["ToolID"].ToString());
                cells[curRow, 3].PutValue(dt.Rows[i]["ToolName"].ToString());
                

                dr = dt2.Select(" ParentID = " + dt.Rows[i]["ID"].ToString());
                for (ProprtryArrStr="",Note="",j = 0; j < dr.Length; j++)
                {
                   
                    PropertyName = dr[j]["name"].ToString().Trim();
                    
                    if (!PropertyNameDict.ContainsKey(PropertyName))
                    {
                        PropertyNameDict.Add(PropertyName, curCol);
                        cells[0, curCol].PutValue(PropertyName);
                        curCol++;
                    }
                    ProprtryArrStr +=  ",\"" + PropertyName + "\":\"" + dr[j]["Value"].ToString() + "\"";
                   
                    cells[curRow, PropertyNameDict[PropertyName]].PutValue(dr[j]["Value"].ToString());
                    Note += PropertyName + ":" + dr[j]["Value"].ToString().Trim() + "\r\n";
                   
                }
                sheet.Comments.Add(curRow, 3);
                sheet.Comments[curRow, 3].Note = Note;
                curRow++;
               
                dr = dt1.Select(" CoreID = " + dt.Rows[i]["ID"].ToString());
                for (j = 0; j < dr.Length; j++)
                {
                   

                    cells[curRow, 0].PutValue(dr[j]["CoreID"].ToString());
                    cells[curRow, 1].PutValue(dr[j]["rkID"].ToString());
                    cells[curRow, 2].PutValue(dr[j]["ToolID"].ToString());
                    cells[curRow, 3].PutValue("|-------");
                    cells[curRow, 4].PutValue(dr[j]["name"].ToString());
                    
                    
                    dr1 = dt2.Select(" ParentID = " + dr[j]["rID"].ToString());
                    for (k = 0,Note="", ProprtryArrStr=""; k < dr1.Length; k++)
                    {
                       
                        PropertyName = dr1[k]["name"].ToString().Trim();

                        if (!PropertyNameDict.ContainsKey(PropertyName))
                        {
                            PropertyNameDict.Add(PropertyName, curCol);
                            cells[0, curCol].PutValue(PropertyName);
                            curCol++;                            
                        }
                        ProprtryArrStr += ",\"" + PropertyName + "\":\"" + dr1[k]["Value"].ToString() + "\"";
                        
                        cells[curRow, PropertyNameDict[PropertyName]].PutValue(dr1[k]["Value"].ToString());
                       
                        Note += PropertyName + ":" + dr1[k]["Value"].ToString().Trim() + "\n\r";
                    }
                    sheet.Comments.Add(curRow,4);
                    sheet.Comments[curRow, 4].Note = Note;
                 
                    curRow++;
                   
                }

             
            }
        }

        if ((fw == 2 || fw == 0) && IDdl != "")
        {
            dt1 = MyManager.GetDataSet("SELECT A.ID,rkID,A.*,B.StateName,C.StateName as RStateName FROM CoreTool AS A left join ToolState AS B on A.State = B.StateID left join ToolState AS C on A.RealState = C.StateID WHERE ModelType = 0 AND ID IN(" + IDdl + ") ORDER BY A.ToolName");
            dt2 = MyManager.GetDataSet("SELECT rkID,B.Name,[Value],A.[CoreID] FROM [CoreToolValue] as A join ClassPropertys as B on A.propertyID = B.ID  where ValueType = 0 AND  CoreID IN(" + IDdl + ")");//属性集合
            for (i = 0; i < dt1.Rows.Count; i++)
            {


                cells[curRow, 0].PutValue(dt1.Rows[i]["ID"].ToString());
                cells[curRow, 1].PutValue(dt1.Rows[i]["rkID"].ToString());
                cells[curRow, 2].PutValue(dt1.Rows[i]["ToolID"].ToString());
                cells[curRow, 3].PutValue(dt1.Rows[i]["ToolName"].ToString());


                dr1 = dt2.Select(" CoreID = " + dt1.Rows[i]["ID"].ToString());
                for (k = 0, Note = "", ProprtryArrStr = ""; k < dr1.Length; k++)
                {

                    PropertyName = dr1[k]["name"].ToString().Trim();

                    if (!PropertyNameDict.ContainsKey(PropertyName))
                    {
                        PropertyNameDict.Add(PropertyName, curCol);
                        cells[0, curCol].PutValue(PropertyName);
                        curCol++;
                    }
                    ProprtryArrStr += ",\"" + PropertyName + "\":\"" + dr1[k]["Value"].ToString() + "\"";

                    cells[curRow, PropertyNameDict[PropertyName]].PutValue(dr1[k]["Value"].ToString());
                    Note += PropertyName + ":" + dr1[k]["Value"].ToString().Trim() + "\n\r";

                }
                sheet.Comments.Add(curRow, 3);
                sheet.Comments[curRow, 3].Note = Note;
                curRow++;
            }

        }
       

 
        XlsSaveOptions saveOptions = new XlsSaveOptions();
        String ExcelName = DateTime.Now.Ticks + ".xls";
        String Path = gCtx.Server.MapPath("~") + "\\Report\\" + ExcelName;
        workbook.Save(Path, saveOptions);
        String ExcelURL = "http://" + gCtx.Request.Url.Host + ":" + gCtx.Request.Url.Port + gCtx.Request.ApplicationPath + "/Report/" + ExcelName;


        return "{\"status\":\"success\",\"url\":\"" + ExcelURL + "\"}"; 
       //return "{\"status\":\"success\",\"data\":" + sw.ToString() + "}"; 
    }
    public String ToolSearch(JObject JO)/*对coretable中的工具进行查询，已经编号的*/
    {
        /*{ range: -1, name: "所有", ret:返回范围 "all"所有 "tool"工具 "bag"工具包, specific:[
         *                                                                              { tid: ToolClassID, name: ToolClassName, vals: [
         *                                                                                                                                  { name: PropertyName, pid: PropertyID, val: Value }
         * ] }
         * ] };*/

        /*这里返回的json中ToolType含义                  查询界面中按钮功能 
         *                  0:独立工具(ModeType)        修改属性、进包        
         *                  1:工具箱(CoreToolValue)     只能修改其属性 不能出包
         *                  3:工具箱中的工具            修改属性、独立、改包 
         *                  5:工具包                    修改其名称、拆包
         */
        String json = "";
        int i, j, k, fw = 0/*范围：0所有 1工具包 2 工具*/;
        String txt, SQL = "", SQL1 = "";
        String IDdlfw = "", IDdl = "", IDbn = "";//独立 和 包内 CoreID
        DataTable dt, dt1, dt2;
        DataRow[] dr, dr1;

        JObject Filter = (JObject)JO["Filter"];
        JArray Specific = (JArray)Filter["specific"];
        String rkID = JO["rkid"].ToString().Trim();
        String ToolID = JO["toolid"].ToString().Trim();
        String ToolName = JO["name"].ToString().Trim();
        if (Filter["range"].ToString() == "-1")
        {

            txt = Filter["ret"].ToString();
            if (txt == "all")
            {
                fw = 0;
            }
            else if (txt == "tool")
            {
                fw = 2;
            }
            else if (txt == "bag")
            {
                fw = 1;
            }

        }
        else
        {
            fw = 1;
        }
        String NameLike1 = " OR ToolName like'%" + ToolName + "%' ", NameLike2 = " OR (ValueType in(1,3) AND Value like'%" + ToolName + "%') ";
        if (ToolName == "" && (rkID!="" || ToolID!=""))
        {
            NameLike1 = NameLike2 = "";
        }
        String t_SQL = "SELECT distinct ID AS CoreID FROM CoreTool WHERE rkID ='" + rkID + "' OR ToolID ='" + ToolID + "' " + NameLike1 + "UNION SELECT distinct CoreID FROM CoreToolValue WHERE rkID='" + rkID + "' " + NameLike2 + " OR ToolID ='" + ToolID + "'";
        dt = MyManager.GetDataSet("SELECT distinct ID AS CoreID FROM CoreTool WHERE rkID ='" + rkID + "' OR ToolID ='" + ToolID + "' " + NameLike1 + "UNION SELECT distinct CoreID FROM CoreToolValue WHERE rkID='" + rkID + "' " + NameLike2 + " OR ToolID ='" + ToolID + "'");
        for (k = 0, IDdl = "", IDbn = ""/*每次需将IDbn清空，获取最新集合，然后继续筛选*/; k < dt.Rows.Count; k++)
        {
            IDbn += (IDbn == "" ? dt.Rows[k]["CoreID"].ToString() : "," + dt.Rows[k]["CoreID"].ToString());
            //IDdlfw += (IDdlfw == "" ? dt.Rows[k]["CoreID"].ToString() : "," + dt.Rows[k]["CoreID"].ToString());
        }

        if (IDbn != "")
        {
            IDdlfw = " AND ID IN(" + IDbn + ") ";
        }
        else if (rkID != "" || ToolName != "" || ToolID != "")//搜索条件不全为空，而搜索结果为空，证明根据搜索条件搜到的结果为空
        {
            IDdlfw = " AND ID IN('') ";
            IDbn = "''";
        }


        if (fw == 0 || fw == 1)
        {//所有 或 工具包


            for (i = 0; i < Specific.Count; i++)
            {
                SQL1 = "(SELECT distinct CoreID FROM CoreToolValue WHERE (ValueType = 3 or ValueType = 1) AND PropertyID = " + Specific[i]["tid"].ToString()
                        + (IDbn == "" ? "" : " AND CoreID IN(" + IDbn + ")") + ")";

                JArray JV = (JArray)Specific[i]["vals"];
                for (j = 0; j < JV.Count; j++)
                {
                    SQL1 += " Intersect ( SELECT CoreID FROM CoreToolValue WHERE ParentID IN(" + " SELECT ID FROM CoreToolValue WHERE (ValueType = 3 or ValueType = 1) AND PropertyID = " + Specific[i]["tid"].ToString() + (IDbn == "" ? "" : " AND CoreID IN(" + IDbn + ")") + ")" + " AND (ValueType = 4 OR ValueType = 2) AND PropertyID = " + JV[j]["pid"].ToString() + (JV[j]["val"].ToString() != "zkgy-1" ? " AND Value = '" + JV[j]["val"].ToString() + "')" : ")");
                }

                dt1 = MyManager.GetDataSet(SQL1);//工具包，将StoreID集合

                if (dt1.Rows.Count == 0)//count = 0 说明到这已经没有符合要求的工具包啦！！！直接退出循环.
                {
                    IDbn = "";
                    break;
                }

                for (k = 0, IDbn = ""/*每次需将IDbn清空，获取最新集合，然后继续筛选*/; k < dt1.Rows.Count; k++)
                {
                    IDbn += (IDbn == "" ? dt1.Rows[k]["CoreID"].ToString() : "," + dt1.Rows[k]["CoreID"].ToString());
                }
            }
            

        }

        if (fw == 2 || fw == 0)//独立工具或所有
        {
            for (i = 0; i < Specific.Count; i++)
            {
                SQL = "(SELECT distinct ID AS CoreID FROM CoreTool WHERE ModelType = 0 AND ModelID = " + Specific[i]["tid"].ToString() + IDdlfw + " )";

                JArray JV = (JArray)Specific[i]["vals"];
                for (j = 0; j < JV.Count; j++)
                {
                    SQL += " Intersect (SELECT distinct CoreID FROM [CoreToolValue] WHERE CoreID IN " + "(SELECT distinct ID AS StoredID FROM CoreTool WHERE ModelType = 0 AND ModelID = " + Specific[i]["tid"].ToString() + ")" + " AND ValueType = 0 AND PropertyID = " + JV[j]["pid"].ToString() + (JV[j]["val"].ToString() != "zkgy-1" ? " AND Value = '" + JV[j]["val"].ToString() + "')" : ")");
                }

                dt1 = MyManager.GetDataSet(SQL); //独立工具，将CoreID集合

                for (k = 0; k < dt1.Rows.Count; k++)
                {
                    IDdl += (IDdl == "" ? dt1.Rows[k]["CoreID"].ToString() : "," + dt1.Rows[k]["CoreID"].ToString());
                }
            }
            if (Specific.Count == 0)
            {
                IDdl = IDbn;  
            }
        }
        Aspose.Cells.Workbook workbook = new Aspose.Cells.Workbook(gCtx.Server.MapPath("~") + "\\Template\\kb.xls");
        Aspose.Cells.Worksheet sheet = workbook.Worksheets[0];
        Aspose.Cells.Cells cells = sheet.Cells;

        cells[0, 0].PutValue("CoreID");
        cells[0, 1].PutValue("入库编号");
        cells[0, 2].PutValue("识别号");
        cells[0, 3].PutValue("工具名");
        cells[0, 4].PutValue("子工具名");

        Dictionary<String, int> PropertyNameDict = new Dictionary<String, int>();
        String PropertyName;
        String ProprtryArrStr = "",Note="";
        StringWriter sw = new StringWriter();
        JsonWriter jWrite = new JsonTextWriter(sw);
        int curRow = 1, curCol = 5;
        jWrite.WriteStartArray();
        if ((fw == 1 || fw == 0) && IDbn != "")
        {
            dt = MyManager.GetDataSet("SELECT rkID,A.*,B.StateName,C.StateName as RStateName FROM CoreTool AS A left join ToolState AS B on A.State = B.StateID left join ToolState AS C on A.RealState = C.StateID WHERE ModelType=1 AND  ID IN(" + IDbn + ") ORDER BY ToolName");//工具包
            dt1 = MyManager.GetDataSet("SELECT rkID,StateName,('V' + convert(varchar(10) ,A.ID)) as ID,A.ID as rID,[CoreID],[PropertyID],[Value] as name ,[ValueType],[ParentID],ToolID  FROM [CoreToolValue] AS A left join ToolState AS B on A.State = B.StateID WHERE (ValueType = 3 OR ValueType = 1) AND  CoreID IN(" + IDbn + ") ORDER BY ToolID ASC");//包内工具集合
            dt2 = MyManager.GetDataSet("SELECT rkID,B.Name,[Value],A.[ParentID] FROM [CoreToolValue] as A join ClassPropertys as B on A.propertyID = B.ID  where (ValueType = 4 or ValueType = 2) AND  CoreID IN(" + IDbn + ")");//属性集合
            for (i = 0; i < dt.Rows.Count; i++)
            {
                jWrite.WriteStartObject();
                jWrite.WritePropertyName("id");
                jWrite.WriteValue(dt.Rows[i]["ID"].ToString());
                jWrite.WritePropertyName("rkid");
                
                cells[curRow, 0].PutValue(dt.Rows[i]["ID"].ToString());
                cells[curRow, 1].PutValue(dt.Rows[i]["rkID"].ToString());
                cells[curRow, 2].PutValue(dt.Rows[i]["ToolID"].ToString());
                cells[curRow, 3].PutValue(dt.Rows[i]["ToolName"].ToString());
                
                jWrite.WriteValue(dt.Rows[i]["rkID"].ToString());
                jWrite.WritePropertyName("toolid");
                jWrite.WriteValue(dt.Rows[i]["toolid"].ToString());
                jWrite.WritePropertyName("posx");
                jWrite.WriteValue(dt.Rows[i]["PosX"].ToString());
                jWrite.WritePropertyName("posy");
                jWrite.WriteValue(dt.Rows[i]["PosY"].ToString());
                jWrite.WritePropertyName("lastseen");
                jWrite.WriteValue(dt.Rows[i]["LastSeen"].ToString());
                jWrite.WritePropertyName("toolstate");
                jWrite.WriteValue(dt.Rows[i]["StateName"].ToString());
                jWrite.WritePropertyName("realtoolstate");
                jWrite.WriteValue(dt.Rows[i]["RStateName"].ToString());
                jWrite.WritePropertyName("name");
                jWrite.WriteValue(dt.Rows[i]["ToolName"].ToString());
                jWrite.WritePropertyName("modifytime");
                jWrite.WriteValue(dt.Rows[i]["ModifyTime"].ToString());
                jWrite.WritePropertyName("iconCls");
                jWrite.WriteValue("icon-toolbag");
                jWrite.WritePropertyName("state");
                jWrite.WriteValue("closed");
                jWrite.WritePropertyName("type");
                jWrite.WriteValue("bag");
                jWrite.WritePropertyName("tooltype");
                jWrite.WriteValue("5");
                jWrite.WritePropertyName("opt");
                jWrite.WriteValue("查看");
                jWrite.WritePropertyName("sx");
                jWrite.WriteStartArray();
                dr = dt2.Select(" ParentID = " + dt.Rows[i]["ID"].ToString());
                for (ProprtryArrStr = "",Note="", j = 0; j < dr.Length; j++)
                {
                    jWrite.WriteStartObject();
                    jWrite.WritePropertyName("name");
                    PropertyName = dr[j]["name"].ToString().Trim();

                    if (!PropertyNameDict.ContainsKey(PropertyName))
                    {
                        PropertyNameDict.Add(PropertyName, curCol);
                        cells[0, curCol].PutValue(PropertyName);
                        curCol++;
                    }
                    ProprtryArrStr += ",\"" + PropertyName + "\":\"" + dr[j]["Value"].ToString() + "\"";
                    jWrite.WriteValue(PropertyName);
                    jWrite.WritePropertyName("value");
                    jWrite.WriteValue(dr[j]["Value"].ToString());
                    cells[curRow, PropertyNameDict[PropertyName]].PutValue(dr[j]["Value"].ToString());
                    Note += PropertyName + ":" + dr[j]["Value"].ToString().Trim() + "\r\n";
                    jWrite.WriteEndObject();
                }
                sheet.Comments.Add(curRow, 3);
                sheet.Comments[curRow, 3].Note = Note;
                curRow++;
                jWrite.WriteEndArray();
                jWrite.WriteRaw(ProprtryArrStr);
                jWrite.WritePropertyName("children");
                jWrite.WriteStartArray();
                dr = dt1.Select(" CoreID = " + dt.Rows[i]["ID"].ToString());
                for (j = 0; j < dr.Length; j++)
                {
                    jWrite.WriteStartObject();

                   
                    cells[curRow, 0].PutValue(dr[j]["CoreID"].ToString());
                    cells[curRow, 1].PutValue(dr[j]["rkID"].ToString());
                    cells[curRow, 2].PutValue(dr[j]["ToolID"].ToString());
                    cells[curRow, 3].PutValue("|-------");
                    cells[curRow, 4].PutValue(dr[j]["name"].ToString());
                   

                    jWrite.WritePropertyName("id");
                    jWrite.WriteValue(dr[j]["ID"].ToString());
                    jWrite.WritePropertyName("rkid");
                    jWrite.WriteValue(dr[j]["rkID"].ToString());
                    jWrite.WritePropertyName("toolid");
                    jWrite.WriteValue(dr[j]["toolid"].ToString());
                    //jWrite.WritePropertyName("toolstate");
                    //jWrite.WriteValue(dr[j]["StateName"].ToString());
                    jWrite.WritePropertyName("name");
                    jWrite.WriteValue(dr[j]["name"].ToString());
                    jWrite.WritePropertyName("iconCls");
                    jWrite.WriteValue("icon-tool");
                    jWrite.WritePropertyName("type");
                    jWrite.WriteValue("bntool");
                    jWrite.WritePropertyName("tooltype");
                    jWrite.WriteValue(dr[j]["ValueType"].ToString());
                    jWrite.WritePropertyName("bagid");
                    jWrite.WriteValue(dt.Rows[i]["toolid"].ToString());
                    jWrite.WritePropertyName("bagname");
                    jWrite.WriteValue(dt.Rows[i]["ToolName"].ToString());
                    jWrite.WritePropertyName("classid");
                    jWrite.WriteValue(dr[j]["propertyid"].ToString());
                    jWrite.WritePropertyName("opt");
                    jWrite.WriteValue("修改");
                    jWrite.WritePropertyName("sx");
                    jWrite.WriteStartArray();
                    dr1 = dt2.Select(" ParentID = " + dr[j]["rID"].ToString());
                    for (k = 0, ProprtryArrStr = "",Note=""; k < dr1.Length; k++)
                    {
                        jWrite.WriteStartObject();
                        jWrite.WritePropertyName("name");
                        jWrite.WriteValue(dr1[k]["name"].ToString().Trim());
                        PropertyName = dr1[k]["name"].ToString().Trim();

                        if (!PropertyNameDict.ContainsKey(PropertyName))
                        {
                            PropertyNameDict.Add(PropertyName, curCol);
                           cells[0, curCol].PutValue(PropertyName);
                            curCol++;
                        }
                        ProprtryArrStr += ",\"" + PropertyName + "\":\"" + dr1[k]["Value"].ToString() + "\"";
                        jWrite.WritePropertyName("value");
                        jWrite.WriteValue(dr1[k]["Value"].ToString());
                       cells[curRow, PropertyNameDict[PropertyName]].PutValue(dr1[k]["Value"].ToString());
                        jWrite.WriteEndObject();
                         Note += PropertyName + ":" + dr1[k]["Value"].ToString().Trim() + "\r\n";

                    }
                   sheet.Comments.Add(curRow, 3);
                   sheet.Comments[curRow, 3].Note = Note;
                    curRow++;
                    jWrite.WriteEndArray();
                    jWrite.WriteRaw(ProprtryArrStr);
                    jWrite.WriteEndObject();
                }

                jWrite.WriteEndArray();
                jWrite.WriteEndObject();
            }
        }

        if ((fw == 2 || fw == 0) && IDdl != "")
        {
            dt1 = MyManager.GetDataSet("SELECT A.ID,rkID,A.*,B.StateName,C.StateName as RStateName FROM CoreTool AS A left join ToolState AS B on A.State = B.StateID left join ToolState AS C on A.RealState = C.StateID WHERE ModelType = 0 AND ID IN(" + IDdl + ") ORDER BY ToolName");
            dt2 = MyManager.GetDataSet("SELECT rkID,B.Name,[Value],A.[CoreID] FROM [CoreToolValue] as A join ClassPropertys as B on A.propertyID = B.ID  where ValueType = 0 AND  CoreID IN(" + IDdl + ")");//属性集合
            for (i = 0; i < dt1.Rows.Count; i++)
            {
                jWrite.WriteStartObject();
                
                
                cells[curRow, 0].PutValue(dt1.Rows[i]["ID"].ToString());
                cells[curRow, 1].PutValue(dt1.Rows[i]["rkID"].ToString());
                cells[curRow, 2].PutValue(dt1.Rows[i]["ToolID"].ToString());
                cells[curRow, 3].PutValue(dt1.Rows[i]["ToolName"].ToString());
                
                
                jWrite.WritePropertyName("id");
                jWrite.WriteValue(dt1.Rows[i]["ID"].ToString());
                jWrite.WritePropertyName("name");
                jWrite.WriteValue(dt1.Rows[i]["ToolName"].ToString());
                jWrite.WritePropertyName("rkid");
                jWrite.WriteValue(dt1.Rows[i]["rkID"].ToString());
                jWrite.WritePropertyName("toolstate");
                jWrite.WriteValue(dt1.Rows[i]["statename"].ToString());
                jWrite.WritePropertyName("realtoolstate");
                jWrite.WriteValue(dt1.Rows[i]["RStateName"].ToString());
                jWrite.WritePropertyName("toolid");
                jWrite.WriteValue(dt1.Rows[i]["toolid"].ToString());
                jWrite.WritePropertyName("modifytime");
                jWrite.WriteValue(dt1.Rows[i]["ModifyTime"].ToString());
                jWrite.WritePropertyName("classid");
                jWrite.WriteValue(dt1.Rows[i]["ModelID"].ToString());
                jWrite.WritePropertyName("iconCls");
                jWrite.WriteValue("icon-tool");
                jWrite.WritePropertyName("tooltype");
                jWrite.WriteValue("0");
                jWrite.WritePropertyName("type");
                jWrite.WriteValue("tool");
                jWrite.WritePropertyName("opt");
                jWrite.WriteValue("修改");
                jWrite.WritePropertyName("sx");
                jWrite.WriteStartArray();
                dr1 = dt2.Select(" CoreID = " + dt1.Rows[i]["ID"].ToString());
                for (k = 0, ProprtryArrStr = "",Note=""; k < dr1.Length; k++)
                {
                    jWrite.WriteStartObject();
                    jWrite.WritePropertyName("name");
                    PropertyName = dr1[k]["name"].ToString().Trim();

                    if (!PropertyNameDict.ContainsKey(PropertyName))
                    {
                        PropertyNameDict.Add(PropertyName, curCol);
                        cells[0, curCol].PutValue(PropertyName);
                        curCol++;
                    }
                    ProprtryArrStr += ",\"" + PropertyName + "\":\"" + dr1[k]["Value"].ToString() + "\"";
                    jWrite.WriteValue(dr1[k]["name"].ToString().Trim());
                    jWrite.WritePropertyName("value");
                    jWrite.WriteValue(dr1[k]["Value"].ToString());
                    cells[curRow, PropertyNameDict[PropertyName]].PutValue(dr1[k]["Value"].ToString());
                    jWrite.WriteEndObject();
                    Note += PropertyName + ":" + dr1[k]["Value"].ToString().Trim() + "\r\n";

                }
                sheet.Comments.Add(curRow, 3);
                sheet.Comments[curRow, 3].Note = Note;
                curRow++;
                jWrite.WriteEndArray();
                jWrite.WriteRaw(ProprtryArrStr);
                jWrite.WriteEndObject();
            }

        }
        jWrite.WriteEndArray();
        String newColumns = "[";
        foreach (String Key in PropertyNameDict.Keys)
        {
            newColumns += (newColumns == "[" ? "" : ",") + "\"" + Key + "\"";
        }

        newColumns += "]";


        XlsSaveOptions saveOptions = new XlsSaveOptions();
        String ExcelName = DateTime.Now.Ticks + ".xls";
        String Path = gCtx.Server.MapPath("~") + "\\Report\\" + ExcelName;
        workbook.Save(Path, saveOptions);
        String ExcelURL = "http://" + gCtx.Request.Url.Host + ":" + gCtx.Request.Url.Port + gCtx.Request.ApplicationPath + "/Report/" + ExcelName;


        return "{\"status\":\"success\",\"url\":\"" + ExcelURL + "\",\"data\":" + sw.ToString() + ",\"newcolumns" + "\":" + newColumns + "}";
        //return "{\"status\":\"success\",\"data\":" + sw.ToString() + "}"; 
    }

    public String ToolSearchForCheck(JObject JO)/*对coretable中的工具进行查询,顺便设定盘库标示*/
    {
        /*{ range: -1, name: "所有", ret:返回范围 "all"所有 "tool"工具 "bag"工具包, specific:[
         *                                                                              { tid: ToolClassID, name: ToolClassName, vals: [
         *                                                                                                                                  { name: PropertyName, pid: PropertyID, val: Value }
         * ] }
         * ] };*/

        /*这里返回的json中ToolType含义                  查询界面中按钮功能 
         *                  0:独立工具(ModeType)        修改属性、进包        
         *                  1:工具箱(CoreToolValue)     只能修改其属性 不能出包
         *                  3:工具箱中的工具            修改属性、独立、改包 
         *                  5:工具包                    修改其名称、拆包
         */
        String json = "";
        int i, j, k, fw = 0/*范围：0所有 1工具包 2 工具*/;
        String txt, SQL = "", SQL1 = "";
        String IDdlfw = "", IDdl = "", IDbn = "";//独立 和 包内 CoreID
        DataTable dt, dt1, dt2;
        DataRow[] dr, dr1;

        JObject Filter = (JObject)JO["Filter"];
        JArray Specific = (JArray)Filter["specific"];
        String rkID = JO["rkid"].ToString().Trim();
        String ToolID = JO["toolid"].ToString().Trim();
        String ToolName = JO["name"].ToString().Trim();
        String CheckCode = JO["curcheckcode"].ToString().Trim();
        String CheckType = JO["querytype"].ToString().Trim();//0:普通查询 1:按查询标记查询

        if (CheckType == "0")
        {
            if (Filter["range"].ToString() == "-1")
            {

                txt = Filter["ret"].ToString();
                if (txt == "all")
                {
                    fw = 0;
                }
                else if (txt == "tool")
                {
                    fw = 2;
                }
                else if (txt == "bag")
                {
                    fw = 1;
                }

            }
            else
            {
                fw = 1;
            }
            String NameLike1 = " OR ToolName like'%" + ToolName + "%' ", NameLike2 = " OR (ValueType in(1,3) AND Value like'%" + ToolName + "%') ";
            if (ToolName == "" && (rkID != "" || ToolID != ""))
            {
                NameLike1 = NameLike2 = "";
            }
            String t_SQL = "SELECT distinct ID AS CoreID FROM CoreTool WHERE rkID ='" + rkID + "' OR ToolID ='" + ToolID + "' " + NameLike1 + "UNION SELECT distinct CoreID FROM CoreToolValue WHERE rkID='" + rkID + "' " + NameLike2 + " OR ToolID ='" + ToolID + "'";
            dt = MyManager.GetDataSet("SELECT distinct ID AS CoreID FROM CoreTool WHERE rkID ='" + rkID + "' OR ToolID ='" + ToolID + "' " + NameLike1 + "UNION SELECT distinct CoreID FROM CoreToolValue WHERE rkID='" + rkID + "' " + NameLike2 + " OR ToolID ='" + ToolID + "'");
            for (k = 0, IDdl = "", IDbn = ""/*每次需将IDbn清空，获取最新集合，然后继续筛选*/; k < dt.Rows.Count; k++)
            {
                IDbn += (IDbn == "" ? dt.Rows[k]["CoreID"].ToString() : "," + dt.Rows[k]["CoreID"].ToString());
                //IDdlfw += (IDdlfw == "" ? dt.Rows[k]["CoreID"].ToString() : "," + dt.Rows[k]["CoreID"].ToString());
            }

            if (IDbn != "")
            {
                IDdlfw = " AND ID IN(" + IDbn + ") ";
            }
            else if (rkID != "" || ToolName != "" || ToolID != "")//搜索条件不全为空，而搜索结果为空，证明根据搜索条件搜到的结果为空
            {
                IDdlfw = " AND ID IN('') ";
                IDbn = "''";
            }


            if (fw == 0 || fw == 1)
            {//所有 或 工具包


                for (i = 0; i < Specific.Count; i++)
                {
                    SQL1 = "(SELECT distinct CoreID FROM CoreToolValue WHERE (ValueType = 3 or ValueType = 1) AND PropertyID = " + Specific[i]["tid"].ToString()
                            + (IDbn == "" ? "" : " AND CoreID IN(" + IDbn + ")") + ")";

                    JArray JV = (JArray)Specific[i]["vals"];
                    for (j = 0; j < JV.Count; j++)
                    {
                        SQL1 += " Intersect ( SELECT CoreID FROM CoreToolValue WHERE ParentID IN(" + " SELECT ID FROM CoreToolValue WHERE (ValueType = 3 or ValueType = 1) AND PropertyID = " + Specific[i]["tid"].ToString() + (IDbn == "" ? "" : " AND CoreID IN(" + IDbn + ")") + ")" + " AND (ValueType = 4 OR ValueType = 2) AND PropertyID = " + JV[j]["pid"].ToString() + (JV[j]["val"].ToString() != "zkgy-1" ? " AND Value = '" + JV[j]["val"].ToString() + "')" : ")");
                    }

                    dt1 = MyManager.GetDataSet(SQL1);//工具包，将StoreID集合

                    if (dt1.Rows.Count == 0)//count = 0 说明到这已经没有符合要求的工具包啦！！！直接退出循环.
                    {
                        IDbn = "";
                        break;
                    }

                    for (k = 0, IDbn = ""/*每次需将IDbn清空，获取最新集合，然后继续筛选*/; k < dt1.Rows.Count; k++)
                    {
                        IDbn += (IDbn == "" ? dt1.Rows[k]["CoreID"].ToString() : "," + dt1.Rows[k]["CoreID"].ToString());
                    }
                }


            }

            if (fw == 2 || fw == 0)//独立工具或所有
            {
                for (i = 0; i < Specific.Count; i++)
                {
                    SQL = "(SELECT distinct ID AS CoreID FROM CoreTool WHERE ModelType = 0 AND ModelID = " + Specific[i]["tid"].ToString() + IDdlfw + " )";

                    JArray JV = (JArray)Specific[i]["vals"];
                    for (j = 0; j < JV.Count; j++)
                    {
                        SQL += " Intersect (SELECT distinct CoreID FROM [CoreToolValue] WHERE CoreID IN " + "(SELECT distinct ID AS StoredID FROM CoreTool WHERE ModelType = 0 AND ModelID = " + Specific[i]["tid"].ToString() + ")" + " AND ValueType = 0 AND PropertyID = " + JV[j]["pid"].ToString() + (JV[j]["val"].ToString() != "zkgy-1" ? " AND Value = '" + JV[j]["val"].ToString() + "')" : ")");
                    }

                    dt1 = MyManager.GetDataSet(SQL); //独立工具，将CoreID集合

                    for (k = 0; k < dt1.Rows.Count; k++)
                    {
                        IDdl += (IDdl == "" ? dt1.Rows[k]["CoreID"].ToString() : "," + dt1.Rows[k]["CoreID"].ToString());
                    }
                }
                if (Specific.Count == 0)
                {
                    IDdl = IDbn;
                }
            }

            if (IDdl == "") {
                IDdl = "''";
            }
            if (IDbn == "")
            {
                IDbn = "''"; 
            }
             
            //所有筛选出来的工具CoreID都在IDdl与IDbn中,现在要把他们中status为0的标记上CheckCode

            MyManager.ExecSQL("UPDATE CoreTool SET TmpCheckCode ='" + CheckCode + "' WHERE (ID IN(" + IDbn + ") OR ID IN(" + IDdl + "))");
        }
        else
        {
            fw = 0;
            IDbn = " ";//
            IDdl = " ";//很重要，否则无法输出
        }     
        Aspose.Cells.Workbook workbook = new Aspose.Cells.Workbook(gCtx.Server.MapPath("~") + "\\Template\\kb.xls");
        Aspose.Cells.Worksheet sheet = workbook.Worksheets[0];
        Aspose.Cells.Cells cells = sheet.Cells;

        cells[0, 0].PutValue("CoreID");
        cells[0, 1].PutValue("入库编号");
        cells[0, 2].PutValue("识别号");
        cells[0, 3].PutValue("工具名");
        cells[0, 4].PutValue("子工具名");

        Dictionary<String, int> PropertyNameDict = new Dictionary<String, int>();
        String PropertyName;
        String ProprtryArrStr = "", Note = "";
        StringWriter sw = new StringWriter();
        JsonWriter jWrite = new JsonTextWriter(sw);
        int curRow = 1, curCol = 5;
        jWrite.WriteStartArray();

        
        if ((fw == 1 || fw == 0) && IDbn != "")
        {
            dt = MyManager.GetDataSet("SELECT CheckInfo,PosID,CheckStatus,rkID,A.*,B.StateName,C.StateName as RStateName FROM CoreTool AS A left join ToolState AS B on A.State = B.StateID left join ToolState AS C on A.RealState = C.StateID WHERE ModelType=1 AND  ID IN(" + (CheckType == "0" ? IDbn : " SELECT CoreID AS ID FROM CheckRelation WHERE CheckCode='" + CheckCode + "'") + ") ORDER BY ToolName");//工具包
            dt1 = MyManager.GetDataSet("SELECT rkID,StateName,('V' + convert(varchar(10) ,A.ID)) as ID,A.ID as rID,[CoreID],[PropertyID],[Value] as name ,[ValueType],[ParentID],ToolID  FROM [CoreToolValue] AS A left join ToolState AS B on A.State = B.StateID WHERE (ValueType = 3 OR ValueType = 1) AND  CoreID IN(" + (CheckType == "0" ? IDbn : " SELECT CoreID  FROM CheckRelation WHERE CheckCode='" + CheckCode + "'") + ") ORDER BY ToolID ASC");//包内工具集合
            dt2 = MyManager.GetDataSet("SELECT rkID,B.Name,[Value],A.[ParentID] FROM [CoreToolValue] as A join ClassPropertys as B on A.propertyID = B.ID  where (ValueType = 4 or ValueType = 2) AND  CoreID IN(" + (CheckType == "0" ? IDbn : " SELECT CoreID   FROM CheckRelation WHERE CheckCode='" + CheckCode + "'") + ")");//属性集合
            
            for (i = 0; i < dt.Rows.Count; i++)
            {
                jWrite.WriteStartObject();
                jWrite.WritePropertyName("id");
                jWrite.WriteValue(dt.Rows[i]["ID"].ToString());
                jWrite.WritePropertyName("rkid");

                cells[curRow, 0].PutValue(dt.Rows[i]["ID"].ToString());
                cells[curRow, 1].PutValue(dt.Rows[i]["rkID"].ToString());
                cells[curRow, 2].PutValue(dt.Rows[i]["ToolID"].ToString());
                cells[curRow, 3].PutValue(dt.Rows[i]["ToolName"].ToString());

                jWrite.WriteValue(dt.Rows[i]["rkID"].ToString());
                jWrite.WritePropertyName("toolid");
                jWrite.WriteValue(dt.Rows[i]["toolid"].ToString());
                jWrite.WritePropertyName("posx");
                jWrite.WriteValue(dt.Rows[i]["PosX"].ToString());
                jWrite.WritePropertyName("posy");
                jWrite.WriteValue(dt.Rows[i]["PosY"].ToString());
                jWrite.WritePropertyName("lastseen");
                jWrite.WriteValue(dt.Rows[i]["LastSeen"].ToString());
                jWrite.WritePropertyName("toolstate");
                jWrite.WriteValue(dt.Rows[i]["StateName"].ToString());
                jWrite.WritePropertyName("realtoolstate");
                jWrite.WriteValue(dt.Rows[i]["RStateName"].ToString());
                jWrite.WritePropertyName("name");
                jWrite.WriteValue(dt.Rows[i]["ToolName"].ToString());
                jWrite.WritePropertyName("modifytime");
                jWrite.WriteValue(dt.Rows[i]["ModifyTime"].ToString());
                jWrite.WritePropertyName("posid");
                jWrite.WriteValue(dt.Rows[i]["PosID"].ToString());
                jWrite.WritePropertyName("iconCls");
                jWrite.WriteValue("icon-toolbag");
                jWrite.WritePropertyName("state");
                jWrite.WriteValue("closed");
                jWrite.WritePropertyName("type");
                jWrite.WriteValue("bag");
                jWrite.WritePropertyName("tooltype");
                jWrite.WriteValue("5");
                jWrite.WritePropertyName("opt");
                jWrite.WriteValue("查看");
                jWrite.WritePropertyName("sx");
                jWrite.WriteStartArray();
                dr = dt2.Select(" ParentID = " + dt.Rows[i]["ID"].ToString());
                for (ProprtryArrStr = "", Note = "", j = 0; j < dr.Length; j++)
                {
                    jWrite.WriteStartObject();
                    jWrite.WritePropertyName("name");
                    PropertyName = dr[j]["name"].ToString().Trim();

                    if (!PropertyNameDict.ContainsKey(PropertyName))
                    {
                        PropertyNameDict.Add(PropertyName, curCol);
                        cells[0, curCol].PutValue(PropertyName);
                        curCol++;
                    }
                    ProprtryArrStr += ",\"" + PropertyName + "\":\"" + dr[j]["Value"].ToString() + "\"";
                    jWrite.WriteValue(PropertyName);
                    jWrite.WritePropertyName("value");
                    jWrite.WriteValue(dr[j]["Value"].ToString());
                    cells[curRow, PropertyNameDict[PropertyName]].PutValue(dr[j]["Value"].ToString());
                    Note += PropertyName + ":" + dr[j]["Value"].ToString().Trim() + "\r\n";
                    jWrite.WriteEndObject();
                }
                sheet.Comments.Add(curRow, 3);
                sheet.Comments[curRow, 3].Note = Note;
                curRow++;
                jWrite.WriteEndArray();
                jWrite.WriteRaw(ProprtryArrStr);
                jWrite.WritePropertyName("children");
                jWrite.WriteStartArray();
                dr = dt1.Select(" CoreID = " + dt.Rows[i]["ID"].ToString());
                for (j = 0; j < dr.Length; j++)
                {
                    jWrite.WriteStartObject();


                    cells[curRow, 0].PutValue(dr[j]["CoreID"].ToString());
                    cells[curRow, 1].PutValue(dr[j]["rkID"].ToString());
                    cells[curRow, 2].PutValue(dr[j]["ToolID"].ToString());
                    cells[curRow, 3].PutValue("|-------");
                    cells[curRow, 4].PutValue(dr[j]["name"].ToString());


                    jWrite.WritePropertyName("id");
                    jWrite.WriteValue(dr[j]["ID"].ToString());
                    jWrite.WritePropertyName("rkid");
                    jWrite.WriteValue(dr[j]["rkID"].ToString());
                    jWrite.WritePropertyName("toolid");
                    jWrite.WriteValue(dr[j]["toolid"].ToString());
                    //jWrite.WritePropertyName("toolstate");
                    //jWrite.WriteValue(dr[j]["StateName"].ToString());
                    jWrite.WritePropertyName("name");
                    jWrite.WriteValue(dr[j]["name"].ToString());
                    jWrite.WritePropertyName("iconCls");
                    jWrite.WriteValue("icon-tool");
                    jWrite.WritePropertyName("type");
                    jWrite.WriteValue("bntool");
                    jWrite.WritePropertyName("tooltype");
                    jWrite.WriteValue(dr[j]["ValueType"].ToString());
                    jWrite.WritePropertyName("bagid");
                    jWrite.WriteValue(dt.Rows[i]["toolid"].ToString());
                    jWrite.WritePropertyName("bagname");
                    jWrite.WriteValue(dt.Rows[i]["ToolName"].ToString());
                    jWrite.WritePropertyName("classid");
                    jWrite.WriteValue(dr[j]["propertyid"].ToString());
                    jWrite.WritePropertyName("opt");
                    jWrite.WriteValue("修改");
                    jWrite.WritePropertyName("sx");
                    jWrite.WriteStartArray();
                    dr1 = dt2.Select(" ParentID = " + dr[j]["rID"].ToString());
                    for (k = 0, ProprtryArrStr = "", Note = ""; k < dr1.Length; k++)
                    {
                        jWrite.WriteStartObject();
                        jWrite.WritePropertyName("name");
                        jWrite.WriteValue(dr1[k]["name"].ToString().Trim());
                        PropertyName = dr1[k]["name"].ToString().Trim();

                        if (!PropertyNameDict.ContainsKey(PropertyName))
                        {
                            PropertyNameDict.Add(PropertyName, curCol);
                            cells[0, curCol].PutValue(PropertyName);
                            curCol++;
                        }
                        ProprtryArrStr += ",\"" + PropertyName + "\":\"" + dr1[k]["Value"].ToString() + "\"";
                        jWrite.WritePropertyName("value");
                        jWrite.WriteValue(dr1[k]["Value"].ToString());
                        cells[curRow, PropertyNameDict[PropertyName]].PutValue(dr1[k]["Value"].ToString());
                        jWrite.WriteEndObject();
                        Note += PropertyName + ":" + dr1[k]["Value"].ToString().Trim() + "\r\n";

                    }
                    sheet.Comments.Add(curRow, 3);
                    sheet.Comments[curRow, 3].Note = Note;
                    curRow++;
                    jWrite.WriteEndArray();
                    jWrite.WriteRaw(ProprtryArrStr);
                    jWrite.WriteEndObject();
                }

                jWrite.WriteEndArray();
                jWrite.WriteEndObject();
            }
        }

        if ((fw == 2 || fw == 0) && IDdl != "")
        {
            dt1 = MyManager.GetDataSet("SELECT CheckInfo,PosID,CheckStatus,A.ID,rkID,A.*,B.StateName,C.StateName as RStateName FROM CoreTool AS A left join ToolState AS B on A.State = B.StateID left join ToolState AS C on A.RealState = C.StateID WHERE ModelType = 0 AND ID IN(" + (CheckType == "0" ? IDdl : " SELECT CoreID AS ID  FROM CheckRelation WHERE CheckCode='" + CheckCode + "'") + ") ORDER BY ToolName");//独立工具
            dt2 = MyManager.GetDataSet("SELECT rkID,B.Name,[Value],A.[CoreID] FROM [CoreToolValue] as A join ClassPropertys as B on A.propertyID = B.ID  where ValueType = 0 AND  CoreID IN(" + (CheckType == "0" ? IDdl : " SELECT CoreID   FROM CheckRelation WHERE CheckCode='" + CheckCode + "'") + ")");//属性集合
           
            for (i = 0; i < dt1.Rows.Count; i++)
            {
                jWrite.WriteStartObject();


                cells[curRow, 0].PutValue(dt1.Rows[i]["ID"].ToString());
                cells[curRow, 1].PutValue(dt1.Rows[i]["rkID"].ToString());
                cells[curRow, 2].PutValue(dt1.Rows[i]["ToolID"].ToString());
                cells[curRow, 3].PutValue(dt1.Rows[i]["ToolName"].ToString());


                jWrite.WritePropertyName("id");
                jWrite.WriteValue(dt1.Rows[i]["ID"].ToString());
                jWrite.WritePropertyName("name");
                jWrite.WriteValue(dt1.Rows[i]["ToolName"].ToString());
                jWrite.WritePropertyName("rkid");
                jWrite.WriteValue(dt1.Rows[i]["rkID"].ToString());
                jWrite.WritePropertyName("toolstate");
                jWrite.WriteValue(dt1.Rows[i]["statename"].ToString());
                jWrite.WritePropertyName("realtoolstate");
                jWrite.WriteValue(dt1.Rows[i]["RStateName"].ToString());
                jWrite.WritePropertyName("toolid");
                jWrite.WriteValue(dt1.Rows[i]["toolid"].ToString());
                jWrite.WritePropertyName("modifytime");
                jWrite.WriteValue(dt1.Rows[i]["ModifyTime"].ToString());
                jWrite.WritePropertyName("posid");
                jWrite.WriteValue(dt1.Rows[i]["PosID"].ToString());
                jWrite.WritePropertyName("classid");
                jWrite.WriteValue(dt1.Rows[i]["ModelID"].ToString());

                jWrite.WritePropertyName("checkinfo");
                jWrite.WriteValue(dt1.Rows[i]["CheckInfo"].ToString());

                jWrite.WritePropertyName("checkstatus");

                if (dt1.Rows[i]["CheckStatus"].ToString() == "1")
                {
                    jWrite.WriteValue("盘点中...");
                }
                else
                {
                    jWrite.WriteValue("待盘点");
                }
                
                jWrite.WritePropertyName("iconCls");
                jWrite.WriteValue("icon-tool");
                jWrite.WritePropertyName("tooltype");
                jWrite.WriteValue("0");
                jWrite.WritePropertyName("type");
                jWrite.WriteValue("tool");
                jWrite.WritePropertyName("opt");
                jWrite.WriteValue("修改");
                jWrite.WritePropertyName("sx");
                jWrite.WriteStartArray();
                dr1 = dt2.Select(" CoreID = " + dt1.Rows[i]["ID"].ToString());
                for (k = 0, ProprtryArrStr = "", Note = ""; k < dr1.Length; k++)
                {
                    jWrite.WriteStartObject();
                    jWrite.WritePropertyName("name");
                    PropertyName = dr1[k]["name"].ToString().Trim();

                    if (!PropertyNameDict.ContainsKey(PropertyName))
                    {
                        PropertyNameDict.Add(PropertyName, curCol);
                        cells[0, curCol].PutValue(PropertyName);
                        curCol++;
                    }
                    ProprtryArrStr += ",\"" + PropertyName + "\":\"" + dr1[k]["Value"].ToString() + "\"";
                    jWrite.WriteValue(dr1[k]["name"].ToString().Trim());
                    jWrite.WritePropertyName("value");
                    jWrite.WriteValue(dr1[k]["Value"].ToString());
                    cells[curRow, PropertyNameDict[PropertyName]].PutValue(dr1[k]["Value"].ToString());
                    jWrite.WriteEndObject();
                    Note += PropertyName + ":" + dr1[k]["Value"].ToString().Trim() + "\r\n";

                }
                sheet.Comments.Add(curRow, 3);
                sheet.Comments[curRow, 3].Note = Note;
                curRow++;
                jWrite.WriteEndArray();
                jWrite.WriteRaw(ProprtryArrStr);
                jWrite.WriteEndObject();
            }

        }
        jWrite.WriteEndArray();
        String newColumns = "[";
        foreach (String Key in PropertyNameDict.Keys)
        {
            newColumns += (newColumns == "[" ? "" : ",") + "\"" + Key + "\"";
        }

        newColumns += "]";


        XlsSaveOptions saveOptions = new XlsSaveOptions();
        String ExcelName = DateTime.Now.Ticks + ".xls";
        String Path = gCtx.Server.MapPath("~") + "\\Report\\" + ExcelName;
        workbook.Save(Path, saveOptions);
        String ExcelURL = "http://" + gCtx.Request.Url.Host + ":" + gCtx.Request.Url.Port + gCtx.Request.ApplicationPath + "/Report/" + ExcelName;


        return "{\"status\":\"success\",\"url\":\"" + ExcelURL + "\",\"data\":" + sw.ToString() + ",\"newcolumns" + "\":" + newColumns + "}";
        //return "{\"status\":\"success\",\"data\":" + sw.ToString() + "}"; 
    }
    
    public String StoreSearch(JObject JO)
    {
        /*{ range: -1, name: "所有", ret: "all", specific:[
         *                                                 { tid: ToolClassID, name: ToolClassName, vals: [
         *                                                                                                  { name: PropertyName, pid: PropertyID, val: Value }
         * ] }
         * ] };*/
        String json="";
        int i, j, k,fw = 0/*0所有 1工具包 2 工具*/;
        String txt, SQL = "", SQL1 = "";
        String IDdl = "", IDbn = "";//独立 和 包内
        DataTable dt,dt1,dt2;
        DataRow[] dr,dr1;
        
        JObject Filter = (JObject)JO["Filter"];
        JArray Specific = (JArray)Filter["specific"];
        
        if (Filter["range"].ToString() == "-1"){
            
            txt = Filter["ret"].ToString();
            if (txt == "all"){
                fw = 0;
            }
            else if (txt == "tool"){
                fw = 2;
            }
            else if (txt =="bag"){
                fw = 1;
            }

        }
        else
        {
            fw = 1;
        }

        if (fw == 0 || fw ==1 ) {//所有 或 工具包

            IDbn = "";       
            for (i = 0; i < Specific.Count; i++)
            {
                /*SQL1 = "(SELECT distinct ID AS StoredID FROM StoredTool WHERE ModelType = 0 AND ModelID = " + Specific[i]["tid"].ToString()
                        +(IDbn == "" ? "" : " AND StoredID IN(" + IDbn + ")") + ")";*/
                SQL1 = "(SELECT distinct StoredID FROM StoredToolValue WHERE (ValueType = 3 or ValueType = 1) AND PropertyID = " + Specific[i]["tid"].ToString()
                        + (IDbn == "" ? "" : " AND StoredID IN(" + IDbn + ")") + ")";
                
                JArray JV = (JArray)Specific[i]["vals"];
                for (j = 0; j < JV.Count; j++)
                {
                    //SQL1  += " Intersect (SELECT distinct StoredID FROM [StoredToolValue] WHERE StoredID IN " + "(SELECT distinct ID AS StoredID FROM StoredTool WHERE ModelType = 0 AND ModelID = " + Specific[i]["tid"].ToString() + ")" + " AND ValueType = 0 AND PropertyID = " + JV[j]["pid"].ToString() + (JV[j]["val"].ToString() != "zkgy-1" ? " AND Value = '" + JV[j]["val"].ToString() + "')" : ")");
                    SQL1 += " Intersect ( SELECT StoredID FROM StoredToolValue WHERE ParentID IN(" + " SELECT ID FROM StoredToolValue WHERE (ValueType = 3 or ValueType = 1) AND PropertyID = " + Specific[i]["tid"].ToString() + (IDbn == "" ? "" : " AND StoredID IN(" + IDbn + ")") + ")" + " AND (ValueType = 4 OR ValueType = 2) AND PropertyID = " + JV[j]["pid"].ToString() + (JV[j]["val"].ToString() != "zkgy-1" ? " AND Value = '" + JV[j]["val"].ToString() + "')" : ")");
                    
                }                
                               
                dt1 = MyManager.GetDataSet(SQL1);//工具包，将StoreID集合

                if (dt1.Rows.Count == 0)//count = 0 说明到这已经没有符合要求的工具包啦！！！直接退出循环.
                {
                    IDbn = "";
                    break;
                }

                    for (k = 0, IDbn = ""/*每次需将IDbn清空，获取最新集合，然后继续筛选*/; k < dt1.Rows.Count; k++)
                    {
                        IDbn += (IDbn == "" ? dt1.Rows[k]["StoredID"].ToString() : "," + dt1.Rows[k]["StoredID"].ToString());
                    }
                
                
             }

        }
        
        if (fw == 2 || fw ==0 )//独立工具或所有
        {
            for (i = 0; i < Specific.Count; i++)
            {
                //SQL = "(SELECT distinct ID AS StoredID FROM StoredTool WHERE ModelType = 0 AND ModelID = " + Specific[i]["tid"].ToString() + ")";

                SQL = "(SELECT distinct ID AS StoredID FROM StoredTool WHERE ModelType = 0 AND ModelID = " + Specific[i]["tid"].ToString() + ")";
                                
                
                JArray JV = (JArray)Specific[i]["vals"];
                for (j = 0; j < JV.Count; j++)
                {
                    SQL += " Intersect (SELECT distinct StoredID FROM [StoredToolValue] WHERE StoredID IN " + "(SELECT distinct ID AS StoredID FROM StoredTool WHERE ModelType = 0 AND ModelID = " + Specific[i]["tid"].ToString() + ")" + " AND ValueType = 0 AND PropertyID = " + JV[j]["pid"].ToString() + (JV[j]["val"].ToString() != "zkgy-1" ? " AND Value = '" + JV[j]["val"].ToString() + "')" : ")");
                }

                dt1 = MyManager.GetDataSet(SQL); //独立工具，将StoreID集合

                for (k = 0; k < dt1.Rows.Count; k++)
                {
                    IDdl += (IDdl == "" ? dt1.Rows[k]["StoredID"].ToString() : "," + dt1.Rows[k]["StoredID"].ToString());
                }
            }
        }
       
  
        StringWriter sw = new StringWriter();
        JsonWriter jWrite = new JsonTextWriter(sw);
        jWrite.WriteStartArray();
        if ((fw == 1 || fw == 0) && IDbn != "")
        {
            dt = MyManager.GetDataSet("SELECT A.ID,rkID,StoredName,StoreTime,B.StateName FROM StoredTool AS A join ToolState AS B on A.State = B.StateID  WHERE ID IN(" + IDbn + ")");//工具包
            dt1 = MyManager.GetDataSet("SELECT rkID,('V' + convert(varchar(10) ,ID)) as ID,ID as rID,[StoredID],[PropertyID],[Value] as name ,[ValueType],[ParentID]  FROM [StoredToolValue] WHERE (ValueType = 3 OR ValueType = 1) AND  StoredID IN(" + IDbn + ")");//包内工具集合
            dt2 = MyManager.GetDataSet("SELECT B.Name,[Value],A.[ParentID] FROM [StoredToolValue] as A join ClassPropertys as B on A.propertyID = B.ID  where (ValueType = 4 or ValueType = 2) AND  StoredID IN(" + IDbn + ")");//属性集合
            for (i = 0; i < dt.Rows.Count; i++)
            {
                jWrite.WriteStartObject();
                jWrite.WritePropertyName("id");
                jWrite.WriteValue(dt.Rows[i]["ID"].ToString());
                jWrite.WritePropertyName("name");
                jWrite.WriteValue(dt.Rows[i]["StoredName"].ToString());
                jWrite.WritePropertyName("rkid");
                jWrite.WriteValue(dt.Rows[i]["rkID"].ToString());
                jWrite.WritePropertyName("statename");
                jWrite.WriteValue(dt.Rows[i]["StateName"].ToString());
                jWrite.WritePropertyName("storetime");
                jWrite.WriteValue(dt.Rows[i]["StoreTime"].ToString());
                jWrite.WritePropertyName("iconCls");
                jWrite.WriteValue("icon-toolbag");
                jWrite.WritePropertyName("state");
                jWrite.WriteValue("closed");
                jWrite.WritePropertyName("type");
                jWrite.WriteValue("bag");
                jWrite.WritePropertyName("sx");
                jWrite.WriteStartArray();
                dr = dt2.Select(" ParentID = " + dt.Rows[i]["ID"].ToString());
                    for (j = 0; j < dr.Length; j++)
                    {
                        jWrite.WriteStartObject();
                        jWrite.WritePropertyName("name");
                        jWrite.WriteValue(dr[j]["name"].ToString());
                        jWrite.WritePropertyName("value");
                        jWrite.WriteValue( dr[j]["Value"].ToString());
                        jWrite.WriteEndObject();
                    } 
                jWrite.WriteEndArray();    
                jWrite.WritePropertyName("children");
                jWrite.WriteStartArray();
                    dr = dt1.Select(" StoredID = " + dt.Rows[i]["ID"].ToString());
                    for (j = 0; j < dr.Length; j++)
                    {
                        jWrite.WriteStartObject();
                        jWrite.WritePropertyName("id");
                        jWrite.WriteValue(dr[j]["ID"].ToString());
                        jWrite.WritePropertyName("name");
                        jWrite.WriteValue(dr[j]["name"].ToString());
                        jWrite.WritePropertyName("rkid");
                        jWrite.WriteValue(dr[j]["rkID"].ToString());
                        jWrite.WritePropertyName("iconCls");
                        jWrite.WriteValue("icon-tool");
                        jWrite.WritePropertyName("type");
                        jWrite.WriteValue("bntool");
                        jWrite.WritePropertyName("sx");
                        jWrite.WriteStartArray();
                        dr1 = dt2.Select(" ParentID = " + dr[j]["rID"].ToString());
                        for (k = 0; k < dr1.Length; k++)
                        {
                            jWrite.WriteStartObject();
                            jWrite.WritePropertyName("name");
                            jWrite.WriteValue(dr1[k]["name"].ToString());
                            jWrite.WritePropertyName("value");
                            jWrite.WriteValue(dr1[k]["Value"].ToString());
                            jWrite.WriteEndObject();
                        }
                        jWrite.WriteEndArray();    
                        jWrite.WriteEndObject();
                    }

                jWrite.WriteEndArray();
                jWrite.WriteEndObject();   
            }
        }
        
        if ((fw == 2 || fw == 0)&& IDdl!="")
        {
            dt1 = MyManager.GetDataSet("SELECT A.ID,rkID,StoredName,StoreTime,B.StateName FROM StoredTool AS A join ToolState AS B on A.State = B.StateID WHERE ID IN(" + IDdl + ")");
            dt2 = MyManager.GetDataSet("SELECT rkID,B.Name,[Value],A.[StoredID] FROM [StoredToolValue] as A join ClassPropertys as B on A.propertyID = B.ID  where ValueType = 0 AND  StoredID IN(" + IDdl + ")");//属性集合
            for (i = 0; i < dt1.Rows.Count; i++)
            {
                jWrite.WriteStartObject();
                jWrite.WritePropertyName("id");
                jWrite.WriteValue(dt1.Rows[i]["ID"].ToString());
                jWrite.WritePropertyName("rkid");
                jWrite.WriteValue(dt1.Rows[i]["rkID"].ToString());
                jWrite.WritePropertyName("statename");
                jWrite.WriteValue(dt1.Rows[i]["StateName"].ToString());
                jWrite.WritePropertyName("name");
                jWrite.WriteValue(dt1.Rows[i]["StoredName"].ToString());
                jWrite.WritePropertyName("storetime");
                jWrite.WriteValue(dt1.Rows[i]["StoreTime"].ToString());
                jWrite.WritePropertyName("iconCls");
                jWrite.WriteValue("icon-tool");
                jWrite.WritePropertyName("type");
                jWrite.WriteValue("tool");
                jWrite.WritePropertyName("sx");
                jWrite.WriteStartArray();
                dr1 = dt2.Select(" StoredID = " + dt1.Rows[i]["ID"].ToString());
                for (k = 0; k < dr1.Length; k++)
                {
                    jWrite.WriteStartObject();
                    jWrite.WritePropertyName("name");
                    jWrite.WriteValue(dr1[k]["name"].ToString());
                    jWrite.WritePropertyName("rkid");
                    jWrite.WriteValue(dr1[k]["rkID"].ToString());
                    jWrite.WritePropertyName("value");
                    jWrite.WriteValue(dr1[k]["Value"].ToString());
                    jWrite.WriteEndObject();
                }
                jWrite.WriteEndArray();
                jWrite.WriteEndObject();
            }
            
        }
        jWrite.WriteEndArray();
        return sw.ToString();
    }
    public String GetStoreBagInfo( int BagID )
    {
        string json;
        DataTable dt = MyManager.GetDataSet("SELECT top 1 StoredName Name FROM StoredTool  Where ID = " + BagID);
        if (dt.Rows.Count == 0)
        {
            json = "{\"status\":\"failed\",\"msg\":\"该工具包不存在!\"}";
        }
        else {
            json = "{\"status\":\"success\",\"data\":{\"name\":\""+dt.Rows[0]["Name"].ToString()+"\"}}";
        }
        return json;
    }
    public String HitTool_StoreTool(JObject JO)//入库打流水号
    {
        int ClassID = Convert.ToInt32(JO["classid"].ToString());//有可能是独立工具ID
        int Type  = Convert.ToInt32(JO["type"].ToString());//1:工具包 2：独立工具
        int i, j, k, HitNum = Convert.ToInt32(JO["hitnum"].ToString());
        String StoreID, ToolID, HitTaskID = JO["taskid"].ToString(),newRank="0",OldSN,failedMsg="";
        DataRow[] dr;
        String[] Rank;
        int iRet =0;
        /* 任务类型 Type
         *  5之外的任何取值:工具包入库
            5:独立工具入库
*/
        
        /***************开始对工具编号**************/
        JArray OldSNArr = JArray.Parse(JO["oldsns"].ToString());
        
        for(i=0;i<OldSNArr.Count;i++)
        {
            if (MyManager.CheckSNExist(OldSNArr[i]["yzsn"].ToString()))
            {
                failedMsg += OldSNArr[i]["yzsn"].ToString() + " ";
            }
        }

        if (failedMsg != "")
        {
            return "{\"status\":\"failed\",\"msg\":\"失败!"+failedMsg+ "\"}";
        }         
  
        
        DataTable dt = MyManager.GetDataSet("SELECT * FROM PropertyValues Where ParentID =" + ClassID );
        for (i = 0; i < HitNum; i++)
        {
            OldSN = "";
            if (i < OldSNArr.Count)
            {
                OldSN = OldSNArr[i]["yzsn"].ToString();
            } 
            if (Type != 5)//工具包入库
            {
                newRank = "0";
                ToolID = MyManager.GetNextFlowID();

                //在coretool中插入工具包行
                StoreID = MyManager.GetFiledByInput("INSERT INTO StoredTool([rkID],[StoredName],[ModelID],[ModelType],[StoreTime],[RelatedTask],[State]) SELECT '"
                                                        + ToolID + "' AS rkID,Value AS StoreName,"+ClassID+" AS ModelID ,1,'" + DateTime.Now.ToString() + "' AS StoreTime,'" + JO["taskid"].ToString() + "' AS RelatedTask,4 AS State FROM PropertyValues WHERE ID = " + ClassID + ";SELECT IDENT_CURRENT('StoredTool') AS CurID", "CurID");

                dr = dt.Select(" ID = " + ClassID);
                Rank = dr[0]["Rank"].ToString().Split('|');
                dr = dt.Select("ValueType = 1 ");/*工具箱*/
                //在Storedtoolvalue中插入工具箱本体及其属性
       
                String BagID = MyManager.GetFiledByInput("INSERT INTO StoredToolValue (StoredID,rkID,[PropertyID],Value,ValueType,ParentID) SELECT " + StoreID + " AS StoredID,'" + ToolID + "' AS rkID,PropertyID,Value,ValueType,IDENT_CURRENT('StoredToolValue') AS ParentID"
                                                        + " FROM PropertyValues WHERE ID = " + dr[0]["ID"].ToString() + ";SELECT IDENT_CURRENT('StoredToolValue') AS CurID", "CurID");

                MyManager.ExecSQL("INSERT INTO StoredToolValue (StoredID,rkID,[PropertyID],Value,ValueType,ParentID) SELECT " + StoreID + " AS StoredID,NULL AS rkID,PropertyID,Value,ValueType," + BagID + " AS ParentID"
                                    + " FROM PropertyValues WHERE ValueType =2 AND ParentID = " + dr[0]["ID"].ToString());

                //按照rank字段进行排列
                for (j = 1; j < Rank.Length; j++)
                {
                    String subToolID = MyManager.GetFiledByInput("INSERT INTO StoredToolValue (StoredID,rkID,[PropertyID],Value,ValueType,ParentID) SELECT " + StoreID + " AS StoredID,'" + MyManager.GetNextFlowID() + "' AS rkID,PropertyID,Value,ValueType," + BagID + " AS ParentID"
                                                       + " FROM PropertyValues WHERE ID = " + Rank[j].ToString() + ";SELECT IDENT_CURRENT('StoredToolValue') AS CurID", "CurID");

                   
                    MyManager.ExecSQL("INSERT INTO StoredToolValue (StoredID,rkID,[PropertyID],Value,ValueType,ParentID) SELECT " + StoreID + " AS StoredID,NULL AS rkID,PropertyID,Value,ValueType," + subToolID + " AS ParentID"
                                        + " FROM PropertyValues WHERE ValueType =4 AND ParentID = " + Rank[j].ToString());
                    newRank += "|" + subToolID;
                }

                MyManager.ExecSQL("Update StoredTool Set Rank = '"+newRank+"' WHERE ID = " +StoreID);
                
            }
            else//独立工具入库，则只需将其属性导入StoreToolValue即可
            {
                
                    JArray JA = JArray.Parse(JO["values"].ToString());
                    String SQL = "";
                StoreID = MyManager.GetFiledByInput("INSERT INTO StoredTool (RelatedTask,[State],rkID,Rank,[StoredName],[ModelID],[ModelType],[StoreTime]) VALUES ('" + JO["taskid"].ToString() + "',4,'" + (OldSN==""?MyManager.GetNextFlowID():OldSN) + "',NULL,'"
                                                         + JO["toolname"].ToString() + "',"
                                                         + JO["classid"].ToString() + ",0,"
                                                         + "'" + DateTime.Now.ToString() + "');SELECT IDENT_CURRENT('StoredTool') AS CurID;", "CurID");

                    foreach (JToken jt in JA)
                    {
                        JObject jobj = (JObject)jt;
                        if (jobj["value"].ToString().IndexOf("'") != -1 || jobj["value"].ToString().IndexOf(" ") != -1) { return "{\"status\":\"failed\",\"msg\":\"属性取值不允许含有分号(')或者空格!\"}"; }
                        //查看该属性值之前是否存在SELECT ID  
                        iRet = Convert.ToInt32(MyManager.GetFiledByInput("SELECT Count(*) AS Count FROM [PropertyValues] where PropertyID =" + jobj["propertyid"].ToString() + " AND Value = '" + jobj["value"].ToString() + "' AND (ParentID is NULL or ParentID=0)", "Count"));
                        if (iRet == 0)//该属性值之前不存在，现在添加到属性值列表中
                        {
                            MyManager.ExecSQL("INSERT INTO PropertyValues (PropertyID,Value,ValueType) VALUES (" + jobj["propertyid"].ToString() + ",'" + jobj["value"].ToString() + "',0)");
                        }
                        SQL += "INSERT INTO [StoredToolValue] ([StoredID],[PropertyID],[Value],[ValueType],[ParentID]) VALUES (" + StoreID + "," + jobj["propertyid"].ToString() + ",'" + jobj["value"].ToString() + "',0," + StoreID + ");";
                    }
                    MyManager.ExecSQL(SQL);
               
            }
        }

        MyManager.ExecSQL("INSERT INTO [HitTool](Type,TaskID,TaskName,CorePerson,State) Values (1,'" + JO["taskid"].ToString() + "','"
                                                                                        + JO["taskname"].ToString() + "','"
                                                                                        + JO["coreperson"].ToString() + "',1)");



        return "{\"status\":\"success\",\"msg\":\"编号成功!任务编号为:" + JO["taskid"].ToString() + "\"}";
    }
    public String HitTool_CoreTool(JObject JO)
    {
        int i, j, k, tNum = 0, iToolCount = 0;
        String CoreID,StoredID,ToolID,ModelType ;/*GetNextID中已经确保CoreTool中ID不会重复*/
        String[] Rank;
        DataRow[] dr, dr1;

        /***************开始对工具编号**************/
        DataTable gdt = MyManager.GetDataSet("SELECT * FROM StoredTool Where  ReleatedTask = '" + JO["taskid"].ToString() + "'");
        for (i = 0; i < gdt.Rows.Count; i++)
        {
            StoredID = gdt.Rows[i]["ID"].ToString();
            ModelType = gdt.Rows[i]["ModelType"].ToString();//0:独立工具 1:工具包
            Rank = gdt.Rows[i]["Rank"].ToString().Split('|');
            DataTable dt = MyManager.GetDataSet("SELECT * FROM StoredToolValue Where StoredID = " + StoredID);
            if (ModelType == "1")
            {
                ToolID = MyManager.GetNextID();

                while (MyManager.SELCount("SELECT COUNT(ID) as Count From CoreToolValue Where ToolID like '" + ToolID + "%'", "Count") > 0)
                {
                    ToolID = MyManager.GetNextID();
                }
                //在coretool中插入工具包行
                CoreID = MyManager.GetFiledByInput("INSERT INTO CoreTool(EPC,ModelType,ModelID,ToolID,ToolName,[ModifyTime],State,[RelatedTask],Rank) SELECT '"+MyManager.GenerateEPC(ToolID)+"' AS EPC,ModelType,ModelID,'"
                                                                                + ToolID + "' AS ToolID,StoredName AS ToolName,'" + DateTime.Now.ToString() + "' AS ModifyTime,1,'" + JO["taskid"].ToString() + "' AS RelatedTask,Rank FROM StoredTool WHERE ID = " + StoredID + ";SELECT IDENT_CURRENT('CoreTool') AS CurID", "CurID");

                dr = dt.Select("ValueType = 1 ");/*工具箱子编号为 AA 等*/
                //在coretoolvalue中插入工具箱本体
                String nID = MyManager.GetFiledByInput("INSERT INTO CoreToolValue (State,[CoreID],[PropertyID],Value,ValueType,ParentID,ToolID) SELECT 1 AS State," + CoreID + " AS CoreID,PropertyID,Value,ValueType," + CoreID + ",'"
                                                        + ToolID + "' AS ToolID  FROM StoredToolValue WHERE ID = " + dr[0]["ID"].ToString() + ";SELECT IDENT_CURRENT('CoreToolValue') AS CurID", "CurID");

                MyManager.ExecSQL("INSERT INTO CoreToolValue (State,[CoreID],[PropertyID],Value,ValueType,ParentID) SELECT 1 AS State," + CoreID + " AS CoreID,PropertyID,Value,ValueType," + nID + " AS ParentID"
                                    + " FROM StoredToolValue WHERE ValueType =2 AND ParentID = " + dr[0]["ID"].ToString());


                dr = dt.Select("ValueType = 3");
                iToolCount = 1;
                for (j = 1; j <= Rank.Length; j++)
                {

                    String mID = MyManager.GetFiledByInput("INSERT INTO CoreToolValue (State,[CoreID],[PropertyID],Value,ValueType,ParentID,ToolID) SELECT 1 AS State," + CoreID + " AS CoreID,PropertyID,Value,ValueType," + nID + " AS ParentID,'"
                                                    + ToolID + iToolCount.ToString("D3") + "' AS ToolID  FROM StoredToolValue WHERE ValueType =3 AND ID = " + Rank[j].ToString() + ";SELECT IDENT_CURRENT('CoreToolValue') AS CurID", "CurID");

                    MyManager.ExecSQL("INSERT INTO CoreToolValue (State,[CoreID],[PropertyID],Value,ValueType,ParentID) SELECT -1 AS State," + CoreID + " AS CoreID,PropertyID,Value,ValueType," + mID + " AS ParentID"
                                                    + " FROM StoredToolValue WHERE ValueType =4 AND ParentID = " + Rank[j].ToString());

                    iToolCount++;

                }

            }
            else { //独立工具
                ToolID = MyManager.GetNextID();

                while (MyManager.SELCount("SELECT COUNT(ID) as Count From CoreToolValue Where ToolID like '" + ToolID + "%'", "Count") > 0)
                {
                    ToolID = MyManager.GetNextID();
                }

                CoreID = MyManager.GetFiledByInput("INSERT INTO CoreTool(EPC,ModelType,ModelID,ToolID,ToolName,[ModifyTime],State,[RelatedTask],Rank) SELECT '"+MyManager.GenerateEPC(ToolID)+"' AS EPC,ModelType,ModelID,'"
                                                        + ToolID + "' AS ToolID,StoredName AS ToolName,'" + DateTime.Now.ToString() + "' AS ModifyTime,1,'" + JO["taskid"].ToString() + "' AS RelatedTask,Rank FROM StoredTool WHERE ID = " + StoredID + ";SELECT IDENT_CURRENT('CoreTool') AS CurID", "CurID");

                dr = dt.Select("ValueType = 1 ");/*工具箱子编号为 AA 等*/
                //在coretoolvalue中插入工具箱本体
                String nID = MyManager.GetFiledByInput("INSERT INTO CoreToolValue (State,[CoreID],[PropertyID],Value,ValueType,ParentID,ToolID) SELECT 1 AS State," + CoreID + " AS CoreID,PropertyID,Value,ValueType,IDENT_CURRENT('CoreToolValue') AS ParentID,'"
                                                        + ToolID + "' AS ToolID  FROM StoredToolValue WHERE ID = " + dr[0]["ID"].ToString() + ";SELECT IDENT_CURRENT('CoreToolValue') AS CurID", "CurID");  
            }
            
        }
        MyManager.ExecSQL("INSERT INTO [HitTool](TaskID,TaskName,CorePerson,State) Values ('" + JO["taskid"].ToString() + "','"
                                                                                     + JO["taskname"].ToString() + "','"
                                                                                     + JO["coreperson"].ToString() + "',1)");
            return "{\"status\":\"success\",\"msg\":\"编号成功!\"}";

    }
    public String RankTool(JObject JO)
    {
        String JsonRet = "{\"status\":\"success\",\"msg\":\"成功\"}";
        int BagID = Convert.ToInt32(JO["bagid"].ToString());
        String Dir/*方向，up或down*/ = JO["direction"].ToString();
        int i = Convert.ToInt32( JO["currank"].ToString());//该工具当前排名
        String OldRank = MyManager.GetFiledByInput("SELECT Rank FROM PropertyValues WHERE ID = " + BagID,"Rank");
        String[] arr = OldRank.Split('|');
        if (Dir == "up") {
            if (i == 1)
            { //本来是第一位，还想往前挪
                OldRank = arr[0] + "|" + String.Join("|", arr, 2, arr.Length - 2) + "|" + arr[1];
            }
            else
            {
                if (arr[i - 1] != arr[i])//前后两个子工具相同时,不做任何改变
                {
                    String t = arr[i - 1];
                    arr[i - 1] = arr[i];
                    arr[i] = t;
                    OldRank = String.Join("|", arr);
                }
            }
        }
        else if (Dir == "down")
        {
            if (i == arr.Length-1)
            { //本来是最后一位，还想往后挪
                OldRank = arr[0] + "|" + arr[i] + "|" + String.Join("|", arr, 1, arr.Length - 2) ;
            }
            else
            {
                if (arr[i + 1] != arr[i])//前后两个子工具相同时,不做任何改变
                {
                    String t = arr[i + 1];
                    arr[i + 1] = arr[i];
                    arr[i] = t;
                    OldRank = String.Join("|", arr);
                }
            }
         }
        MyManager.ExecSQL("UPDATE PropertyValues Set Rank = '" +OldRank+ "' WHERE ID = "+BagID);
        return JsonRet;
        
    }
    public String GetIdenticalTool(JObject JO)
    {
        String JsonRet = "";
        String CoreID;
        
        String CmpOption = JO["cmpoption"].ToString();//比较选择，如果为1则进行全面比较，包括所有属性，0则进行“匹配属性比较”
        String ToolState = JO["toolstate"].ToString();//工具状态
         /*从coretoovalue中选取在库的，且模型一致的，属性和子工具总数目一致的工具或者工具箱*/
        int Count,i,j;//参考工具的属性数目
        StringWriter sw = new StringWriter();
        JsonWriter jWrite = new JsonTextWriter(sw);
        DataTable dt,dt1,dt2;
        
        //检查输入json中有无coreid 若没有则自动生成
        if (JO["coreid"] != null) {
            CoreID = JO["coreid"].ToString();            
        }
        else{
            CoreID = MyManager.GetFiledByInput("SELECT ID AS CoreID From CoreTool Where ToolID ='" +JO["toolid"].ToString() +"'","CoreID");
        }
        if (CmpOption == "0")//只含匹配项目
        {
           
            //选取在状态为toolstate的，模型一致的， 匹配属性的工具
            /*   dt =  MyManager.GetDataSet("SELECT * from coretoolvalue AS A join CLassPropertys AS B  on A.propertyid = B.ID and B.pType = 0 AND a.coreid = " + CoreID ); //只含匹配项目
                 Count = dt.Rows.Count;  
                 dt1 = MyManager.GetDataSet("SELECT coreid ,count(A.id) as tNum from coretoolvalue AS A join CLassPropertys AS B  on A.propertyid = B.ID  where B.ptype = 0 AND coreid in (select id from coretool where state = " + ToolState + " AND modelid in (select modelid from coretool where id =" + CoreID + ")) Group By coreid");
                dt2 = MyManager.GetDataSet("SELECT * from coretoolvalue AS A join CLassPropertys AS B  on A.propertyid = B.ID  where B.ptype = 0 AND coreid in (select id from coretool where state = " + ToolState + " AND modelid in (select modelid from coretool where id =" + CoreID + "))");
              */
            //2016-03-29修改，比较时，不管其工具包或者独立工具的模型是否一致，只要求其除了工具箱本体及其属性之外的条目大于待比较工具箱的相关条目
            dt = MyManager.GetDataSet("SELECT * from coretoolvalue AS A join CLassPropertys AS B  on A.propertyid = B.ID and B.pType = 0 AND a.coreid = " + CoreID + " Where A.ValueType not in (1,2)" ); //只含匹配项目
            Count = dt.Rows.Count;
            dt1 = MyManager.GetDataSet("SELECT coreid ,count(A.id) as tNum from coretoolvalue AS A join CLassPropertys AS B  on A.propertyid = B.ID  where B.ptype = 0 AND coreid in (select id from coretool where state = " + ToolState + " ) AND A.ValueType not in(1,2) Group By coreid");
            dt2 = MyManager.GetDataSet("SELECT * from coretoolvalue");
        
        }
        else//全面比较
        {
            dt =  MyManager.GetDataSet("SELECT * from coretoolvalue where ValueType not in(1,2) AND  CoreID = " + CoreID);
            Count = dt.Rows.Count;  
            //选取在库的，模型一致的的工具
            dt1 = MyManager.GetDataSet("SELECT coreid ,count(id) as tNum from coretoolvalue   where coreid in (select id from coretool where state = " + ToolState + " )  Group By coreid");
            dt2 = MyManager.GetDataSet("SELECT *  from coretoolvalue ");//1021日，将coretoolvalue 改为coretool
            
        }


        DataView dv;
        int bContinue = 1 ;
        DataRow[] dr2,dr1,dr = dt1.Select(" tNum >= " + Count );//选取属性数量一致或大于的工具包CoreID，放入dr
        int Total = 0;
        
        jWrite.WriteStartArray();
        for (i = 0; i < dr.Length; i++)
        {
             //开始对筛选出来的工具与参考工具比较  dt里面是参考工具，dt1里面是数据行与参考工具一致的工具
           
            dv = dt2.DefaultView;
            dv.RowFilter = " CoreID = " + dr[i]["CoreID"].ToString();//开始逐一选取待比较工具
            DataTable dt3 = dv.ToTable(); //dt3中放着需要比较的单个工具或工具包
                //保证 工具箱本体 工具箱内工具 独立工具 类ID相同 即propertyid
                dr2 = dt.Select(" ValueType = 1 OR ValueType =3 OR ValueType = 5");
                bContinue = 1;
                for (j = 0; j < dr2.Length; j++)
                {
                    DataRow[] tdr = dt3.Select(" PropertyID = " + dr2[j]["PropertyID"].ToString() + " AND  ValueType = " + dr2[j]["ValueType"].ToString());
                    if (tdr.Length == 0) { //该工具不符合
                        bContinue = 0;
                        break;
                    }else
                    {
                        dt3.Rows.Remove(tdr[0]);//比较一行，删除一行，防止一行被比较多次。
                    }
                }
                // 其属性id相同，且value相同
                dr2 = dt.Select(" ValueType = 2 OR ValueType =4 OR ValueType = 0");
                for (j = 0; bContinue==1 && j < dr2.Length; j++)
                {
                    DataRow[] tdr = dt3.Select(" PropertyID = " + dr2[j]["PropertyID"].ToString() + "AND  ValueType = " + dr2[j]["ValueType"].ToString() + " AND  Value = '" + dr2[j]["Value"].ToString() + "'");
                    if (tdr.Length == 0)
                    { //该工具不符合
                        bContinue = 0;
                        break;
                    }
                    else
                    {
                        dt3.Rows.Remove(tdr[0]);//比较一行，删除一行，防止一行被比较多次。
                    }
                }
                if (bContinue==1) { //bCoutinue =1 证明符合要求
                    Total++;
                    String ids = MyManager.GetFiledByInput("SELECT (convert(varchar, ID)+'|'+ToolID + '|'+ToolName) as ids FROM CoreTool Where ID = " + dr[i]["CoreID"].ToString(), "ids");
                    String[] arr = ids.Split('|');
                    if (arr.Length > 0)
                    {
                       // txt += "SELECT (ID+'|'+ToolID) as ids FROM CoreTool Where ID = " + dr[i]["CoreID"].ToString();
                        jWrite.WriteStartObject();
                        jWrite.WritePropertyName("toolname");
                        jWrite.WriteValue(arr[2].ToString());
                        jWrite.WritePropertyName("toolid");
                        jWrite.WriteValue(arr[1].ToString());
                        jWrite.WritePropertyName("coreid");
                        jWrite.WriteValue(arr[0].ToString());
                        jWrite.WritePropertyName("pvcount");//属性和取值集合个数
                        jWrite.WriteValue(dr[i]["tNum"].ToString());
                        jWrite.WriteEndObject(); 
                    }
                }
        }
        jWrite.WriteEndArray();
        return "{\"status\":\"success\",\"total\":" + Total + ",\"data\":" + sw.ToString() +"}";
 
    }
    public int GetWantToBorrowCount(int TaskID)
    {
        return MyManager.SELCount("SELECT COUNT(ID) as iCount From ToolApp  WHERE TaskID = " + TaskID, "iCount");
    }
    public String AddToBorrow(JObject JO)
    {
        String TaskID = JO["taskid"].ToString();
        String UserID = gCtx.Session["UserID"].ToString();
        String UserName = gCtx.Session["Name"].ToString();
        String fw = "(''";
        int n =Convert.ToInt32( JO["num"].ToString());//欲借数量
        //检查该任务是否由该人创建，否则无法修改
        int Count = MyManager.SELCount("SELECT COUNT(ID) as iCount From Tasks WHERE ID = " + TaskID + " AND CreateUser = " + UserID, "iCount");
        if (Count == 0) {
            return "{\"status\":\"failed\",\"msg\":\"非任务创建者本人，不允许修改!\"}";
        }
        JArray JA = JArray.FromObject(JO["data"]);
        for (int i = 0; i < JA.Count; i++)
        {
            fw += ",'" + JA[i]["toolid"].ToString() + "'";
        }
        fw += ")";
        MyManager.ExecSQL("DELETE FROM ToolApp Where TaskID = " + TaskID + " AND WantToolID IN " + fw);

        for (int i = 0; i < n; i++)
        {
          /*
           * ,[TaskID]
              ,[UserID]
              ,[UserName]
              ,[ToolID]
              ,[CreateTime]
              ,[BorrowedID]
              ,[BorrowTime]
              ,[Borrower]
              ,[State]
          */
            MyManager.ExecSQL("INSERT INTO ToolApp (CoreID,TaskID,UserID,UserName,WantToolID,WantToolName,CreateTime,State) Values("
                                    + JA[i]["coreid"].ToString() + ","
                                   + TaskID +
                              "," + UserID + 
                              ",'" + UserName +
                              "','" + JA[i]["toolid"].ToString() +
                              "','" + JA[i]["toolname"].ToString() + 
                              "','" + DateTime.Now.ToString() + "',0)");
                
        }


        return "{\"status\":\"success\",\"msg\":\"添加成功!\",\"borrowcount\":" + MyManager.SELCount("SELECT COUNT(ID) as iCount From ToolApp  WHERE TaskID = " + TaskID , "iCount") + "}";
                 
    }
    public String GetBorrowInfo(int TaskID)    
    {
        String json = "",State = "";
        int i = 0;
        StringWriter sw = new StringWriter();
        JsonWriter jWrite = new JsonTextWriter(sw);
        jWrite.WriteStartArray();
        DataTable dt = MyManager.GetDataSet("SELECT * FROM ToolApp Where TaskID =  " + TaskID);
        for (i = 0; i < dt.Rows.Count; i++)
        {/*
          * <th data-options="field:'xh'" width="30">序号</th>
                        <th data-options="field:'status'" width="50">状态</th>
						<th data-options="field:'wangttoolid'" width="60">欲借件号</th>
						<th data-options="field:'wanttoolname'" width="100">工具名称</th>
						<th data-options="field:'createusername'" width="80">添加人</th>
						<th data-options="field:'createtime'" width="150">添加时间</th>
                        <th data-options="field:'BorrowedID'" width="80">已借出件号</th>
                        <th data-options="field:'Borrowedtoolname'" width="120">借出工具名称</th>
						<th data-options="field:'BorrowerName'" width="80">借用人</th>
                        <th data-options="field:'BorrowerAdminName'" width="80">借出人</th>
                        <th data-options="field:'BorrowerName'" width="80">借用人</th>
                        <th data-options="field:'RefunderTime'" width="80">归还时间</th>
                        <th data-options="field:'RefunderName'" width="80">归还人</th>
                        <th data-options="field:'RefunderAdminName'" width="100">入库检验人</th>
          */
            jWrite.WriteStartObject();
            State = dt.Rows[i]["State"].ToString();
            jWrite.WritePropertyName("status");
            if (State == "0")
            {
                jWrite.WriteValue("已提交");
            }
            else if (State == "1")
            {
                jWrite.WriteValue("已借出");
            }
            else if (State == "2")
            {
                jWrite.WriteValue("已归还");
            }
            else if (State == "3")
            {
                jWrite.WriteValue("缺件");
            }
            jWrite.WritePropertyName("xh");
            jWrite.WriteValue(i+1);
            jWrite.WritePropertyName("WantToolID");
            jWrite.WriteValue(dt.Rows[i]["WantToolID"].ToString());
            jWrite.WritePropertyName("coreid");
            jWrite.WriteValue(dt.Rows[i]["coreid"].ToString());
            jWrite.WritePropertyName("id");
            jWrite.WriteValue(dt.Rows[i]["id"].ToString());
            jWrite.WritePropertyName("WantToolName");
            jWrite.WriteValue(dt.Rows[i]["WantToolName"].ToString());
            jWrite.WritePropertyName("UserName");
            jWrite.WriteValue(dt.Rows[i]["UserName"].ToString());
            jWrite.WritePropertyName("createtime");
            jWrite.WriteValue(dt.Rows[i]["createtime"].ToString());
            jWrite.WritePropertyName("BorrowedToolID");
            jWrite.WriteValue(dt.Rows[i]["BorrowedToolID"].ToString());
            jWrite.WritePropertyName("BorrowedToolName");
            jWrite.WriteValue(dt.Rows[i]["BorrowedToolName"].ToString());
            jWrite.WritePropertyName("BorrowAdminName");
            jWrite.WriteValue(dt.Rows[i]["BorrowAdminName"].ToString());
            jWrite.WritePropertyName("BorrowTime");
            jWrite.WriteValue(dt.Rows[i]["BorrowTime"].ToString());
            jWrite.WritePropertyName("BorrowerName");
            jWrite.WriteValue(dt.Rows[i]["BorrowerName"].ToString());
            jWrite.WritePropertyName("RefunderName");
            jWrite.WriteValue(dt.Rows[i]["RefunderName"].ToString());
            jWrite.WritePropertyName("RefundAdminName");
            jWrite.WriteValue(dt.Rows[i]["RefundAdminName"].ToString());
            jWrite.WritePropertyName("RefundTime");
            jWrite.WriteValue(dt.Rows[i]["RefundTime"].ToString());
            jWrite.WriteEndObject(); 
        }
            jWrite.WriteEndArray();
        return sw.ToString() ;
    }
    public String DelBorrowApp(JObject JO)
    {
        //检查申请创建者是否是本人，而且任务没有提交。
        int Count = 0;
        Count = MyManager.SELCount("SELECT Count(ID) AS tCount FROM ToolApp Where UserID = " + gCtx.Session["UserID"].ToString() + " AND TaskID = " + JO["taskid"].ToString(), "tCount");
        if (Count == 0) { return "{\"status\":\"failed\",\"msg\":\"非本人哦！不能删除!\"}"; }
        Count = MyManager.SELCount("SELECT Count(ID) AS tCount FROM TaskProcess Where  TaskID = " + JO["taskid"].ToString(), "tCount");
        if (Count > 0) { return "{\"status\":\"failed\",\"msg\":\"任务已经提交，不能删除!\"}"; }
        MyManager.ExecSQL("DELETE FROM ToolApp WHERE ID = " + JO["appid"].ToString());
        return "删除成功！"; 
    }
    public String GetToolState(String ToolID)
    {
        return MyManager.GetFiledByInput("SELECT StateName From CoreTool join ToolState On CoreTool.State = ToolState.StateID Where ToolID = '" + ToolID + "'", "StateName");
    }
    public String  BorrowToolByID(JObject JO)
    {

        String Msg = "工具借用成功！";
        String ToolID = JO["toolid"].ToString();
        String BorrowerName = JO["borrowername"].ToString().Trim();
        String TaskID = JO["taskid"].ToString();
        String CurState = "";
        String AppID = JO["appid"].ToString();
        String CoreID = "",nID,CurToolName;
        if (BorrowerName == "" || BorrowerName.IndexOf(" ") != -1 || BorrowerName.IndexOf("'") != -1)
        {
            return "借用者名称不可为空，且不可含空格，引号!";
        }
        ///检查是否是该任务的处理人是否是该人  TaskProcess 中 recvuser 且state = 2
        if (0 == MyManager.SELCount("SELECT count(ID) as tCount FROM TaskProcess WHERE State = 2 AND TaskID = " + TaskID + " AND RecvUser = " + gCtx.Session["UserID"].ToString(), "tCount"))
        {
            return "非管理人员，无法进行该操作！";
        }

        CurState = MyManager.GetFiledByInput("SELECT StateName From CoreTool join ToolState on CoreTool.State = ToolState.StateID Where ToolID = '" + ToolID + "'", "StateName");
        
        if (CurState !="在库")
        {
            return "该工具现在状态为" + CurState + "，不能借出!";
        }
        
        //开始借工具 
        String txt = MyManager.GetFiledByInput("SELECT (convert(varchar,ID)+'|'+ToolName)as txt From CoreTool Where ToolID = '" + ToolID + "'", "txt");
        String[] arr = txt.Split('|');
        CoreID = arr[0];
        CurToolName = arr[1];
        if (CoreID == "")
        {
            return "该工具不存在！!";
        }
        //检查工具包中的子工具能否借出
        if (MyManager.SELCount("SELECT Count(ID) as tCount From CoreToolValue Where State <> 0 AND CoreID = " + CoreID + " AND (ValueType =1 or ValueType =3)", "tCount") > 0)
        {
            return "该工具包中的若干子工具存在问题或者被借出，因此该工具包不可借出，详情请查看工具包。";
        }
        MyManager.ExecSQL("Update CoreTool Set State = 2 WHERE ID = " + CoreID);
        //MyManager.ExecSQL("Update CoreTool Set State = 2 WHERE CoreID = " + CoreID);
        nID =  MyManager.GetFiledByInput("insert into borrowinfocoretool  select [ToolID],[ToolName],[ModelType],[ModelID],[ModifyTime],[State],[RelatedTask],[Rank],appid=" + AppID + " from coretool WHERE ID = " + CoreID + ";SELECT IDENT_CURRENT('[BorrowInfoCoreTool]') AS nID", "nID");
        MyManager.ExecSQL("insert into borrowinfocoretoolvalue  select [CoreID]=" + nID + ",[ToolID],[State],[PropertyID],[Value],[ModifyTime],[ValueType],[ParentID],appid=" + AppID + " from coretoolValue WHERE CoreID = " + CoreID);
        /*
         * ,[BorrowedToolID]
          ,[BorrowedToolName]
          ,[BorrowTime]
          ,[BorrowerID]
          ,[BorrowerName]
          ,[BorrowAdminID]
          ,[BorrowAdminName]
         */
        MyManager.ExecSQL("UPDATE ToolApp Set State=1,BorrowedToolID = '" + ToolID + "',BorrowedToolName='" + CurToolName + "',BorrowTime='" + DateTime.Now.ToString() + "',BorrowerName='" + BorrowerName + "',BorrowAdminID=" + gCtx.Session["UserID"].ToString() + ",BorrowAdminName='" + gCtx.Session["Name"].ToString() + "' WHERE ID = " +AppID);
        return Msg;
    }
    public String RefundToolByAppID(JObject  JO)
    {
        String AppId = JO["appid"].ToString();
        String ToolID = MyManager.GetFiledByInput("SELECT BorrowedToolID FROM ToolApp Where [State] =1 AND ID = " + AppId, "BorrowedToolID");
        if (ToolID == "")
        {
            return "该申请未借出!";
        }

        if (JO["refundername"].ToString().Trim() == "" || JO["refundername"].ToString().Trim().IndexOf(" ") != -1 || JO["refundername"].ToString().Trim().IndexOf("'") != -1)
        {
            return "借用者名称不可为空，且不可含空格，引号!";
        }
        
        if ("2" != MyManager.GetFiledByInput("SELECT [State] FROM CoreTool Where ToolID  = '" + ToolID + "'", "State"))
        {
            return "该工具没被借出，不可归还!";
        }
        String CoreID = MyManager.GetFiledByInput("SELECT ID FROM CoreTool Where [State] =2 AND ToolID = '" + ToolID + "'", "ID");
        MyManager.ExecSQL("UPDATE CoreTool Set [State] = 0 Where ID = " + CoreID);
        MyManager.ExecSQL("UPDATE CoreToolValue Set [State] = 0 Where (ValueType = 1 Or ValueType = 3) And  CoreID = " + CoreID);
        /*
         *  
       ,[RefunderID]
       ,[RefunderName]
       ,[RefundTime]
       ,[RefundAdminID]
       ,[RefundAdminName]
         */
        MyManager.ExecSQL("UPDATE ToolApp Set [State] = 2,RefundAdminID=" + gCtx.Session["UserID"].ToString() + ",RefundAdminName='" + gCtx.Session["Name"].ToString() + "',RefunderName='" + JO["refundername"].ToString().Trim() + "',RefundTime='" + DateTime.Now.ToString() + "' Where ID =" + AppId);
        /*
         * 当所有工具都归还完毕之后任务自动关闭
         */
        String TaskID =MyManager.GetFiledByInput("SELECT TaskID FROM ToolApp Where ID  = '" + AppId + "'", "TaskID");

        DataTable dt = MyManager.GetDataSet("SELECT * FROM ToolApp WHERE TaskID = " + TaskID + " AND State IN (0,1)");
        String SubStr = "";
        if (dt.Rows.Count == 0)
        {
            SubStr = ",任务已经自动关闭!";
            MyManager.ExecSQL("UPDATE Tasks SET State = 10 WHERE ID =" + TaskID);
            MyManager.ExecSQL("DELETE FROM TaskProcess WHERE TaskID =" + TaskID);
            //  Session["UserID"] = dt.Rows[0]["ID"];
            //  Session["Name"] = dt.Rows[0]["Name"];
            MyManager.ExecSQL("INSERT INTO TaskLog (TaskID,CreateUserID,CreateUserName,Title,Content,DateTime) Values (" + TaskID + "," + gCtx.Session["UserID"].ToString() + ",'" + gCtx.Session["Name"].ToString() + "','关闭任务','任务自动关闭','" + DateTime.Now.ToString() + "')");
  
        }

        return "工具归还成功" + SubStr;
    }
    public String AddToTmpHitTool(JObject JO)
    {
        String TaskID, rkID;
        TaskID = JO["taskid"].ToString();
        rkID = JO["rkid"].ToString();
        if (1 == MyManager.SELCount("SELECT count(ID) as tCount From StoredTool Where RelatedTask = '" + TaskID + "' AND rkID = '" + rkID + "'", "tCount"))
        {
            return "件号为:" + rkID + "的工具已经存在!";
        }
        if (1 != MyManager.SELCount("SELECT count(ID) as tCount From StoredTool Where [State]=0 AND  rkID = '" + rkID + "'", "tCount"))
        {
            return "件号为:" + rkID + "的工具状态不可入编!";  
        }
        MyManager.ExecSQL("UPDATE StoredTool Set RelatedTask = '" + TaskID + "' WHERE rkID = '" +rkID + "'");
        return "件号为:"+rkID + "的工具添加成功!!!"; 
    }
    public int  GetTmpHitToolByTaskID(JObject JO)
    {
        return MyManager.SELCount("SELECT count(ID) as tCount From StoredTool  WHERE RelatedTask = '" + JO["taskid"].ToString() + "'", "tCount");
    }
    public String GetTmpHitToolInfobyTaskID(JObject JO)
    {
        StringWriter sw = new StringWriter();
        JsonWriter jWrite = new JsonTextWriter(sw);
        DataTable dt = MyManager.GetDataSet("SELECT ID,rkID,StoredName,StoreTime,PosID FROM StoredTool WHERE RelatedTask  ='" + JO["taskid"].ToString() + "' Order by rkID ");
        jWrite.WriteStartArray();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            jWrite.WriteStartObject();
            jWrite.WritePropertyName("xh");
            jWrite.WriteValue(i+1);
            jWrite.WritePropertyName("rkid");
            jWrite.WriteValue(dt.Rows[i]["rkID"].ToString());
            jWrite.WritePropertyName("id");
            jWrite.WriteValue(dt.Rows[i]["ID"].ToString());
            jWrite.WritePropertyName("toolname");
            jWrite.WriteValue(dt.Rows[i]["StoredName"].ToString());
            jWrite.WritePropertyName("storetime");
            jWrite.WriteValue(dt.Rows[i]["StoreTime"].ToString());
            jWrite.WritePropertyName("posid");
            jWrite.WriteValue(dt.Rows[i]["posid"].ToString());
            jWrite.WriteEndObject();
        }
        jWrite.WriteEndArray();

        return sw.ToString();

    }
    public String DelTmpHitToolByrkID(JObject JO)
    {
        if (1 == MyManager.ExecSQL("UPDATE StoredTool Set [RelatedTask] = NULL Where rkID = '" + JO["rkid"].ToString() + "'")) { return "删除成功!"; }
        return "删除失败!"; 
    }
    public String tijiao(JObject JO)//实际为入编功能
    {
        String TaskID = JO["taskid"].ToString();
        String CorePerson = JO["coreperson"].ToString();
        int i, j, k,d, tNum = 0, iToolCount = 0;
        String CoreID, StoredID, ToolID, ModelType,newRank;/*GetNextID中已经确保CoreTool中ID不会重复*/
        String[] Rank;
        DataRow[] dr, dr1;
        //首先,查看该任务中所有工具是否都具备了货位编码
        if(0!=Convert.ToInt32( MyManager.GetFiledByInput("SELECT Count(*) as iCount FROM StoredTool WHERE (PosID is null OR PosID like '% %') AND  RelatedTask='" + TaskID + "'", "iCount")))
        {
            //有的工具没有货位编码
            return "{\"status\":\"failed\",\"msg\":\"师傅，所有工具必须都具有货位编码。\"}"; 
        }
        
                   
        /***************开始对工具编号**************/
        DataTable gdt = MyManager.GetDataSet("SELECT * FROM StoredTool Where  RelatedTask = '" + JO["taskid"].ToString() + "'");
        for (i = 0; i < gdt.Rows.Count; i++)
        {
            StoredID = gdt.Rows[i]["ID"].ToString();
            ModelType = gdt.Rows[i]["ModelType"].ToString();//0:独立工具 1:工具包
            Rank = gdt.Rows[i]["Rank"].ToString().Split('|');
            DataTable dt = MyManager.GetDataSet("SELECT * FROM StoredToolValue Where StoredID = " + StoredID);
            if (ModelType == "1")
            {
                ToolID = MyManager.GetNextID();

                while (MyManager.SELCount("SELECT COUNT(ID) as Count From CoreToolValue Where ToolID like '" + ToolID + "%'", "Count") > 0)
                {
                    ToolID = MyManager.GetNextID();
                }
                //在coretool中插入工具包行
                CoreID = MyManager.GetFiledByInput("INSERT INTO CoreTool(EPC,rkID,ModelType,ModelID,ToolID,ToolName,[ModifyTime],State,[RelatedTask],PosID) SELECT '"+MyManager.GenerateEPC(ToolID)+"' AS EPC,rkID,ModelType,ModelID,'"
                                                                                + ToolID + "' AS ToolID,StoredName AS ToolName,'" + DateTime.Now.ToString() + "' AS ModifyTime,1,'" + JO["taskid"].ToString() + "' AS RelatedTask FROM StoredTool,PosID WHERE ID = " + StoredID + ";SELECT IDENT_CURRENT('CoreTool') AS CurID", "CurID");

                dr = dt.Select("ValueType = 1 ");/*工具箱子编号为 AA 等*/
                //在coretoolvalue中插入工具箱本体
                String nID = MyManager.GetFiledByInput("INSERT INTO CoreToolValue (rkID,State,[CoreID],[PropertyID],Value,ValueType,ParentID,ToolID) SELECT rkID,1 AS State," + CoreID + " AS CoreID,PropertyID,Value,ValueType,IDENT_CURRENT('CoreToolValue') AS ParentID,'"
                                                        + ToolID + "' AS ToolID  FROM StoredToolValue WHERE ID = " + dr[0]["ID"].ToString() + ";SELECT IDENT_CURRENT('CoreToolValue') AS CurID", "CurID");

                MyManager.ExecSQL("INSERT INTO CoreToolValue (rkID,State,[CoreID],[PropertyID],Value,ValueType,ParentID) SELECT rkID,1 AS State," + CoreID + " AS CoreID,PropertyID,Value,ValueType," + nID + " AS ParentID"
                                    + " FROM StoredToolValue WHERE ValueType =2 AND ParentID = " + dr[0]["ID"].ToString());


                dr = dt.Select("ValueType = 3");
                iToolCount = 0;
                newRank = "0";
                for (j = 0; j < Rank.Length; j++)
                {

                    String mID = MyManager.GetFiledByInput("INSERT INTO CoreToolValue (rkID,State,[CoreID],[PropertyID],Value,ValueType,ParentID,ToolID) SELECT rkID,1 AS State," + CoreID + " AS CoreID,PropertyID,Value,ValueType," + nID + " AS ParentID,'"
                                                    + ToolID + iToolCount.ToString("D3") + "' AS ToolID  FROM StoredToolValue WHERE ValueType =3 AND ID = " + Rank[j].ToString() + ";SELECT IDENT_CURRENT('CoreToolValue') AS CurID", "CurID");

                    MyManager.ExecSQL("INSERT INTO CoreToolValue (rkID,State,[CoreID],[PropertyID],Value,ValueType,ParentID) SELECT rkID,-1 AS State," + CoreID + " AS CoreID,PropertyID,Value,ValueType," + mID + " AS ParentID"
                                                    + " FROM StoredToolValue WHERE ValueType =4 AND ParentID = " + Rank[j].ToString());
                    
                    iToolCount++;
                    newRank += "|" + mID;

                }
                MyManager.ExecSQL("Update CoreTool Set Rank = '" + newRank + "' WHERE ID=" + CoreID);

            }
            else
            { //独立工具
                ToolID = MyManager.GetNextID();

                while (MyManager.SELCount("SELECT COUNT(ID) as Count From CoreToolValue Where ToolID like '" + ToolID + "%'", "Count") > 0)
                {
                    ToolID = MyManager.GetNextID();
                }

                CoreID = MyManager.GetFiledByInput("INSERT INTO CoreTool(EPC,rkID,ModelType,ModelID,ToolID,ToolName,[ModifyTime],State,[RelatedTask],Rank,PosID) SELECT '" + MyManager.GenerateEPC(ToolID) + "',rkID,ModelType,ModelID,'"
                                                        + ToolID + "' AS ToolID,StoredName AS ToolName,'" + DateTime.Now.ToString() + "' AS ModifyTime,1,'" + JO["taskid"].ToString() + "' AS RelatedTask,Rank,PosID FROM StoredTool WHERE ID = " + StoredID + ";SELECT IDENT_CURRENT('CoreTool') AS CurID", "CurID");

                dr = dt.Select("ValueType = 0 ");/*选取工具属性*/
                //在coretoolvalue中插入工具的属性
                for (d = 0; d < dr.Length; d++)
                {
                    MyManager.GetFiledByInput("INSERT INTO CoreToolValue (rkID,State,[CoreID],[PropertyID],Value,ValueType,ParentID,ToolID) SELECT rkID,1 AS State," + CoreID + " AS CoreID,PropertyID,Value,ValueType," + CoreID + " AS ParentID,'"
                                                            + ToolID + "' AS ToolID  FROM StoredToolValue WHERE ID = " + dr[d]["ID"].ToString() + ";SELECT IDENT_CURRENT('CoreToolValue') AS CurID", "CurID");
                }
            }

            MyManager.ExecSQL("DELETE FROM StoredTool WHERE ID = " + gdt.Rows[i]["ID"].ToString() + ";DELETE FROM StoredToolValue Where StoredID = " + gdt.Rows[i]["ID"].ToString());

        }
        
        MyManager.ExecSQL("INSERT INTO HitTool(TaskID,Type,TaskName,CorePerson,State) VALUES ('"+
                           TaskID + "',2,'打号任务','" + CorePerson + "',1)" );
        
         return "{\"status\":\"failed\",\"msg\":\""+"任务提交成功，请记住任务编号:" +TaskID+"\"}"; 
     
    }

    public String CreateBagExcel(JObject JO)
    {
        String ExcelURL = "";
        String DebugStr = "";
        int num = Convert.ToInt32( JO["num"].ToString());
        int BagClassID = Convert.ToInt32(JO["classid"].ToString());
        int comoption = Convert.ToInt32(JO["comoption"].ToString());/*比较选项 0:缺省比较 1：完全比较*/
        String  bagname = JO["bagname"].ToString();
        int i = 0,j,k;
        String SQL = "",Note= "",tList;
        String myPath = gCtx.Server.MapPath("~");
        
        Aspose.Cells.Workbook workbook = new Aspose.Cells.Workbook(gCtx.Server.MapPath("~") + "\\Template\\zbmb.xls");
        Aspose.Cells.Worksheet sheet = workbook.Worksheets[0];
        Aspose.Cells.Cells cells = sheet.Cells;
        DataTable dt = MyManager.GetDataSet("select A.*,B.ptype,B.Name from  [PropertyValues] AS A join CLassPropertys AS B On A.PropertyID = B.ID where A.parentid in (select distinct ID FROM [PropertyValues] where parentid = "+BagClassID+")");//存放模型ID为bagclassid的工具包中包括本体的所有工具及其属性
        DataRow[] sxdr, dr = dt.Select(" ValueType not in(2,4) ");//模型中工具列表
        sheet = workbook.Worksheets[workbook.Worksheets.AddCopy("Bak")];
        cells = sheet.Cells;
        cells[2, 0].PutValue(bagname + "x" + num + " 组包申领表");
        
        for (i = 0; i <dr.Length; i++)
        {
            cells[4+i,0].PutValue(i+1);
            cells[4+i,1].PutValue(dr[i]["Name"].ToString().Trim());
            cells[4+i, 2].PutValue(dr[i]["num"].ToString().Trim());
            cells[4 + i,4].PutValue(num);
            cells[4 + i, 5].PutValue(num * Convert.ToInt32(dr[i]["num"].ToString().Trim()));
            sxdr/*模型工具属性*/ = dt.Select(" ValueType Not IN(1,3)  AND ParentID =" + dr[i]["ID"].ToString() +(comoption == 0 ? " AND ptype = 0" : ""));
/*
            if (sxdr.Length == 0)
            {
                DebugStr += dr[i]["ID"].ToString() + "-->0   ";
                gCtx.Response.Write(DebugStr);
            }
            else
            {
                DebugStr += dr[i]["ID"].ToString() + "-->" + sxdr.Length+"   ";
            }
            
    */
            for (j=0,Note = "",SQL="";j<sxdr.Length;j++){
                Note += sxdr[j]["Name"].ToString().Trim() + ":" + sxdr[j]["Value"].ToString().Trim() + "\n\r";
                if (SQL == "")
                {
                    SQL = " SELECT distinct StoredID From  StoredToolValue Where  StoredID IN(SELECT ID FROM  StoredTool WHERE ModelID =" + dr[i]["PropertyID"].ToString() + " AND [State] = 0  )  AND PropertyID = " + sxdr[j]["PropertyID"].ToString() + " AND Value = '" + sxdr[j]["Value"].ToString() + "'";
                }else
                {
                    //SQL += " intersect (SELECT distinct StoredID From  StoredToolValue Where ValueType = " + sxdr[j]["ValueType"].ToString() + " AND PropertyID = " + sxdr[j]["PropertyID"].ToString() + " AND Value = '" + sxdr[j]["Value"].ToString() + "')";
                    SQL += " intersect (SELECT distinct StoredID From  StoredToolValue Where  PropertyID = " + sxdr[j]["PropertyID"].ToString() + " AND Value = '" + sxdr[j]["Value"].ToString() + "')";
                }          
            }
           
            sheet.Comments.Add(4+i, 1);
            sheet.Comments[4 + i, 1].Note = Note;
            //最后一步，取rkID 

            if (SQL == "")//证明这个工具在添加的时候，没有一个属性是匹配属性
            {
                SQL = "SELECT ID,rkID FROM  StoredTool WHERE ModelID =" + dr[i]["PropertyID"].ToString() + " AND [State] = 0 ";
                sheet.Comments[4 + i, 1].Note = "注意，这个工具模型没有匹配属性(用来比较的属性!),请提醒管理员。";
            }
            else
            {
               SQL = "SELECT Distinct ID,rkID From  StoredTool Where ID IN(" + SQL + ")";
            }
            
           
            DataTable RetDT = MyManager.GetDataSet(SQL);
            if (RetDT.Rows.Count >= Convert.ToInt32(dr[i]["num"].ToString())*num)
            {
                cells[4 + i, 6].PutValue("备选工具数量充足。");
            }
            else
            {
                cells[4 + i, 6].PutValue("备选工具数量不足!!");
                var s = cells[4 + i, 6].GetStyle();
                s.ForegroundColor = Color.Cyan;
                s.Pattern = BackgroundType.Solid;
                cells[4 + i, 6].SetStyle(s);  
            }
            
            
            for (k = 0, tList = ""; k < RetDT.Rows.Count; k++)
            {
                if (tList != "") tList += ",";
                
                tList += RetDT.Rows[k]["rkID"].ToString();
            }
            
            if (tList == "") tList = "无备件";
            
            cells[4 + i, 7].PutValue(tList);
                    
        }

        workbook.Worksheets.RemoveAt("Bak");
        XlsSaveOptions saveOptions = new XlsSaveOptions();
        String ExcelName = DateTime.Now.Ticks + ".xls";
        String Path = myPath + "\\Report\\" + ExcelName;
        workbook.Save(Path, saveOptions);
        ExcelURL =  "http://" + gCtx.Request.Url.Host + ":" + gCtx.Request.Url.Port  + gCtx.Request.ApplicationPath + "/Report/" + ExcelName; 
       return ExcelURL;
    }

    public String AddToCoreTool(JObject JO)//工具包入编核心函数
    {
        String TaskID = "",rkIDs="";
        Boolean bRight = false;
        String Msg="编号成功！";
        int BagID = Convert.ToInt32(JO["bagid"].ToString());
        int ComOption =  Convert.ToInt32(JO["comoption"].ToString());
        String CorePerson = JO["coreperson"].ToString();
        String BagName = JO["bagname"].ToString();
        JArray JA  = JArray.Parse(JO["list"].ToString());
        DataRow[] dr=null, dr1=null, tdr=null;
        int i, j, k, t;
        Boolean bContinue;
        DataTable RetDT;//中间表，有两列，一列为StoredID,一列为rkID
      
        ///检查bagid对应的工具包模型是否存在，顺便获取工具包模型
        DataTable dt1,dt = MyManager.GetDataSet("select A.*,B.ptype,B.Name,'' as SNs from  [PropertyValues] AS A join CLassPropertys AS B On A.PropertyID = B.ID where A.parentid in (select distinct ID FROM [PropertyValues] where parentid = " + BagID + ")");
        if (dt.Rows.Count == 0) { Msg = "该工具包模型不存在，请刷新!"; return ""; }///此处要修改！！！！
        //开始依据比较模式，比较各个工具 
        for (i = 0; i < JA.Count; i++)
        {
            if (rkIDs == "") { rkIDs = "'"+JA[i]["sn"].ToString()+"'"; }
            else {
                rkIDs += ",'" + JA[i]["sn"].ToString()+"'";
            }
            bContinue = true;
            int PID = Convert.ToInt32(JA[i]["pid"].ToString());//工具包模型内工具的id
            String SN = JA[i]["sn"].ToString();//库存工具ID

            for (k = 0; k < JA.Count; k++)
            {
                if (JA[k]["sn"].ToString() == SN.ToString() && k != i)//查重，避免SN重复出现
                {
                    Msg = "序号为" + SN + "的工具重复";
                    bContinue = false;
                    break;
                } 
                                   
            }

                tdr = dt.Select(" ValueType  in(1,3) AND ID = " + PID);
                if (tdr.Length == 0) { Msg += " 模型ID错误，ID为" + PID + "的工具不存在!"; break; }

                dr = dt.Select(" ValueType  in(2,4) AND ParentID = " + PID + (ComOption == 0 ? " AND pType = 0" : ""));
            //当该工具没有匹配属性时，下面的循环会直接结束，认为同类的库存工具和该工具相同
                dt1 /*从StoreToolvalue中选取工具比较*/ = MyManager.GetDataSet("SELECT * FROM StoredToolValue Where StoredID  IN(SELECT ID From  StoredTool Where rkID = '"+SN+"') ");

            for (j = 0; bContinue == true && j < dr.Length; j++)
            {
                 dr1 = dt1.Select(" PropertyID = " + dr[j]["PropertyID"].ToString() + " AND Value ='" +dr[j]["Value"].ToString()+ "'");
                 if (dr1.Length == 0) {
                     Msg = "序号为" + SN + "的工具，" + dr[j]["Name"].ToString() + "属性取值与模型不匹配。";
                     bContinue = false;
                     break;   
                 }
            }
            
            if (bContinue == false)
            {
                break; 
            }
            if (Convert.ToInt32(tdr[0]["num"].ToString()) > 0)
            {
                int index = dt.Rows.IndexOf(tdr[0]);
                dt.Rows[index]["num"] = Convert.ToInt32(tdr[0]["num"].ToString()) - 1;
                if (dt.Rows[index]["SNs"].ToString() == "")//将SN放入dt的SN字段
                {
                    dt.Rows[index]["SNs"] = SN;
                }else{
                    dt.Rows[index]["SNs"] = "|" + SN;
                }
            }
            else {//出错了，有多于某子工具标配数量的SN输入。
                Msg = "工具输入量超过标配。";
                break;
            } 
         
        }
        String ToolID,CoreID,StoredID;
        TaskID = "BH-" + DateTime.Now.Ticks.ToString();
        if (dt.Select(" ValueType IN(1,3) AND num>0").Length == 0) {//匹配
            bRight = true;
            Msg = "匹配";
            //获取工具编号
            ToolID = MyManager.GetNextID();

            while (MyManager.SELCount("SELECT COUNT(ID) as Count From CoreToolValue Where ToolID like '" + ToolID + "%'", "Count") > 0)
            {
                ToolID = MyManager.GetNextID();
            }
            //在coretool中插入工具包行
            RetDT = MyManager.GetDataSet("SELECT ID as StoredID,rkID,rkID as SN From StoredTool Where rkID IN(" + rkIDs+ ")");
            dr = RetDT.Select(" rkID = '" + JA[0]["sn"].ToString()+"'");

            StoredID = dr[0]["StoredID"].ToString();
            CoreID = MyManager.GetFiledByInput("INSERT INTO CoreTool(EPC,rkID,ModelType,ModelID,ToolID,ToolName,[ModifyTime],State,[RelatedTask]) SELECT '" + MyManager.GenerateEPC(ToolID) + "'as EPC,rkID,1," + BagID + " AS ModelID,'"
                                                                            + ToolID + "' AS ToolID,'" + BagName + "' AS ToolName,'" + DateTime.Now.ToString() + "' AS ModifyTime,1,'" + TaskID + "' AS RelatedTask FROM StoredTool WHERE ID = " + StoredID + ";SELECT IDENT_CURRENT('CoreTool') AS CurID", "CurID");

            dr = dt.Select("ValueType = 1 ");/*工具箱子编号为 AA 等*/
            //在coretoolvalue中插入工具箱本体
            String nID = MyManager.GetFiledByInput("INSERT INTO CoreToolValue (rkID,State,[CoreID],[PropertyID],Value,ValueType,ParentID,ToolID) SELECT rkID,1 AS State," + CoreID + " AS CoreID,ModelID,StoredName,1 as ValueType,IDENT_CURRENT('CoreToolValue') AS ParentID,'"
                                                    + ToolID + "' AS ToolID  FROM StoredTool WHERE ID = " + StoredID + ";SELECT IDENT_CURRENT('CoreToolValue') AS CurID", "CurID");

            MyManager.ExecSQL("INSERT INTO CoreToolValue (rkID,State,[CoreID],[PropertyID],Value,ValueType,ParentID) SELECT rkID,1 AS State," + CoreID + " AS CoreID,PropertyID,Value,2 AS ValueType," + nID + " AS ParentID"
                                + " FROM StoredToolValue WHERE  ParentID = " +StoredID);

            int  iToolCount = 0;
            String newRank = "0";
            for (j = 1; j <JA.Count; j++)
            {
                dr = RetDT.Select(" rkID = '" + JA[j]["sn"].ToString()+"'");

                StoredID = dr[0]["StoredID"].ToString();
                String mID = MyManager.GetFiledByInput("INSERT INTO CoreToolValue (rkID,State,[CoreID],[PropertyID],Value,ValueType,ParentID,ToolID) SELECT rkID,1 AS State," + CoreID + " AS CoreID,ModelID,StoredName,3 as ValueType," + nID + " AS ParentID,'"
                                                + ToolID + iToolCount.ToString("D3") + "' AS ToolID  FROM StoredTool WHERE  ID = " + StoredID + ";SELECT IDENT_CURRENT('CoreToolValue') AS CurID", "CurID");

                MyManager.ExecSQL("INSERT INTO CoreToolValue (rkID,State,[CoreID],[PropertyID],Value,ValueType,ParentID) SELECT rkID,-1 AS State," + CoreID + " AS CoreID,PropertyID,Value,4 as ValueType," + mID + " AS ParentID"
                                                + " FROM StoredToolValue WHERE ParentID = " + StoredID);

                iToolCount++;
                newRank += "|" + mID;

            }
            MyManager.ExecSQL("Update CoreTool Set Rank = '" + newRank + "' WHERE ID=" + CoreID);
            //删除storedtool和其value表中数据
            MyManager.ExecSQL("DELETE FROM StoredToolValue Where StoredID IN( SELECT ID as StoredID  FROM StoredTool Where rkID IN (" + rkIDs + "))");
            MyManager.ExecSQL("DELETE  FROM StoredTool Where rkID IN (" + rkIDs + ")");

           MyManager.ExecSQL("INSERT INTO HitTool(TaskID,Type,TaskName,CorePerson,State) VALUES ('" +
                               TaskID + "',2,'打号任务','" + CorePerson + "',1)");
            Msg = "入编成功,任务号为:" + TaskID; 
        }
       

        return "{\"status\":\""+(bRight==true?"success":"failed")+"\",\"msg\":\"" + Msg + "\",\"taskid\":\""+TaskID+"\"}";
    }
    public String GetPeronList(int TaskID)
    {       
        return GetGeneralJSONRetBySQL("SELECT ID as id ,Name as name From UserList Order by UserName");        
    }

    public String GetBorrowPeronListByTaskID(int TaskID)
    {
        return GetGeneralJSONRetBySQL("SELECT A.UserID as id,B.Name as name From PreBrowersList AS A join UserList AS B on A.UserID = B.ID where A.Taskid = " + TaskID + " Order by name");
    }
    public String ModifyBorrowPerson(int TaskID,int UserID,String Type)
    {
        //String okjson = "{\"status\":\"success\",\"msg\":\"添加成功!\",\"borrowcount\":";
        if (Type == "Add")
        {
            if (MyManager.SELCount("select count(id) as icount from PreBrowersList where taskid=" + TaskID + " and userid =" + UserID, "icount") > 0)
            {
                return "{\"status\":\"failed\",\"msg\":\"该人员已经存在!\"}";
            }
            else
            {
                MyManager.ExecSQL("insert into PreBrowersList(taskid,userid) values(" + TaskID + "," + UserID + ") ");
                return "{\"status\":\"success\",\"msg\":\"添加成功!\"}";
            }
        }
        if (Type == "Del")
        {
            if (MyManager.SELCount("select count(id) as icount from PreBrowersList where taskid=" + TaskID + " and userid =" + UserID, "icount") > 0)
            {
                if (MyManager.SELCount("select count(id) as icount from PreBrowersList where taskid=" + TaskID, "icount") > 1)
                {
                    MyManager.ExecSQL("delete from PreBrowersList where taskid = " + TaskID + " and userid=" + UserID);
                    return "{\"status\":\"success\",\"msg\":\"添加成功!\"}";
                }else
                    return "{\"status\":\"failed\",\"msg\":\"至少要保留一个人来借工具!\"}";                
            }
            else
            {
                return "{\"status\":\"failed\",\"msg\":\"该人员不存在!\"}";
            }
        }
        return "";
    }

    public String GetbrwerCount( int TaskID)
    {
        return MyManager.GetFiledByInput("SELECT count(ID) as iCount from [PreBrowersList] Where TaskID = " + TaskID, "iCount");
    }

    public String GetUserInfoByID(int UserID)
    {
        DataTable dt = MyManager.GetDataSet("select name,CorpName  FROM [UserList] AS A join Corps AS B on A.CorpID = B.CorpID where A.ID =" + UserID);

        if (dt.Rows.Count == 0)
        {
            return "{\"status\":\"failed\",\"type\":\"GetUserInfoByID\",\"name\":\"null\",\"msg\":\"该用户不存在!\"}"; 
        }

        return "{\"status\":\"success\",\"type\":\"GetUserInfoByID\",\"name\":\"" + dt.Rows[0]["name"].ToString() + "\",\"corpname\":\"" + dt.Rows[0]["CorpName"].ToString() + "\"}";
    }

    public String GetBorwTaskListBytUserID(int UserID)
    {
        StringWriter sw = new StringWriter();
        JsonWriter jWrite = new JsonTextWriter(sw);
        int i = 0;
        DataTable dt = MyManager.GetDataSet("SELECT  B.Name+'('+C.Name+')' as showName,B.ID FROM [PreBrowersList] AS A join Tasks AS B on A.Taskid = B.ID join UserList as C on B.CreateUser = C.ID where (B.State = 1 OR B.State = 2 ) AND UserID = " + UserID);

        jWrite.WriteStartArray();
        for (i = 0; i < dt.Rows.Count; i++)
        {
            jWrite.WriteStartObject();
            jWrite.WritePropertyName("showname");
            jWrite.WriteValue(dt.Rows[i]["showName"].ToString());
            jWrite.WritePropertyName("taskid");
            jWrite.WriteValue(dt.Rows[i]["ID"].ToString());
            jWrite.WriteEndObject();
        }
        jWrite.WriteEndArray();

       return "{\"status\":\"success\",\"tasklist\":"+sw.ToString()+"}";
    }


    public String GetBorrowInfoByTaskID(int TaskID)
    {
        StringWriter sw = new StringWriter();
        JsonWriter jWrite = new JsonTextWriter(sw);
        int i;
        DataTable dt = MyManager.GetDataSet("Select * From [ToolApp] where TaskID = " + TaskID);
        String RetJson;

        jWrite.WriteStartArray();
        for (i = 0; i < dt.Rows.Count; i++)
        {
            jWrite.WriteStartObject();
            jWrite.WritePropertyName("appid");
            jWrite.WriteValue(dt.Rows[i]["ID"].ToString());
            jWrite.WritePropertyName("toolname");
            jWrite.WriteValue(dt.Rows[i]["WantToolName"].ToString());
            jWrite.WritePropertyName("toolid");
            jWrite.WriteValue(dt.Rows[i]["WantToolID"].ToString());
            jWrite.WritePropertyName("appstate");
            jWrite.WriteValue(dt.Rows[i]["State"].ToString());
            if (dt.Rows[i]["State"].ToString() == "0")
            {
                jWrite.WritePropertyName("liketools");
                RetJson = GetIdenticalTool(JObject.Parse("{\"coreid\":\"" + dt.Rows[i]["CoreID"].ToString() + "\",\"toolstate\":\"0\",\"cmpoption\":\"0\"}"));
                //gCtx.Response.Write(RetJson);
                JObject JO = JObject.Parse(RetJson);
                jWrite.WriteValue(JO["data"].ToString());
            }
            else 
            {
                jWrite.WritePropertyName("borrowedtoolname");
                jWrite.WriteValue(dt.Rows[i]["borrowedtoolname"].ToString());
                jWrite.WritePropertyName("borrowedtoolcoreid");
                jWrite.WriteValue(dt.Rows[i]["CoreID"].ToString());
                jWrite.WritePropertyName("borrowedtoolid");
                jWrite.WriteValue(dt.Rows[i]["borrowedtoolid"].ToString());
            }
            jWrite.WriteEndObject();
        }
        jWrite.WriteEndArray();

        return "{\"status\":\"success\",\"data\":"+sw.ToString()+"}";

    }

    public String BorrowORRefundTool(JObject JO)
    {
        long AppID = Convert.ToInt32(JO["appid"].ToString());
        long UserID = Convert.ToInt32(JO["userid"].ToString());
        String opType =JO["optype"].ToString();
        String ToolID = JO["toolid"].ToString();
        String ToolName = System.Web.HttpUtility.UrlDecode(JO["toolname"].ToString(), System.Text.Encoding.UTF8) ;
        String username = System.Web.HttpUtility.UrlDecode(JO["username"].ToString(), System.Text.Encoding.UTF8);
        String Pic = JO["pic"].ToString();
        
        DataTable dt = MyManager.GetDataSet("SELECT * From ToolApp WHERE ID = " + AppID);
        DataTable dt1 =  MyManager.GetDataSet("SELECT * FROM CoreTool AS A join ToolState AS B  on A.State = B.StateID WHERE ToolID = '" + ToolID+ "'");
       
        if (dt.Rows.Count < 1)
        {
            return "{\"status\":\"failed\",\"msg\":\"该记录不存在，请刷新！\"}";  
        }
        if (dt1.Rows.Count < 1)
        {
            return "{\"status\":\"failed\",\"msg\":\"该编号的工具不存在！\"}";
        }
        String AppState = dt.Rows[0]["State"].ToString();
        
        if (opType == "borrow")
        {
            if (AppState == "1")
            {
                return "{\"status\":\"failed\",\"msg\":\"该申请已外借,请刷新.\"}";  
            }
            else if (AppState == "2")
            {
                return "{\"status\":\"failed\",\"msg\":\"工具已归还,如借,请重新申请!\"}"; 
            }
            else if (AppState == "0")
            {
                if (ToolID == "" || ToolName =="")
                {
                    return "{\"status\":\"failed\",\"msg\":\"工具编号或名称不可为空！\"}";  
                }
                if (dt1.Rows[0]["State"].ToString() != "0")
                {
                    return "{\"status\":\"failed\",\"msg\":\"该工具状态为[" + dt1.Rows[0]["StateName"].ToString() + "],不可借出!\"}"; 
                }
                if (1 == MyManager.ExecSQL("UPDATE  ToolApp Set State = 1,borrowtime='" + DateTime.Now.ToString() + "',borrowerid = '" + UserID + "',borrowername='" + username + "',borrowedtoolid='" + ToolID + "',borrowedtoolname='" + ToolName + "',borrowpic = '" + Pic + "' WHERE ID = " + AppID))
                {
                    MyManager.ExecSQL("UPDATE CoreTool SET State = 2 WHERE ToolID = '" + ToolID + "'");
                    return "{\"status\":\"success\",\"msg\":\"工具借用成功！\"}";
                }
                else {
                    return "{\"status\":\"success\",\"msg\":\"工具借用失败！\"}";
                }
                  
            }   
            else
            {
                return "{\"status\":\"failed\",\"msg\":\"申请状态错误,请重新申请!\"}"; 
            }
        }
        else
        {
            if (AppState == "1")
            {
                if (ToolID == "" || ToolName == "")
                {
                    return "{\"status\":\"failed\",\"msg\":\"工具编号或名称不可为空！\"}";
                }

                if (dt.Rows[0]["borrowedtoolid"].ToString() != ToolID)
                {
                    return "{\"status\":\"failed\",\"msg\":\"借出编号" + dt.Rows[0]["borrowedtoolid"].ToString() + "与归还工具编号不符！\"}";  
                }
                if (dt1.Rows[0]["State"].ToString() != "2")
                {
                    return "{\"status\":\"failed\",\"msg\":\"该工具状态为[" + dt1.Rows[0]["StateName"].ToString() + "],不可借出!\"}";
                }
                
                MyManager.ExecSQL("UPDATE CoreTool SET State = 0 WHERE ToolID = '" + ToolID + "'");
                
                if (1 == MyManager.ExecSQL("UPDATE  ToolApp Set State = 2,refundtime='" + DateTime.Now.ToString() + "',refunderid = '" + UserID + "',refundername='" + username + "',refundpic = '" + Pic + "' WHERE ID = " + AppID))
                {
                    if (MyManager.SELCount("SELECT Count(*) as Num From ToolApp WHERE State in (0,1) AND TaskID=" + dt.Rows[0]["TaskId"].ToString(), "Num") == 0)
                    {
                        //当该任务下面所有工具均已归还时，任务自动关闭
                        MyManager.ExecSQL("UPDATE Tasks SET State = 10 WHERE ID = " + dt.Rows[0]["TaskID"].ToString());
                    } 
                    return "{\"status\":\"success\",\"msg\":\"工具归还成功！\"}";
                }
                else
                {
                    return "{\"status\":\"success\",\"msg\":\"工具归还失败！\"}";
                }
            }
            else if (AppState == "2")
            {
                return "{\"status\":\"failed\",\"msg\":\"工具已归还!\"}";
            }
            else if (AppState == "0")
            {
                return "{\"status\":\"failed\",\"msg\":\"工具还未借出!\"}";                

            }
            else
            {
                return "{\"status\":\"failed\",\"msg\":\"申请状态错误,请重新申请!\"}";
            }
            
        }
    }


    public String GetToolBorrowHistory(JObject JO)
    {
     String toolid = "";
     String toolname = "";
     String borrowername = "";
     String borrowstime = ""; 
     String borrowetime = "";
     String refundername = "";
     String refundstime = "";
     String refundetime = "";
     String SQL = "";
     String apper = "";
        
        toolid = JO["toolid"] == null ? "" : JO["toolid"].ToString();
        toolname = JO["toolname"] == null ? "" : JO["toolname"].ToString();
        borrowername = JO["borrowername"] == null ? "" : JO["borrowername"].ToString();
        borrowstime = JO["borrowstime"] == null ? "" : JO["borrowstime"].ToString();
        borrowetime = JO["borrowetime"] == null ? "" : JO["borrowetime"].ToString();
        refundername = JO["refundername"] == null ? "" : JO["refundername"].ToString();
        refundstime = JO["refundstime"] == null ? "" : JO["refundstime"].ToString();
        refundetime = JO["refundetime"] == null ? "" : JO["refundetime"].ToString();
        apper = JO["apper"] == null ? "" : JO["apper"].ToString();

        SQL = "SELECT A.*,B.Name FROM ToolApp AS A join UserList  AS B on B.ID = A.UserID  WHERE 1=1 ";

        if (apper != "")
        {
            SQL += " AND Name like '%" + apper + "%' ";
        }
        
        if (toolid != "")
        {
            SQL += " AND case isnull([BorrowedToolID],'') when '' then [WantToolID] else [BorrowedToolID] end   = '" + toolid + "'"; 
        }
        
        if (toolname != "")
        {
            SQL += " AND case isnull([BorrowedToolName],'') when '' then [WantToolName] else [BorrowedToolName] end  like '%" + toolname + "%'";
        }

        if (borrowername != "")
        {
            SQL += " AND case isnull([BorrowerName],'') when '' then A.[UserName] else [BorrowerName] end like '%" + borrowername + "%'";
        }

        if (borrowstime != "")
        {
            SQL += " AND borrowtime >= '" + borrowstime + "'";
        }

        if (borrowetime != "")
        {
            SQL += " AND borrowtime <= '" + borrowetime + "'";
        }

        if (refundername  != "")
        {
            SQL += " AND refundername like '%" + refundername + "%'";
        }

        if (refundstime != "")
        {
            SQL += " AND refundtime >= '" + refundstime + "'";
        }

        if (refundetime != "")
        {
            SQL += " AND refundtime <= '" + refundetime + "'";
        }

        return GetGeneralJSONRetBySQL(SQL);

    }
    public String devGetInfo(JObject JO)
    {
        String Type = JO["type"].ToString();
        DataTable dt = MyManager.GetDataSet("SELECT Info From devInfo Where Type='" +Type+ "'");
        if (dt.Rows.Count == 0)
        {
            return "{\"status\":\"failed\",\"info\":\"\"}"; 
        }

        return "{\"status\":\"success\",\"info\":\"" + dt.Rows[0]["Info"].ToString() + "\"}"; 
    }

    public String GetToolPos(JObject JO)
    {
        String ToolID = JO["toolid"].ToString();
        DataTable dt = MyManager.GetDataSet("SELECT PosX,PosY,RealState From CoreTool Where ToolID = '" + ToolID + "'");
        String PosX,PosY,RealState;
        if (dt.Rows.Count == 0)
        {
            return "{\"status\":\"failed\",\"msg\":\"工具不存在!\"}";
        }

        if (dt.Rows[0]["PosX"] == System.DBNull.Value)
        {
             PosX = "X";     
        }else
        {
            PosX=dt.Rows[0]["PosX"].ToString();
        }
        if (System.DBNull.Value == dt.Rows[0]["PosY"])
        {
            PosY = "X";  
        }            
        else {
            PosY = dt.Rows[0]["PosY"].ToString();
            
        }
        if (System.DBNull.Value == dt.Rows[0]["RealState"])
        {
            RealState = "-1";
        }
        else
        {
            RealState = dt.Rows[0]["RealState"].ToString();

        }


        return "{\"status\":\"success\",\"posx\":\""+PosX+"\",\"posy\":\""+PosY+"\",\"realstate\":\""+RealState+"\"}";
                        
        
    }

    public String CheckOldSNExist(String oldsn)
    {
        if (MyManager.CheckSNExist(oldsn.ToString()))
        {
            return "{\"status\":\"failed\",\"msg\":\"序号"+oldsn+"已经存在!\"}";
        }
        return "{\"status\":\"success\",\"msg\":\"序号" + oldsn + "可以使用!\",\"oldsn\":\""+oldsn+"\"}";
    }
    public String ModifyPropertyName(JObject JO)
    {
            //首先查看该工具类中该属性ID是否存在
        DataTable dt;
        dt = MyManager.GetDataSet("SELECT ID FROM ClassPropertys WHERE NodeType = 3 AND ID =" + Convert.ToInt32(JO["propertyid"].ToString()) + " AND ParentID = " + Convert.ToInt32(JO["cid"].ToString()));
        if (dt.Rows.Count == 0)
        {
            return "{\"status\":\"failed\",\"msg\":\"该属性不存在!\"}";
        }
        if (JO["newname"].ToString().Trim().IndexOf(" ") != -1 || JO["newname"].ToString().Trim().IndexOf("'") != -1 || JO["newname"].ToString().Trim() == "")
        {
            return "{\"status\":\"failed\",\"msg\":\"属性名中不可含有分号或者空格!\"}";
        }//查看是否有重名属性
        dt = MyManager.GetDataSet("SELECT ID FROM ClassPropertys WHERE PARENTID = " + Convert.ToInt32(JO["cid"].ToString()) + " AND NodeType =3 AND ID <>" + Convert.ToInt32(JO["propertyid"].ToString()) + "  AND Name = '" + JO["newname"].ToString().Trim() + "'");
        if (dt.Rows.Count !=0 )
        {
             return "{\"status\":\"failed\",\"msg\":\"该属性与其他属性重名!\"}";
        }

        MyManager.ExecSQL("Update ClassPropertys Set Name = '" + JO["newname"].ToString().Trim() + "'" + " WHERE ID =" + Convert.ToInt32(JO["propertyid"].ToString()));
        return "{\"status\":\"success\",\"msg\":\"属性名修改成功!\"}";
    }
    
    public String CheckBagIDValid (JObject JO)
    {
        String BagID = JO["bagid"].ToString().Trim();// like AA AB AC
        if (BagID == "" || BagID.IndexOf(" ")!=-1 || BagID.IndexOf("'")!=-1)
        {
            return "{\"status\":\"failed\",\"isvalid\":\"false\",\"msg\":\"识别号不能为空,且不可含分号空格!\"}";
        }

        DataTable dt = MyManager.GetDataSet("SELECT ToolName FROM CoreTool WHERE ToolID = '" + JO["bagid"].ToString() + "' AND ModelType = 1 ");
        if (dt.Rows.Count == 0)
        {
            return "{\"status\":\"failed\",\"msg\":\"工具包"+BagID+"不存在!\"}";    
        }
        return "{\"status\":\"success\",\"isvalid\":\"true\",\"msg\":\"ok!\",\"bagname\":\"" + dt.Rows[0]["ToolName"].ToString() + "\"}";  
    }
    public String ModifyCoreTool(JObject JO)
    {
                //6:修改包内工具(CoreTool)
                //7:修改工具箱本体(CoreTool)
                //8:修改独立工具(CoreTool)

        String ToolID = JO["toolid"].ToString().Trim().ToUpper(), newToolID,CoreID ;
        String newBagID = JO["bagid"].ToString().Trim().ToUpper(), OldBagID;
        String Type = JO["type"].ToString().Trim();
        String ToolName = JO["toolname"].ToString().Trim();
        String OldBag;
        String SQL = "";
        int ClassID = Convert.ToInt32(JO["classid"].ToString());
        if (ToolID == "" || ToolID.IndexOf(" ") != -1 || ToolID.IndexOf("'") != -1 || newBagID.IndexOf(" ") != -1 || newBagID.IndexOf(",") != -1 || ToolName.IndexOf("'") != -1 || ToolName.IndexOf(" ") != -1)
        {
            return "{\"status\":\"failed\",\"msg\":\"工具识别号和工具名中不能含有空格和引号!\"}";
        }

        DataTable dt = MyManager.GetDataSet("SELECT * FROM CoreToolValue Where ToolID = '" +ToolID+ "'");
        DataTable dt1 = MyManager.GetDataSet("SELECT * FROM CoreTool Where ModelType = 1 AND State = 0 AND ToolID = '" + newBagID + "'");
        if (Type!="8" && dt.Rows.Count==0)//这里的dt不适用于独立工具
        {
            return "{\"status\":\"failed\",\"msg\":\"识别号为"+ToolID+"的工具不存在!\"}";
        }

        if (Type == "6")//6:修改包内工具(CoreTool)
        {
            DataTable tdt = MyManager.GetDataSet("SELECT ToolID FROM CoreTool WHERE State =0 AND ID = " + dt.Rows[0]["CoreID"].ToString());
            if (tdt.Rows.Count == 0)
            {
                return "{\"status\":\"failed\",\"msg\":\"数据错误，包内工具竟然没有所在工具包!\"}";    
            }
            OldBagID = tdt.Rows[0]["ToolID"].ToString();
            if (OldBagID != newBagID)//工具包更改
            {
                if (newBagID == "")//变为独立工具
                {
                    newToolID = MyManager.GetNextID();
                    CoreID = MyManager.GetFiledByInput("INSERT INTO CoreTool(EPC,rkID,ModelType,ModelID,ToolID,ToolName,[ModifyTime],State,[RelatedTask]) SELECT '"+MyManager.GenerateEPC(newToolID)+"' AS EPC,rkID,0," + ClassID + ",'"
                                                                + newToolID + "' AS ToolID,'" + ToolName + "','" + DateTime.Now.ToString() + "' AS ModifyTime,0,NULL FROM CoreToolValue WHERE ToolID = '" + ToolID + "';SELECT IDENT_CURRENT('CoreTool') AS CurID", "CurID");
                  //删除该包内工具行和其所有属性行
                  MyManager.ExecSQL("DELETE FROM CoreToolValue WHERE ID = '" + dt.Rows[0]["ID"].ToString() + "' OR ParentID = '" + dt.Rows[0]["ID"].ToString() + "'");
                  //

                  JArray JA = JArray.Parse(JO["values"].ToString());
                  SQL = "";

                  foreach (JToken jt in JA)
                  {
                      JObject jobj = (JObject)jt;
                      if (jobj["value"].ToString().IndexOf("'") != -1 || jobj["value"].ToString().IndexOf(" ") != -1) { return "{\"status\":\"failed\",\"msg\":\"属性取值不允许含有分号(')或者空格!\"}"; }
                      //查看该属性值之前是否存在SELECT ID  
                      int iRet = Convert.ToInt32(MyManager.GetFiledByInput("SELECT Count(*) AS Count FROM [PropertyValues] where PropertyID =" + jobj["propertyid"].ToString() + " AND Value = '" + jobj["value"].ToString() + "' AND (ParentID is NULL or ParentID=0)", "Count"));
                      if (iRet == 0)//该属性值之前不存在，现在添加到属性值列表中
                      {
                          MyManager.ExecSQL("INSERT INTO PropertyValues (PropertyID,Value,ValueType) VALUES (" + jobj["propertyid"].ToString() + ",'" + jobj["value"].ToString() + "',0)");
                      }
                      SQL += "INSERT INTO [CoreToolValue] ([CoreID],[PropertyID],[Value],[ValueType],[ParentID],State) VALUES (" + CoreID + "," + jobj["propertyid"].ToString() + ",'" + jobj["value"].ToString() + "',0," + CoreID + ",-1);";
                  }

                  MyManager.ExecSQL(SQL);

                  return "{\"status\":\"success\",\"msg\":\"工具修改成功，已变为独立工具-->"+newToolID+".\"}";
                    
                }
                else
                {

                    if (dt1.Rows.Count == 0)
                    {
                        return "{\"status\":\"failed\",\"msg\":\"新工具包不存在啊！\"}";
                    }
                    else
                    {
                        CoreID = dt1.Rows[0]["ID"].ToString();
                        newToolID = MyManager.FindNextTooIDInBag(newBagID);
                        if (newToolID == "")
                        {
                            return "{\"status\":\"failed\",\"msg\":\"获取新工具识别号失败，请联系李光耀!\"}"; 
                        }
                        String BagIDOfnewBag /*工具包中工具箱本体的ID(CoreToolValue)*/ = MyManager.GetFiledByInput("SELECT ID FROM CoreToolValue WHERE ValueType = 1 AND CoreID = " +dt1.Rows[0]["ID"].ToString(),"ID");
                        if(BagIDOfnewBag=="")
                        {
                           return "{\"status\":\"failed\",\"msg\":\"获取新工具包中工具箱本体ID失败，请联系李光耀!\"}"; 
                        }
                        MyManager.ExecSQL("UPDATE CoreToolValue Set CoreID = "+dt1.Rows[0]["ID"].ToString() +
                            ",ParentID=" + BagIDOfnewBag + ",PropertyID="+ClassID + ",Value='" +ToolName+"',ModifyTime='" +DateTime.Now.ToString()+ "',ValueType=3,ToolID='" +newToolID+ "' WHERE ID= " +dt.Rows[0]["ID"].ToString());

                        MyManager.ExecSQL("DELETE FROM CoreToolValue WHERE  ParentID = '" + dt.Rows[0]["ID"].ToString() + "'");
                        //

                        JArray JA = JArray.Parse(JO["values"].ToString());
                        SQL = "";

                        foreach (JToken jt in JA)
                        {
                            JObject jobj = (JObject)jt;
                            if (jobj["value"].ToString().IndexOf("'") != -1 || jobj["value"].ToString().IndexOf(" ") != -1) { return "{\"status\":\"failed\",\"msg\":\"属性取值不允许含有分号(')或者空格!\"}"; }
                            //查看该属性值之前是否存在SELECT ID  
                            int iRet = Convert.ToInt32(MyManager.GetFiledByInput("SELECT Count(*) AS Count FROM [PropertyValues] where PropertyID =" + jobj["propertyid"].ToString() + " AND Value = '" + jobj["value"].ToString() + "' AND (ParentID is NULL or ParentID=0)", "Count"));
                            if (iRet == 0)//该属性值之前不存在，现在添加到属性值列表中
                            {
                                MyManager.ExecSQL("INSERT INTO PropertyValues (PropertyID,Value,ValueType) VALUES (" + jobj["propertyid"].ToString() + ",'" + jobj["value"].ToString() + "',0)");
                            }
                            SQL += "INSERT INTO [CoreToolValue] ([CoreID],[PropertyID],[Value],[ValueType],[ParentID],State) VALUES (" + CoreID + "," + jobj["propertyid"].ToString() + ",'" + jobj["value"].ToString() + "',4," + dt.Rows[0]["ID"].ToString() + ",-1);";
                        }

                        MyManager.ExecSQL(SQL);
                        return "{\"status\":\"success\",\"msg\":\"工具修改成功，新识别号为-->" +newToolID+ ".\"}";  
                    }
                }
            }
            else//不换包
            {
                MyManager.ExecSQL("UPDATE CoreToolValue Set PropertyID=" + ClassID + ",Value='" + ToolName + "',ModifyTime='" + DateTime.Now.ToString() + "' WHERE ID= " + dt.Rows[0]["ID"].ToString());

                MyManager.ExecSQL("DELETE FROM CoreToolValue WHERE ParentID = '" + dt.Rows[0]["ID"].ToString() + "'");
                //

                JArray JA = JArray.Parse(JO["values"].ToString());
                SQL = "";

                foreach (JToken jt in JA)
                {
                    JObject jobj = (JObject)jt;
                    if (jobj["value"].ToString().IndexOf("'") != -1 || jobj["value"].ToString().IndexOf(" ") != -1) { return "{\"status\":\"failed\",\"msg\":\"属性取值不允许含有分号(')或者空格!\"}"; }
                    //查看该属性值之前是否存在SELECT ID  
                    int iRet = Convert.ToInt32(MyManager.GetFiledByInput("SELECT Count(*) AS Count FROM [PropertyValues] where PropertyID =" + jobj["propertyid"].ToString() + " AND Value = '" + jobj["value"].ToString() + "' AND (ParentID is NULL or ParentID=0)", "Count"));
                    if (iRet == 0)//该属性值之前不存在，现在添加到属性值列表中
                    {
                        MyManager.ExecSQL("INSERT INTO PropertyValues (PropertyID,Value,ValueType) VALUES (" + jobj["propertyid"].ToString() + ",'" + jobj["value"].ToString() + "',0)");
                    }
                    SQL += "INSERT INTO [CoreToolValue] ([CoreID],[PropertyID],[Value],[ValueType],[ParentID],State) VALUES (" + dt1.Rows[0]["ID"].ToString() + "," + jobj["propertyid"].ToString() + ",'" + jobj["value"].ToString() + "',4," + dt.Rows[0]["ID"].ToString() + ",-1);";
                }

                MyManager.ExecSQL(SQL);
                return "{\"status\":\"success\",\"msg\":\"工具修改成功,未换包.\"}";  
            }

        }
        else if (Type == "7")//修改工具箱本体
        {
            if (dt.Rows[0]["ValueType"].ToString() != "1")
            {
                return "{\"status\":\"failed\",\"msg\":\"该工具非工具箱本体，与任务类型不匹配.\"}";
            }

            CoreID = dt.Rows[0]["CoreID"].ToString();

            MyManager.ExecSQL("UPDATE CoreToolValue Set PropertyID=" + ClassID + ",Value='" + ToolName + "',ModifyTime='" + DateTime.Now.ToString() + "',ValueType=1 WHERE ID= " + dt.Rows[0]["ID"].ToString());

            MyManager.ExecSQL("DELETE FROM CoreToolValue WHERE  ValueType = 2 AND ParentID = '" + dt.Rows[0]["ID"].ToString() + "'");
            //

            JArray JA = JArray.Parse(JO["values"].ToString());
            SQL = "";

            foreach (JToken jt in JA)
            {
                JObject jobj = (JObject)jt;
                if (jobj["value"].ToString().IndexOf("'") != -1 || jobj["value"].ToString().IndexOf(" ") != -1) { return "{\"status\":\"failed\",\"msg\":\"属性取值不允许含有分号(')或者空格!\"}"; }
                //查看该属性值之前是否存在SELECT ID  
                int iRet = Convert.ToInt32(MyManager.GetFiledByInput("SELECT Count(*) AS Count FROM [PropertyValues] where PropertyID =" + jobj["propertyid"].ToString() + " AND Value = '" + jobj["value"].ToString() + "' AND (ParentID is NULL or ParentID=0)", "Count"));
                if (iRet == 0)//该属性值之前不存在，现在添加到属性值列表中
                {
                    MyManager.ExecSQL("INSERT INTO PropertyValues (PropertyID,Value,ValueType) VALUES (" + jobj["propertyid"].ToString() + ",'" + jobj["value"].ToString() + "',0)");
                }
                SQL += "INSERT INTO [CoreToolValue] ([CoreID],[PropertyID],[Value],[ValueType],[ParentID],State) VALUES (" + CoreID + "," + jobj["propertyid"].ToString() + ",'" + jobj["value"].ToString() + "',2," + dt.Rows[0]["ID"].ToString() + ",-1);";
            }

            MyManager.ExecSQL(SQL);
            return "{\"status\":\"success\",\"msg\":\"工具箱本体修改成功!\"}"; 
            
        }
        else if (Type == "8")//修改独立工具
        {
            
            dt = MyManager.GetDataSet("SELECT * FROM CoreTool Where ModelType = 0 AND State = 0 AND ToolID = '" + ToolID + "'");
            if (dt.Rows.Count == 0)
            {
                return "{\"status\":\"failed\",\"msg\":\"该独立工具不存在或其不在库!\"}";  
            }
            
            if (newBagID != "")//独立工具进包
            {
                if (dt1.Rows.Count == 0)
                {
                    return "{\"status\":\"failed\",\"msg\":\"目的工具包不存在 !\"}";
                }
                
               newToolID = MyManager.FindNextTooIDInBag(newBagID);
               CoreID = dt1.Rows[0]["ID"].ToString();
               String BagIDOfnewBag /*工具包中工具箱本体的ID(CoreToolValue)*/ = MyManager.GetFiledByInput("SELECT ID FROM CoreToolValue WHERE ValueType = 1 AND CoreID = " + dt1.Rows[0]["ID"].ToString(), "ID");
               String NewIDInCoreToolValue = MyManager.GetFiledByInput("INSERT INTO [CoreToolValue] (rkID,ToolID,[CoreID],[PropertyID],[Value],[ValueType],[ParentID],State) VALUES ('" + dt.Rows[0]["rkID"].ToString() + "','" + newToolID + "'," + dt1.Rows[0]["ID"].ToString() + "," + ClassID + ",'" + ToolName + "',3," + BagIDOfnewBag + ","+dt.Rows[0]["State"].ToString()+");SELECT IDENT_CURRENT('CoreToolValue') AS CurID", "CurID");

               MyManager.ExecSQL("DELETE FROM CoreTool WHERE ID = '" + dt.Rows[0]["ID"].ToString() + "'");
               MyManager.ExecSQL("DELETE FROM CoreToolValue WHERE  ParentID = '" + dt.Rows[0]["ID"].ToString() + "'");

               JArray JA = JArray.Parse(JO["values"].ToString());
               SQL = "";

               foreach (JToken jt in JA)
               {
                   JObject jobj = (JObject)jt;
                   if (jobj["value"].ToString().IndexOf("'") != -1 || jobj["value"].ToString().IndexOf(" ") != -1) { return "{\"status\":\"failed\",\"msg\":\"属性取值不允许含有分号(')或者空格!\"}"; }
                   //查看该属性值之前是否存在SELECT ID  
                   int iRet = Convert.ToInt32(MyManager.GetFiledByInput("SELECT Count(*) AS Count FROM [PropertyValues] where PropertyID =" + jobj["propertyid"].ToString() + " AND Value = '" + jobj["value"].ToString() + "' AND (ParentID is NULL or ParentID=0)", "Count"));
                   if (iRet == 0)//该属性值之前不存在，现在添加到属性值列表中
                   {
                       MyManager.ExecSQL("INSERT INTO PropertyValues (PropertyID,Value,ValueType) VALUES (" + jobj["propertyid"].ToString() + ",'" + jobj["value"].ToString() + "',0)");
                   }
                   SQL += "INSERT INTO [CoreToolValue] ([CoreID],[PropertyID],[Value],[ValueType],[ParentID],State) VALUES (" + CoreID + "," + jobj["propertyid"].ToString() + ",'" + jobj["value"].ToString() + "',4," + NewIDInCoreToolValue + ",-1);";
               }

               MyManager.ExecSQL(SQL);
               return "{\"status\":\"success\",\"newid\":\"" + NewIDInCoreToolValue + "\",\"msg\":\"独立工具入包成功-->" + newToolID + "\"}";  
            }
            else { //独立工具修改属性
                CoreID = dt.Rows[0]["ID"].ToString();
                MyManager.ExecSQL("UPDATE CoreTool SET  ModelID=" + ClassID + ",ToolName='" + ToolName + "',ModifyTime='" + DateTime.Now.ToString() + "' WHERE ID= " + dt.Rows[0]["ID"].ToString());

                MyManager.ExecSQL("DELETE FROM CoreToolValue WHERE  ParentID = '" + dt.Rows[0]["ID"].ToString() + "'");
                //

                JArray JA = JArray.Parse(JO["values"].ToString());
                SQL = "";

                foreach (JToken jt in JA)
                {
                    JObject jobj = (JObject)jt;
                    if (jobj["value"].ToString().IndexOf("'") != -1 || jobj["value"].ToString().IndexOf(" ") != -1) { return "{\"status\":\"failed\",\"msg\":\"属性取值不允许含有分号(')或者空格!\"}"; }
                    //查看该属性值之前是否存在SELECT ID  
                    int iRet = Convert.ToInt32(MyManager.GetFiledByInput("SELECT Count(*) AS Count FROM [PropertyValues] where PropertyID =" + jobj["propertyid"].ToString() + " AND Value = '" + jobj["value"].ToString() + "' AND (ParentID is NULL or ParentID=0)", "Count"));
                    if (iRet == 0)//该属性值之前不存在，现在添加到属性值列表中
                    {
                        MyManager.ExecSQL("INSERT INTO PropertyValues (PropertyID,Value,ValueType) VALUES (" + jobj["propertyid"].ToString() + ",'" + jobj["value"].ToString() + "',0)");
                    }
                    SQL += "INSERT INTO [CoreToolValue] ([CoreID],[PropertyID],[Value],[ValueType],[ParentID],State) VALUES (" + CoreID + "," + jobj["propertyid"].ToString() + ",'" + jobj["value"].ToString() + "',0," + dt.Rows[0]["ID"].ToString() + ",-1);";
                }

                MyManager.ExecSQL(SQL);
            }
            return "{\"status\":\"success\",\"msg\":\"独立工具修改成功!\"}";  
        }

        return "{\"status\":\"failed\",\"msg\":\"无此任务类型！\"}";
          
    }
    public String DePackBag(JObject JO)
    {
        String BagID, BagName;
        BagID = JO["bagid"].ToString().Trim();
        BagName = JO["bagname"].ToString();
        int i;
        if(BagID.IndexOf(" ")!=-1 || BagID.IndexOf("'")!=-1)
        {
           return "{\"status\":\"failed\",\"msg\":\"不可含空格与引号!\"}";
        }
        DataTable dt = MyManager.GetDataSet("SELECT * FROM CoreTool Where ModelType = 1 AND  ToolID = '" + BagID + "'");
        String CoreID = dt.Rows[0]["ID"].ToString();
        DataTable dt1 = MyManager.GetDataSet("SELECT * FROM CoreToolValue WHERE (ValueType = 1 OR ValueType =3) AND CoreID=" + CoreID);
        String ToolIDVal = "",newToolID;
        for (i = 0; i < dt1.Rows.Count; i++)
        {
            String ID = dt1.Rows[i]["ID"].ToString();
            newToolID = MyManager.GetNextID();
            ToolIDVal += " " + newToolID;
            CoreID = MyManager.GetFiledByInput("INSERT INTO CoreTool(EPC,rkID,ModelType,ModelID,ToolID,ToolName,[ModifyTime],State,[RelatedTask]) SELECT '"+MyManager.GenerateEPC(newToolID)+"' AS EPC,rkID,0,PropertyID,'"
                                                               + newToolID + "' AS ToolID,Value,'" + DateTime.Now.ToString() + "' AS ModifyTime,State,NULL FROM CoreToolValue WHERE ID = '" + dt1.Rows[i]["ID"].ToString() + "';SELECT IDENT_CURRENT('CoreTool') AS CurID", "CurID");

            MyManager.ExecSQL("UPDATE CoreToolValue Set ValueType =0, CoreID = " + CoreID + ",ParentID = " + CoreID + ",ModifyTime='" + DateTime.Now.ToString() + "' WHERE (ValueType = 4 OR ValueType =2) AND ParentID= " + ID);

            MyManager.ExecSQL("DELETE FROM CoreToolValue WHERE ID = " + ID);
        }
        MyManager.ExecSQL("DELETE FROM CoreTool WHERE ID = " + dt.Rows[0]["ID"].ToString());
        return "{\"status\":\"success\",\"msg\":\"拆包成功，识别号范围:"+ToolIDVal+"\"}";
    }

    public String ManualAddToolBag(JObject JO)
    {
        String ToolID/*工具箱本体的识别号*/, BagName, newToolID;
        ToolID = JO["toolid"].ToString().Trim();
        BagName = JO["bagname"].ToString().Trim();
        String newID,CoreID;
        if(ToolID.IndexOf(" ")!=-1 || ToolID.IndexOf("'")!=-1 || BagName.IndexOf(" ")!=-1 || BagName.IndexOf("'")!=-1)
        {
           return "{\"status\":\"failed\",\"msg\":\"不可含空格与引号!\"}"; 
        }
        DataTable dt = MyManager.GetDataSet("SELECT * FROM CoreTool WHERE State =0 AND ModelType=0 AND ToolID='" +ToolID+ "'");
        if (dt.Rows.Count == 0)
        {
            return "{\"status\":\"failed\",\"msg\":\"工具箱"+ToolID+"本体不在库或者不存在!\"}";   
        }
        newToolID = MyManager.GetNextID();
        CoreID = MyManager.GetFiledByInput("INSERT INTO CoreTool(EPC,rkID,ModelType,ModelID,ToolID,ToolName,[ModifyTime],State,[RelatedTask]) SELECT '"+MyManager.GenerateEPC(newToolID)+"',rkID,1,0,'"
                                                              + newToolID + "' AS ToolID,'" + BagName + "','" + DateTime.Now.ToString() + "' AS ModifyTime,State,NULL FROM CoreTool WHERE ID = '" + dt.Rows[0]["ID"].ToString() + "';SELECT IDENT_CURRENT('CoreTool') AS CurID", "CurID");


        newID = MyManager.GetFiledByInput("INSERT INTO CoreToolValue(ParentID,CoreID,rkID,ValueType,ToolID,PropertyID,Value,[ModifyTime],State) SELECT " + CoreID + "," + CoreID + ",rkID,1,'"
                                                              + newToolID + "' AS ToolID,ModelID,ToolName,'" + DateTime.Now.ToString() + "' AS ModifyTime,State FROM CoreTool WHERE ID = '" + dt.Rows[0]["ID"].ToString() + "';SELECT IDENT_CURRENT('CoreToolValue') AS CurID", "CurID");

        MyManager.ExecSQL("UPDATE CoreToolValue SET CoreID="+CoreID +",ValueType=2,ParentID="+newID +" WHERE ValueType=0 AND  CoreID=" + dt.Rows[0]["ID"].ToString());
        MyManager.ExecSQL("DELETE FROM CoreTool WHERE ID = " + dt.Rows[0]["ID"].ToString());
        return "{\"status\":\"success\",\"msg\":\"加包成功，识别号为:"+newToolID+"\"}"; 
    }
    public String CloseTheTask(JObject JO)
    {
        int TaskID = Convert.ToInt32(JO["taskid"].ToString());
        DataTable dt = MyManager.GetDataSet("SELECT ID,State FROM Tasks WHERE ID=" + TaskID);
        if (dt.Rows.Count == 0)
        {
            return "{\"status\":\"failed\",\"msg\":\"该任务不存在!\"}"; 
        }
        if (dt.Rows[0]["State"].ToString() == "10")
        {
            return "{\"status\":\"failed\",\"msg\":\"该任务已经关闭\"}";   
        }
        dt = MyManager.GetDataSet("SELECT ID FROM ToolApp WHERE State = 1 AND TaskID = " + TaskID);
        if (dt.Rows.Count != 0)
        {
            return "{\"status\":\"failed\",\"msg\":\"该任务中有借出未还的工具，不允许关闭!\"}";  
        }
        MyManager.ExecSQL("UPDATE Tasks SET State = 10 WHERE ID =" + TaskID);
        MyManager.ExecSQL("DELETE FROM TaskProcess WHERE TaskID =" + TaskID);
        //  Session["UserID"] = dt.Rows[0]["ID"];
        //  Session["Name"] = dt.Rows[0]["Name"];
        MyManager.ExecSQL("INSERT INTO TaskLog (TaskID,CreateUserID,CreateUserName,Title,Content,DateTime) Values (" + TaskID + "," + gCtx.Session["UserID"].ToString() + ",'" + gCtx.Session["Name"].ToString() + "','关闭任务','" + JO["content"].ToString() + "','"+DateTime.Now.ToString()+"')");
        return "{\"status\":\"success\",\"msg\":\"任务关闭成功!\"}"; 
    }
    
    public String GetCheckList(JObject JO)
    {
        String UserID = gCtx.Session["UserID"].ToString();
        StringWriter sw = new StringWriter();
        JsonWriter jWrite = new JsonTextWriter(sw);
        DataTable dt = MyManager.GetDataSet("SELECT * FROM CheckList WHERE UserID = '"  +UserID+ "'");

        jWrite.WriteStartArray();       
        
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            jWrite.WriteStartObject();
            jWrite.WritePropertyName("id");
            jWrite.WriteValue(dt.Rows[i]["CheckCode"].ToString());
            jWrite.WritePropertyName("name");
            jWrite.WriteValue(dt.Rows[i]["CheckName"].ToString());
            jWrite.WriteEndObject();    
        }        
        
        jWrite.WriteEndArray();

        return "{\"status\":\"success\",\"msg\":\"获取成功!\",\"data\":" + sw.ToString() +"}";  
    }

    public String GetToolPosID(JObject JO)
    {
        String rkID = JO["rkid"].ToString();
        String PosID = MyManager.GetFiledByInput("SELECT PosID FROM StoredTool WHERE rkID='" + rkID + "'", "PosID");
        
        return "{\"status\":\"success\",\"msg\":\"获取成功!\",\"posid\":\""+PosID+"\"}"; 
    }

    public String SetToolPosID(JObject JO)
    {
        String rkID = JO["rkid"].ToString();
        MyManager.ExecSQL("UPDATE StoredTool Set PosID = '" + JO["posid"].ToString() + "' WHERE rkID = '" + rkID + "'");
        return "{\"status\":\"success\",\"msg\":\"设置成功!\"}";
    }

    public String StartCheck(JObject JO)//创建盘点任务或者切换盘点任务
    {
        String CheckCode = JO["checkcode"].ToString().Trim();
        String CheckName = JO["checkname"].ToString().Trim();
        DataTable dt = MyManager.GetDataSet("SELECT * FROM CheckList WHERE CheckCode = '" +CheckCode+ "' OR CheckName = '" +CheckName+"'");
        if (dt.Rows.Count > 0)//切换盘点任务
        {
            DataTable dt1 = MyManager.GetDataSet("SELECT distinct  CoreTool.CheckCode,CheckName FROM CoreTool,CheckList WHERE CoreTool.CheckCode = CheckList.CheckCode AND  CoreTool.CheckCode <> '" + CheckCode + "' AND CheckStatus = 1 AND CoreTool.ID IN (SELECT CoreID FROM CheckRelation WHERE CheckCode = '" + CheckCode + "')");
            if (dt1.Rows.Count == 0)//跟其他盘点任务没有交叉
            {
                MyManager.ExecSQL("UPDATE CoreTool SET CheckStatus = '1',CheckCode='" + CheckCode + "' WHERE ID IN (SELECT CoreID FROM CheckRelation WHERE CheckCode = '" + CheckCode + "')");
                return "{\"status\":\"success\",\"msg\":\"进入盘点成功!\"}";    
            }
            else//可能是该任务正在盘点中或者跟其他任务的盘点工具有交叉;
            {
                String str="";
                for (int i = 0; i < dt1.Rows.Count; i++)
                {
                    str += " " + dt1.Rows[i]["CheckName"].ToString();
                }

                return  "{\"status\":\"failed\",\"msg\":\"该任务跟"+str +"有交叉工具，不可重复盘点!\"}";    
            
            }  
                
        }else{//创建盘点任务

            dt = MyManager.GetDataSet("SELECT ID FROM CoreTool WHERE TmpCheckCode='" + CheckCode+ "'");
            if (dt.Rows.Count == 0)
            {
                return "{\"status\":\"failed\",\"msg\":\"师傅，请先进行查询后再创建盘点！\"}";  
            }
            
            DataTable dt1 = MyManager.GetDataSet("SELECT distinct  CoreTool.CheckCode,CheckName FROM CoreTool,CheckList WHERE CoreTool.CheckCode = CheckList.CheckCode AND  TmpCheckCode = '" + CheckCode + "' AND CheckStatus<>0 ");
                
                if (dt1.Rows.Count !=0)
                {
                    String str = "";
                    for (int i = 0; i < dt1.Rows.Count; i++)
                    {
                        str += " " + dt1.Rows[i]["CheckName"].ToString();
                    }
                    
                    return "{\"status\":\"failed\",\"msg\":\"您箱创建的盘点跟其他任务("+str+")有重叠工具,且该任务正在盘点中，无法创建当前盘点!\"}";  
                }
               
                
                MyManager.ExecSQL("INSERT INTO CheckList (CheckCode,CheckName,UserID,Name,StartTime) VALUES ('" +CheckCode + "','"+CheckName + "','"+gCtx.Session["UserID"].ToString()+"','"+gCtx.Session["Name"].ToString()+"','"+DateTime.Now.ToString()+"')");
                MyManager.ExecSQL("INSERT INTO CheckRelation (IDType,CoreID,CheckCode) SELECT '0',ID,'"+CheckCode+"' FROM CoreTool WHERE TmpCheckCode = '" +CheckCode+"'");
                MyManager.ExecSQL("INSERT INTO CheckRelation (IDType,CoreID,CheckCode) SELECT '1',ID,'" + CheckCode + "' FROM CoreToolValue WHERE CoreID IN(SELECT ID FROM CoreTool WHERE ModelType = '1' AND TmpCheckCode = '" + CheckCode + "'" +") AND ValueType = '3' )");
 
            MyManager.ExecSQL("UPDATE CoreTool SET CheckStatus = 1,CheckCode='" + CheckCode + "' WHERE TmpCheckCode = '" + CheckCode + "'");
                return "{\"status\":\"success\",\"msg\":\"创建盘点成功!!\"}";  
        }
        //
    }

    public String StopCheck(JObject JO) 
    {
        String CheckCode = JO["checkcode"].ToString().Trim();
        MyManager.ExecSQL("UPDATE CoreTool SET CheckStatus = '0' WHERE CheckCode='" + CheckCode + "'");
      
         return "{\"status\":\"success\",\"msg\":\"该盘点结束成功!\"}";  
          
    }

    public String ExitCheck(JObject JO)
    {
        String CheckCode = JO["checkcode"].ToString().Trim();
        MyManager.ExecSQL("UPDATE CoreTool SET CheckStatus = '0' WHERE CheckCode='" + CheckCode + "'");

        return "{\"status\":\"success\",\"msg\":\"该盘点结束成功!\"}";  
    }
   public void ProcessRequest (HttpContext context) 
   {

        int i = 0;
        String json_old = "",Cmd = "",retJSON = "";
        context.Response.ContentType = "text/plain";
        gCtx = context;
       try
        {
            
         StreamReader reader = new StreamReader(context.Request.InputStream);
            json_old = reader.ReadToEnd();
           /* if (json == "")
            {
                context.Response.Write(context.Session["UserID"].ToString());
                return;
            }*/
           // if (gCtx.Session["UserID"] == null) { context.Response.Write("{\"status\":\"failed\",\"msg\":\"请登陆!\"}"); return; }
            JObject JO = JObject.Parse(json_old);
             Cmd = JO["cmd"].ToString();
            
            //获取工具模型树
            
           if (Cmd == "getModelTree")
            {
                retJSON = "{\"status\":\"success\",\"data\":" + GetClassTreeJSON() + "}";
            }
          
            //获取某个工具模型属性列表

           if (Cmd == "getClassTree")
           {
               retJSON = "{\"status\":\"success\",\"data\":" + GetClassProperty(Convert.ToInt32(JO["classid"].ToString())) + "}";
           }

           if (Cmd == "getClassAndProperty")
           {
               retJSON = "{\"status\":\"success\",\"data\":" + GetClassAndProperty(Convert.ToInt32(JO["classid"].ToString()), Convert.ToInt32(JO["type"].ToString()), JO["toolid"].ToString() == "" ? "0" : JO["toolid"].ToString()) + "}";
           }
           
           if (Cmd == "addPropertyValue")
           {
               if (JO["value"].ToString().IndexOf("'") != -1 || JO["value"].ToString().IndexOf(" ") != -1)
               {
                   retJSON = "{\"status\":\"failed\",\"msg\":\"不允许含有分号(')或者空格!\"}" ;
                   context.Response.Write(retJSON);
                   return;
               }

               retJSON = addPropertyValue(Convert.ToInt32(JO["PropertyID"].ToString()), JO["value"].ToString());
           }
           //retJSON = "{\"status\":\"success\",\"data\":" + GetClassProperty(Convert.ToInt32(2)) + "}";

           if (Cmd == "ChangePropertyNecessary")
           {
               retJSON = ChangePropertyNecessary(Convert.ToInt32(JO["propertyid"].ToString()), Convert.ToInt32(JO["necessary"]));
               
           }

           if (Cmd == "ChangePropertyCompare")
           {
               retJSON = ChangePropertyCompare(Convert.ToInt32(JO["propertyid"].ToString()), Convert.ToInt32(JO["compare"]));

           }


           if (Cmd == "addProperty")
           {
               if (JO["name"].ToString().IndexOf("'") != -1 || JO["name"].ToString().IndexOf(" ") != -1)
               {
                   retJSON = "{\"status\":\"failed\",\"msg\":\"不允许含有分号(')或者空格!\"}" ;
                   context.Response.Write(retJSON);
                   return;
               }

               retJSON = addProperty(Convert.ToInt32(JO["classid"].ToString()), JO["name"].ToString(), Convert.ToInt32(JO["necessary"].ToString()), Convert.ToInt32(JO["compare"].ToString()));
           }

           if (Cmd == "getToolBagModel")
           {
               retJSON = "{\"status\":\"success\",\"data\":" + GetToolBagModelJSON(Convert.ToInt32(JO["bagid"].ToString()), Convert.ToInt32(JO["type"].ToString())) + "}"; 
           }

           if (Cmd == "AddClass")
           {
               if (JO["name"].ToString().IndexOf("'") != -1 || JO["name"].ToString().IndexOf(" ") != -1)
               {
                   retJSON = "{\"status\":\"failed\",\"msg\":\"不允许含有分号(')或者空格!\"}";
                   context.Response.Write(retJSON);
                   return;
               }

              retJSON = addClass(JO["name"].ToString());
           }

           if (Cmd == "GetClassList") {
               retJSON = "{\"status\":\"success\",\"data\":" + GetClassList() + "}";
           }

           if (Cmd == "addToolBag" || Cmd == "addToolToBag" ||Cmd == "ModifyBagOrTool")
           {
               retJSON = addFun(JO);

           }

           if (Cmd == "StoreTool")
           {
               retJSON = HitTool_StoreTool(JO);
           }

           if (Cmd == "StoreToolBag")
           {
               retJSON = HitTool_StoreTool(JO);
           }

           if (Cmd == "GetToolBagList")
           {
               retJSON = "{\"status\":\"success\",\"data\":" + GetToolBagList() + "}";
           }
           if (Cmd == "GetPropertysByClassID")
           {
               retJSON = "{\"status\":\"success\",\"data\":" + GetPropertysByClassID(Convert.ToInt32(JO["classid"].ToString())) + "}";
           }
           if (Cmd == "GetValuesByPropertyID")
           {
               retJSON = "{\"status\":\"success\",\"data\":" + GetValuesByPropertyID(Convert.ToInt32(JO["propertyid"].ToString())) + "}";
           }
           if (Cmd == "StoreSearch")
           {
               retJSON = "{\"status\":\"success\",\"data\":" + StoreSearch(JO) + "}";
           }
           if (Cmd == "ToolSearch")
           {
               retJSON = ToolSearch(JO) ;
           }
           if (Cmd == "GetStoreBagInfo")
           {
               retJSON = GetStoreBagInfo(Convert.ToInt32(JO["bagid"].ToString()));
           }
           if (Cmd == "HitTool")/*工具打号*/
           {
               retJSON = HitTool_CoreTool(JO);
           }
           if (Cmd == "RankTool")
           {
               retJSON = RankTool(JO);
           }
           if (Cmd == "GetIdenticalTool")
           {
               retJSON = GetIdenticalTool(JO);
           }
           if (Cmd == "AddToBorrow")
           {
               retJSON = AddToBorrow(JO);
           }
           if (Cmd == "test")
           {
               retJSON = "{\"status\":\"failed\",\"data\":\"" + Test(context) + "\"}";
           }
           if (Cmd == "GetWantToBorrowCount")
           {
               retJSON = "{\"status\":\"success\",\"count\":\"" + GetWantToBorrowCount(Convert.ToInt32( JO["taskid"].ToString())) + "\"}"; 
           }
           if (Cmd == "GetBorrowInfo") {

               retJSON = "{\"status\":\"success\",\"data\":" + GetBorrowInfo(Convert.ToInt32(JO["taskid"].ToString())) + "}";
           }
           if (Cmd == "DelBorrowApp")
           {
               retJSON = "{\"status\":\"success\",\"msg\":\"" + DelBorrowApp(JO) + "\"}";
           }
           if (Cmd == "GetToolState") {
               retJSON = "{\"status\":\"success\",\"toolstate\":\"" + GetToolState(JO["toolid"].ToString()) + "\"}";
           }
           if (Cmd == "BorrowToolByID")
           {
               retJSON = "{\"status\":\"success\",\"msg\":\"" + BorrowToolByID(JO) + "\"}";
           }
           if (Cmd == "RefundToolByAppID")
           {
               retJSON = "{\"status\":\"success\",\"msg\":\"" + RefundToolByAppID(JO) + "\"}"; 
           }
           if (Cmd == "AddToTmpHitTool")
           {
               retJSON = "{\"status\":\"success\",\"msg\":\"" + AddToTmpHitTool(JO) + "\"}";
           }
           if (Cmd == "GetTmpHitToolCountByTaskID")
           {
               retJSON = "{\"status\":\"success\",\"count\":\"" + GetTmpHitToolByTaskID(JO) + "\"}";
           }
           if (Cmd == "GetTmpHitToolInfobyTaskID")
           {
               retJSON = "{\"status\":\"success\",\"data\":" + GetTmpHitToolInfobyTaskID(JO) + "}";
           }

           if (Cmd == "DelTmpHitToolByrkID")
           {
               retJSON = "{\"status\":\"success\",\"msg\":\"" + DelTmpHitToolByrkID(JO) + "\"}";
           }
           if (Cmd == "tijiao")
           {
               retJSON = tijiao(JO);
           }
           if (Cmd == "CreateBagExcel")
           {
               retJSON = "{\"status\":\"success\",\"msg\":\"申领表生成成功！\",\"data\":\"" + CreateBagExcel(JO) + "\"}"; 
           }
           if (Cmd == "AddToCoreTool")
           {
               retJSON = AddToCoreTool(JO); 
           }
           if (Cmd == "GetPeronList")
           {
               retJSON = GetPeronList(Convert.ToInt32(JO["TaskID"].ToString()));
           }
           if (Cmd == "GetBorrowPeronListByTaskID")
           {
               retJSON = GetBorrowPeronListByTaskID(Convert.ToInt32(JO["TaskID"].ToString()));  
           }
           if (Cmd == "ModifyBorrowPerson")
           {
               retJSON = ModifyBorrowPerson(Convert.ToInt32(JO["taskid"].ToString()), Convert.ToInt32(JO["userid"].ToString()), JO["type"].ToString());
           }
           if (Cmd == "GetbrwerCount")
           {
               retJSON = GetbrwerCount(Convert.ToInt32(JO["taskid"].ToString()));
           }
           if (Cmd == "GetUserInfoByID")
           {
               retJSON = GetUserInfoByID(Convert.ToInt32(JO["userid"].ToString()));
           }
           if (Cmd == "GetBorwTaskListBytUserID")
           {
               retJSON = GetBorwTaskListBytUserID(Convert.ToInt32(JO["userid"].ToString()));
           }
           if (Cmd == "GetBorrowInfoByTaskID")
           {
               retJSON = GetBorrowInfoByTaskID(Convert.ToInt32(JO["taskid"].ToString()));
           }
           if (Cmd == "GetToolBorrowHistory")
           {
               retJSON = GetToolBorrowHistory(JO);

           }
           if (Cmd == "GetToolPos")
           {
               retJSON = GetToolPos(JO);
           }

           if (Cmd == "BRTool")
           {
               retJSON = BorrowORRefundTool(JO);
           }
           if (Cmd == "LinuxTest")
           {
               //retJSON = Encoding.Default.GetString(Encoding.Convert(System.Text.Encoding.UTF8, System.Text.Encoding.Default, Encoding.GetEncoding("UTF-8").GetBytes(JO["name"].ToString())));
              // retJSON = System.Web.HttpUtility.UrlDecode(JO["name"].ToString(), System.Text.Encoding.Default);
               retJSON = "gyLinuxer";
           }
           if (Cmd == "devGetInfo")
           {
               retJSON = devGetInfo(JO);
            }
           if (Cmd == "CheckOldSNExist")
           {
               retJSON = CheckOldSNExist(JO["oldsn"].ToString());
           }

           if (Cmd == "ModifyPropertyName")
           {
               retJSON = ModifyPropertyName(JO);  
           }

           if (Cmd == "CheckBagIDValid")
           {
               retJSON = CheckBagIDValid(JO);
           }

           if (Cmd == "ModifyCoreTool")
           {
               retJSON = ModifyCoreTool(JO); 
           }

           if (Cmd == "DePackBag")
           {
               retJSON = DePackBag(JO); 
           }

           if (Cmd == "ManualAddToolBag")
           {
               retJSON = ManualAddToolBag(JO); 
           }
          
           if (Cmd == "ToolSearchToExcel")
           {
               retJSON = ToolSearchToExcel(JO); 
           }

           if (Cmd == "CloseTheTask")
           {
               retJSON = CloseTheTask(JO); 
           }
           if (Cmd == "GetToolPosID")//获取货位编码
           {
               retJSON = GetToolPosID(JO);
           }
           if (Cmd == "SetToolPosID")//设置货位编码
           {
               retJSON = SetToolPosID(JO);
           }
           if (Cmd == "ToolSearchForCheck")//创建盘点任务
           {
               retJSON = ToolSearchForCheck(JO);
           }

           if (Cmd == "GetCheckList")
           {
               retJSON = GetCheckList(JO); 
           }

           if (Cmd == "StartCheck")
           {
               retJSON = StartCheck(JO);
           }

           if (Cmd == "StopCheck")
           {
               retJSON = StopCheck(JO);
           }
           
           if (Cmd == "ExitCheck")
           {
               retJSON = ExitCheck(JO);
           }
           
           
           
           context.Response.Write(retJSON);
        }
        catch (Exception ee)
        {
            context.Response.Write(json_old);
            context.Response.Write("{\"status\":\"failed\",\"msg\":\""+ee.ToString()+ "\"}");
        }
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}