// CustomDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ModuleReaderManager.h"
#include "CustomDlg.h"
#include "ModuleReader.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CCustomDlg dialog


CCustomDlg::CCustomDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CCustomDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CCustomDlg)
	m_EASDataStr = _T("");
	m_accesspwd = _T("");
	m_ant = -1;
	m_EASstate = -1;
	m_isblk1 = FALSE;
	m_isblk2 = FALSE;
	m_isblk3 = FALSE;
	m_isblk4 = FALSE;
	m_isblk5 = FALSE;
	m_isblk6 = FALSE;
	m_isblk7 = FALSE;
	m_isblk8 = FALSE;
	m_filterbank = -1;
	m_faddr = _T("");
	m_fdata = _T("");
	m_isMatch = FALSE;
	m_isfilter = FALSE;
	m_impinjqtcmdread = -1;
	m_impinjqtmempublic = -1;
	m_impinjpersistperm = -1;
	m_impinjnear = -1;
	m_isperm1 = FALSE;
	m_isperm2 = FALSE;
	m_isperm3 = FALSE;
	m_isperm4 = FALSE;
	m_isperm5 = FALSE;
	m_isperm6 = FALSE;
	m_isperm7 = FALSE;
	m_isperm8 = FALSE;
	m_blkrange = 0;
	m_startblk = 0;
	//}}AFX_DATA_INIT
	
	m_pdlg = (CModuleReaderManagerDlg*)pParent;
	

	
}

int CCustomDlg::getAnt()
{
	int ant = -1;

	ant = m_ant+1;
	return ant;
}


void CCustomDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CCustomDlg)
	DDX_Control(pDX, IDC_tbblkrange, m_tbblkrange);
	DDX_Control(pDX, IDC_tbstartblk, m_tbstartblk);
	DDX_Text(pDX, IDC_statEASData, m_EASDataStr);
	DDX_Text(pDX, IDC_editpwd, m_accesspwd);
	DDX_Radio(pDX, IDC_rdant1, m_ant);
	DDX_Radio(pDX, IDC_rdset, m_EASstate);
	DDX_Check(pDX, IDC_blkck1, m_isblk1);
	DDX_Check(pDX, IDC_blkck2, m_isblk2);
	DDX_Check(pDX, IDC_blkck3, m_isblk3);
	DDX_Check(pDX, IDC_blkck4, m_isblk4);
	DDX_Check(pDX, IDC_blkck5, m_isblk5);
	DDX_Check(pDX, IDC_blkck6, m_isblk6);
	DDX_Check(pDX, IDC_blkck7, m_isblk7);
	DDX_Check(pDX, IDC_blkck8, m_isblk8);
	DDX_CBIndex(pDX, IDC_fiterbank, m_filterbank);
	DDX_Text(pDX, IDC_tbfaddr, m_faddr);
	DDX_Text(pDX, IDC_tbfdata, m_fdata);
	DDX_Check(pDX, IDC_ccInvert, m_isMatch);
	DDX_Check(pDX, IDC_ccfilter, m_isfilter);
	DDX_Radio(pDX, IDC_rbimpinjqtcmdtread, m_impinjqtcmdread);
	DDX_Radio(pDX, IDC_rbimpinjqtmemtpublic, m_impinjqtmempublic);
	DDX_Radio(pDX, IDC_rbimpinjqtpersistperm, m_impinjpersistperm);
	DDX_Radio(pDX, IDC_rbimpinjqtrangetnear, m_impinjnear);
	DDX_Check(pDX, IDC_ckperm1, m_isperm1);
	DDX_Check(pDX, IDC_ckperm2, m_isperm2);
	DDX_Check(pDX, IDC_ckperm3, m_isperm3);
	DDX_Check(pDX, IDC_ckperm4, m_isperm4);
	DDX_Check(pDX, IDC_ckperm5, m_isperm5);
	DDX_Check(pDX, IDC_ckperm6, m_isperm6);
	DDX_Check(pDX, IDC_ckperm7, m_isperm7);
	DDX_Check(pDX, IDC_ckperm8, m_isperm8);
	DDX_Text(pDX, IDC_tbblkrange, m_blkrange);
	DDX_Text(pDX, IDC_tbstartblk, m_startblk);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CCustomDlg, CDialog)
	//{{AFX_MSG_MAP(CCustomDlg)
	ON_BN_CLICKED(IDC_btnChangeEAS, OnbtnChangeEAS)
	ON_BN_CLICKED(IDC_btnEASAlarm, OnbtnEASAlarm)
	ON_BN_CLICKED(IDC_btnBlockReadLock, OnbtnBlockReadLock)
	ON_BN_CLICKED(IDC_btnsetimpinjqt, Onbtnsetimpinjqt)
	ON_BN_CLICKED(IDC_btnpermlockget, Onbtnpermlockget)
	ON_BN_CLICKED(IDC_btnpermlockset, Onbtnpermlockset)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CCustomDlg message handlers

