using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Configuration;
using System.Data.OleDb;
using System.Runtime.InteropServices;
using System.IO;
using System.Data;
namespace 指纹登机
{
    public partial class Form1 : Form
    {
        public AxZKFPEngXControl.AxZKFPEngX gZK;
        public TreeNode CurNode;
        public Boolean isConnected;
        public struct NodeTag{
             public String UserID;
             public String UserName;
             public int HaveFingerTmp;
        }; 
        [DllImport(@"C:\WINDOWS\system32\match.dll")]
        public static extern bool process(string ARegTemplate, string AVerTemplate);
        [DllImport(@"C:\WINDOWS\system32\match.dll")]
        public static extern int process10(string ARegTemplate, string AVerTemplate);
        public Form1()
        {
            InitializeComponent();
        }
        void initMachine()
        {
  
            axZKFPEngX1.SensorIndex = 0;
            axZKFPEngX1.EnrollCount = 3;//登记指纹时，需要登记三次。
            if (axZKFPEngX1.InitEngine() == 0)
            {
               // MessageBox.Show("连接成功！");
                isConnected = true;
                stLb2.Text = "已连接";
               // fpcHandle = axZKFPEngX1.CreateFPCacheDB();

                /*txtb1.Text = axZKFPEngX1.SensorCount.ToString();
                txtb2.Text = axZKFPEngX1.SensorIndex.ToString();
                txtb3.Text = axZKFPEngX1.ImageWidth.ToString();
                txtb4.Text = axZKFPEngX1.ImageHeight.ToString();
                txtb5.Text = axZKFPEngX1.SensorSN;
                
                btnCloseSensor.Enabled = true;
                btnInitialSensor.Enabled = false;
                statusBar1.Panels[1].Text = "初始化成功!";*/

            }
            else
            {
                stLb2.Text = "未连接";
               //  MessageBox.Show("连接失败！");
                isConnected = false;
            }
        }
        void CreateTree( TreeView tv)
        {
            String NodeName;
            DataTable dt = MyManager.GetDataSet("select ID,name,(case when FingerTmpStr is null then 0 when FingerTmpStr IS not null then 1 end) as sign  from userlist order by Name asc");
            TreeNode p_node = tv.Nodes.Add("全体人员");
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (dt.Rows[i]["sign"].ToString() == "0")
                {
                    NodeName = dt.Rows[i]["Name"].ToString() + "(N)";
                }
                else
                {
                    NodeName = dt.Rows[i]["Name"].ToString() + "(Y)";
                }
                NodeTag nt = new NodeTag();
                nt.UserName = dt.Rows[i]["Name"].ToString();
                nt.UserID = dt.Rows[i]["ID"].ToString();
                nt.HaveFingerTmp =Convert.ToInt32( dt.Rows[i]["sign"].ToString());
                TreeNode node  =  new TreeNode (NodeName);
                node.Tag = nt;
                if (nt.HaveFingerTmp == 0) { node.ForeColor = Color.Red; }
                
                p_node.Nodes.Add(node);
            }
            p_node.Expand();
            //tv.Nodes.Add(p_node);
        }
        private void Form1_Load(object sender, EventArgs e)
        {
            
            CreateTree(treeView1);
            initMachine();
            gZK = axZKFPEngX1;
        }

