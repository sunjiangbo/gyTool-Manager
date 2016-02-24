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



public partial class _Default : System.Web.UI.Page
{
    string sConn = System.Configuration.ConfigurationSettings.AppSettings["DB.CONNECTIONSTRING"];

    public byte[] DatasetToBinary(System.Data.DataSet dsResult, ref string err)
    {
        //ClearCommand();
        //DataSet dsResult = new DataSet();

        byte[] bArrayResult = null;
       
        try
        {
            //dsResult = SqlHelper.ExecuteDataset(m_currentConnectionString, CommandType.Text, m_commandStringBuilder.ToString());
            // 上面都是取数据的,无需关心.二进制压缩数据集是下面一小段
            dsResult.RemotingFormat = SerializationFormat.Binary;
            MemoryStream ms = new MemoryStream();
            IFormatter bf = new BinaryFormatter();
            bf.Serialize(ms, dsResult);
            bArrayResult = ms.ToArray();
            ms.Close();
        }
        catch (Exception ee)
        {
            err = ee.ToString();
        }
        return bArrayResult;
    }

    /**/
    /// <summary>
    /// 此方法实现从二进制流还原Dataset数据
    /// </summary>
    /// <returns></returns>
    public DataSet BinaryToDataset(byte[] bUserData)
    {
        if (bUserData == null)
        {
            //MessageBox.Show("二进制数据流为空");
            //err = "";
            return null;
        }
        // 反序列化的过程
        MemoryStream ms = new MemoryStream(bUserData);
        IFormatter bf = new BinaryFormatter();
        object obj = bf.Deserialize(ms);
        DataSet dsResult = (DataSet)obj;
        ms.Close();
        return dsResult;
    }
    public string Encode(string str)
    {
        byte[] encbuff = System.Text.Encoding.UTF8.GetBytes(str);
        return Convert.ToBase64String(encbuff);
    }

    public string Decode(string str)
    {
        byte[] decbuff = Convert.FromBase64String(str);
        return System.Text.Encoding.UTF8.GetString(decbuff);
    }
   /* public void GetData(String SQLText)
    {
        SqlConnection sqlCon;
        sqlCon = new SqlConnection(sConn);
        sqlCon.Open();
        SqlDataAdapter da = new SqlDataAdapter(SQLText, sqlCon);
        DataSet ds = new DataSet();
        da.Fill(ds);
        GridView1.DataSource = ds;
        GridView1.DataBind();
    }*/
    public byte[] GetDataBySQL(String SQLText)
    {
        SqlConnection sqlCon;
        sqlCon = new SqlConnection(sConn);
        try
        {
            sqlCon.Open();
            SqlDataAdapter da = new SqlDataAdapter(SQLText, sqlCon);
            //数据集对象。
            DataSet ds = new DataSet();
            //填充到数据集。
            da.Fill(ds);
            MemoryStream serializationStream = new MemoryStream();
            new BinaryFormatter().Serialize(serializationStream, ds);
            return serializationStream.ToArray();

        }
        catch (Exception ex)
        {
            // You might want to pass these errors
            // back out to the caller.
            sqlCon.Close();

            return Encoding.UTF8.GetBytes( ex.Message);
        }
      

       // Response.Write(
    }
    public String ExecSQLGetMyFormat(String SQLText)
    {
        SqlConnection sqlCon;
        sqlCon = new SqlConnection(sConn);
       try
        {
        sqlCon.Open();
        SqlDataAdapter da = new SqlDataAdapter(SQLText, sqlCon);
        //数据集对象。
        DataSet ds = new DataSet();
        //填充到数据集。
        da.Fill(ds);
        DataTable dt = ds.Tables[0];
        //填充之后你就可以使用数据集里面的表了。
        int i, j;
        StringWriter sw = new StringWriter();
        JsonWriter jWrite = new JsonTextWriter(sw);
        jWrite.WriteStartObject();

        jWrite.WritePropertyName("DataRowsCount");
        jWrite.WriteValue(dt.Rows.Count);

        jWrite.WritePropertyName("DataFieldsCount");
        jWrite.WriteValue(dt.Columns.Count);

        jWrite.WritePropertyName("DataFieldsNames");
        jWrite.WriteStartArray();
        for (i = 0; i < dt.Columns.Count; i++)
        {
            jWrite.WriteValue(dt.Columns[i].ColumnName.ToString());
        }
        jWrite.WriteEndArray();

        for (j = 0; j < dt.Columns.Count; j++)
        {
            jWrite.WritePropertyName(dt.Columns[j].ColumnName.ToString());
            jWrite.WriteStartArray();
            for (i = 0; i < dt.Rows.Count; i++)
            {
                jWrite.WriteValue(dt.Rows[i][j].ToString());
            }
            jWrite.WriteEndArray();
        }

        jWrite.WriteEndObject();//for (i=0;i<)
        sqlCon.Close();
        return sw.GetStringBuilder().ToString();
    }
     catch (Exception ex)
       {
            // You might want to pass these errors
            // back out to the caller.
           sqlCon.Close();
            return ex.Message;
       }
   
        
    }

    public String ExecNoQuerySQL(String SQLText)
    {
        int iCount = 0;
        String sRet;
        SqlConnection sqlCon;
        sqlCon = new SqlConnection(sConn);
        SqlCommand sCmd = new SqlCommand();
        try
        {
            sqlCon.Open();
            sCmd.Connection = sqlCon;
            sCmd.CommandText = SQLText;
            iCount = sCmd.ExecuteNonQuery();
            sRet = "RowCount= " + iCount;
        }
        catch (Exception ex)
        {
            // You might want to pass these errors
            // back out to the caller.
            sRet = "错误信息:" + ex.Message;
        }
        sqlCon.Close();
        return sRet;
    }

    protected void Page_Load(object sender, EventArgs e)
    {

       //String str =  
            
            StringWriter sw = new StringWriter();
            JsonWriter jWrite = new JsonTextWriter(sw);
            jWrite.WriteStartObject();

            for (int i = 0; i < Request.Form.Count; i++)
            {
                jWrite.WritePropertyName(Request.Form.Keys[i].ToString());
                jWrite.WriteValue("RESLUT:"+ Request.Form[i].ToString() );
                
            }
            jWrite.WriteEndObject();
            Response.Write( sw.ToString());
      

    }
   
 
}
