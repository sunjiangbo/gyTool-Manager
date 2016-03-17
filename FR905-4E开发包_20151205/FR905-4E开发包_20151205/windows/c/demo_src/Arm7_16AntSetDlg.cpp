// Arm7_16AntSetDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ModuleReaderManager.h"
#include "Arm7_16AntSetDlg.h"
#include "ModuleReader.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// Arm7_16AntSetDlg dialog


Arm7_16AntSetDlg::Arm7_16AntSetDlg(CModuleReaderManagerDlg *pmrm, int reader, CWnd* pParent)
	: CDialog(Arm7_16AntSetDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(Arm7_16AntSetDlg)
	m_isant1 = FALSE;
	m_isant10 = FALSE;
	m_isant11 = FALSE;
	m_isant12 = FALSE;
	m_isant13 = FALSE;
	m_isant14 = FALSE;
	m_isant15 = FALSE;
	m_isant16 = FALSE;
	m_isant2 = FALSE;
	m_isant3 = FALSE;
	m_isant4 = FALSE;
	m_isant5 = FALSE;
	m_isant6 = FALSE;
	m_isant7 = FALSE;
	m_isant8 = FALSE;
	m_isant9 = FALSE;
	m_readpwr = 0;
	m_writepwr = 0;
	//}}AFX_DATA_INIT
	pMrM = pmrm;
	m_reader = reader;
}


void Arm7_16AntSetDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(Arm7_16AntSetDlg)
	DDX_Control(pDX, IDC_ckant9, m_cant9);
	DDX_Control(pDX, IDC_ckant8, m_cant8);
	DDX_Control(pDX, IDC_ckant7, m_cant7);
	DDX_Control(pDX, IDC_ckant6, m_cant6);
	DDX_Control(pDX, IDC_ckant5, m_cant5);
	DDX_Control(pDX, IDC_ckant4, m_cant4);
	DDX_Control(pDX, IDC_ckant3, m_cant3);
	DDX_Control(pDX, IDC_ckant2, m_cant2);
	DDX_Control(pDX, IDC_ckant16, m_cant16);
	DDX_Control(pDX, IDC_ckant15, m_cant15);
	DDX_Control(pDX, IDC_ckant14, m_cant14);
	DDX_Control(pDX, IDC_ckant13, m_cant13);
	DDX_Control(pDX, IDC_ckant12, m_cant12);
	DDX_Control(pDX, IDC_ckant11, m_cant11);
	DDX_Control(pDX, IDC_ckant10, m_cant10);
	DDX_Control(pDX, IDC_ckant1, m_cant1);
	DDX_Check(pDX, IDC_ckant1, m_isant1);
	DDX_Check(pDX, IDC_ckant10, m_isant10);
	DDX_Check(pDX, IDC_ckant11, m_isant11);
	DDX_Check(pDX, IDC_ckant12, m_isant12);
	DDX_Check(pDX, IDC_ckant13, m_isant13);
	DDX_Check(pDX, IDC_ckant14, m_isant14);
	DDX_Check(pDX, IDC_ckant15, m_isant15);
	DDX_Check(pDX, IDC_ckant16, m_isant16);
	DDX_Check(pDX, IDC_ckant2, m_isant2);
	DDX_Check(pDX, IDC_ckant3, m_isant3);
	DDX_Check(pDX, IDC_ckant4, m_isant4);
	DDX_Check(pDX, IDC_ckant5, m_isant5);
	DDX_Check(pDX, IDC_ckant6, m_isant6);
	DDX_Check(pDX, IDC_ckant7, m_isant7);
	DDX_Check(pDX, IDC_ckant8, m_isant8);
	DDX_Check(pDX, IDC_ckant9, m_isant9);
	DDX_Text(pDX, IDC_tbreadpwr, m_readpwr);
	DDX_Text(pDX, IDC_writepwr, m_writepwr);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(Arm7_16AntSetDlg, CDialog)
	//{{AFX_MSG_MAP(Arm7_16AntSetDlg)
	ON_BN_CLICKED(IDC_btnok, Onbtnok)
	ON_WM_CTLCOLOR()
	ON_BN_CLICKED(IDC_btnset, Onbtnset)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// Arm7_16AntSetDlg message handlers

void Arm7_16AntSetDlg::Onbtnok() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);

	pMrM->selcnts = 0;
	for (int i = 1; i <= 16; ++i)
	{
		if (pants[i]->GetCheck() == BST_CHECKED)
			pMrM->selectants[pMrM->selcnts++] = i;
	}
	PostMessage(WM_CLOSE,0,0);
}

BOOL Arm7_16AntSetDlg::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	pants[1] = &m_cant1;
	pants[2] = &m_cant2;
	pants[3] = &m_cant3;
	pants[4] = &m_cant4;
	pants[5] = &m_cant5;
	pants[6] = &m_cant6;
	pants[7] = &m_cant7;
	pants[8] = &m_cant8;
	pants[9] = &m_cant9;
	pants[10] = &m_cant10;
	pants[11] = &m_cant11;
	pants[12] = &m_cant12;
	pants[13] = &m_cant13;
	pants[14] = &m_cant14;
	pants[15] = &m_cant15;
	pants[16] = &m_cant16;

	ParamGet(m_reader, MTR_PARAM_READER_CONN_ANTS, &cst);
	AntPowerConf antconf;
	ParamGet(m_reader, MTR_PARAM_RF_ANTPOWER, &antconf);
	m_readpwr = antconf.Powers[0].readPower;
	m_writepwr = antconf.Powers[0].writePower;
	UpdateData(FALSE);

	for (int i = 0; i < pMrM->selcnts; ++i)
	{
		pants[pMrM->selectants[i]]->SetCheck(1);
	}
// 	for (int i = 0; i < cst.antcnt; ++i)
// 	{
// 		pants[cst.connectedants[i]]->SetButtonStyle(BS_FLAT);
// 		pants[cst.connectedants[i]]->
// 	}
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

HBRUSH Arm7_16AntSetDlg::OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor) 
{
	HBRUSH hbr = CDialog::OnCtlColor (pDC, pWnd , nCtlColor );
	//Draw red text for all edit controls .
	bool isgreen = false;
	for (int i = 0; i < cst.antcnt; ++i)
	{
		if (pants[cst.connectedants[i]]->GetSafeHwnd() == pWnd->GetSafeHwnd())
		{
			pDC->SetTextColor (RGB (0, 255 , 0 ));
			isgreen = TRUE;
			break;
		}
	}
	if (!isgreen)
		pDC->SetTextColor (RGB (255, 0 , 0 ));
	return hbr;
}

void Arm7_16AntSetDlg::Onbtnset() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	AntPowerConf antconf;
	antconf.antcnt = 16;
	for (int i = 0; i < 16; ++i)
	{
		antconf.Powers[i].antid = i+1;
		antconf.Powers[i].readPower = m_readpwr;
		antconf.Powers[i].writePower = m_writepwr;
	}
	if (ParamSet(m_reader, MTR_PARAM_RF_ANTPOWER, &antconf) != MT_OK_ERR)
	{
		MessageBox("ÉèÖÃÊ§°Ü");
		return;
	}
}
