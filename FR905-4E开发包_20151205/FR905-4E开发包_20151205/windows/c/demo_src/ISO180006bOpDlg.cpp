// ISO180006bOpDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ModuleReaderManager.h"
#include "ISO180006bOpDlg.h"
#include "ModuleReader.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// ISO180006bOpDlg dialog


ISO180006bOpDlg::ISO180006bOpDlg(CWnd* pParent, int hreader)
	: CDialog(ISO180006bOpDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(ISO180006bOpDlg)
	m_isant1 = FALSE;
	m_isant2 = FALSE;
	m_isant3 = FALSE;
	m_isant4 = FALSE;
	m_datastr = _T("");
	m_staddr = 0;
	m_blkscnt = 1;
	//}}AFX_DATA_INIT
	m_hreader = hreader;
}


void ISO180006bOpDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(ISO180006bOpDlg)
	DDX_Control(pDX, IDC_listtag, m_lvtags);
	DDX_Check(pDX, IDC_ckant1, m_isant1);
	DDX_Check(pDX, IDC_ckant2, m_isant2);
	DDX_Check(pDX, IDC_ckant3, m_isant3);
	DDX_Check(pDX, IDC_ckant4, m_isant4);
	DDX_Text(pDX, IDC_rtbdata, m_datastr);
	DDX_Text(pDX, IDC_tbstaddr, m_staddr);
	DDV_MinMaxInt(pDX, m_staddr, 0, 215);
	DDX_Text(pDX, IDC_tbblks, m_blkscnt);
	DDV_MinMaxUInt(pDX, m_blkscnt, 1, 216);
	//}}AFX_DATA_MAP

}


BEGIN_MESSAGE_MAP(ISO180006bOpDlg, CDialog)
	//{{AFX_MSG_MAP(ISO180006bOpDlg)
	ON_BN_CLICKED(IDC_btnstart, Onbtnstart)
//	ON_WM_TIMER()
	ON_BN_CLICKED(IDC_btnstop, Onbtnstop)
	ON_BN_CLICKED(IDC_btnread, Onbtnread)
	ON_BN_CLICKED(IDC_btnclear, Onbtnclear)
	ON_BN_CLICKED(IDC_btnwrite, Onbtnwrite)
	ON_BN_CLICKED(IDC_btnlock, Onbtnlock)
	ON_WM_SHOWWINDOW()
	ON_WM_CREATE()
	ON_WM_CLOSE()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// ISO180006bOpDlg message handlers

int ISO180006bOpDlg::ValidAntenna(int num)
{
	int antcnt = 0;
	if (m_isant1)
		antcnt++;
	if (m_isant2)
		antcnt++;
	if (m_isant3)
		antcnt++;
	if (m_isant4)
		antcnt++;
	
	if (antcnt == 0)
	{
		MessageBox("没有选择天线");
		return -1;
	}
	
	if (num == 1)
	{
		if (antcnt != 1)
		{
			MessageBox("必须且只能选择一个天线");
			return -1;
		}
	}
	
	return 0;
}

void ISO180006bOpDlg::Onbtnstart() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);

	if (ValidAntenna(4) < 0)
		return;
	selcnts = 0;
	
	if (m_isant1)
	{
		selectants[selcnts++] = 1;
	}
	if (m_isant2)
	{
		selectants[selcnts++] = 2;
	}
	if (m_isant3)
	{
		selectants[selcnts++] = 3;
	}
	if (m_isant4)
	{
		selectants[selcnts++] = 4;
	}

	Inv_Potls_ST invpotls;
	invpotls.potlcnt = 1;
	invpotls.potls[0].potl = SL_TAG_PROTOCOL_ISO180006B;
	ParamSet(m_hreader, MTR_PARAM_TAG_INVPOTL, &invpotls);
	SetTimer(1, 700, NULL);

//	READER_ERR __stdcall TagInventory(int hReader, int *ants, int antcnt, unsigned short timeout, 
//		TAGINFO *pTInfo, int *tagcnt);
}

