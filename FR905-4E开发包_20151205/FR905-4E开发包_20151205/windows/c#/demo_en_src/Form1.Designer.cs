namespace ModuleReaderManager
{
    partial class Form1
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
            this.components = new System.ComponentModel.Container();
            this.btnconnect = new System.Windows.Forms.Button();
            this.tbip = new System.Windows.Forms.TextBox();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.labreadtime = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.labant4cnt = new System.Windows.Forms.Label();
            this.label11 = new System.Windows.Forms.Label();
            this.labant3cnt = new System.Windows.Forms.Label();
            this.label9 = new System.Windows.Forms.Label();
            this.labtotalcnt = new System.Windows.Forms.Label();
            this.label10 = new System.Windows.Forms.Label();
            this.labant2cnt = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.labant1cnt = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.btnstart = new System.Windows.Forms.Button();
            this.btnstop = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.button1 = new System.Windows.Forms.Button();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.toolStripStatusLabel1 = new System.Windows.Forms.ToolStripStatusLabel();
            this.cbant4 = new System.Windows.Forms.CheckBox();
            this.cbant3 = new System.Windows.Forms.CheckBox();
            this.cbant2 = new System.Windows.Forms.CheckBox();
            this.cbant1 = new System.Windows.Forms.CheckBox();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.btndisconnect = new System.Windows.Forms.Button();
            this.cbbreadertype = new System.Windows.Forms.ComboBox();
            this.label4 = new System.Windows.Forms.Label();
            this.btnInvParas = new System.Windows.Forms.Button();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.readparamenu = new System.Windows.Forms.ToolStripMenuItem();
            this.tagopmenu = new System.Windows.Forms.ToolStripMenuItem();
            this.gen2tagopMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.iso183k6btagopToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.CountTagMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.menuitlongtask = new System.Windows.Forms.ToolStripMenuItem();
            this.updatemenu = new System.Windows.Forms.ToolStripMenuItem();
            this.Custommenu = new System.Windows.Forms.ToolStripMenuItem();
            this.menutest = new System.Windows.Forms.ToolStripMenuItem();
            this.menuabout = new System.Windows.Forms.ToolStripMenuItem();
            this.menuitemlog = new System.Windows.Forms.ToolStripMenuItem();
            this.menuoutputtags = new System.Windows.Forms.ToolStripMenuItem();
            this.cbpotl6b = new System.Windows.Forms.CheckBox();
            this.cbpotlgen2 = new System.Windows.Forms.CheckBox();
            this.rtbopfailmsg = new System.Windows.Forms.RichTextBox();
            this.cbpotlipx64 = new System.Windows.Forms.CheckBox();
            this.cbpotlipx256 = new System.Windows.Forms.CheckBox();
            this.btn16portsSet = new System.Windows.Forms.Button();
            this.lvTags = new ModuleReaderManager.DoubleBufferListView();
            this.columnHeader1 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader2 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader3 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader4 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader5 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader6 = new System.Windows.Forms.ColumnHeader();
            this.groupBox2.SuspendLayout();
            this.statusStrip1.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.menuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // btnconnect
            // 
            this.btnconnect.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnconnect.Location = new System.Drawing.Point(6, 87);
            this.btnconnect.Name = "btnconnect";
            this.btnconnect.Size = new System.Drawing.Size(85, 30);
            this.btnconnect.TabIndex = 4;
            this.btnconnect.Text = "Connect";
            this.btnconnect.UseVisualStyleBackColor = true;
            this.btnconnect.Click += new System.EventHandler(this.btnconnect_Click);
            // 
            // tbip
            // 
            this.tbip.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.tbip.Location = new System.Drawing.Point(97, 22);
            this.tbip.Name = "tbip";
            this.tbip.Size = new System.Drawing.Size(137, 23);
            this.tbip.TabIndex = 5;
            this.tbip.Text = "192.168.1.100";
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.labreadtime);
            this.groupBox2.Controls.Add(this.label2);
            this.groupBox2.Controls.Add(this.labant4cnt);
            this.groupBox2.Controls.Add(this.label11);
            this.groupBox2.Controls.Add(this.labant3cnt);
            this.groupBox2.Controls.Add(this.label9);
            this.groupBox2.Controls.Add(this.labtotalcnt);
            this.groupBox2.Controls.Add(this.label10);
            this.groupBox2.Controls.Add(this.labant2cnt);
            this.groupBox2.Controls.Add(this.label8);
            this.groupBox2.Controls.Add(this.labant1cnt);
            this.groupBox2.Controls.Add(this.label3);
            this.groupBox2.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.groupBox2.Location = new System.Drawing.Point(9, 329);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(239, 138);
            this.groupBox2.TabIndex = 6;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Inventory Stat.";
            // 
            // labreadtime
            // 
            this.labreadtime.AutoSize = true;
            this.labreadtime.Location = new System.Drawing.Point(81, 109);
            this.labreadtime.Name = "labreadtime";
            this.labreadtime.Size = new System.Drawing.Size(24, 17);
            this.labreadtime.TabIndex = 18;
            this.labreadtime.Text = "    ";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(8, 109);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(76, 17);
            this.label2.TabIndex = 17;
            this.label2.Text = "Duration：";
            // 
            // labant4cnt
            // 
            this.labant4cnt.AutoSize = true;
            this.labant4cnt.Location = new System.Drawing.Point(59, 75);
            this.labant4cnt.Name = "labant4cnt";
            this.labant4cnt.Size = new System.Drawing.Size(16, 17);
            this.labant4cnt.TabIndex = 14;
            this.labant4cnt.Text = "0";
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Location = new System.Drawing.Point(7, 75);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(40, 17);
            this.label11.TabIndex = 16;
            this.label11.Text = "ant4:";
            // 
            // labant3cnt
            // 
            this.labant3cnt.AutoSize = true;
            this.labant3cnt.Location = new System.Drawing.Point(198, 32);
            this.labant3cnt.Name = "labant3cnt";
            this.labant3cnt.Size = new System.Drawing.Size(16, 17);
            this.labant3cnt.TabIndex = 14;
            this.labant3cnt.Text = "0";
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(156, 32);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(40, 17);
            this.label9.TabIndex = 14;
            this.label9.Text = "ant3:";
            // 
            // labtotalcnt
            // 
            this.labtotalcnt.AutoSize = true;
            this.labtotalcnt.Font = new System.Drawing.Font("Microsoft Sans Serif", 15F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.labtotalcnt.ForeColor = System.Drawing.Color.Red;
            this.labtotalcnt.Location = new System.Drawing.Point(184, 72);
            this.labtotalcnt.Name = "labtotalcnt";
            this.labtotalcnt.Size = new System.Drawing.Size(24, 25);
            this.labtotalcnt.TabIndex = 12;
            this.labtotalcnt.Text = "0";
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(95, 75);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(104, 17);
            this.label10.TabIndex = 12;
            this.label10.Text = "TotalNumber：";
            // 
            // labant2cnt
            // 
            this.labant2cnt.AutoSize = true;
            this.labant2cnt.Location = new System.Drawing.Point(126, 33);
            this.labant2cnt.Name = "labant2cnt";
            this.labant2cnt.Size = new System.Drawing.Size(16, 17);
            this.labant2cnt.TabIndex = 15;
            this.labant2cnt.Text = "0";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(81, 33);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(40, 17);
            this.label8.TabIndex = 14;
            this.label8.Text = "ant2:";
            // 
            // labant1cnt
            // 
            this.labant1cnt.AutoSize = true;
            this.labant1cnt.Location = new System.Drawing.Point(54, 33);
            this.labant1cnt.Name = "labant1cnt";
            this.labant1cnt.Size = new System.Drawing.Size(16, 17);
            this.labant1cnt.TabIndex = 13;
            this.labant1cnt.Text = "0";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(7, 33);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(40, 17);
            this.label3.TabIndex = 12;
            this.label3.Text = "ant1:";
            // 
            // btnstart
            // 
            this.btnstart.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnstart.ForeColor = System.Drawing.Color.Black;
            this.btnstart.Location = new System.Drawing.Point(5, 291);
            this.btnstart.Name = "btnstart";
            this.btnstart.Size = new System.Drawing.Size(98, 30);
            this.btnstart.TabIndex = 7;
            this.btnstart.Text = "Inventory";
            this.btnstart.UseVisualStyleBackColor = true;
            this.btnstart.Click += new System.EventHandler(this.btnstart_Click);
            // 
            // btnstop
            // 
            this.btnstop.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnstop.Location = new System.Drawing.Point(117, 291);
            this.btnstop.Name = "btnstop";
            this.btnstop.Size = new System.Drawing.Size(57, 30);
            this.btnstop.TabIndex = 8;
            this.btnstop.Text = "Stop";
            this.btnstop.UseVisualStyleBackColor = true;
            this.btnstop.Click += new System.EventHandler(this.btnstop_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.5F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.label1.Location = new System.Drawing.Point(10, 25);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(71, 17);
            this.label1.TabIndex = 3;
            this.label1.Text = "address:";
            // 
            // button1
            // 
            this.button1.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.button1.Location = new System.Drawing.Point(186, 291);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(63, 30);
            this.button1.TabIndex = 9;
            this.button1.Text = "Clear";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // timer1
            // 
            this.timer1.Interval = 700;
            this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
            // 
            // statusStrip1
            // 
            this.statusStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripStatusLabel1});
            this.statusStrip1.Location = new System.Drawing.Point(0, 572);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.Size = new System.Drawing.Size(959, 22);
            this.statusStrip1.TabIndex = 11;
            this.statusStrip1.Text = "statusStrip1";
            // 
            // toolStripStatusLabel1
            // 
            this.toolStripStatusLabel1.Name = "toolStripStatusLabel1";
            this.toolStripStatusLabel1.Size = new System.Drawing.Size(131, 17);
            this.toolStripStatusLabel1.Text = "toolStripStatusLabel1";
            // 
            // cbant4
            // 
            this.cbant4.AutoSize = true;
            this.cbant4.Enabled = false;
            this.cbant4.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.cbant4.Location = new System.Drawing.Point(72, 77);
            this.cbant4.Name = "cbant4";
            this.cbant4.Size = new System.Drawing.Size(63, 21);
            this.cbant4.TabIndex = 16;
            this.cbant4.Text = "ANT4";
            this.cbant4.UseVisualStyleBackColor = true;
            // 
            // cbant3
            // 
            this.cbant3.AutoSize = true;
            this.cbant3.Enabled = false;
            this.cbant3.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.cbant3.Location = new System.Drawing.Point(12, 77);
            this.cbant3.Name = "cbant3";
            this.cbant3.Size = new System.Drawing.Size(63, 21);
            this.cbant3.TabIndex = 15;
            this.cbant3.Text = "ANT3";
            this.cbant3.UseVisualStyleBackColor = true;
            // 
            // cbant2
            // 
            this.cbant2.AutoSize = true;
            this.cbant2.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.cbant2.Location = new System.Drawing.Point(72, 38);
            this.cbant2.Name = "cbant2";
            this.cbant2.Size = new System.Drawing.Size(63, 21);
            this.cbant2.TabIndex = 14;
            this.cbant2.Text = "ANT2";
            this.cbant2.UseVisualStyleBackColor = true;
            // 
            // cbant1
            // 
            this.cbant1.AutoSize = true;
            this.cbant1.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.cbant1.Location = new System.Drawing.Point(12, 38);
            this.cbant1.Name = "cbant1";
            this.cbant1.Size = new System.Drawing.Size(63, 21);
            this.cbant1.TabIndex = 13;
            this.cbant1.Text = "ANT1";
            this.cbant1.UseVisualStyleBackColor = true;
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.btndisconnect);
            this.groupBox3.Controls.Add(this.cbbreadertype);
            this.groupBox3.Controls.Add(this.label4);
            this.groupBox3.Controls.Add(this.btnconnect);
            this.groupBox3.Controls.Add(this.label1);
            this.groupBox3.Controls.Add(this.tbip);
            this.groupBox3.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.groupBox3.Location = new System.Drawing.Point(5, 148);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(243, 129);
            this.groupBox3.TabIndex = 13;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "Connect Setting";
            // 
            // btndisconnect
            // 
            this.btndisconnect.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btndisconnect.Location = new System.Drawing.Point(123, 87);
            this.btndisconnect.Name = "btndisconnect";
            this.btndisconnect.Size = new System.Drawing.Size(108, 30);
            this.btndisconnect.TabIndex = 16;
            this.btndisconnect.Text = "Disconnect";
            this.btndisconnect.UseVisualStyleBackColor = true;
            this.btndisconnect.Click += new System.EventHandler(this.btndisconnect_Click);
            // 
            // cbbreadertype
            // 
            this.cbbreadertype.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbbreadertype.FormattingEnabled = true;
            this.cbbreadertype.Items.AddRange(new object[] {
            "1 Antenna",
            "2 Antennas",
            "3 Antennas",
            "4 Antennas",
            "16 Antennas"});
            this.cbbreadertype.Location = new System.Drawing.Point(97, 58);
            this.cbbreadertype.Name = "cbbreadertype";
            this.cbbreadertype.Size = new System.Drawing.Size(136, 25);
            this.cbbreadertype.TabIndex = 14;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(7, 61);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(88, 17);
            this.label4.TabIndex = 15;
            this.label4.Text = "ReaderPorts";
            // 
            // btnInvParas
            // 
            this.btnInvParas.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnInvParas.Location = new System.Drawing.Point(159, 38);
            this.btnInvParas.Name = "btnInvParas";
            this.btnInvParas.Size = new System.Drawing.Size(96, 30);
            this.btnInvParas.TabIndex = 17;
            this.btnInvParas.Text = "Parameters...";
            this.btnInvParas.UseVisualStyleBackColor = true;
            this.btnInvParas.Click += new System.EventHandler(this.btnInvParas_Click);
            // 
            // menuStrip1
            // 
            this.menuStrip1.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.readparamenu,
            this.tagopmenu,
            this.updatemenu,
            this.Custommenu,
            this.menutest,
            this.menuabout,
            this.menuitemlog,
            this.menuoutputtags});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(959, 28);
            this.menuStrip1.TabIndex = 19;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // readparamenu
            // 
            this.readparamenu.Name = "readparamenu";
            this.readparamenu.Size = new System.Drawing.Size(132, 24);
            this.readparamenu.Text = "ReaderConfig";
            this.readparamenu.Click += new System.EventHandler(this.readparamenu_Click);
            // 
            // tagopmenu
            // 
            this.tagopmenu.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.gen2tagopMenuItem,
            this.iso183k6btagopToolStripMenuItem,
            this.CountTagMenuItem,
            this.menuitlongtask});
            this.tagopmenu.Name = "tagopmenu";
            this.tagopmenu.Size = new System.Drawing.Size(130, 24);
            this.tagopmenu.Text = "TagOperation";
            // 
            // gen2tagopMenuItem
            // 
            this.gen2tagopMenuItem.Name = "gen2tagopMenuItem";
            this.gen2tagopMenuItem.Size = new System.Drawing.Size(259, 24);
            this.gen2tagopMenuItem.Text = "Gen2TagOperation";
            this.gen2tagopMenuItem.Click += new System.EventHandler(this.gen2tagopMenuItem_Click);
            // 
            // iso183k6btagopToolStripMenuItem
            // 
            this.iso183k6btagopToolStripMenuItem.Name = "iso183k6btagopToolStripMenuItem";
            this.iso183k6btagopToolStripMenuItem.Size = new System.Drawing.Size(259, 24);
            this.iso183k6btagopToolStripMenuItem.Text = "180006BTagOperation";
            this.iso183k6btagopToolStripMenuItem.Click += new System.EventHandler(this.iso183k6btagopToolStripMenuItem_Click);
            // 
            // CountTagMenuItem
            // 
            this.CountTagMenuItem.Name = "CountTagMenuItem";
            this.CountTagMenuItem.Size = new System.Drawing.Size(259, 24);
            this.CountTagMenuItem.Text = "CountTags";
            this.CountTagMenuItem.Click += new System.EventHandler(this.CountTagMenuItem_Click);
            // 
            // menuitlongtask
            // 
            this.menuitlongtask.Name = "menuitlongtask";
            this.menuitlongtask.Size = new System.Drawing.Size(259, 24);
            this.menuitlongtask.Text = "LongTask";
            this.menuitlongtask.Click += new System.EventHandler(this.menuitlongtask_Click);
            // 
            // updatemenu
            // 
            this.updatemenu.Name = "updatemenu";
            this.updatemenu.Size = new System.Drawing.Size(153, 24);
            this.updatemenu.Text = "FirmwareUpdate";
            this.updatemenu.Click += new System.EventHandler(this.updatemenu_Click);
            // 
            // Custommenu
            // 
            this.Custommenu.Name = "Custommenu";
            this.Custommenu.Size = new System.Drawing.Size(142, 24);
            this.Custommenu.Text = "PrivateTagCmd";
            this.Custommenu.Click += new System.EventHandler(this.Custommenu_Click);
            // 
            // menutest
            // 
            this.menutest.Name = "menutest";
            this.menutest.Size = new System.Drawing.Size(143, 24);
            this.menutest.Text = "RegulatoryTest";
            this.menutest.Click += new System.EventHandler(this.menutest_Click);
            // 
            // menuabout
            // 
            this.menuabout.Name = "menuabout";
            this.menuabout.Size = new System.Drawing.Size(69, 24);
            this.menuabout.Text = "About";
            this.menuabout.Click += new System.EventHandler(this.menuabout_Click);
            // 
            // menuitemlog
            // 
            this.menuitemlog.Name = "menuitemlog";
            this.menuitemlog.Size = new System.Drawing.Size(51, 24);
            this.menuitemlog.Text = "Log";
            this.menuitemlog.Click += new System.EventHandler(this.menuitemlog_Click);
            // 
            // menuoutputtags
            // 
            this.menuoutputtags.Name = "menuoutputtags";
            this.menuoutputtags.Size = new System.Drawing.Size(106, 24);
            this.menuoutputtags.Text = "TagOutput";
            this.menuoutputtags.Click += new System.EventHandler(this.menuoutputtags_Click);
            // 
            // cbpotl6b
            // 
            this.cbpotl6b.AutoSize = true;
            this.cbpotl6b.Location = new System.Drawing.Point(61, 118);
            this.cbpotl6b.Name = "cbpotl6b";
            this.cbpotl6b.Size = new System.Drawing.Size(66, 16);
            this.cbpotl6b.TabIndex = 20;
            this.cbpotl6b.Text = "180006b";
            this.cbpotl6b.UseVisualStyleBackColor = true;
            // 
            // cbpotlgen2
            // 
            this.cbpotlgen2.AutoSize = true;
            this.cbpotlgen2.Location = new System.Drawing.Point(11, 118);
            this.cbpotlgen2.Name = "cbpotlgen2";
            this.cbpotlgen2.Size = new System.Drawing.Size(48, 16);
            this.cbpotlgen2.TabIndex = 21;
            this.cbpotlgen2.Text = "gen2";
            this.cbpotlgen2.UseVisualStyleBackColor = true;
            // 
            // rtbopfailmsg
            // 
            this.rtbopfailmsg.Location = new System.Drawing.Point(9, 479);
            this.rtbopfailmsg.Name = "rtbopfailmsg";
            this.rtbopfailmsg.Size = new System.Drawing.Size(239, 95);
            this.rtbopfailmsg.TabIndex = 23;
            this.rtbopfailmsg.Text = "";
            // 
            // cbpotlipx64
            // 
            this.cbpotlipx64.AutoSize = true;
            this.cbpotlipx64.Location = new System.Drawing.Point(128, 118);
            this.cbpotlipx64.Name = "cbpotlipx64";
            this.cbpotlipx64.Size = new System.Drawing.Size(54, 16);
            this.cbpotlipx64.TabIndex = 24;
            this.cbpotlipx64.Text = "ipx64";
            this.cbpotlipx64.UseVisualStyleBackColor = true;
            // 
            // cbpotlipx256
            // 
            this.cbpotlipx256.AutoSize = true;
            this.cbpotlipx256.Location = new System.Drawing.Point(182, 118);
            this.cbpotlipx256.Name = "cbpotlipx256";
            this.cbpotlipx256.Size = new System.Drawing.Size(60, 16);
            this.cbpotlipx256.TabIndex = 25;
            this.cbpotlipx256.Text = "ipx256";
            this.cbpotlipx256.UseVisualStyleBackColor = true;
            // 
            // btn16portsSet
            // 
            this.btn16portsSet.Location = new System.Drawing.Point(159, 74);
            this.btn16portsSet.Name = "btn16portsSet";
            this.btn16portsSet.Size = new System.Drawing.Size(96, 33);
            this.btn16portsSet.TabIndex = 26;
            this.btn16portsSet.Text = "16ants Setting";
            this.btn16portsSet.UseVisualStyleBackColor = true;
            this.btn16portsSet.Click += new System.EventHandler(this.btn16portsSet_Click);
            // 
            // lvTags
            // 
            this.lvTags.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeader1,
            this.columnHeader2,
            this.columnHeader3,
            this.columnHeader4,
            this.columnHeader5,
            this.columnHeader6});
            this.lvTags.Dock = System.Windows.Forms.DockStyle.Right;
            this.lvTags.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lvTags.GridLines = true;
            this.lvTags.Location = new System.Drawing.Point(261, 28);
            this.lvTags.Name = "lvTags";
            this.lvTags.Size = new System.Drawing.Size(698, 544);
            this.lvTags.TabIndex = 18;
            this.lvTags.UseCompatibleStateImageBehavior = false;
            this.lvTags.View = System.Windows.Forms.View.Details;
            this.lvTags.ColumnClick += new System.Windows.Forms.ColumnClickEventHandler(this.lvTags_ColumnClick);
            // 
            // columnHeader1
            // 
            this.columnHeader1.Text = "NO.";
            this.columnHeader1.Width = 46;
            // 
            // columnHeader2
            // 
            this.columnHeader2.Text = "ReadCount";
            this.columnHeader2.Width = 71;
            // 
            // columnHeader3
            // 
            this.columnHeader3.Text = "EPC ID";
            this.columnHeader3.Width = 273;
            // 
            // columnHeader4
            // 
            this.columnHeader4.Text = "Ant";
            this.columnHeader4.Width = 51;
            // 
            // columnHeader5
            // 
            this.columnHeader5.Text = "EmbeddedData";
            this.columnHeader5.Width = 116;
            // 
            // columnHeader6
            // 
            this.columnHeader6.Text = "Protocol";
            this.columnHeader6.Width = 123;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(959, 594);
            this.Controls.Add(this.btn16portsSet);
            this.Controls.Add(this.cbpotlipx256);
            this.Controls.Add(this.cbpotlipx64);
            this.Controls.Add(this.rtbopfailmsg);
            this.Controls.Add(this.cbpotlgen2);
            this.Controls.Add(this.cbpotl6b);
            this.Controls.Add(this.lvTags);
            this.Controls.Add(this.btnInvParas);
            this.Controls.Add(this.cbant4);
            this.Controls.Add(this.groupBox3);
            this.Controls.Add(this.cbant3);
            this.Controls.Add(this.cbant2);
            this.Controls.Add(this.statusStrip1);
            this.Controls.Add(this.menuStrip1);
            this.Controls.Add(this.cbant1);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.btnstop);
            this.Controls.Add(this.btnstart);
            this.Controls.Add(this.groupBox2);
            this.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.ForeColor = System.Drawing.Color.Black;
            this.MainMenuStrip = this.menuStrip1;
            this.MaximizeBox = false;
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "ModuleReaderManager";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Form1_FormClosing);
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.statusStrip1.ResumeLayout(false);
            this.statusStrip1.PerformLayout();
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnconnect;
        private System.Windows.Forms.TextBox tbip;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.Button btnstart;
        private System.Windows.Forms.Button btnstop;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Timer timer1;
        private System.Windows.Forms.StatusStrip statusStrip1;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Label labant2cnt;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label labant1cnt;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label labtotalcnt;
        private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabel1;
        private System.Windows.Forms.CheckBox cbant2;
        private System.Windows.Forms.CheckBox cbant1;
        private System.Windows.Forms.CheckBox cbant4;
        private System.Windows.Forms.CheckBox cbant3;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.ComboBox cbbreadertype;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label labant3cnt;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Label labant4cnt;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.Button btndisconnect;
        private System.Windows.Forms.Button btnInvParas;
        private ModuleReaderManager.DoubleBufferListView lvTags;
        private System.Windows.Forms.ColumnHeader columnHeader1;
        private System.Windows.Forms.ColumnHeader columnHeader2;
        private System.Windows.Forms.ColumnHeader columnHeader3;
        private System.Windows.Forms.ColumnHeader columnHeader4;
        private System.Windows.Forms.ColumnHeader columnHeader5;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem readparamenu;
        private System.Windows.Forms.ToolStripMenuItem tagopmenu;
        private System.Windows.Forms.ToolStripMenuItem updatemenu;
        private System.Windows.Forms.ToolStripMenuItem Custommenu;
        private System.Windows.Forms.ToolStripMenuItem menutest;
        private System.Windows.Forms.CheckBox cbpotl6b;
        private System.Windows.Forms.CheckBox cbpotlgen2;
        private System.Windows.Forms.RichTextBox rtbopfailmsg;
        private System.Windows.Forms.ToolStripMenuItem gen2tagopMenuItem;
        private System.Windows.Forms.ToolStripMenuItem iso183k6btagopToolStripMenuItem;
        private System.Windows.Forms.ColumnHeader columnHeader6;
        private System.Windows.Forms.Label labreadtime;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.CheckBox cbpotlipx64;
        private System.Windows.Forms.CheckBox cbpotlipx256;
        private System.Windows.Forms.ToolStripMenuItem CountTagMenuItem;
        private System.Windows.Forms.Button btn16portsSet;
        private System.Windows.Forms.ToolStripMenuItem menuitlongtask;
        private System.Windows.Forms.ToolStripMenuItem menuabout;
        private System.Windows.Forms.ToolStripMenuItem menuitemlog;
        private System.Windows.Forms.ToolStripMenuItem menuoutputtags;
    }
}

