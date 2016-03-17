using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using ModuleTech;
using System.Diagnostics;
using System.Threading;
using ModuleLibrary;

namespace InventoryTool
{
    public partial class Form1 : DevComponents.DotNetBar.Metro.MetroForm
    {
        public Form1()
        {
            InitializeComponent();
            
        }
        void ResizelvTags()
        {
            this.lvTags.Columns[0].Width = lvTags.Width / 14;
            this.lvTags.Columns[1].Width = lvTags.Width / 11;
            this.lvTags.Columns[2].Width = lvTags.Width / 12 * 5;
            this.lvTags.Columns[3].Width = lvTags.Width / 12;
            this.lvTags.Columns[4].Width = lvTags.Width / 12;
            this.lvTags.Columns[5].Width = lvTags.Width / 13;
            this.lvTags.Columns[6].Width = lvTags.Width / 11;
            this.lvTags.Columns[7].Width = lvTags.Width / 12;
        }
        Color antorigincolor;
        void ResetControls()
        {
            cbxant1.TextColor = antorigincolor;
            cbxant2.TextColor = antorigincolor;
            cbxant3.TextColor = antorigincolor;
            cbxant4.TextColor = antorigincolor;

            cbxant1.Enabled = false;
            cbxant2.Enabled = false;
            cbxant3.Enabled = false;
            cbxant4.Enabled = false;

            AntList.Clear();
            AntList.Add(cbxant1);
            AntList.Add(cbxant2);
            AntList.Add(cbxant3);
            AntList.Add(cbxant4);

            this.cbxpotlgen2.Enabled = false;
            this.cbxpotlgen2.Checked = true;
            this.cbxpotl6b.Enabled = false;
            this.cbxpotlipx256.Enabled = false;
            this.cbxpotlipx64.Enabled = false;

            this.btnxconnect.Enabled = true;
            this.btnxdisconnect.Enabled = false;
            this.btnxstart.Enabled = false;
            this.btnxstop.Enabled = false;

            this.cbxhighbkrate.Enabled = false;
            this.cbbxtagnums.SelectedIndex = 0;
        }
        private void Form1_Load(object sender, EventArgs e)
        {
            ResizelvTags();
            antorigincolor = cbxant1.TextColor;
            //this.sdpower.IncreaseTooltip = "aa";
            ResetControls();
        }

        private void Form1_Resize(object sender, EventArgs e)
        {
            ResizelvTags();
        }

        bool IsRead = false;
        Reader Rdr = null;
        int AntPortLimit = 0;
        List<DevComponents.DotNetBar.Controls.CheckBoxX> AntList = new List<DevComponents.DotNetBar.Controls.CheckBoxX>();
        Thread Readth = null;

        delegate void HandleException(string err);
        void StopReadByExcepion(string err)
        {
            this.btnxstop_Click(null, null);
            CusShowMsgBox(err);
        }
        delegate void HandleOpFailedExcepion(string err);
        void OpFailedExTipStrSet(string err)
        {
            if (oftfrm != null)
                oftfrm.SetTipString(err);
            else
            {
                oftfrm = new OpFailedTipFrm(this, err);
                oftfrm.Show();
            }
        }

        public OpFailedTipFrm oftfrm = null;
        void ReadFunc()
        {
            while (IsRead)
            {
                try
                {
                    if (IsRevertAntOrder)
                    {
                        SimpleReadPlan pl = Rdr.ParamGet("ReadPlan") as SimpleReadPlan;
                        if (pl != null)
                        {
                            if (pl.Protocol == TagProtocol.GEN2)
                            {
                                int[] neworder = new int[pl.Antennas.Length];
                                for (int j = 0; j < pl.Antennas.Length; ++j)
                                    neworder[j] = pl.Antennas[pl.Antennas.Length - 1 - j];
                                Rdr.ParamSet("ReadPlan", new SimpleReadPlan(TagProtocol.GEN2, neworder));
                            }
                        }
                    }
                    TagReadData[] tags = Rdr.Read(ReadDur);
                    foreach (TagReadData tag in tags)
                    {
                        AddTagToDic(tag);
                    }
                }
                catch (OpFaidedException opex)
                {
                    this.BeginInvoke(new HandleOpFailedExcepion(OpFailedExTipStrSet), opex.ToString());
                }
                catch (Exception ex)
                {
                    this.BeginInvoke(new HandleException(StopReadByExcepion), ex.ToString());
                    break;
                }
            }
        }

