using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using Newtonsoft.Json;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.IO;
using Newtonsoft.Json.Linq;
using ModuleTech;
using System.Diagnostics;
using ModuleTech.Gen2;
using ModuleLibrary;

namespace WindowsFormsApplication3
{


    public partial class Form1 : Form
    {



        class Mach
        {
            public int MachID;
            public String MachName;
            public String MachIP;
            public Reader rd;
            public Thread Mthread;
            public int ReConnectedCount;
            public int[] ConnectedAnts;
        };
        [Serializable]
        class TagInfo
        {
            public String EPC;
            public String ToolNum;
            public int Rssi;
            public DateTime LastSeen;
            public long ReadCount;
            public int PosX;
            public int PosY;
        };

        Mach mc;

        public Form1()
        {
            InitializeComponent();
        }
        public const int INFO  = 0;
        public const int REMIND = 1;
        public const int ALERT = 2;
        public const int WARN = 3;
        TcpListener mListener;
        int Port;
        List<rUser> UserList;
        int fpcHandle;
        int CurUserID;
        Reader rd;

        void initMach()
        {
            String Ant;
            DataTable dt = MyManager.GetDataSet("SELECT * FROM MachList Where Type = 'One'");
            if (dt.Rows.Count == 0)
            {
                MessageBox.Show("无法在数据库中获取读写器IP地址！程序即将退出!");
                System.Environment.Exit(0);
            }
                mc = new Mach();
                mc.MachID = Convert.ToInt32(dt.Rows[0]["ID"].ToString());
                mc.MachName = dt.Rows[0]["MachineName"].ToString();
                mc.MachIP = dt.Rows[0]["IP"].ToString();
                // mc.ConnectedAnts = Array.ConvertAll<string, int>(dt.Rows[i]["ConnectedAnt"].ToString().Split('|'), delegate(string s) { return int.Parse(s); });
                mc.rd = null;
          
        }


        String PrepareReader()
        {
            String Ret = "OK";
            int i, j, k;
         
                try
                {
                    mc.rd = Reader.Create(mc.MachIP, ModuleTech.Region.NA, 4);

                    int[] connectedants = (int[])rd.ParamGet("ConnectedAntennas");
                    mc.ConnectedAnts = (int[])connectedants.Clone();
         
                    SimpleReadPlan searchPlan = new SimpleReadPlan(mc.ConnectedAnts);
                    mc.rd.ParamSet("ReadPlan", searchPlan);
            //        mc.Mthread = new Thread(new ParameterizedThreadStart(TagMonitorThread));
                   // MyManager.AddInfoToDB("信息", MachLst[i].MachName + "连接成功！");
                }
                catch (Exception ex)
                {
                    Ret = mc.MachName + "-->" + ex.ToString();
                  //  MyManager.AddInfoToDB("错误", Ret);
                    ;
                }
            
            return Ret;
        }

        String SetReaderFilterByToolNumAndRead(String ToolNum)
        {
            Gen2TagFilter filter = new Gen2TagFilter(ByteFormat.FromHex(MyManager.GenerateEPC(ToolNum)), MemBank.EPC, 32, false);
            mc.rd.ParamSet("Singulation", filter);
            try
            {
                TagReadData[] Tags = mc.rd.Read(500);
                if (Tags.Length > 0)
                {
                    return "";
                }
            }
            catch (Exception ex)
            { 
                
            }
      
        }

        private delegate void DispMSGDelegate(String Type,String Content,int Eventlevel);
        public void AddMsg(String Type, String Content,int EventLevel)
        {
            if (listView1.InvokeRequired == false)
            {
                ListViewItem item = new ListViewItem(listView1.Items.Count + 1 + "");
                if (EventLevel == REMIND)
                {
                    item.ForeColor = Color.Green;
                }
                else if (EventLevel == ALERT)
                {
                    item.ForeColor = Color.Yellow;
                }
                else if (EventLevel == WARN)
                {
                    item.ForeColor = Color.Red;
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
                listView1.Invoke(DMSGD, Type, Content,EventLevel);
                
            }
        }

        private String DealCmd(rUser user,String CmdDat)
        {

            JObject JO = JObject.Parse(CmdDat);
            try{
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

                AddMsg("信息", "处理完毕-->" +CmdDat, INFO);
                return "{\"status\":\"success\",\"msg\":\"命令执行成功\"}";

            }catch(Exception e)
            {
                AddMsg("警告","解析"+CmdDat+"错误!",WARN);
                return "{\"status\":\"failed\",\"reason\":\"解析命令失败!\"}";
            }
           
        }

        private void ReceiveData(object obj)
        {
            rUser user = (rUser)obj;
            TcpClient client = user.client;
            int RDCN = 0;
            Boolean Continue = true;
            byte[] buff = new byte[4096];
            AddMsg("信息", "启动一个接收消息线程",1);
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
                     } while (user.NWStream.DataAvailable );

                   //if (RecvStr != null || RecvStr != "")
                   {
                       AddMsg("收到消息", RecvStr, 0);
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
                catch(Exception ex)
                {
                    AddMsg("异常", ex.ToString(),3);
                }
                if (RecvStr == null || RDCN == 0)
                {//跟客户端失去联系
                    AddMsg("信息", "跟客户端失去联系",3);
                    Continue = false;
                }

            }

            UserList.Remove(user);
            client.Close();
           
        }

