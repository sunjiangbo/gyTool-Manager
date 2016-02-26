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
            public int[] ConnectedAnts;
        };

        class TagInfo{
            public String EPC;
            public String ToolNum;
            public int    Rssi;
            public DateTime LastSeen;
            public long   ReadCount;
            public int    PosX;
            public int    PosY;
        };

        List<Mach> MachLst = new List<Mach>();
        Mutex TagMux = new Mutex();
        Dictionary<String, TagInfo> TagDic = new Dictionary<String, TagInfo>();
        Reader rd;
        Boolean isInventory = false;
        void  initMach()
        {
            Mach mc;
            String Ant;
            DataTable dt = MyManager.GetDataSet("SELECT * FROM MachList");
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                mc = new Mach();
                mc.MachID = Convert.ToInt32(dt.Rows[i]["ID"].ToString());
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
                    if (connectedants.Length < 2)
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
                    MyManager.AddInfoToDB("错误", MachLst[i].MachName + "连接成功！");
                }
                catch (Exception ex)
                {
                    Ret = MachLst[i].MachName + "-->" + ex.ToString();
                    MyManager.AddInfoToDB("错误",Ret);
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
                tTagInfo.LastSeen = Tag.Time;
                tTagInfo.ReadCount++;
                if (tTagInfo.Rssi > Tag.Rssi ) //说明新来的定位信号更强，更准确，并且得到的工具位置发生了变更。
                {
                    tTagInfo.PosX = MachID;
                    tTagInfo.PosY = Tag.Antenna;
                    tTagInfo.Rssi = Tag.Rssi;
                }
            }
            else
            {
                tTagInfo = new TagInfo();
                tTagInfo.ReadCount = 1;
                tTagInfo.LastSeen = Tag.Time;
                tTagInfo.PosX = MachID;
                tTagInfo.PosY = Tag.Antenna;
                tTagInfo.Rssi = Tag.Rssi;
                TagDic.Add(EPC, tTagInfo);
            }

            TagMux.ReleaseMutex();
        }

        void TagMonitorThread(object Mach)
        {
            Mach mc = (Mach)Mach;
            int MachID = mc.MachID;
            while (isInventory)
            {
               TagReadData[] Tags = mc.rd.Read(500);
               foreach (TagReadData tag in Tags)
               {
                   AddTagToDic(tag,MachID);
               }
            }
        }


        void CreateMonitorThreads()
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
                    lst1.Items.Add(MachLst[i].MachName + "未建立连接!");
                    break;
                }
                //只显示EPC以FFFF FFFF开头的标签
                Gen2TagFilter filter = new Gen2TagFilter(ByteFormat.FromHex("FFFFFFFF"), MemBank.EPC, 32, false);
                rd.ParamSet("Singulation", filter);
                SimpleReadPlan searchPlan = new SimpleReadPlan(MachLst[i].ConnectedAnts);
                rd.ParamSet("ReadPlan", searchPlan);
                MachLst[i].Mthread = new Thread(new ParameterizedThreadStart(TagMonitorThread));
            }

            if (unFinished==1) return;

            for (i = 0; i < MachLst.Count; i++)
            {
                MachLst[i].Mthread.Start(MachLst[i]);
            }           
        }
//--------------------------------------------------------------------------------------------------------------------------------------
        public Form1()
        {
            InitializeComponent();
        }


        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
               
               rd = Reader.Create("192.168.1.101", ModuleTech.Region.NA, 4);

            }
            catch (Exception ex)
            {
                MessageBox.Show("连接失败，请检查读写器地址是否正确" + ex.ToString());
               
                return;
            }

            lst1.Items.Add("连接成功！");
            int[] connectedants = (int[])rd.ParamGet("ConnectedAntennas");
            for (int c = 0; c < connectedants.Length; ++c)
            {
                lst1.Items.Add(c + "->" + connectedants[c]);
            }
            TagFilter tf = (TagFilter)rd.ParamGet("Singulation");
            
          // rd.read

            int[] ants = new int[] { 1,4 };
            Gen2TagFilter filter = new Gen2TagFilter(ByteFormat.FromHex("FFFFFFFF"),MemBank.EPC, 32, false);
            rd.ParamSet("Singulation", filter);
            SimpleReadPlan searchPlan = new SimpleReadPlan(ants);
            rd.ParamSet("ReadPlan", searchPlan);
           
        }

        private void button2_Click(object sender, EventArgs e)
        {
            isInventory = true;
            /*
            TagReadData[] tags = rd.Read(500);
            foreach (TagReadData tag in tags)
            {
                lst1.Items.Add(tag.EPCString + "->" + tag.Rssi +"->" + tag.Time.ToString() + "->" + tag.Antenna);
            }*/
        }




        private void button3_Click(object sender, EventArgs e)
        {
            lst1.Items.Add(MyManager.DecodeEPC(MyManager.GenerateEPC("ZGT")));
            lst1.Items.Add((char)67);
        }
        private void button4_Click(object sender, EventArgs e)
        {
            for (int i = 0; i < MachLst.Count; i++)
            {
                lst1.Items.Add(MachLst[i].MachName + MachLst[i].MachIP);
            }
        }
      
        private void Form1_Load(object sender, EventArgs e)
        {
            return;
            String Ret;
            initMach();
            Ret = CheckAntAndInitReaders();
            if (Ret == "OK")
            {
                lst1.Items.Add("所有机器和天线连接正常!");
            }
            else
            {
                lst1.Items.Add(Ret);
            }
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
            TagMux.WaitOne();
            BinaryFormatter Formatter = new BinaryFormatter(null, new StreamingContext(StreamingContextStates.Clone));
            MemoryStream stream = new MemoryStream();
            Formatter.Serialize(stream, TagDic);
            TagMux.ReleaseMutex();

            stream.Position = 0;
            object clonedObj = Formatter.Deserialize(stream);
            stream.Close();

            Dictionary<String, TagInfo> tmpTagDic = (Dictionary<String, TagInfo>) clonedObj;
        }
    }
}
