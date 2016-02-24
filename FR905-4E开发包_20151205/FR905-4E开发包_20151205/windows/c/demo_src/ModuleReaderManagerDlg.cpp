// ModuleReaderManagerDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ModuleReaderManager.h"
#include "ModuleReaderManagerDlg.h"
#include "CustomDlg.h"
#include "ISO180006bOpDlg.h"
#include "OtherParams.h"
#include "Arm7_16AntSetDlg.h"
#include "TestGpioDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
		// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CModuleReaderManagerDlg dialog

CModuleReaderManagerDlg::CModuleReaderManagerDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CModuleReaderManagerDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CModuleReaderManagerDlg)
	m_sourcestr = _T("");
	m_isfilter = FALSE;
	m_fdata = _T("");
	m_faddr = _T("");
	m_addr = _T("");
	m_blks = _T("");
	m_ispwd = FALSE;
	m_accesspwd = _T("");
	m_isMatch = FALSE;
	m_bant1 = FALSE;
	m_bant2 = FALSE;
	m_bant3 = FALSE;
	m_bant4 = FALSE;
	m_filterbank = -1;
	m_wrdata = _T("");
	m_wrbank = -1;
	m_lockobj = -1;
	m_locktype = -1;
	m_repisrand = FALSE;
	m_repisrep = FALSE;
	logstr = _T("");
	m_repcnt = _T("");
	m_randlen = _T("");
	m_timeout = "1000";
	m_addbytes = -1;
	m_addbank = -1;
	m_session = -1;
	m_isadddata = FALSE;
	m_ip = _T("");
	m_subnet = _T("");
	m_gateway = _T("");
	m_ant1rp = _T("");
	m_ant1wp = _T("");
	m_ant2rp = _T("");
	m_ant2wp = _T("");
	m_ant3rp = _T("");
	m_ant3wp = _T("");
	m_ant4rp = _T("");
	m_ant4wp = _T("");
	m_ebstartaddr = _T("");
	m_maxepc = -1;
	m_is180006b = FALSE;
	m_isGen2 = FALSE;
	m_ReaderIndex = -1;
	m_BoardType = _T("");
	m_ModuleType = _T("");
	m_isIpx256 = FALSE;
	m_isIpx64 = FALSE;
	m_readdur = 0;
	m_sleepdur = 0;
	m_emdbytecnt = _T("");
	isInit = 0;
	isTestRun = FALSE;
	ismachstoptest = FALSE;
	isIP = false;
	isGetIp = false;
	m_tagscnt = 0;
	m_isTagInvRun = false;
	selcnts = 0;
	m_isasyncread = FALSE;
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	AfxInitRichEdit();


}

void CModuleReaderManagerDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CModuleReaderManagerDlg)
	DDX_Control(pDX, IDC_Chkasyncread, m_conisasyncread);
	DDX_Control(pDX, IDC_btnkill, m_btnkill);
	DDX_Control(pDX, IDC_btnrandrw, m_btnrandrw);
	DDX_Control(pDX, IDC_btnwriteepc, m_writeepc);
	DDX_Control(pDX, IDC_btntestgpio, m_testgpio);
	DDX_Control(pDX, IDC_btnotherparam, m_otherparams);
	DDX_Control(pDX, IDC_btn180006bop, m_180006bop);
	DDX_Control(pDX, IDC_btn16antsset, m_16antsset);
	DDX_Control(pDX, IDC_listtags, m_listtags);
	DDX_Control(pDX, IDC_CKIPX64, m_cisIpx64);
	DDX_Control(pDX, IDC_CKIPX256, m_cisIpx256);
	DDX_Control(pDX, IDC_CKISO180006B, m_cis180006b);
	DDX_Control(pDX, IDC_CKGEN2, m_cisgen2);
	DDX_Control(pDX, IDC_btnCustomCmd, m_btnCustcmd);
	DDX_Control(pDX, IDC_tbgateway, m_gatewayc);
	DDX_Control(pDX, IDC_tbsubnet, m_subnetc);
	DDX_Control(pDX, IDC_tbip, m_ipc);
	DDX_Control(pDX, IDC_tbant4wp, m_ant4wpc);
	DDX_Control(pDX, IDC_tbant4rp, m_ant4rpc);
	DDX_Control(pDX, IDC_tbant3wp, m_ant3wpc);
	DDX_Control(pDX, IDC_tbant3rp, m_ant3rpc);
	DDX_Control(pDX, IDC_tbant2wp, m_ant2wpc);
	DDX_Control(pDX, IDC_tbant2rp, m_ant2rpc);
	DDX_Control(pDX, IDC_tbant1wp, m_ant1wpc);
	DDX_Control(pDX, IDC_tbant1rp, m_ant1rpc);
	DDX_Control(pDX, IDC_btnsetconf, m_setconf);
	DDX_Control(pDX, IDC_btngetconf, m_getconf);
	DDX_Control(pDX, IDC_btnstoptest, m_stoptest);
	DDX_Control(pDX, IDC_btnconnect, m_btnconnect);
	DDX_Control(pDX, IDC_btnlock, m_btnlock);
	DDX_Control(pDX, IDC_btnwrite, m_btnwrite);
	DDX_Control(pDX, IDC_btnstop, m_btnstop);
	DDX_Control(pDX, IDC_btnstart, m_btnstart);
	DDX_Control(pDX, IDC_btnread, m_btnread);
	DDX_Control(pDX, IDC_ccant4, m_ant4);
	DDX_Control(pDX, IDC_ccant3, m_ant3);
	DDX_Control(pDX, IDC_ccant2, m_ant2);
	DDX_Control(pDX, IDC_ccant1, m_ant1);
	DDX_Text(pDX, IDC_tbsrcstr, m_sourcestr);
	DDX_Check(pDX, IDC_ccfilter, m_isfilter);
	DDX_Text(pDX, IDC_tbfdata, m_fdata);
	DDX_Text(pDX, IDC_tbfaddr, m_faddr);
	DDX_Text(pDX, IDC_tbaddr, m_addr);
	DDX_Text(pDX, IDC_tbblocks, m_blks);
	DDX_Check(pDX, IDC_ccpwd, m_ispwd);
	DDX_Text(pDX, IDC_tbaccesspwd, m_accesspwd);
	DDX_Check(pDX, IDC_ccInvert, m_isMatch);
	DDX_Check(pDX, IDC_ccant1, m_bant1);
	DDX_Check(pDX, IDC_ccant2, m_bant2);
	DDX_Check(pDX, IDC_ccant3, m_bant3);
	DDX_Check(pDX, IDC_ccant4, m_bant4);
	DDX_CBIndex(pDX, IDC_fiterbank, m_filterbank);
	DDX_Text(pDX, IDC_wrdata, m_wrdata);
	DDX_CBIndex(pDX, IDC_wrbank, m_wrbank);
	DDX_CBIndex(pDX, IDC_lockobj, m_lockobj);
	DDX_CBIndex(pDX, IDC_locktype, m_locktype);
	DDX_Check(pDX, IDC_repsirand, m_repisrand);
	DDX_Check(pDX, IDC_repisrep, m_repisrep);
	DDX_Text(pDX, IDC_redloginfo, logstr);
	DDX_Text(pDX, IDC_repcnt, m_repcnt);
	DDX_Text(pDX, IDC_reprandlen, m_randlen);
	DDX_Text(pDX, IDC_timeout, m_timeout);
	DDX_CBIndex(pDX, IDC_cbaddbank, m_addbank);
	DDX_CBIndex(pDX, IDC_cbsess, m_session);
	DDX_Check(pDX, IDC_ckisaddtiondata, m_isadddata);
	DDX_Text(pDX, IDC_tbip, m_ip);
	DDX_Text(pDX, IDC_tbsubnet, m_subnet);
	DDX_Text(pDX, IDC_tbgateway, m_gateway);
	DDX_Text(pDX, IDC_tbant1rp, m_ant1rp);
	DDX_Text(pDX, IDC_tbant1wp, m_ant1wp);
	DDX_Text(pDX, IDC_tbant2rp, m_ant2rp);
	DDX_Text(pDX, IDC_tbant2wp, m_ant2wp);
	DDX_Text(pDX, IDC_tbant3rp, m_ant3rp);
	DDX_Text(pDX, IDC_tbant3wp, m_ant3wp);
	DDX_Text(pDX, IDC_tbant4rp, m_ant4rp);
	DDX_Text(pDX, IDC_tbant4wp, m_ant4wp);
	DDX_Text(pDX, IDC_tbebstartaddr, m_ebstartaddr);
	DDX_CBIndex(pDX, IDC_cbmaxepc, m_maxepc);
	DDX_Check(pDX, IDC_CKISO180006B, m_is180006b);
	DDX_Check(pDX, IDC_CKGEN2, m_isGen2);
	DDX_CBIndex(pDX, IDC_readertype, m_ReaderIndex);
	DDX_Text(pDX, IDC_STATIC_boardtype, m_BoardType);
	DDX_Text(pDX, IDC_STATIC_moduletype, m_ModuleType);
	DDX_Check(pDX, IDC_CKIPX256, m_isIpx256);
	DDX_Check(pDX, IDC_CKIPX64, m_isIpx64);
	DDX_Text(pDX, IDC_tbreaddur, m_readdur);
	DDV_MinMaxInt(pDX, m_readdur, 0, 65535);
	DDX_Text(pDX, IDC_tbsleepdur, m_sleepdur);
	DDV_MinMaxInt(pDX, m_sleepdur, 0, 65535);
	DDX_Text(pDX, IDC_tbemdbytes, m_emdbytecnt);
	DDX_Check(pDX, IDC_Chkasyncread, m_isasyncread);
	//}}AFX_DATA_MAP
	DDX_Control(pDX, IDC_btndisconnect, m_btndisc);
}

BEGIN_MESSAGE_MAP(CModuleReaderManagerDlg, CDialog)
	//{{AFX_MSG_MAP(CModuleReaderManagerDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_btnconnect, Onbtnconnect)
	ON_BN_CLICKED(IDC_btnstart, Onbtnstart)
	ON_BN_CLICKED(IDC_btnstop, Onbtnstop)
	ON_BN_CLICKED(IDC_btnread, Onbtnread)
	ON_BN_CLICKED(IDC_btnwrite, Onbtnwrite)
	ON_BN_CLICKED(IDC_btnlock, Onbtnlock)
	ON_BN_CLICKED(IDC_btnstoptest, Onbtnstoptest)
	ON_WM_CLOSE()
	ON_BN_CLICKED(IDC_btnsetconf, Onbtnsetconf)
	ON_BN_CLICKED(IDC_btngetconf, Onbtngetconf)
	ON_BN_CLICKED(IDC_btnCustomCmd, OnbtnCustomCmd)
	ON_BN_CLICKED(IDC_btnwriteepc, Onbtnwriteepc)
	ON_BN_CLICKED(IDC_btn180006bop, Onbtn180006bop)
	ON_BN_CLICKED(IDC_btntestgpio, Onbtntestgpio)
	ON_BN_CLICKED(IDC_btnotherparam, Onbtnotherparam)
	ON_MESSAGE(WM_MY_MSG_TAGINV, OnTagInv)
	ON_BN_CLICKED(IDC_btnclear, Onbtnclear)
	ON_BN_CLICKED(IDC_btn16antsset, Onbtn16antsset)
	ON_BN_CLICKED(IDC_btnrandrw, Onbtnrandrw)
	ON_BN_CLICKED(IDC_btnclearlog, Onbtnclearlog)
	ON_BN_CLICKED(IDC_btnkill, Onbtnkill)
	ON_WM_TIMER()
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDC_btndisconnect, &CModuleReaderManagerDlg::OnBnClickedbtndisconnect)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CModuleReaderManagerDlg message handlers