int CCustomDlg::Validaccpwd()
{
	int ret = m_pdlg->ValidHexStr(m_accesspwd.GetBuffer(0), 8);
	if (ret == -1)
	{
		MessageBox("访问密码包含非法字符");
		return -1;
	}
	else if (ret == -2)
	{
		MessageBox("输入的访问密码字符串长度必须是4的倍数");
		return -1;
	}
	else if (ret == -3)
	{
		MessageBox("访问密码只能是8个16进制字符");
		return -1;
	}
	else if (ret == -4)
	{
		MessageBox("请输入访问密码 ");
		return -1;
	}
	return 0;
}


void CCustomDlg::OnbtnChangeEAS() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);

	int ant = getAnt();
	if (ant == 0)
	{
		MessageBox("请选择天线");
		return;
	}

	if (SetFilter_() < 0)
		return;

	if (m_EASstate == -1)
	{
		MessageBox("请选择EAS状态");
		return;
	}
	else
	{
		NXPChangeEASPara para;
		if (Validaccpwd() < 0)
			return;
		Str2Hex(m_accesspwd, 8, para.AccessPwd);


		if (m_EASstate == 0)
			para.isSet = 1;
		else
			para.isSet = 0;

		para.TimeOut = 500;
		if (CustomCmd(m_pdlg->m_reader, ant, NXP_ChangeEAS, &para, NULL) != MT_OK_ERR)
			MessageBox("ChangeEAS失败");
	}
}

void CCustomDlg::OnbtnEASAlarm() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	
	int ant = getAnt();
	if (ant == 0)
	{
		MessageBox("请选择天线");
		return;
	}

	NXPEASAlarmPara para;
	NXPEASAlarmResult reslt;
	para.DR = 0x01;
	para.MC = 0x02;
	para.TrExt = 0x01;
	para.TimeOut = 300;
	
	if (CustomCmd(m_pdlg->m_reader, ant, NXP_EASAlarm, &para, &reslt) != MT_OK_ERR)
		MessageBox("ChangeEAS失败");
	else
	{
		char tmp[20];
		memset(tmp, 0, 20);
		Hex2Str(reslt.EASdata, 8, tmp);
		this->m_EASDataStr = tmp;
		UpdateData(FALSE);
	}
}


BOOL CCustomDlg::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	// TODO: Add extra initialization here
	if (m_pdlg->m_antscnt == 1)
	{
		GetDlgItem(IDC_rdant1)->EnableWindow(true);
		GetDlgItem(IDC_rdant2)->EnableWindow(false); 
		GetDlgItem(IDC_rdant3)->EnableWindow(false); 
		GetDlgItem(IDC_rdant4)->EnableWindow(false); 
	}
	else if (m_pdlg->m_antscnt == 2)
	{
		GetDlgItem(IDC_rdant1)->EnableWindow(true);
		GetDlgItem(IDC_rdant2)->EnableWindow(true); 
		GetDlgItem(IDC_rdant3)->EnableWindow(false); 
		GetDlgItem(IDC_rdant4)->EnableWindow(false); 
	}
	else if (m_pdlg->m_antscnt == 3)
	{
		GetDlgItem(IDC_rdant1)->EnableWindow(true);
		GetDlgItem(IDC_rdant2)->EnableWindow(true); 
		GetDlgItem(IDC_rdant3)->EnableWindow(true); 
		GetDlgItem(IDC_rdant4)->EnableWindow(false); 
	}
	else if (m_pdlg->m_antscnt == 4)
	{
		GetDlgItem(IDC_rdant1)->EnableWindow(true);
		GetDlgItem(IDC_rdant2)->EnableWindow(true); 
		GetDlgItem(IDC_rdant3)->EnableWindow(true); 
		GetDlgItem(IDC_rdant4)->EnableWindow(true); 
	}

	m_tbstartblk.SetWindowText("0");
	m_tbblkrange.SetWindowText("1");
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

