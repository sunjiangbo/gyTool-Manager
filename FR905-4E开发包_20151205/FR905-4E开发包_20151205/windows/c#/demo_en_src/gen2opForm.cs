using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using ModuleTech;
using ModuleTech.Gen2;
using ModuleLibrary;
using System.Diagnostics;
using System.Threading;

namespace ModuleReaderManager
{
    public partial class gen2opForm : Form
    {
        public gen2opForm(Reader rdr, ReaderParams param)
        {
            InitializeComponent();
            mordr = rdr;
            rparam = param;
        }
        ReaderParams rparam = null;
        Reader mordr = null;

        public static int IsValidHexstr(string str, int len)
        {
            if (str == "")
                return -3;
            if (str.Length % 4 != 0)
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

        private bool IsValidAddr(string addr, int bank, int rorw)
        {
            if (addr == "")
                return false;

            int addr_;
            try
            {
                addr_ = int.Parse(addr);
            }
            catch (Exception exxx)
            {
                return false;
            }

            switch (bank)
            {
                case 0:
                    {
                        if (addr_ >= 0 && addr_ <= 3)
                            return true;
                        break;
                    }
                case 1:
                    {
                        if (rorw == 2)
                        {
                            if (addr_ >= 2 && addr_ <= 7)
                                return true;
                        }
                        else if (rorw == 1)
                        {
                            if (addr_ >= 0 && addr_ <= 7)
                                return true;
                        }
                        break;
                    }
                case 2:
                    {
                        if (addr_ >= 0)
                            return true;
                        break;
                    }
                case 3:
                    {
                        if (addr_ >= 0 && addr_ <= 8000)
                            return true;
                        break;
                    }

            }
            
            return false;
        }

        private bool IsValidCnt(string cnt, int bank, string addr)
        {
            if (cnt == "")
                return false;

            int addr_;
            int cnt_;
            try
            {
                addr_ = int.Parse(addr);
                cnt_ = int.Parse(cnt);
            }
            catch (Exception exx)
            {
                return false;
            }

            int sum = addr_ + cnt_;
            switch (bank)
            {
                case 0:
                    {
                        if (sum <= 4)
                            return true;
                        break;
                    }
                case 1:
                    {
                        if (sum <= 33)
                            return true;
                        break;
                    }
                case 2:
                    {
                        if (sum <= 16)
                            return true;
                        break;
                    }
                case 3:
                    {
                        if (sum <= 8000)
                            return true;
                        break;
                    }
            }
            return false;
        }


        private int IsAntSet()
        {
            int ret = -1;
            if (rparam.readertype != ReaderType.MT_A7_16ANTS)
            {
                for (int i = 1; i <= allants.Count; ++i)
                {
                    if (allants[i].Checked)
                    {
                        mordr.ParamSet("TagopAntenna", i);
                        if (allants[i].ForeColor == Color.Red)
                            ret = 1;
                        else
                            ret = 0;
                    }
                }
            }
            else
            {
                if (this.tb16antssel.Text.Trim() == string.Empty)
                {
                    MessageBox.Show("please input antenna id : 1-16");
                    return -1;
                }
                
                int ant = int.Parse(this.tb16antssel.Text.Trim());
                if (ant < 1 || ant > 16)
                {
                    MessageBox.Show("please input antenna id : 1-16");
                    return -1;
                }

                bool isdet = false;
                for (int i = 0; i < rparam.SixteenDevConAnts.Length; ++i)
                {
                    if (ant == rparam.SixteenDevConAnts[i])
                    {
                        isdet = true;
                        break;
                    }
                }
                if (isdet)
                    ret = 0;
                else
                    ret = 1;
                mordr.ParamSet("TagopAntenna", ant);
            }

            return ret;
        }

        private void btnread_Click(object sender, EventArgs e)
        {
            int ret;
            Gen2TagFilter filter = null;

            if (this.cbbopbank.SelectedIndex == -1)
            {
                MessageBox.Show("please select bank for operation");
                return;
            }

            if (!IsValidAddr(this.tbstartaddr.Text.Trim(), this.cbbopbank.SelectedIndex, 1))
            {
                MessageBox.Show("starting address is invalid");
                return;
            }

            if (!IsValidCnt(this.tbblocks.Text.Trim(), this.cbbopbank.SelectedIndex, this.tbstartaddr.Text))
            {
                MessageBox.Show("blocks value is invalid");
                return;
            }

            if (this.cbisaccesspasswd.Checked)
            {
                ret = Form1.IsValidPasswd(this.tbaccesspasswd.Text.Trim());
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
                    uint passwd = uint.Parse(this.tbaccesspasswd.Text.Trim(), System.Globalization.NumberStyles.AllowHexSpecifier);
                    mordr.ParamSet("AccessPassword", passwd);
                }
            }
            else
                mordr.ParamSet("AccessPassword", (uint)0);

            ushort[] readdata = null;

            ret = IsAntSet();
            if (ret == -1)
            {
                MessageBox.Show("please select antenna");
                return;
            }
            else if (ret == 1)
            {
                    DialogResult stat = DialogResult.OK;
                    stat = MessageBox.Show("execute operation on the port without finding antenna ?", "tip-off",
                                    MessageBoxButtons.OKCancel, MessageBoxIcon.Question,
                                    MessageBoxDefaultButton.Button2);
                    if (stat != DialogResult.OK)
                        return;
                
            }

            if (this.cbisfilter.Checked)
            {

                ret = Form1.IsValidBinaryStr(this.tbfldata.Text.Trim());
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
                    MessageBox.Show("please select bank for filter");
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
                        MessageBox.Show("starting address must be numbers");
                        return;
                    }
                    if (bitaddr < 0)
                    {
                        MessageBox.Show("starting address must be more than zero");
                        return;
                    }
                }