int ValidEditInt(CString num, int modnum, int maxnum)
{
	if (num == "")
		return -1;
	char *intchar = num.GetBuffer(0);
	for (int i = 0; i < num.GetLength(); ++i)
	{
		if (intchar[i] < '0' || intchar[i] > '9')
			return -2;
	}

	int a = atoi(intchar);

	if (a % modnum != 0)
		return -3;

	if (maxnum != -1)
	{
		if (a > maxnum)
			return -4;
	}

	return a;
}

int CModuleReaderManagerDlg::ValidHexStr(char *buf)
{
	char buf_[600];
	strcpy(buf_, buf);


	int len = strlen(buf);
	if (len == 0)
		return -4;

	CharUpper(buf_);
	for (int i = 0; i < len; ++i)
	{
		if (!((buf_[i] >= '0' && buf_[i] <= '9') || (buf_[i] >= 'A' && buf_[i] <= 'F')))
			return -1;
	}

	return 0;
}

int CModuleReaderManagerDlg::ValidHexStr(char *buf, int maxlen)
{
	char buf_[600];
	strcpy(buf_, buf);
	
	
	int len = strlen(buf);
	if (len == 0)
		return -4;
	if (len > maxlen)
		return -3;
	if (len % 4 != 0)
		return -2;
	
	CharUpper(buf_);
	for (int i = 0; i < len; ++i)
	{
		if (!((buf_[i] >= '0' && buf_[i] <= '9') || (buf_[i] >= 'A' && buf_[i] <= 'F')))
			return -1;
	}
	
	return 0;
}

BOOL CModuleReaderManagerDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// TODO: Add extra initialization here
	
	m_btnlock.EnableWindow(FALSE);
	m_btnkill.EnableWindow(FALSE);
	m_btnCustcmd.EnableWindow(FALSE);
	m_btnwrite.EnableWindow(FALSE);
	m_btnstop.EnableWindow(FALSE);
	m_btnstart.EnableWindow(FALSE);
	m_btnread.EnableWindow(FALSE);
	m_ant1.EnableWindow(FALSE);
	m_ant2.EnableWindow(FALSE);
	m_ant3.EnableWindow(FALSE);
	m_ant4.EnableWindow(FALSE);
	m_stoptest.EnableWindow(FALSE);
	m_setconf.EnableWindow(FALSE);
	m_getconf.EnableWindow(FALSE);
	m_cisgen2.EnableWindow(FALSE);
	m_cis180006b.EnableWindow(FALSE);
	m_cisIpx64.EnableWindow(FALSE);
	m_cisIpx256.EnableWindow(FALSE);

	m_180006bop.EnableWindow(FALSE);
	m_testgpio.EnableWindow(FALSE);
	m_otherparams.EnableWindow(FALSE);
	m_writeepc.EnableWindow(FALSE);
	m_btnrandrw.EnableWindow(FALSE);
	m_btndisc.EnableWindow(FALSE);
	m_isGen2 = TRUE;
	m_readdur = 150;
	m_sleepdur = 300;
	UpdateData(FALSE);

	m_listtags.ModifyStyle(LVS_TYPEMASK, LVS_REPORT);
	m_listtags.SetExtendedStyle(LVS_EX_FULLROWSELECT|LVS_EX_GRIDLINES); 
	m_listtags.InsertColumn(0,"序号");
	m_listtags.SetColumnWidth(0, 40);
	m_listtags.InsertColumn(1,"EPC"); 
	m_listtags.SetColumnWidth(1, 160);
	m_listtags.InsertColumn(2,"天线");
	m_listtags.SetColumnWidth(2, 40);
	m_listtags.InsertColumn(3,"次数");
	m_listtags.SetColumnWidth(3, 40);
	m_listtags.InsertColumn(4,"协议");
	m_listtags.SetColumnWidth(4, 40);
	m_listtags.InsertColumn(5,"附加数据");
	m_listtags.SetColumnWidth(5, 65);
	m_16antsset.EnableWindow(FALSE);
	m_hMutex = CreateMutex(NULL, FALSE, NULL);
	return TRUE;  // return TRUE  unless you set the focus to a control
}



void CModuleReaderManagerDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CModuleReaderManagerDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CModuleReaderManagerDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void OnErrPrint(READER_ERR errcode, void* cookie)
{
	TRACE("err when reading :%d\n", errcode);
}

void CalcPwdFromEpc(const unsigned char *epc , int epclen, 
					void *cookie, unsigned char *accesspwd)
{
	char epcstr[128];
	Hex2Str((unsigned char*)epc, epclen, epcstr);
	//	TRACE("CalcPwdFromEpc epc:%s\n", epcstr);
	int index = epc[epclen-1] % 4;
	if (index == 0)
	{
		accesspwd[0] = 0x55;
		accesspwd[1] = 0x55;
		accesspwd[2] = 0x55;
		accesspwd[3] = 0x55;
	}
	else if (index == 1)
	{
		accesspwd[0] = 0x11;
		accesspwd[1] = 0x11;
		accesspwd[2] = 0x11;
		accesspwd[3] = 0x11;
	}
	else if (index == 2)
	{
		accesspwd[0] = 0x22;
		accesspwd[1] = 0x22;
		accesspwd[2] = 0x22;
		accesspwd[3] = 0x22;
	}
	else if (index == 3)
	{
		accesspwd[0] = 0x33;
		accesspwd[1] = 0x33;
		accesspwd[2] = 0x33;
		accesspwd[3] = 0x33;
	}
}


void CModuleReaderManagerDlg::Onbtnconnect() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	READER_ERR err;
    char tmpbuf[10];

	if (m_sourcestr == "")
	{
		MessageBox("请输入读写器地址");
		return;
	}
	if (m_ReaderIndex == -1)
	{
		MessageBox("请选择读写器类型");
		return;
	}

	int st = GetTickCount();
	if (m_ReaderIndex == 4)
		err = InitReader_Notype(&m_reader, m_sourcestr.GetBuffer(0), 16);
	else
		err = InitReader_Notype(&m_reader, m_sourcestr.GetBuffer(0), 1+m_ReaderIndex);

	TRACE("dur: %d", GetTickCount() -st);
	if (err != MT_OK_ERR)
	{
		CString errsr = "连接失败, 错误码：";
		errsr += _itoa(err, tmpbuf, 10);
		MessageBox(errsr);
		return;
	}
	
	GetHardwareDetails(m_reader, &hwdtls);
	if (m_ReaderIndex == 4)
		m_antscnt = 16;
	else
		m_antscnt = m_ReaderIndex + 1;
	char buf_[50];
	strcpy(buf_, m_sourcestr);
	CharUpper(buf_);
	/////
//	ConnAnts_ST cast;
//	err = ParamGet(m_reader, MTR_PARAM_READER_CONN_ANTS, &cast);
	/////
	if (hwdtls.board == MAINBOARD_ARM7 || hwdtls.board == MAINBOARD_ARM9 || 
		hwdtls.board == MAINBOARD_ARM9_WIFI)
	{
		if (strstr(buf_, "COM") != NULL)
			isIP = FALSE;
		else
			isIP = TRUE;
	}
	else
		isIP = FALSE;
		
	if (!isIP)
	{
		m_ipc.EnableWindow(FALSE);
		m_subnetc.EnableWindow(FALSE);
		m_gatewayc.EnableWindow(FALSE);
	}

	if (hwdtls.board == MAINBOARD_ARM7)
		m_BoardType = "arm7 主板";
	else if (hwdtls.board == MAINBOARD_SERIAL)
		m_BoardType = "串口 主板";
	else if (hwdtls.board == MAINBOARD_WIFI)
		m_BoardType = "wifi 主板";
	else if (hwdtls.board == MAINBOARD_ARM9)
		m_BoardType = "arm9 主板";
	else if (hwdtls.board == MAINBOARD_ARM9_WIFI)
		m_BoardType = "arm9_wifi 主板";
	
	if (hwdtls.module == MODOULE_R902_M1S)
		m_ModuleType = "r902_m1s";
	else if (hwdtls.module == MODOULE_R902_M2S)
		m_ModuleType = "r902_m2s";
	else if (hwdtls.module == MODOULE_M5E)
		m_ModuleType = "m5e";
	else if (hwdtls.module == MODOULE_SLR1100)
		m_ModuleType = "slr1100";
	else if (hwdtls.module == MODOULE_SLR1200)
		m_ModuleType = "slr1200";
	else if (hwdtls.module == MODOULE_SLR3000)
		m_ModuleType = "slr3000";
	else if (hwdtls.module == MODOULE_SLR5100)
		m_ModuleType = "slr5100";
	else if (hwdtls.module == MODOULE_SLR5200)
		m_ModuleType = "slr5200";
	else if (hwdtls.module == MODOULE_SLR3100)
		m_ModuleType = "slr3100";
	else if (hwdtls.module == MODOULE_SLR3200)
		m_ModuleType = "slr3200";
	else if (hwdtls.module == MODOULE_SLR1300)
		m_ModuleType = "slr1300";
	else if (hwdtls.module == MODOULE_M5E_PRC)
		m_ModuleType = "m5e-prc";
	else if (hwdtls.module == MODOULE_M6E)
		m_ModuleType = "m6e";
	else if (hwdtls.module == MODOULE_M6E_PRC)
		m_ModuleType = "m6e-prc";
	else if (hwdtls.module == MODOULE_M5E_C)
		m_ModuleType = "m5e_c";
	else if (hwdtls.module == MODOULE_M6E_MICRO)
		m_ModuleType = "m6e_micro";

	m_readertype = hwdtls.logictype;
	

	if (m_antscnt == 1)
	{
		this->m_ant1.EnableWindow(TRUE);
		m_ant1rpc.EnableWindow(TRUE);
		m_ant1wpc.EnableWindow(TRUE);
		m_ant2rpc.EnableWindow(FALSE);
		m_ant2wpc.EnableWindow(FALSE);
		m_ant3rpc.EnableWindow(FALSE);
		m_ant3wpc.EnableWindow(FALSE);
		m_ant4rpc.EnableWindow(FALSE);
		m_ant4wpc.EnableWindow(FALSE);
	}
	else if (m_antscnt == 2)
	{
		this->m_ant1.EnableWindow(TRUE);
		this->m_ant2.EnableWindow(TRUE);
		m_ant1rpc.EnableWindow(TRUE);
		m_ant1wpc.EnableWindow(TRUE);
		m_ant2rpc.EnableWindow(TRUE);
		m_ant2wpc.EnableWindow(TRUE);
		m_ant3rpc.EnableWindow(FALSE);
		m_ant3wpc.EnableWindow(FALSE);
		m_ant4rpc.EnableWindow(FALSE);
		m_ant4wpc.EnableWindow(FALSE);
	}
	else if (m_antscnt == 3)
	{
		this->m_ant1.EnableWindow(TRUE);
		this->m_ant2.EnableWindow(TRUE);
		this->m_ant3.EnableWindow(TRUE);
		m_ant1rpc.EnableWindow(TRUE);
		m_ant1wpc.EnableWindow(TRUE);
		m_ant2rpc.EnableWindow(TRUE);
		m_ant2wpc.EnableWindow(TRUE);
		m_ant3rpc.EnableWindow(TRUE);
		m_ant3wpc.EnableWindow(TRUE);
		m_ant4rpc.EnableWindow(FALSE);
		m_ant4wpc.EnableWindow(FALSE);
	}
	else if (m_antscnt == 4)
	{
		this->m_ant1.EnableWindow(TRUE);
		this->m_ant2.EnableWindow(TRUE);
		this->m_ant3.EnableWindow(TRUE);
		this->m_ant4.EnableWindow(TRUE);

		m_ant1rpc.EnableWindow(TRUE);
		m_ant1wpc.EnableWindow(TRUE);
		m_ant2rpc.EnableWindow(TRUE);
		m_ant2wpc.EnableWindow(TRUE);
		m_ant3rpc.EnableWindow(TRUE);
		m_ant3wpc.EnableWindow(TRUE);
		m_ant4rpc.EnableWindow(TRUE);
		m_ant4wpc.EnableWindow(TRUE);
	}
	else if (m_antscnt == 16)
	{
		m_ant1rpc.EnableWindow(FALSE);
		m_ant1wpc.EnableWindow(FALSE);
		m_ant2rpc.EnableWindow(FALSE);
		m_ant2wpc.EnableWindow(FALSE);
		m_ant3rpc.EnableWindow(FALSE);
		m_ant3wpc.EnableWindow(FALSE);
		m_ant4rpc.EnableWindow(FALSE);
		m_ant4wpc.EnableWindow(FALSE);
		m_16antsset.EnableWindow(TRUE);
		
	}

	if (hwdtls.module == MODOULE_M6E || hwdtls.module == MODOULE_M6E_PRC
		|| hwdtls.module == MODOULE_M6E_MICRO)
	{
		m_cisIpx64.EnableWindow(TRUE);
		m_cisIpx256.EnableWindow(TRUE);
		m_cis180006b.EnableWindow(TRUE);
		m_cisgen2.EnableWindow(TRUE);
		m_isGen2 = FALSE;
		m_is180006b = FALSE;
		m_isIpx64 = FALSE;
		m_isIpx256 = FALSE;

		MT_TagStreamingOnTagBlock otbok;
		otbok.cookie = this;
		otbok.handler = OnReadTag;
		SetTagStreamingOnTagHandler(m_reader, &otbok);
		
		MT_TagStreamingOnErrorBlock oebok;
		oebok.cookie = NULL;
		oebok.handler = OnErrPrint;
		SetTagStreamingOnErrHandler(m_reader, &oebok);
		
		MT_AuthReqCallbackBlock arbok;
		arbok.cookie = NULL;
		arbok.GetAccessPwdFromEpc = CalcPwdFromEpc;
		SetAuthReqCallbackBlock(m_reader, &arbok);
	}

	UpdateData(FALSE);

