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
public partial class TaskManage : System.Web.UI.Page
{
    struct GropInfo
    {
        public String Name;
        public String CorpID;
    };
    static String CorpParentID = "", UserType = "", UserID = "", RecvUserName="";
    static ArrayList GIList = null;


    protected String GetMyViewState(String UserType)//根据用户权限获取应该显示的处理状态
    {
        String SubSQL = "";

        if (UserType == "0")//科队级领导
        {
            SubSQL = " (A.State IN (1,4,5,6)) AND ";
        }
        else if (UserType == "1")//小组长
        {
            SubSQL = " (A.State IN (1,4,5,6,7,8)) AND ";
        }
        else if (UserType == "2")
        {
            SubSQL = " (A.State IN (1,5,6,7)) AND ";
        }

        return SubSQL;
    }

    protected ArrayList GetGropInfoList(String CorpID) //获取本科队小组信息
    {
        ArrayList ls = new ArrayList();

        DataTable dt = MyManager.GetDataSet("SELECT * FROM Corps WHERE CorpType = 2 And ParentID=" + CorpID + " ORDER BY CorpID ASC");

        for (int i = 0; i < dt.Rows.Count; i++)
        {
            GropInfo GI = new GropInfo();
            GI.CorpID = dt.Rows[i]["CorpID"].ToString();
            GI.Name = dt.Rows[i]["CorpName"].ToString();
            ls.Add(GI);
        }

        return ls;
    }
    protected void GV1Bind()
    {
        GridView1.DataSource = MyManager.GetDataSet("select F.Name as TaskStatus ,A.TaskID,A.State,A.Memo,A.Content,A.DateTime,B.TaskCode,B.Name AS TaskName,C.CorpName as SendCropName ,E.TypeName FROM [TaskProcess] as A  left join Tasks as B On A.TaskID = B.ID left join Corps AS  C on A.SendCorpID = C.CorpID left join TaskTypes AS E on B.Type = E.TypeID left join TaskProcessState AS F On A.State = F.State  WHERE " + GetMyViewState(Session["UserType"].ToString()) + " A.RecvUser = " + Session["UserID"].ToString() + " ORDER BY A.DateTime DESC");
        GridView1.DataBind();
    }

