using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using ModuleTech.Gen2;
using ModuleTech;

namespace ModuleReaderManager
{
    public partial class InventoryParasform : Form
    {
        Form1 frm1 = null;
        public InventoryParasform(Form1 frm)
        {
            frm1 = frm;
            InitializeComponent();
        }



        private void button1_Click(object sender, EventArgs e)
        {
            int rdur = 0;
            int sdur = 0;

            frm1.rParms.isUniByEmd = this.cbisunibynullemd.Checked;
            frm1.rParms.isChangeColor = this.cbischgcolor.Checked;
            frm1.rParms.isUniByAnt = this.cbisunibyant.Checked;
            try
            {
                rdur = int.Parse(this.tbreaddur.Text.Trim());
                sdur = int.Parse(this.tbsleepdur.Text.Trim());

            }
            catch (Exception ex)
            {
                MessageBox.Show("Inventory duration and interval must be numbers in millisecond");
                return;
            }

            frm1.rParms.readdur = rdur;
            frm1.rParms.sleepdur = sdur;
            frm1.rParms.isRevertAnts = this.cbisrevertants.Checked;
            if (this.cbisOneReadOneTime.Checked)
                frm1.rParms.isOneReadOneTime = true;
            else
                frm1.rParms.isOneReadOneTime = false;

            if (this.cbisReadFixCount.Checked)
            {
                if (this.tbReadCount.Text.Trim() == string.Empty)
                {
                    MessageBox.Show("please input inventory count");
                    return;
                }
                try
                {
                    frm1.rParms.FixReadCount = int.Parse(this.tbReadCount.Text.Trim());
                }
                catch (System.Exception ere)
                {
                    MessageBox.Show(ere.ToString());
                    return;
                }
                if (frm1.rParms.FixReadCount <= 0)
                {
                    MessageBox.Show("inventory count must be more than zero");
                    return;
                }
                frm1.rParms.isReadFixCount = true;  
            }
            else
            {
                frm1.rParms.isReadFixCount = false;
                frm1.rParms.FixReadCount = 0;
            }

            if (this.cbisfilter.Checked)
            {

                int ret = Form1.IsValidBinaryStr(this.tbfilterdata.Text.Trim());
                switch (ret)
                {
                    case -3:
                        MessageBox.Show("please input data for match");
                        break;
                    case -1:
                        MessageBox.Show("match data must be binary string");
                        break;

                }

                if (ret != 0)
                    return;
                if (this.cbbfilterbank.SelectedIndex == -1)
                {
                    MessageBox.Show("please select filter bank");
                    return;
                }

                if (this.cbbfilterrule.SelectedIndex == -1)
                {
                    MessageBox.Show("please select filter rule");
                    return;
                }

                int bitaddr = 0;
                if (this.tbfilteraddr.Text.Trim() == "")
                {
                    MessageBox.Show("please input starting address in bit");
                    return;
                }
                else
                {
                    try
                    {
                        bitaddr = int.Parse(this.tbfilteraddr.Text.Trim());
                    }
                    catch (Exception exc)
                    {
                        MessageBox.Show("starting address must be number");
                        return;
                    }
                    if (bitaddr < 0)
                    {
                        MessageBox.Show("starting address must be more than zero");
                        return;
                    }
                }

                byte[] filterbytes = new byte[(this.tbfilterdata.Text.Trim().Length - 1) / 8 + 1];
                for (int c = 0; c < filterbytes.Length; ++c)
                    filterbytes[c] = 0;

                int bitcnt = 0;
                foreach (Char ch in this.tbfilterdata.Text.Trim())
                {
                    if (ch == '1')
                        filterbytes[bitcnt / 8] |= (byte)(0x01 << (7 - bitcnt % 8));
                    bitcnt++;

                }

                Gen2TagFilter filter = new Gen2TagFilter(this.tbfilterdata.Text.Trim().Length, filterbytes,
                    (MemBank)this.cbbfilterbank.SelectedIndex + 1, bitaddr,
                    this.cbbfilterrule.SelectedIndex == 0 ? false : true);
                frm1.modulerdr.ParamSet("Singulation", filter);
            }
            else
                frm1.modulerdr.ParamSet("Singulation", null);


            if (!(frm1.rParms.readertype == ReaderType.PR_ONEANT || frm1.modulerdr.HwDetails.module == Reader.Module_Type.MODOULE_R902_MT100))
            {

                if (this.cbisaddiondata.Checked)
                {
                    int wordaddr = 0;
                    int ebbytescnt;

                    if (this.tbebstartaddr.Text.Trim() == "")
                    {
                        MessageBox.Show("please input starting address of embedded data bank in word");
                        return;
                    }
                    else
                    {
                        try
                        {
                            wordaddr = int.Parse(this.tbebstartaddr.Text.Trim());
                        }
                        catch (Exception exc)
                        {
                            MessageBox.Show("starting address must be number");
                            return;
                        }
                        if (wordaddr < 0)
                        {
                            MessageBox.Show("starting address must be more than zero");
                            return;
                        }
                    }

                    if (this.tbebbytescnt.Text.Trim() == "")
                    {
                        MessageBox.Show("please input starting address of embedded data bank in word");
                        return;
                    }
                    else
                    {
                        try
                        {
                            ebbytescnt = int.Parse(this.tbebbytescnt.Text.Trim());
                        }
                        catch (Exception exc)
                        {
                            MessageBox.Show("the byte count to read of embedded data must be number");
                            return;
                        }
                        if (ebbytescnt < 0 || ebbytescnt > 32)
                        {
                            MessageBox.Show("the byte count to read of embedded data must be in the range of 0-33");
                            return;
                        }
                    }


                    if (this.cbbebbank.SelectedIndex == -1)
                    {
                        MessageBox.Show("please select bank of embedded data");
                        return;
                    }

                    EmbededCmdData ecd = new EmbededCmdData((MemBank)this.cbbebbank.SelectedIndex, (UInt32)wordaddr,
                        (byte)ebbytescnt);

                    frm1.modulerdr.ParamSet("EmbededCmdOfInventory", ecd);
                }
                else
                    frm1.modulerdr.ParamSet("EmbededCmdOfInventory", null);


                if (this.cbispwd.Checked)
                {
                    int ret = Form1.IsValidPasswd(this.tbacspwd.Text.Trim());
                    {
                        switch (ret)
                        {
                            case -3:
                                MessageBox.Show("please input access password");
                                break;
                            case -2:
                            case -4:
                                MessageBox.Show("access password must be 8 of hexadecimal numbers");
                                break;
                            case -1:
                                MessageBox.Show("access password must be 8 of hexadecimal numbers");
                                break;

                        }
                    }
                    if (ret != 0)
                        return;
                    else
                    {
                        uint passwd = uint.Parse(this.tbacspwd.Text.Trim(), System.Globalization.NumberStyles.AllowHexSpecifier);
                        frm1.modulerdr.ParamSet("AccessPassword", passwd);
                    }
                }
                else
                    frm1.modulerdr.ParamSet("AccessPassword", (uint)0);

            }

            this.Close();
        }

