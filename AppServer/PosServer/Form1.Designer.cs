namespace WindowsFormsApplication1
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
            this.button1 = new System.Windows.Forms.Button();
            this.lst1 = new System.Windows.Forms.ListBox();
            this.button2 = new System.Windows.Forms.Button();
            this.button3 = new System.Windows.Forms.Button();
            this.dv1 = new System.Windows.Forms.DataGridView();
            this.button4 = new System.Windows.Forms.Button();
            this.lv1 = new System.Windows.Forms.ListView();
            this.c1 = new System.Windows.Forms.ColumnHeader();
            this.c2 = new System.Windows.Forms.ColumnHeader();
            this.c3 = new System.Windows.Forms.ColumnHeader();
            this.c4 = new System.Windows.Forms.ColumnHeader();
            this.c5 = new System.Windows.Forms.ColumnHeader();
            this.button5 = new System.Windows.Forms.Button();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.c6 = new System.Windows.Forms.ColumnHeader();
            ((System.ComponentModel.ISupportInitialize)(this.dv1)).BeginInit();
            this.SuspendLayout();
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(612, 12);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 23);
            this.button1.TabIndex = 0;
            this.button1.Text = "connect";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // lst1
            // 
            this.lst1.FormattingEnabled = true;
            this.lst1.ItemHeight = 12;
            this.lst1.Location = new System.Drawing.Point(12, 475);
            this.lst1.Name = "lst1";
            this.lst1.Size = new System.Drawing.Size(951, 256);
            this.lst1.TabIndex = 1;
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(807, 12);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(75, 23);
            this.button2.TabIndex = 2;
            this.button2.Text = "Stop";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new System.EventHandler(this.button2_Click);
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(708, 12);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(75, 23);
            this.button3.TabIndex = 3;
            this.button3.Text = "Start";
            this.button3.UseVisualStyleBackColor = true;
            this.button3.Click += new System.EventHandler(this.button3_Click);
            // 
            // dv1
            // 
            this.dv1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dv1.Location = new System.Drawing.Point(12, 41);
            this.dv1.Name = "dv1";
            this.dv1.RowTemplate.Height = 23;
            this.dv1.Size = new System.Drawing.Size(34, 18);
            this.dv1.TabIndex = 4;
            // 
            // button4
            // 
            this.button4.Location = new System.Drawing.Point(888, 12);
            this.button4.Name = "button4";
            this.button4.Size = new System.Drawing.Size(75, 23);
            this.button4.TabIndex = 5;
            this.button4.Text = "button4";
            this.button4.UseVisualStyleBackColor = true;
            this.button4.Click += new System.EventHandler(this.button4_Click);
            // 
            // lv1
            // 
            this.lv1.Alignment = System.Windows.Forms.ListViewAlignment.Default;
            this.lv1.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.c1,
            this.c2,
            this.c3,
            this.c4,
            this.c5,
            this.c6});
            this.lv1.FullRowSelect = true;
            this.lv1.GridLines = true;
            this.lv1.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.Nonclickable;
            this.lv1.Location = new System.Drawing.Point(12, 41);
            this.lv1.Name = "lv1";
            this.lv1.Size = new System.Drawing.Size(951, 428);
            this.lv1.TabIndex = 6;
            this.lv1.UseCompatibleStateImageBehavior = false;
            this.lv1.View = System.Windows.Forms.View.Details;
            this.lv1.SelectedIndexChanged += new System.EventHandler(this.lv1_SelectedIndexChanged);
            // 
            // c1
            // 
            this.c1.Text = "EPC";
            this.c1.Width = 200;
            // 
            // c2
            // 
            this.c2.Text = "件号";
            // 
            // c3
            // 
            this.c3.Text = "最后发现时间";
            this.c3.Width = 150;
            // 
            // c4
            // 
            this.c4.Text = "ReadCount";
            this.c4.Width = 94;
            // 
            // c5
            // 
            this.c5.Text = "RSSI";
            // 
            // button5
            // 
            this.button5.Location = new System.Drawing.Point(495, 12);
            this.button5.Name = "button5";
            this.button5.Size = new System.Drawing.Size(75, 23);
            this.button5.TabIndex = 7;
            this.button5.Text = "button5";
            this.button5.UseVisualStyleBackColor = true;
            this.button5.Click += new System.EventHandler(this.button5_Click);
            // 
            // timer1
            // 
            this.timer1.Enabled = true;
            this.timer1.Interval = 500;
            this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
            // 
            // c6
            // 
            this.c6.Text = "天线";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(975, 740);
            this.Controls.Add(this.button5);
            this.Controls.Add(this.lv1);
            this.Controls.Add(this.button4);
            this.Controls.Add(this.dv1);
            this.Controls.Add(this.button3);
            this.Controls.Add(this.button2);
            this.Controls.Add(this.lst1);
            this.Controls.Add(this.button1);
            this.Name = "Form1";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dv1)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.ListBox lst1;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.DataGridView dv1;
        private System.Windows.Forms.Button button4;
        private System.Windows.Forms.ListView lv1;
        private System.Windows.Forms.ColumnHeader c1;
        private System.Windows.Forms.ColumnHeader c2;
        private System.Windows.Forms.Button button5;
        private System.Windows.Forms.Timer timer1;
        private System.Windows.Forms.ColumnHeader c3;
        private System.Windows.Forms.ColumnHeader c4;
        private System.Windows.Forms.ColumnHeader c5;
        private System.Windows.Forms.ColumnHeader c6;
    }
}

