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
using System.Linq;
using System.Web.Security;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Text;


public partial class TakeComments : System.Web.UI.Page
{
    static String TaskID = "";
    static String s1 = "&lt;!DOCTYPE HTML&gt; &lt;table width=&quot;770&quot; border=&quot;0&quot; align=&quot;center&quot; cellpadding=&quot;0&quot; cellspacing=&quot;1&quot; bgcolor=&quot;#cdd7e8&quot;&gt;  &lt;tr&gt;    &lt;td height=&quot;300&quot; valign=&quot;top&quot; bgcolor=&quot;#FFFFFF&quot;&gt;&lt;table width=&quot;100%&quot; border=&quot;0&quot; align=&quot;center&quot; cellpadding=&quot;0&quot; cellspacing=&quot;0&quot;&gt; &lt;tr&gt;        &lt;td background=&quot;img/header_menu2.gif&quot; align=&quot;center&quot; height=&quot;30px&quot; &gt;                                        &lt;b&gt;&lt;font color=&quot;#29458c&quot; size=&quot;3&quot;&gt;";
    static String s2 = "&lt;/font&gt;&lt;/b&gt;&lt;/td&gt;      &lt;/tr&gt;    &lt;/table&gt;      &lt;table width=&quot;98%&quot; border=&quot;0&quot; align=&quot;center&quot; cellpadding=&quot;0&quot; cellspacing=&quot;2&quot;&gt;        &lt;tr&gt;          &lt;td height=&quot;1&quot; bgcolor=&quot;#c6cfd2&quot;&gt;&lt;/td&gt;        &lt;/tr&gt;        &lt;tr&gt;          &lt;td height=&quot;30&quot; bgcolor=&quot;#f2f6f7&quot;&gt;                               &lt;div align=&quot;center&quot;&gt;                        发布人：";

    //static String s1 = "&lt;table width=&quot;770&quot; border=&quot;0&quot; align=&quot;center&quot; cellpadding=&quot;0&quot; cellspacing=&quot;1&quot; bgcolor=&quot;#cdd7e8&quot;&gt;  &lt;tr&gt;    &lt;td height=&quot;300&quot; valign=&quot;top&quot; bgcolor=&quot;#FFFFFF&quot;&gt;&lt;table width=&quot;100%&quot; border=&quot;0&quot; align=&quot;center&quot; cellpadding=&quot;10&quot; cellspacing=&quot;0&quot;&gt;      &lt;tr&gt;        &lt;td height=&quot;40&quot;  background=&quot;img/header_menu2.gif&quot;&gt;                &lt;div align=&quot;center&quot;&gt;                        &lt;b&gt;&lt;font color=&quot;#29458c&quot; size=&quot;3&quot;&gt;                           ";
    //static String s2 = "                        &lt;/font&gt;&lt;/b&gt;                    &lt;/div&gt;                &lt;/td&gt;      &lt;/tr&gt;    &lt;/table&gt;      &lt;table width=&quot;98%&quot; border=&quot;0&quot; align=&quot;center&quot; cellpadding=&quot;0&quot; cellspacing=&quot;0&quot;&gt;        &lt;tr&gt;          &lt;td height=&quot;1&quot; bgcolor=&quot;#c6cfd2&quot;&gt;&lt;/td&gt;        &lt;/tr&gt;        &lt;tr&gt;          &lt;td height=&quot;30&quot; bgcolor=&quot;#f2f6f7&quot;&gt;                               &lt;div align=&quot;center&quot;&gt;                        发布人：";
    static String s3 = "&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp; 发布时间：";
    static String s4 = "&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;/div&gt;                              &lt;/td&gt;        &lt;/tr&gt;        &lt;tr&gt;          &lt;td height=&quot;1&quot; bgcolor=&quot;#c6cfd2&quot;&gt;&lt;/td&gt;        &lt;/tr&gt;      &lt;/table&gt;      &lt;table width=&quot;98%&quot; border=&quot;0&quot; align=&quot;center&quot; cellpadding=&quot;0&quot; cellspacing=&quot;0&quot;&gt;        &lt;tr&gt;          &lt;td height=&quot;200&quot; valign=&quot;top&quot; style=&quot;line-height: 150%&quot;&gt; ";
    static String s5 = "&lt;/td&gt;        &lt;/tr&gt;      &lt;/table&gt;      &lt;table width=&quot;98%&quot; border=&quot;0&quot; align=&quot;center&quot; cellpadding=&quot;0&quot; cellspacing=&quot;0&quot;&gt;        &lt;tr&gt;          &lt;td height=&quot;1&quot; bgcolor=&quot;#c6cfd2&quot;&gt;&lt;/td&gt;        &lt;/tr&gt;        &lt;tr&gt;          &lt;td height=&quot;30&quot; bgcolor=&quot;#fafdfe&quot;&gt;";
    static String s6 = "&lt;/div&gt;&lt;/td&gt;        &lt;/tr&gt;        &lt;tr&gt;          &lt;td height=&quot;1&quot; bgcolor=&quot;#c6cfd2&quot;&gt;&lt;/td&gt;        &lt;/tr&gt;      &lt;/table&gt;&lt;/td&gt;  &lt;/tr&gt;&lt;/table&gt;";

    protected String GetCommentShowStr(String TaskID)
    {

        int i = 0;
        StringBuilder sb = new StringBuilder("");

        DataTable dt = MyManager.GetDataSet("SELECT A.*,B.Name,C.CorpName FROM TaskComments AS A left join UserList AS B on A.UserID= B.ID left join Corps AS C on C.CorpID = B.CorpID WHERE TaskID =" + TaskID + " ORDER BY DateTime ASC");

        if (dt.Rows.Count == 0) return "";

        DataRow[] dr = dt.Select(" Type = 1 ");

        for (i = 0; i < dr.Length; i++)
        {
            sb.Append(s1).Append(dr[i]["Title"].ToString()).Append(s2).Append(dr[i]["Name"].ToString()).Append(s3).Append(dr[i]["DateTime"].ToString()).Append(s4).Append(dr[i]["Content"].ToString()).Append(s5).Append(s6);
        }

        return sb.ToString();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["TaskID"] == null) return;

        TaskID = Request["TaskID"].ToString();

        //开始显示评论


        //  Response.Write(Server.HtmlDecode(" &lt;html xmlns=&quothttp://www.w3.org/1999/xhtml&quot &gt;&lt;body&gt;" + sx + "&lt;/body&gt;&lt;/html&gt;"));
        //Response.Write("<div>dsafdafdaf</div>");

        Response.Write(Server.HtmlDecode( GetCommentShowStr(TaskID)));

        //ln1.Text =Server.HtmlDecode( GetCommentShowStr(TaskID));
    }
    protected void Button3_Click(object sender, EventArgs e)
    {

        Page.ClientScript.RegisterStartupScript(Page.GetType(), "message", "<script language='JavaScript'>showDialogByUrl('MyEditor.aspx?TaskID="+TaskID+"','TaskComments.aspx?TaskID="+TaskID+"');</script>");

    }
}