void ISO180006bOpDlg::OnTimer(UINT nIDEvent) 
{
	// TODO: Add your message handler code here and/or call default
	if (nIDEvent == 1)
	{
		TAGINFO tags[200];
		
		int tagcnt = 0;
		char tmp[200];
		
		char tmp2[100];
		
		READER_ERR err = TagInventory(m_hreader, selectants, selcnts, 400, tags, &tagcnt);
		if (err != MT_OK_ERR)
		{
			if (err == MT_CMD_FAILED_ERR)
				return;
			else
			{
				KillTimer(1);
				
				if (err == MT_HARDWARE_ALERT_ERR_BY_HIGN_RETURN_LOSS || 
					err == MT_HARDWARE_ALERT_ERR_BY_TOO_MANY_RESET ||
					err == MT_HARDWARE_ALERT_ERR_BY_NO_ANTENNAS ||
				err == MT_HARDWARE_ALERT_ERR_BY_READER_DOWN)
					MessageBox("危险操作，请检查读写器的工作状态和工作环境");
				else
					MessageBox("Inventory错误");		
				return;
			}
		}
		
		
		
		this->m_lvtags.ResetContent();
		
		for(int i = 0; i < tagcnt; ++i)
		{
			memset(tmp, 0, 200);
			Hex2Str(tags[i].EpcId, tags[i].Epclen, tmp);
			strcat(tmp, " ");
			strcat(tmp, _itoa(tags[i].RSSI, tmp2, 10));
			strcat(tmp, " ");
			strcat(tmp, _itoa(tags[i].Frequency, tmp2, 10));
			strcat(tmp, " ");
			strcat(tmp, _itoa(tags[i].TimeStamp, tmp2, 10));
			strcat(tmp, " ");
			strcat(tmp, _itoa(tags[i].AntennaID, tmp2, 10));
			strcat(tmp, " ");
			if (tags[i].protocol == SL_TAG_PROTOCOL_GEN2)
				strcat(tmp, "gen2");
			else if (tags[i].protocol == SL_TAG_PROTOCOL_ISO180006B)
				strcat(tmp, "180006b");
			
			if (tags[i].EmbededDatalen != 0)
			{
				Hex2Str(tags[i].EmbededData, tags[i].EmbededDatalen, tmp2);
				strcat(tmp, "  ");
				strcat(tmp, tmp2);
			}
			this->m_lvtags.AddString(tmp);
		}
	}

	CDialog::OnTimer(nIDEvent);
}

void ISO180006bOpDlg::Onbtnstop() 
{
	// TODO: Add your control notification handler code here
	KillTimer(1);
}

int ISO180006bOpDlg::opant()
{
	if (m_isant1)
	{
		return 1;
	}
	if (m_isant2)
	{
		return 2;
	}
	if (m_isant3)
	{
		return 3;
	}
	if (m_isant4)
	{
		return 4;
	}
	return -1;
}

void ISO180006bOpDlg::Onbtnread() 
{
	// TODO: Add your control notification handler code here
	if(!UpdateData(TRUE))
		return;

	if (ValidAntenna(1) < 0)
		return;

	int selindex = m_lvtags.GetCurSel();
	if (selindex == CB_ERR)
	{
		MessageBox("请选择卡号");
		return;
	}
	CString tmpstr;
	m_lvtags.GetText(selindex, tmpstr);
	CString tagid = tmpstr.Left(16);
	unsigned char fdata[8];
	Str2Hex(tagid.GetBuffer(0), 16, fdata);
//	SetFilter(m_hreader, 4, m_staddr*8, fdata, 64, 0);

	TagFilter_ST filter;
	filter.bank = 4;
	filter.fdata = fdata;
	filter.flen = 64;
	filter.startaddr = 0;
	filter.isInvert = 0;
	ParamSet(m_hreader, MTR_PARAM_TAG_FILTER, &filter);


	int ant = opant();
	unsigned char databuf[256];
	char tmp[601];

	if (GetTagData(m_hreader, ant, 4, m_staddr, m_blkscnt, databuf, NULL, 1000) != MT_OK_ERR)
	{
		MessageBox("读失败");
		return;
	}
	
	memset(tmp, 0, 601);
	Hex2Str(databuf, m_blkscnt, tmp);
	m_datastr = tmp;
	UpdateData(FALSE);
	m_datastr = "";

}