// 	if (SetGen2MVal(m_reader, 3) != MT_OK_ERR)
// 	{
// 		MessageBox("设置M错误");
// 		CloseReader(m_reader);
// 		return;
// 	}
	
//	m_readertype += 1;


	m_btnconnect.EnableWindow(FALSE);
	m_btnCustcmd.EnableWindow(TRUE);
	m_btnlock.EnableWindow(TRUE);
	m_btnkill.EnableWindow(TRUE);
	m_btnwrite.EnableWindow(TRUE);
	//	m_btnstop.EnableWindow(TRUE);
	m_btnstart.EnableWindow(TRUE);
	m_btnread.EnableWindow(TRUE);
	m_setconf.EnableWindow(TRUE);
	m_getconf.EnableWindow(TRUE);

	m_180006bop.EnableWindow(TRUE);
	m_testgpio.EnableWindow(TRUE);
	m_otherparams.EnableWindow(TRUE);
	m_writeepc.EnableWindow(TRUE);
	m_stoptest.EnableWindow(TRUE);
	m_btnrandrw.EnableWindow(TRUE);
	Onbtngetconf();
	isInit = 1;
	m_btndisc.EnableWindow(TRUE);
}

int CModuleReaderManagerDlg::Validwdata()
{
	int ret = ValidHexStr(m_wrdata.GetBuffer(0), 480);
	if (ret == -1)
	{
		MessageBox("要被写入的数据包含非法字符");
		return -1;
	}
	else if (ret == -2)
	{
		MessageBox("需要被写入的数据字符串长度必须是4的倍数");
		return -1;
	}
	else if (ret == -4)
	{
		MessageBox("请输入要写入的数据");
		return -1;
	}

	return 0;
}

int CModuleReaderManagerDlg::Validaccpwd()
{
	int ret = ValidHexStr(m_accesspwd.GetBuffer(0), 8);
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
		MessageBox("请输入要写入的访问密码 ");
		return -1;
	}
	return 0;
}


int CModuleReaderManagerDlg::ValidAntenna(int num)
{
	if (m_readertype != ARM7_16ANTS)
	{
		
		int antcnt = 0;
		if (m_bant1)
			antcnt++;
		if (m_bant2)
			antcnt++;
		if (m_bant3)
			antcnt++;
		if (m_bant4)
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
	else
	{
		if (selcnts == 0)
		{
			MessageBox("没有选择天线");
			return -1;
		}
		if (num ==1)
		{
			if (selcnts > 1)
			{
				MessageBox("必须且只能选择一个天线");
				return -1;
			}

		}
		return 0;
	}
	
}

int ValidBinStr(char *buf, int maxlen)
{
	char buf_[600];
	strcpy(buf_, buf);
	
	
	int len = strlen(buf);
	if (len == 0)
		return -4;
	if (len > maxlen)
		return -3;

	for (int i = 0; i < len; ++i)
	{
		if (!(buf_[i] == '0' || buf_[i] == '1'))
			return -1;
	}
	
	return 0;
}

int BinStr2data(CString str, unsigned char *buf)
{
	int len = str.GetLength();
	int bytecnt = 0;
	int i = 0;
	for (i = 0; i < len/8; ++i)
	{
		buf[i] = (unsigned char)strtol(str.Mid(i * 8, 8), NULL, 2);
	}
	if (len % 8 != 0)
	{
		unsigned char tmp = (unsigned char)strtol(str.Mid(i * 8, len % 8), NULL, 2);
		buf[i] = tmp << (8-(len % 8));
		i++;
	}

	return i;
}

int CModuleReaderManagerDlg::SetFilter_()
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
		ParamSet(m_reader, MTR_PARAM_TAG_FILTER, &filter);
	}
	else
	{
		ParamSet(m_reader, MTR_PARAM_TAG_FILTER, NULL);
	}

	return 0;	
}


void CModuleReaderManagerDlg::Onbtnstart() 
{
	
	UpdateData(TRUE);

	Inv_Potls_ST invpotls;
	if (m_readertype == 7 || m_readertype == 8 || m_readertype == ARM7_16ANTS ||
		m_readertype == SL_COMMN_READER)
	{
		
		invpotls.potlcnt = 0;

		if (m_is180006b)
			invpotls.potls[invpotls.potlcnt++].potl = SL_TAG_PROTOCOL_ISO180006B;
		if (m_isGen2)
			invpotls.potls[invpotls.potlcnt++].potl = SL_TAG_PROTOCOL_GEN2;
		if (m_isIpx64)
			invpotls.potls[invpotls.potlcnt++].potl = SL_TAG_PROTOCOL_IPX64;
		if (m_isIpx256)
			invpotls.potls[invpotls.potlcnt++].potl = SL_TAG_PROTOCOL_IPX256;
		if (invpotls.potlcnt == 0)
		{
			MessageBox("请选择协议");
			return;
		}
		for (int w = 0; w < invpotls.potlcnt; ++w)
			invpotls.potls[w].weight = 30;

		ParamSet(m_reader, MTR_PARAM_TAG_INVPOTL, &invpotls);
	}

	if (SetFilter_() < 0)
		return;


	if (ValidAntenna(4) < 0)
		return;
	
// 	if (!(invpotls.potlcnt == 1 && invpotls.potls[0].potl == SL_TAG_PROTOCOL_ISO180006B))
// 	{
		if (m_isadddata)
		{
			EmbededData_ST embd;
			int addr = ValidEditInt(m_ebstartaddr, 1, -1);
			if (addr < 0)
			{
				MessageBox("附加数据的起始地址不合法");
				return;
			}
			if (m_addbank == -1)
			{
				MessageBox("请选择附加数据的bank");
				return;
			}
			int emdbytecnt = ValidEditInt(m_emdbytecnt, 1, 128);
			if (emdbytecnt < 0)
			{
				MessageBox("附加数据的字节数只能是1到128");
				return;
			}
			
			unsigned char *pwd = NULL;
			if (m_ispwd)
			{
				if (Validaccpwd() < 0)
					return;
				
				unsigned char unpwd[50];
				memset(unpwd, 0, 50);
				Str2Hex(m_accesspwd, 8, unpwd);
				pwd = unpwd;
			}
			embd.bank = m_addbank;
			embd.startaddr = addr;
			embd.bytecnt = emdbytecnt;
			embd.accesspwd = pwd;
			ParamSet(m_reader, MTR_PARAM_TAG_EMBEDEDDATA, &embd);
		}
		else
			ParamSet(m_reader, MTR_PARAM_TAG_EMBEDEDDATA, NULL);
// 	}
// 	else
// 		ParamSet(m_reader, MTR_PARAM_TAG_EMBEDEDDATA, NULL);


	if (m_readertype != ARM7_16ANTS)
	{
		
		selcnts = 0;
		
		if (m_bant1)
		{
			selectants[selcnts++] = 1;
		}
		if (m_bant2)
		{
			selectants[selcnts++] = 2;
		}
		if (m_bant3)
		{
			selectants[selcnts++] = 3;
		}
		if (m_bant4)
		{
			selectants[selcnts++] = 4;
		}
	}

	if (m_isasyncread)
	{

		READER_ERR ret = StartTagStreaming(m_reader, selectants, selcnts, m_readdur);
		if (ret != MT_OK_ERR)
		{
			char numbuf[10];
			CString aserrstr = "启动异步读取失败, 错误码：";
			aserrstr += _itoa(ret, numbuf, 10);
			MessageBox(aserrstr);
			return;
		}
		m_conisasyncread.EnableWindow(FALSE);
	}
	else
	{
		// TODO: Add your control notification handler code here
		m_isTagInvRun = true;
		DWORD dwThreadId;
		m_hTagInvTh = CreateThread( 
			NULL,              // default security attributes
			0,                 // use default stack size  
			ThreadTagInventory,        // thread function 
			this,             // argument to thread function 
			0,                 // use default creation flags 
			&dwThreadId);   // returns the thread identifier 
		
		if (m_hTagInvTh == NULL)
		{
			MessageBox("创建线程失败");
			return;
		}
	}

	m_btnstart.EnableWindow(FALSE);
	m_btnstop.EnableWindow(TRUE);
	m_btnread.EnableWindow(FALSE);
	m_btnwrite.EnableWindow(FALSE);
	m_btnCustcmd.EnableWindow(FALSE);
	m_btnlock.EnableWindow(FALSE);
	m_btnkill.EnableWindow(FALSE);
	m_stoptest.EnableWindow(FALSE);
	m_setconf.EnableWindow(FALSE);
	m_getconf.EnableWindow(FALSE);



}

