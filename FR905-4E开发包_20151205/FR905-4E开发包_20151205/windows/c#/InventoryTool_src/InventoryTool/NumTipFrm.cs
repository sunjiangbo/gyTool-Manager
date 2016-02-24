using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace InventoryTool
{
    public partial class NumTipFrm : Form
    {
        public NumTipFrm(int num)
        {
            InitializeComponent();
            this.BackColor = Color.White;
            this.TransparencyKey = Color.White;
            DispNum = num.ToString();
            
            if (DispNum.Length == 1)
                this.Width = this.Width / 4;
            else if (DispNum.Length == 2)
                this.Width = this.Width / 2;
            else if (DispNum.Length == 3)
                this.Width = this.Width / 4 * 3;
            this.timer1.Enabled = true;
        }
        string DispNum;

        private void timer1_Tick(object sender, EventArgs e)
        {
            this.timer1.Enabled = false;
            this.Close();
        }

        private void NumTipFrm_Paint(object sender, PaintEventArgs e)
        {
            Graphics g = this.CreateGraphics();
            Font font = new Font("宋体", 180f);
            PointF pointF = new PointF(0, 0);
            SizeF sizeF = g.MeasureString(DispNum, font);
            g.FillRectangle(Brushes.White, new RectangleF(pointF, sizeF));
            g.DrawString(DispNum, font, Brushes.Red, pointF);
            g.Dispose();
            font.Dispose();
        }

    }
}