        void CusShowMsgBox(string str)
        {
            CusMsgFrm frm = new CusMsgFrm(str);
            frm.StartPosition = FormStartPosition.CenterParent;
            frm.ShowDialog();           
        }

        private void btnxconnect_Click(object sender, EventArgs e)
        {
            if (this.cbbxportnum.SelectedIndex == -1)
            {
                CusShowMsgBox("请选择天线端口数");
                return;
            }
            if (this.tbxaddr.Text.Trim() == string.Empty)
            {
                CusShowMsgBox("请输入读写器地址(IP或串口号)");
                return;
            }

            AntPortLimit = this.cbbxportnum.SelectedIndex + 1;
            try
            {
                Rdr = Reader.Create(this.tbxaddr.Text.Trim(), ModuleTech.Region.NA, AntPortLimit);

                int maxp = (int)Rdr.ParamGet("RfPowerMax");
                int minp = (int)Rdr.ParamGet("RfPowerMin");
                this.sdpower.Minimum = minp / 10;
                this.sdpower.Maximum = maxp / 10;
                this.sdpower.Step = 10;

                AntPower[] pwrs = new AntPower[AntPortLimit];
                for (int i = 0; i < AntPortLimit; ++i)
                {
                    AntList[i].Enabled = true;
                    pwrs[i].AntId = (byte)(i + 1);
                    pwrs[i].ReadPower = (ushort)maxp;
                    pwrs[i].WritePower = (ushort)maxp;
                }
                Rdr.ParamSet("AntPowerConf", pwrs);

                int[] connports = (int[])Rdr.ParamGet("ConnectedAntennas");
                for (int i = 0; i < connports.Length; ++i)
                {
                    if (connports[i] <= AntPortLimit)
                    {
                        AntList[connports[i] - 1].TextColor = Color.SteelBlue;
                        AntList[connports[i] - 1].Checked = true;
                    }
                }

                this.sdpower.Value = maxp / 10;
                if (AntPortLimit == 1)
                    AntList[0].Checked = true;

                if (Rdr.HwDetails.module == Reader.Module_Type.MODOULE_M6E ||
                    Rdr.HwDetails.module == Reader.Module_Type.MODOULE_M6E_MICRO ||
                    Rdr.HwDetails.module == Reader.Module_Type.MODOULE_M6E_PRC)
                {
                    this.cbxpotlgen2.Enabled = true;
                    this.cbxpotl6b.Enabled = true;
                    this.cbxpotlipx256.Enabled = true;
                    this.cbxpotlipx64.Enabled = true;
                    this.cbxhighbkrate.Enabled = true;
                }
            }
            catch (System.Exception ex)
            {
                CusShowMsgBox(ex.ToString());
                return;
            }
            this.epconnparam.Expanded = false;
            //           this.epinvparam.Expanded = true;
            this.btnxconnect.Enabled = false;
            this.btnxdisconnect.Enabled = true;
            this.btnxstart.Enabled = true;
            this.labxmbtype.Text = MainBoard2Str(Rdr.HwDetails.board);
            this.labxmdtype.Text = RfidModule2Str(Rdr.HwDetails.module);

            this.epinvparam.Enabled = true;
            this.epdatastatistic.Enabled = true;
            this.epotherparam.Enabled = true;

            Form2 frm = new Form2("连接成功");
            frm.ShowDialog();
        }

