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
                iRet = sCmd.ExecuteNonQuery();
            }
            myConn.Close();
            return iRet;
        }
    }
}