void ISO180006bOpDlg::Onbtnclear() 
{
	// TODO: Add your control notification handler code here
	this->m_lvtags.ResetContent();
}

int ValidHexStr(char *buf, int maxlen)
{
	char buf_[600];
	strcpy(buf_, buf);
	
	
	int len = strlen(buf);
	if (len == 0)
		return -4;
	if (len > maxlen)
		return -3;
	if (len % 2 != 0)
		return -2;
	
	CharUpper(buf_);
	for (int i = 0; i < len; ++i)
	{
		if (!((buf_[i] >= '0' && buf_[i] <= '9') || (buf_[i] >= 'A' && buf_[i] <= 'F')))
			return -1;
	}
	
	return 0;
}

int ISO180006bOpDlg::Validwdata()
{
	int ret = ValidHexStr(m_datastr.GetBuffer(0), 432);
	if (ret == -1)
	{
		MessageBox("要被写入的数据包含非法字符");
		return -1;
	}
	else if (ret == -2)
	{
		MessageBox("需要被写入的数据字符串长度必须是2的倍数");
		return -1;
	}
	else if (ret == -4)
	{
		MessageBox("请输入要写入的数据");
		return -1;
	}
	
	return 0;
}

void ISO180006bOpDlg::Onbtnwrite() 
{
	// TODO: Add your control notification handler code here
	if(!UpdateData(TRUE))
		return;
	
	if (ValidAntenna(1) < 0)
		return;
	
	int selindex = m_lvtags.GetCurSel();
	if (selindex == CB_ERR)
	{
		MessageBox("请选择卡号");
		return;
	}
	CString tmpstr;
	m_lvtags.GetText(selindex, tmpstr);
	CString tagid = tmpstr.Left(16);
	unsigned char fdata[8];
	Str2Hex(tagid.GetBuffer(0), 16, fdata);
//	SetFilter(m_hreader, 4, m_staddr*8, fdata, 64, 0);
	TagFilter_ST filter;
	filter.bank = 4;
	filter.fdata = fdata;
	filter.flen = 64;
	filter.startaddr = 0;
	filter.isInvert = 0;
	ParamSet(m_hreader, MTR_PARAM_TAG_FILTER, &filter);

	int ant = opant();
	unsigned char databuf[256];
	if (Validwdata() < 0)
			return;
	Str2Hex(m_datastr.GetBuffer(0), m_datastr.GetLength(), databuf);

	if (WriteTagData(m_hreader, ant, 4, m_staddr, databuf, m_datastr.GetLength()/2, NULL, 1000) != MT_OK_ERR)
	{
		MessageBox("写失败");
		return;
	}
	else
	{
		m_datastr = "写成功";
		UpdateData(FALSE);
	}
}

void ISO180006bOpDlg::Onbtnlock() 
{
	// TODO: Add your control notification handler code here
	if(!UpdateData(TRUE))
		return;
	
	if (ValidAntenna(1) < 0)
		return;
	
	int selindex = m_lvtags.GetCurSel();
	if (selindex == CB_ERR)
	{
		MessageBox("请选择卡号");
		return;
	}
	CString tmpstr;
	m_lvtags.GetText(selindex, tmpstr);
	CString tagid = tmpstr.Left(16);
	unsigned char fdata[8];
	Str2Hex(tagid.GetBuffer(0), 16, fdata);
//	SetFilter(m_hreader, 4, m_staddr*8, fdata, 64, 0);
	TagFilter_ST filter;
	filter.bank = 4;
	filter.fdata = fdata;
	filter.flen = 64;
	filter.startaddr = 0;
	filter.isInvert = 0;
	ParamSet(m_hreader, MTR_PARAM_TAG_FILTER, &filter);

	int ant = opant();
	if (Lock180006BTag(m_hreader, ant, m_staddr, m_blkscnt, 1000) != MT_OK_ERR)
	{
		MessageBox("锁失败");
		return;
	}
	else
	{
		m_datastr = "锁成功";
		UpdateData(FALSE);
		m_datastr = "";
	}
}

void ISO180006bOpDlg::OnClose() 
{
	// TODO: Add your message handler code here and/or call default
	ResetFilter(m_hreader);
	CDialog::OnClose();
}