int ValidBinStr(char *buf, int maxlen);
int ValidEditInt(CString num, int modnum, int maxnum);
int BinStr2data(CString str, unsigned char *buf);

int CCustomDlg::SetFilter_()
{
	if (m_isfilter)
	{
		
		int ret = ValidBinStr(m_fdata.GetBuffer(0), 240);
		if (ret == -1)
		{
			MessageBox("请在匹配数据中输入合法的2进制字符");
			return -1;
		}
		
		if (m_filterbank == -1)
		{
			MessageBox("必须选择过滤bank");
			return -1;
		}
		else if (ret == -4)
		{
			MessageBox("请输入匹配数据");
			return -1;
		}
		
		int addr = ValidEditInt(m_faddr, 1, -1);
		
		if (addr == -1)
		{
			MessageBox("请输入起始地址");
			return -1;
		}
		else if (addr == -2)
		{
			MessageBox("起始地址含有非法字符");
			return -1;
		}
		
		
		unsigned char matchdata[256];
		memset(matchdata, 0, 256);
		
		BinStr2data(m_fdata, matchdata);
		
		TagFilter_ST filter;
		filter.bank = m_filterbank+1;
		filter.fdata = matchdata;
		filter.flen = m_fdata.GetLength();
		filter.startaddr = addr;
		if (m_isMatch)
			filter.isInvert = 1;
		else
			filter.isInvert = 0;
		ParamSet(m_pdlg->m_reader, MTR_PARAM_TAG_FILTER, &filter);
	}
	else
	{
		ParamSet(m_pdlg->m_reader, MTR_PARAM_TAG_FILTER, NULL);
	}
	
	return 0;	
}

void CCustomDlg::OnbtnBlockReadLock() 
{
	// TODO: Add your control notification handler code here
	unsigned char blkbits = 0;
	UpdateData(TRUE);
	if (m_isblk8)
		blkbits |= 0x01;
	if (m_isblk7)
		blkbits |= 0x02;
	if (m_isblk6)
		blkbits |= 0x04;
	if (m_isblk5)
		blkbits |= 0x08;
	if (m_isblk4)
		blkbits |= 0x10;
	if (m_isblk3)
		blkbits |= 0x20;
	if (m_isblk2)
		blkbits |= 0x40;
	if (m_isblk1)
		blkbits |= 0x80;

	int ant = getAnt();
	if (ant == 0)
	{
		MessageBox("请选择天线");
		return;
	}
	

	ALIENHiggs3BlockReadLockPara para;

	if (Validaccpwd() < 0)
		return;

	if (SetFilter_() < 0)
		return;

	Str2Hex(m_accesspwd, 8, para.AccessPwd);
	
	para.TimeOut = 500;
	para.BlkBits = blkbits;
	if (CustomCmd(m_pdlg->m_reader, ant, ALIEN_Higgs3_BlockReadLock, &para, NULL) != MT_OK_ERR)
		MessageBox("操作失败");
}

void CCustomDlg::Onbtnsetimpinjqt() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	IMPINJM4QtPara para;
	para.TimeOut = 1000;
	IMPINJM4QtResult result;
	if (Validaccpwd() < 0)
		return;
	Str2Hex(m_accesspwd, 8, para.AccessPwd);

	if (SetFilter_() < 0)
		return;

	
	int ant = getAnt();
	if (ant == 0)
	{
		MessageBox("请选择天线");
		return;
	}


	if (m_impinjqtcmdread == -1)
	{
		MessageBox("请选择命令类型");
		return;
	}
	else
	{
		if (m_impinjqtcmdread == 0)
		{
			para.CmdType = 0;
		}
		else
		{
			para.CmdType = 1;
			if (m_impinjqtmempublic == -1)
			{
				MessageBox("请选择内存视图");
				return;
			}
			else
			{
				if (m_impinjqtmempublic == 0)
					para.MemType = 1;
				else
					para.MemType = 0;
			}
			if (m_impinjnear == -1)
			{
				MessageBox("请选择识别距离");
				return;
			}
			else
			{
				if (m_impinjnear == 0)
					para.RangeType = 1;
				else
					para.RangeType = 0;
			}
			if (m_impinjpersistperm == -1)
			{
				MessageBox("请选择状态类型");
				return;
			}
			else
			{
				if (m_impinjpersistperm == 0)
					para.PersistType = 1;
				else
					para.PersistType = 0;
			}
		}
	}

	if (CustomCmd(m_pdlg->m_reader, ant, IMPINJ_M4_Qt, &para, &result) != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
	if (m_impinjqtcmdread == 0)
	{
		if (result.MemType == 1)
			m_impinjqtmempublic = 0;
		else
			m_impinjqtmempublic = 1;
		if (result.RangeType == 1)
			m_impinjnear = 0;
		else
			m_impinjnear = 1;
		UpdateData(false);
	}
}

