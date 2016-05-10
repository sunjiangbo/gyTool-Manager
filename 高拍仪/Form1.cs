using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using eloamComLib;
using System.Globalization;
using System.Timers;
using System.Threading;
using System.Net;
using System.Net.Sockets;
using Newtonsoft.Json.Linq;
using System.IO;
namespace EloamComDemo
{
    public partial class Form1 : Form
    {


        public const int INFO = 0;
        public const int REMIND = 1;
        public const int ALERT = 2;
        public const int WARN = 3;
        TcpListener mListener;
        int Port;
        List<rUser> UserList;

        private EloamGlobal global;
        private EloamVideo video;
        private int timer_value;

        private EloamImage globalTempImage;

        public EloamMemory m_pTemplate;
        public EloamMemory m_pFeature;

        //定义系统计时器
        private System.Timers.Timer timer;

        //设备列表
        private List<EloamDevice> deviceList;


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

        private delegate void DispMSGDelegate(String Type, String Content, int Eventlevel);
        public void AddMsg(String Type, String Content, int EventLevel)
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
                listView1.Invoke(DMSGD, Type, Content, EventLevel);

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

                if (Cmd == "TakePhoto")
                {
                    String localFileName = TakeShoot();
                    if (localFileName == "")
                    {
                        AddMsg("信息","拍照失败!!",ALERT);
                        return "{\"status\":\"error\",\"msg\":\"拍照失败!\"}";
                    }
                    AddMsg("信息","拍照成功-->"+localFileName,INFO);
                    String remoteURL = uploadFile("http://172.16.74.61:8080/imgupload.aspx", localFileName);

                    if (remoteURL == "error")
                    {
                        AddMsg("信息", "照片上传失败!!", ALERT);
                        return "{\"status\":\"error\",\"msg\":\"照片上传失败!!\"}";
                    }
                    AddMsg("信息", "上传成功-->" + remoteURL, INFO);
                    return "{\"status\":\"success\",\"msg\":\""+remoteURL+"\"}";
                }
                          

