﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using ModuleTech;
using System.Threading;
using System.Diagnostics;


namespace ModuleReaderManager
{
    public partial class updatefrm : Form
    {
        public updatefrm()
        {
            InitializeComponent();
            this.progressBar1.Maximum = 100;
            this.progressBar1.Minimum = 0;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (this.cbbReadertype.SelectedIndex == -1)
            {
                MessageBox.Show("please select reader type");
                return;
            }
            OpenFileDialog of = new OpenFileDialog();
            if (this.cbbReadertype.SelectedIndex == 1 || this.cbbReadertype.SelectedIndex == 2)
                of.Filter = "maf|*.maf";
            else if (this.cbbReadertype.SelectedIndex == 4)
            {
            }
            else if (this.cbbReadertype.SelectedIndex == 5)
            {
                of.Filter = "bin|*.bin";
            }
            else if (this.cbbReadertype.SelectedIndex == 6)
            {
                if (this.textBox1.Text == string.Empty)
                {
                    MessageBox.Show("请输入读写器地址");
                    return;
                }

                if (this.textBox1.Text.ToLower().IndexOf("com") != -1)
                    of.Filter = "bin|*.bin";
                else
                    of.Filter = "maf|*.maf";
            }
            else
                of.Filter = "sim|*.sim";

            if (of.ShowDialog() == DialogResult.OK)
            {
                this.textBox2.Text = of.FileName;
            }
        }
        delegate void updateprog(float prg);
        delegate void EnableQuit();
        void EnableQuitbtn()
        {
            this.button1.Enabled = true;
            this.button2.Enabled = true;
            this.button3.Enabled = true;
            this.button4.Enabled = true;
        }

        void EnableQuitbtnforsuc()
        {
            this.button1.Enabled = true;
            this.button2.Enabled = true;
            this.button3.Enabled = true;
            this.button4.Enabled = true;
            if (this.cbbReadertype.SelectedIndex != 5 && this.cbbReadertype.SelectedIndex != 6)
                this.labsoftver.Text = (string)rd.ParamGet("SoftwareVersion");
        }

        void updateprogbar(float prg)
        {
            this.Invoke(new updateprog(updateui), prg);
        }

        void updateui(float prog)
        {
            int curstep = (int)(prog * 100);
            this.progressBar1.Value = curstep;
        }

        Reader rd = null;

        Thread updatehread;

        int readertype = -1;

        bool isBootFirmware = false;


        void updatefirmware()
        {
   //         Debug.WriteLine("开始升级");
            try
            {
                rd.FirmwareLoad(this.textBox2.Text.Trim(), new Reader.FirmwareUpdate(updateprogbar));
                isBootFirmware = true;
                MessageBox.Show("updating success");
                this.Invoke(new EnableQuit(EnableQuitbtnforsuc));

            }
            catch (Exception eex)
            {
                isBootFirmware = false;
                MessageBox.Show("updating failed: " + eex.ToString());
                this.Invoke(new EnableQuit(EnableQuitbtn));
                return;
            }


        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (this.cbbReadertype.SelectedIndex == -1)
            {
                MessageBox.Show("please select reader type");
                return;
            }
            if (this.textBox2.Text.Trim() == "")
            {
                MessageBox.Show("please input the path of firmware file");
                return;
            }
            if (this.textBox1.Text.Trim() == "")
            {
                MessageBox.Show("please input reader address (ip or serial port number)");
                return;
            }

            if (this.cbbReadertype.SelectedIndex == 1)
            {
                if (this.textBox1.Text.Trim().ToLower().Contains("com"))
                {
                    MessageBox.Show("this kind of reader can only update firmware by ethernet");
                    return;
                }
            }

            string fwpath = this.textBox2.Text.Trim();
            char[] dep = new char[1];
            dep[0] = '\\';
            string[] strs = fwpath.Split(dep);
            string fwfilename = strs[strs.Length - 1];

            if (this.cbbReadertype.SelectedIndex == 1)
            {
                if (!fwfilename.StartsWith("m5e"))
                {
                    MessageBox.Show("invalid firmware file name");
                    return;
                }
            }
            if (this.cbbReadertype.SelectedIndex == 2)
            {
                if (!fwfilename.StartsWith("m6e"))
                {
                    MessageBox.Show("invalid firmware file name");
                    return;
                }
            }
            

            if (rd == null)
            {
                try
                {
                    rd = Reader.Create(this.textBox1.Text.Trim(), this.cbbReadertype.SelectedIndex);
                    readertype = this.cbbReadertype.SelectedIndex;

                }
                catch (Exception exx)
                {
                    MessageBox.Show("fail to connect reader：" + exx.ToString());
                    this.Invoke(new EnableQuit(EnableQuitbtn));
                    return;
                }
            }


            if (updatehread != null)
            {
                updatehread.Join();

            }

            updatehread = new Thread(updatefirmware);
            updatehread.Start();
            this.button1.Enabled = false;
            this.button3.Enabled = false;
            this.button2.Enabled = false;
            this.button4.Enabled = false;
        }

        private void updatefrm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (rd != null)
                rd.Disconnect();
        }

        private void button3_Click(object sender, EventArgs e)
        {

            if (this.cbbReadertype.SelectedIndex == -1)
            {
                MessageBox.Show("please select reader type");
                return;
            }
            else if (this.cbbReadertype.SelectedIndex == 2)
            {
                MessageBox.Show("dose not support the operation");
                return;
            }
            if (this.textBox1.Text.Trim() == "")
            {
                MessageBox.Show("please input reader address (ip or serial port)");
                return;
            }
            try
            {
                if (rd == null)
                {
                    rd = Reader.Create(this.textBox1.Text.Trim(), this.cbbReadertype.SelectedIndex);

                    readertype = this.cbbReadertype.SelectedIndex;
                }
                if (readertype == 5)
                {
                    MessageBox.Show("dose not support the operation");
                    return;
                }
                this.labsoftver.Text = (string)rd.ParamGet("SoftwareVersion");
            }
            catch (Exception exx)
            {
                isBootFirmware = false;
                MessageBox.Show("fail to connect reader：" + exx.ToString());
                return;
            }


        }

        private void updatefrm_FormClosed(object sender, FormClosedEventArgs e)
        {
            if (updatehread != null)
                updatehread.Join();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            if (rd != null)
            {
                if (isBootFirmware && (readertype == 1 || readertype == 2 || readertype == 4))
                    rd.ParamSet("BootFirmware", true);
            }
            this.Close();
        }

    }
}