void CModuleReaderManagerDlg::Onbtnclear() 
{
	// TODO: Add your control notification handler code here
	this->m_listtags.DeleteAllItems();
}

void CModuleReaderManagerDlg::Onbtnstop() 
{
	// TODO: Add your control notification handler code here
//	KillTimer(1);
	UpdateData(TRUE);
	if (m_isasyncread)
	{
		DWORD dwThreadId;
		
		CreateThread( 
			NULL,              // default security attributes
			0,                 // use default stack size  
			StopAsyncReadingFunc,        // thread function 
			this,             // argument to thread function 
			0,                 // use default creation flags 
		&dwThreadId);   // returns the thread identifier 
		m_conisasyncread.EnableWindow(TRUE);
	}
	else
	{
		m_isTagInvRun = false;
		WaitForSingleObject(m_hTagInvTh, INFINITE);
		CloseHandle(m_hTagInvTh);
	}

	m_btnstop.EnableWindow(FALSE);
	m_btnstart.EnableWindow(TRUE);
	m_btnread.EnableWindow(TRUE);
	m_btnwrite.EnableWindow(TRUE);
	m_btnlock.EnableWindow(TRUE);
	m_btnkill.EnableWindow(TRUE);
	m_btnCustcmd.EnableWindow(TRUE);
	m_setconf.EnableWindow(TRUE);
	m_getconf.EnableWindow(TRUE);
	m_isTagInvRun = FALSE;
}

int CModuleReaderManagerDlg::opant()
{
	if (m_readertype != ARM7_16ANTS)
	{
		if (m_bant1)
		{
			return 1;
		}
		if (m_bant2)
		{
			return 2;
		}
		if (m_bant3)
		{
			return 3;
		}
		if (m_bant4)
		{
			return 4;
		}
		return -1;
	}
	else
	{
		return selectants[0];
	}
}


LRESULT CModuleReaderManagerDlg::OnTagInv(WPARAM wParam, LPARAM lParam)
{
	char tmpepcl[200];
	char tmpepcr[200];
	char tmpemdl[200];
	char tmpemdr[200];
	char tmpemdstr[200];
	char tmpnum[10];

//	TRACE("start OnTagInv:%d, wParam:%d, lParam:%d\n", GetTickCount(), wParam, lParam);
	if (wParam == 0)
	{
		for (int j = 0; j < lParam; ++j)
		{	
			bool isnew = true;
			tmpepcr[0] = 0;
			Hex2Str(m_InvTags[j].EpcId, m_InvTags[j].Epclen, tmpepcr);
			tmpemdr[0] = 0;
			Hex2Str(m_InvTags[j].EmbededData, m_InvTags[j].EmbededDatalen, tmpemdr);
			int listcnt = m_listtags.GetItemCount();
			for (int i = 0; i < listcnt; ++i)
			{
				m_listtags.GetItemText(i, 1, tmpepcl, 200);
				m_listtags.GetItemText(i, 5, tmpemdl, 200);
				m_listtags.GetItemText(i, 2, tmpnum, 10);
				int ant = atoi(tmpnum);
				if ((strcmp(tmpepcl, tmpepcr) == 0) && (strcmp(tmpemdl, tmpemdr) == 0) && 
					ant == m_InvTags[j].AntennaID)
				{
					isnew = false;
					m_listtags.GetItemText(i, 3, tmpnum, 10);
					int readcnt = atoi(tmpnum) + m_InvTags[j].ReadCnt;
					m_listtags.SetItemText(i, 3, _itoa(readcnt, tmpnum, 10));
					break;
				}
			}
			if (isnew)
			{

				m_listtags.InsertItem(listcnt, _itoa(listcnt, tmpnum, 10)); 
				m_listtags.SetItemText(listcnt, 1, tmpepcr);
				m_listtags.SetItemText(listcnt, 2, _itoa(m_InvTags[j].AntennaID, tmpnum, 10));
				m_listtags.SetItemText(listcnt, 3, _itoa(m_InvTags[j].ReadCnt, tmpnum, 10));
				if (m_InvTags[j].protocol == SL_TAG_PROTOCOL_GEN2)
					m_listtags.SetItemText(listcnt, 4, "GEN2");
				else if (m_InvTags[j].protocol == SL_TAG_PROTOCOL_ISO180006B)
					m_listtags.SetItemText(listcnt, 4, "180006B");
				else if (m_InvTags[j].protocol == SL_TAG_PROTOCOL_IPX256)
					m_listtags.SetItemText(listcnt, 4, "IPX256");
				else if (m_InvTags[j].protocol == SL_TAG_PROTOCOL_IPX64)
					m_listtags.SetItemText(listcnt, 4, "IPX64");
				if (m_InvTags[j].EmbededDatalen != 0)
				{
					Hex2Str(m_InvTags[j].EmbededData, m_InvTags[j].EmbededDatalen, tmpemdstr);
					m_listtags.SetItemText(listcnt, 5, tmpemdstr);
				}
				else
					m_listtags.SetItemText(listcnt, 5, "");
			}
		}
	}
	else
	{
		CTime   curr_time=CTime::GetCurrentTime();
		CString errinfo = curr_time.Format("%Y-%m_%d %H-%M-%S");
		if (lParam != 0)
		{
			if ((lParam >> 16) == 0)
				errinfo += " 180006b";
			else
				errinfo += " gen2";

			unsigned short optype = (lParam & 0xffff);
			if (optype == 3)
				errinfo += " inv";
			else if (optype == 2)
				errinfo += " write";
			else if (optype == 1)
				errinfo += " read";
		}
		errinfo += " errcode:";
		errinfo += _itoa(wParam, tmpnum, 10);
		errinfo += "\r\n";
		logstr += errinfo;
		UpdateData(FALSE);
	}

//	TRACE("end OnTagInv:%d\n", GetTickCount());
	return 0;
}

DWORD WINAPI CModuleReaderManagerDlg::ThreadTagInventory( LPVOID lpParam )
{
	CModuleReaderManagerDlg *pdlg = (CModuleReaderManagerDlg *)lpParam;
	READER_ERR err;

	while (pdlg->m_isTagInvRun)
	{
		if (pdlg->m_readertype != SL_COMMN_READER)
		{
			err = TagInventory_Raw(pdlg->m_reader, pdlg->selectants, pdlg->selcnts, pdlg->m_readdur, 
				&pdlg->m_InvTagCnt);
		}
		else
		{
			err = TagInventory(pdlg->m_reader, pdlg->selectants, pdlg->selcnts, pdlg->m_readdur, 
				pdlg->m_InvTags, &pdlg->m_InvTagCnt);
		}
		if (err == MT_OK_ERR)
		{
			if (pdlg->m_InvTagCnt > 0)
			{
//				TRACE("PostMessage :%d\n", GetTickCount());
				if (pdlg->m_readertype != SL_COMMN_READER)
				{
					for (int c = 0; c < pdlg->m_InvTagCnt; ++c)
					{
						err = GetNextTag(pdlg->m_reader, pdlg->m_InvTags+c);
						if (err != 0)
						{
							pdlg->MessageBox("取标签错误");
							return NULL;
						}
					}
				}
				
				pdlg->PostMessage(WM_MY_MSG_TAGINV, err, pdlg->m_InvTagCnt);
			}
		}
		else
		{
			if (err == MT_HARDWARE_ALERT_ERR_BY_HIGN_RETURN_LOSS)
			{
				pdlg->MessageBox("回波反射过大");
				break;
			}
			else if (err == MT_HARDWARE_ALERT_ERR_BY_TOO_MANY_RESET)
			{
				pdlg->MessageBox("模块复位次数过多");
				break;
			}
			else if (err == MT_HARDWARE_ALERT_ERR_BY_NO_ANTENNAS)
			{
				pdlg->MessageBox("未检测到天线");
				break;
			}
			else if (err == MT_HARDWARE_ALERT_ERR_BY_HIGH_TEMPERATURE)
			{
				pdlg->MessageBox("温度过高");
				break;
			}
			else if (err == MT_HARDWARE_ALERT_ERR_BY_READER_DOWN)
			{
				pdlg->MessageBox("读写器宕机");
				break;
			}
			else if (err == MT_HARDWARE_ALERT_BY_FAILED_RESET_MODLUE)
			{
				pdlg->MessageBox("复位模块失败");
				break;
			}
			else if (err == MT_IO_ERR)
			{
				pdlg->MessageBox("通信接口错误");
				break;
			}
			else
				pdlg->PostMessage(WM_MY_MSG_TAGINV, err, 0);
		}

		Sleep(pdlg->m_sleepdur);
	}
	return NULL;
}

typedef struct  
{
	CModuleReaderManagerDlg *pdlg;
	int antid;
	int bank;
	int addr;
	int blks;
	unsigned char pwd[4];
	unsigned short tmout;
	int opcnt;
	bool ispwd;
}ReadTagData_ST;

DWORD WINAPI CModuleReaderManagerDlg::StopAsyncReadingFunc( LPVOID lpParam )
{
	CModuleReaderManagerDlg *pdlg = (CModuleReaderManagerDlg *)lpParam;
	StopTagStreaming(pdlg->m_reader);
	return 0;
}

DWORD WINAPI CModuleReaderManagerDlg::ThreadReadTagData( LPVOID lpParam )
{
	ReadTagData_ST *paras = (ReadTagData_ST*)lpParam;
	int successcnt = 0;
	int failedcnt = 0;
	unsigned char rdata[300];
	CString &logstr = paras->pdlg->logstr;
	int start;
	int dur;
	int totaldur = 0;
	char tmp[10];
	char temp[601];
	int i;
	unsigned char *pwd;
	int strcnt = 0;

	if (paras->ispwd)
	{
		pwd = paras->pwd;
	}
	else
		pwd = NULL;

	for (i = 0; i < paras->opcnt; ++i)
	{
		if (!paras->pdlg->isTestRun)
			break;
		if (strcnt == 50)
		{
			strcnt = 0;
			logstr = "";
		}
		strcnt++;

//		int isdt;
		start = GetTickCount();
		READER_ERR err = GetTagData(paras->pdlg->m_reader, paras->antid, paras->bank, paras->addr, 
			paras->blks, rdata, pwd, paras->tmout);

		dur = GetTickCount() - start;
//		if (isdt == 1)
//			dur -= 30;

		totaldur += dur;
		if (err != MT_OK_ERR)
		{
			failedcnt++;
			logstr += "第";
			logstr += _itoa(i, tmp, 10);

			if (err == MT_HARDWARE_ALERT_ERR_BY_HIGN_RETURN_LOSS || 
				err == MT_HARDWARE_ALERT_ERR_BY_TOO_MANY_RESET ||
				err == MT_HARDWARE_ALERT_ERR_BY_NO_ANTENNAS ||
				err == MT_HARDWARE_ALERT_ERR_BY_READER_DOWN)
				logstr += "次失败,危险操作，请检查读写器的工作状态和工作环境, ";
			else
				logstr += "次失败, ";
		}
		else
		{
			successcnt++;
			logstr += "第";
			logstr += _itoa(i, tmp, 10);
			logstr += "次成功, ";
			memset(temp, 0, 601);
			Hex2Str(rdata, paras->blks*2, temp);
			logstr += "data:";
			logstr += temp;
			logstr += "，";
		}
		logstr += "用时：";
		logstr += _itoa(dur, tmp, 10);
		logstr += "毫秒\n";
	}

	logstr += "共执行操作";
	logstr += _itoa(i, tmp, 10);
	logstr += "次，";
	logstr += "成功";
	logstr += _itoa(successcnt, tmp, 10);
	logstr += "次，";
	logstr += "失败";
	logstr += _itoa(failedcnt, tmp, 10);
	logstr += "次，";
	logstr += "共耗时：";
	logstr += _itoa(totaldur, tmp, 10);
	logstr += "毫秒";

	Sleep(500);

	paras->pdlg->ismachstoptest = true;
	paras->pdlg->isTestRun = false;

	delete paras;


	return 0;
}


