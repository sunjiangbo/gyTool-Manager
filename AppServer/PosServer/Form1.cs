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
            public Thread Mthread;
            public int ReConnectedCount;
            public int[] ConnectedAnts;
        };
         [Serializable]
        class TagInfo{
            public String EPC;
            public String ToolNum;
            public int    Rssi;
            public DateTime LastSeen;
            public long   ReadCount;
            public int    PosX;
            public int    PosY;           
        };

         public const int INFO = 0;
         public const int REMIND = 1;
         public const int ALERT = 2;
         public const int WARN = 3;
        List<Mach> MachLst = new List<Mach>();
        Mutex TagMux = new Mutex();
        Mutex CoreTabDAMux = new Mutex();
        static Dictionary<String, TagInfo> TagDic = new Dictionary<String, TagInfo>();
        object clonedObj;
        Reader rd;
        Boolean isInventory = true;
       
        SqlDataAdapter CoreTabDA;


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
                listView1.Items.Insert(0, item);
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
            DataTable dt = MyManager.GetDataSet("SELECT * FROM MachList Where Type ='Fix'");
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                mc = new Mach();
                mc.MachID = Convert.ToInt32(dt.Rows[i]["MachID"].ToString());
                mc.MachName = dt.Rows[i]["MachineName"].ToString();
                mc.MachIP = dt.Rows[i]["IP"].ToString();
               // mc.ConnectedAnts = Array.ConvertAll<string, int>(dt.Rows[i]["ConnectedAnt"].ToString().Split('|'), delegate(string s) { return int.Parse(s); });
                mc.rd = null;
                MachLst.Add(mc);
            }
        }
        
        String CheckAntAndInitReaders()
        {
            String Ret = "OK";
            int i, j, k;
            for (i = 0; i < MachLst.Count; i++)
            {
                try
                {
                    MachLst[i].rd = Reader.Create(MachLst[i].MachIP, ModuleTech.Region.NA, 4);

                    int[] connectedants = (int[])MachLst[i].rd.ParamGet("ConnectedAntennas");
                    if (connectedants.Length <1)
                    {
                        Ret = "";
                        int[] xx = { 0, 0, 0, 0 };
                        for (j = 0; j < connectedants.Length; j++)
                        {
                            xx[connectedants[j] - 1] = 1;
                        }
                        for (k = 0; k < 4; k++)
                        {
                            if (xx[k] == 0)
                            {
                                Ret += (k + 1).ToString() + " ";
                            }
                        }
                        Ret = MachLst[i].MachName + "," + Ret + "号天线未连接!!";
                        MyManager.AddInfoToDB("错误", Ret);                        
                        break;
                    }
                    MachLst[i].ConnectedAnts = (int[])connectedants.Clone();
                    MyManager.AddInfoToDB("信息", MachLst[i].MachName + "连接成功！");
                }
                catch (Exception ex)
                {
                    Ret = MachLst[i].MachName + "-->" + ex.ToString();
                    MyManager.AddInfoToDB("错误",Ret);
                    AddMsg(Ret, WARN);
                    AddMsg("请检查后重新启动本程序!", WARN);
                    isInventory = false;
                    break;
                }
            }
            return Ret;
        }

        void AddTagToDic(TagReadData Tag,int MachID)
        {
            TagInfo tTagInfo;
            String EPC = Tag.EPCString;
            TagMux.WaitOne();
            
            if (TagDic.ContainsKey(EPC))
            {
                tTagInfo = TagDic[EPC];
                if ((tTagInfo.PosX == MachID && tTagInfo.PosY==Tag.Antenna) ||Tag.Rssi>(tTagInfo.Rssi+9) || ((TimeSpan)(DateTime.Now - tTagInfo.LastSeen)).Seconds >10){
                   /* 必须保证所有读写器和服务器时间同步
                    * 算法描述:若最新位置和原位置相同，则更新其信息(主要是RSSI)。
                    *          若位置不一致，则其RSSI必须大于原RSSI+9
                    *          或者20s后强制更新。
                    */
                    
                    tTagInfo.LastSeen = DateTime.Now;//Tag.Time;
                    tTagInfo.ReadCount++;
                    tTagInfo.PosX = MachID;
                    tTagInfo.PosY = Tag.Antenna;
                    tTagInfo.Rssi = Tag.Rssi;
                }
            }
            else
            {
                tTagInfo = new TagInfo();
                tTagInfo.ReadCount = 1;
                tTagInfo.LastSeen = DateTime.Now;//Tag.Time;
                tTagInfo.PosX = MachID;
                tTagInfo.PosY = Tag.Antenna;
                tTagInfo.Rssi = Tag.Rssi;
                TagDic.Add(EPC, tTagInfo);
            }

          TagMux.ReleaseMutex();
        }

        void ReConnect(Mach mc)
        {

            int i, j, k;
            String Ret = "";

            if (mc.ReConnectedCount >100)
            {
                /*本设备重连超过五次不成功，可能连接存在问题
                 */

                MyManager.AddInfoToDB("错误", mc.MachName + "重连100次不成功,不再尝试连接。");
                return;
            }

            try
            {
                mc.ReConnectedCount++;
                Thread Old = mc.Mthread;//保存其旧线程，待重新连接完毕，关闭它，因为Reconnect本身所在线程就是旧线程
                MyManager.AddInfoToDB("信息", mc.MachName + "开始重连.");
                mc.rd = Reader.Create(mc.MachIP, ModuleTech.Region.NA, 4);

                int[] connectedants = (int[])mc.rd.ParamGet("ConnectedAntennas");

                if (connectedants.Length < 1)
                {
                    Ret = "";
                    int[] xx = { 0, 0, 0, 0 };
                    for (j = 0; j < connectedants.Length; j++)
                    {
                        xx[connectedants[j] - 1] = 1;
                    }
                    for (k = 0; k < 4; k++)
                    {
                        if (xx[k] == 0)
                        {
                            Ret += (k + 1).ToString() + " ";
                        }
                    }
                    Ret = mc.MachName + "," + Ret + "号天线未连接!!";
                    MyManager.AddInfoToDB("错误", Ret);
                }
                mc.ConnectedAnts = (int[])connectedants.Clone();
                Gen2TagFilter filter = new Gen2TagFilter(ByteFormat.FromHex("FFFFFFFF"), MemBank.EPC, 32, false);
                mc.rd.ParamSet("Singulation", filter);
                SimpleReadPlan searchPlan = new SimpleReadPlan(mc.ConnectedAnts);
                mc.rd.ParamSet("ReadPlan", searchPlan);
                mc.Mthread = new Thread(new ParameterizedThreadStart(TagMonitorThread));
                mc.Mthread.Start(mc);
               // Old.Abort();
                MyManager.AddInfoToDB("信息", mc.MachName + "重连并启动监视线程成功！");
                Old.Abort();
                mc.ReConnectedCount=0;
                isInventory = true;
            }
            catch (Exception ex)
            {
                Ret = mc.MachName + "，重连-->" + ex.ToString();
                MyManager.AddInfoToDB("错误", Ret);
                AddMsg(Ret, WARN);
                ReConnect(mc);
            }
            mc.ReConnectedCount = 0;

       }

        void TagMonitorThread(object Mach)
        {
            Mach mc = (Mach)Mach;
            int MachID = mc.MachID;
           while (isInventory)
            {
                try
                {
                    TagReadData[] Tags = mc.rd.Read(500);
                    foreach (TagReadData tag in Tags)
                    {
                        AddTagToDic(tag, MachID);
                    }
                }
                catch (OpFaidedException ex1)
                {
                    MyManager.AddInfoToDB("OpFaidedException", mc.MachName + "->" + ex1.ToString());
                    AddMsg("OpFaidedException:" + mc.MachName + "->" + ex1.ToString(), WARN);
                }
                catch (Exception ex2)//需要重新连接机器
                {
                    MyManager.AddInfoToDB("错误", mc.MachName + "->" + ex2.ToString() + ",开始重新连接。");
                    AddMsg("警告:"+ mc.MachName + "->" + ex2.ToString() + ",开始重新连接。", WARN);
                    //isInventory = false;
                    ReConnect(mc);
                }
            }
        }


        void  CreateMonitorThreads()
        {
            int i,unFinished=0;

            if (MachLst.Count == 0)
            {
                return;
            }

            for (i = 0,unFinished=0; i < MachLst.Count; i++)
            {
                if (MachLst[i].rd == null)
                {
                    unFinished = 1;
                    MyManager.AddInfoToDB("错误", MachLst[i].MachName + "未建立连接!");
                    //lst1.Items.Add(MachLst[i].MachName + "未建立连接!");
                    AddMsg(MachLst[i].MachName + "未建立连接!",WARN);
                    break;
                }
                //只显示EPC以FFFF FFFF开头的标签
               Gen2TagFilter filter = new Gen2TagFilter(ByteFormat.FromHex("FFFFFFFF"), MemBank.EPC, 32, false);
               MachLst[i].rd.ParamSet("Singulation", filter);
               SimpleReadPlan searchPlan = new SimpleReadPlan(MachLst[i].ConnectedAnts);
                MachLst[i].rd.ParamSet("ReadPlan", searchPlan);
                MachLst[i].Mthread = new Thread(new ParameterizedThreadStart(TagMonitorThread));
            }

            if (unFinished==1) return;

            for (i = 0; i < MachLst.Count; i++)
            {
                MachLst[i].Mthread.Start(MachLst[i]);
               // lst1.Items.Add("启动"+ MachLst[i].Mthread);
                AddMsg(MachLst[i].MachName + "监视线程成功启动!", INFO);
            }

            AddMsg("线程创建完毕", INFO);
        }

        public void GetCoreTab(object source, System.Timers.ElapsedEventArgs e)
        {
            CoreTabDAMux.WaitOne();
            CoreTabDA = MyManager.GetDataADP("Exec GetCoreTablePRC"); 
            //this.Invoke(new TextOption(f));//invok 委托实现跨线程的调用
            CoreTabDAMux.ReleaseMutex();
        }

       /* delegate void TextOption();//定义一个委托

        void f()
        {
            label1.Text = DateTime.Now.ToString();//调用内容，并用lable1显示出来。。。
        }
       */
        public void GetCoreTabThread()
        {
            System.Timers.Timer t = new System.Timers.Timer(1500);//
            t.Elapsed += new System.Timers.ElapsedEventHandler(GetCoreTab);
            t.AutoReset = true;//设置是执行一次（false）还是一直执行(true)；
            t.Enabled = true;//是否执行System.Timers.Timer.Elapsed事件；
        }
        public void UpdateAllToolStateThread()
        {
            System.Timers.Timer t1 = new System.Timers.Timer(2000);//
            t1.Elapsed += new System.Timers.ElapsedEventHandler(UpdateAllToolState);
            t1.AutoReset = true;//设置是执行一次（false）还是一直执行(true)；
            t1.Enabled = true;//是否执行System.Timers.Timer.Elapsed事件；
        }
        public int GetSecendsDeta(DateTime Start,DateTime End)
        {
            TimeSpan span = (TimeSpan)(End - Start);
            return span.Seconds;
        }
        public void UpdateAllToolState(object source, System.Timers.ElapsedEventArgs e)
        {
  
            if (!isInventory) return;

             Dictionary<String, TagInfo> tmpTagDic = (Dictionary<String, TagInfo>) clonedObj;
             int i = 0;
             DataRow[] drs;
             String EPC;
             String State;
             TagInfo tag;
             DataTable CoreTabDT = new DataTable();//CoreTool表的datatable,4秒更新一次

             CoreTabDAMux.WaitOne();
             try
             {
                 CoreTabDA.Fill(CoreTabDT);

                 //  for (i = 0; i < CoreTabDT.Rows.Count; )
                 foreach (DataRow dr in CoreTabDT.Rows)
                 {
                     EPC = dr["EPC"].ToString();
                     State = dr["State"].ToString();

                     if (tmpTagDic.ContainsKey(EPC))//实际在库
                     {
                         tag = tmpTagDic[EPC];
                         dr["PosX"] = tag.PosX;
                         dr["PosY"] = tag.PosY;
                         dr["LastSeen"] = tag.LastSeen.ToString();

                         if (State == "0")//理论在库
                         {
                             dr["RealState"] = 5;
                         }
                         else if (State == "2") //理论借出
                         {
                             dr["RealState"] = 6;
                         }
                         else
                         {
                             dr["RealState"] = 0;
                         }
                         tmpTagDic.Remove(EPC);//从tmpTagDic中移除该tag，减小下次dict的查询负担。
                     }
                     else//实际不在库
                     {
                         if (State == "0")//在库
                         {
                             dr["RealState"] = 7;
                         }
                         else if (State == "2") //借出
                         {
                             dr["RealState"] = 2;
                         }
                         else
                         {
                             dr["RealState"] = 8;
                         }
                     }

                 }
                 SqlCommand cmd = new SqlCommand();
                 SqlCommandBuilder sb = new SqlCommandBuilder(CoreTabDA);
                 DataTable dsModified = CoreTabDT.GetChanges(DataRowState.Modified);
                 if (dsModified != null && dsModified.Rows.Count != 0)
                 {
                     cmd = sb.GetUpdateCommand();
                    // AddMsg(dsModified.Rows.Count + "-->" + cmd.CommandText, INFO);
                     CoreTabDA.Update(CoreTabDT);
                 }
             }
             catch (Exception exx) {
                  MyManager.AddInfoToDB("错误", "UpdateAllToolState--->" + exx.Message);
                 AddMsg("UpdateAllToolState--->" + exx.Message, WARN);
             }

             CoreTabDAMux.ReleaseMutex();            
        }

