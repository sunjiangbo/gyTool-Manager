using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Windows.Forms;
using System.Threading;
using ModuleTech;
using System.Diagnostics;
using ModuleTech.Gen2;
using ModuleLibrary;
using System.IO;
using System.Runtime.Serialization;
using System.Runtime.InteropServices;
using System.Runtime.Serialization.Formatters.Binary;
using System.Net;
using System.Net.Sockets;
using Newtonsoft.Json.Linq;

namespace WindowsFormsApplication1
{
    public partial class Form1 : Form
    {

         class Mach
        {
            public int    MachID;
            public String MachName;
            public String MachIP;
            public Reader rd;
           
            public int ReConnectedCount;
            public int[] ConnectedAnts;
        };
         
      

         public const int INFO = 0;
         public const int REMIND = 1;
         public const int ALERT = 2;
         public const int WARN = 3;


      

        Mach[] McArr;
        TcpListener mListener;
        int Port;
        List<rUser> UserList;


        public String LightCtl(int PosX, int PosY, bool lightOn)
        {
            int i, j;
             AddMsg("LightCtl:" + PosX  +" " + PosY,INFO);
             try
             {
                 if (PosX == 0 && PosY == 0)
                 {

                     for (i = 0; i < McArr.Length; i++)
                     {
                        // AddMsg("bg" + i, INFO);
                         if (McArr[i] == null || McArr[i].rd == null)
                             continue;

                         for (j = 1; j <= 4; j++)
                         {
                             McArr[i].rd.GPOSet(j, lightOn == true ? false : true);
                             //AddMsg("cur" + i + " " + j, INFO);
                         }
                     }
                     return "{\"status\":\"success\",\"msg\":\"命令执行成功\"}";
                 }
               

                
                 AddMsg("开始执行GPOSet(" + PosY + "," + (lightOn == true ? "true" : "false") + ")", INFO);
                 McArr[PosX].rd.GPOSet(PosY, lightOn==true? false : true);
                 return "{\"status\":\"success\",\"msg\":\"命令执行成功\"}";
             }
             catch (Exception ex)
             {
                 AddMsg("LightCtl->" + ex.Message, WARN);
                 return "{\"status\":\"failed\",\"msg\":\""+ex.Message+"\"}";
             }

        }

        private String DealCmd(rUser user, String CmdDat)
        {

            JObject JO = JObject.Parse(CmdDat);
            try
            {
                String Cmd = JO["cmd"].ToString();

                if (Cmd == "DeactiveME")
                {

                    SendToClient("{\"status\":\"success\",\"msg\":\"失活执行成功,提前发送\"}");
                    user.Active = 0;
                }

                if (Cmd == "activeME")
                {
                    user.Active = 1;
                }

                if (Cmd == "LightCtl")
                {
                    String sRet =  LightCtl(Convert.ToInt32(JO["posx"].ToString()),Convert.ToInt32(JO["posy"].ToString()),JO["lighton"].ToString()=="true"?true:false);
                    AddMsg(sRet, INFO);
                    return sRet;
                }              


                AddMsg( "处理完毕-->" + CmdDat, INFO);
                return "{\"status\":\"success\",\"msg\":\"命令执行成功\"}";

            }
            catch (Exception e)
            {
                AddMsg("执行错误!" + CmdDat + e.Message, WARN);
                return "{\"status\":\"failed\",\"reason\":\"解析命令失败!" + e.Message + "\"}";
            }

        }
        private void ReceiveData(object obj)
        {
            rUser user = (rUser)obj;
            TcpClient client = user.client;
            int RDCN = 0;
            Boolean Continue = true;
            byte[] buff = new byte[4096];
            AddMsg( "启动一个接收消息线程", INFO);
            while (Continue)
            {
                string RecvStr = null;

                try
                {
                    //从网络流中读出字符串
                    //此方法会自动判断字符串长度前缀，并根据长度前缀读出字符串
                    RDCN = 0;
                    RecvStr = null;
                    do
                    {

                        RDCN = user.NWStream.Read(buff, 0, 4096);
                        RecvStr += System.Text.Encoding.UTF8.GetString(buff, 0, RDCN);
                    } while (user.NWStream.DataAvailable);

                    //if (RecvStr != null || RecvStr != "")
                    {
                        AddMsg("收到消息"+RecvStr, 0);
                    }
                    //   do
                    //   {
                    //Thread.Sleep(3000);
                    //SendToClient(DateTime.Now.ToString()+"");
                    SendToClient(DealCmd(user, RecvStr));
                    //byte [] ptrby = System.Text.Encoding.UTF8.GetBytes(RecvStr);
                    //  user.NWStream.Write(ptrby, 0, ptrby.Length);
                    // RecvStr += System.Text.Encoding.UTF8.GetString(buff, 0, RDCN);
                    // } while (user.NWStream.DataAvailable )
                }
                catch (Exception ex)
                {
                    AddMsg("异常"+ ex.ToString(), 3);
                }
                if (RecvStr == null || RDCN == 0)
                {//跟客户端失去联系
                    AddMsg( "跟客户端失去联系", 3);
                    Continue = false;
                }

            }

            UserList.Remove(user);
            client.Close();

        }