void CModuleReaderManagerDlg::Onbtnread() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	
	int tmt;
	
	tmt = ValidEditInt(m_timeout, 1, -1);
	if (tmt < 0)
	{
		MessageBox("超时设置不合法");
		return;
	}
	
	
	unsigned char *pwd;
	
	if (m_ispwd)
	{
		if (Validaccpwd() < 0)
			return;
		
		unsigned char unpwd[50];
		memset(unpwd, 0, 50);
		Str2Hex(m_accesspwd, 8, unpwd);
		pwd = unpwd;
	}
	else
		pwd = NULL;
	
	if (m_wrbank == -1)
	{
		MessageBox("请选择读bank");
		return;
	}

	int rcnt;
	if (m_repisrep)
	{
		rcnt = ValidEditInt(m_repcnt, 1, -1);
		if (rcnt < 0)
		{
			MessageBox("重复次数不合法");
			return;
		}
	}

	int addr = ValidEditInt(m_addr, 1, -1);
	if (addr < 0)
	{
		MessageBox("读地址不合法");
		return;
	}

	int blks = ValidEditInt(m_blks, 1, 8000);
	if (blks < 0)
	{
		MessageBox("块数不合法");
		return;
	}

	char tmp[16385];
	if (SetFilter_() < 0)
		return;

	if (ValidAntenna(1) < 0)
		return;

//	SwitchAnts(m_reader, );

	unsigned char rdata[8192];
	int op_ant = opant();

	if (m_repisrep)
	{
		ReadTagData_ST *opreadpara = new ReadTagData_ST;
		opreadpara->antid = op_ant;
		opreadpara->bank = m_wrbank;
		opreadpara->addr = addr;
		opreadpara->blks = blks;
		opreadpara->opcnt = rcnt;
		if (m_ispwd)
		{
			opreadpara->ispwd = TRUE;
			memcpy(opreadpara->pwd, pwd, 4);
		}
		else
			opreadpara->ispwd = FALSE;

		opreadpara->tmout = tmt;
		opreadpara->pdlg = this;

		DWORD dwThreadId;
		isTestRun = TRUE;
		ismachstoptest = FALSE;
		logstr = "";
		SetTimer(2, 500, NULL);
		m_thread = CreateThread( 
			NULL,              // default security attributes
			0,                 // use default stack size  
			ThreadReadTagData,        // thread function 
			opreadpara,             // argument to thread function 
			0,                 // use default creation flags 
			&dwThreadId);   // returns the thread identifier 
		
		if (m_thread == NULL)
		{
			MessageBox("创建线程失败");
			delete opreadpara;
			return;
			
		}
		
		m_btnlock.EnableWindow(FALSE);
		m_btnkill.EnableWindow(FALSE);
		m_btnCustcmd.EnableWindow(FALSE);
		m_btnwrite.EnableWindow(FALSE);
		m_btnstop.EnableWindow(FALSE);
		m_btnstart.EnableWindow(FALSE);
		m_stoptest.EnableWindow(true);
		m_btnread.EnableWindow(FALSE);
		m_setconf.EnableWindow(FALSE);
		m_getconf.EnableWindow(FALSE);
		return;
	}
//	int isdt;
	READER_ERR err = GetTagData(m_reader, op_ant, m_wrbank, addr, blks, rdata, pwd, tmt);
	if (err != MT_OK_ERR)
	{
		
		if (err == MT_HARDWARE_ALERT_ERR_BY_HIGN_RETURN_LOSS || 
			err == MT_HARDWARE_ALERT_ERR_BY_TOO_MANY_RESET ||
			err == MT_HARDWARE_ALERT_ERR_BY_NO_ANTENNAS ||
				err == MT_HARDWARE_ALERT_ERR_BY_READER_DOWN)
			MessageBox("危险操作，请检查读写器的工作状态和工作环境");
		else
			MessageBox("读失败");

		return;
	}
	else
	{
//		memset(tmp, 0, 16385);
		Hex2Str(rdata, blks*2, tmp);

		m_wrdata = tmp;
		UpdateData(FALSE);
		m_wrdata = "";
	}
}
//if ()
typedef struct  
{
	CModuleReaderManagerDlg *pdlg;
	int antid;
	int bank;
	int addr;
	bool randflag;
	unsigned char *data;
	int datalen;
	unsigned char pwd[4];
	unsigned short tmout;
	int opcnt;
	bool ispwd;
}WriteTagData_ST;

void RandomData(unsigned char *buf, int len)
{
	for (int i = 0; i < len; ++i)
	{
		buf[i] = rand();
	}
}

DWORD WINAPI CModuleReaderManagerDlg::ThreadWriteTagData( LPVOID lpParam )
{
	WriteTagData_ST *paras = (WriteTagData_ST*)lpParam;
	int successcnt = 0;
	int failedcnt = 0;
	CString &logstr = paras->pdlg->logstr;
	int i;
	int start;
	int dur;
	int totaldur = 0;
	char tmp[10];
	unsigned char temp[300];
	char tempstr[601];
	unsigned char *wdata;
	unsigned char *pwd;
	int strcnt = 0;
	if (paras->ispwd)
	{
		pwd = paras->pwd;
	}
	else
		pwd = NULL;

	for (i = 0; i < paras->opcnt; ++i)
	{
		
		if (!paras->pdlg->isTestRun)
			break;
		if (strcnt == 50)
		{
			strcnt = 0;
			logstr = "";
		}
		strcnt++;

		if (paras->randflag)
		{
			RandomData(temp, paras->datalen);
			wdata = temp;
		}
		else
		{
			wdata = paras->data;
		}

//		int isdt;
		start = GetTickCount();
		READER_ERR err = WriteTagData(paras->pdlg->m_reader, paras->antid, paras->bank, 
			paras->addr, wdata, paras->datalen, pwd, paras->tmout);

		dur = GetTickCount() - start;
//		if (isdt == 1)
//			dur -= 30;

		totaldur += dur;
		if (err != MT_OK_ERR)
		{
			failedcnt++;
			logstr += "第";
			logstr += _itoa(i, tmp, 10);
			
			if (err == MT_HARDWARE_ALERT_ERR_BY_HIGN_RETURN_LOSS || 
				err == MT_HARDWARE_ALERT_ERR_BY_TOO_MANY_RESET ||
				err == MT_HARDWARE_ALERT_ERR_BY_NO_ANTENNAS ||
				err == MT_HARDWARE_ALERT_ERR_BY_READER_DOWN)
				logstr += "次失败,危险操作，请检查读写器的工作状态和工作环境, ";
			else
				logstr += "次失败, ";
		}
		else
		{
			successcnt++;
			logstr += "第";
			logstr += _itoa(i, tmp, 10);
			logstr += "次成功, ";
		}

		logstr += "写入数据：";
		Hex2Str(wdata, paras->datalen, tempstr); 
		logstr += tempstr;
		logstr += "，用时：";
		logstr += _itoa(dur, tmp, 10);
		logstr += "毫秒\n";
	}

	logstr += "共执行操作";
	logstr += _itoa(i, tmp, 10);
	logstr += "次，";
	logstr += "成功";
	logstr += _itoa(successcnt, tmp, 10);
	logstr += "次，";
	logstr += "失败";
	logstr += _itoa(failedcnt, tmp, 10);
	logstr += "次，";
	logstr += "共耗时：";
	logstr += _itoa(totaldur, tmp, 10);
	logstr += "毫秒";
	
	Sleep(500);

	paras->pdlg->ismachstoptest = true;
	paras->pdlg->isTestRun = false;

	if (!paras->randflag)
	{
		delete [] paras->data;
	}
	delete paras;



	return 0;
}

void CModuleReaderManagerDlg::Onbtnwrite() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);

	int tmt;

	tmt = ValidEditInt(m_timeout, 1, -1);
	if (tmt < 0)
	{
		MessageBox("超时设置不合法");
		return;
	}


	int randdatalen;
	if (!(m_repisrep && m_repisrand))
	{
		if (Validwdata() < 0)
			return;
	}
	else
	{
		randdatalen = ValidEditInt(m_randlen, 1, 8000);
		if (randdatalen < 0)
		{
			MessageBox("数据长度不合法");
			return;
		}
	}

	if (ValidAntenna(1) < 0)
		return;

	unsigned char *pwd;
	if (m_ispwd)
	{
		if (Validaccpwd() < 0)
			return;
		
		unsigned char unpwd[50];
		memset(unpwd, 0, 50);
		Str2Hex(m_accesspwd, 8, unpwd);
		pwd = unpwd;
	}
	else
		pwd = NULL;
	
	if (SetFilter_() < 0)
		return;
	int addr = ValidEditInt(m_addr, 1, -1);
	if (addr < 0)
	{
		MessageBox("写地址不合法");
		return;
	}
	
	if (m_wrbank == -1)
	{
		MessageBox("请选择写bank");
		return;
	}
	
	int rcnt;
	if (m_repisrep)
	{
		rcnt = ValidEditInt(m_repcnt, 1, -1);
		if (rcnt < 0)
		{
			MessageBox("重复次数不合法");
			return;
		}
	}
//	SwitchAnts(m_reader, opant());
	unsigned char wdata[300];
	
	
	Str2Hex(m_wrdata, m_wrdata.GetLength(), wdata);
	int op_ant = opant();

	if (m_repisrep)
	{
		WriteTagData_ST *opwritepara = new WriteTagData_ST;

		opwritepara->antid = op_ant;
		opwritepara->bank = m_wrbank;
		opwritepara->addr = addr;
		if (m_repisrand)
		{
			opwritepara->randflag = true;
			opwritepara->datalen = randdatalen*2;
		}
		else
		{
			opwritepara->randflag = FALSE;
			opwritepara->datalen = m_wrdata.GetLength()/2;
			opwritepara->data = new unsigned char[m_wrdata.GetLength()/2];
			memcpy(opwritepara->data, wdata, m_wrdata.GetLength()/2);
		}
      
	//	 char *pppp=new char[100];
		opwritepara->opcnt = rcnt;
		if (m_ispwd)
		{
			opwritepara->ispwd = true;
			memcpy(opwritepara->pwd, pwd, 4);
		}
		else
			opwritepara->ispwd = FALSE;

		opwritepara->tmout = tmt;
		opwritepara->pdlg = this;
		
		DWORD dwThreadId;
		isTestRun = TRUE;
		ismachstoptest = FALSE;
		logstr = "";
		SetTimer(2, 500, NULL);
		m_thread = CreateThread( 
			NULL,              // default security attributes
			0,                 // use default stack size  
			ThreadWriteTagData,        // thread function 
			opwritepara,             // argument to thread function 
			0,                 // use default creation flags 
			&dwThreadId);   // returns the thread identifier 
		
		if (m_thread == NULL)
		{
			MessageBox("创建线程失败");
			if (!opwritepara->randflag)
			{
				delete [] opwritepara->data;
			}
			delete opwritepara;
			return;
		}

		m_btnlock.EnableWindow(FALSE);
		m_btnkill.EnableWindow(FALSE);
		m_btnCustcmd.EnableWindow(FALSE);
		m_btnwrite.EnableWindow(FALSE);
		m_btnstop.EnableWindow(FALSE);
		m_btnstart.EnableWindow(FALSE);
		m_stoptest.EnableWindow(true);
		m_btnread.EnableWindow(FALSE);
		m_setconf.EnableWindow(FALSE);
		m_getconf.EnableWindow(FALSE);
		return;
	}