        private void SendToClient( String str)
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
                        AddMsg("发送消息->" + i, str, INFO);

                    }
                    catch
                    {//发送失败
                        AddMsg("发送消息失败->" + i, str, WARN);
                    }
                }
            }
        }

        public void FingerInit()
        {
            int InitRet;


            FingerHW.SensorIndex = 0;
            AddMsg("信息", "开始初始化指纹仪", INFO);

            InitRet = FingerHW.InitEngine();
            if (InitRet != 0)
            {
                if (InitRet == 1)
                {
                    MessageBox.Show("指纹识别驱动程序加载失败。");
                }
                if (InitRet == 2)
                {
                    MessageBox.Show("没有连接指纹识别仪");
                }
                System.Environment.Exit(0);
                return;
            }

            FingerHW.Threshold = 8;
            AddMsg("信息", "最小成功比对分数设定为8", INFO);
            AddMsg("信息", "指纹仪初始化成功", REMIND);


        }

        void LoadAllFingerToMemAndStartCapture()
        {
            byte[] tmp;
            string tmpstr = "";
            int autoid = 0;
            fpcHandle = FingerHW.CreateFPCacheDB();

            DataTable dt = MyManager.GetDataSet("SELECT ID,[FingerTmpStr] From UserList ");

            AddMsg("信息", "开始加载指纹模板", INFO);
            foreach (DataRow dw in dt.Rows)
            {
                FingerHW.AddRegTemplateToFPCacheDB(fpcHandle, Convert.ToInt32(dw["ID"].ToString()),Convert.FromBase64String(dw["FingerTmpStr"].ToString()) );
            }
            AddMsg("信息", "指纹模板加载完成", REMIND);

            if (FingerHW.IsRegister)
            {
                FingerHW.CancelEnroll();
            }
            FingerHW.BeginCapture();
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
                AddMsg("信息", "新连接" + ((IPEndPoint)newClient.Client.RemoteEndPoint).Address.ToString(), 1);

                //每接受一个客户端连接,就创建一个对应的线程循环接收该客户端发来的信息
                ParameterizedThreadStart pts = new ParameterizedThreadStart(ReceiveData);
                Thread threadReceive = new Thread(pts);
                rUser user = new rUser(newClient);
                user.Active = 0;
                UserList.Add(user);
                threadReceive.Start(user);
                
            }
        }
        private void Form1_Load(object sender, EventArgs e)
        {
            Port = 7900;
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
            AddMsg("信息", "监听成功!",1);

            UserList =  new List<rUser>();

            sPort.Text = Port+"";
            sListenState.Text = "监听中";

            ThreadStart ts = new ThreadStart(ListenClientConnect);
            Thread myThread = new Thread(ts);
            myThread.Start();

            FingerInit();
            LoadAllFingerToMemAndStartCapture();
            listView1.FullRowSelect = true;
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
    
        }

        private void Form1_FormClosed(object sender, FormClosedEventArgs e)
        {
            System.Environment.Exit(0);
        }

        private void listView1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void FingerHW_OnCapture(object sender, AxZKFPEngXControl.IZKFPEngXEvents_OnCaptureEvent e)
        {
            int score = 9;
            int processedFPNumber = 0;
            int UserID = FingerHW.IdentificationInFPCacheDB(fpcHandle, e.aTemplate, ref score, ref processedFPNumber);
            //if (id > 0)
            if (UserID > 0)
            {
                CurUserID = UserID;
                AddMsg("信息", "捕获指纹UserID=" + UserID, REMIND);
                SendToClient("{\"type\":\"UserCapture\",\"userid\":\""+UserID+"\"}");
            }
            else
            {
                AddMsg("信息", "指纹比对失败!" + UserID,ALERT);
                SendToClient("{\"type\":\"UserCapture\",\"userid\":\"\null\"}");
            }
        }
    }
}
