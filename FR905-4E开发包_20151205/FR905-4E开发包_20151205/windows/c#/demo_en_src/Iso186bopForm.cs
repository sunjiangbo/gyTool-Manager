using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Diagnostics;
using ModuleTech;
using ModuleTech.ISO180006b;
using ModuleLibrary;

namespace ModuleReaderManager
{
    public partial class Iso186bopForm : Form
    {
        public Iso186bopForm(Reader rdr_, ReaderParams rparam_)
        {
            InitializeComponent();
            Modrdr = rdr_;
            rparam = rparam_;
        }
        Reader Modrdr = null;
        ReaderParams rparam = null;

        private void btnInvStart_Click(object sender, EventArgs e)
        {
            List<int> selants = new List<int>();
            bool isalert = false;
            foreach (int antindex in allants.Keys)
            {
                if (allants[antindex].Enabled)
                {
                    if (allants[antindex].Checked)
                    {
                        selants.Add(antindex);
                        if (allants[antindex].ForeColor == Color.Red)
                            isalert = true;
                    }
                }
            }

            if (selants.Count == 0)
            {
                MessageBox.Show("please select antenna");
                return;
            }

            if (isalert)
            {
                DialogResult stat = DialogResult.OK;
                stat = MessageBox.Show("execute operation on the port without finding antenna ?", "tip-off",
                                MessageBoxButtons.OKCancel, MessageBoxIcon.Question,
                                MessageBoxDefaultButton.Button2);
                if (stat != DialogResult.OK)
                    return;
            }

            Modrdr.ParamSet("ReadPlan", new SimpleReadPlan(TagProtocol.ISO180006B, selants.ToArray()));

            this.timer1.Enabled = true;
            this.btnRead.Enabled = false;
            this.btnwrite.Enabled = false;
            this.btnlock.Enabled = false;
            this.btnInvStart.Enabled = false;
            this.btnInvStop.Enabled = true;
        }

        private void btnInvStop_Click(object sender, EventArgs e)
        {
            this.timer1.Enabled = false;
            this.btnRead.Enabled = true;
            this.btnwrite.Enabled = true;
            this.btnlock.Enabled = true;
            this.btnInvStop.Enabled = false;
            this.btnInvStart.Enabled = true;
        }

        Dictionary<int, CheckBox> allants = new Dictionary<int, CheckBox>();

        private void Iso186bopForm_Load(object sender, EventArgs e)
        {
            this.timer1.Enabled = false;
            Modrdr.ParamSet("TagopProtocol", TagProtocol.ISO180006B);
            allants.Add(1, cbant1);
            allants.Add(2, cbant2);
            allants.Add(3, cbant3);
            allants.Add(4, cbant4);

            for (int i = 1; i <= allants.Count; ++i)
                allants[i].Enabled = false;

            for (int j = 0; j < rparam.AntsState.Count; ++j)
            {
                allants[rparam.AntsState[j].antid].Enabled = true;
                if (rparam.AntsState[j].isConn)
                    allants[rparam.AntsState[j].antid].ForeColor = Color.Green;
                else
                    allants[rparam.AntsState[j].antid].ForeColor = Color.Red;
            }

        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            TagReadData[] tags = null;
            try
            {
                tags = Modrdr.Read(50);
            }
            catch (Exception ex)
            {
                this.timer1.Enabled = false;
                MessageBox.Show(ex.ToString());
                return;
            }
            this.listBox2.Items.Clear();
            foreach (TagReadData tag in tags)
            {
                this.listBox2.Items.Add(tag.EPCString);
            }
        }