//	int isdt;
	int wst = GetTickCount();
	READER_ERR err = WriteTagData(m_reader, op_ant, m_wrbank, addr, wdata, m_wrdata.GetLength()/2, pwd, tmt);
	if (err != MT_OK_ERR)
	{
		
		if (err == MT_HARDWARE_ALERT_ERR_BY_HIGN_RETURN_LOSS || 
			err == MT_HARDWARE_ALERT_ERR_BY_TOO_MANY_RESET ||
			err == MT_HARDWARE_ALERT_ERR_BY_NO_ANTENNAS ||
				err == MT_HARDWARE_ALERT_ERR_BY_READER_DOWN)
			MessageBox("危险操作，请检查读写器的工作状态和工作环境");
		else
			MessageBox("写失败");

		return;
	}
	else
	{
		CString wdurstr;
		int wdur = GetTickCount()-wst;
		wdurstr.Format("%d",wdur);		
		m_wrdata = "写成功,耗时:"+ wdurstr;
		UpdateData(FALSE);
		m_wrdata = "";
	}
	// TODO: Add your control notification handler code here
	
}

void CModuleReaderManagerDlg::Onbtnlock() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	unsigned char unpwd[50];
	int tmt;
	
	tmt = ValidEditInt(m_timeout, 1, -1);
	if (tmt < 0)
	{
		MessageBox("超时设置不合法");
		return;
	}


	if (ValidAntenna(1) < 0)
		return;

	unsigned char *pwd;
	if (m_ispwd)
	{
		if (Validaccpwd() < 0)
			return;
		
		memset(unpwd, 0, 50);
		Str2Hex(m_accesspwd, 8, unpwd);
		pwd = unpwd;
	}
	else
	{
		MessageBox("锁定操作必须提供访问密码");
		return;
	}


	if (SetFilter_() < 0)
		return;

	if (m_lockobj == -1)
	{
		MessageBox("请选择锁定区域");
		return;
	}

	if (m_locktype == -1)
	{
		MessageBox("请选择锁定类型");
		return;
	}


//	SwitchAnts(m_reader, opant());

	int lockobj = m_lockobj;
	int locktype = m_locktype;

	int lockobj_;
	int locktype_;
	
	switch (lockobj)
	{
	case 0:
		{
			lockobj_ = LOCK_OBJECT_KILL_PASSWORD;
			switch (locktype)
			{
			case 0:
				locktype_ = KILL_PASSWORD_UNLOCK;
				break;
			case 1:
				locktype_ = KILL_PASSWORD_LOCK;
				break;
			case 2:
				locktype_ = KILL_PASSWORD_PERM_LOCK;
				break;
			}
			break;
		}
	case 1:
		{
			lockobj_ = LOCK_OBJECT_ACCESS_PASSWD;
			switch (locktype)
			{
			case 0:
				locktype_ = ACCESS_PASSWD_UNLOCK;
				break;
			case 1:
				locktype_ = ACCESS_PASSWD_LOCK;
				break;
			case 2:
				locktype_ = ACCESS_PASSWD_PERM_LOCK;
				break;
			}
			break;	
		}
	case 2:
		{
			lockobj_ = LOCK_OBJECT_BANK1;
			switch (locktype)
			{
			case 0:
				locktype_ = BANK1_UNLOCK;
				break;
			case 1:
				locktype_ = BANK1_LOCK;
				break;
			case 2:
				locktype_ = BANK1_PERM_LOCK;
				break;
			}
			break;
		}
	case 3:
		{
			lockobj_ = LOCK_OBJECT_BANK2;
			switch (locktype)
			{
			case 0:
				locktype_ = BANK2_UNLOCK;
				break;
			case 1:
				locktype_ = BANK2_LOCK;
				break;
			case 2:
				locktype_ = BANK2_PERM_LOCK;
				break;
			}
			break;
		}
	case 4:
		{
			lockobj_ = LOCK_OBJECT_BANK3;
			switch (locktype)
			{
			case 0:
				locktype_ = BANK3_UNLOCK;
				break;
			case 1:
				locktype_ = BANK3_LOCK;
				break;
			case 2:
				locktype_ = BANK3_PERM_LOCK;
				break;
			}
			break;
		}
	}
	int op_ant = opant();

	READER_ERR err = LockTag(m_reader, op_ant, lockobj_, locktype_, pwd, tmt);
	if (err != MT_OK_ERR)
	{
		
		if (err == MT_HARDWARE_ALERT_ERR_BY_HIGN_RETURN_LOSS || 
			err == MT_HARDWARE_ALERT_ERR_BY_TOO_MANY_RESET ||
			err == MT_HARDWARE_ALERT_ERR_BY_NO_ANTENNAS ||
				err == MT_HARDWARE_ALERT_ERR_BY_READER_DOWN)
			MessageBox("危险操作，请检查读写器的工作状态和工作环境");
		else
			MessageBox("锁定失败");

		return;
	}
	else
	{
		m_wrdata = "锁定成功";
		UpdateData(FALSE);
		m_wrdata = "";
	}
	
}

BOOL CModuleReaderManagerDlg::DestroyWindow() 
{
	// TODO: Add your specialized code here and/or call the base class
	return CDialog::DestroyWindow();
}

void CModuleReaderManagerDlg::Onbtnstoptest() 
{
	// TODO: Add your control notification handler code here
//	KillTimer(2);
	isTestRun = FALSE;

	WaitForSingleObject(m_thread, INFINITE);
	CloseHandle(m_thread);

	m_btnlock.EnableWindow(true);
	m_btnkill.EnableWindow(true);
	m_btnwrite.EnableWindow(true);
	m_btnCustcmd.EnableWindow(true);
	m_btnstop.EnableWindow(FALSE);
	m_btnstart.EnableWindow(true);
	m_stoptest.EnableWindow(FALSE);
	m_btnread.EnableWindow(true);
	m_setconf.EnableWindow(true);
	m_getconf.EnableWindow(true);
	m_btnrandrw.EnableWindow(TRUE);
}


void CModuleReaderManagerDlg::OnClose() 
{
	// TODO: Add your message handler code here and/or call default
	if (isTestRun)
		Onbtnstoptest();
	if (m_isTagInvRun)
		Onbtnstop();

	Sleep(1000);
	if (isInit ==1)
		CloseReader(m_reader);

	CDialog::OnClose();
}

int CModuleReaderManagerDlg::ValidPower(CString &power, unsigned short Max, unsigned short Min,
												   unsigned short *pwrs, int pos)
{
	char tmp[10];
	int p = ValidEditInt(power, 1, -1);
	if (p < 0)
	{
		MessageBox("功率值不合法");
		return -1;
	}

	if (p > Max || p < Min)
	{
		char tip[50];
		strcpy(tip, "功率值只能在");
		strcat(tip, _itoa(Min, tmp, 10));
		strcat(tip, "-");
		strcat(tip, _itoa(Max, tmp, 10));
		strcat(tip, "之间");
		MessageBox(tip);
		return -1;
	}
	else
	{
		pwrs[pos] = p*100;
		return 0;
	}
}

void CModuleReaderManagerDlg::Onbtnsetconf() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	if (m_session == -1)
	{
		MessageBox("请选择Session");
		return;
	}

	if (m_readertype != 7 && m_readertype != 8)
	{
		if (m_maxepc == -1)
		{
			MessageBox("请选择最大epc长度");
			return;
		}
	}

	unsigned short Maxp;
	unsigned short Minp;
	
	if (ParamGet(m_reader, MTR_PARAM_RF_MAXPOWER, &Maxp) != MT_OK_ERR)
	{
		MessageBox("获取功率上限失败");
		return;
	}
	if (ParamGet(m_reader, MTR_PARAM_RF_MINPOWER, &Minp) != MT_OK_ERR)
	{
		MessageBox("获取功率下限失败");
		return;
	}

	Maxp = Maxp /100;
	Minp = Minp / 100;


	AntPowerConf pwrconfs;
	unsigned short rpwrs[8];
	unsigned short wpwrs[8];
	int ants[8];
	int pos = 0;
	int ret;
	
	
	if (m_antscnt == 1)
	{
		ret = ValidPower(m_ant1rp, Maxp, Minp, rpwrs, pos);
		if (ret != 0)
			return;
		
		ret = ValidPower(m_ant1wp, Maxp, Minp, wpwrs, pos);
		if (ret != 0)
			return;
		
		pos++;
		ants[0] = 1;
	}
	else if (m_antscnt == 2)
	{
		ret = ValidPower(m_ant1rp, Maxp, Minp, rpwrs, pos);
		if (ret != 0)
			return;
		
		ret = ValidPower(m_ant1wp, Maxp, Minp, wpwrs, pos);
		if (ret != 0)
			return;
		
		pos++;
		
		
		ret = ValidPower(m_ant2rp, Maxp, Minp, rpwrs, pos);
		if (ret != 0)
			return;
		
		ret = ValidPower(m_ant2wp, Maxp, Minp, wpwrs, pos);
		if (ret != 0)
			return;
		
		pos++;
		
		ants[0] = 1;
		ants[1] = 2;
	}
	else if (m_antscnt == 3)
	{
		ret = ValidPower(m_ant1rp, Maxp, Minp, rpwrs, pos);
		if (ret != 0)
			return;
		
		ret = ValidPower(m_ant1wp, Maxp, Minp, wpwrs, pos);
		if (ret != 0)
			return;
		
		pos++;
		
		
		ret = ValidPower(m_ant2rp, Maxp, Minp, rpwrs, pos);
		if (ret != 0)
			return;
		
		ret = ValidPower(m_ant2wp, Maxp, Minp, wpwrs, pos);
		if (ret != 0)
			return;
		
		pos++;
		
		ret = ValidPower(m_ant3rp, Maxp, Minp, rpwrs, pos);
		if (ret != 0)
			return;
		
		ret = ValidPower(m_ant3wp, Maxp, Minp, wpwrs, pos);
		if (ret != 0)
			return;
		
		pos++;
		ants[0] = 1;
		ants[1] = 2;
		ants[2] = 3;
	}
	else if (m_antscnt == 4)
	{
		ret = ValidPower(m_ant1rp, Maxp, Minp, rpwrs, pos);
		if (ret != 0)
			return;
		
		ret = ValidPower(m_ant1wp, Maxp, Minp, wpwrs, pos);
		if (ret != 0)
			return;
		
		pos++;
		
		
		ret = ValidPower(m_ant2rp, Maxp, Minp, rpwrs, pos);
		if (ret != 0)
			return;
		
		ret = ValidPower(m_ant2wp, Maxp, Minp, wpwrs, pos);
		if (ret != 0)
			return;
		
		pos++;
		
		ret = ValidPower(m_ant3rp, Maxp, Minp, rpwrs, pos);
		if (ret != 0)
			return;
		
		ret = ValidPower(m_ant3wp, Maxp, Minp, wpwrs, pos);
		if (ret != 0)
			return;
		
		pos++;
		
		
		ret = ValidPower(m_ant4rp, Maxp, Minp, rpwrs, pos);
		if (ret != 0)
			return;
		
		ret = ValidPower(m_ant4wp, Maxp, Minp, wpwrs, pos);
		if (ret != 0)
			return;
		
		pos++;
		
		ants[0] = 1;
		ants[1] = 2;
		ants[2] = 3;
		ants[3] = 4;
	}

	if (ParamSet(m_reader, MTR_PARAM_POTL_GEN2_SESSION, &m_session) != MT_OK_ERR)
	{
		MessageBox("设置Session失败 ");
	}

	pwrconfs.antcnt = pos;
	for (int c = 0; c < pos; ++c)
	{
		pwrconfs.Powers[c].antid = ants[c];
		pwrconfs.Powers[c].readPower = rpwrs[c];
		pwrconfs.Powers[c].writePower = wpwrs[c];
	}

	if (m_readertype != ARM7_16ANTS)
	{
		if (ParamSet(m_reader, MTR_PARAM_RF_ANTPOWER, &pwrconfs) != MT_OK_ERR)
		{
			MessageBox("设置功率失败");
		}
	}

	int epclen;
	if (m_maxepc == 0)
		epclen = 96;
	else if (m_maxepc == 1)
		epclen = 496;

	if (m_readertype != 7 && m_readertype != 8)
	{
		if (ParamSet(m_reader, MTR_PARAM_POTL_GEN2_MAXEPCLEN, &epclen) != MT_OK_ERR)
		{
			MessageBox("设置EPC长度失败");
		}
	}

	if (isIP)
	{
		if (m__ip != m_ip || m__subnet != m_subnet || m__gateway != m_gateway)
		{
			Reader_Ip rip;
			strcpy(rip.ip, m_ip.GetBuffer(0));
			strcpy(rip.mask, m_subnet.GetBuffer(0));
			strcpy(rip.gateway, m_gateway.GetBuffer(0));
			if (ParamSet(m_reader, MTR_PARAM_READER_IP, &rip) != MT_OK_ERR)
			{
				MessageBox("设置IP信息失败");
				return;
			}
			else
			{
				if (isInit ==1)
				{
					CloseReader(m_reader);
					m_btnlock.EnableWindow(FALSE);
					m_btnkill.EnableWindow(FALSE);
					m_btnwrite.EnableWindow(FALSE);
					m_btnCustcmd.EnableWindow(FALSE);
					m_btnstop.EnableWindow(FALSE);
					m_btnstart.EnableWindow(FALSE);
					m_btnread.EnableWindow(FALSE);
					m_ant1.EnableWindow(FALSE);
					m_ant2.EnableWindow(FALSE);
					m_ant3.EnableWindow(FALSE);
					m_ant4.EnableWindow(FALSE);
					m_stoptest.EnableWindow(FALSE);
					m_setconf.EnableWindow(FALSE);
					m_getconf.EnableWindow(FALSE);
					m_btnconnect.EnableWindow(TRUE);
					isInit = 0;
					MessageBox("读写器IP改变，需要重新连接读写器");
				}
			}
		}
	}
}

