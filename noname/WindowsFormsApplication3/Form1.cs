using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;


namespace WindowsFormsApplication3
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("序号", typeof(Int32));
            dt.Columns.Add("件号", typeof(String));
            dt.Columns.Add("工具名",typeof(String));
            for (int i = 0; i < 10; i++)
            {
                dt.Rows.Add(dt.NewRow());
                dt.Rows[i]["序号"] = i;
                dt.Rows[i]["件号"] = "GJ-" + i;
                dt.Rows[i]["工具名"] = "工具"+i;
            }
            

            dataGridView1.DataSource = dt;
            dataGridView1.ShowCellToolTips = true;
            dataGridView1.BorderStyle = BorderStyle.Fixed3D;
        }

        private void dataGridView1_RowsAdded(object sender, DataGridViewRowsAddedEventArgs e)
        {
            richTextBox1.AppendText(dataGridView1.Rows[e.RowIndex].Cells[1].Value.ToString() + "\n");
            if (Convert.ToInt32(dataGridView1.Rows[e.RowIndex].Cells[0].Value.ToString()) > 5)
            {
                dataGridView1.Rows[e.RowIndex].Cells[1].Style.BackColor = Color.Yellow;
            }
        }

        private void dataGridView1_RowPostPaint(object sender, DataGridViewRowPostPaintEventArgs e)
        {
            using (SolidBrush b = new SolidBrush(dataGridView1.RowHeadersDefaultCellStyle.ForeColor))
            {
                e.Graphics.DrawString((e.RowIndex + 1).ToString(System.Globalization.CultureInfo.CurrentUICulture), e.InheritedRowStyle.Font, b, e.RowBounds.Location.X + 20, e.RowBounds.Location.Y + 4);
            }
        }
    }
}
