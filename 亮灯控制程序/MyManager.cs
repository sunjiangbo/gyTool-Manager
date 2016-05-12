using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
namespace WindowsFormsApplication1
{
    class MyManager
    {
        static  public int AddInfoToDB( String Type, String Txt)
        {
            return MyManager.ExecSQL("INSERT INTO MachMsg(Time,Type,txt) VALUES('" + DateTime.Now.ToString() + "','" + Type + "','" + Txt + "')");
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

        static public SqlDataAdapter GetDataADP(String SQLTxt)
        {
            DataTable dt = new DataTable();
            SqlConnection myConn = new SqlConnection(System.Configuration.ConfigurationSettings.AppSettings["ConnStr"]);
            myConn.Open();
            if (myConn.State == System.Data.ConnectionState.Open)
            {
                myConn.Close();
                SqlDataAdapter da = new SqlDataAdapter(SQLTxt, myConn);
                return da;
            }
           
            return null;
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
                iRet = sCmd.ExecuteNonQuery();
            }
            myConn.Close();
            return iRet;
        }

        public static String GenerateEPC(String ToolNum)
        {
            //现在默认只会传进来 类AA或AAA
            String EPC = "";

            if (ToolNum.Length < 2)
            {
                return "";
            }

            for (int i = 0; i < ToolNum.Length; i++)
            {
                EPC += Convert.ToInt16(ToolNum[i]);
            }

            if (EPC.Length < 6)
            {
                EPC = "FFFFFFFFFFFFFF00" + EPC + "000F";
            }
            else
            {
                EPC = "FFFFFFFFFFFFFF" + EPC + "000F";
            }

            return EPC;
        }

        public static String DecodeEPC(String EPC)//从EPC得到工具号
        {
            //现在默认只会得到 类AA或AAA
            String ToolNum;

            if (EPC[14] == '0' && EPC[15] == '0')
            {
                ToolNum = ((char)Convert.ToInt16(EPC.Substring(16, 2))).ToString() + ((char)Convert.ToInt16(EPC.Substring(18, 2))).ToString();
            }
            else
            {
                ToolNum = ((char)Convert.ToInt16(EPC.Substring(14, 2))).ToString() + ((char)Convert.ToInt16(EPC.Substring(16, 2))).ToString() + ((char)Convert.ToInt16(EPC.Substring(18, 2))).ToString();
            }


            return ToolNum;
        }
    }
}
