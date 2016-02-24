// TestGpioDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ModuleReaderManager.h"
#include "TestGpioDlg.h"
#include "ModuleReader.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// TestGpioDlg dialog


TestGpioDlg::TestGpioDlg(CWnd* pParent, int reader, CModuleReaderManagerDlg *pdlg /*=NULL*/)
	: CDialog(TestGpioDlg::IDD, pParent)
	, m_recvstr(_T(""))
	, m_sendstr(_T(""))
	, m_psamslot(0)
{
	//{{AFX_DATA_INIT(TestGpioDlg)
	m_isgpi1 = FALSE;
	m_isgpi2 = FALSE;
	m_isgpi3 = FALSE;
	m_isgpi4 = FALSE;
	m_isgpo1 = FALSE;
	m_isgpo2 = FALSE;
	m_isgpo3 = FALSE;
	m_isgpo4 = FALSE;
	//}}AFX_DATA_INIT
	m_hreader = reader;
	m_pdlg = pdlg;
}


void TestGpioDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(TestGpioDlg)
	DDX_Check(pDX, IDC_ckgpi1, m_isgpi1);
	DDX_Check(pDX, IDC_ckgpi2, m_isgpi2);
	DDX_Check(pDX, IDC_ckgpi3, m_isgpi3);
	DDX_Check(pDX, IDC_ckgpi4, m_isgpi4);
	DDX_Check(pDX, IDC_ckgpo1, m_isgpo1);
	DDX_Check(pDX, IDC_ckgpo2, m_isgpo2);
	DDX_Check(pDX, IDC_ckgpo3, m_isgpo3);
	DDX_Check(pDX, IDC_ckgpo4, m_isgpo4);
	//}}AFX_DATA_MAP
	DDX_Text(pDX, IDC_etrecv, m_recvstr);
	DDX_Text(pDX, IDC_etsend, m_sendstr);
	DDX_CBIndex(pDX, IDC_cmbpsam, m_psamslot);
}


BEGIN_MESSAGE_MAP(TestGpioDlg, CDialog)
	//{{AFX_MSG_MAP(TestGpioDlg)
	ON_BN_CLICKED(IDC_btngetgpi, Onbtngetgpi)
	ON_BN_CLICKED(IDC_btnsetgpo, Onbtnsetgpo)
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDC_btnexec, &TestGpioDlg::OnBnClickedbtnexec)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// TestGpioDlg message handlers

void TestGpioDlg::Onbtngetgpi() 
{
	// TODO: Add your control notification handler code here
	int state;
	READER_ERR err;
	err = GetGPI(m_hreader, 1, &state);
	if (err != MT_OK_ERR)
	{
		MessageBox("获取gpi1错误");
	}
	else
	{
		if (state == 1)
			m_isgpi1 = TRUE;
		else
			m_isgpi1 = FALSE;
	}

	err = GetGPI(m_hreader, 2, &state);
	if (err != MT_OK_ERR)
	{
		MessageBox("获取gpi2错误");
	}
	else
	{
		if (state == 1)
			m_isgpi2 = TRUE;
		else
			m_isgpi2 = FALSE;
	}

	err = GetGPI(m_hreader, 3, &state);
	if (err != MT_OK_ERR)
	{
		MessageBox("获取gpi3错误");
	}
	else
	{
		if (state == 1)
			m_isgpi3 = TRUE;
		else
			m_isgpi3 = FALSE;
	}

	err = GetGPI(m_hreader, 4, &state);
	if (err != MT_OK_ERR)
	{
		MessageBox("获取gpi4错误");
	}
	else
	{
		if (state == 1)
			m_isgpi4 = TRUE;
		else
			m_isgpi4 = FALSE;
	}

	UpdateData(FALSE);
}

void TestGpioDlg::Onbtnsetgpo() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	int state;
	READER_ERR err;

	if (m_isgpo1)
		state = 1;
	else
		state = 0;
	err = SetGPO(m_hreader, 1, state);

	if (m_isgpo2)
		state = 1;
	else
		state = 0;
	err = SetGPO(m_hreader, 2, state);

	if (m_isgpo3)
		state = 1;
	else
		state = 0;
	err = SetGPO(m_hreader, 3, state);

	if (m_isgpo4)
		state = 1;
	else
		state = 0;
	err = SetGPO(m_hreader, 4, state);
}

void TestGpioDlg::OnBnClickedbtnexec()
{
	// TODO: 在此添加控件通知处理程序代码
	UpdateData(TRUE);
	if (m_psamslot == -1)
	{
		MessageBox("请选择PSAM卡槽");
		return;
	}
	if (m_pdlg->ValidHexStr(m_sendstr.GetBuffer(0)) != 0)
	{
		MessageBox("请输入合法的cos命令");
		return;
	}
	unsigned char cos[256];
	Str2Hex(m_sendstr, m_sendstr.GetLength(), cos);
	unsigned char cosresp[256];
	int cosresplen;
	unsigned char psamerr;
	READER_ERR rerr = PsamTransceiver(m_hreader, m_psamslot+1, m_sendstr.GetLength()/2, cos,
		&cosresplen, cosresp, &psamerr, 300);
	if (rerr != MT_OK_ERR)
	{
		CString errnum;
		errnum.Format("%d", rerr);
		CString tipstr = "执行失败，错误码:";
		tipstr += errnum;
		MessageBox(tipstr);
		return;
	}
	else
	{
		if (psamerr != 0)
		{
			CString errnum;
			errnum.Format("%d", psamerr);
			CString tipstr = "执行失败，子系统错误码:";
			tipstr += errnum;
			MessageBox(tipstr);
			return;
		}
		else
		{
			if (cosresplen > 0)
			{
				char recvstr[512];
				Hex2Str(cosresp, cosresplen, recvstr);
				m_recvstr = recvstr;
				UpdateData(FALSE);
			}
		}
	}
}
