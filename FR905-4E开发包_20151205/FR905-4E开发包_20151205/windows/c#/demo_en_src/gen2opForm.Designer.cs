namespace ModuleReaderManager
{
    partial class gen2opForm
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows 窗体设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.cbbopbank = new System.Windows.Forms.ComboBox();
            this.label2 = new System.Windows.Forms.Label();
            this.tbaccesspasswd = new System.Windows.Forms.TextBox();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.tb16antssel = new System.Windows.Forms.TextBox();
            this.label14 = new System.Windows.Forms.Label();
            this.cbbfilterrule = new System.Windows.Forms.ComboBox();
            this.label12 = new System.Windows.Forms.Label();
            this.tbfilteraddr = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.cbbfilterbank = new System.Windows.Forms.ComboBox();
            this.rbant4 = new System.Windows.Forms.RadioButton();
            this.rbant3 = new System.Windows.Forms.RadioButton();
            this.cbisaccesspasswd = new System.Windows.Forms.CheckBox();
            this.rbant2 = new System.Windows.Forms.RadioButton();
            this.cbisfilter = new System.Windows.Forms.CheckBox();
            this.rbant1 = new System.Windows.Forms.RadioButton();
            this.tbkillpasswd = new System.Windows.Forms.TextBox();
            this.label9 = new System.Windows.Forms.Label();
            this.tbfldata = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.rtbdata = new System.Windows.Forms.RichTextBox();
            this.btnread = new System.Windows.Forms.Button();
            this.label7 = new System.Windows.Forms.Label();
            this.tbstartaddr = new System.Windows.Forms.TextBox();
            this.label8 = new System.Windows.Forms.Label();
            this.tbblocks = new System.Windows.Forms.TextBox();
            this.btnwrite = new System.Windows.Forms.Button();
            this.btnlock = new System.Windows.Forms.Button();
            this.btnkill = new System.Windows.Forms.Button();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.btnstopread = new System.Windows.Forms.Button();
            this.btnconread = new System.Windows.Forms.Button();
            this.labavewtime = new System.Windows.Forms.Label();
            this.label15 = new System.Windows.Forms.Label();
            this.labwritecnt = new System.Windows.Forms.Label();
            this.label13 = new System.Windows.Forms.Label();
            this.btnstop = new System.Windows.Forms.Button();
            this.btnConwirte = new System.Windows.Forms.Button();
            this.btnWriteEpc = new System.Windows.Forms.Button();
            this.label10 = new System.Windows.Forms.Label();
            this.cbblockunit = new System.Windows.Forms.ComboBox();
            this.label11 = new System.Windows.Forms.Label();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.cbblocktype = new System.Windows.Forms.ComboBox();
            this.groupBox4 = new System.Windows.Forms.GroupBox();
            this.btnpermblkget = new System.Windows.Forms.Button();
            this.tbblkrange = new System.Windows.Forms.TextBox();
            this.label18 = new System.Windows.Forms.Label();
            this.tbblkstart = new System.Windows.Forms.TextBox();
            this.label17 = new System.Windows.Forms.Label();
            this.label16 = new System.Windows.Forms.Label();
            this.cb8 = new System.Windows.Forms.CheckBox();
            this.cb7 = new System.Windows.Forms.CheckBox();
            this.cb6 = new System.Windows.Forms.CheckBox();
            this.cb5 = new System.Windows.Forms.CheckBox();
            this.cb4 = new System.Windows.Forms.CheckBox();
            this.cb3 = new System.Windows.Forms.CheckBox();
            this.cb2 = new System.Windows.Forms.CheckBox();
            this.cb1 = new System.Windows.Forms.CheckBox();
            this.btnpermblklock = new System.Windows.Forms.Button();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.groupBox4.SuspendLayout();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(224, 26);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(29, 12);
            this.label1.TabIndex = 0;
            this.label1.Text = "bank";
            // 
            // cbbopbank
            // 
            this.cbbopbank.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbbopbank.FormattingEnabled = true;
            this.cbbopbank.Items.AddRange(new object[] {
            "ReserveBank",
            "EPCBank",
            "TIDBank",
            "USERBank"});
            this.cbbopbank.Location = new System.Drawing.Point(259, 23);
            this.cbbopbank.Name = "cbbopbank";
            this.cbbopbank.Size = new System.Drawing.Size(73, 20);
            this.cbbopbank.TabIndex = 1;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(14, 78);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(89, 12);
            this.label2.TabIndex = 2;
            this.label2.Text = "accesspassword";
            // 
            // tbaccesspasswd
            // 
            this.tbaccesspasswd.Location = new System.Drawing.Point(115, 75);
            this.tbaccesspasswd.Name = "tbaccesspasswd";
            this.tbaccesspasswd.Size = new System.Drawing.Size(69, 21);
            this.tbaccesspasswd.TabIndex = 3;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.tb16antssel);
            this.groupBox1.Controls.Add(this.label14);
            this.groupBox1.Controls.Add(this.cbbfilterrule);
            this.groupBox1.Controls.Add(this.label12);
            this.groupBox1.Controls.Add(this.tbfilteraddr);
            this.groupBox1.Controls.Add(this.label4);
            this.groupBox1.Controls.Add(this.label3);
            this.groupBox1.Controls.Add(this.cbbfilterbank);
            this.groupBox1.Controls.Add(this.rbant4);
            this.groupBox1.Controls.Add(this.rbant3);
            this.groupBox1.Controls.Add(this.cbisaccesspasswd);
            this.groupBox1.Controls.Add(this.rbant2);
            this.groupBox1.Controls.Add(this.cbisfilter);
            this.groupBox1.Controls.Add(this.rbant1);
            this.groupBox1.Controls.Add(this.tbkillpasswd);
            this.groupBox1.Controls.Add(this.label9);
            this.groupBox1.Controls.Add(this.tbfldata);
            this.groupBox1.Controls.Add(this.label5);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.tbaccesspasswd);
            this.groupBox1.Location = new System.Drawing.Point(12, 12);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(347, 161);
            this.groupBox1.TabIndex = 4;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "tag operation setting";
            // 
            // tb16antssel
            // 
            this.tb16antssel.Location = new System.Drawing.Point(167, 132);
            this.tb16antssel.Name = "tb16antssel";
            this.tb16antssel.Size = new System.Drawing.Size(47, 21);
            this.tb16antssel.TabIndex = 28;
            // 
            // label14
            // 
            this.label14.AutoSize = true;
            this.label14.Location = new System.Drawing.Point(117, 135);
            this.label14.Name = "label14";
            this.label14.Size = new System.Drawing.Size(53, 12);
            this.label14.TabIndex = 27;
            this.label14.Text = "op ant：";
            // 
            // cbbfilterrule
            // 
            this.cbbfilterrule.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbbfilterrule.FormattingEnabled = true;
            this.cbbfilterrule.Items.AddRange(new object[] {
            "match",
            "no match"});
            this.cbbfilterrule.Location = new System.Drawing.Point(259, 18);
            this.cbbfilterrule.Name = "cbbfilterrule";
            this.cbbfilterrule.Size = new System.Drawing.Size(73, 20);
            this.cbbfilterrule.TabIndex = 26;
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Location = new System.Drawing.Point(194, 21);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(59, 12);
            this.label12.TabIndex = 25;
            this.label12.Text = "matchrule";
            // 
            // tbfilteraddr
            // 
            this.tbfilteraddr.Location = new System.Drawing.Point(115, 45);
            this.tbfilteraddr.Name = "tbfilteraddr";
            this.tbfilteraddr.Size = new System.Drawing.Size(69, 21);
            this.tbfilteraddr.TabIndex = 24;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(14, 50);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(95, 12);
            this.label4.TabIndex = 23;
            this.label4.Text = "startingaddress";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(194, 49);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(65, 12);
            this.label3.TabIndex = 22;
            this.label3.Text = "filterbank";
            // 
            // cbbfilterbank
            // 
            this.cbbfilterbank.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbbfilterbank.FormattingEnabled = true;
            this.cbbfilterbank.Items.AddRange(new object[] {
            "EPCbank",
            "TIDbank",
            "USERbank"});
            this.cbbfilterbank.Location = new System.Drawing.Point(259, 46);
            this.cbbfilterbank.Name = "cbbfilterbank";
            this.cbbfilterbank.Size = new System.Drawing.Size(73, 20);
            this.cbbfilterbank.TabIndex = 21;
            // 
            // rbant4
            // 
            this.rbant4.AutoSize = true;
            this.rbant4.Enabled = false;
            this.rbant4.Location = new System.Drawing.Point(253, 105);
            this.rbant4.Name = "rbant4";
            this.rbant4.Size = new System.Drawing.Size(47, 16);
            this.rbant4.TabIndex = 20;
            this.rbant4.TabStop = true;
            this.rbant4.Text = "ant4";
            this.rbant4.UseVisualStyleBackColor = true;
            // 
            // rbant3
            // 
            this.rbant3.AutoSize = true;
            this.rbant3.Enabled = false;
            this.rbant3.Location = new System.Drawing.Point(171, 105);
            this.rbant3.Name = "rbant3";
            this.rbant3.Size = new System.Drawing.Size(47, 16);
            this.rbant3.TabIndex = 19;
            this.rbant3.TabStop = true;
            this.rbant3.Text = "ant3";
            this.rbant3.UseVisualStyleBackColor = true;
            // 
            // cbisaccesspasswd
            // 
            this.cbisaccesspasswd.AutoSize = true;
            this.cbisaccesspasswd.Location = new System.Drawing.Point(223, 134);
            this.cbisaccesspasswd.Name = "cbisaccesspasswd";
            this.cbisaccesspasswd.Size = new System.Drawing.Size(120, 16);
            this.cbisaccesspasswd.TabIndex = 16;
            this.cbisaccesspasswd.Text = "enable accesspwd";
            this.cbisaccesspasswd.UseVisualStyleBackColor = true;
            // 
            // rbant2
            // 
            this.rbant2.AutoSize = true;
            this.rbant2.Location = new System.Drawing.Point(90, 105);
            this.rbant2.Name = "rbant2";
            this.rbant2.Size = new System.Drawing.Size(47, 16);
            this.rbant2.TabIndex = 18;
            this.rbant2.TabStop = true;
            this.rbant2.Text = "ant2";
            this.rbant2.UseVisualStyleBackColor = true;
            // 
            // cbisfilter
            // 
            this.cbisfilter.AutoSize = true;
            this.cbisfilter.Location = new System.Drawing.Point(17, 134);
            this.cbisfilter.Name = "cbisfilter";
            this.cbisfilter.Size = new System.Drawing.Size(102, 16);
            this.cbisfilter.TabIndex = 15;
            this.cbisfilter.Text = "enable filter";
            this.cbisfilter.UseVisualStyleBackColor = true;
            // 
            // rbant1
            // 
            this.rbant1.AutoSize = true;
            this.rbant1.Location = new System.Drawing.Point(16, 104);
            this.rbant1.Name = "rbant1";
            this.rbant1.Size = new System.Drawing.Size(47, 16);
            this.rbant1.TabIndex = 17;
            this.rbant1.TabStop = true;
            this.rbant1.Text = "ant1";
            this.rbant1.UseVisualStyleBackColor = true;
            // 
            // tbkillpasswd
            // 
            this.tbkillpasswd.Location = new System.Drawing.Point(259, 75);
            this.tbkillpasswd.Name = "tbkillpasswd";
            this.tbkillpasswd.Size = new System.Drawing.Size(73, 21);
            this.tbkillpasswd.TabIndex = 16;
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(194, 78);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(47, 12);
            this.label9.TabIndex = 7;
            this.label9.Text = "killpwd";
            // 
            // tbfldata
            // 
            this.tbfldata.Location = new System.Drawing.Point(80, 18);
            this.tbfldata.Name = "tbfldata";
            this.tbfldata.Size = new System.Drawing.Size(104, 21);
            this.tbfldata.TabIndex = 6;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(14, 21);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(59, 12);
            this.label5.TabIndex = 6;
            this.label5.Text = "matchdata";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(15, 57);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(35, 12);
            this.label6.TabIndex = 5;
            this.label6.Text = "data:";
            // 
            // rtbdata
            // 
            this.rtbdata.Location = new System.Drawing.Point(57, 54);
            this.rtbdata.Name = "rtbdata";
            this.rtbdata.Size = new System.Drawing.Size(275, 75);
            this.rtbdata.TabIndex = 6;
            this.rtbdata.Text = "";
            // 
            // btnread
            // 
            this.btnread.Location = new System.Drawing.Point(6, 148);
            this.btnread.Name = "btnread";
            this.btnread.Size = new System.Drawing.Size(54, 23);
            this.btnread.TabIndex = 7;
            this.btnread.Text = "read";
            this.btnread.UseVisualStyleBackColor = true;
            this.btnread.Click += new System.EventHandler(this.btnread_Click);
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(14, 25);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(77, 12);
            this.label7.TabIndex = 8;
            this.label7.Text = "startaddress";
            // 
            // tbstartaddr
            // 
            this.tbstartaddr.Location = new System.Drawing.Point(95, 22);
            this.tbstartaddr.Name = "tbstartaddr";
            this.tbstartaddr.Size = new System.Drawing.Size(42, 21);
            this.tbstartaddr.TabIndex = 9;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(138, 25);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(41, 12);
            this.label8.TabIndex = 10;
            this.label8.Text = "blocks";
            // 
            // tbblocks
            // 
            this.tbblocks.Location = new System.Drawing.Point(184, 22);
            this.tbblocks.Name = "tbblocks";
            this.tbblocks.Size = new System.Drawing.Size(39, 21);
            this.tbblocks.TabIndex = 11;
            // 
            // btnwrite
            // 
            this.btnwrite.Location = new System.Drawing.Point(73, 148);
            this.btnwrite.Name = "btnwrite";
            this.btnwrite.Size = new System.Drawing.Size(54, 23);
            this.btnwrite.TabIndex = 12;
            this.btnwrite.Text = "write";
            this.btnwrite.UseVisualStyleBackColor = true;
            this.btnwrite.Click += new System.EventHandler(this.btnwrite_Click);
            // 
            // btnlock
            // 
            this.btnlock.Location = new System.Drawing.Point(140, 148);
            this.btnlock.Name = "btnlock";
            this.btnlock.Size = new System.Drawing.Size(54, 23);
            this.btnlock.TabIndex = 13;
            this.btnlock.Text = "lock";
            this.btnlock.UseVisualStyleBackColor = true;
            this.btnlock.Click += new System.EventHandler(this.btnlock_Click);
            // 
            // btnkill
            // 
            this.btnkill.Location = new System.Drawing.Point(208, 148);
            this.btnkill.Name = "btnkill";
            this.btnkill.Size = new System.Drawing.Size(54, 23);
            this.btnkill.TabIndex = 14;
            this.btnkill.Text = "kill";
            this.btnkill.UseVisualStyleBackColor = true;
            this.btnkill.Click += new System.EventHandler(this.btnkill_Click);
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.btnstopread);
            this.groupBox2.Controls.Add(this.btnconread);
            this.groupBox2.Controls.Add(this.labavewtime);
            this.groupBox2.Controls.Add(this.label15);
            this.groupBox2.Controls.Add(this.labwritecnt);
            this.groupBox2.Controls.Add(this.label13);
            this.groupBox2.Controls.Add(this.btnstop);
            this.groupBox2.Controls.Add(this.btnConwirte);
            this.groupBox2.Controls.Add(this.btnWriteEpc);
            this.groupBox2.Controls.Add(this.btnlock);
            this.groupBox2.Controls.Add(this.tbstartaddr);
            this.groupBox2.Controls.Add(this.btnkill);
            this.groupBox2.Controls.Add(this.label1);
            this.groupBox2.Controls.Add(this.cbbopbank);
            this.groupBox2.Controls.Add(this.btnwrite);
            this.groupBox2.Controls.Add(this.tbblocks);
            this.groupBox2.Controls.Add(this.label8);
            this.groupBox2.Controls.Add(this.label6);
            this.groupBox2.Controls.Add(this.rtbdata);
            this.groupBox2.Controls.Add(this.label7);
            this.groupBox2.Controls.Add(this.btnread);
            this.groupBox2.Location = new System.Drawing.Point(12, 233);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(347, 246);
            this.groupBox2.TabIndex = 15;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "tag operation";
            // 
            // btnstopread
            // 
            this.btnstopread.Location = new System.Drawing.Point(125, 206);
            this.btnstopread.Name = "btnstopread";
            this.btnstopread.Size = new System.Drawing.Size(54, 23);
            this.btnstopread.TabIndex = 23;
            this.btnstopread.Text = "stop";
            this.btnstopread.UseVisualStyleBackColor = true;
            this.btnstopread.Click += new System.EventHandler(this.btnstopread_Click);
            // 
            // btnconread
            // 
            this.btnconread.Location = new System.Drawing.Point(6, 206);
            this.btnconread.Name = "btnconread";
            this.btnconread.Size = new System.Drawing.Size(87, 23);
            this.btnconread.TabIndex = 22;
            this.btnconread.Text = "repeat read";
            this.btnconread.UseVisualStyleBackColor = true;
            this.btnconread.Click += new System.EventHandler(this.btnconread_Click);
            // 
            // labavewtime
            // 
            this.labavewtime.AutoSize = true;
            this.labavewtime.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.labavewtime.ForeColor = System.Drawing.Color.Red;
            this.labavewtime.Location = new System.Drawing.Point(261, 206);
            this.labavewtime.Name = "labavewtime";
            this.labavewtime.Size = new System.Drawing.Size(17, 16);
            this.labavewtime.TabIndex = 21;
            this.labavewtime.Text = "0";
            // 
            // label15
            // 
            this.label15.AutoSize = true;
            this.label15.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.label15.ForeColor = System.Drawing.Color.Red;
            this.label15.Location = new System.Drawing.Point(180, 207);
            this.label15.Name = "label15";
            this.label15.Size = new System.Drawing.Size(80, 16);
            this.label15.TabIndex = 20;
            this.label15.Text = "average:";
            // 
            // labwritecnt
            // 
            this.labwritecnt.AutoSize = true;
            this.labwritecnt.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.labwritecnt.ForeColor = System.Drawing.Color.Red;
            this.labwritecnt.Location = new System.Drawing.Point(261, 182);
            this.labwritecnt.Name = "labwritecnt";
            this.labwritecnt.Size = new System.Drawing.Size(17, 16);
            this.labwritecnt.TabIndex = 19;
            this.labwritecnt.Text = "0";
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.label13.ForeColor = System.Drawing.Color.Red;
            this.label13.Location = new System.Drawing.Point(180, 182);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(80, 16);
            this.label13.TabIndex = 18;
            this.label13.Text = "OpTimes:";
            // 
            // btnstop
            // 
            this.btnstop.Location = new System.Drawing.Point(125, 177);
            this.btnstop.Name = "btnstop";
            this.btnstop.Size = new System.Drawing.Size(54, 23);
            this.btnstop.TabIndex = 17;
            this.btnstop.Text = "stop";
            this.btnstop.UseVisualStyleBackColor = true;
            this.btnstop.Click += new System.EventHandler(this.btnstop_Click);
            // 
            // btnConwirte
            // 
            this.btnConwirte.Location = new System.Drawing.Point(6, 177);
            this.btnConwirte.Name = "btnConwirte";
            this.btnConwirte.Size = new System.Drawing.Size(87, 23);
            this.btnConwirte.TabIndex = 16;
            this.btnConwirte.Text = "repeat wirte";
            this.btnConwirte.UseVisualStyleBackColor = true;
            this.btnConwirte.Click += new System.EventHandler(this.btnConwirte_Click);
            // 
            // btnWriteEpc
            // 
            this.btnWriteEpc.Location = new System.Drawing.Point(275, 147);
            this.btnWriteEpc.Name = "btnWriteEpc";
            this.btnWriteEpc.Size = new System.Drawing.Size(66, 23);
            this.btnWriteEpc.TabIndex = 15;
            this.btnWriteEpc.Text = "writeEPC";
            this.btnWriteEpc.UseVisualStyleBackColor = true;
            this.btnWriteEpc.Click += new System.EventHandler(this.btnWriteEpc_Click);
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(15, 17);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(71, 12);
            this.label10.TabIndex = 14;
            this.label10.Text = "lock region";
            // 
            // cbblockunit
            // 
            this.cbblockunit.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbblockunit.FormattingEnabled = true;
            this.cbblockunit.Items.AddRange(new object[] {
            "AccessPwd",
            "KillPwd",
            "EPCBank",
            "TIDBank",
            "USERBank"});
            this.cbblockunit.Location = new System.Drawing.Point(91, 14);
            this.cbblockunit.Name = "cbblockunit";
            this.cbblockunit.Size = new System.Drawing.Size(81, 20);
            this.cbblockunit.TabIndex = 15;
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Location = new System.Drawing.Point(194, 17);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(59, 12);
            this.label11.TabIndex = 16;
            this.label11.Text = "lock type";
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.cbblocktype);
            this.groupBox3.Controls.Add(this.label11);
            this.groupBox3.Controls.Add(this.label10);
            this.groupBox3.Controls.Add(this.cbblockunit);
            this.groupBox3.Location = new System.Drawing.Point(12, 181);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(347, 45);
            this.groupBox3.TabIndex = 16;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "lock setting";
            // 
            // cbblocktype
            // 
            this.cbblocktype.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbblocktype.FormattingEnabled = true;
            this.cbblocktype.Items.AddRange(new object[] {
            "Unlock",
            "TempLock",
            "PermLock"});
            this.cbblocktype.Location = new System.Drawing.Point(259, 14);
            this.cbblocktype.Name = "cbblocktype";
            this.cbblocktype.Size = new System.Drawing.Size(73, 20);
            this.cbblocktype.TabIndex = 17;
            // 
            // groupBox4
            // 
            this.groupBox4.Controls.Add(this.btnpermblkget);
            this.groupBox4.Controls.Add(this.tbblkrange);
            this.groupBox4.Controls.Add(this.label18);
            this.groupBox4.Controls.Add(this.tbblkstart);
            this.groupBox4.Controls.Add(this.label17);
            this.groupBox4.Controls.Add(this.label16);
            this.groupBox4.Controls.Add(this.cb8);
            this.groupBox4.Controls.Add(this.cb7);
            this.groupBox4.Controls.Add(this.cb6);
            this.groupBox4.Controls.Add(this.cb5);
            this.groupBox4.Controls.Add(this.cb4);
            this.groupBox4.Controls.Add(this.cb3);
            this.groupBox4.Controls.Add(this.cb2);
            this.groupBox4.Controls.Add(this.cb1);
            this.groupBox4.Controls.Add(this.btnpermblklock);
            this.groupBox4.Location = new System.Drawing.Point(12, 485);
            this.groupBox4.Name = "groupBox4";
            this.groupBox4.Size = new System.Drawing.Size(347, 65);
            this.groupBox4.TabIndex = 17;
            this.groupBox4.TabStop = false;
            this.groupBox4.Text = "permanent block lock";
            // 
            // btnpermblkget
            // 
            this.btnpermblkget.Location = new System.Drawing.Point(282, 11);
            this.btnpermblkget.Name = "btnpermblkget";
            this.btnpermblkget.Size = new System.Drawing.Size(54, 23);
            this.btnpermblkget.TabIndex = 23;
            this.btnpermblkget.Text = "get";
            this.btnpermblkget.UseVisualStyleBackColor = true;
            this.btnpermblkget.Click += new System.EventHandler(this.btnpermblkget_Click);
            // 
            // tbblkrange
            // 
            this.tbblkrange.Location = new System.Drawing.Point(232, 37);
            this.tbblkrange.Name = "tbblkrange";
            this.tbblkrange.Size = new System.Drawing.Size(42, 21);
            this.tbblkrange.TabIndex = 22;
            this.tbblkrange.Text = "1";
            // 
            // label18
            // 
            this.label18.AutoSize = true;
            this.label18.Location = new System.Drawing.Point(163, 41);
            this.label18.Name = "label18";
            this.label18.Size = new System.Drawing.Size(65, 12);
            this.label18.TabIndex = 21;
            this.label18.Text = "BlockRange";
            // 
            // tbblkstart
            // 
            this.tbblkstart.Location = new System.Drawing.Point(232, 12);
            this.tbblkstart.Name = "tbblkstart";
            this.tbblkstart.Size = new System.Drawing.Size(42, 21);
            this.tbblkstart.TabIndex = 20;
            this.tbblkstart.Text = "0";
            // 
            // label17
            // 
            this.label17.AutoSize = true;
            this.label17.Location = new System.Drawing.Point(163, 18);
            this.label17.Name = "label17";
            this.label17.Size = new System.Drawing.Size(65, 12);
            this.label17.TabIndex = 19;
            this.label17.Text = "StartBlock";
            // 
            // label16
            // 
            this.label16.AutoSize = true;
            this.label16.Location = new System.Drawing.Point(9, 39);
            this.label16.Name = "label16";
            this.label16.Size = new System.Drawing.Size(137, 12);
            this.label16.TabIndex = 18;
            this.label16.Text = "1  2  3  4  5  6  7  8";
            // 
            // cb8
            // 
            this.cb8.AutoSize = true;
            this.cb8.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cb8.Location = new System.Drawing.Point(135, 20);
            this.cb8.Name = "cb8";
            this.cb8.Size = new System.Drawing.Size(12, 11);
            this.cb8.TabIndex = 17;
            this.cb8.UseVisualStyleBackColor = true;
            // 
            // cb7
            // 
            this.cb7.AutoSize = true;
            this.cb7.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cb7.Location = new System.Drawing.Point(117, 20);
            this.cb7.Name = "cb7";
            this.cb7.Size = new System.Drawing.Size(12, 11);
            this.cb7.TabIndex = 16;
            this.cb7.UseVisualStyleBackColor = true;
            // 
            // cb6
            // 
            this.cb6.AutoSize = true;
            this.cb6.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cb6.Location = new System.Drawing.Point(98, 20);
            this.cb6.Name = "cb6";
            this.cb6.Size = new System.Drawing.Size(12, 11);
            this.cb6.TabIndex = 15;
            this.cb6.UseVisualStyleBackColor = true;
            // 
            // cb5
            // 
            this.cb5.AutoSize = true;
            this.cb5.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cb5.Location = new System.Drawing.Point(81, 20);
            this.cb5.Name = "cb5";
            this.cb5.Size = new System.Drawing.Size(12, 11);
            this.cb5.TabIndex = 14;
            this.cb5.UseVisualStyleBackColor = true;
            // 
            // cb4
            // 
            this.cb4.AutoSize = true;
            this.cb4.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cb4.Location = new System.Drawing.Point(63, 20);
            this.cb4.Name = "cb4";
            this.cb4.Size = new System.Drawing.Size(12, 11);
            this.cb4.TabIndex = 13;
            this.cb4.UseVisualStyleBackColor = true;
            // 
            // cb3
            // 
            this.cb3.AutoSize = true;
            this.cb3.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cb3.Location = new System.Drawing.Point(45, 20);
            this.cb3.Name = "cb3";
            this.cb3.Size = new System.Drawing.Size(12, 11);
            this.cb3.TabIndex = 12;
            this.cb3.UseVisualStyleBackColor = true;
            // 
            // cb2
            // 
            this.cb2.AutoSize = true;
            this.cb2.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cb2.Location = new System.Drawing.Point(27, 20);
            this.cb2.Name = "cb2";
            this.cb2.Size = new System.Drawing.Size(12, 11);
            this.cb2.TabIndex = 11;
            this.cb2.UseVisualStyleBackColor = true;
            // 
            // cb1
            // 
            this.cb1.AutoSize = true;
            this.cb1.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cb1.Location = new System.Drawing.Point(9, 20);
            this.cb1.Name = "cb1";
            this.cb1.Size = new System.Drawing.Size(12, 11);
            this.cb1.TabIndex = 10;
            this.cb1.UseVisualStyleBackColor = true;
            // 
            // btnpermblklock
            // 
            this.btnpermblklock.Location = new System.Drawing.Point(282, 36);
            this.btnpermblklock.Name = "btnpermblklock";
            this.btnpermblklock.Size = new System.Drawing.Size(54, 23);
            this.btnpermblklock.TabIndex = 0;
            this.btnpermblklock.Text = "lock";
            this.btnpermblklock.UseVisualStyleBackColor = true;
            this.btnpermblklock.Click += new System.EventHandler(this.btnpermblklock_Click);
            // 
            // gen2opForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(373, 562);
            this.Controls.Add(this.groupBox4);
            this.Controls.Add(this.groupBox3);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox1);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "gen2opForm";
            this.Text = "tag operations";
            this.Load += new System.EventHandler(this.opForm_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            this.groupBox4.ResumeLayout(false);
            this.groupBox4.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox cbbopbank;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox tbaccesspasswd;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.TextBox tbfldata;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.RichTextBox rtbdata;
        private System.Windows.Forms.Button btnread;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox tbstartaddr;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.TextBox tbblocks;
        private System.Windows.Forms.Button btnwrite;
        private System.Windows.Forms.Button btnlock;
        private System.Windows.Forms.Button btnkill;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.TextBox tbkillpasswd;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.ComboBox cbblockunit;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.ComboBox cbblocktype;
        private System.Windows.Forms.CheckBox cbisfilter;
        private System.Windows.Forms.CheckBox cbisaccesspasswd;
        private System.Windows.Forms.RadioButton rbant2;
        private System.Windows.Forms.RadioButton rbant1;
        private System.Windows.Forms.RadioButton rbant4;
        private System.Windows.Forms.RadioButton rbant3;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.ComboBox cbbfilterbank;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox tbfilteraddr;
        private System.Windows.Forms.ComboBox cbbfilterrule;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.Button btnWriteEpc;
        private System.Windows.Forms.Button btnConwirte;
        private System.Windows.Forms.Button btnstop;
        private System.Windows.Forms.Label labavewtime;
        private System.Windows.Forms.Label label15;
        private System.Windows.Forms.Label labwritecnt;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.Button btnstopread;
        private System.Windows.Forms.Button btnconread;
        private System.Windows.Forms.TextBox tb16antssel;
        private System.Windows.Forms.Label label14;
        private System.Windows.Forms.GroupBox groupBox4;
        private System.Windows.Forms.Label label16;
        private System.Windows.Forms.CheckBox cb8;
        private System.Windows.Forms.CheckBox cb7;
        private System.Windows.Forms.CheckBox cb6;
        private System.Windows.Forms.CheckBox cb5;
        private System.Windows.Forms.CheckBox cb4;
        private System.Windows.Forms.CheckBox cb3;
        private System.Windows.Forms.CheckBox cb2;
        private System.Windows.Forms.CheckBox cb1;
        private System.Windows.Forms.Button btnpermblklock;
        private System.Windows.Forms.Button btnpermblkget;
        private System.Windows.Forms.TextBox tbblkrange;
        private System.Windows.Forms.Label label18;
        private System.Windows.Forms.TextBox tbblkstart;
        private System.Windows.Forms.Label label17;
    }
}