        string RfidModule2Str(Reader.Module_Type mdtype)
        {
            switch (mdtype)
            {
                case Reader.Module_Type.MODOULE_M5E:
                    return "M5E";
                case Reader.Module_Type.MODOULE_M5E_C:
                    return "M5E-C";
                case Reader.Module_Type.MODOULE_M6E:
                    return "M6E";
                case Reader.Module_Type.MODOULE_M6E_MICRO:
                    return "M6E-Micro";
                case Reader.Module_Type.MODOULE_M6E_PRC:
                    return "M6E-PRC";
                case Reader.Module_Type.MODOULE_R902_MT100:
                    return "SLR1000";
                case Reader.Module_Type.MODOULE_SLR1100:
                    return "SLR1100";
                case Reader.Module_Type.MODOULE_SLR1200:
                    return "SLR1200";
                case Reader.Module_Type.MODOULE_SLR1300:
                    return "SLR1300";
                case Reader.Module_Type.MODOULE_SLR3000:
                    return "SLR3000";
                case Reader.Module_Type.MODOULE_SLR3100:
                    return "SLR3100";
                case Reader.Module_Type.MODOULE_SLR3200:
                    return "SLR3200";
                case Reader.Module_Type.MODOULE_SLR5100:
                    return "SLR5100";
                case Reader.Module_Type.MODOULE_SLR5200:
                    return "SLR5200";
                default:
                    return "Unknown";
            }
        }

        string MainBoard2Str(Reader.MaindBoard_Type mbtype)
        {
            switch (mbtype)
            {
                case Reader.MaindBoard_Type.MAINBOARD_ARM7:
                    return "ARM7";
                case Reader.MaindBoard_Type.MAINBOARD_ARM9:
                    return "ARM9";
                case Reader.MaindBoard_Type.MAINBOARD_ARM9_WIFI:
                    return "ARM9_WIFI";
                case Reader.MaindBoard_Type.MAINBOARD_SERIAL:
                    return "Serial";
                default:
                    return "Unknown";
            }
        }
        private void sdpower_ValueChanged(object sender, EventArgs e)
        {
            try
            {
                int valset = this.sdpower.Value;
                AntPower[] pwrs = new AntPower[AntPortLimit];
                for (int i = 0; i < AntPortLimit; ++i)
                {
                    pwrs[i].AntId = (byte)(i + 1);
                    pwrs[i].ReadPower = (ushort)(valset * 10);
                    pwrs[i].WritePower = (ushort)(valset * 10);
                }
                Rdr.ParamSet("AntPowerConf", pwrs);
                this.labxpwr.Text = (valset/10).ToString();
            }
            catch (System.Exception ex)
            {
                CusShowMsgBox("操作失败:" + ex.ToString());
                return;
            }

        }

