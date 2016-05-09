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
    public partial class CusMsgFrm : DevComponents.DotNetBar.Metro.MetroForm
    {
        public CusMsgFrm(string str)
        {
            InitializeComponent();
            this.label1.Text = str;
            this.buttonX1.Text = "确定";
        }

        private void buttonX1_Click(object sender, EventArgs e)
        {
            this.Close();
        }

    }
}