    protected void GV2Bind()
    {
        GridView2.DataSource = MyManager.GetDataSet("select F.Name as TaskStatus ,A.TaskID,A.State,A.Memo,A.Content,A.DateTime,B.TaskCode,B.Name AS TaskName,C.CorpName as SendCropName ,E.TypeName FROM [TaskProcess] as A  left join Tasks as B On A.TaskID = B.ID left join Corps AS  C on A.SendCorpID = C.CorpID left join TaskTypes AS E on B.Type = E.TypeID left join TaskProcessState AS F On A.State = F.State  WHERE A.State = 2 AND  A.RecvUser = " + Session["UserID"].ToString() + " ORDER BY A.DateTime DESC");
        GridView2.DataBind();
    }
    protected void Page_Load(object sender, EventArgs e)
    {
      
        if (Session["UserType"].ToString() == "0")
        {
            GIList = GetGropInfoList(Session["CorpParentID"].ToString());
        }

        CorpParentID = Session["CorpParentID"].ToString();
        UserType = Session["UserType"].ToString();
        UserID = Session["UserID"].ToString();


        if (Request["reFrashGV1"] != null)
        {
            GV1Bind();
            Hidden1.Value = "1";
        }

        if (Request["reFrashGV2"] != null)
        {
            GV2Bind();
            Hidden1.Value = "2";
        }

        if (IsPostBack)
        {
            return;
        }


        GV1Bind();
        GV2Bind();

    }
    protected void GridView2_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void GridView3_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        int i = 0;
        GropInfo GI;
        if (e.Row.RowType != DataControlRowType.Header)
        {

            e.Row.Cells[2].Text = (e.Row.RowIndex + 1).ToString();
            DropDownList dList = (DropDownList)e.Row.FindControl("DropDownList1");
            Button btn = (Button)e.Row.FindControl("Button1");//任务分配按钮
            LinkButton lkBtn = (LinkButton)e.Row.FindControl("LinkButton1");

            if (lkBtn != null)
            {
                lkBtn.CommandArgument = e.Row.Cells[0].Text;
                lkBtn.Text = e.Row.Cells[5].Text;
            }

            if (btn != null)
            {
                btn.CommandArgument = e.Row.Cells[0].Text + "|" + e.Row.RowIndex.ToString() + "|" + e.Row.Cells[1].Text;
            }
            if (dList != null)
            {
                dList.Visible = false;
            }

            if (Session["UserType"].ToString() == "0")//0代表是领导 1组长 2组员
            {
                if (e.Row.Cells[1].Text == "1" || e.Row.Cells[1].Text == "5" || e.Row.Cells[1].Text == "6")
                {
                    if (btn != null) btn.Text = "任务分配";
                    if (dList != null && GIList != null)
                    {
                        dList.Visible = true;
                        dList.Items.Add(new ListItem("", "0"));
                        for (i = 0; i < GIList.Count; i++)
                        {
                            GI = (GropInfo)GIList[i];
                            dList.Items.Add(new ListItem(GI.Name, GI.CorpID));
                        }
                    }
                }
                else if (e.Row.Cells[1].Text == "4")
                {
                    if (btn != null) btn.Text = "已获知";
                }
            }

            if (Session["UserType"].ToString() == "1")
            {
                if (e.Row.Cells[1].Text == "1" || e.Row.Cells[1].Text == "7")
                {
                    if (btn != null) btn.Text = "领取";
                }
                else
                {
                    if (btn != null) btn.Text = "已获知";
                }


            }


            if (Session["UserType"].ToString() == "2")
            {
                if (e.Row.Cells[1].Text == "1" || e.Row.Cells[1].Text == "7")
                {
                    if (btn != null) btn.Text = "领取";
                }
                else
                {
                    if (btn != null) btn.Text = "已获知";
                }


            }
        }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        int i = 0;
        Button Btn = (Button)sender;
        String txt = Btn.Text;
        String TaskID = "";
        String UserType = Session["UserType"].ToString();
        String RealTaskProcessState = "", RowIndex = "", GVTaskProcessState = "";
        String[] Arr = Btn.CommandArgument.Split('|');
        DataTable dt;
        String Msg = "", Title = "";
        
        TaskID = Arr[0];
        RowIndex = Arr[1];
        GVTaskProcessState = Arr[2];

        RealTaskProcessState = MyManager.GetFiledByInput("SELECT State FROM TaskProcess WHERE TaskID = " + TaskID + " AND RecvUser=" + Session["UserID"].ToString(), "State");


        if (RealTaskProcessState != GVTaskProcessState)
        {
            Page.ClientScript.RegisterStartupScript(Page.GetType(), "message", "<script language='JavaScript'>showDlg('任务状态有更新，请重新查看!');</script>");
            GV1Bind();
            return;
        }

