﻿<%@ WebHandler Language="C#" Class="Handler" %>

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

    public String GetClassAndProperty(int ClassID, int Type/* 任务类型 1:添加工具包 2:添加包内工具 3:修改工具箱模型 4:修改包内工具模型*/,int ToolID)
    {
        String ValueName = "", PropertyID = "",ValueID="",Num="1";
        int ValueType = 0;
        StringWriter sw = new StringWriter();
        JsonWriter jWrite = new JsonTextWriter(sw);
        DataTable dt1 = null, dt = MyManager.GetDataSet("SELECT  A.ID,A.Name,A.necessary,B.value,B.ID AS vID,A.pType FROM CLassPropertys AS A  left join [PropertyValues] as B on (B.propertyID = A.ID AND B.ValueType = 0 AND (B.ParentID  = 0 or B.ParentID is NULL) ) where A.ParentID=" + ClassID + " order by A.ID");
        //字段中的vID代表属性某个取值的ID
        DataRow[] dr;
        jWrite.WriteStartArray();
        if (Type == 3)//修改工具箱
        {
            ValueType = TOOL_BAG_PROPERTY;
            dt1 = MyManager.GetDataSet("SELECT  [ID],[PropertyID],[Value],[ValueType],[Num],[ParentID] FROM [PropertyValues] WHERE (ValueType =" + ValueType + " ) AND (ParentID = " + ToolID + " OR ID=" + ToolID + ")");
        }
        else if (Type == 4)//修改包内工具
        {
            ValueType = TOOL_IN_BAG_PROPERTY ;
            dt1 = MyManager.GetDataSet("SELECT  [ID],[PropertyID],[Value],[ValueType],[Num],[ParentID] FROM [PropertyValues] WHERE (ValueType =" + TOOL_IN_BAG + " OR ValueType = "+TOOL_IN_BAG_PROPERTY+" ) AND (ParentID = " + ToolID + " OR ID=" + ToolID + ")");
            
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
                    return "{\"status\":\"failed\",\"msg\":\"该工具箱名已存在，请更换！\"}";
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
               MyManager.ExecSQL("UPDATE PropertyValues Set Rank = " + CurBagID + " WHERE ID = " + CurBagID);
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
    public String ToolSearch(JObject JO)/*对coretable中的工具进行查询，已经编号的*/
    {
        /*{ range: -1, name: "所有", ret:返回范围 "all"所有 "tool"工具 "bag"工具包, specific:[
         *                                                                              { tid: ToolClassID, name: ToolClassName, vals: [
         *                                                                                                                                  { name: PropertyName, pid: PropertyID, val: Value }
         * ] }
         * ] };*/
        String json = "";
        int i, j, k, fw = 0/*范围：0所有 1工具包 2 工具*/;
        String txt, SQL = "", SQL1 = "";
        String IDdl = "", IDbn = "";//独立 和 包内
        DataTable dt, dt1, dt2;
        DataRow[] dr, dr1;

        JObject Filter = (JObject)JO["Filter"];
        JArray Specific = (JArray)Filter["specific"];

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
                SQL = "(SELECT distinct ID AS CoreID FROM CoreTool WHERE ModelType = 0 AND ModelID = " + Specific[i]["tid"].ToString() + ")";

                JArray JV = (JArray)Specific[i]["vals"];
                for (j = 0; j < JV.Count; j++)
                {
                    SQL += " Intersect (SELECT distinct CoreID FROM [CoreToolValue] WHERE CoreID IN " + "(SELECT distinct ID AS StoredID FROM CoreTool WHERE ModelType = 0 AND ModelID = " + Specific[i]["tid"].ToString() + ")" + " AND ValueType = 0 AND PropertyID = " + JV[j]["pid"].ToString() + (JV[j]["val"].ToString() != "zkgy-1" ? " AND Value = '" + JV[j]["val"].ToString() + "')" : ")");
                }

                dt1 = MyManager.GetDataSet(SQL); //独立工具，将StoreID集合

                for (k = 0; k < dt1.Rows.Count; k++)
                {
                    IDdl += (IDdl == "" ? dt1.Rows[k]["CoreID"].ToString() : "," + dt1.Rows[k]["CoreID"].ToString());
                }
            }
        }


        StringWriter sw = new StringWriter();
        JsonWriter jWrite = new JsonTextWriter(sw);
        jWrite.WriteStartArray();
        if ((fw == 1 || fw == 0) && IDbn != "")
        {
            dt = MyManager.GetDataSet("SELECT rkID,A.*,B.StateName,C.StateName as RStateName FROM CoreTool AS A left join ToolState AS B on A.State = B.StateID left join ToolState AS C on A.RealState = C.StateID WHERE ID IN(" + IDbn + ")");//工具包
            dt1 = MyManager.GetDataSet("SELECT rkID,StateName,('V' + convert(varchar(10) ,A.ID)) as ID,A.ID as rID,[CoreID],[PropertyID],[Value] as name ,[ValueType],[ParentID],ToolID  FROM [CoreToolValue] AS A left join ToolState AS B on A.State = B.StateID WHERE (ValueType = 3 OR ValueType = 1) AND  CoreID IN(" + IDbn + ")");//包内工具集合
            dt2 = MyManager.GetDataSet("SELECT rkID,B.Name,[Value],A.[ParentID] FROM [CoreToolValue] as A join ClassPropertys as B on A.propertyID = B.ID  where (ValueType = 4 or ValueType = 2) AND  CoreID IN(" + IDbn + ")");//属性集合
            for (i = 0; i < dt.Rows.Count; i++)
            {
                jWrite.WriteStartObject();
                jWrite.WritePropertyName("id");
                jWrite.WriteValue(dt.Rows[i]["ID"].ToString());
                jWrite.WritePropertyName("rkid");
                jWrite.WriteValue(dt.Rows[i]["rkID"].ToString());
                jWrite.WritePropertyName("toolid");
                jWrite.WriteValue(dt.Rows[i]["toolid"].ToString());
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
                jWrite.WritePropertyName("sx");
                jWrite.WriteStartArray();
                dr = dt2.Select(" ParentID = " + dt.Rows[i]["ID"].ToString());
                for (j = 0; j < dr.Length; j++)
                {
                    jWrite.WriteStartObject();
                    jWrite.WritePropertyName("name");
                    jWrite.WriteValue(dr[j]["name"].ToString());
                    jWrite.WritePropertyName("value");
                    jWrite.WriteValue(dr[j]["Value"].ToString());
                    jWrite.WriteEndObject();
                }
                jWrite.WriteEndArray();
                jWrite.WritePropertyName("children");
                jWrite.WriteStartArray();
                dr = dt1.Select(" CoreID = " + dt.Rows[i]["ID"].ToString());
                for (j = 0; j < dr.Length; j++)
                {
                    jWrite.WriteStartObject();
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

        if ((fw == 2 || fw == 0) && IDdl != "")
        {
            dt1 = MyManager.GetDataSet("SELECT rkID,A.*,B.StateName,C.StateName as RStateName FROM CoreTool AS A left join ToolState AS B on A.State = B.StateID left join ToolState AS C on A.RealState = C.StateID WHERE ID IN(" + IDdl + ")");
            dt2 = MyManager.GetDataSet("SELECT rkID,B.Name,[Value],A.[CoreID] FROM [CoreToolValue] as A join ClassPropertys as B on A.propertyID = B.ID  where ValueType = 0 AND  CoreID IN(" + IDdl + ")");//属性集合
            for (i = 0; i < dt1.Rows.Count; i++)
            {
                jWrite.WriteStartObject();
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
                jWrite.WritePropertyName("iconCls");
                jWrite.WriteValue("icon-tool");
                jWrite.WritePropertyName("type");
                jWrite.WriteValue("tool");
                jWrite.WritePropertyName("sx");
                jWrite.WriteStartArray();
                dr1 = dt2.Select(" CoreID = " + dt1.Rows[i]["ID"].ToString());
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

        }
        jWrite.WriteEndArray();
        return sw.ToString();
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
        String StoreID, ToolID, HitTaskID = JO["taskid"].ToString(),newRank="0";
        DataRow[] dr;
        String[] Rank;
        int iRet =0;
        /* 任务类型 Type
         *  5之外的任何取值:工具包入库
            5:独立工具入库
*/
        
        /***************开始对工具编号**************/

        DataTable dt = MyManager.GetDataSet("SELECT * FROM PropertyValues Where ParentID =" + ClassID );
        for (i = 0; i < HitNum; i++)
        {


            if (Type != 5)//工具包入库
            {
                newRank = "0";
                ToolID = MyManager.GetNextFlowID();

                //在coretool中插入工具包行
                StoreID = MyManager.GetFiledByInput("INSERT INTO StoredTool([rkID],[StoredName],[ModelID],[ModelType],[StoreTime],[RelatedTask],[State]) SELECT "
                                                        + ToolID + " AS rkID,Value AS StoreName,"+ClassID+" AS ModelID ,1,'" + DateTime.Now.ToString() + "' AS StoreTime,'" + JO["taskid"].ToString() + "' AS RelatedTask,4 AS State FROM PropertyValues WHERE ID = " + ClassID + ";SELECT IDENT_CURRENT('StoredTool') AS CurID", "CurID");

                dr = dt.Select(" ID = " + ClassID);
                Rank = dr[0]["Rank"].ToString().Split('|');
                dr = dt.Select("ValueType = 1 ");/*工具箱*/
                //在Storedtoolvalue中插入工具箱本体及其属性
       
                String BagID = MyManager.GetFiledByInput("INSERT INTO StoredToolValue (StoredID,rkID,[PropertyID],Value,ValueType,ParentID) SELECT " + StoreID + " AS StoredID," + ToolID + " AS rkID,PropertyID,Value,ValueType,IDENT_CURRENT('StoredToolValue') AS ParentID"
                                                        + " FROM PropertyValues WHERE ID = " + dr[0]["ID"].ToString() + ";SELECT IDENT_CURRENT('StoredToolValue') AS CurID", "CurID");

                MyManager.ExecSQL("INSERT INTO StoredToolValue (StoredID,rkID,[PropertyID],Value,ValueType,ParentID) SELECT " + StoreID + " AS StoredID,NULL AS rkID,PropertyID,Value,ValueType," + BagID + " AS ParentID"
                                    + " FROM PropertyValues WHERE ValueType =2 AND ParentID = " + dr[0]["ID"].ToString());

                //按照rank字段进行排列
                for (j = 1; j < Rank.Length; j++)
                {
                    String subToolID = MyManager.GetFiledByInput("INSERT INTO StoredToolValue (StoredID,rkID,[PropertyID],Value,ValueType,ParentID) SELECT " + StoreID + " AS StoredID," + MyManager.GetNextFlowID() + " AS rkID,PropertyID,Value,ValueType," + BagID + " AS ParentID"
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
                    StoreID = MyManager.GetFiledByInput("INSERT INTO StoredTool (RelatedTask,[State],rkID,Rank,[StoredName],[ModelID],[ModelType],[StoreTime]) VALUES ('"+JO["taskid"].ToString()+"',4," + MyManager.GetNextFlowID() + ",NULL,'"
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
                CoreID = MyManager.GetFiledByInput("INSERT INTO CoreTool(ModelType,ModelID,ToolID,ToolName,[ModifyTime],State,[RelatedTask],Rank) SELECT ModelType,ModelID,'"
                                                                                + ToolID + "' AS ToolID,StoredName AS ToolName,'" + DateTime.Now.ToString() + "' AS ModifyTime,1,'" + JO["taskid"].ToString() + "' AS RelatedTask,Rank FROM StoredTool WHERE ID = " + StoredID + ";SELECT IDENT_CURRENT('CoreTool') AS CurID", "CurID");

                dr = dt.Select("ValueType = 1 ");/*工具箱子编号为 AA 等*/
                //在coretoolvalue中插入工具箱本体
                String nID = MyManager.GetFiledByInput("INSERT INTO CoreToolValue (State,[CoreID],[PropertyID],Value,ValueType,ParentID,ToolID) SELECT 1 AS State," + CoreID + " AS CoreID,PropertyID,Value,ValueType,IDENT_CURRENT('CoreToolValue') AS ParentID,'"
                                                        + ToolID + "' AS ToolID  FROM StoredToolValue WHERE ID = " + dr[0]["ID"].ToString() + ";SELECT IDENT_CURRENT('CoreToolValue') AS CurID", "CurID");

                MyManager.ExecSQL("INSERT INTO CoreToolValue (State,[CoreID],[PropertyID],Value,ValueType,ParentID) SELECT 1 AS State," + CoreID + " AS CoreID,PropertyID,Value,ValueType," + nID + " AS ParentID"
                                    + " FROM StoredToolValue WHERE ValueType =2 AND ParentID = " + dr[0]["ID"].ToString());


                dr = dt.Select("ValueType = 3");
                iToolCount = 1;
                for (j = 0; j < Rank.Length; j++)
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

                CoreID = MyManager.GetFiledByInput("INSERT INTO CoreTool(ModelType,ModelID,ToolID,ToolName,[ModifyTime],State,[RelatedTask],Rank) SELECT ModelType,ModelID,'"
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
            dt =  MyManager.GetDataSet("SELECT * from coretoolvalue AS A join CLassPropertys AS B  on A.propertyid = B.ID and B.pType = 0 AND a.coreid = " + CoreID ); //只含匹配项目
            Count = dt.Rows.Count;  
            //选取在状态为toolstate的，模型一致的， 匹配属性的工具
            dt1 = MyManager.GetDataSet("SELECT coreid ,count(A.id) as tNum from coretoolvalue AS A join CLassPropertys AS B  on A.propertyid = B.ID  where B.ptype = 0 AND coreid in (select id from coretool where state = " + ToolState + " AND modelid in (select modelid from coretool where id =" + CoreID + ")) Group By coreid");
            dt2 = MyManager.GetDataSet("SELECT * from coretoolvalue AS A join CLassPropertys AS B  on A.propertyid = B.ID  where B.ptype = 0 AND coreid in (select id from coretool where state = " + ToolState + " AND modelid in (select modelid from coretool where id =" + CoreID + "))");
        }
        else//全面比较
        {
            dt =  MyManager.GetDataSet("SELECT * from coretoolvalue where CoreID = " + CoreID);
            Count = dt.Rows.Count;  
            //选取在库的，模型一致的的工具
            dt1 = MyManager.GetDataSet("SELECT coreid ,count(id) as tNum from coretoolvalue   where coreid in (select id from coretool where state = " + ToolState + " AND modelid in (select modelid from coretoolwhere id =" + CoreID + ")) Group By coreid");
            dt2 = MyManager.GetDataSet("SELECT *  from coretoolvalue   where coreid in (select id from coretool where state = " + ToolState + " AND modelid in (select modelid from coretool where id =" + CoreID + "))");//1021日，将coretoolvalue 改为coretool
            
        }


        DataView dv;
        int bContinue = 1 ;
        DataRow[] dr2,dr1,dr = dt1.Select(" tNum = " + Count );//选取属性数量一致的工具包CoreID，放入dr
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
                dr2 = dt.Select(" ValueType = 2 OR ValueType =4 OR ValueType = 6");
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
        String BorrowerName = JO["borrowername"].ToString();
        String TaskID = JO["taskid"].ToString();
        String CurState = "";
        String AppID = JO["appid"].ToString();
        String CoreID = "",nID,CurToolName;
        
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
        MyManager.ExecSQL("UPDATE ToolApp Set [State] = 2,RefundAdminID=" + gCtx.Session["UserID"].ToString() + ",RefundAdminName='" + gCtx.Session["Name"].ToString() + "',RefunderName='" + JO["refundername"].ToString() + "',RefundTime='" + DateTime.Now.ToString() + "' Where ID =" + AppId);
        return "工具归还成功";
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
        DataTable dt = MyManager.GetDataSet("SELECT ID,rkID,StoredName,StoreTime FROM StoredTool WHERE RelatedTask  ='" + JO["taskid"].ToString() + "' Order by rkID ");
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
                CoreID = MyManager.GetFiledByInput("INSERT INTO CoreTool(rkID,ModelType,ModelID,ToolID,ToolName,[ModifyTime],State,[RelatedTask]) SELECT rkID,ModelType,ModelID,'"
                                                                                + ToolID + "' AS ToolID,StoredName AS ToolName,'" + DateTime.Now.ToString() + "' AS ModifyTime,1,'" + JO["taskid"].ToString() + "' AS RelatedTask FROM StoredTool WHERE ID = " + StoredID + ";SELECT IDENT_CURRENT('CoreTool') AS CurID", "CurID");

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

                CoreID = MyManager.GetFiledByInput("INSERT INTO CoreTool(rkID,ModelType,ModelID,ToolID,ToolName,[ModifyTime],State,[RelatedTask],Rank) SELECT rkID,ModelType,ModelID,'"
                                                        + ToolID + "' AS ToolID,StoredName AS ToolName,'" + DateTime.Now.ToString() + "' AS ModifyTime,1,'" + JO["taskid"].ToString() + "' AS RelatedTask,Rank FROM StoredTool WHERE ID = " + StoredID + ";SELECT IDENT_CURRENT('CoreTool') AS CurID", "CurID");

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
        
        return "任务提交成功，请记住任务编号:" +TaskID; 
    }

    public String CreateBagExcel(JObject JO)
    {
        String ExcelURL = "";
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
        for (i = 0,SQL=""; i <dr.Length; i++)
        {
            cells[4+i,0].PutValue(i+1);
            cells[4+i,1].PutValue(dr[i]["Name"].ToString().Trim());
            cells[4+i, 2].PutValue(dr[i]["num"].ToString().Trim());
            cells[4 + i,4].PutValue(num);
            cells[4 + i, 5].PutValue(num * Convert.ToInt32(dr[i]["num"].ToString().Trim()));
            sxdr/*模型工具属性*/ = dt.Select(" ValueType Not IN(1,3)  AND ParentID =" + dr[i]["ID"].ToString() +(comoption == 0 ? " AND ptype = 0" : ""));
            for (j=0,Note = "",SQL="";j<sxdr.Length;j++){
                Note += sxdr[j]["Name"].ToString().Trim() + ":" + sxdr[j]["Value"].ToString().Trim() + "\n\r";
                if (SQL == "")
                {
                    SQL = "SELECT distinct StoredID From  StoredToolValue Where  StoredID IN(SELECT ID FROM  StoredTool WHERE ModelID =" + dr[i]["PropertyID"].ToString() + " AND [State] = 0  )  AND PropertyID = " + sxdr[j]["PropertyID"].ToString() + " AND Value = '" + sxdr[j]["Value"].ToString() + "'";
                }else
                {
                    //SQL += " intersect (SELECT distinct StoredID From  StoredToolValue Where ValueType = " + sxdr[j]["ValueType"].ToString() + " AND PropertyID = " + sxdr[j]["PropertyID"].ToString() + " AND Value = '" + sxdr[j]["Value"].ToString() + "')";
                    SQL += "intersect (SELECT distinct StoredID From  StoredToolValue Where  PropertyID = " + sxdr[j]["PropertyID"].ToString() + " AND Value = '" + sxdr[j]["Value"].ToString() + "')";
                }          
            }
           
            sheet.Comments.Add(4+i, 1);
            sheet.Comments[4 + i, 1].Note = Note;
            //最后一步，取rkID 
            SQL = "SELECT Distinct ID,rkID From  StoredTool Where ID IN("+SQL+")";
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

    public String AddToCoreTool(JObject JO)
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
            if (rkIDs == "") { rkIDs = JA[i]["sn"].ToString(); }
            else {
                rkIDs += "," + JA[i]["sn"].ToString();
            }
            bContinue = true;
            int PID = Convert.ToInt32(JA[i]["pid"].ToString());//工具包模型内工具的id
            int SN = Convert.ToInt32(JA[i]["sn"].ToString());//库存工具ID

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
                dt1 /*从StoreToolvalue中选取工具比较*/ = MyManager.GetDataSet("SELECT * FROM StoredToolValue Where StoredID  IN(SELECT ID From  StoredTool Where rkID = "+SN+") ");

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
            dr = RetDT.Select(" rkID = " + JA[0]["sn"].ToString());

            StoredID = dr[0]["StoredID"].ToString();
            CoreID = MyManager.GetFiledByInput("INSERT INTO CoreTool(rkID,ModelType,ModelID,ToolID,ToolName,[ModifyTime],State,[RelatedTask]) SELECT rkID,ModelType,"+BagID+" AS ModelID,'"
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
                dr = RetDT.Select(" rkID = " + JA[j]["sn"].ToString());

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
   
   public void ProcessRequest (HttpContext context) 
   {

        int i = 0;
        String json = "",Cmd = "",retJSON = "";
        context.Response.ContentType = "text/plain";
        gCtx = context;
       try
        {
   
         StreamReader reader = new StreamReader(context.Request.InputStream);
            json = reader.ReadToEnd();
           /* if (json == "")
            {
                context.Response.Write(context.Session["UserID"].ToString());
                return;
            }*/
           // if (gCtx.Session["UserID"] == null) { context.Response.Write("{\"status\":\"failed\",\"msg\":\"请登陆!\"}"); return; }
            JObject JO = JObject.Parse(json);
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
               retJSON = "{\"status\":\"success\",\"data\":" + GetClassAndProperty(Convert.ToInt32(JO["classid"].ToString()), Convert.ToInt32(JO["type"].ToString()), JO["toolid"].ToString() == "" ? 0 : Convert.ToInt32(JO["toolid"].ToString())) + "}";
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
               retJSON = "{\"status\":\"success\",\"data\":" + ToolSearch(JO) + "}";
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
               retJSON = "{\"status\":\"success\",\"msg\":\"" + tijiao(JO) + "\"}"; 
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
           context.Response.Write(retJSON);
           
        }
        catch (Exception ee)
        {
            context.Response.Write("{\"status\":\"failed\",\"msg\":\""+ee.ToString()+ "\"}");
        }
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}