        private void tabPage1_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (isConnected == false) {
                MessageBox.Show("指纹仪没有连接!");
                return;
            }
            CurNode = treeView1.SelectedNode;
            if (CurNode == null)
            {
                MessageBox.Show("没有选择人员!");
                return;
            }
            if (gZK.IsRegister)
            {
                gZK.CancelEnroll();
            }
            gZK.BeginEnroll();
            button1.Enabled = false;
            button3.Enabled = true;
        }

        private void treeView1_NodeMouseClick(object sender, TreeNodeMouseClickEventArgs e)
        {
            NodeTag nt = (NodeTag)e.Node.Tag;
            label2.Text = "未登记";
            button1.Enabled = true;
            button2.Enabled = false;
            button3.Enabled = false;
            if (nt.HaveFingerTmp == 1)
            {
                label2.Text = "已登记";
                DataTable dt = MyManager.GetDataSet("SELECT FingerTmpStr,FingerTmpBin,FingerImg From UserList Where ID = " + nt.UserID);
                textBox1.Text = dt.Rows[0]["FingerTmpStr"].ToString();
               // pictureBox1.Image
               // pictureBox1.Load(dt.Rows[0]["FingerImg"].ToString());
                button1.Enabled = false;
                button2.Enabled = false;
                button3.Enabled = true;
            }
            //MessageBox.Show(e.Node.Text + "" + nt.UserID);
        }

        private void treeView1_AfterSelect(object sender, TreeViewEventArgs e)
        {

        }

        private void axZKFPEngX1_OnImageReceived(object sender, AxZKFPEngXControl.IZKFPEngXEvents_OnImageReceivedEvent e)
        {
            if (!gZK.IsRegister) return;
            Graphics g = pictureBox1.CreateGraphics();
            Bitmap bmp = new Bitmap(pictureBox1.Width, pictureBox1.Height);
            g = Graphics.FromImage(bmp);
            int handle1 = g.GetHdc().ToInt32();
            axZKFPEngX1.PrintImageAt(handle1, 0, 0, bmp.Width, bmp.Height);
            g.Dispose();
            pictureBox1.Image = bmp;
        }
        private byte[] GetImageBytes(Image image)
        {
            MemoryStream mstream = new MemoryStream();
            image.Save(mstream, System.Drawing.Imaging.ImageFormat.Jpeg);
            byte[] byteData = new Byte[mstream.Length];
            mstream.Position = 0;
            mstream.Read(byteData, 0, byteData.Length);
            mstream.Close();
            return byteData;
        }  
        private void axZKFPEngX1_OnFeatureInfo(object sender, AxZKFPEngXControl.IZKFPEngXEvents_OnFeatureInfoEvent e)
        {
            if (!gZK.IsRegister) return;
            string strTemp = "指纹质量";
            if (e.aQuality == 0)
            {
                strTemp = strTemp + "合格";
            }
            else
            {
                if (e.aQuality == 1)
                {
                    strTemp = strTemp + "特征点不够";
                }
                else
                    strTemp = strTemp + "不合格";
            }
            if (axZKFPEngX1.IsRegister)
                if (axZKFPEngX1.EnrollIndex != 1)
                    strTemp = strTemp + " 登记状态：请再按 " + (axZKFPEngX1.EnrollIndex - 1).ToString() + "次指纹";
                else
                    strTemp = strTemp + " 登记状态：登记成功!";
            textBox2.Text = strTemp;
        }

        private void axZKFPEngX1_OnEnroll(object sender, AxZKFPEngXControl.IZKFPEngXEvents_OnEnrollEvent e)
        {
            byte[] tmpbyte;
            string tmp = "";
            tmp = gZK.GetTemplateAsString();
            textBox1.Text = tmp;
            if (MyManager.InsertFingerTmp(((NodeTag)CurNode.Tag).UserID, tmp, (byte[])e.aTemplate, GetImageBytes(pictureBox1.Image)) ==true)
            {
                MessageBox.Show("指纹登记成功!");
                textBox2.Text = "指纹登机成功！";
                NodeTag nt = (NodeTag)CurNode.Tag;
                nt.HaveFingerTmp = 1;
                CurNode.Text = nt.UserName + "(Y)";
                CurNode.ForeColor = Color.Black;
            }
            else {
                MessageBox.Show("指纹登记失败!");
                textBox2.Text = "指纹登机失败！";
            }
           

            button1.Enabled = true;
            button3.Enabled = false;
   
            //tmpbyte = Convert.FromBase64String(tmp);
            //开始检查指纹是否重复
            //DataTable dt = MyManager.GetDataSet("SELECT UserName,UserID,FingerTmp From UserList Where UserID <>" + ((NodeTag)CurNode.Tag).UserID + " AND "); 
        }
    }
}