        if (UserType == "0")
        {
            if (RealTaskProcessState == "1" || RealTaskProcessState == "5" || RealTaskProcessState == "6")//科长 State = 1 开始分配任务。
            {
                Title = "任务分配";

                //任务分配后，科长该任务状态变为处理中2
                MyManager.ExecSQL("UPDATE TaskProcess Set Content='任务已分配',DateTime = '" + DateTime.Now.ToString() + "',State = 2 WHERE TaskID =" + TaskID + " AND RecvUser = " + Session["UserID"].ToString());

                DropDownList dList = (DropDownList)GridView1.Rows[Convert.ToInt32(RowIndex)].FindControl("DropDownList1");

                if (dList.Text == "")
                {
                    Page.ClientScript.RegisterStartupScript(Page.GetType(), "message", "<script language='JavaScript'>showDlg('没选择分配小组!');</script>");
                    return;
                }

                //更改任务发送和接收部门 Tasks RecvCorpID 和 SendCorpID 

                MyManager.ExecSQL("UPDATE Tasks Set SendCorpID = "+Session["CorpID"].ToString()+",RecvCorpID=" + dList.SelectedItem.Value + " WHERE ID = " + TaskID);

                dt = MyManager.GetDataSet("SELECT A.*,B.CorpID,C.CorpName,B.Name,B.UserType,C.CorpType FROM TaskProcess AS A left join UserList  AS B on A.RecvUser = B.ID left join Corps AS C On B.CorpID = C.CorpID  WHERE TaskID = " + TaskID);
                DataRow[] dr;

                dr = dt.Select(" CorpID = " + dList.SelectedItem.Value);//给制定小组长分配任务

                if (dr.Length > 0)//TaskProcess中存在小组长信息说明任务从部门外转来
                {
                    Msg = "分配至小组:" + dr[0]["CorpName"];
                    for (i = 0; i < dr.Length; i++)
                    {
                        MyManager.ExecSQL("UPDATE TaskProcess Set Content='任务被分配至本组',DateTime = '" + DateTime.Now.ToString() + "',State = 7 WHERE ID=" + dr[i]["ID"].ToString());
                    }

                    //告知其他小组长任务已分配。
                    dr = dt.Select(" UserType = 1 AND  CorpID <> " + dList.SelectedItem.Value);

                    Msg += " 告知:";

                    for (i = 0; i < dr.Length; i++)
                    {
                        Msg += " " + dr[i]["Name"].ToString();
                        MyManager.ExecSQL("UPDATE TaskProcess Set Content='领导分配任务至他组',DateTime = '" + DateTime.Now.ToString() + "',State = 8 WHERE ID=" + dr[i]["ID"].ToString());
                    }

                    //给小组组员分配任务
                    dt = MyManager.GetDataSet("SELECT * FROM Userlist WHERE UserType = 2 AND CorpID = " + dList.SelectedItem.Value);

                    

                    for (i = 0; i < dt.Rows.Count; i++)
                    {
                        //每次插入TaskProcess 之前确保之前没有记录，保证TaskProces中，对于每个任务每人只有一条记录
                        MyManager.ExecSQL("DELETE FROM TaskProcess Where TaskID = " + TaskID + " AND RecvUser = " + dt.Rows[i]["ID"].ToString());
                        
                        MyManager.ExecSQL("INSERT INTO TaskProcess(TaskID,SendUser,SendCorpID,RecvCorpID,RecvUser,State,Content,DateTime) VALUES ("
                                         + TaskID + ","
                                         + Session["UserID"].ToString() + ","
                                         + Session["CorpID"].ToString() + ","
                                         + dList.SelectedItem.Value + ","
                                         + dt.Rows[i]["ID"].ToString() + ",7,'领导分配任务到本组','" + DateTime.Now.ToString() + "')");
                    }



                    MyManager.WriteTaskFlow(TaskID, Session["UserID"].ToString(), Session["CorpID"].ToString(), dList.SelectedItem.Value, "科队内流转", DateTime.Now.ToString());
                }
                else
                {
                    dt = MyManager.GetDataSet("SELECT * FROM Userlist WHERE  CorpID = " + dList.SelectedItem.Value);

                    for (i = 0; i < dt.Rows.Count; i++)
                    {
                        //每次插入TaskProcess 之前确保之前没有记录，保证TaskProces中，对于每个任务每人只有一条记录

                        MyManager.ExecSQL("DELETE FROM TaskProcess Where TaskID = " + TaskID + " AND RecvUser = " + dt.Rows[i]["ID"].ToString());

                        MyManager.ExecSQL("INSERT INTO TaskProcess(TaskID,SendUser,SendCorpID,RecvCorpID,RecvUser,State,Content,DateTime) VALUES ("
                                             + TaskID + ","
                                             + Session["UserID"].ToString() + ","
                                             + Session["CorpID"].ToString() + ","
                                             + dList.SelectedItem.Value + ","
                                             + dt.Rows[i]["ID"].ToString() + ",7,'领导分配任务到本组','" + DateTime.Now.ToString() + "')");
                    }
                }
            }
            else if (RealTaskProcessState == "4")
            {
                Title = "获知任务分配";
                MyManager.ExecSQL("UPDATE TaskProcess Set Content='任务被领取已获知',State = 2 WHERE RecvUser = " + Session["UserID"].ToString());
                Msg = Session["Name"].ToString() + " 已获知任务被领取，开始任务监督。";
            }

            MyManager.ExecSQL("INSERT INTO TaskLog (TaskID,CreateUserID,CreateUserName,Title,Content,DateTime) VAlues('"
                             + TaskID + "','"
                             + Session["UserID"].ToString() + "','"
                             + Session["Name"].ToString() + "','"
                             + Title + "','"
                             + Msg + "','"
                             + DateTime.Now.ToString() + "')");

        }

