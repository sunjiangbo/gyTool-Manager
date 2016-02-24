﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using ModuleTech;
using ModuleTech.Gen2;
using ModuleLibrary;
using System.Threading;

namespace ModuleReaderManager
{
    public partial class regulatoryFrm : Form
    {
        Reader modrdr = null;
        public regulatoryFrm(Reader rdr)
        {
            modrdr = rdr;
            InitializeComponent();
        }

        private void btnsetopfre_Click(object sender, EventArgs e)
        {
            if (this.tbopfre.Text.Trim() == string.Empty)
            {
                MessageBox.Show("please input frequency point");
                return;
            }
            try
            {
                modrdr.ParamSet("setOperatingFrequency", uint.Parse(this.tbopfre.Text.Trim()));
            }
            catch
            {
                MessageBox.Show("setting failed");
            }
        }

        private void btntransCW_Click(object sender, EventArgs e)
        {
            if (this.btnsetopant.Enabled)
            {
                MessageBox.Show("please input antenna id");
                return;
            }
            try
            {
                modrdr.ParamSet("transmitCWSignal", 1);
                this.btnstopCW.Enabled = true;
                this.btntransCW.Enabled = false;
            }
            catch
            {
                MessageBox.Show("transmitting failed");
            }
        }

        private void btnstopCW_Click(object sender, EventArgs e)
        {
            try
            {
                modrdr.ParamSet("transmitCWSignal", 0);
                this.btntransCW.Enabled = true;
                this.btnstopCW.Enabled = false;
            }
            catch
            {
                MessageBox.Show("stopping failed");
            }
        }

        private void btnPRBSOn_Click(object sender, EventArgs e)
        {
            if (this.btnsetopant.Enabled)
            {
                MessageBox.Show("please input antenna id");
                return;
            }
            if (this.tbdur.Text.Trim() == string.Empty)
            {
                MessageBox.Show("please input duration");
                return;
            }
            int dur = int.Parse(this.tbdur.Text.Trim());
            if (dur > 65535)
            {
                MessageBox.Show("the duration must be in the range of 0-65536");
                return;
            }
            ushort usdur = (ushort)dur;
            int aa = Environment.TickCount;
            try
            {
                this.btnPRBSOn.Enabled = false;
                modrdr.ParamSet("turnPRBSOn", usdur);
            }
            catch (Exception exx)
            {
                MessageBox.Show("transmitting failed"+exx.ToString());
            }
 //           int bb = (dur - (Environment.TickCount - aa));
 //           if (bb > 0)
  //              Thread.Sleep(bb+1500);
            this.btnPRBSOn.Enabled = true;
        }

        private void regulatoryFrm_Load(object sender, EventArgs e)
        {
            this.btnstopCW.Enabled = false;
            this.btntransCW.Enabled = true;
            
        }

        private void btnsetopant_Click(object sender, EventArgs e)
        {
            if (this.tbopant.Text.Trim() == string.Empty)
            {
                MessageBox.Show("please input antenna id");
                return;
            }
            int ant = int.Parse(this.tbopant.Text);
            modrdr.ParamSet("setRegulatoryOpAnt", ant);
            this.tbopant.Enabled = false;
            this.btnsetopant.Enabled = false;
        }


    }
}