void CCustomDlg::Onbtnpermlockget() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	
	int ant = getAnt();
	if (ant == 0)
	{
		MessageBox("请选择天线");
		return;
	}
	
	unsigned char pwd[4];
	unsigned char mask[2];
	mask[0] = 0;
	mask[1] = 0;
	if (Validaccpwd() < 0)
		return;
	
	if (SetFilter_() < 0)
		return;
	
	Str2Hex(m_accesspwd, 8, pwd);

	if (BlockPermaLock(m_pdlg->m_reader, ant, 0, m_startblk, m_blkrange, mask, pwd, 1000) != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}

	if (((mask[0] >> 7) & 0x1) == 1)
		m_isperm1 = true;
	else
		m_isperm1 = false;
	if (((mask[0] >> 6) & 0x1) == 1)
		m_isperm2 = true;
	else
		m_isperm2 = false;
	if (((mask[0] >> 5) & 0x1) == 1)
		m_isperm3 = true;
	else
		m_isperm3 = false;
	if (((mask[0] >> 4) & 0x1) == 1)
		m_isperm4 = true;
	else
		m_isperm4 = false;
	if (((mask[0] >> 3) & 0x1) == 1)
		m_isperm5 = true;
	else
		m_isperm5 = false;
	if (((mask[0] >> 2) & 0x1) == 1)
		m_isperm6 = true;
	else
		m_isperm6 = false;
	if (((mask[0] >> 1) & 0x1) == 1)
		m_isperm7 = true;
	else
		m_isperm7 = false;
	if (((mask[0] >> 0) & 0x1) == 1)
		m_isperm8 = true;
	else
		m_isperm8 = false;

	UpdateData(false);
}

void CCustomDlg::Onbtnpermlockset() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	
	int ant = getAnt();
	if (ant == 0)
	{
		MessageBox("请选择天线");
		return;
	}
	
	unsigned char pwd[4];
	unsigned char mask[2];
	
	mask[0] = 0;
	mask[1] = 0;
	if (Validaccpwd() < 0)
		return;
	
	if (SetFilter_() < 0)
		return;
	
	Str2Hex(m_accesspwd, 8, pwd);
	
	if (m_isperm8)
		mask[0] |= 0x01;
	if (m_isperm7)
		mask[0] |= 0x02;
	if (m_isperm6)
		mask[0] |= 0x04;
	if (m_isperm5)
		mask[0] |= 0x08;
	if (m_isperm4)
		mask[0] |= 0x10;
	if (m_isperm3)
		mask[0] |= 0x20;
	if (m_isperm2)
		mask[0] |= 0x40;
	if (m_isperm1)
		mask[0] |= 0x80;

	if (BlockPermaLock(m_pdlg->m_reader, ant, 1, m_startblk, m_blkrange, mask, pwd, 1000) != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
}

/*
void CCustomDlg::OnButton5() 
{
	// TODO: Add your control notification handler code here
	unsigned char data[100];
// 	data[0] = 0x11;
// 	data[1] = 0x22;
// 	data[2] = 0x33;
// 	data[3] = 0x44;
// 	data[4] = 0x55;
// 	data[5] = 0x66;
// 	data[6] = 0x77;
// 	data[7] = 0x88;
// 	if (EraseDataOnReader(m_pdlg->m_reader) != MT_OK_ERR)
// 	{
// 		MessageBox("操作失败");
// 		return;
// 	}
// 	if (SaveDataOnReader(m_pdlg->m_reader, 0, data, 8) != MT_OK_ERR)
// 	{
// 		MessageBox("操作失败");
// 		return;
// 	}
	if (ReadDataOnReader(m_pdlg->m_reader, 0, data, 8) != MT_OK_ERR)
	{
 		MessageBox("操作失败");
 		return;
	}
}
*/