        if (UserType == "1")
        {
            if (RealTaskProcessState == "1")//组长 State = 1 开始领取任务。
            {
                Title = "组长领取任务";
                //更改任务发送和接收部门 Tasks RecvCorpID 和 SendCorpID 
                MyManager.ExecSQL("UPDATE Tasks Set SendCorpID = " + Session["CorpParentID"].ToString() + ",RecvCorpID=" + Session["CorpID"].ToString() + " WHERE ID = " + TaskID);

                //组长该任务状态变为处理中2
                MyManager.ExecSQL("UPDATE TaskProcess Set Content='任务领取',DateTime = '" + DateTime.Now.ToString() + "',State = 2 WHERE TaskID =" + TaskID + " AND RecvUser = " + Session["UserID"].ToString());

                ///给小组成员分配任务
                dt = MyManager.GetDataSet("select A.CorpName,A.Corptype,A.CorpID,B.ID AS UserID,B.UserType,B.Name from Corps AS A left join UserList AS B On A.CorpID = B.CorpID WHERE A.ParentID =" + Session["CorpParentID"].ToString());
                DataRow[] dr;
                dr = dt.Select(" UserType=2 AND CorpID = " + Session["CorpID"]);
                Msg = "接收人员:";
                for (i = 0; i < dr.Length; i++)
                {
                    Msg += " " + dr[i]["Name"].ToString();
                    //每次插入TaskProcess 之前确保之前没有记录，保证TaskProces中，对于每个任务每人只有一条记录
                    MyManager.ExecSQL("DELETE FROM TaskProcess Where TaskID = " + TaskID + " AND RecvUser = " + dr[i]["UserID"].ToString());

                    MyManager.ExecSQL("INSERT INTO TaskProcess(TaskID,SendUser,SendCorpID,RecvCorpID,RecvUser,State,Content,DateTime) VALUES ("
                          + TaskID + ","
                          + Session["UserID"].ToString() + ","
                          + Session["CorpID"].ToString() + ","
                          + Session["CorpID"].ToString() + ","
                          + dr[i]["UserID"].ToString() + ",1,'组长分配','" + DateTime.Now.ToString() + "')");
                }
                //写log
                MyManager.ExecSQL("INSERT INTO TaskLog (TaskID,CreateUserID,CreateUserName,Title,Content,DateTime) VAlues('"
                            + TaskID + "','"
                            + Session["UserID"].ToString() + "','"
                            + Session["Name"].ToString() + "','"
                            + Title + "','"
                            + Msg + "','"
                            + DateTime.Now.ToString() + "')");

                //通知科长和其他小组组长，任务已被我组认领

                dr = dt.Select(" UserType<> 2 AND UserID<>" + Session["UserID"].ToString());
                Title = "通知任务被认领";
                Msg = "通知";
                for (i = 0; i < dr.Length; i++)
                {
                    Msg += " " + dr[i]["Name"].ToString();
                    MyManager.ExecSQL("UPDATE TaskProcess Set Content = '任务被" + Session["CorpName"].ToString() + "领取',DateTime = '" + DateTime.Now.ToString() + "',State = 4 WHERE TaskID = " + TaskID + " AND RecvUser = " + dr[i]["UserID"].ToString());
                }

                MyManager.ExecSQL("INSERT INTO TaskLog (TaskID,CreateUserID,CreateUserName,Title,Content,DateTime) VAlues("
                            + TaskID + ","
                            + Session["UserID"].ToString() + ",'"
                            + Session["Name"].ToString() + "','"
                            + Msg + "','"
                            + "任务被" + Session["CorpName"].ToString() + "认领" + "','"
                            + DateTime.Now.ToString() + "')");
                MyManager.WriteTaskFlow(TaskID, Session["UserID"].ToString(), Session["CorpParentID"].ToString(), Session["CorpID"].ToString(), "科队内流转", DateTime.Now.ToString());

            }
            else if (RealTaskProcessState == "7")
            {
                MyManager.ExecSQL("UPDATE TaskProcess Set Content='任务分配至本组',DateTime = '" + DateTime.Now.ToString() + "',State = 2 WHERE TaskID =" + TaskID + " AND RecvUser = " + Session["UserID"].ToString());

                MyManager.ExecSQL("INSERT INTO TaskLog (TaskID,CreateUserID,CreateUserName,Title,Content,DateTime) VAlues('"
                            + TaskID + "','"
                            + Session["UserID"].ToString() + "','"
                            + Session["Name"].ToString() + "','"
                            + "任务认领" + "','"
                            + Session["Name"].ToString() + "','"
                            + DateTime.Now.ToString() + "')");
            }
            else //4 5 6 8 任务被认领 被退回 被撤回 已分配他组
            {
                MyManager.ExecSQL("UPDATE TaskProcess Set DateTime = '" + DateTime.Now.ToString() + "',State = 9 WHERE TaskID =" + TaskID + " AND RecvUser = " + Session["UserID"].ToString());

                MyManager.ExecSQL("INSERT INTO TaskLog (TaskID,CreateUserID,CreateUserName,Title,Content,DateTime) VAlues('"
                            + TaskID + "','"
                            + Session["UserID"].ToString() + "','"
                            + Session["Name"].ToString() + "','"
                            + "获知" + "','"
                            + GridView1.Rows[Convert.ToInt32(RowIndex)].Cells[7].Text + "','"
                            + DateTime.Now.ToString() + "')");
            }

        }
        /*-------------------------------------组员---------------------------------------------------------*/
        if (UserType == "2")//组员
        {
            if (RealTaskProcessState == "1" || RealTaskProcessState == "7")//组员 State = 7开始领取任务。
            {
                Title = "任务领取";
                //组员该任务状态变为处理中2
                MyManager.ExecSQL("UPDATE TaskProcess Set Content='处理中',DateTime = '" + DateTime.Now.ToString() + "',State = 2 WHERE TaskID =" + TaskID + " AND RecvUser = " + Session["UserID"].ToString());

                MyManager.ExecSQL("INSERT INTO TaskLog (TaskID,CreateUserID,CreateUserName,Title,Content,DateTime) VAlues('"
                  + TaskID + "','"
                  + Session["UserID"].ToString() + "','"
                  + Session["Name"].ToString() + "','"
                  + Title + "','"
                  + GridView1.Rows[Convert.ToInt32(RowIndex)].Cells[5].Text + "','"
                  + DateTime.Now.ToString() + "')");
            }
            else // 5 6任务被撤回或者退回
            {
                MyManager.ExecSQL("UPDATE TaskProcess Set Content='',DateTime = '" + DateTime.Now.ToString() + "',State = 9 WHERE TaskID =" + TaskID + " AND RecvUser = " + Session["UserID"].ToString());

                MyManager.ExecSQL("INSERT INTO TaskLog (TaskID,CreateUserID,CreateUserName,Title,Content,DateTime) VAlues('"
                  + TaskID + "','"
                  + Session["UserID"].ToString() + "','"
                  + Session["Name"].ToString() + "','"
                  + "获知" + "','"
                  + GridView1.Rows[Convert.ToInt32(RowIndex)].Cells[7].Text + "','"
                  + DateTime.Now.ToString() + "')");
            }
        }