//----------------------------------------------------自写函数分解线--------------------------------------------------
        public Form1()
        {
            InitializeComponent();
        }


        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
               
               rd = Reader.Create("192.168.1.250", ModuleTech.Region.NA, 4);

            }
            catch (Exception ex)
            {
                MessageBox.Show("连接失败，请检查读写器地址是否正确" + ex.ToString());
               
                return;
            }

        //    lst1.Items.Add("连接成功！");
            int[] connectedants = (int[])rd.ParamGet("ConnectedAntennas");
            for (int c = 0; c < connectedants.Length; ++c)
            {
                //lst1.Items.Add(c + "->" + connectedants[c]);
            }
            TagFilter tf = (TagFilter)rd.ParamGet("Singulation");
            
          // rd.read

            int[] ants = new int[] { 1,2 };
            Gen2TagFilter filter = new Gen2TagFilter(ByteFormat.FromHex("FFFFFFFF"),MemBank.EPC, 32, false);
            rd.ParamSet("Singulation", filter);
            SimpleReadPlan searchPlan = new SimpleReadPlan(ants);
            rd.ParamSet("ReadPlan", searchPlan);
           
        }

        private void button2_Click(object sender, EventArgs e)
        {
            isInventory = false;
            AddMsg("探测线程关闭", INFO);
            /*
            TagReadData[] tags = rd.Read(500);
            foreach (TagReadData tag in tags)
            {
                lst1.Items.Add(tag.EPCString + "->" + tag.Rssi +"->" + tag.Time.ToString() + "->" + tag.Antenna);
            }*/
        }




        private void button3_Click(object sender, EventArgs e)
        {
            
        }
        private void button4_Click(object sender, EventArgs e)
        {
            isInventory = true;
            AddMsg("探测线程重新开启", INFO);
        }
      
        private void Form1_Load(object sender, EventArgs e)
        {
           
            String Ret;
            isInventory = true;
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
            CreateMonitorThreads();
            (new Thread(GetCoreTabThread)).Start();
            (new Thread(UpdateAllToolStateThread)).Start();
            isInventory = true;
        }

        private void button5_Click(object sender, EventArgs e)
        {
            ListViewItem item = new ListViewItem(lv1.Items.Count.ToString());
            
            item.SubItems.Add("EPC");
            //item.SubItems.Add(tag.epcid);
           // item.SubItems.Add(tag.antid.ToString());
            lv1.Items.Add(item);
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            if (!isInventory) return;

            TagMux.WaitOne();
            BinaryFormatter Formatter = new BinaryFormatter(null, new StreamingContext(StreamingContextStates.Clone));
            MemoryStream stream = new MemoryStream();
            Formatter.Serialize(stream, TagDic);
            TagMux.ReleaseMutex();


            stream.Position = 0;
            clonedObj = Formatter.Deserialize(stream);
            Dictionary<String, TagInfo> tmpTagDic = (Dictionary<String, TagInfo>)clonedObj;
            stream.Close();

            // Dictionary<String, TagInfo> tmpTagDic;
            // tmpTagDic =  (Dictionary<String, TagInfo>) clonedObj;
            try
            {
                foreach (String Key in tmpTagDic.Keys)
                {
                 //  AddMsg(tmpTagDic[Key].LastSeen + "-->" + MyManager.DecodeEPC(Key) + "-->天线:" + tmpTagDic[Key].PosY + "->信号强度:" + TagDic[Key].Rssi, INFO);
                    if (lv1.Items.ContainsKey(Key))
                    {
                        ListViewItem item = lv1.Items[Key];

                        item.SubItems[1].Text = MyManager.DecodeEPC(Key);
                        item.SubItems[2].Text = tmpTagDic[Key].LastSeen.ToString();
                        item.SubItems[3].Text = tmpTagDic[Key].ReadCount.ToString();
                        item.SubItems[4].Text = tmpTagDic[Key].Rssi.ToString();
                        item.SubItems[5].Text = tmpTagDic[Key].PosY.ToString();
                        item.SubItems[6].Text = tmpTagDic[Key].PosX.ToString();
                    }
                    else
                    {
                        ListViewItem item = new ListViewItem(Key);
                        item.Name = Key;
                        item.SubItems.Add(MyManager.DecodeEPC(Key));
                        item.SubItems.Add(tmpTagDic[Key].LastSeen.ToString());
                        item.SubItems.Add(tmpTagDic[Key].ReadCount.ToString());
                        item.SubItems.Add(tmpTagDic[Key].Rssi.ToString());
                        item.SubItems.Add(tmpTagDic[Key].PosY.ToString());
                        item.SubItems.Add(tmpTagDic[Key].PosX.ToString());
                        lv1.Items.Add(item);
                    }
                }

            }
            catch (Exception exxx)
            {
                MyManager.AddInfoToDB("错误", "UpdateAllToolState--->" + exxx.Message);
            }
        }
        private void lv1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void listView1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click_1(object sender, EventArgs e)
        {
            textBox2.Text = MyManager.GenerateEPC(textBox1.Text);
        }

        private void button3_Click_1(object sender, EventArgs e)
        {
            String s1,s2;
            s1 = "10:01:00";
            s2 = "10:01:07";
            MessageBox.Show(GetSecendsDeta(Convert.ToDateTime(s1),Convert.ToDateTime(s2))+"");
        }
    }
}