        private void btnRead_Click(object sender, EventArgs e)
        {
            List<int> selants = new List<int>();
            bool isalert = false;
            foreach (int antindex in allants.Keys)
            {
                if (allants[antindex].Enabled)
                {
                    if (allants[antindex].Checked)
                    {
                        selants.Add(antindex);
                        if (allants[antindex].ForeColor == Color.Red)
                            isalert = true;
                    }
                }
            }

            if (selants.Count != 1)
            {
                MessageBox.Show("must and only select one antenna");
                return;
            }
            

            if (isalert)
            {
                DialogResult stat = DialogResult.OK;
                stat = MessageBox.Show("execute operation on the port without finding antenna ?", "tip-off",
                                MessageBoxButtons.OKCancel, MessageBoxIcon.Question,
                                MessageBoxDefaultButton.Button2);
                if (stat != DialogResult.OK)
                    return;
            }

            if (listBox2.SelectedIndex == -1)
            {
                MessageBox.Show("please select the id of tag to operate");
                return;
            }

            if (this.tbStartAddr.Text.Trim() == string.Empty)
            {
                MessageBox.Show("please input the starting address");
                return;
            }
            if (this.tbBlkCnt.Text.Trim() == string.Empty)
            {
                MessageBox.Show("please input the block count to read");
                return;
            }

            string sltag = listBox2.SelectedItem.ToString();

            try
            {
                int addrst = int.Parse(this.tbStartAddr.Text.Trim());
                int blkcnt = int.Parse(this.tbBlkCnt.Text.Trim());
                Modrdr.ParamSet("TagopAntenna", selants[0]);
                int t1 = Environment.TickCount;
                byte[] data = Modrdr.ReadTagMemBytes(new ISO180006bTagData(ByteFormat.FromHex(sltag)), MemBank.ISO180006BMEM, addrst, blkcnt);
                Debug.WriteLine((Environment.TickCount - t1).ToString());
                this.rtbdata.Text = ByteFormat.ToHex(data);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
        }

        public static int IsValidHexstr(string str, int len)
        {
            if (str == "")
                return -3;
            if (str.Length % 2 != 0)
                return -2;
            if (str.Length > len)
                return -4;
            string lowstr = str.ToLower();
            byte[] hexchars = Encoding.ASCII.GetBytes(lowstr);

            foreach (byte a in hexchars)
            {
                if (!((a >= 48 && a <= 57) || (a >= 97 && a <= 102)))
                    return -1;
            }
            return 0;
        }

        private void btnwrite_Click(object sender, EventArgs e)
        {
            List<int> selants = new List<int>();
            bool isalert = false;
            foreach (int antindex in allants.Keys)
            {
                if (allants[antindex].Enabled)
                {
                    if (allants[antindex].Checked)
                    {
                        selants.Add(antindex);
                        if (allants[antindex].ForeColor == Color.Red)
                            isalert = true;
                    }
                }
            }
            if (selants.Count != 1)
            {
                MessageBox.Show("must and only select one antenna");
                return;
            }


            if (isalert)
            {
                DialogResult stat = DialogResult.OK;
                stat = MessageBox.Show("execute operation on the port without finding antenna ?", "tip-off",
                                MessageBoxButtons.OKCancel, MessageBoxIcon.Question,
                                MessageBoxDefaultButton.Button2);
                if (stat != DialogResult.OK)
                    return;
            }

            if (listBox2.SelectedIndex == -1)
            {
                MessageBox.Show("please select the id of tag to operate");
                return;
            }
            string sltag = listBox2.SelectedItem.ToString();


            if (IsValidHexstr(this.rtbdata.Text.Trim(), 432) != 0)
            {
                MessageBox.Show("data for writing must be hexadecimal numbers and the length of data must be multiple of 2 and no less than 432");
                return;
            }

            if (this.tbStartAddr.Text.Trim() == string.Empty)
            {
                MessageBox.Show("please input the starting address");
                return;
            }

            int bytecnt = this.rtbdata.Text.Trim().Length / 2;

            try
            {
                Modrdr.ParamSet("TagopAntenna", selants[0]);
                int addrst = int.Parse(this.tbStartAddr.Text.Trim());
                int st = Environment.TickCount;
                byte[] wdata = ByteFormat.FromHex(this.rtbdata.Text.Trim());
                Modrdr.ParamSet("OpTimeout", (ushort)6500);
                Modrdr.WriteTagMemBytes(new ISO180006bTagData(ByteFormat.FromHex(sltag)), MemBank.ISO180006BMEM, addrst, wdata);
                this.label3.Text = (Environment.TickCount - st).ToString();
                this.rtbdata.Text = "writing success";
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
            finally
            {
                Modrdr.ParamSet("OpTimeout", (ushort)1000);
            }
            
        }

        private void btnlock_Click(object sender, EventArgs e)
        {
            List<int> selants = new List<int>();
            bool isalert = false;
            foreach (int antindex in allants.Keys)
            {
                if (allants[antindex].Enabled)
                {
                    if (allants[antindex].Checked)
                    {
                        selants.Add(antindex);
                        if (allants[antindex].ForeColor == Color.Red)
                            isalert = true;
                    }
                }
            }
            if (selants.Count != 1)
            {
                MessageBox.Show("must and only select one antenna");
                return;
            }


            if (isalert)
            {
                DialogResult stat = DialogResult.OK;
                stat = MessageBox.Show("execute operation on the port without finding antenna ?", "tip-off",
                                MessageBoxButtons.OKCancel, MessageBoxIcon.Question,
                                MessageBoxDefaultButton.Button2);
                if (stat != DialogResult.OK)
                    return;
            }

            if (listBox2.SelectedIndex == -1)
            {
                MessageBox.Show("please select the id of tag to operate");
                return;
            }
            string sltag = listBox2.SelectedItem.ToString();

            if (this.tbStartAddr.Text.Trim() == string.Empty)
            {
                MessageBox.Show("please input the starting address");
                return;
            }
            try
            {
                int addrst = int.Parse(this.tbStartAddr.Text.Trim());
                Modrdr.ParamSet("TagopAntenna", selants[0]);
                Modrdr.LockTag(new ISO180006bTagData(ByteFormat.FromHex(sltag)), new ISO180006bLockAction(addrst));
                this.rtbdata.Text = "lock success";
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }


        }

        private void btnclear_Click(object sender, EventArgs e)
        {
            this.listBox2.Items.Clear();
        }

        private void Iso186bopForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            this.timer1.Enabled = false;
        }

    }
}
