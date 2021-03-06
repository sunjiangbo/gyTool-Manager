﻿using System;
using System.Collections.Generic;
using System.Data.OleDb;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Configuration;
using System.Runtime.Serialization.Formatters.Binary;
using System.Runtime.Serialization;
using System.Net;
using System.IO;
using System.Text;

/// <summary>
///MyManager 的摘要说明
/// </summary>
public class MyManager
{

    public static Boolean InsertFingerTmp(String UserID,String FingerTmpStr,byte[] FingerTmpBin,byte[] FingerImg)
    {
        byte[] fb;
        Boolean bRet = false;
        SqlConnection myConn = new SqlConnection(System.Configuration.ConfigurationSettings.AppSettings["ConnStr"]);
        SqlCommand sCmd = new SqlCommand();
        sCmd.CommandText = "UPDATE UserList Set FingerTmpStr=@FingerTmpStr,FingerTmpBin=@FingerTmpBin,FingerImg=@FingerImg Where ID =@UserID";
        sCmd.Parameters.Add("@UserID",SqlDbType.Int);
        sCmd.Parameters.Add("@FingerTmpStr",SqlDbType.Text);
        sCmd.Parameters.Add("@FingerTmpBin",SqlDbType.Image);
        sCmd.Parameters.Add("@FingerImg",SqlDbType.Image);
        sCmd.Parameters["@UserID"].Value = UserID;
        sCmd.Parameters["@FingerTmpStr"].Value = FingerTmpStr;
        sCmd.Parameters["@FingerTmpBin"].Value = FingerTmpBin;
        sCmd.Parameters["@FingerImg"].Value = FingerImg;
        sCmd.Connection = myConn;
        myConn.Open();
        int iRet = (int)sCmd.ExecuteNonQuery();
        if (iRet == 1) 
        { bRet = true; }
        else 
        { bRet = false; }
        myConn.Close();
        return bRet;
    }