void CModuleReaderManagerDlg::Onbtngetconf() 
{
	// TODO: Add your control notification handler code here
	AntPowerConf pwrs;
	int sess;
	char tmp[10];

	if (ParamGet(m_reader, MTR_PARAM_RF_ANTPOWER, &pwrs) != MT_OK_ERR)
	{
		MessageBox("获取功率配置失败");
	}
	else
	{
		if (pwrs.antcnt == 1)
		{
			m_ant1rp = _itoa(pwrs.Powers[0].readPower/100, tmp, 10);
			m_ant1wp = _itoa(pwrs.Powers[0].writePower/100, tmp, 10);
		}
		else if (pwrs.antcnt == 2)
		{
			m_ant1rp = _itoa(pwrs.Powers[0].readPower/100, tmp, 10);
			m_ant1wp = _itoa(pwrs.Powers[0].writePower/100, tmp, 10);
			m_ant2rp = _itoa(pwrs.Powers[1].readPower/100, tmp, 10);
			m_ant2wp = _itoa(pwrs.Powers[1].writePower/100, tmp, 10);
		}
		else if (pwrs.antcnt == 3)
		{
			m_ant1rp = _itoa(pwrs.Powers[0].readPower/100, tmp, 10);
			m_ant1wp = _itoa(pwrs.Powers[0].writePower/100, tmp, 10);
			m_ant2rp = _itoa(pwrs.Powers[1].readPower/100, tmp, 10);
			m_ant2wp = _itoa(pwrs.Powers[1].writePower/100, tmp, 10);
			m_ant3rp = _itoa(pwrs.Powers[2].readPower/100, tmp, 10);
			m_ant3wp = _itoa(pwrs.Powers[2].writePower/100, tmp, 10);
		}
		else if (pwrs.antcnt == 4)
		{
			m_ant1rp = _itoa(pwrs.Powers[0].readPower/100, tmp, 10);
			m_ant1wp = _itoa(pwrs.Powers[0].writePower/100, tmp, 10);
			m_ant2rp = _itoa(pwrs.Powers[1].readPower/100, tmp, 10);
			m_ant2wp = _itoa(pwrs.Powers[1].writePower/100, tmp, 10);
			m_ant3rp = _itoa(pwrs.Powers[2].readPower/100, tmp, 10);
			m_ant3wp = _itoa(pwrs.Powers[2].writePower/100, tmp, 10);
			m_ant4rp = _itoa(pwrs.Powers[3].readPower/100, tmp, 10);
			m_ant4wp = _itoa(pwrs.Powers[3].writePower/100, tmp, 10);
		}
	}
	
	if (ParamGet(m_reader, MTR_PARAM_POTL_GEN2_SESSION, &sess) != MT_OK_ERR)
	{
		MessageBox("获取Session配置失败");
	}
	else
	{
		m_session = sess;
	}
	
	int maxepc;
	if (ParamGet(m_reader, MTR_PARAM_POTL_GEN2_MAXEPCLEN, &maxepc) != MT_OK_ERR)
	{
		MessageBox("获取epc最大长度失败");
	}
	else
	{
		if (maxepc == 96)
			m_maxepc = 0;
		else if (maxepc == 496)
			m_maxepc = 1;
	}

	if (isIP)
	{
		if (isInit == 0 || !isGetIp)
		{
			Reader_Ip rip;
			READER_ERR err12 = ParamGet(m_reader, MTR_PARAM_READER_IP, &rip);
			if (err12 != MT_OK_ERR)
			{
				MessageBox("获取IP配置失败");
				return;
			}
			m__ip = rip.ip;
			m__subnet = rip.mask;
			m__gateway = rip.gateway;
			m_ip = rip.ip;
			m_subnet = rip.mask;
			m_gateway = rip.gateway;
			isGetIp = true;
		}
		else
		{
			m_ip = m__ip;
			m_subnet = m__subnet;
			m_gateway = m__gateway;
		}
	}
	UpdateData(FALSE);
}

void CModuleReaderManagerDlg::OnbtnCustomCmd() 
{
	// TODO: Add your control notification handler code here
	CCustomDlg ccdlg(this);
	ccdlg.DoModal();
}

void CModuleReaderManagerDlg::Onbtnwriteepc() 
{

	UpdateData(TRUE);
	
	int tmt;
	
	tmt = ValidEditInt(m_timeout, 1, -1);
	if (tmt < 0)
	{
		MessageBox("超时设置不合法");
		return;
	}
	
	
	if (ValidAntenna(1) < 0)
		return;
	
	if (Validwdata() < 0)
		return;

	unsigned char wdata[300];
	
	
	Str2Hex(m_wrdata, m_wrdata.GetLength(), wdata);
	int op_ant = opant();
	
	unsigned char *pwd;
	
	if (m_ispwd)
	{
		if (Validaccpwd() < 0)
			return;
		
		unsigned char unpwd[50];
		memset(unpwd, 0, 50);
		Str2Hex(m_accesspwd, 8, unpwd);
		pwd = unpwd;
	}
	else
		pwd = NULL;

	if (SetFilter_() < 0)
		return;

	//	int isdt;
	READER_ERR err = WriteTagEpcEx(m_reader, op_ant, wdata, m_wrdata.GetLength()/2, pwd, tmt);
	if (err != MT_OK_ERR)
	{
		
		if (err == MT_HARDWARE_ALERT_ERR_BY_HIGN_RETURN_LOSS || 
			err == MT_HARDWARE_ALERT_ERR_BY_TOO_MANY_RESET ||
			err == MT_HARDWARE_ALERT_ERR_BY_NO_ANTENNAS ||
				err == MT_HARDWARE_ALERT_ERR_BY_READER_DOWN)
			MessageBox("危险操作，请检查读写器的工作状态和工作环境");
		else
			MessageBox("写EPC失败");
		
		return;
	}
	else
	{
		m_wrdata = "写EPC成功";
		UpdateData(FALSE);
		m_wrdata = "";
	}
}

void CModuleReaderManagerDlg::Onbtn180006bop() 
{
	// TODO: Add your control notification handler code here
	ISO180006bOpDlg dlg(NULL, m_reader);
	dlg.DoModal();
}

void CModuleReaderManagerDlg::Onbtntestgpio() 
{
	// TODO: Add your control notification handler code here
	TestGpioDlg dlg(NULL, m_reader, this);
	dlg.DoModal();
}

void CModuleReaderManagerDlg::Onbtnotherparam() 
{
	// TODO: Add your control notification handler code here
	OtherParams dlg(NULL, m_reader);
	dlg.DoModal();
}



void CModuleReaderManagerDlg::Onbtn16antsset() 
{
	// TODO: Add your control notification handler code here
	Arm7_16AntSetDlg *pdlg = new Arm7_16AntSetDlg(this, m_reader);
	pdlg->DoModal();
}


