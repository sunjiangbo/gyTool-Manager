using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using ModuleTech;
using ModuleLibrary;

namespace ModuleReaderManager
{
    public partial class logFrm : Form
    {
        public logFrm()
        {
            InitializeComponent();
        }

        private void btngetlog_Click(object sender, EventArgs e)
        {
            if (this.tbrdraddr.Text.Trim() == string.Empty)
            {
                MessageBox.Show("please input the ip address of reader");
                return;
            }
            try
            {
                Reader rdr = Reader.Create(this.tbrdraddr.Text.Trim(), 4);
                rdr.ParamSet("StartGetLog", true);
                rtblogstr.Text = "";
                while (true)
                {
                    try
                    {
                        string logblk = (string)rdr.ParamGet("NextLogBlock");
                        rtblogstr.Text += logblk;
                    }
                    catch (OpFaidedException exx)
                    {
                        if (exx.ErrCode == 0xA010 || 0xA00F == exx.ErrCode)
                            return;
                    }
                    catch (System.Exception ex)
                    {
                        MessageBox.Show("operation failed：" + ex.ToString());
                        return;
                    }
                }
    
            }
            catch
            {
                MessageBox.Show("connection reader failed");
                return;
            }
        }
    }
}