    public static string Post(string url, string postContent)
    {
        HttpWebRequest req = (HttpWebRequest)HttpWebRequest.Create(url);

        req.Method = "POST";

        if (!string.IsNullOrEmpty(postContent))
        {
            using (StreamWriter sw = new StreamWriter(req.GetRequestStream(), Encoding.UTF8))
            {
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
	public MyManager()
	{
	
        
	}
    static public DataTable GetDataSet(String SQLTxt)
    {
        DataTable dt = new DataTable();
        SqlConnection myConn = new SqlConnection(System.Configuration.ConfigurationSettings.AppSettings["ConnStr"]);
        myConn.Open();
        if (myConn.State == System.Data.ConnectionState.Open)
        {
            SqlDataAdapter da = new SqlDataAdapter(SQLTxt, myConn);
            da.Fill(dt);
        }
        
        myConn.Close();
        return dt;
    }
    static public int ExecSQL(String SQLTxt)
    {
        int iRet = 0;
        DataTable dt = new DataTable();
        SqlConnection myConn = new SqlConnection(System.Configuration.ConfigurationSettings.AppSettings["ConnStr"]);
        myConn.Open();
        if (myConn.State == System.Data.ConnectionState.Open)
        {
            SqlCommand sCmd = new SqlCommand(SQLTxt, myConn);
            iRet =  sCmd.ExecuteNonQuery();
        }
        myConn.Close();
        return iRet;
    }
    static public int SELCount(String SQLTxt,String Concern/*需要返回的字段*/)
    {
        int iRet = 0;
        DataTable dt = new DataTable();
        SqlConnection myConn = new SqlConnection(System.Configuration.ConfigurationSettings.AppSettings["ConnStr"]);
        myConn.Open();
        if (myConn.State == System.Data.ConnectionState.Open)
        {
            SqlCommand sCmd = new SqlCommand(SQLTxt, myConn);
            SqlDataReader dr = sCmd.ExecuteReader();
            if (dr.HasRows)
            {
                dr.Read();
                iRet = Convert.ToInt32(dr[Concern].ToString());
            }
            dr.Close();
        }
        myConn.Close();
        return iRet;
    }
    static public String GetFiledByInput(String SelSQL ,String Concern/*需要返回的字段*/)
    {
        String sRet = "";
        DataTable dt = new DataTable();
        SqlConnection myConn = new SqlConnection(System.Configuration.ConfigurationSettings.AppSettings["ConnStr"]);
        myConn.Open();
        if (myConn.State == System.Data.ConnectionState.Open)
        {
            SqlCommand sCmd = new SqlCommand(SelSQL, myConn);
            SqlDataReader dr = sCmd.ExecuteReader();
            if (dr.HasRows)
            {
                dr.Read();
                sRet = dr[Concern].ToString();
            }
            
            dr.Close();
        }
        myConn.Close();
        return sRet;
    }
    static public Boolean FuckSQLInject(string sSql)
    {
        int srcLen, decLen = 0;
        sSql = sSql.ToLower().Trim();
        srcLen = sSql.Length;
        if(sSql.Contains("'"))return false;
        if (sSql.Contains("--")) return false;
        if (sSql.Contains(";")) return false;
        if (sSql.Contains("exec")) return false;
        if (sSql.Contains("delete")) return false;
        if (sSql.Contains("select")) return false;
        if (sSql.Contains("update")) return false;
        if (sSql.Contains("insert")) return false;
        if (sSql.Contains("master")) return false;
        if (sSql.Contains("truncate")) return false;
        if (sSql.Contains("declare")) return false;
        if (sSql.Contains("create")) return false;
        if (sSql.Contains("drop")) return false;
        if (sSql.Contains(" or ")) return false;
        if (sSql.Contains(" alter ")) return false;
        return true;
      
    }
    
    static public int GetMaxID()
    {
        int MaxID = 0;
        SqlConnection myConn = new SqlConnection(System.Configuration.ConfigurationSettings.AppSettings["ConnStr"]);
        myConn.Open();
        if (myConn.State == System.Data.ConnectionState.Open)
        {
            SqlCommand sCmd = new SqlCommand("SELECT Max(MaxID) AS ID FROM SN", myConn);
            SqlDataReader dr = sCmd.ExecuteReader();
            dr.Read();
            MaxID = Convert.ToInt32(dr["ID"].ToString());
            dr.Close();
           
        }

        myConn.Close();
        
        return MaxID;
    }
    static public String GetToolQuerySQL(String ToolType, String AirPlaneID, String SubjectID, String ToolName, String ToolID, String ghStartTime, String ghEndTime, String cjStartTime, String cjEndTime)
    {
        String SubSQL= "",SubSQL1 = "";
        String SQL1 = "SELECT   A.*,B.AirPlane,C.SubjectName,D.TypeName as gjlx,E.StateName AS zkzt,F.TypeName AS shzt,G.ToolName AS ParentName FROM Tools AS A left   join ACType AS B on A.AirPlaneID = B.ID left join AirPlaneSubject AS C on A.SubjectID = C.ID  left join ToolType AS D on A.ToolType = D.TypeID left join ToolState AS E on  A.State = E.StateID  left join BadType AS F  on  A.IsBad = F.BadType left Join Tools AS G on A.ParentID = G.ID WHERE ( 1=1 ";
        String SQL2 = " ORDER By A.ParentID,A.ToolType";

        if (AirPlaneID != "0" && AirPlaneID != "")
        {
            SubSQL += " AND A.AirPlaneID = " + AirPlaneID;
        }

        if (SubjectID != "0" && SubjectID != "")
        {
            SubSQL += " AND A.SubjectID = " + SubjectID;
        }

        if (ToolName != "")
        {
            SubSQL += " AND A.ToolName LIKE '%" + ToolName + "%'";
        }

        if (ToolID != "")
        {
            SubSQL += " AND A.ToolID LIKE '%" + ToolID + "%'";
        }
        SubSQL1 = SubSQL.Replace("A.", "");
        if (ToolType != "")
        {
            if (ToolType == "0")
            {
                SubSQL += " AND A.ToolType = " + ToolType + ")";
            }

            if (ToolType == "1")
            {
                SubSQL += "AND A.ToolType  = 1)  OR (A.ToolType = 2 AND A.ParentID IN(SELECT ID FROM Tools WHERE ToolType = 1" + SubSQL1 + " )) ";

            }

            if (ToolType == "-1")
            {
                SubSQL += ")  OR (A.ToolType = 2 AND A.ParentID IN(SELECT ID FROM Tools WHERE ToolType = 1 " + SubSQL1 + " )) " +
                          "OR (A.ToolType = 1 AND A.ID IN(SELECT ParentID FROM Tools WHERE ToolType = 2 " + SubSQL1 + ")) " +
                          "OR (A.ToolType = 2 AND A.ParentID IN (SELECT ParentID FROM Tools WHERE ToolType = 2 " + SubSQL1 + ")) ";
            }

            if (ToolType == "2")
            {
                SubSQL += " AND A.ToolType = " + ToolType + ")";
            }
        }
        else
        {
            SubSQL += ")";
        }

       

      /*  if (StartTime != "")
        {
            if (EndTime != "")
            { 
               SubSQL += " " 
            }
        }
      */
        return SQL1 + SubSQL + SQL2;
    }
    static public String CreateTask(String TaskTypeID,String TaskName,String TaskCode,String CreateUserID,String CreateCorpID,String RecvCorpID,String TaskMemo)
    {
        /*
         *
         * 注意：本函数内不保证表内任务重复，请在传递任务之前，保证TaskCode不重复。 
         * 
         */
        String TaskID = "";
        int  iRet = 0; 
        
        
      iRet = ExecSQL("INSERT INTO Tasks([Type],[TaskCode],[Name],[State],[CreateUser],[CreateCorpID] ,[SendCorpID],[RecvCorpID],Memo,CreateTime) VALUES ("
            +TaskTypeID +",'"
            +TaskCode+"','"
            +TaskName+ "',0,"
            +CreateUserID+ ","
            +CreateCorpID + ","
            +CreateCorpID+ ","//任务刚创建时，任务创建部门和任务发送部分一致
            +RecvCorpID +",'"
            + TaskMemo + "','"
            +DateTime.Now.ToString() + "')");

        if (iRet < 1)
        {
            return "";
        }

        TaskID = GetFiledByInput("SELECT ID FROM Tasks Where TaskCode = '" + TaskCode + "'","ID");

        return TaskID;
    }

    static public int WriteTaskFlow(String TaskID,String SendUser,String SendCorp,String RecvCorp,String Content,String CurDateTime )
    {
        /*
         * 1.任务创建
         * 
         * 2.任务分配
         * 
         * 3.任务流转
         * 
         */
        int iRet = 0;


        iRet = ExecSQL("INSERT INTO TaskFlow(TaskID,SendUser,SendCorp,RecvCorp,Content,DateTime) VALUES ("
           + TaskID + ","
           + SendUser + ","
           + SendCorp + ","
           + RecvCorp + ",'"
           + Content + "','"
           + CurDateTime + "')");
        
        return iRet;
    }

    static public String GetDealPage(int  TaskType,String TaskID)
    {
        String PageUrl = "";

        switch (TaskType)
        {
            case 1:
                {
                    PageUrl = "ToolApp.aspx?TaskID=" + TaskID;
                    break;
                }
            default:
                {
                    break;
                }

                

        }

        return PageUrl;
    }

    static public String ToolApp(String TaskID, String ToolID,String  UserID,String sMemo/*用于在管理员操作时提供记录*/)
    {
        String sRet = "";
        sRet = GetFiledByInput("SELECT  count(ID) as iCount FROM ToolApp WHERE TaskID = " + TaskID + " AND ToolID = '" + ToolID + "'", "iCount");

        if (Convert.ToInt32(sRet) > 0)
        {
            return "申请已存在"; 
        }

        sRet = GetFiledByInput("SELECT  Count(ID) as iCount FROM Tools WHERE ToolType = 2  AND ToolID = '" + ToolID + "'", "iCount");

        if (Convert.ToInt32(sRet) > 0)
        {
            return "包内工具不允许单独申请借出!";
        }


        if (1 <= ExecSQL("INSERT INTO ToolApp ([UserID],[TaskID],[AirPlaneID],[SubjectID],[ToolType],[orginalID],[ToolID],[ToolName],[ParentID],[AddTime],[CreateTime],[sMemo],[Memo]) "+
                                       "SELECT UserID="+UserID+",[TaskID]="+TaskID+",[AirPlaneID],[SubjectID],[ToolType],[ID] AS orginalID,[ToolID],[ToolName],[ParentID],[AddTime]='"+DateTime.Now.ToString()+"',[CreateTime],[sMemo]='"+sMemo+"',[Memo] FROM Tools WHERE ToolID ='" + ToolID + "' OR ( ToolType = 2 AND ParentID=(SELECT ID FROM Tools WHERE ToolType =1 AND ToolID= '" + ToolID + "'))"))
        {
            return "申请成功";
        }

        return "申请工具失败,原因未知,可能是件号错误！";
                
    }

    static public int DeleteToolApp(String AppID)
    {
       return MyManager.ExecSQL("DELETE FROM ToolApp WHERE TaskID =(SELECT TaskID FROM ToolApp WHERE ID=" + AppID + ") AND ParentID=(SELECT ParentID FROM ToolApp WHERE ID=" + AppID + ")");
    }

    static public String GetNextID()/*获取下一个工具包前两位编号*/
    {
        String[] arr = { "A", "B", "C", "D", "E", "F", "G", "H", "J", "K", "L", "M", "N", "P", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" };
        String ID = MyManager.GetFiledByInput("Select Top 1 NextID FROM NextID", "NextID");
        int i, j, k, t;
        if (MyManager.SELCount("SELECT  count(ID) as Count FROM CoreTool WHERE ToolID like '" + ID + "%'", "Count") > 0)
        {

            if (ID[ID.Length - 1].ToString() == arr[arr.Length - 1])//最后一位字母为字符表中最后一个字母，需要进位
            {

                //开始层层进位
                for (i = ID.Length - 1; i >= 0; i--)
                {
                    if (ID[i].ToString() == arr[arr.Length - 1])
                    {
                        ID = (i == 0 ? "" : ID.Substring(0, i)) + arr[0] + (i == ID.Length - 1 ? "" : ID.Substring(i + 1, ID.Length - 1 - i));
                        //ID = ID.Substring(0, i) + arr[0];//某位为最后一个字母则证明前位需要进位，而本位变为第一个字母
                    }
                    else //碰到不为最后一个字母的，则该位变为下一个字母，然后退出循环即可。
                    {
                        j = 0;
                        while (ID[i].ToString() != arr[j]) j++;

                        ID = (i == 0 ? "" : ID.Substring(0, i)) + arr[j + 1] + (i == ID.Length - 1 ? "" : ID.Substring(i + 1, ID.Length - 1 - i));

                        break;
                    }
                }
                if (i < 0)//需要加位
                {
                    ID = arr[0] + ID;
                }
            }
            else
            {


                j = 0;
                while (ID[ID.Length - 1].ToString() != arr[j]) j++;

                ID = ID.Substring(0, ID.Length - 1) + arr[j + 1];
            }


        }

        MyManager.ExecSQL("Update NextID Set NextID = '" + ID + "' WHERE ID =1");

        return ID;
    }

}