DWORD WINAPI CModuleReaderManagerDlg::ThreadRandReadAndWrite( LPVOID lpParam )
{
	CModuleReaderManagerDlg *pdlg = (CModuleReaderManagerDlg *)lpParam;
	READER_ERR err;

	int ants[] = {1};
	int dur;
	int pcnt = 0;
	Inv_Potls_ST invpotls;
	invpotls.potlcnt = 1;
	int tagscnt;
	int opbank;
	int addr;
	int blkcnt;
	unsigned char rbuf[64];
	unsigned char wbuf[32];
	char epcstr[128];

	while(pdlg->isTestRun)
	{
		if (pcnt % 2 == 0)
		{
			TRACE("start 180006b\n");
			opbank = 4;
			addr = 50;
			invpotls.potls[0].potl = SL_TAG_PROTOCOL_ISO180006B;
			invpotls.potls[0].weight = 30;
			dur = 30;
			blkcnt = 64;
		}
		else
		{
			TRACE("start gen2\n");
			opbank = 3;
			addr = 0;
			invpotls.potls[0].potl = SL_TAG_PROTOCOL_GEN2;
			invpotls.potls[0].weight = 30;
			dur = 70;
			blkcnt = 32;
		}
		ParamSet(pdlg->m_reader, MTR_PARAM_TAG_INVPOTL, &invpotls);
		ParamSet(pdlg->m_reader, MTR_PARAM_TAG_FILTER, NULL);
		err = TagInventory(pdlg->m_reader, ants, 1, dur, pdlg->m_tags, &tagscnt);
		if (err != MT_OK_ERR)
		{
			int rettype = 0;
			if(pcnt % 2 == 0)
				rettype = (0 << 16) | 3;
			else
				rettype = (1 << 16) | 3;
			pdlg->PostMessage(WM_MY_MSG_TAGINV, err, rettype);
			TRACE("inv err\n");
		}
		else
		{
			TRACE("tagscnt :%d\n", tagscnt);

			for (int i = 0; i < tagscnt; ++i)
			{
				TagFilter_ST tf;
				if (pcnt % 2 == 0)
				{
					tf.bank = 4;
					tf.startaddr = 0;
					tf.fdata = pdlg->m_tags[i].EpcId;
					tf.flen = 64;
					tf.isInvert = 0;
				}
				else
				{
					tf.bank = 1;
					tf.startaddr = 32;
					tf.fdata = pdlg->m_tags[i].EpcId;
					tf.flen = pdlg->m_tags[i].Epclen*8;
					tf.isInvert = 0;
				}

				Hex2Str(pdlg->m_tags[i].EpcId, pdlg->m_tags[i].Epclen, epcstr);
				TRACE("op epc:%s\n", epcstr);
				ParamSet(pdlg->m_reader, MTR_PARAM_TAG_FILTER, &tf);
				err = GetTagData(pdlg->m_reader, 1, opbank, addr, blkcnt, rbuf, NULL, 1000);
				if (err != MT_OK_ERR)
				{
					int rettype = 0;
					if(pcnt % 2 == 0)
						rettype = (0 << 16) | 1;
					else
						rettype = (1 << 16) | 1;
					pdlg->PostMessage(WM_MY_MSG_TAGINV, err, rettype);
					TRACE("read err failed\n");
				}
				else
					TRACE("read err success\n");

				wbuf[rand() % 32] = (unsigned char)rand();
				err = WriteTagData(pdlg->m_reader, 1, opbank, addr, wbuf, 32, NULL, 1000);
				if (err != MT_OK_ERR)
				{
					int rettype = 0;
					if(pcnt % 2 == 0)
						rettype = (0 << 16) | 2;
					else
						rettype = (1 << 16) | 2;

					pdlg->PostMessage(WM_MY_MSG_TAGINV, err, rettype);
					TRACE("write err failed\n");
				}
				else
					TRACE("write err success\n");
			}
		}
		
		pcnt++;
	}
	return 0;
}


void CModuleReaderManagerDlg::Onbtnrandrw() 
{
	// TODO: Add your control notification handler code here
	isTestRun = true;
	DWORD dwThreadId;
	m_thread = CreateThread( 
		NULL,              // default security attributes
		0,                 // use default stack size  
		ThreadRandReadAndWrite,        // thread function 
		this,             // argument to thread function 
		0,                 // use default creation flags 
		&dwThreadId);   // returns the thread identifier 
	
	if (m_hTagInvTh == NULL)
	{
		MessageBox("创建线程失败");
		return;
	}
	m_stoptest.EnableWindow(true);
}

void CModuleReaderManagerDlg::Onbtnclearlog() 
{
	// TODO: Add your control notification handler code here
	logstr = "";
	UpdateData(FALSE);
}

void CModuleReaderManagerDlg::Onbtnkill() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	unsigned char unpwd[50];
	int tmt;
	
	tmt = ValidEditInt(m_timeout, 1, -1);
	if (tmt < 0)
	{
		MessageBox("超时设置不合法");
		return;
	}
	
	
	if (ValidAntenna(1) < 0)
		return;
	
	unsigned char *pwd;
	if (m_ispwd)
	{
		if (Validaccpwd() < 0)
			return;
		
		memset(unpwd, 0, 50);
		Str2Hex(m_accesspwd, 8, unpwd);
		pwd = unpwd;
	}
	else
	{
		MessageBox("锁定操作必须提供访问密码");
		return;
	}
	
	
	if (SetFilter_() < 0)
		return;

	int op_ant = opant();

	READER_ERR err = KillTag(m_reader, op_ant, pwd, tmt);
	if (err != MT_OK_ERR)
	{
		
		if (err == MT_HARDWARE_ALERT_ERR_BY_HIGN_RETURN_LOSS || 
			err == MT_HARDWARE_ALERT_ERR_BY_TOO_MANY_RESET ||
			err == MT_HARDWARE_ALERT_ERR_BY_NO_ANTENNAS ||
			err == MT_HARDWARE_ALERT_ERR_BY_READER_DOWN)
			MessageBox("危险操作，请检查读写器的工作状态和工作环境");
		else
			MessageBox("销毁失败");
		
		return;
	}
	else
	{
		m_wrdata = "销毁成功";
		UpdateData(FALSE);
		m_wrdata = "";
	}
}

void CModuleReaderManagerDlg::OnReadTag(TAGINFO *tag, void* cookie)
{
/*
char tagbuf[128];
char databuf[200];
databuf[0] = 0;
Hex2Str(tag->EpcId, tag->Epclen, tagbuf);
if (tag->EmbededDatalen != 0)
	Hex2Str(tag->EmbededData, tag->EmbededDatalen, databuf);
TRACE("read tag:%s, potl:%d, readcnt:%d, ant:%d, data:%s\n", tagbuf, tag->protocol, tag->ReadCnt, 
	  tag->AntennaID, databuf);
*/

	CModuleReaderManagerDlg *pdlg = (CModuleReaderManagerDlg*)cookie;
	char tmpepcl[200];
	char tmpepcr[200];
	char tmpemdl[200];
	char tmpemdr[200];
	char tmpemdstr[200];
	char tmpnum[10];

	bool isnew = true;
	Hex2Str(tag->EpcId, tag->Epclen, tmpepcr);
	Hex2Str(tag->EmbededData, tag->EmbededDatalen, tmpemdr);
	int listcnt = pdlg->m_listtags.GetItemCount();
	
	for (int i = 0; i < listcnt; ++i)
	{
		int ant;
		pdlg->m_listtags.GetItemText(i, 1, tmpepcl, 200);
		pdlg->m_listtags.GetItemText(i, 5, tmpemdl, 200);
		pdlg->m_listtags.GetItemText(i, 2, tmpnum, 10);
		ant = atoi(tmpnum);
		if ((strcmp(tmpepcl, tmpepcr) == 0) && (strcmp(tmpemdl, tmpemdr) == 0)
			&& ant == tag->AntennaID)
		{
			isnew = false;
			pdlg->m_listtags.GetItemText(i, 3, tmpnum, 10);
			int readcnt = atoi(tmpnum) + tag->ReadCnt;
			pdlg->m_listtags.SetItemText(i, 3, _itoa(readcnt, tmpnum, 10));
			break;
		}
	}
	if (isnew)
	{
		pdlg->m_listtags.InsertItem(listcnt, _itoa(listcnt, tmpnum, 10)); 
		pdlg->m_listtags.SetItemText(listcnt, 1, tmpepcr);
		pdlg->m_listtags.SetItemText(listcnt, 2, _itoa(tag->AntennaID, tmpnum, 10));
		pdlg->m_listtags.SetItemText(listcnt, 3, _itoa(tag->ReadCnt, tmpnum, 10));
		if (tag->protocol == SL_TAG_PROTOCOL_GEN2)
			pdlg->m_listtags.SetItemText(listcnt, 4, "GEN2");
		else if (tag->protocol == SL_TAG_PROTOCOL_ISO180006B)
			pdlg->m_listtags.SetItemText(listcnt, 4, "180006B");
		else if (tag->protocol == SL_TAG_PROTOCOL_IPX256)
			pdlg->m_listtags.SetItemText(listcnt, 4, "IPX256");
		else if (tag->protocol == SL_TAG_PROTOCOL_IPX64)
			pdlg->m_listtags.SetItemText(listcnt, 4, "IPX64");
		if (tag->EmbededDatalen != 0)
		{
			Hex2Str(tag->EmbededData, tag->EmbededDatalen, tmpemdstr);
			pdlg->m_listtags.SetItemText(listcnt, 5, tmpemdstr);
		}
		else
			pdlg->m_listtags.SetItemText(listcnt, 5, "");
	}

}



/*
void CModuleReaderManagerDlg::OnButton4() 
{
	// TODO: Add your control notification handler code here
	CloseReader(m_reader);
	m_btnlock.EnableWindow(FALSE);
	m_btnkill.EnableWindow(FALSE);
	m_btnCustcmd.EnableWindow(FALSE);
	m_btnwrite.EnableWindow(FALSE);
	m_btnstop.EnableWindow(FALSE);
	m_btnstart.EnableWindow(FALSE);
	m_btnread.EnableWindow(FALSE);
	m_ant1.EnableWindow(FALSE);
	m_ant2.EnableWindow(FALSE);
	m_ant3.EnableWindow(FALSE);
	m_ant4.EnableWindow(FALSE);
	m_stoptest.EnableWindow(FALSE);
	m_setconf.EnableWindow(FALSE);
	m_getconf.EnableWindow(FALSE);
	m_cisgen2.EnableWindow(FALSE);
	m_cis180006b.EnableWindow(FALSE);
	m_cisIpx64.EnableWindow(FALSE);
	m_cisIpx256.EnableWindow(FALSE);
	
	m_180006bop.EnableWindow(FALSE);
	m_testgpio.EnableWindow(FALSE);
	m_otherparams.EnableWindow(FALSE);
	m_writeepc.EnableWindow(FALSE);
	m_btnrandrw.EnableWindow(FALSE);
	m_btnconnect.EnableWindow(TRUE);
	UpdateData(FALSE);
}*/

void CModuleReaderManagerDlg::OnBnClickedbtndisconnect()
{
	// TODO: 在此添加控件通知处理程序代码
	m_btnlock.EnableWindow(FALSE);
	m_btnkill.EnableWindow(FALSE);
	m_btnCustcmd.EnableWindow(FALSE);
	m_btnwrite.EnableWindow(FALSE);
	m_btnstop.EnableWindow(FALSE);
	m_btnstart.EnableWindow(FALSE);
	m_btnread.EnableWindow(FALSE);
	m_ant1.EnableWindow(FALSE);
	m_ant2.EnableWindow(FALSE);
	m_ant3.EnableWindow(FALSE);
	m_ant4.EnableWindow(FALSE);
	m_stoptest.EnableWindow(FALSE);
	m_setconf.EnableWindow(FALSE);
	m_getconf.EnableWindow(FALSE);
	m_cisgen2.EnableWindow(FALSE);
	m_cis180006b.EnableWindow(FALSE);
	m_cisIpx64.EnableWindow(FALSE);
	m_cisIpx256.EnableWindow(FALSE);

	m_180006bop.EnableWindow(FALSE);
	m_testgpio.EnableWindow(FALSE);
	m_otherparams.EnableWindow(FALSE);
	m_writeepc.EnableWindow(FALSE);
	m_btnrandrw.EnableWindow(FALSE);
	m_btndisc.EnableWindow(FALSE);
	m_btnconnect.EnableWindow(TRUE);
	m_isGen2 = TRUE;
	m_readdur = 150;
	m_sleepdur = 300;
	UpdateData(FALSE);

	CloseReader(m_reader);
}
