using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;

namespace InventoryTool
{
    public partial class OpFailedTipFrm : DevComponents.DotNetBar.Metro.MetroForm
    {
        public OpFailedTipFrm(Form1 frm1_, string tipstr)
        {
            InitializeComponent();
            gtipstr = tipstr;
            this.richTextBoxEx1.Text = gtipstr;
            this.buttonX1.Text = "确定";
            frm1 = frm1_;


            Point ml = frm1.Location;
            ml.X = ml.X + (frm1.Width - this.Width) / 2;
            ml.Y = ml.Y + (frm1.Height - this.Height) / 2;
            this.StartPosition = FormStartPosition.Manual;
            this.Location = ml;

        }
        Form1 frm1 = null;
        string gtipstr = "";
        public void SetTipString(string tipstr)
        {
            gtipstr += "\r\n";
            gtipstr += tipstr;
            this.richTextBoxEx1.Text = gtipstr;
        }

        private void buttonX1_Click(object sender, EventArgs e)
        {
            this.Close();
            frm1.oftfrm = null;
        }
    }
}