        GV1Bind();
    }
    protected void GridView1_RowCreated(object sender, GridViewRowEventArgs e)
    {
        e.Row.Cells[0].Visible = false;
        e.Row.Cells[1].Visible = false;
        e.Row.Cells[5].Visible = false;
    }

    protected void LinkButton1_Click(object sender, EventArgs e)
    {
        Page.ClientScript.RegisterStartupScript(this.GetType(), "", "<script>window.open('TaskDetails.aspx?TaskID=" + ((LinkButton)sender).CommandArgument.ToString() + "','newwindow','titlebar=no,toolbar=no,location=no,top=100,left=200')</script>");
    }

    protected void GridView2_RowCreated(object sender, GridViewRowEventArgs e)
    {
        e.Row.Cells[0].Visible = false;
        e.Row.Cells[1].Visible = false;
        e.Row.Cells[5].Visible = false;
        if (Session["UserType"].ToString() == "2")
        {
            e.Row.Cells[11].Visible = false;
        }
    }
    protected void GridView2_SelectedIndexChanged1(object sender, EventArgs e)
    {

    }
    protected void RollBackBtn_Click(object sender, EventArgs e)
    {



    }
    protected void GridView2_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType != DataControlRowType.Header)
        {
            Button DealBtn = (Button)e.Row.FindControl("DealBtn");
            Button RollBtn = (Button)e.Row.FindControl("RollBackBtn");
            Button OutBtn = (Button)e.Row.FindControl("OutBtn");
            LinkButton lkBtn = (LinkButton)e.Row.FindControl("LinkButton2");

            if (lkBtn != null)
            {
                lkBtn.CommandArgument = e.Row.Cells[0].Text;
                lkBtn.Text = e.Row.Cells[5].Text;
            }
            if (OutBtn != null)
            {
                OutBtn.CommandArgument = e.Row.Cells[0].Text + "|" + e.Row.RowIndex.ToString() + "|" + e.Row.Cells[1].Text;
            }

            if (DealBtn != null)
            {
                 DealBtn.CommandArgument = e.Row.Cells[0].Text + "|" + e.Row.RowIndex.ToString() + "|" + e.Row.Cells[1].Text;
            }

            if (RollBtn != null)
            {
                RollBtn.CommandArgument = e.Row.Cells[0].Text + "|" + e.Row.RowIndex.ToString() + "|" + e.Row.Cells[1].Text;
                
                if (Session["UserType"].ToString() == "1")
                {
                    RollBtn.Text = "退回";
                    RollBtn.CommandName = "退回";
                }

                
                    if (Session["UserType"].ToString() == "0")
                    {
                        RollBtn.Text = "撤回";
                        RollBtn.CommandName = "撤回";
                    }

               
                
            }
        }
    }
    protected void RollBackBtn_Click1(object sender, EventArgs e)
    {
        int i = 0;
        Button Btn = (Button)sender;
        String txt = Btn.Text;
        String TaskID = "";
        String RealTaskProcessState = "", RowIndex = "", GVTaskProcessState = "";
        String[] Arr = Btn.CommandArgument.Split('|');
        DataTable dt;
        String Msg = "", Title = "";

      
        TaskID = Arr[0];
        RowIndex = Arr[1];
        GVTaskProcessState = Arr[2];
        RealTaskProcessState = MyManager.GetFiledByInput("SELECT  top 1 State FROM TaskProcess WHERE TaskID = " + TaskID + " AND RecvUser=" + Session["UserID"].ToString(), "State");

        if (RealTaskProcessState != GVTaskProcessState)
        {
            Page.ClientScript.RegisterStartupScript(Page.GetType(), "message", "<script language='JavaScript'>showDlg('任务状态有更新，请重新查看!');</script>");
            GV1Bind();
            return;
        }

        if (Session["UserType"].ToString() == "1"&& Btn.CommandName =="退回")//组长
        {

            //通知自己和组员，任务被该组长退回
            MyManager.ExecSQL("UPDATE TaskProcess Set Content='任务被" + Session["Name"].ToString() +"退回',State = 5 WHERE  TaskID = "+TaskID+" AND RecvUser IN (SELECT ID FROM UserList WHERE  CorpID = " + Session["CorpID"].ToString() + ") ");

            //通知科长，任务被该组长撤回
            MyManager.ExecSQL("UPDATE TaskProcess Set Content='任务被" + Session["Name"].ToString() + "退回',State = 5 WHERE  TaskID = " + TaskID + " AND RecvUser IN (SELECT ID FROM UserList WHERE UserType =0 AND CorpID = " + Session["CorpParentID"].ToString() + ") ");

            //写任务流转记录
            MyManager.WriteTaskFlow(TaskID, Session["UserID"].ToString(), Session["CorpID"].ToString(), Session["CorpParentID"].ToString(), "科队内流转:任务退回", DateTime.Now.ToString());

            //写任务日志
            MyManager.ExecSQL("INSERT INTO TaskLog (TaskID,CreateUserID,CreateUserName,Title,Content,DateTime) VAlues('"
                 + TaskID + "','"
                 + Session["UserID"].ToString() + "','"
                 + Session["Name"].ToString() + "','"
                 + "任务退回" + "','"
                 + "" + "','"
                 + DateTime.Now.ToString() + "')");
            
        }

        if (Session["UserType"].ToString() == "0" && Btn.CommandName == "撤回")//领导
        {

            String CC, CurCorpID, CurCorpName;//CC部门ID和名 34|质检科
            String[] tArr;
           
            CC = MyManager.GetFiledByInput("SELECT (convert(varchar(4),CorpID) + '|' + CorpName) AS CC  FROM Tasks AS A join Corps AS B on A.RecvCorpID = B.CorpID Where A.ID=" + TaskID, "CC");
            tArr = CC.Split('|');
            CurCorpID = tArr[0];
            CurCorpName = tArr[1];

            //通知该组组长和组员，任务被撤回
            MyManager.ExecSQL("UPDATE TaskProcess Set Content='任务被" + Session["Name"].ToString() + "撤回',State = 5 WHERE  TaskID = " + TaskID + " AND RecvUser IN (SELECT ID FROM UserList WHERE  CorpID =  (SELECT RecvCorpID FROM Tasks WHERE ID = "+TaskID+" )) ");

            //通知"科长们"，任务被撤回
            MyManager.ExecSQL("UPDATE TaskProcess Set Content='任务被" + Session["Name"].ToString() + "撤回',State = 5 WHERE  TaskID = " + TaskID + " AND RecvUser IN (SELECT ID FROM UserList WHERE UserType =0 AND CorpID = " + Session["CorpParentID"].ToString() + ") ");

            //写任务流转记录
            MyManager.WriteTaskFlow(TaskID, Session["UserID"].ToString(), CurCorpID, Session["CorpParentID"].ToString(), "科队内流转:任务被撤回", DateTime.Now.ToString());

            //写任务日志
            MyManager.ExecSQL("INSERT INTO TaskLog (TaskID,CreateUserID,CreateUserName,Title,Content,DateTime) VAlues('"
                 + TaskID + "','"
                 + Session["UserID"].ToString() + "','"
                 + Session["Name"].ToString() + "','"
                 + "任务撤回" + "','"
                 + "原部门:"+CurCorpName + "','"
                 + DateTime.Now.ToString() + "')");
        }
        GV2Bind();
    }
    protected void OutBtn_Click(object sender, EventArgs e)
    {
        int i = 0;
        Button Btn = (Button)sender;
        String txt = Btn.Text;
        String TaskID = "";
        String RealTaskProcessState = "", RowIndex = "", GVTaskProcessState = "";
        String[] Arr = Btn.CommandArgument.Split('|');
        DataTable dt;
        String Msg = "", Title = "";


        TaskID = Arr[0];
        RowIndex = Arr[1];
        GVTaskProcessState = Arr[2];
        RealTaskProcessState = MyManager.GetFiledByInput("SELECT  top 1 State FROM TaskProcess WHERE TaskID = " + TaskID + " AND RecvUser=" + Session["UserID"].ToString(), "State");

        if (RealTaskProcessState != GVTaskProcessState)
        {
            Page.ClientScript.RegisterStartupScript(Page.GetType(), "message", "<script language='JavaScript'>showDlg('任务状态有更新，请重新查看!');</script>");
           
            return;
        }

        Page.ClientScript.RegisterStartupScript(Page.GetType(), "message", "<script language='JavaScript'>showDialogByUrl('CorpsSelect.aspx?TaskID=" + TaskID + "','TaskManage.aspx');</script>");


       // GV2Bind();
    }
    protected void Button2_Click(object sender, EventArgs e)
    {

    }
    protected void Button3_Click(object sender, EventArgs e)
    {

    }
}