                byte[] filterbytes = new byte[(this.tbfldata.Text.Trim().Length - 1) / 8 + 1];
                for (int c = 0; c < filterbytes.Length; ++c)
                    filterbytes[c] = 0;

                int bitcnt = 0;
                foreach (Char ch in this.tbfldata.Text.Trim())
                {
                    if (ch == '1')
                        filterbytes[bitcnt / 8] |= (byte)(0x01 << (7 - bitcnt % 8));
                    bitcnt++;

                }

                filter = new Gen2TagFilter(this.tbfldata.Text.Trim().Length, filterbytes,
                    (MemBank)this.cbbfilterbank.SelectedIndex + 1, bitaddr,
                    this.cbbfilterrule.SelectedIndex == 0 ? false : true);
            }
     

            try
            {
                int st = Environment.TickCount;
                readdata = mordr.ReadTagMemWords(filter,
                    (MemBank)this.cbbopbank.SelectedIndex, int.Parse(this.tbstartaddr.Text.Trim())
                    , int.Parse(this.tbblocks.Text.Trim()));
                Debug.WriteLine("read dur :" + (Environment.TickCount - st).ToString());
                if (rparam.setGPO1)
                {
                    mordr.GPOSet(1, true);
                    System.Threading.Thread.Sleep(20);
                    mordr.GPOSet(1, false);
                }

            }
            catch (OpFaidedException notagexp)
            {
                if (notagexp.ErrCode == 0x400)
                    MessageBox.Show("no tag");
                else
                    MessageBox.Show("operation failed:" + notagexp.ToString());

                return;
            }
            catch (Exception ex)
            {
                MessageBox.Show("operation failed:" + ex.ToString());
                return;
            }

            string readdatastr = "";
            for (int i = 0; i < readdata.Length; ++i)
                readdatastr += readdata[i].ToString("X4");