        private void InventoryParasform_Load(object sender, EventArgs e)
        {
            this.cbischgcolor.Checked = frm1.rParms.isChangeColor;
            this.cbisunibynullemd.Checked = frm1.rParms.isUniByEmd;
            this.cbisunibyant.Checked = frm1.rParms.isUniByAnt;

            object obj = null;
          

            if (!(frm1.rParms.readertype == ReaderType.PR_ONEANT 
                  || frm1.rParms.readertype == ReaderType.MT_A7_16ANTS))
            {

                obj = frm1.modulerdr.ParamGet("EmbededCmdOfInventory");
                if (obj != null)
                {
                    EmbededCmdData ecd = (EmbededCmdData)obj;
                    this.tbebstartaddr.Text = ecd.StartAddr.ToString();
                    this.tbebbytescnt.Text = ecd.ByteCnt.ToString();
                    this.cbbebbank.SelectedIndex = (int)ecd.Bank;
                    this.cbisaddiondata.Checked = true;
                }
                uint pwd = (uint)frm1.modulerdr.ParamGet("AccessPassword");
                if (pwd != 0)
                {
                    this.cbispwd.Checked = true;
                    this.tbacspwd.Text = pwd.ToString("X8");
                }
            }
            else
                this.gbemddata.Enabled = false;

            obj = frm1.modulerdr.ParamGet("Singulation");
            if (obj != null)
            {
                Gen2TagFilter filter = (Gen2TagFilter)obj;
                this.cbbfilterbank.SelectedIndex = (int)filter.FilterBank -1;
                this.tbfilteraddr.Text = filter.FilterAddress.ToString();
                string binarystr = "";
                foreach (byte bt in filter.FilterData)
                {
                    string tmp = Convert.ToString(bt, 2);
                    if (tmp.Length != 8)
                    {
                        for (int c = 0; c < 8-tmp.Length; ++c)
                            binarystr += "0";
                    }
                    binarystr += tmp;
                }
                this.tbfilterdata.Text = binarystr.Substring(0, filter.FilterLength);

                if (filter.IsInvert)
                    this.cbbfilterrule.SelectedIndex = 1;
                else
                    this.cbbfilterrule.SelectedIndex = 0;

                this.cbisfilter.Checked = true;
            }
            this.tbreaddur.Text = frm1.rParms.readdur.ToString();
            this.tbsleepdur.Text = frm1.rParms.sleepdur.ToString();
            if (frm1.rParms.isReadFixCount)
            {
                this.cbisReadFixCount.Checked = true;
                this.tbReadCount.Text = frm1.rParms.FixReadCount.ToString();
            }
            else
            {
                this.cbisReadFixCount.Checked = false;
                this.tbReadCount.Enabled = false;
            }
            if (frm1.rParms.isOneReadOneTime)
                this.cbisOneReadOneTime.Checked = true;
            else
                this.cbisOneReadOneTime.Checked = false;

        }

        private void cbisReadFixCount_CheckedChanged(object sender, EventArgs e)
        {
            if (this.cbisReadFixCount.Checked)
                this.tbReadCount.Enabled = true;
            else
                this.tbReadCount.Enabled = false;
        }

    }
}