        Mutex tagmutex = new Mutex();
        Dictionary<string, TagInfo> m_Tags = new Dictionary<string, TagInfo>();
        int ReadDur = 0;
        private void btnxstart_Click(object sender, EventArgs e)
        {
            List<int> selants = new List<int>();
            for (int i = 0; i < AntList.Count; ++i)
            {
                if (AntList[i].Checked)
                    selants.Add(i + 1);
            }
            if (selants.Count == 0)
            {
                CusShowMsgBox("请选择天线");
                return;
            }
            else
            {
                int TagReadTime = 0;
                if (this.cbbxtagnums.SelectedIndex >= 3)
                {
                    Rdr.ParamSet("Gen2Session", ModuleTech.Gen2.Session.Session1);
                    if (this.cbbxtagnums.SelectedIndex == 3)
                        TagReadTime = 300;
                    else if (this.cbbxtagnums.SelectedIndex == 4)
                        TagReadTime = 500;
                    else if (this.cbbxtagnums.SelectedIndex == 5)
                        TagReadTime = 800;
                    else if (this.cbbxtagnums.SelectedIndex > 6)
                        TagReadTime = 1000;
                }
                else
                {
                    Rdr.ParamSet("Gen2Session", ModuleTech.Gen2.Session.Session0);
                    if (this.cbbxtagnums.SelectedIndex == 0)
                        TagReadTime = 70;
                    else if (this.cbbxtagnums.SelectedIndex == 1)
                        TagReadTime = 180;
                    else
                        TagReadTime = 250;
                }
                int MinTotAntsTime = 0;
                if (selants.Count == 1)
                    MinTotAntsTime = 70;
                else if (selants.Count == 2)
                    MinTotAntsTime = 200;
                else if (selants.Count == 3)
                    MinTotAntsTime = 500;
                else if (selants.Count == 4)
                    MinTotAntsTime = 720;

                ReadDur = (TagReadTime >= MinTotAntsTime ? TagReadTime : MinTotAntsTime);
            }

            List<SimpleReadPlan> readplans = new List<SimpleReadPlan>();
            if (this.cbxpotl6b.Checked)
                readplans.Add(new SimpleReadPlan(TagProtocol.ISO180006B, selants.ToArray(), 30));
            if (this.cbxpotlgen2.Checked)
                readplans.Add(new SimpleReadPlan(TagProtocol.GEN2, selants.ToArray(), 30));
            if (this.cbxpotlipx256.Checked)
                readplans.Add(new SimpleReadPlan(TagProtocol.IPX256, selants.ToArray(), 30));
            if (this.cbxpotlipx64.Checked)
                readplans.Add(new SimpleReadPlan(TagProtocol.IPX64, selants.ToArray(), 30));
            if (readplans.Count == 0)
            {
                CusShowMsgBox("请选择协议");
                return;
            }
            else if (readplans.Count == 1)
                Rdr.ParamSet("ReadPlan", readplans[0]);
            else
                Rdr.ParamSet("ReadPlan", new MultiReadPlan(readplans.ToArray()));

            IsRead = true;
            Readth = new Thread(ReadFunc);
            Readth.Start();
            this.timer1.Interval = ReadDur;
            this.timer1.Enabled = true;
            this.btnxstart.Enabled = false;
            this.btnxstop.Enabled = true;
            this.btnxdisconnect.Enabled = false;

            this.epinvparam.Expanded = false;
            this.epinvparam.Enabled = false;
            this.epotherparam.Expanded = false;
            this.epotherparam.Enabled = false;

        }