            this.rtbdata.Text = readdatastr;
        }

        private void btnwrite_Click(object sender, EventArgs e)
        {
            int ret;
            Gen2TagFilter filter = null;

            if (this.cbbopbank.SelectedIndex == -1)
            {
                MessageBox.Show("please select bank for operation");
                return;
            }
            if (!IsValidAddr(this.tbstartaddr.Text.Trim(), this.cbbopbank.SelectedIndex, 2))
            {
                MessageBox.Show("starting address is invalid");
                return;
            }

            if (IsValidHexstr(this.rtbdata.Text.Trim(), 16384) != 0)
            {
                MessageBox.Show("data for writing must be hexadecimal numbers and the length of data must be multiple of 4 ");
                return;
            }

            int cnt = this.rtbdata.Text.Length / 4;

            if (!IsValidCnt(cnt.ToString(), this.cbbopbank.SelectedIndex, this.tbstartaddr.Text.Trim()))
            {
                MessageBox.Show("data for writing is more than the capacity of bank to write");
                return;
            }



            if (this.cbisaccesspasswd.Checked)
            {
                ret = Form1.IsValidPasswd(this.tbaccesspasswd.Text.Trim());
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
                    uint passwd = uint.Parse(this.tbaccesspasswd.Text.Trim(), System.Globalization.NumberStyles.AllowHexSpecifier);
                    mordr.ParamSet("AccessPassword", passwd);
                }
            }
            else
                mordr.ParamSet("AccessPassword", (uint)0);

            ret = IsAntSet();
            if (ret == -1)
            {
                MessageBox.Show("please select antenna for operation");
                return;
            }
            else if (ret == 1)
            {
                DialogResult stat = DialogResult.OK;
                stat = MessageBox.Show("execute operation on the port without finding antenna ?", "tip-off",
                                MessageBoxButtons.OKCancel, MessageBoxIcon.Question,
                                MessageBoxDefaultButton.Button2);
                if (stat != DialogResult.OK)
                    return;

            }

            ushort[] writedata = new ushort[this.rtbdata.Text.Trim().Length / 4];

            for (int a = 0; a < writedata.Length; ++a)
                writedata[a] = ushort.Parse(this.rtbdata.Text.Trim().Substring(a * 4, 4), System.Globalization.NumberStyles.AllowHexSpecifier);



            if (this.cbisfilter.Checked)
            {

                ret = Form1.IsValidBinaryStr(this.tbfldata.Text.Trim());
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
                    MessageBox.Show("please select bank for filter");
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
                        MessageBox.Show("starting address must be numbers");
                        return;
                    }
                    if (bitaddr < 0)
                    {
                        MessageBox.Show("starting address must be more than zero");
                        return;
                    }
                }

                byte[] filterbytes = new byte[(this.tbfldata.Text.Trim().Length - 1) / 8 + 1];
                for (int c = 0; c < filterbytes.Length; ++c)
                    filterbytes[c] = 0;

                int bitcnt = 0;
                foreach (Char ch in this.tbfldata.Text.Trim())
                {
                    if (ch == '1')
                        filterbytes[bitcnt / 8] |= (byte)(0x01 << (7 - bitcnt % 8));
                    bitcnt++;

                }

                filter = new Gen2TagFilter(this.tbfldata.Text.Trim().Length, filterbytes,
                    (MemBank)this.cbbfilterbank.SelectedIndex + 1, bitaddr,
                    this.cbbfilterrule.SelectedIndex == 0 ? false : true);
            }
            
            try
            {
                int st = System.Environment.TickCount;
                mordr.WriteTagMemWords(filter,
                    (MemBank)this.cbbopbank.SelectedIndex, int.Parse(this.tbstartaddr.Text.Trim())
                    , writedata);
                Console.WriteLine("write tag dur:" + (System.Environment.TickCount - st).ToString());
            }
            catch (OpFaidedException notagexp)
            {
                if (notagexp.ErrCode == 0x400)
                    MessageBox.Show("no tag");
                else
                    MessageBox.Show("operation failed:" + notagexp.ToString());

                return;
            }

            catch (Exception ex)
            {
                MessageBox.Show("operation failed:" + ex.ToString());
                return;
            }

            this.rtbdata.Text = "writing success";
            if (rparam.setGPO1)
            {
                mordr.GPOSet(1, true);
                System.Threading.Thread.Sleep(20);
                mordr.GPOSet(1, false);
            }

        }

        private void btnlock_Click(object sender, EventArgs e)
        {
            int ret;
            ret = IsAntSet();
            if (ret == -1)
            {
                MessageBox.Show("please select antenna for operation");
                return;
            }
            else if (ret == 1)
            {
                DialogResult stat = DialogResult.OK;
                stat = MessageBox.Show("execute operation on the port without finding antenna ?", "tip-off",
                                MessageBoxButtons.OKCancel, MessageBoxIcon.Question,
                                MessageBoxDefaultButton.Button2);
                if (stat != DialogResult.OK)
                    return;

            }

            if (this.cbblocktype.SelectedIndex == -1)
            {
                MessageBox.Show("please select lock type");
                return;
            }
            if (this.cbblockunit.SelectedIndex == -1)
            {
                MessageBox.Show("please select lock region");
                return;
            }

            
            ret = Form1.IsValidPasswd(this.tbaccesspasswd.Text.Trim());
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
                uint passwd = uint.Parse(this.tbaccesspasswd.Text.Trim(), System.Globalization.NumberStyles.AllowHexSpecifier);
                mordr.ParamSet("AccessPassword", passwd);
            }

            Gen2TagFilter filter = null;

            if (this.cbisfilter.Checked)
            {

                ret = Form1.IsValidBinaryStr(this.tbfldata.Text.Trim());
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
                    MessageBox.Show("please select bank for filter");
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
                        MessageBox.Show("starting address must be numbers");
                        return;
                    }
                    if (bitaddr < 0)
                    {
                        MessageBox.Show("starting address must be more than zero");
                        return;
                    }
                }

                byte[] filterbytes = new byte[(this.tbfldata.Text.Trim().Length - 1) / 8 + 1];
                for (int c = 0; c < filterbytes.Length; ++c)
                    filterbytes[c] = 0;

                int bitcnt = 0;
                foreach (Char ch in this.tbfldata.Text.Trim())
                {
                    if (ch == '1')
                        filterbytes[bitcnt / 8] |= (byte)(0x01 << (7 - bitcnt % 8));
                    bitcnt++;

                }

                filter = new Gen2TagFilter(this.tbfldata.Text.Trim().Length, filterbytes,
                    (MemBank)this.cbbfilterbank.SelectedIndex + 1, bitaddr,
                    this.cbbfilterrule.SelectedIndex == 0 ? false : true);
            }
            Gen2LockAct[] act = new Gen2LockAct[1];
  //          Gen2LockAct[] act2 = new Gen2LockAct[2];
            switch (this.cbblockunit.SelectedIndex)
            {
                case 0:
                   {
                       if (this.cbblocktype.SelectedIndex == 0)
                           act[0] = Gen2LockAct.ACCESS_UNLOCK;
                       else if (this.cbblocktype.SelectedIndex == 1)
                           act[0] = Gen2LockAct.ACCESS_LOCK;
                       else if (this.cbblocktype.SelectedIndex == 2)
                           act[0] = Gen2LockAct.ACCESS_PERMALOCK;
                       break;
                   }
                case 1:
                   {
                       if (this.cbblocktype.SelectedIndex == 0)
                           act[0] = Gen2LockAct.KILL_UNLOCK;
                       else if (this.cbblocktype.SelectedIndex == 1)
                           act[0] = Gen2LockAct.KILL_LOCK;
                       else if (this.cbblocktype.SelectedIndex == 2)
                           act[0] = Gen2LockAct.KILL_PERMALOCK;
                       break;
                   }
                case 2:
                   {
                       if (this.cbblocktype.SelectedIndex == 0)
                           act[0] = Gen2LockAct.EPC_UNLOCK;
                       else if (this.cbblocktype.SelectedIndex == 1)
                           act[0] = Gen2LockAct.EPC_LOCK;
                       else if (this.cbblocktype.SelectedIndex == 2)
                           act[0] = Gen2LockAct.EPC_PERMALOCK;
                       break;
                   }
                case 3:
                   {
                       if (this.cbblocktype.SelectedIndex == 0)
                           act[0] = Gen2LockAct.TID_UNLOCK;
                       else if (this.cbblocktype.SelectedIndex == 1)
                           act[0] = Gen2LockAct.TID_LOCK;
                       else if (this.cbblocktype.SelectedIndex == 2)
                           act[0] = Gen2LockAct.TID_PERMALOCK;
                       break;
                   }
                case 4:
                   {
                       if (this.cbblocktype.SelectedIndex == 0)
                           act[0] = Gen2LockAct.USER_UNLOCK;
                       else if (this.cbblocktype.SelectedIndex == 1)
                           act[0] = Gen2LockAct.USER_LOCK;
                       else if (this.cbblocktype.SelectedIndex == 2)
                           act[0] = Gen2LockAct.USER_PERMALOCK;
                       break;
                   }
            }

            try
            {
                mordr.LockTag(filter, new Gen2LockAction(act));
            }
            catch (OpFaidedException notagexp)
            {
                if (notagexp.ErrCode == 0x400)
                    MessageBox.Show("no tag");
                else
                    MessageBox.Show("operation failed:" + notagexp.ToString());

                return;
            }
            catch (Exception ex)
            {
                MessageBox.Show("operation failed:" + ex.ToString());
                return;
            }

            this.rtbdata.Text = "lock success";
            if (rparam.setGPO1)
            {
                mordr.GPOSet(1, true);
                System.Threading.Thread.Sleep(20);
                mordr.GPOSet(1, false);
            }
        }

        private void btnkill_Click(object sender, EventArgs e)
        {
            int ret;
            uint killpasswd;
            ret = Form1.IsValidPasswd(this.tbkillpasswd.Text.Trim());
            {
                switch (ret)
                {
                    case -3:
                        MessageBox.Show("please input kill password");
                        break;
                    case -2:
                    case -4:
                        MessageBox.Show("kill password must be 8 of hexadecimal numbers");
                        break;
                    case -1:
                        MessageBox.Show("kill password must be 8 of hexadecimal numbers");
                        break;

                }
            }
            if (ret != 0)
                return;
            else
                killpasswd = uint.Parse(this.tbkillpasswd.Text.Trim(), System.Globalization.NumberStyles.AllowHexSpecifier);


            Gen2TagFilter filter = null;

            if (this.cbisfilter.Checked)
            {

                ret = Form1.IsValidBinaryStr(this.tbfldata.Text.Trim());
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
                    MessageBox.Show("please select bank for filter");
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
                        MessageBox.Show("starting address must be numbers");
                        return;
                    }
                    if (bitaddr < 0)
                    {
                        MessageBox.Show("starting address must be more than zero");
                        return;
                    }
                }

                byte[] filterbytes = new byte[(this.tbfldata.Text.Trim().Length - 1) / 8 + 1];
                for (int c = 0; c < filterbytes.Length; ++c)
                    filterbytes[c] = 0;

                int bitcnt = 0;
                foreach (Char ch in this.tbfldata.Text.Trim())
                {
                    if (ch == '1')
                        filterbytes[bitcnt / 8] |= (byte)(0x01 << (7 - bitcnt % 8));
                    bitcnt++;

                }

                filter = new Gen2TagFilter(this.tbfldata.Text.Trim().Length, filterbytes,
                    (MemBank)this.cbbfilterbank.SelectedIndex + 1, bitaddr,
                    this.cbbfilterrule.SelectedIndex == 0 ? false : true);
            }
            try
            {
                mordr.KillTag(filter, killpasswd);
            }
            catch (OpFaidedException notagexp)
            {
                if (notagexp.ErrCode == 0x400)
                    MessageBox.Show("no tag");
                else
                    MessageBox.Show("operation failed:" + notagexp.ToString());

                return;
            }
            catch (Exception ex)
            {
                MessageBox.Show("operation failed:" + ex.ToString());
            }

            this.rtbdata.Text = "kill success";
            if (rparam.setGPO1)
            {
                mordr.GPOSet(1, true);
                System.Threading.Thread.Sleep(20);
                mordr.GPOSet(1, false);
            }
        }

        Dictionary<int, RadioButton> allants = new Dictionary<int, RadioButton>();

        private void opForm_Load(object sender, EventArgs e)
        {
            allants.Add(1, rbant1);
            allants.Add(2, rbant2);
            allants.Add(3, rbant3);
            allants.Add(4, rbant4);

            for (int i = 1; i <= allants.Count; ++i)
                allants[i].Enabled = false;

            if (rparam.readertype != ReaderType.MT_A7_16ANTS)
            {
                for (int j = 0; j < rparam.AntsState.Count; ++j)
                {
                    allants[rparam.AntsState[j].antid].Enabled = true;
                    if (rparam.AntsState[j].isConn)
                        allants[rparam.AntsState[j].antid].ForeColor = Color.Green;
                    else
                        allants[rparam.AntsState[j].antid].ForeColor = Color.Red;
                }

                if (rparam.readertype == ReaderType.PR_ONEANT)
                {
                    this.tbfilteraddr.Enabled = false;
                    this.tbfldata.Enabled = false;
                    this.cbbfilterbank.Enabled = false;
                    this.cbbfilterrule.Enabled = false;
                    this.cbisfilter.Enabled = false;
                }
                this.tb16antssel.Enabled = false;
            }
   
            mordr.ParamSet("TagopProtocol", TagProtocol.GEN2);

            this.btnConwirte.Enabled = true;
            this.btnconread.Enabled = true;
            this.btnstop.Enabled = false;
            this.btnstopread.Enabled = false;
        }

        private void btnWriteEpc_Click(object sender, EventArgs e)
        {
            Gen2TagFilter filter = null;
            int ret = 0;
            if (this.cbisfilter.Checked)
            {

                ret = Form1.IsValidBinaryStr(this.tbfldata.Text.Trim());
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
                    MessageBox.Show("please select bank for filter");
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
                        MessageBox.Show("starting address must be numbers");
                        return;
                    }
                    if (bitaddr < 0)
                    {
                        MessageBox.Show("starting address must be more than zero");
                        return;
                    }
                }

                byte[] filterbytes = new byte[(this.tbfldata.Text.Trim().Length - 1) / 8 + 1];
                for (int c = 0; c < filterbytes.Length; ++c)
                    filterbytes[c] = 0;

                int bitcnt = 0;
                foreach (Char ch in this.tbfldata.Text.Trim())
                {
                    if (ch == '1')
                        filterbytes[bitcnt / 8] |= (byte)(0x01 << (7 - bitcnt % 8));
                    bitcnt++;

                }

                filter = new Gen2TagFilter(this.tbfldata.Text.Trim().Length, filterbytes,
                    (MemBank)this.cbbfilterbank.SelectedIndex + 1, bitaddr,
                    this.cbbfilterrule.SelectedIndex == 0 ? false : true);
            }
            if (this.cbisaccesspasswd.Checked)
            {
                ret = Form1.IsValidPasswd(this.tbaccesspasswd.Text.Trim());
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
                    uint passwd = uint.Parse(this.tbaccesspasswd.Text.Trim(), System.Globalization.NumberStyles.AllowHexSpecifier);
                    mordr.ParamSet("AccessPassword", passwd);
                }
            }
            else
                mordr.ParamSet("AccessPassword", (uint)0);

            if (IsValidHexstr(this.rtbdata.Text.Trim(), 600) != 0)
            {
                MessageBox.Show("data for writing must be hexadecimal numbers and the length of data must be multiple of 4 ");
                return;
            }

            ret = IsAntSet();
            if (ret == -1)
            {
                MessageBox.Show("please select antenna for operation");
                return;
            }
            else if (ret == 1)
            {
                DialogResult stat = DialogResult.OK;
                stat = MessageBox.Show("execute operation on the port without finding antenna ?", "tip-off",
                                MessageBoxButtons.OKCancel, MessageBoxIcon.Question,
                                MessageBoxDefaultButton.Button2);
                if (stat != DialogResult.OK)
                    return;

            }

            try
            {
                mordr.WriteTag(filter, new TagData(this.rtbdata.Text.Trim()));
                this.rtbdata.Text = "writing epc success";
            }
            catch (Exception ex)
            {
                MessageBox.Show("operation failed：" + ex.ToString());
                return;
            }
        }

        delegate void UpdateConWriteHandler(int cnt, int dur);
        delegate void UpdateConReadHandler(int cnt, int dur, ushort[] data);

        void updateconwirte(int cnt, int dur)
        {
            this.rtbdata.Text = "writing success:" + cnt.ToString() + "--" + dur.ToString();
        }

        void updateconread(int cnt, int dur, ushort[] data)
        {
            this.rtbdata.Text = "reading success：" + cnt.ToString() + "--" + dur.ToString() + "\n";
            string readdatastr = "";
            for (int i = 0; i < data.Length; ++i)
                readdatastr += data[i].ToString("X4");
            this.rtbdata.Text += readdatastr;
        }

        bool isrun = false;
        ushort[] writedata__ = null;
        Thread conwriteth = null;
        Thread conreadth = null;

        MemBank membank__ = MemBank.USER;
        int startconaddr = 0;
        int conreadwordcnt = 0;
        int writecnt = 0;
        int totwtime = 0;
        private void ConReadFunc()
        {
            int st = 0;
            int dur = 0;
            writecnt = 0;
            totwtime = 0;
            ushort[] rdata = null;
    //        Console.WriteLine("startconaddr:" + startconaddr.ToString());
            while (isconreadrun)
            {
                try
                {
                    st = System.Environment.TickCount;
                    rdata = mordr.ReadTagMemWords(null, membank__, startconaddr, conreadwordcnt);
                    dur = System.Environment.TickCount - st;
                    totwtime += dur;
                    writecnt++;
                    this.BeginInvoke(new UpdateConReadHandler(updateconread), writecnt, dur, rdata);
                }
                catch (Exception ex)
                {
                    //    Console.WriteLine("failed write tag dur:" + (System.Environment.TickCount - st).ToString());
                }
            }

        }
        ///
        ushort rand = 5;
        ///
        private void ConWriteFunc()
        {
            int st = 0;
            int dur = 0;
            writecnt = 0;
            totwtime = 0;
    //        Console.WriteLine("startconaddr:" + startconaddr.ToString());
                     ////////////
            writedata__[0] = rand++;
            ////////////
            while (isrun)
            {
                try
                {
                    st = System.Environment.TickCount;
                    mordr.WriteTagMemWords(null,
                        membank__, startconaddr, writedata__);
                    dur = System.Environment.TickCount - st;

                    totwtime += dur;
                    writecnt++;
                    this.BeginInvoke(new UpdateConWriteHandler(updateconwirte), writecnt, dur);

                    //                   Console.WriteLine("success write tag dur:" + dur.ToString());
                }
                catch (Exception ex)
                {
                    //    Console.WriteLine("failed write tag dur:" + (System.Environment.TickCount - st).ToString());
                }
            }
        }

        private void btnConwirte_Click(object sender, EventArgs e)
        {
            int ret;

            if (this.cbbopbank.SelectedIndex == -1)
            {
                MessageBox.Show("please select bank for operation");
                return;
            }
            if (!IsValidAddr(this.tbstartaddr.Text.Trim(), this.cbbopbank.SelectedIndex, 2))
            {
                MessageBox.Show("starting address is invalid");
                return;
            }

            try
            {
                startconaddr = int.Parse(this.tbstartaddr.Text.Trim());
            }
            catch
            {
                MessageBox.Show("please input starting address");
                return;
            }

            if (IsValidHexstr(this.rtbdata.Text.Trim(), 600) != 0)
            {
                MessageBox.Show("data for writing must be hexadecimal numbers and the length of data must be multiple of 4 ");
                return;
            }

            int cnt = this.rtbdata.Text.Length / 4;

            if (!IsValidCnt(cnt.ToString(), this.cbbopbank.SelectedIndex, this.tbstartaddr.Text.Trim()))
            {
                MessageBox.Show("data for writing is more than the capacity of bank to write");
                return;
            }
  
           mordr.ParamSet("AccessPassword", (uint)0);

            ret = IsAntSet();
            if (ret == -1)
            {
                MessageBox.Show("please select antenna for operation");
                return;
            }
            else if (ret == 1)
            {
                DialogResult stat = DialogResult.OK;
                stat = MessageBox.Show("execute operation on the port without finding antenna ?", "tip-off",
                                MessageBoxButtons.OKCancel, MessageBoxIcon.Question,
                                MessageBoxDefaultButton.Button2);
                if (stat != DialogResult.OK)
                    return;

            }

            writedata__ = new ushort[this.rtbdata.Text.Trim().Length / 4];
            for (int a = 0; a < writedata__.Length; ++a)
                writedata__[a] = ushort.Parse(this.rtbdata.Text.Trim().Substring(a * 4, 4), 
                    System.Globalization.NumberStyles.AllowHexSpecifier);
            membank__ = (MemBank)this.cbbopbank.SelectedIndex;
            isrun = true;
            mordr.ParamSet("OpTimeout", (ushort)50);
            this.btnConwirte.Enabled = false;
            this.btnconread.Enabled = false;
            this.btnstop.Enabled = true;
            this.btnstopread.Enabled = false;
            this.labavewtime.Text = "0";
            this.labwritecnt.Text = "0";

            conwriteth = new Thread(ConWriteFunc);
            conwriteth.Start();
        }

        private void btnstop_Click(object sender, EventArgs e)
        {
            isrun = false;
            conwriteth.Join();
            if (writecnt != 0)
                this.labavewtime.Text = ((int)(totwtime / writecnt)).ToString();
            this.labwritecnt.Text = writecnt.ToString();
            this.btnConwirte.Enabled = true;
            this.btnconread.Enabled = true;
            this.btnstop.Enabled = false;
            this.btnstopread.Enabled = false;
        }

        bool isconreadrun = false;
        private void btnconread_Click(object sender, EventArgs e)
        {
            int ret;

            if (this.cbbopbank.SelectedIndex == -1)
            {
                MessageBox.Show("please select bank for operation");
                return;
            }
            if (!IsValidAddr(this.tbstartaddr.Text.Trim(), this.cbbopbank.SelectedIndex, 2))
            {
                MessageBox.Show("starting address is invalid");
                return;
            }

            try
            {
                startconaddr = int.Parse(this.tbstartaddr.Text.Trim());
            }
            catch
            {
                MessageBox.Show("please input starting address");
                return;
            }
            try
            {
                conreadwordcnt = int.Parse(this.tbblocks.Text.Trim());
            }
            catch
            {
                MessageBox.Show("please input blocks for reading");
                return;
            }
            mordr.ParamSet("AccessPassword", (uint)0);

            ret = IsAntSet();
            if (ret == -1)
            {
                MessageBox.Show("please select antenna for operation");
                return;
            }
            else if (ret == 1)
            {
                DialogResult stat = DialogResult.OK;
                stat = MessageBox.Show("execute operation on the port without finding antenna ?", "tip-off",
                                MessageBoxButtons.OKCancel, MessageBoxIcon.Question,
                                MessageBoxDefaultButton.Button2);
                if (stat != DialogResult.OK)
                    return;

            }

            membank__ = (MemBank)this.cbbopbank.SelectedIndex;
            isconreadrun = true;
            mordr.ParamSet("OpTimeout", (ushort)50);
            this.btnConwirte.Enabled = false;
            this.btnconread.Enabled = false;
            this.btnstop.Enabled = false;
            this.btnstopread.Enabled = true;
            this.labavewtime.Text = "0";
            this.labwritecnt.Text = "0";
            conreadth = new Thread(ConReadFunc);
            conreadth.Start();
        }

        private void btnstopread_Click(object sender, EventArgs e)
        {
            isconreadrun = false;
            conreadth.Join();
            if (writecnt != 0)
                this.labavewtime.Text = (((int)(totwtime / writecnt)) - 4).ToString();
            this.labwritecnt.Text = writecnt.ToString();
            this.btnConwirte.Enabled = true;
            this.btnconread.Enabled = true;
            this.btnstop.Enabled = false;
            this.btnstopread.Enabled = false;
        }

        private void btnpermblklock_Click(object sender, EventArgs e)
        {
            int ret;
            Gen2TagFilter filter = null;

            if (this.cbisaccesspasswd.Checked)
            {
                ret = Form1.IsValidPasswd(this.tbaccesspasswd.Text.Trim());
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
                    uint passwd = uint.Parse(this.tbaccesspasswd.Text.Trim(), System.Globalization.NumberStyles.AllowHexSpecifier);
                    mordr.ParamSet("AccessPassword", passwd);
                }
            }
            else
                mordr.ParamSet("AccessPassword", (uint)0);

            ret = IsAntSet();
            if (ret == -1)
            {
                MessageBox.Show("please select antenna for operation");
                return;
            }
            else if (ret == 1)
            {
                DialogResult stat = DialogResult.OK;
                stat = MessageBox.Show("execute operation on the port without finding antenna ?", "tip-off",
                                MessageBoxButtons.OKCancel, MessageBoxIcon.Question,
                                MessageBoxDefaultButton.Button2);
                if (stat != DialogResult.OK)
                    return;

            }

            if (this.cbisfilter.Checked)
            {

                ret = Form1.IsValidBinaryStr(this.tbfldata.Text.Trim());
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
                    MessageBox.Show("please select bank for filter");
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
                        MessageBox.Show("starting address must be numbers");
                        return;
                    }
                    if (bitaddr < 0)
                    {
                        MessageBox.Show("starting address must be more than zero");
                        return;
                    }
                }

                byte[] filterbytes = new byte[(this.tbfldata.Text.Trim().Length - 1) / 8 + 1];
                for (int c = 0; c < filterbytes.Length; ++c)
                    filterbytes[c] = 0;

                int bitcnt = 0;
                foreach (Char ch in this.tbfldata.Text.Trim())
                {
                    if (ch == '1')
                        filterbytes[bitcnt / 8] |= (byte)(0x01 << (7 - bitcnt % 8));
                    bitcnt++;

                }

                filter = new Gen2TagFilter(this.tbfldata.Text.Trim().Length, filterbytes,
                    (MemBank)this.cbbfilterbank.SelectedIndex + 1, bitaddr,
                    this.cbbfilterrule.SelectedIndex == 0 ? false : true);
            }

            int blkstart = 0;
            if (this.tbblkstart.Text.Trim() == string.Empty)
            {
                MessageBox.Show("please input start block");
                return;
            }
            else
                blkstart = int.Parse(this.tbblkstart.Text.Trim());

            int blkrange = 0;
            if (this.tbblkrange.Text.Trim() == string.Empty)
            {
                MessageBox.Show("please input range of block");
                return;
            }
            else
                blkrange = int.Parse(this.tbblkrange.Text.Trim());

            byte[] mask = new byte[2];
            mask[0] = 0;
            mask[1] = 0;
            if (this.cb1.Checked)
            {
                mask[0] |= 0x01 << 7; 
            }
            if (this.cb2.Checked)
            {
                mask[0] |= 0x01 << 6;
            }
            if (this.cb3.Checked)
            {
                mask[0] |= 0x01 << 5;
            }
            if (this.cb4.Checked)
            {
                mask[0] |= 0x01 << 4;
            }
            if (this.cb5.Checked)
            {
                mask[0] |= 0x01 << 3;
            }
            if (this.cb6.Checked)
            {
                mask[0] |= 0x01 << 2;
            }
            if (this.cb7.Checked)
            {
                mask[0] |= 0x01 << 1;
            }
            if (this.cb8.Checked)
            {
                mask[0] |= 0x01 << 0;
            }
            try
            {
                mordr.Gen2OpBlockPermaLock(filter, blkstart, blkrange, mask);
            }
            catch (OpFaidedException notagexp)
            {
                if (notagexp.ErrCode == 0x400)
                    MessageBox.Show("no tag");
                else
                    MessageBox.Show("operation failed:" + notagexp.ToString());

                return;
            }
            catch (Exception ex)
            {
                MessageBox.Show("operation failed:" + ex.ToString());
                return;
            }

        }

        private void btnpermblkget_Click(object sender, EventArgs e)
        {
            int ret;
            Gen2TagFilter filter = null;

            if (this.cbisaccesspasswd.Checked)
            {
                ret = Form1.IsValidPasswd(this.tbaccesspasswd.Text.Trim());
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
                    uint passwd = uint.Parse(this.tbaccesspasswd.Text.Trim(), System.Globalization.NumberStyles.AllowHexSpecifier);
                    mordr.ParamSet("AccessPassword", passwd);
                }
            }
            else
                mordr.ParamSet("AccessPassword", (uint)0);

            ushort[] readdata = null;

            ret = IsAntSet();
            if (ret == -1)
            {
                MessageBox.Show("please select antenna for operation");
                return;
            }
            else if (ret == 1)
            {
                DialogResult stat = DialogResult.OK;
                stat = MessageBox.Show("execute operation on the port without finding antenna ?", "tip-off",
                                MessageBoxButtons.OKCancel, MessageBoxIcon.Question,
                                MessageBoxDefaultButton.Button2);
                if (stat != DialogResult.OK)
                    return;

            }

            if (this.cbisfilter.Checked)
            {

                ret = Form1.IsValidBinaryStr(this.tbfldata.Text.Trim());
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
                    MessageBox.Show("please select bank for filter");
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
                        MessageBox.Show("starting address must be numbers");
                        return;
                    }
                    if (bitaddr < 0)
                    {
                        MessageBox.Show("starting address must be more than zero");
                        return;
                    }
                }

                byte[] filterbytes = new byte[(this.tbfldata.Text.Trim().Length - 1) / 8 + 1];
                for (int c = 0; c < filterbytes.Length; ++c)
                    filterbytes[c] = 0;

                int bitcnt = 0;
                foreach (Char ch in this.tbfldata.Text.Trim())
                {
                    if (ch == '1')
                        filterbytes[bitcnt / 8] |= (byte)(0x01 << (7 - bitcnt % 8));
                    bitcnt++;

                }

                filter = new Gen2TagFilter(this.tbfldata.Text.Trim().Length, filterbytes,
                    (MemBank)this.cbbfilterbank.SelectedIndex + 1, bitaddr,
                    this.cbbfilterrule.SelectedIndex == 0 ? false : true);
            }

            int blkstart = 0;
            if (this.tbblkstart.Text.Trim() == string.Empty)
            {
                MessageBox.Show("please input start block");
                return;
            }
            else
                blkstart = int.Parse(this.tbblkstart.Text.Trim());

            int blkrange = 0;
            if (this.tbblkrange.Text.Trim() == string.Empty)
            {
                MessageBox.Show("please input range of block");
                return;
            }
            else
                blkrange = int.Parse(this.tbblkrange.Text.Trim());

            try
            {
                byte[] mask = mordr.Gen2OpBlockPermaLock(filter, blkstart, blkrange, null);
                if (((mask[0] >> 7) & 0x1) == 1)
                    this.cb1.Checked = true;
                else
                    this.cb1.Checked = false;

                if (((mask[0] >> 6) & 0x1) == 1)
                    this.cb2.Checked = true;
                else
                    this.cb2.Checked = false;

                if (((mask[0] >> 5) & 0x1) == 1)
                    this.cb3.Checked = true;
                else
                    this.cb3.Checked = false;

                if (((mask[0] >> 4) & 0x1) == 1)
                    this.cb4.Checked = true;
                else
                    this.cb4.Checked = false;

                if (((mask[0] >> 3) & 0x1) == 1)
                    this.cb5.Checked = true;
                else
                    this.cb5.Checked = false;

                if (((mask[0] >> 2) & 0x1) == 1)
                    this.cb6.Checked = true;
                else
                    this.cb6.Checked = false;

                if (((mask[0] >> 1) & 0x1) == 1)
                    this.cb7.Checked = true;
                else
                    this.cb7.Checked = false;

                if (((mask[0] >> 0) & 0x1) == 1)
                    this.cb8.Checked = true;
                else
                    this.cb8.Checked = false;
            }
            catch (OpFaidedException notagexp)
            {
                if (notagexp.ErrCode == 0x400)
                    MessageBox.Show("no tag");
                else
                    MessageBox.Show("operation failed:" + notagexp.ToString());

                return;
            }
            catch (Exception ex)
            {
                MessageBox.Show("operation failed:" + ex.ToString());
                return;
            }

        }


    }
}