        private void SendToClient(String str)
        {
            int i = 0;
            rUser user;
            for (i = 0; i < UserList.Count; i++)
            {
                user = UserList[i];
                if (user.Active == 1)
                {
                    try
                    {
                        byte[] ptrby = System.Text.Encoding.UTF8.GetBytes(str);
                        user.NWStream.Write(ptrby, 0, ptrby.Length);
                        //将字符串写入网络流，此方法会自动附加字符串长度前缀
                        // user.bw.Write(str);
                        //user.bw.Flush();
                        AddMsg("发送消息->" + i+ str, INFO);

                    }
                    catch
                    {//发送失败
                        AddMsg("发送消息失败->" + i+ str, WARN);
                    }
                }
            }
        }

        private void ListenClientConnect()
        {
            while (true)
            {
                TcpClient newClient = null;
                try
                {
                    //等待用户进入
                    newClient = mListener.AcceptTcpClient();
                }
                catch
                {
                    //当单击“停止监听”或者退出此窗体时AcceptTcpClient()会产生异常
                    //因此可以利用此异常退出循环
                    break;
                }
                AddMsg("新连接" + ((IPEndPoint)newClient.Client.RemoteEndPoint).Address.ToString(), INFO);

                //每接受一个客户端连接,就创建一个对应的线程循环接收该客户端发来的信息
                ParameterizedThreadStart pts = new ParameterizedThreadStart(ReceiveData);
                Thread threadReceive = new Thread(pts);
                rUser user = new rUser(newClient);
                user.Active = 0;
                UserList.Add(user);
                threadReceive.Start(user);

            }
        }
        private delegate void DispMSGDelegate(String Content, int Eventlevel);
        public void AddMsg( String Content, int EventLevel)
        {
            String Type;
            if (listView1.InvokeRequired == false)
            {
                ListViewItem item = new ListViewItem(listView1.Items.Count + 1 + "");
                if (EventLevel == REMIND)
                {
                    item.ForeColor = Color.Green;
                    Type = "提醒";
                }
                else if (EventLevel == ALERT)
                {
                    item.ForeColor = Color.Yellow;
                    Type = "警告";
                }
                else if (EventLevel == WARN)
                {
                    item.ForeColor = Color.Red;
                    Type = "报警";
                }
                else
                {
                    Type = "信息";
                }
                item.SubItems.Add(DateTime.Now.ToString());
                item.SubItems.Add(Type);
                item.SubItems.Add(Content);
                listView1.Items.Add(item);
            }
            else
            {
                DispMSGDelegate DMSGD = new DispMSGDelegate(AddMsg);

                //使用控件lstMain的Invoke方法执行DMSGD代理(其类型是DispMSGDelegate)
                listView1.Invoke(DMSGD, Content, EventLevel);

            }
        }