        List<TagInfo> tmplist = new List<TagInfo>();
        Dictionary<string, ListViewItem> taglvdic = new Dictionary<string, ListViewItem>();
        private void timer1_Tick(object sender, EventArgs e)
        {
            tmplist.Clear();
            tagmutex.WaitOne();
            foreach (TagInfo tag in m_Tags.Values)
            {
                tmplist.Add(tag);
            }
            tagmutex.ReleaseMutex();

            int ant1cnt = 0;
            int ant2cnt = 0;
            int ant3cnt = 0;
            int ant4cnt = 0;
            foreach (TagInfo tag in tmplist)
            {
                if (tag.antid == 1)
                    ant1cnt++;
                if (tag.antid == 2)
                    ant2cnt++;
                if (tag.antid == 3)
                    ant3cnt++;
                if (tag.antid == 4)
                    ant4cnt++;

                if (taglvdic.ContainsKey(tag.epcid))
                {
                    ListViewItem tmpitem = taglvdic[tag.epcid];
                    bool isupdatecolor = false;
                    if (tag.readcnt != int.Parse(tmpitem.SubItems[1].Text))
                    {
                        isupdatecolor = true;
                        tmpitem.SubItems[1].Text = tag.readcnt.ToString();
                    }
                    tmpitem.SubItems[3].Text = tag.antid.ToString();
                    tmpitem.SubItems[5].Text = tag.RssiRaw.ToString();
                    tmpitem.SubItems[7].Text = tag.Phase.ToString();
                    tmpitem.SubItems[6].Text = tag.Frequency.ToString();
                    if (isupdatecolor)
                        tmpitem.BackColor = Color.White;
                    else
                    {
                        TimeSpan span = DateTime.Now - tag.timestamp;
                        if (span.Seconds > 2 && span.Seconds < 4)
                            tmpitem.BackColor = Color.Silver;
                        else if (span.Seconds >= 4)
                            tmpitem.BackColor = Color.DimGray;
                    }
                }
                else
                {
                    ListViewItem item = new ListViewItem(lvTags.Items.Count.ToString());
                    item.SubItems.Add(tag.readcnt.ToString());
                    item.SubItems.Add(tag.epcid);
                    item.SubItems.Add(tag.antid.ToString());

                    if (tag.potl == TagProtocol.ISO180006B)
                        item.SubItems.Add("6B");
                    else if (tag.potl == TagProtocol.IPX256)
                        item.SubItems.Add("IPX256");
                    else if (tag.potl == TagProtocol.IPX64)
                        item.SubItems.Add("IPX64");
                    else if (tag.potl == TagProtocol.GEN2)
                        item.SubItems.Add("GEN2");

                    item.SubItems.Add(tag.RssiRaw.ToString());
                    item.SubItems.Add(tag.Frequency.ToString());
                    item.SubItems.Add(tag.Phase.ToString());
                    lvTags.Items.Add(item);
                    taglvdic.Add(tag.epcid, item);
                }
            }

            this.labxnumant1.Text = ant1cnt.ToString();
            this.labxnumant2.Text = ant2cnt.ToString();
            this.labxnumant3.Text = ant3cnt.ToString();
            this.labxnumant4.Text = ant4cnt.ToString();
        }

        private void btnxclear_Click(object sender, EventArgs e)
        {
            tagmutex.WaitOne();
            m_Tags.Clear();
            tagmutex.ReleaseMutex();
            this.lvTags.Items.Clear();
            this.taglvdic.Clear();
        }

        void AddTagToDic(TagReadData tag)
        {
            TagInfo tmptag = null;

            tagmutex.WaitOne();

            string keystr = tag.EPCString;

            if (m_Tags.ContainsKey(keystr))
            {
                tmptag = m_Tags[keystr];
                tmptag.readcnt += tag.ReadCount;
                tmptag.RssiRaw = tag.Rssi;
                tmptag.Phase = tag.Phase;
                tmptag.antid = tag.Antenna;
                tmptag.Frequency = tag.Frequency;
                tmptag.timestamp = tag.Time;
            }
            else
            {
                TagInfo newtag = null;
                newtag = new TagInfo(tag.EPCString, tag.ReadCount, tag.Antenna, tag.Time,
                    tag.Tag.Protocol, tag.EMDDataString);
                newtag.RssiRaw = tag.Rssi;
                newtag.Phase = tag.Phase;
                newtag.Frequency = tag.Frequency;
                m_Tags.Add(keystr, newtag);
            }
            tagmutex.ReleaseMutex();
        }

        private void btnxstop_Click(object sender, EventArgs e)
        {
            this.timer1.Enabled = false;
            IsRead = false;
            if (Readth != null)
            {
                Readth.Join();
                Readth = null;
            }

            timer1_Tick(null, null);
            this.btnxstop.Enabled = false;
            this.btnxstart.Enabled = true;
            this.btnxdisconnect.Enabled = true;
            this.epinvparam.Enabled = true;
            this.epotherparam.Enabled = true;
            NumTipFrm frm = new NumTipFrm(this.lvTags.Items.Count);
            frm.ShowDialog();
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (IsRead)
                btnxstop_Click(null, null);
            if (oftfrm != null)
                oftfrm.Close();
        }

