using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Aspose;
using Aspose.Cells;
public partial class test : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
       
    }

     public String GetNextID()/*获取下一个工具包前两位编号*/
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

                        ID = (i == 0 ? "" : ID.Substring(0, i)) + arr[j+1] + (i == ID.Length - 1 ? "" : ID.Substring(i + 1, ID.Length - 1 - i));

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
                
                ID = ID.Substring(0, ID.Length - 1) + arr[j+1];
            }


        }

        MyManager.ExecSQL("Update NextID Set NextID = '" + ID + "' WHERE ID =1");

        return ID;
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        int i=0;
       while(i++<50000)Response.Write( GetNextID() +"</br>");
    }
}