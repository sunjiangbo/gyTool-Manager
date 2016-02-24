namespace ModuleReaderManager
{
    partial class InventoryParasform
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
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.cbbfilterrule = new System.Windows.Forms.ComboBox();
            this.label7 = new System.Windows.Forms.Label();
            this.cbbfilterbank = new System.Windows.Forms.ComboBox();
            this.label6 = new System.Windows.Forms.Label();
            this.tbfilteraddr = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.cbisfilter = new System.Windows.Forms.CheckBox();
            this.label2 = new System.Windows.Forms.Label();
            this.tbfilterdata = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.tbebstartaddr = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.cbbebbank = new System.Windows.Forms.ComboBox();
            this.gbemddata = new System.Windows.Forms.GroupBox();
            this.tbebbytescnt = new System.Windows.Forms.TextBox();
            this.cbispwd = new System.Windows.Forms.CheckBox();
            this.tbacspwd = new System.Windows.Forms.TextBox();
            this.label8 = new System.Windows.Forms.Label();
            this.cbisaddiondata = new System.Windows.Forms.CheckBox();
            this.button1 = new System.Windows.Forms.Button();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.cbisOneReadOneTime = new System.Windows.Forms.CheckBox();
            this.cbisReadFixCount = new System.Windows.Forms.CheckBox();
            this.tbReadCount = new System.Windows.Forms.TextBox();
            this.label39 = new System.Windows.Forms.Label();
            this.cbisrevertants = new System.Windows.Forms.CheckBox();
            this.tbreaddur = new System.Windows.Forms.TextBox();
            this.tbsleepdur = new System.Windows.Forms.TextBox();
            this.label10 = new System.Windows.Forms.Label();
            this.label9 = new System.Windows.Forms.Label();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.cbisunibyant = new System.Windows.Forms.CheckBox();
            this.cbischgcolor = new System.Windows.Forms.CheckBox();
            this.cbisunibynullemd = new System.Windows.Forms.CheckBox();
            this.groupBox1.SuspendLayout();
            this.gbemddata.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.SuspendLayout();
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.cbbfilterrule);
            this.groupBox1.Controls.Add(this.label7);
            this.groupBox1.Controls.Add(this.cbbfilterbank);
            this.groupBox1.Controls.Add(this.label6);
            this.groupBox1.Controls.Add(this.tbfilteraddr);
            this.groupBox1.Controls.Add(this.label5);
            this.groupBox1.Controls.Add(this.cbisfilter);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.tbfilterdata);
            this.groupBox1.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.groupBox1.Location = new System.Drawing.Point(14, 12);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(310, 108);
            this.groupBox1.TabIndex = 13;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "filter setting";
            // 
            // cbbfilterrule
            // 
            this.cbbfilterrule.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbbfilterrule.FormattingEnabled = true;
            this.cbbfilterrule.Items.AddRange(new object[] {
            "match",
            "no match"});
            this.cbbfilterrule.Location = new System.Drawing.Point(254, 49);
            this.cbbfilterrule.Name = "cbbfilterrule";
            this.cbbfilterrule.Size = new System.Drawing.Size(48, 20);
            this.cbbfilterrule.TabIndex = 14;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("宋体", 9F);
            this.label7.Location = new System.Drawing.Point(185, 55);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(65, 12);
            this.label7.TabIndex = 14;
            this.label7.Text = "filterrule";
            // 
            // cbbfilterbank
            // 
            this.cbbfilterbank.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbbfilterbank.FormattingEnabled = true;
            this.cbbfilterbank.Items.AddRange(new object[] {
            "EPCbank",
            "TIDbank",
            "USERbank"});
            this.cbbfilterbank.Location = new System.Drawing.Point(82, 49);
            this.cbbfilterbank.Name = "cbbfilterbank";
            this.cbbfilterbank.Size = new System.Drawing.Size(97, 20);
            this.cbbfilterbank.TabIndex = 14;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("宋体", 9F);
            this.label6.Location = new System.Drawing.Point(6, 55);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(65, 12);
            this.label6.TabIndex = 14;
            this.label6.Text = "filterbank";
            // 
            // tbfilteraddr
            // 
            this.tbfilteraddr.Location = new System.Drawing.Point(254, 20);
            this.tbfilteraddr.Name = "tbfilteraddr";
            this.tbfilteraddr.Size = new System.Drawing.Size(50, 21);
            this.tbfilteraddr.TabIndex = 14;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("宋体", 9F);
            this.label5.Location = new System.Drawing.Point(185, 23);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(59, 12);
            this.label5.TabIndex = 14;
            this.label5.Text = "startaddr";
            // 
            // cbisfilter
            // 
            this.cbisfilter.AutoSize = true;
            this.cbisfilter.Font = new System.Drawing.Font("宋体", 9F);
            this.cbisfilter.Location = new System.Drawing.Point(9, 81);
            this.cbisfilter.Name = "cbisfilter";
            this.cbisfilter.Size = new System.Drawing.Size(102, 16);
            this.cbisfilter.TabIndex = 13;
            this.cbisfilter.Text = "enable filter";
            this.cbisfilter.UseVisualStyleBackColor = true;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("宋体", 9F);
            this.label2.Location = new System.Drawing.Point(6, 23);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(59, 12);
            this.label2.TabIndex = 13;
            this.label2.Text = "matchdata";
            // 
            // tbfilterdata
            // 
            this.tbfilterdata.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.5F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.tbfilterdata.Location = new System.Drawing.Point(82, 20);
            this.tbfilterdata.Name = "tbfilterdata";
            this.tbfilterdata.Size = new System.Drawing.Size(97, 23);
            this.tbfilterdata.TabIndex = 13;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("宋体", 9F);
            this.label1.Location = new System.Drawing.Point(8, 25);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(59, 12);
            this.label1.TabIndex = 14;
            this.label1.Text = "startaddr";
            // 
            // tbebstartaddr
            // 
            this.tbebstartaddr.Location = new System.Drawing.Point(75, 20);
            this.tbebstartaddr.Name = "tbebstartaddr";
            this.tbebstartaddr.Size = new System.Drawing.Size(72, 21);
            this.tbebstartaddr.TabIndex = 15;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("宋体", 9F);
            this.label3.Location = new System.Drawing.Point(154, 25);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(59, 12);
            this.label3.TabIndex = 17;
            this.label3.Text = "bytecount";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("宋体", 9F);
            this.label4.Location = new System.Drawing.Point(8, 59);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(29, 12);
            this.label4.TabIndex = 18;
            this.label4.Text = "bank";
            // 
            // cbbebbank
            // 
            this.cbbebbank.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbbebbank.FormattingEnabled = true;
            this.cbbebbank.Items.AddRange(new object[] {
            "Reservebank",
            "EPCbank",
            "TIDbank",
            "USERbank"});
            this.cbbebbank.Location = new System.Drawing.Point(75, 56);
            this.cbbebbank.Name = "cbbebbank";
            this.cbbebbank.Size = new System.Drawing.Size(72, 20);
            this.cbbebbank.TabIndex = 19;
            // 
            // gbemddata
            // 
            this.gbemddata.Controls.Add(this.tbebbytescnt);
            this.gbemddata.Controls.Add(this.cbispwd);
            this.gbemddata.Controls.Add(this.tbacspwd);
            this.gbemddata.Controls.Add(this.label8);
            this.gbemddata.Controls.Add(this.cbisaddiondata);
            this.gbemddata.Controls.Add(this.cbbebbank);
            this.gbemddata.Controls.Add(this.label3);
            this.gbemddata.Controls.Add(this.label4);
            this.gbemddata.Controls.Add(this.label1);
            this.gbemddata.Controls.Add(this.tbebstartaddr);
            this.gbemddata.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.gbemddata.Location = new System.Drawing.Point(349, 12);
            this.gbemddata.Name = "gbemddata";
            this.gbemddata.Size = new System.Drawing.Size(310, 118);
            this.gbemddata.TabIndex = 20;
            this.gbemddata.TabStop = false;
            this.gbemddata.Text = "embedded data";
            // 
            // tbebbytescnt
            // 
            this.tbebbytescnt.Location = new System.Drawing.Point(223, 20);
            this.tbebbytescnt.Name = "tbebbytescnt";
            this.tbebbytescnt.Size = new System.Drawing.Size(81, 21);
            this.tbebbytescnt.TabIndex = 25;
            // 
            // cbispwd
            // 
            this.cbispwd.AutoSize = true;
            this.cbispwd.Font = new System.Drawing.Font("宋体", 9F);
            this.cbispwd.Location = new System.Drawing.Point(184, 94);
            this.cbispwd.Name = "cbispwd";
            this.cbispwd.Size = new System.Drawing.Size(120, 16);
            this.cbispwd.TabIndex = 24;
            this.cbispwd.Text = "enable accesspwd";
            this.cbispwd.UseVisualStyleBackColor = true;
            // 
            // tbacspwd
            // 
            this.tbacspwd.Location = new System.Drawing.Point(223, 56);
            this.tbacspwd.Name = "tbacspwd";
            this.tbacspwd.Size = new System.Drawing.Size(81, 21);
            this.tbacspwd.TabIndex = 23;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Font = new System.Drawing.Font("宋体", 9F);
            this.label8.Location = new System.Drawing.Point(154, 59);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(59, 12);
            this.label8.TabIndex = 22;
            this.label8.Text = "accesspwd";
            // 
            // cbisaddiondata
            // 
            this.cbisaddiondata.AutoSize = true;
            this.cbisaddiondata.Font = new System.Drawing.Font("宋体", 9F);
            this.cbisaddiondata.Location = new System.Drawing.Point(10, 94);
            this.cbisaddiondata.Name = "cbisaddiondata";
            this.cbisaddiondata.Size = new System.Drawing.Size(144, 16);
            this.cbisaddiondata.TabIndex = 20;
            this.cbisaddiondata.Text = "enable embedded data";
            this.cbisaddiondata.UseVisualStyleBackColor = true;
            // 
            // button1
            // 
            this.button1.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.button1.Location = new System.Drawing.Point(258, 241);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(147, 39);
            this.button1.TabIndex = 21;
            this.button1.Text = "OK";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.cbisOneReadOneTime);
            this.groupBox3.Controls.Add(this.cbisReadFixCount);
            this.groupBox3.Controls.Add(this.tbReadCount);
            this.groupBox3.Controls.Add(this.label39);
            this.groupBox3.Controls.Add(this.cbisrevertants);
            this.groupBox3.Controls.Add(this.tbreaddur);
            this.groupBox3.Controls.Add(this.tbsleepdur);
            this.groupBox3.Controls.Add(this.label10);
            this.groupBox3.Controls.Add(this.label9);
            this.groupBox3.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.groupBox3.Location = new System.Drawing.Point(15, 141);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(309, 82);
            this.groupBox3.TabIndex = 26;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "Inventory cycle";
            // 
            // cbisOneReadOneTime
            // 
            this.cbisOneReadOneTime.AutoSize = true;
            this.cbisOneReadOneTime.Location = new System.Drawing.Point(90, 56);
            this.cbisOneReadOneTime.Name = "cbisOneReadOneTime";
            this.cbisOneReadOneTime.Size = new System.Drawing.Size(120, 16);
            this.cbisOneReadOneTime.TabIndex = 21;
            this.cbisOneReadOneTime.Text = "OneInvOneReadCnt";
            this.cbisOneReadOneTime.UseVisualStyleBackColor = true;
            // 
            // cbisReadFixCount
            // 
            this.cbisReadFixCount.AutoSize = true;
            this.cbisReadFixCount.Location = new System.Drawing.Point(213, 56);
            this.cbisReadFixCount.Name = "cbisReadFixCount";
            this.cbisReadFixCount.Size = new System.Drawing.Size(90, 16);
            this.cbisReadFixCount.TabIndex = 20;
            this.cbisReadFixCount.Text = "InvFixCount";
            this.cbisReadFixCount.UseVisualStyleBackColor = true;
            this.cbisReadFixCount.CheckedChanged += new System.EventHandler(this.cbisReadFixCount_CheckedChanged);
            // 
            // tbReadCount
            // 
            this.tbReadCount.Location = new System.Drawing.Point(256, 17);
            this.tbReadCount.Name = "tbReadCount";
            this.tbReadCount.Size = new System.Drawing.Size(46, 21);
            this.tbReadCount.TabIndex = 19;
            // 
            // label39
            // 
            this.label39.AutoSize = true;
            this.label39.Location = new System.Drawing.Point(212, 23);
            this.label39.Name = "label39";
            this.label39.Size = new System.Drawing.Size(41, 12);
            this.label39.TabIndex = 18;
            this.label39.Text = "InvCnt";
            // 
            // cbisrevertants
            // 
            this.cbisrevertants.AutoSize = true;
            this.cbisrevertants.Location = new System.Drawing.Point(10, 56);
            this.cbisrevertants.Name = "cbisrevertants";
            this.cbisrevertants.Size = new System.Drawing.Size(78, 16);
            this.cbisrevertants.TabIndex = 17;
            this.cbisrevertants.Text = "RevertAnt";
            this.cbisrevertants.UseVisualStyleBackColor = true;
            // 
            // tbreaddur
            // 
            this.tbreaddur.Location = new System.Drawing.Point(49, 20);
            this.tbreaddur.Name = "tbreaddur";
            this.tbreaddur.Size = new System.Drawing.Size(41, 21);
            this.tbreaddur.TabIndex = 16;
            // 
            // tbsleepdur
            // 
            this.tbsleepdur.Location = new System.Drawing.Point(163, 18);
            this.tbsleepdur.Name = "tbsleepdur";
            this.tbsleepdur.Size = new System.Drawing.Size(44, 21);
            this.tbsleepdur.TabIndex = 15;
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(92, 23);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(71, 12);
            this.label10.TabIndex = 15;
            this.label10.Text = "InvInterval";
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(6, 24);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(41, 12);
            this.label9.TabIndex = 15;
            this.label9.Text = "InvDur";
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.cbisunibyant);
            this.groupBox2.Controls.Add(this.cbischgcolor);
            this.groupBox2.Controls.Add(this.cbisunibynullemd);
            this.groupBox2.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.groupBox2.Location = new System.Drawing.Point(349, 158);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(312, 65);
            this.groupBox2.TabIndex = 29;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "display setting";
            // 
            // cbisunibyant
            // 
            this.cbisunibyant.AutoSize = true;
            this.cbisunibyant.Location = new System.Drawing.Point(225, 20);
            this.cbisunibyant.Name = "cbisunibyant";
            this.cbisunibyant.Size = new System.Drawing.Size(72, 16);
            this.cbisunibyant.TabIndex = 2;
            this.cbisunibyant.Text = "UniByAnt";
            this.cbisunibyant.UseVisualStyleBackColor = true;
            // 
            // cbischgcolor
            // 
            this.cbischgcolor.AutoSize = true;
            this.cbischgcolor.Location = new System.Drawing.Point(121, 20);
            this.cbischgcolor.Name = "cbischgcolor";
            this.cbischgcolor.Size = new System.Drawing.Size(90, 16);
            this.cbischgcolor.TabIndex = 1;
            this.cbischgcolor.Text = "ChangeColor";
            this.cbischgcolor.UseVisualStyleBackColor = true;
            // 
            // cbisunibynullemd
            // 
            this.cbisunibynullemd.AutoSize = true;
            this.cbisunibynullemd.Location = new System.Drawing.Point(19, 21);
            this.cbisunibynullemd.Name = "cbisunibynullemd";
            this.cbisunibynullemd.Size = new System.Drawing.Size(96, 16);
            this.cbisunibynullemd.TabIndex = 0;
            this.cbisunibynullemd.Text = "UniByEmbData";
            this.cbisunibynullemd.UseVisualStyleBackColor = true;
            // 
            // InventoryParasform
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(677, 295);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox3);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.gbemddata);
            this.Controls.Add(this.groupBox1);
            this.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "InventoryParasform";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Inventory Setting";
            this.Load += new System.EventHandler(this.InventoryParasform_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.gbemddata.ResumeLayout(false);
            this.gbemddata.PerformLayout();
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.ComboBox cbbfilterrule;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.ComboBox cbbfilterbank;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TextBox tbfilteraddr;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.CheckBox cbisfilter;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox tbfilterdata;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox tbebstartaddr;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.ComboBox cbbebbank;
        private System.Windows.Forms.GroupBox gbemddata;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.CheckBox cbisaddiondata;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.TextBox tbacspwd;
        private System.Windows.Forms.CheckBox cbispwd;
        private System.Windows.Forms.TextBox tbebbytescnt;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.CheckBox cbisrevertants;
        private System.Windows.Forms.TextBox tbreaddur;
        private System.Windows.Forms.TextBox tbsleepdur;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.CheckBox cbisunibynullemd;
        private System.Windows.Forms.CheckBox cbischgcolor;
        private System.Windows.Forms.CheckBox cbisunibyant;
        private System.Windows.Forms.TextBox tbReadCount;
        private System.Windows.Forms.Label label39;
        private System.Windows.Forms.CheckBox cbisReadFixCount;
        private System.Windows.Forms.CheckBox cbisOneReadOneTime;
    }
}