                AddMsg("信息", "处理完毕-->" + CmdDat, INFO);
                return "{\"status\":\"success\",\"msg\":\"命令执行成功\"}";

            }
            catch (Exception e)
            {
                AddMsg("警告", "解析" + CmdDat + "错误!", WARN);
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
            AddMsg("信息", "启动一个接收消息线程", 1);
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
                catch (Exception ex)
                {
                    AddMsg("异常", ex.ToString(), 3);
                }
                if (RecvStr == null || RDCN == 0)
                {//跟客户端失去联系
                    AddMsg("信息", "跟客户端失去联系", 3);
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
                        AddMsg("发送消息->" + i, str, INFO);

                    }
                    catch
                    {//发送失败
                        AddMsg("发送消息失败->" + i, str, WARN);
                    }
                }
            }
        }
        public Form1()
        {
            InitializeComponent();
            global = new EloamGlobal();
            deviceList = new List<EloamDevice>();

            m_pFeature = null;
            m_pTemplate = null;

            FormInit();

            Init();
        }
        public void FormInit()
        {
            //传入设备状态改变事件
            global.DevChange += DevChangeEventHandler;
            //传入移动监测事件
            global.MoveDetec += MoveDetecEventHandler;

            //初始化设备
            global.InitDevs();


            if (global.InitBarcode())
            {
                barcode.Enabled = true;
            }
            else
            {
                barcode.Enabled = false;
            }
        }


        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            closeVideo_Click(new object(), new EventArgs());

            int count = deviceList.Count;
            if (count != 0)
            {
                for (int i = 0; i < count; i++)
                {
                    deviceList[i].Destroy();
                }
            }
            deviceList.Clear();

            global.DeinitBarcode();

            if (null != m_pTemplate)
            {
                m_pTemplate.Destroy();
                m_pTemplate = null;
            }
            if (null != m_pFeature)
            {
                m_pFeature.Destroy();
                m_pFeature = null;
            }

            global.DeinitBiokey();
            global.DeinitIdCard();
            global.DeinitDevs();

            global = null;
        }

        //设备状态改变事件响应
        public void DevChangeEventHandler(int type, int idx, int dbt)
        {
            if (1 == type)
			{
				if (1 == dbt)//设备到达
				{
					EloamDevice tempDevice = (EloamDevice)global.CreateDevice(1, idx);
                    deviceList.Add(tempDevice);

                    selectDevice.Items.Add(tempDevice.GetFriendlyName());
                    if (-1 == selectDevice.SelectedIndex)
                    {
                        selectDevice.SelectedIndex = 0;//改变所选设备
                    }

				}
				else if (2 == dbt)//设备丢失
				{
                    EloamDevice tempDevice = deviceList[idx];
                    if (null != video)
					{
                        EloamDevice tempDevice2 = (EloamDevice)video.GetDevice();
                        if (tempDevice == tempDevice2)
                        {
                            closeVideo_Click(new object(), new EventArgs());
                        }
					}

                    deviceList[idx].Destroy();
                    deviceList.RemoveAt(idx);
                    selectDevice.Items.RemoveAt(idx);
					if (-1 == selectDevice.SelectedIndex)
					{
                        if (0 != deviceList.Count)
                        {
                            selectDevice.SelectedIndex = 0;
                        }
					}
				}
			}
        }

        //移动监测事件响应
        public void MoveDetecEventHandler(object pVideo, int id)
        {
            // Fire_MoveDetec
            shoot_Click(new object(), new EventArgs());
        }


        public String uploadFile(String url,String path)
        {
            HttpWebRequest request = WebRequest.Create(url) as HttpWebRequest;
            CookieContainer cookieContainer = new CookieContainer();
            request.CookieContainer = cookieContainer;
            request.AllowAutoRedirect = true;
            request.Method = "POST";
            string boundary = DateTime.Now.Ticks.ToString("X"); // 随机分隔线
            request.ContentType = "multipart/form-data;charset=utf-8;boundary=" + boundary;
            byte[] itemBoundaryBytes = Encoding.UTF8.GetBytes("\r\n--" + boundary + "\r\n");
            byte[] endBoundaryBytes = Encoding.UTF8.GetBytes("\r\n--" + boundary + "--\r\n");
            int pos = path.LastIndexOf("\\");
            string fileName = path.Substring(pos + 1);
            //请求头部信息 
            StringBuilder sbHeader = new StringBuilder(string.Format("Content-Disposition:form-data;name=\"file\";filename=\"{0}\"\r\nContent-Type:application/octet-stream\r\n\r\n", fileName));
            byte[] postHeaderBytes = Encoding.UTF8.GetBytes(sbHeader.ToString());
            FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read);
            byte[] bArr = new byte[fs.Length];
            fs.Read(bArr, 0, bArr.Length);
            fs.Close();
            Stream postStream = request.GetRequestStream();
            postStream.Write(itemBoundaryBytes, 0, itemBoundaryBytes.Length);
            postStream.Write(postHeaderBytes, 0, postHeaderBytes.Length);
            postStream.Write(bArr, 0, bArr.Length);
            postStream.Write(endBoundaryBytes, 0, endBoundaryBytes.Length);
            postStream.Close();
            //发送请求并获取相应回应数据
            HttpWebResponse response = request.GetResponse() as HttpWebResponse;
            //直到request.GetResponse()程序才开始向目标网页发送Post请求
            Stream instream = response.GetResponseStream();
            StreamReader sr = new StreamReader(instream, Encoding.UTF8);
            //返回结果网页（html）代码
            string content = sr.ReadToEnd();
            return content;
        }

        public bool  VideoOpen ()
        {
            int devIdx = 0;
            int resIdx = 0;
            int modeIdx = 0;

            if (-1 != devIdx)
            {
                if (null != video)
                {
                    video.Destroy();
                    video = null;
                }

                EloamDevice tempDevice = deviceList[devIdx];
                video = (EloamVideo)tempDevice.CreateVideo(resIdx, modeIdx + 1);

                if (null != video)
                {
                    eloamView.SelectVideo(video);
                    eloamView.SetText("打开视频中，请等待...", RGB(255, 255, 255));

                    selectDevice.Enabled = false;
                    selectResolution.Enabled = false;
                    selectMode.Enabled = false;

                    openVideo.Enabled = false;
                    closeVideo.Enabled = true;
                }

                return true;
            }
            else {
                return false;
            }
        }

        private void openVideo_Click(object sender, EventArgs e)
        {
            VideoOpen();
        }

        public uint RGB(uint r, uint g, uint b)
        {
            return (  ( (b << 16) | (g << 8) )  | r  );
        }

        private void closeVideo_Click(object sender, EventArgs e)
        {
            if (null != video)
            {
                eloamView.SetText(null, 0);
                video.Destroy();
                video = null;
            }

            eloamView.SetText(null, 0);

            Reset();
        }
        public void Reset()
        {
            Init();
        }
        public void Init()
        {
            selectDevice.Enabled = true;
            selectResolution.Enabled = true;
            selectMode.Enabled = true;

            openVideo.Enabled = true;
            closeVideo.Enabled = false;
            turnLeft.Enabled = false;
            turnRight.Enabled = false;
            exchangeLeftRight.Enabled = false;
            exchangeUpDown.Enabled = false;
            openProperty.Enabled = false;

            rectify.Enabled = false;
            rectify.Checked = false;
            removeGround.Enabled = false;
            removeGround.Checked = false;
            autoShoot.Enabled = false;
            autoShoot.Checked = false;

            openTimer.Enabled = false;
            openTimer.Checked = false;
            edit_Timer.Enabled = false;

            compoundShoot.Enabled = false;
            compoundShoot.Checked = false;

            pictureSavePath.Enabled = false;
            shoot.Enabled = false;

            timer_value = 5;
            edit_Timer.Text = timer_value.ToString();
            pictureSavePath.Text = "D:";

            barcode.Enabled = false;
        }


        private void openProperty_Click(object sender, EventArgs e)
        {
            if (null != video)
            {
                EloamDevice tempDevice = (EloamDevice)video.GetDevice();
                tempDevice.ShowProperty(eloamView.GetView());
            }
        }


        private void rectify_CheckedChanged(object sender, EventArgs e)
        {
            if (null != video)
            {
                if (rectify.Checked)
                {
                    video.EnableDeskew(0);
                }
                else
                {
                    video.DisableDeskew();
                }
            }
        }

        private void removeGround_CheckedChanged(object sender, EventArgs e)
        {
            if (null != video)
            {
                if (removeGround.Checked)
                {
                    video.EnableDelBkColor(0);
                }
                else
                {
                    video.DisableDelBkColor();
                }
            }
        }

        private void autoShoot_CheckedChanged(object sender, EventArgs e)
        {
            if (null != video)
            {
                if (autoShoot.Checked)
                {
                    video.EnableMoveDetec(0);
                }
                else
                {
                    video.DisableMoveDetec();
                }
            }
        }

        private void compoundShoot_CheckedChanged(object sender, EventArgs e)
        {
            if (compoundShoot.Checked)
            {
                if (null != globalTempImage)
                {
                    globalTempImage.Destroy();
                    globalTempImage = null;
                }
            }
        }

        public String TakeShoot()
        {
            if (null == video)
            {
                return "";
            }

            EloamView tempView = (EloamView)eloamView.GetView();
            EloamImage tempImage = (EloamImage)video.CreateImage(0, tempView);

            DateTime dateTime = DateTime.Now;
            string time = DateTime.Now.ToString(
                "yyyyMMdd_HHmmss_fff", DateTimeFormatInfo.InvariantInfo);
            string filename =  "D:\\photo\\" + time + ".jpg";

            if (tempImage.Save(filename, 0))
            {
                return filename;
            }

            return ""; 
        }

        private void shoot_Click(object sender, EventArgs e)
        {
            if(null == video){
                return;
            }

            EloamView tempView = (EloamView)eloamView.GetView();
            EloamImage tempImage = (EloamImage)video.CreateImage(0, tempView);


            if (null != tempImage)
            {

                DateTime dateTime = DateTime.Now;
                string time = DateTime.Now.ToString(
                    "yyyyMMdd_HHmmss_fff", DateTimeFormatInfo.InvariantInfo);
                string filename = pictureSavePath.Text + "\\Manual_" + time + ".jpg";

                if (compoundShoot.Checked)//合成拍照
                {
                    if (null == globalTempImage)
                    {
                        globalTempImage = tempImage;
                        MessageBox.Show("<合成拍摄中...> 请放下一张");
                    }
                    else
                    {
                        int w1 = globalTempImage.GetWidth();
                        int w2 = tempImage.GetWidth();
                        int width = (w1 > w2) ? w1: w2;
                        int h1 = globalTempImage.GetHeight();
                        int h2 = tempImage.GetHeight();
                        int height = h1 + h2;

                        EloamImage compoundImage = 
                            (EloamImage)global.CreateImage(width, height, 3);
                        if (null != compoundImage)
                        {
                            EloamRect rcDest1 = (EloamRect)global.CreateRect(0, 0, w1, h1);
                            EloamRect rcSrc1 = (EloamRect)global.CreateRect(0, 0, w1, h1);
                            compoundImage.Blend(rcDest1, globalTempImage, rcSrc1, 0, 0);

                            EloamRect rcDest2 = (EloamRect)global.CreateRect(0, h2, w2, h2);
                            EloamRect rcSrc2 = (EloamRect)global.CreateRect(0, 0, w2, h2);
                            compoundImage.Blend(rcDest2, tempImage, rcSrc2, 0, 0);

                            if (compoundImage.Save(filename, 0))
                            {
                                eloamView.PlayCaptureEffect();
                                eloamThumbnail.Add(filename);
                            }
                            else
                            {
                                MessageBox.Show("保存失败，请检查保存路径设置是否正确!");
                            }
                        }

                        globalTempImage.Destroy();
                        globalTempImage = null;
                    }

                }
                else
                {
                    if (tempImage.Save(filename, 0))
                    {
                       // eloamView.PlayCaptureEffect();
                       // eloamThumbnail.Add(filename);
                        if (barcode.Checked)
                        {
                            global.DiscernBarcode(tempImage);
                            int count = global.GetBarcodeCount();
                            if (count > 0)
                            {
                                string strMsg = "";
                                for (int i = 0; i < count; ++i)
                                {
                                    strMsg += global.GetBarcodeData(i) + "\r\n";
                                }

                                MessageBox.Show(strMsg);
                            }
                            else
                            {
                                MessageBox.Show("识别条码失败");
                            }
                        }
                    }
                    else
                    {
                        MessageBox.Show("保存失败，请检查保存路径设置是否正确!");
                    }
                    
                }

            }
        }


        private void turnLeft_Click(object sender, EventArgs e)
        {
            video.RotateLeft();
        }

        private void turnRight_Click(object sender, EventArgs e)
        {
            video.RotateRight();
        }

        private void exchangeLeftRight_Click(object sender, EventArgs e)
        {
            video.Mirror();
        }

        private void exchangeUpDown_Click(object sender, EventArgs e)
        {
            video.Flip();
        }

        private void openTimer_CheckedChanged(object sender, EventArgs e)
        {
            if (openTimer.Checked)
            {
                edit_Timer.Enabled = false;

                timer = new System.Timers.Timer();
                timer.Enabled = true;
                timer.Interval = 
                    uint.Parse(edit_Timer.Text) * 1000;//单位为毫秒
                timer.Elapsed += new ElapsedEventHandler(timer_Elapsed);
                
            }
            else
            {
                timer.Stop();
                timer.Enabled = false;
                edit_Timer.Enabled = true;
            }
        }
        void timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            shoot_Click(sender, e);
        }

        private void selectDevice_SelectedIndexChanged(object sender, EventArgs e)
        {

            int idx = selectDevice.SelectedIndex;//记录当前所选设备

            selectMode.Items.Clear();
            selectResolution.Items.Clear();
            
            if (-1 != idx)
            {
                EloamDevice tempDevice = deviceList[idx];

                //加载分辨率列表
                int count = tempDevice.GetResolutionCount();
                for (int i = 0; i < count; ++i)
                {
                    int width = tempDevice.GetResolutionWidth(i);
                    int height = tempDevice.GetResolutionHeight(i);

                    string str = width.ToString() + "*" + height.ToString();
                    selectResolution.Items.Add(str);
                }

                //加载模式列表
                int subtype = tempDevice.GetSubtype();
                if (0 != (subtype & 1) )
                {
                    selectMode.Items.Add("YUY2");
                }
                if (0 != (subtype & 2) )
                {
                    selectMode.Items.Add("MJPG");
                }

                //selectResolution.SelectedIndex = 0;
                //selectMode.SelectedIndex = 0;
                openVideo.Enabled = true;
            }
            else
            {
                openVideo.Enabled = false;
            }
        }

        private void edit_Timer_TextChanged(object sender, EventArgs e)
        {
            try
            {
                uint.Parse(edit_Timer.Text);
            }
            catch (System.Exception)
            {
                MessageBox.Show("请输入一个正整数");
                edit_Timer.Text = "5";
            }
        }

        private void eloamView_VideoAttach(object sender, AxeloamComLib._IEloamViewEvents_VideoAttachEvent e)
        {
            if (0 == e.videoId)
            {
                openVideo.Enabled = false;
                closeVideo.Enabled = true;
                turnLeft.Enabled = true;
                turnRight.Enabled = true;
                exchangeLeftRight.Enabled = true;
                exchangeUpDown.Enabled = true;
                openProperty.Enabled = true;

                rectify.Enabled = true;
                removeGround.Enabled = true;
                autoShoot.Enabled = true;

                openTimer.Enabled = true;
                edit_Timer.Enabled = true;

                compoundShoot.Enabled = true;

                pictureSavePath.Enabled = true;
                shoot.Enabled = true;

                barcode.Enabled = true;
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (!global.InitOcr())
            {
                MessageBox.Show("初始化失败");
                return;
            }
            
            EloamView tempView = (EloamView)eloamView.GetView();
            EloamImage tempImage = (EloamImage)video.CreateImage(0, tempView);
            if (tempImage != null)
            {
                global.DiscernOcr(1, tempImage);
                global.WaitOcrDiscern();
                global.SaveOcr("D://ocr.doc", 0);
            }
            else
            {
                MessageBox.Show("视频未打开");
            }
            global.DeinitOcr();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            Port = 7902;

            AddMsg("信息", "机器启动中", INFO);
            if (selectDevice.Items.Count == 0 || selectResolution.Items.Count == 0 || selectMode.Items.Count == 0)
            {
                AddMsg("警告", "机器未连接或连接异常，请重新启动程序。", WARN);
               return;
            }
             if (!VideoOpen()) {
               AddMsg("警告", "机器打开失败!", WARN);
               return;
           }

            AddMsg("信息", "机器打开成功!", INFO);

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
            AddMsg("信息", "监听成功!", 1);

            UserList = new List<rUser>();

            sListenState.Text = Port + "";
            sListenState.Text = "监听中";

            ThreadStart ts = new ThreadStart(ListenClientConnect);
            Thread myThread = new Thread(ts);
            myThread.Start();

          

            //listView1.FullRowSelect = true;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            
           AddMsg("信息", uploadFile("http://172.16.74.61:8080//imgupload.aspx", TakeShoot()),INFO);
        }

    }
}