        void  initMach()
        {
            Mach mc;
            String Ant;
            DataTable dt = MyManager.GetDataSet("SELECT * FROM MachList Where Type ='Fix' ORDER BY MachID ASC");
            int MachID;
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                MachID = Convert.ToInt32(dt.Rows[i]["MachID"].ToString());
                McArr[MachID] = new Mach();
                McArr[MachID].MachID = MachID;
                McArr[MachID].MachName = dt.Rows[i]["MachineName"].ToString();
                McArr[MachID].MachIP = dt.Rows[i]["IP"].ToString();
               // mc.ConnectedAnts = Array.ConvertAll<string, int>(dt.Rows[i]["ConnectedAnt"].ToString().Split('|'), delegate(string s) { return int.Parse(s); });
                McArr[MachID].rd = null;
                AddMsg("读取" + McArr[MachID].MachName, INFO);
            }
        }


        String CheckAntAndInitReaders()
        {
            String Ret = "OK";
            int i, j, k;
            for (i = 0; i < McArr.Length; i++)
            {
                if (McArr[i]==null )
                    continue;

                try
                {
                    McArr[i].rd = Reader.Create(McArr[i].MachIP, ModuleTech.Region.NA, 4) ;
                    AddMsg("开始连接" + McArr[i].MachName, INFO);
                  

                    AddMsg( McArr[i].MachName + "连接成功！", INFO);
                    MyManager.AddInfoToDB("信息", McArr[i].MachName + "连接成功！");
                }
                catch (Exception ex)
                {
                    Ret = McArr[i].MachName + "-->" + ex.ToString();
                    MyManager.AddInfoToDB("错误", Ret);
                    AddMsg(Ret, WARN);
                    AddMsg("请检查后重新启动本程序!", WARN);
               
                    break;
                }
            }
            return Ret;
        }
     
       


       
//----------------------------------------------------自写函数分解线--------------------------------------------------
        public Form1()
        {
            InitializeComponent();
        }


        private void button1_Click(object sender, EventArgs e)
        {
            
           
        }

        private void button2_Click(object sender, EventArgs e)
        {
           
       
        }




        private void button3_Click(object sender, EventArgs e)
        {
            
        }
        private void button4_Click(object sender, EventArgs e)
        {
           
        }
        void ConnectAllRFID()
        {
            int i, unFinished = 0;

           

            for (i = 0, unFinished = 0; i < McArr.Length; i++)
            {
                if (McArr[i].rd == null)
                {
                    unFinished = 1;
                    MyManager.AddInfoToDB("错误", McArr[i].MachName + "未建立连接!");
                    //lst1.Items.Add(MachLst[i].MachName + "未建立连接!");
                    AddMsg(McArr[i].MachName + "未建立连接!", WARN);
                    break;
                }
                //只显示EPC以FFFF FFFF开头的标签
               
            }

            if (unFinished == 1) return;

          

            AddMsg("线程创建完毕", INFO);
        }
        private void Form1_Load(object sender, EventArgs e)
        {
           
            String Ret;
            
            Port = 7903;
            mListener = new TcpListener(Port);
            try
            {
                mListener.Start();
            }
            catch (Exception ex)
            {
                mListener.Stop();
                MessageBox.Show("在端口监听失败,程序退出!");
                Application.Exit();
            }
            AddMsg("Tcp"+Port+"监听成功!", 1);

            UserList = new List<rUser>();

           

            ThreadStart ts = new ThreadStart(ListenClientConnect);
            Thread myThread = new Thread(ts);
            myThread.Start();

            McArr = new Mach[12];

            initMach();
            
            
            Ret = CheckAntAndInitReaders();
            if (Ret == "OK")
            {
                //lst1.Items.Add("所有机器和天线连接正常!");
                AddMsg("所有机器和天线连接正常", REMIND);
            }
            else
            {
                AddMsg(Ret, WARN);
            }

            
        }

        private void button5_Click(object sender, EventArgs e)
        {
       
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
        }

        private void button2_Click_1(object sender, EventArgs e)
        {
           LightCtl(0, 0, true);
        }

        private void button3_Click_1(object sender, EventArgs e)
        {
           
        }

        private void button5_Click_1(object sender, EventArgs e)
        {
            LightCtl(0, 0, false);
        }
    }
}