        private void btnxdisconnect_Click(object sender, EventArgs e)
        {
            Rdr.Disconnect();
            ResetControls();
            
            this.epconnparam.Expanded = true;
            this.epinvparam.Expanded = false;
            this.epinvparam.Enabled = false;
            this.epdatastatistic.Expanded = false;
            this.epdatastatistic.Enabled = false;
            this.epotherparam.Expanded = false;
            this.epotherparam.Enabled = false;
        }

        private void cbxdetectant_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                if (this.cbxdetectant.Checked)
                    Rdr.ParamSet("CheckAntConnection", true);
                else
                    Rdr.ParamSet("CheckAntConnection", false);
            }
            catch (System.Exception ex)
            {
                CusShowMsgBox("操作失败:" + ex.ToString());
                return;
            }
        }

        private void cbxhighbkrate_CheckedChanged(object sender, EventArgs e)
        {
            if (Rdr.HwDetails.module == Reader.Module_Type.MODOULE_M6E ||
                Rdr.HwDetails.module == Reader.Module_Type.MODOULE_M6E_PRC)
            {
                try
                {
                    if (this.cbxhighbkrate.Checked)
                    {
                        Rdr.ParamSet("gen2tagEncoding", 0);
                        Rdr.ParamSet("gen2BLF", 640);
                    }
                    else
                    {
                        Rdr.ParamSet("gen2BLF", 250);
                        Rdr.ParamSet("gen2tagEncoding", 2);
                    }
                }
                catch (System.Exception ex)
                {
                    CusShowMsgBox("操作失败:" + ex.ToString());
                    return;
                }
            }
        }

        //private void rbgen2session_CheckedChanged(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        if (this.rbgen2session.Checked)
        //            Rdr.ParamSet("Gen2Session", ModuleTech.Gen2.Session.Session0);
        //        else
        //            Rdr.ParamSet("Gen2Session", ModuleTech.Gen2.Session.Session1);
        //    }
        //    catch (System.Exception ex)
        //    {
        //        CusShowMsgBox("操作失败:" + ex.ToString());
        //        return;
        //    }
        //}
        bool IsRevertAntOrder = false;
        private void cbxrevertantorder_CheckedChanged(object sender, EventArgs e)
        {
            if (cbxrevertantorder.Checked)
                IsRevertAntOrder = true;
            else
                IsRevertAntOrder = false;
        }

        private void lvTags_ColumnClick(object sender, ColumnClickEventArgs e)
        {
            if (e.Column >= 1 && e.Column <= 7)
            {
                tmplist.Clear();
                foreach (ListViewItem viewitem in lvTags.Items)
                {
                    TagProtocol potl = TagProtocol.NONE;
                    if (viewitem.SubItems[4].Text == "GEN2")
                        potl = TagProtocol.GEN2;
                    else if (viewitem.SubItems[4].Text == "6B")
                        potl = TagProtocol.ISO180006B;
                    else if (viewitem.SubItems[4].Text == "IPX256")
                        potl = TagProtocol.IPX256;
                    else if (viewitem.SubItems[4].Text == "IPX64")
                        potl = TagProtocol.IPX64;

                    TagInfo newtag = new TagInfo(viewitem.SubItems[2].Text, int.Parse(viewitem.SubItems[1].Text),
                        int.Parse(viewitem.SubItems[3].Text), DateTime.Now, potl, null);
                    newtag.RssiRaw = int.Parse(viewitem.SubItems[5].Text);
                    newtag.Frequency = int.Parse(viewitem.SubItems[6].Text);
                    newtag.Phase = int.Parse(viewitem.SubItems[7].Text);
                    tmplist.Add(newtag);
                }
                this.lvTags.Items.Clear();
                IComparer<TagInfo> tagcmper = null;
                if (e.Column == 1)
                    tagcmper = new TagInfoCompReadCnt();
                else if (e.Column == 2)
                    tagcmper = new TagInfoCompEPCId();
                else if (e.Column == 3)
                    tagcmper = new TagInfoCompAntId();
                else if (e.Column == 4)
                    tagcmper = new TagInfoCompPotl();
                else if (e.Column == 5)
                    tagcmper = new TagInfoCompRssi();
                else if (e.Column == 6)
                    tagcmper = new TagInfoCompFreq();
                else if (e.Column == 7)
                    tagcmper = new TagInfoCompPhase();

                tmplist.Sort(tagcmper);
                foreach (TagInfo tag in tmplist)
                {
                    ListViewItem item = new ListViewItem(lvTags.Items.Count.ToString());
                    item.SubItems.Add(tag.readcnt.ToString());
                    item.SubItems.Add(tag.epcid);
                    item.SubItems.Add(tag.antid.ToString());

                    if (tag.potl == TagProtocol.GEN2)
                        item.SubItems.Add("GEN2");
                    else if (tag.potl == TagProtocol.ISO180006B)
                        item.SubItems.Add("6B");
                    else if (tag.potl == TagProtocol.IPX256)
                        item.SubItems.Add("IPX256");
                    else if (tag.potl == TagProtocol.IPX64)
                        item.SubItems.Add("IPX64");
                    item.SubItems.Add(tag.RssiRaw.ToString());
                    item.SubItems.Add(tag.Frequency.ToString());
                    item.SubItems.Add(tag.Phase.ToString());
                    lvTags.Items.Add(item);
                }
            }
        }

    }

    public class TagInfoCompEPCId : IComparer<TagInfo>
    {
        public int Compare(TagInfo x, TagInfo y)
        {
            return x.epcid.CompareTo(y.epcid);
        }
    }

    public class TagInfoCompReadCnt : IComparer<TagInfo>
    {
        public int Compare(TagInfo x, TagInfo y)
        {
            return x.readcnt.CompareTo(y.readcnt);
        }
    }

    public class TagInfoCompPotl : IComparer<TagInfo>
    {
        public int Compare(TagInfo x, TagInfo y)
        {
            return x.potl.CompareTo(y.potl);
        }
    }

    public class TagInfoCompFreq : IComparer<TagInfo>
    {
        public int Compare(TagInfo x, TagInfo y)
        {
            return x.Frequency.CompareTo(y.Frequency);
        }
    }

    public class TagInfoCompPhase : IComparer<TagInfo>
    {
        public int Compare(TagInfo x, TagInfo y)
        {
            return x.Phase.CompareTo(y.Phase);
        }
    }

    public class TagInfoCompRssi : IComparer<TagInfo>
    {
        public int Compare(TagInfo x, TagInfo y)
        {
            return x.RssiRaw.CompareTo(y.RssiRaw);
        }
    }

    public class TagInfoCompEmdData : IComparer<TagInfo>
    {
        public int Compare(TagInfo x, TagInfo y)
        {
            return x.emddatastr.CompareTo(y.emddatastr);
        }
    }

    public class TagInfoCompAntId : IComparer<TagInfo>
    {
        public int Compare(TagInfo x, TagInfo y)
        {
            return x.antid.CompareTo(y.antid);
        }
    }

    public class TagInfo
    {
        public TagInfo(string epc, int rcnt, int ant, DateTime time, TagProtocol potl_, string emdstr)
        {
            epcid = epc;
            readcnt = rcnt;
            antid = ant;
            timestamp = time;
            potl = potl_;
            emddatastr = emdstr;
            RssiSum = 0;
        }
        public string epcid;
        public int readcnt;
        public int antid;
        public TagProtocol potl;
        public DateTime timestamp;
        public string emddatastr;
        public int RssiSum;
        public int RssiRaw;
        public int Frequency;
        public int Phase;
    }

    class DoubleBufferListView : ListView
    {
        public DoubleBufferListView()
        {
            SetStyle(ControlStyles.DoubleBuffer | ControlStyles.OptimizedDoubleBuffer | ControlStyles.AllPaintingInWmPaint, true);
            UpdateStyles();
        }
    }
}