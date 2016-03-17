using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
//添加的命名空间引用
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.IO;



namespace WindowsFormsApplication3
{


    public partial class Form1 : Form
    {
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
        private void ReceiveData(object obj)
        {
            rUser user = (rUser)obj;
            TcpClient client = user.client;
            int RDCN = 0;
            Boolean Continue = true;
            byte[] buff =  new byte[user.client.ReceiveBufferSize];
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
                        RDCN = user.NWStream.Read(buff, 0, user.client.ReceiveBufferSize);

                        RecvStr += System.Text.Encoding.UTF8.GetString(buff, 0, RDCN);
                     } while (user.NWStream.DataAvailable );

                   if (RecvStr != null || RecvStr != "")
                   {
                       AddMsg("收到消息", RecvStr, 0);
                   }
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

        private void SendToClient(rUser user, string str)
        {
            try
            {
                //将字符串写入网络流，此方法会自动附加字符串长度前缀
               // user.bw.Write(str);
                //user.bw.Flush();
 
            }
            catch
            {//发送失败
            
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
                AddMsg("信息", "新连接" + ((IPEndPoint)newClient.Client.RemoteEndPoint).Address.ToString(), 1);

                //每接受一个客户端连接,就创建一个对应的线程循环接收该客户端发来的信息
                ParameterizedThreadStart pts = new ParameterizedThreadStart(ReceiveData);
                Thread threadReceive = new Thread(pts);
                rUser user = new rUser(newClient);
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
        }
    }
}
