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
    class rUser
    {
        public TcpClient client;
        public NetworkStream NWStream;
        public NetworkStream bw;
        public rUser(TcpClient client)
        {
            this.client = client;
            NWStream = client.GetStream();
     //       br = new StreamReader(networkStream);
       //     bw = new StreamWriter(networkStream);
        }
    }
}
