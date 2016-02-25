﻿using System;
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
using System.Runtime.InteropServices;

namespace WindowsFormsApplication1
{
    public partial class Form1 : Form
    {
         struct Mach
        {
            public int    MachID;
            public String MachName;
            public String MachIP;
            public int[]  ConnectedAnts;
        };
         List<Mach> MachLst = new List<Mach>();
        public Form1()
        {
            InitializeComponent();
        }
        Reader rd;
        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
               
               rd = Reader.Create("192.168.1.100", ModuleTech.Region.NA, 4);

            }
            catch (Exception ex)
            {
                MessageBox.Show("连接失败，请检查读写器地址是否正确" + ex.ToString());
               
                return;
            }

          lst1.Items.Add("连接成功！");
          /*  int[] connectedants = (int[])rd.ParamGet("ConnectedAntennas");
            for (int c = 0; c < connectedants.Length; ++c)
            {
                lst1.Items.Add(c + "->" + connectedants[c]);
            }
            TagFilter tf = (TagFilter)rd.ParamGet("Singulation");*/
            
          // rd.read

            int[] ants = new int[] { 1 };
           // Gen2TagFilter filter = new Gen2TagFilter(ByteFormat.FromHex("AAAABBBB"),MemBank.EPC, 32, false);
            //rd.ParamSet("Singulation", filter);
            SimpleReadPlan searchPlan = new SimpleReadPlan(ants);
            rd.ParamSet("ReadPlan", searchPlan);
           
        }

        private void button2_Click(object sender, EventArgs e)
        {


            TagReadData[] tags = rd.Read(500);
            foreach (TagReadData tag in tags)
            {
                lst1.Items.Add(tag.EPCString + "->" + tag.Rssi +"->" + tag.Time.ToString() + "->" + tag.Antenna);
            }
        }

        
     
 
        private void button3_Click(object sender, EventArgs e)
        {

         
            
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
            Mach mc;
            String Ant;
            DataTable dt = MyManager.GetDataSet("SELECT * FROM MachList");
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                mc = new Mach();
                mc.MachID = Convert.ToInt32( dt.Rows[i]["ID"].ToString());
                mc.MachName = dt.Rows[i]["MachineName"].ToString();
                mc.MachIP = dt.Rows[i]["IP"].ToString();
                mc.ConnectedAnts= Array.ConvertAll<string, int>(dt.Rows[i]["ConnectedAnt"].ToString().Split('|'), delegate(string s) { return int.Parse(s); });
                MachLst.Add(mc);
            }
        }
    }
}