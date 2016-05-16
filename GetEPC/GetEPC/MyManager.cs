using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
namespace GetEPC
{
    class MyManager
    {
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
