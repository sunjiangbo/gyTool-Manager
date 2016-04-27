namespace EloamComDemo
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.openVideo = new System.Windows.Forms.Button();
            this.closeVideo = new System.Windows.Forms.Button();
            this.shoot = new System.Windows.Forms.Button();
            this.removeGround = new System.Windows.Forms.CheckBox();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.selectResolution = new System.Windows.Forms.ComboBox();
            this.groupBox6 = new System.Windows.Forms.GroupBox();
            this.rectify = new System.Windows.Forms.CheckBox();
            this.pictureSavePath = new System.Windows.Forms.TextBox();
            this.groupBox9 = new System.Windows.Forms.GroupBox();
            this.edit_Timer = new System.Windows.Forms.TextBox();
            this.textBox2 = new System.Windows.Forms.TextBox();
            this.openTimer = new System.Windows.Forms.CheckBox();
            this.groupBox10 = new System.Windows.Forms.GroupBox();
            this.compoundShoot = new System.Windows.Forms.CheckBox();
            this.openProperty = new System.Windows.Forms.Button();
            this.groupBox11 = new System.Windows.Forms.GroupBox();
            this.selectDevice = new System.Windows.Forms.ComboBox();
            this.groupBox12 = new System.Windows.Forms.GroupBox();
            this.selectMode = new System.Windows.Forms.ComboBox();
            this.exchangeLeftRight = new System.Windows.Forms.Button();
            this.turnLeft = new System.Windows.Forms.Button();
            this.exchangeUpDown = new System.Windows.Forms.Button();
            this.turnRight = new System.Windows.Forms.Button();
            this.groupBox8 = new System.Windows.Forms.GroupBox();
            this.groupBox13 = new System.Windows.Forms.GroupBox();
            this.autoShoot = new System.Windows.Forms.CheckBox();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.eloamView = new AxeloamComLib.AxEloamView();
            this.eloamThumbnail = new AxeloamComLib.AxEloamThumbnail();
            this.groupBox5 = new System.Windows.Forms.GroupBox();
            this.barcode = new System.Windows.Forms.CheckBox();
            this.button1 = new System.Windows.Forms.Button();
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.ddd = new System.Windows.Forms.ToolStripStatusLabel();
            this.sListenState = new System.Windows.Forms.ToolStripStatusLabel();
            this.toolStripStatusLabel1 = new System.Windows.Forms.ToolStripStatusLabel();
            this.toolStripStatusLabel2 = new System.Windows.Forms.ToolStripStatusLabel();
            this.sPort = new System.Windows.Forms.ToolStripStatusLabel();
            this.listView1 = new System.Windows.Forms.ListView();
            this.columnHeader1 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader2 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader3 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader4 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.button2 = new System.Windows.Forms.Button();
            this.groupBox1.SuspendLayout();
            this.groupBox6.SuspendLayout();
            this.groupBox9.SuspendLayout();
            this.groupBox10.SuspendLayout();
            this.groupBox11.SuspendLayout();
            this.groupBox12.SuspendLayout();
            this.groupBox8.SuspendLayout();
            this.groupBox13.SuspendLayout();
            this.groupBox2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.eloamView)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.eloamThumbnail)).BeginInit();
            this.groupBox5.SuspendLayout();
            this.statusStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // openVideo
            // 
            this.openVideo.Location = new System.Drawing.Point(633, 171);
            this.openVideo.Name = "openVideo";
            this.openVideo.Size = new System.Drawing.Size(130, 23);
            this.openVideo.TabIndex = 0;
            this.openVideo.Text = "打开视频";
            this.openVideo.UseVisualStyleBackColor = true;
            this.openVideo.Click += new System.EventHandler(this.openVideo_Click);
            // 
            // closeVideo
            // 
            this.closeVideo.Location = new System.Drawing.Point(633, 205);
            this.closeVideo.Name = "closeVideo";
            this.closeVideo.Size = new System.Drawing.Size(130, 23);
            this.closeVideo.TabIndex = 1;
            this.closeVideo.Text = "关闭视频";
            this.closeVideo.UseVisualStyleBackColor = true;
            this.closeVideo.Click += new System.EventHandler(this.closeVideo_Click);
            // 
            // shoot
            // 
            this.shoot.Location = new System.Drawing.Point(632, 551);
            this.shoot.Name = "shoot";
            this.shoot.Size = new System.Drawing.Size(130, 23);
            this.shoot.TabIndex = 4;
            this.shoot.Text = "拍摄";
            this.shoot.UseVisualStyleBackColor = true;
            this.shoot.Click += new System.EventHandler(this.shoot_Click);
            // 
            // removeGround
            // 
            this.removeGround.AutoSize = true;
            this.removeGround.Location = new System.Drawing.Point(3, 8);
            this.removeGround.Name = "removeGround";
            this.removeGround.Size = new System.Drawing.Size(60, 16);
            this.removeGround.TabIndex = 16;
            this.removeGround.Text = "去底色";
            this.removeGround.UseVisualStyleBackColor = true;
            this.removeGround.CheckedChanged += new System.EventHandler(this.removeGround_CheckedChanged);
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.selectResolution);
            this.groupBox1.Location = new System.Drawing.Point(633, 64);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(130, 48);
            this.groupBox1.TabIndex = 23;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "分辨率：";
            // 
            // selectResolution
            // 
            this.selectResolution.FormattingEnabled = true;
            this.selectResolution.Location = new System.Drawing.Point(8, 20);
            this.selectResolution.Name = "selectResolution";
            this.selectResolution.Size = new System.Drawing.Size(113, 20);
            this.selectResolution.TabIndex = 10;
            // 
            // groupBox6
            // 
            this.groupBox6.Controls.Add(this.rectify);
            this.groupBox6.Location = new System.Drawing.Point(632, 339);
            this.groupBox6.Name = "groupBox6";
            this.groupBox6.Size = new System.Drawing.Size(130, 30);
            this.groupBox6.TabIndex = 27;
            this.groupBox6.TabStop = false;
            // 
            // rectify
            // 
            this.rectify.AutoSize = true;
            this.rectify.Location = new System.Drawing.Point(3, 8);
            this.rectify.Name = "rectify";
            this.rectify.Size = new System.Drawing.Size(72, 16);
            this.rectify.TabIndex = 16;
            this.rectify.Text = "纠偏裁边";
            this.rectify.UseVisualStyleBackColor = true;
            this.rectify.CheckedChanged += new System.EventHandler(this.rectify_CheckedChanged);
            // 
            // pictureSavePath
            // 
            this.pictureSavePath.Location = new System.Drawing.Point(6, 19);
            this.pictureSavePath.Name = "pictureSavePath";
            this.pictureSavePath.Size = new System.Drawing.Size(130, 21);
            this.pictureSavePath.TabIndex = 22;
            // 
            // groupBox9
            // 
            this.groupBox9.Controls.Add(this.edit_Timer);
            this.groupBox9.Controls.Add(this.textBox2);
            this.groupBox9.Controls.Add(this.openTimer);
            this.groupBox9.Location = new System.Drawing.Point(632, 428);
            this.groupBox9.Name = "groupBox9";
            this.groupBox9.Size = new System.Drawing.Size(130, 36);
            this.groupBox9.TabIndex = 29;
            this.groupBox9.TabStop = false;
            // 
            // edit_Timer
            // 
            this.edit_Timer.Location = new System.Drawing.Point(74, 9);
            this.edit_Timer.MaxLength = 5;
            this.edit_Timer.Name = "edit_Timer";
            this.edit_Timer.Size = new System.Drawing.Size(34, 21);
            this.edit_Timer.TabIndex = 19;
            this.edit_Timer.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.edit_Timer.TextChanged += new System.EventHandler(this.edit_Timer_TextChanged);
            // 
            // textBox2
            // 
            this.textBox2.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.textBox2.Enabled = false;
            this.textBox2.Location = new System.Drawing.Point(103, 13);
            this.textBox2.Name = "textBox2";
            this.textBox2.ReadOnly = true;
            this.textBox2.Size = new System.Drawing.Size(28, 14);
            this.textBox2.TabIndex = 20;
            this.textBox2.Text = "秒";
            this.textBox2.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // openTimer
            // 
            this.openTimer.AutoSize = true;
            this.openTimer.Location = new System.Drawing.Point(3, 13);
            this.openTimer.Name = "openTimer";
            this.openTimer.Size = new System.Drawing.Size(72, 16);
            this.openTimer.TabIndex = 17;
            this.openTimer.Text = "定时拍照";
            this.openTimer.UseVisualStyleBackColor = true;
            this.openTimer.CheckedChanged += new System.EventHandler(this.openTimer_CheckedChanged);
            // 
            // groupBox10
            // 
            this.groupBox10.Controls.Add(this.compoundShoot);
            this.groupBox10.Location = new System.Drawing.Point(632, 459);
            this.groupBox10.Name = "groupBox10";
            this.groupBox10.Size = new System.Drawing.Size(130, 30);
            this.groupBox10.TabIndex = 29;
            this.groupBox10.TabStop = false;
            // 
            // compoundShoot
            // 
            this.compoundShoot.AutoSize = true;
            this.compoundShoot.Location = new System.Drawing.Point(3, 8);
            this.compoundShoot.Name = "compoundShoot";
            this.compoundShoot.Size = new System.Drawing.Size(72, 16);
            this.compoundShoot.TabIndex = 20;
            this.compoundShoot.Text = "智能合并";
            this.compoundShoot.UseVisualStyleBackColor = true;
            this.compoundShoot.CheckedChanged += new System.EventHandler(this.compoundShoot_CheckedChanged);
            // 
            // openProperty
            // 
            this.openProperty.Location = new System.Drawing.Point(633, 307);
            this.openProperty.Name = "openProperty";
            this.openProperty.Size = new System.Drawing.Size(130, 23);
            this.openProperty.TabIndex = 5;
            this.openProperty.Text = "属性";
            this.openProperty.UseVisualStyleBackColor = true;
            this.openProperty.Click += new System.EventHandler(this.openProperty_Click);
            // 
            // groupBox11
            // 
            this.groupBox11.Controls.Add(this.selectDevice);
            this.groupBox11.Location = new System.Drawing.Point(633, 9);
            this.groupBox11.Name = "groupBox11";
            this.groupBox11.Size = new System.Drawing.Size(130, 48);
            this.groupBox11.TabIndex = 24;
            this.groupBox11.TabStop = false;
            this.groupBox11.Text = "设备列表：";
            // 
            // selectDevice
            // 
            this.selectDevice.FormattingEnabled = true;
            this.selectDevice.Location = new System.Drawing.Point(8, 20);
            this.selectDevice.Name = "selectDevice";
            this.selectDevice.Size = new System.Drawing.Size(113, 20);
            this.selectDevice.TabIndex = 10;
            this.selectDevice.SelectedIndexChanged += new System.EventHandler(this.selectDevice_SelectedIndexChanged);
            // 
            // groupBox12
            // 
            this.groupBox12.Controls.Add(this.selectMode);
            this.groupBox12.Location = new System.Drawing.Point(633, 118);
            this.groupBox12.Name = "groupBox12";
            this.groupBox12.Size = new System.Drawing.Size(130, 48);
            this.groupBox12.TabIndex = 24;
            this.groupBox12.TabStop = false;
            this.groupBox12.Text = "模式：";
            // 
            // selectMode
            // 
            this.selectMode.FormattingEnabled = true;
            this.selectMode.Location = new System.Drawing.Point(8, 20);
            this.selectMode.Name = "selectMode";
            this.selectMode.Size = new System.Drawing.Size(113, 20);
            this.selectMode.TabIndex = 10;
            // 
            // exchangeLeftRight
            // 
            this.exchangeLeftRight.Location = new System.Drawing.Point(633, 268);
            this.exchangeLeftRight.Name = "exchangeLeftRight";
            this.exchangeLeftRight.Size = new System.Drawing.Size(62, 30);
            this.exchangeLeftRight.TabIndex = 31;
            this.exchangeLeftRight.Text = "左右";
            this.exchangeLeftRight.UseVisualStyleBackColor = true;
            this.exchangeLeftRight.Click += new System.EventHandler(this.exchangeLeftRight_Click);
            // 
            // turnLeft
            // 
            this.turnLeft.Location = new System.Drawing.Point(633, 234);
            this.turnLeft.Name = "turnLeft";
            this.turnLeft.Size = new System.Drawing.Size(62, 30);
            this.turnLeft.TabIndex = 30;
            this.turnLeft.Text = "左转";
            this.turnLeft.UseVisualStyleBackColor = true;
            this.turnLeft.Click += new System.EventHandler(this.turnLeft_Click);
            // 
            // exchangeUpDown
            // 
            this.exchangeUpDown.Location = new System.Drawing.Point(701, 267);
            this.exchangeUpDown.Name = "exchangeUpDown";
            this.exchangeUpDown.Size = new System.Drawing.Size(62, 30);
            this.exchangeUpDown.TabIndex = 33;
            this.exchangeUpDown.Text = "上下";
            this.exchangeUpDown.UseVisualStyleBackColor = true;
            this.exchangeUpDown.Click += new System.EventHandler(this.exchangeUpDown_Click);
            // 
            // turnRight
            // 
            this.turnRight.Location = new System.Drawing.Point(701, 233);
            this.turnRight.Name = "turnRight";
            this.turnRight.Size = new System.Drawing.Size(62, 30);
            this.turnRight.TabIndex = 32;
            this.turnRight.Text = "右转";
            this.turnRight.UseVisualStyleBackColor = true;
            this.turnRight.Click += new System.EventHandler(this.turnRight_Click);
            // 
            // groupBox8
            // 
            this.groupBox8.Controls.Add(this.pictureSavePath);
            this.groupBox8.Location = new System.Drawing.Point(632, 498);
            this.groupBox8.Name = "groupBox8";
            this.groupBox8.Size = new System.Drawing.Size(130, 45);
            this.groupBox8.TabIndex = 28;
            this.groupBox8.TabStop = false;
            this.groupBox8.Text = "拍照路径：";
            // 
            // groupBox13
            // 
            this.groupBox13.Controls.Add(this.removeGround);
            this.groupBox13.Location = new System.Drawing.Point(632, 370);
            this.groupBox13.Name = "groupBox13";
            this.groupBox13.Size = new System.Drawing.Size(130, 30);
            this.groupBox13.TabIndex = 28;
            this.groupBox13.TabStop = false;
            // 
            // autoShoot
            // 
            this.autoShoot.AutoSize = true;
            this.autoShoot.Location = new System.Drawing.Point(3, 8);
            this.autoShoot.Name = "autoShoot";
            this.autoShoot.Size = new System.Drawing.Size(72, 16);
            this.autoShoot.TabIndex = 34;
            this.autoShoot.Text = "自动连拍";
            this.autoShoot.UseVisualStyleBackColor = true;
            this.autoShoot.CheckedChanged += new System.EventHandler(this.autoShoot_CheckedChanged);
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.autoShoot);
            this.groupBox2.Location = new System.Drawing.Point(632, 403);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(130, 30);
            this.groupBox2.TabIndex = 30;
            this.groupBox2.TabStop = false;
            // 
            // eloamView
            // 
            this.eloamView.Enabled = true;
            this.eloamView.Location = new System.Drawing.Point(13, 13);
            this.eloamView.Name = "eloamView";
            this.eloamView.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("eloamView.OcxState")));
            this.eloamView.Size = new System.Drawing.Size(614, 317);
            this.eloamView.TabIndex = 34;
            this.eloamView.VideoAttach += new AxeloamComLib._IEloamViewEvents_VideoAttachEventHandler(this.eloamView_VideoAttach);
            // 
            // eloamThumbnail
            // 
            this.eloamThumbnail.Enabled = true;
            this.eloamThumbnail.Location = new System.Drawing.Point(310, 454);
            this.eloamThumbnail.Name = "eloamThumbnail";
            this.eloamThumbnail.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("eloamThumbnail.OcxState")));
            this.eloamThumbnail.Size = new System.Drawing.Size(192, 192);
            this.eloamThumbnail.TabIndex = 35;
            // 
            // groupBox5
            // 
            this.groupBox5.Controls.Add(this.barcode);
            this.groupBox5.Location = new System.Drawing.Point(782, 10);
            this.groupBox5.Name = "groupBox5";
            this.groupBox5.Size = new System.Drawing.Size(137, 43);
            this.groupBox5.TabIndex = 45;
            this.groupBox5.TabStop = false;
            // 
            // barcode
            // 
            this.barcode.AutoSize = true;
            this.barcode.Location = new System.Drawing.Point(10, 16);
            this.barcode.Name = "barcode";
            this.barcode.Size = new System.Drawing.Size(72, 16);
            this.barcode.TabIndex = 16;
            this.barcode.Text = "条码识别";
            this.barcode.UseVisualStyleBackColor = true;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(782, 64);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(130, 23);
            this.button1.TabIndex = 46;
            this.button1.Text = "Ocr保存到文件";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // statusStrip1
            // 
            this.statusStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.ddd,
            this.sListenState,
            this.toolStripStatusLabel1,
            this.toolStripStatusLabel2,
            this.sPort});
            this.statusStrip1.Location = new System.Drawing.Point(0, 620);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.Size = new System.Drawing.Size(923, 22);
            this.statusStrip1.TabIndex = 48;
            this.statusStrip1.Text = "statusStrip1";
            // 
            // ddd
            // 
            this.ddd.Name = "ddd";
            this.ddd.Size = new System.Drawing.Size(65, 17);
            this.ddd.Text = "监听状态：";
            // 
            // sListenState
            // 
            this.sListenState.Name = "sListenState";
            this.sListenState.Size = new System.Drawing.Size(131, 17);
            this.sListenState.Text = "toolStripStatusLabel1";
            // 
            // toolStripStatusLabel1
            // 
            this.toolStripStatusLabel1.Name = "toolStripStatusLabel1";
            this.toolStripStatusLabel1.Size = new System.Drawing.Size(41, 17);
            this.toolStripStatusLabel1.Text = "端口：";
            // 
            // toolStripStatusLabel2
            // 
            this.toolStripStatusLabel2.Name = "toolStripStatusLabel2";
            this.toolStripStatusLabel2.Size = new System.Drawing.Size(131, 17);
            this.toolStripStatusLabel2.Text = "toolStripStatusLabel2";
            // 
            // sPort
            // 
            this.sPort.Name = "sPort";
            this.sPort.Size = new System.Drawing.Size(131, 17);
            this.sPort.Text = "toolStripStatusLabel3";
            // 
            // listView1
            // 
            this.listView1.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeader1,
            this.columnHeader2,
            this.columnHeader3,
            this.columnHeader4});
            this.listView1.FullRowSelect = true;
            this.listView1.GridLines = true;
            this.listView1.Location = new System.Drawing.Point(13, 332);
            this.listView1.Name = "listView1";
            this.listView1.Size = new System.Drawing.Size(613, 284);
            this.listView1.TabIndex = 49;
            this.listView1.UseCompatibleStateImageBehavior = false;
            this.listView1.View = System.Windows.Forms.View.Details;
            // 
            // columnHeader1
            // 
            this.columnHeader1.Text = "序号";
            this.columnHeader1.Width = 45;
            // 
            // columnHeader2
            // 
            this.columnHeader2.Text = "时间";
            this.columnHeader2.Width = 131;
            // 
            // columnHeader3
            // 
            this.columnHeader3.Text = "类型";
            this.columnHeader3.Width = 82;
            // 
            // columnHeader4
            // 
            this.columnHeader4.Text = "内容";
            this.columnHeader4.Width = 439;
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(810, 118);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(75, 23);
            this.button2.TabIndex = 50;
            this.button2.Text = "button2";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new System.EventHandler(this.button2_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(923, 642);
            this.Controls.Add(this.button2);
            this.Controls.Add(this.listView1);
            this.Controls.Add(this.statusStrip1);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.groupBox5);
            this.Controls.Add(this.eloamThumbnail);
            this.Controls.Add(this.eloamView);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox13);
            this.Controls.Add(this.exchangeUpDown);
            this.Controls.Add(this.turnRight);
            this.Controls.Add(this.exchangeLeftRight);
            this.Controls.Add(this.turnLeft);
            this.Controls.Add(this.groupBox12);
            this.Controls.Add(this.groupBox11);
            this.Controls.Add(this.groupBox10);
            this.Controls.Add(this.groupBox9);
            this.Controls.Add(this.groupBox8);
            this.Controls.Add(this.groupBox6);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.openProperty);
            this.Controls.Add(this.shoot);
            this.Controls.Add(this.closeVideo);
            this.Controls.Add(this.openVideo);
            this.Name = "Form1";
            this.Text = "Form1";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Form1_FormClosing);
            this.Load += new System.EventHandler(this.Form1_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox6.ResumeLayout(false);
            this.groupBox6.PerformLayout();
            this.groupBox9.ResumeLayout(false);
            this.groupBox9.PerformLayout();
            this.groupBox10.ResumeLayout(false);
            this.groupBox10.PerformLayout();
            this.groupBox11.ResumeLayout(false);
            this.groupBox12.ResumeLayout(false);
            this.groupBox8.ResumeLayout(false);
            this.groupBox8.PerformLayout();
            this.groupBox13.ResumeLayout(false);
            this.groupBox13.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.eloamView)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.eloamThumbnail)).EndInit();
            this.groupBox5.ResumeLayout(false);
            this.groupBox5.PerformLayout();
            this.statusStrip1.ResumeLayout(false);
            this.statusStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button openVideo;
        private System.Windows.Forms.Button closeVideo;
        private System.Windows.Forms.Button shoot;
        private System.Windows.Forms.CheckBox removeGround;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.ComboBox selectResolution;
        private System.Windows.Forms.GroupBox groupBox6;
        private System.Windows.Forms.CheckBox rectify;
        private System.Windows.Forms.TextBox pictureSavePath;
        private System.Windows.Forms.GroupBox groupBox9;
        private System.Windows.Forms.GroupBox groupBox10;
        private System.Windows.Forms.CheckBox compoundShoot;
        private System.Windows.Forms.TextBox textBox2;
        private System.Windows.Forms.TextBox edit_Timer;
        private System.Windows.Forms.CheckBox openTimer;
        private System.Windows.Forms.Button openProperty;
        private System.Windows.Forms.GroupBox groupBox11;
        private System.Windows.Forms.ComboBox selectDevice;
        private System.Windows.Forms.GroupBox groupBox12;
        private System.Windows.Forms.ComboBox selectMode;
        private System.Windows.Forms.Button exchangeLeftRight;
        private System.Windows.Forms.Button turnLeft;
        private System.Windows.Forms.Button exchangeUpDown;
        private System.Windows.Forms.Button turnRight;
        private System.Windows.Forms.GroupBox groupBox8;
        private System.Windows.Forms.GroupBox groupBox13;
        private System.Windows.Forms.CheckBox autoShoot;
        private System.Windows.Forms.GroupBox groupBox2;
        private AxeloamComLib.AxEloamView eloamView;
        private AxeloamComLib.AxEloamThumbnail eloamThumbnail;
        private System.Windows.Forms.GroupBox groupBox5;
        private System.Windows.Forms.CheckBox barcode;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.StatusStrip statusStrip1;
        private System.Windows.Forms.ToolStripStatusLabel ddd;
        private System.Windows.Forms.ToolStripStatusLabel sListenState;
        private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabel1;
        private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabel2;
        private System.Windows.Forms.ToolStripStatusLabel sPort;
        private System.Windows.Forms.ListView listView1;
        private System.Windows.Forms.ColumnHeader columnHeader1;
        private System.Windows.Forms.ColumnHeader columnHeader2;
        private System.Windows.Forms.ColumnHeader columnHeader3;
        private System.Windows.Forms.ColumnHeader columnHeader4;
        private System.Windows.Forms.Button button2;
    }
}

