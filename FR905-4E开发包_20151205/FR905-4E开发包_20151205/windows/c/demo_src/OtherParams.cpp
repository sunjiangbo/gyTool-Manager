// OtherParams.cpp : implementation file
//

#include "stdafx.h"
#include "ModuleReaderManager.h"
#include "OtherParams.h"
#include "ModuleReader.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// OtherParams dialog


OtherParams::OtherParams(CWnd* pParent, int reader)
	: CDialog(OtherParams::IDD, pParent)
{
	//{{AFX_DATA_INIT(OtherParams)
	m_ebank = 0;
	m_estart = 0;
	m_fbank = 0;
	m_fbitstart = 0;
	m_fmdata = _T("");
	m_mbytescnt = 0;
	m_mpwd = _T("");
	m_qval = 0;
	m_ischk = _T("");
	m_fismatch = 0;
	m_selectregion = _T("");
	m_gen2blf = 0;
	m_uniant = _T("");
	m_uniemd = _T("");
	m_rechrssi = _T("");
	m_gen2tari = _T("");
	m_gen2target = _T("");
	m_hoptime = 0;
	m_lbtenble = _T("");
	m_gen2wmode = _T("");
	m_gen2enc = _T("");
	m_6bblf = 0;
	m_sracspwd = _T("");
	m_sraddress = 0;
	m_srbank = 0;
	m_srblks = 0;
	m_fwdata = _T("");
	m_indexbitaddr = 0;
	m_indexbitnum = 0;
	m_fwaddr = 0;
	m_pwdtype = -1;
	m_tagtype = -1;
	m_powersave = _T("");
	m_transmitmode = _T("");
	m_invmode = -1;
	//}}AFX_DATA_INIT
	m_hReader = reader;
}


void OtherParams::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(OtherParams)
	DDX_Control(pDX, IDC_listhtb, m_htb);
	DDX_Text(pDX, IDC_EDITebank, m_ebank);
	DDX_Text(pDX, IDC_EDITestart, m_estart);
	DDX_Text(pDX, IDC_EDITfbank, m_fbank);
	DDX_Text(pDX, IDC_EDITfbitstart, m_fbitstart);
	DDX_Text(pDX, IDC_EDITfmdata, m_fmdata);
	DDX_Text(pDX, IDC_EDITmbytescnt, m_mbytescnt);
	DDX_Text(pDX, IDC_EDITmpwd, m_mpwd);
	DDX_Text(pDX, IDC_EDITqval, m_qval);
	DDX_CBString(pDX, IDC_cbchkant, m_ischk);
	DDX_Text(pDX, IDC_EDITfmatch, m_fismatch);
	DDX_CBString(pDX, IDC_SelectRegion, m_selectregion);
	DDX_Text(pDX, IDC_tbgen2blf, m_gen2blf);
	DDX_CBString(pDX, IDC_cbuniant, m_uniant);
	DDX_CBString(pDX, IDC_cbuniemd, m_uniemd);
	DDX_CBString(pDX, IDC_cbrechrssi, m_rechrssi);
	DDX_CBString(pDX, IDC_cbgen2tari, m_gen2tari);
	DDX_CBString(pDX, IDC_cbgen2target, m_gen2target);
	DDX_Text(pDX, IDC_tbhoptime, m_hoptime);
	DDX_CBString(pDX, IDC_cblbtenable, m_lbtenble);
	DDX_CBString(pDX, IDC_cbgen2wmode, m_gen2wmode);
	DDX_CBString(pDX, IDC_cbgen2enc, m_gen2enc);
	DDX_Text(pDX, IDC_tb6bblf, m_6bblf);
	DDX_Text(pDX, IDC_tbsracspwd, m_sracspwd);
	DDX_Text(pDX, IDC_tbsraddress, m_sraddress);
	DDV_MinMaxInt(pDX, m_sraddress, 0, 2048);
	DDX_Text(pDX, IDC_tbsrbank, m_srbank);
	DDX_Text(pDX, IDC_tbsrblks, m_srblks);
	DDV_MinMaxInt(pDX, m_srblks, 0, 2048);
	DDX_Text(pDX, IDC_tbflashwrtiedata, m_fwdata);
	DDX_Text(pDX, IDC_tbindexbitaddr, m_indexbitaddr);
	DDX_Text(pDX, IDC_tbindexbitnum, m_indexbitnum);
	DDX_Text(pDX, IDC_tbflashwrtieaddr, m_fwaddr);
	DDV_MinMaxInt(pDX, m_fwaddr, 0, 4096);
	DDX_CBIndex(pDX, IDC_cbpwdtype, m_pwdtype);
	DDX_CBIndex(pDX, IDC_cbtagtype, m_tagtype);
	DDX_CBString(pDX, IDC_cbpowersave, m_powersave);
	DDX_CBString(pDX, IDC_cbtransmitmode, m_transmitmode);
	DDX_CBIndex(pDX, IDC_Cbbinvmode, m_invmode);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(OtherParams, CDialog)
	//{{AFX_MSG_MAP(OtherParams)
	ON_BN_CLICKED(IDC_btnsetqval, Onbtnsetqval)
	ON_BN_CLICKED(IDC_btngetqval, Onbtngetqval)
	ON_BN_CLICKED(IDC_btnsetchk, Onbtnsetchk)
	ON_BN_CLICKED(IDC_btngetchk, Onbtngetchk)
	ON_BN_CLICKED(IDC_btnsetfilter, Onbtnsetfilter)
	ON_BN_CLICKED(IDC_btngetfilter, Onbtngetfilter)
	ON_BN_CLICKED(IDC_btnsetemb, Onbtnsetemb)
	ON_BN_CLICKED(IDC_btngetemb, Onbtngetemb)
	ON_BN_CLICKED(IDC_btnsetmval, Onbtnsetmval)
	ON_BN_CLICKED(IDC_btngetmval, Onbtngetmval)
	ON_BN_CLICKED(IDC_btnresetfilter, Onbtnresetfilter)
	ON_BN_CLICKED(IDC_btnresetemb, Onbtnresetemb)
	ON_BN_CLICKED(IDC_setRegion, OnsetRegion)
	ON_BN_CLICKED(IDC_getRegion, OngetRegion)
	ON_BN_CLICKED(IDC_btngethtb, Onbtngethtb)
	ON_BN_CLICKED(IDC_btnsethtb, Onbtnsethtb)
	ON_BN_CLICKED(IDC_btnsetgen2blf, Onbtnsetgen2blf)
	ON_BN_CLICKED(IDC_btngetgen2blf, Onbtngetgen2blf)
	ON_BN_CLICKED(IDC_btnuniantget, Onbtnuniantget)
	ON_BN_CLICKED(IDC_btnuniantset, Onbtnuniantset)
	ON_BN_CLICKED(IDC_btnuniemdget, Onbtnuniemdget)
	ON_BN_CLICKED(IDC_btnuniemdset, Onbtnuniemdset)
	ON_BN_CLICKED(IDC_btnrechrssiget, Onbtnrechrssiget)
	ON_BN_CLICKED(IDC_btnrechrssiset, Onbtnrechrssiset)
	ON_BN_CLICKED(IDC_btngen2tariget, Onbtngen2tariget)
	ON_BN_CLICKED(IDC_btngen2tariset, Onbtngen2tariset)
	ON_BN_CLICKED(IDC_btngen2targetget, Onbtngen2targetget)
	ON_BN_CLICKED(IDC_btngen2targetset, Onbtngen2targetset)
	ON_BN_CLICKED(IDC_btnhoptimeget, Onbtnhoptimeget)
	ON_BN_CLICKED(IDC_btnhoptimeset, Onbtnhoptimeset)
	ON_BN_CLICKED(IDC_btnlbtenbleget, Onbtnlbtenbleget)
	ON_BN_CLICKED(IDC_btnlbtenbleset, Onbtnlbtenbleset)
	ON_BN_CLICKED(IDC_btngen2wmodeget, Onbtngen2wmodeget)
	ON_BN_CLICKED(IDC_btngen2wmodeset, Onbtngen2wmodeset)
 	ON_BN_CLICKED(IDC_btn6bblfget, Onbtn6bblfget)
 	ON_BN_CLICKED(IDC_btn6bblfset, Onbtn6bblfset)
	ON_BN_CLICKED(IDC_btnsetsecureread, Onbtnsetsecureread)
	ON_BN_CLICKED(IDC_btngetsecureread, Onbtngetsecureread)
	ON_BN_CLICKED(IDC_btnflashwrite, Onbtnflashwrite)
	ON_BN_CLICKED(IDC_btnresetsr, Onbtnresetsr)
	ON_BN_CLICKED(IDC_btngettransmitmod, Onbtngettransmitmod)
	ON_BN_CLICKED(IDC_btnsettransmitmod2, Onbtnsettransmitmod2)
	ON_BN_CLICKED(IDC_btngetpowersavemode, Onbtngetpowersavemode)
	ON_BN_CLICKED(IDC_btnsetpowersavemode, Onbtnsetpowersavemode)
	ON_BN_CLICKED(IDC_btngetinvmode, Onbtngetinvmode)
	ON_BN_CLICKED(IDC_btnsetinvmode, Onbtnsetinvmode)
	ON_BN_CLICKED(IDC_BUTTON_savesettings, OnBUTTONsavesettings)
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDC_BUTTON_eraseconf, &OtherParams::OnBnClickedButtoneraseconf)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// OtherParams message handlers

void OtherParams::Onbtnsetqval() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	if (ParamSet(m_hReader, MTR_PARAM_POTL_GEN2_Q, &m_qval) != MT_OK_ERR)
	{
		MessageBox("设置失败");
		return;
	}
}


void OtherParams::Onbtngetqval() 
{
	// TODO: Add your control notification handler code here
	if (ParamGet(m_hReader, MTR_PARAM_POTL_GEN2_Q, &m_qval) != MT_OK_ERR)
	{
		MessageBox("获取失败");
		return;
	}
	UpdateData(FALSE);
}

void OtherParams::Onbtnsetchk() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	int isck = 0;
	if (m_ischk == "")
	{
		MessageBox("请选择是否检测");
		return;
	}
	else if (m_ischk == "检测天线")
		isck = 1;
	else if (m_ischk == "不检测天线")
		isck = 0;
	if (ParamSet(m_hReader, MTR_PARAM_READER_IS_CHK_ANT, &isck) != MT_OK_ERR)
	{
		MessageBox("设置失败");
		return;
	}
}

void OtherParams::Onbtngetchk() 
{
	// TODO: Add your control notification handler code here
	int isck = 0;
	if (ParamGet(m_hReader, MTR_PARAM_READER_IS_CHK_ANT, &isck) != MT_OK_ERR)
	{
		MessageBox("获取失败");
		return;
	}
	if (isck == 0)
		m_ischk = "不检测天线";
	else
		m_ischk = "检测天线";

	UpdateData(FALSE);
}

void Data2BinStr(unsigned char *buf, int bitlen, char *str)
{
	*str = 0;
	int tmp;
	char tmpbuf[10];
	int i;
	for (i = 0; i < bitlen/8; ++i)
	{
		for (int j = 0; j < 8; ++j)
		{
			tmp = (buf[i] >> (7 - j)) & 0x1;
			sprintf(tmpbuf, "%d", tmp);
			strcat(str, tmpbuf);
		}
	}

	for (int c = 0; c < bitlen % 8; ++c)
	{
		tmp = (buf[i] >> (7 - c)) & 0x1;
		sprintf(tmpbuf, "%d", tmp);
		strcat(str, tmpbuf);
	}
}

int BinStr2data(CString str, unsigned char *buf);


void OtherParams::Onbtnsetfilter() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	TagFilter_ST filter;
	unsigned char fdatabuf[256];
	filter.bank = m_fbank;
	filter.fdata = fdatabuf;
	filter.startaddr = m_fbitstart;
	filter.flen = m_fmdata.GetLength();
	BinStr2data(m_fmdata, filter.fdata);
	filter.isInvert = m_fismatch;
	if (ParamSet(m_hReader, MTR_PARAM_TAG_FILTER, &filter) != MT_OK_ERR)
	{
		MessageBox("设置失败");
		return;
	}
}

void OtherParams::Onbtngetfilter() 
{
	// TODO: Add your control notification handler code here
	TagFilter_ST filter;
	unsigned char fdatabuf[256];
	filter.fdata = fdatabuf;
	char str[8*256];
	if (ParamGet(m_hReader, MTR_PARAM_TAG_FILTER, &filter) != MT_OK_ERR)
	{
		MessageBox("获取失败");
		return;
	}
	m_fbank = filter.bank;
	m_fbitstart = filter.startaddr;
	Data2BinStr(filter.fdata, filter.flen, str);
	m_fmdata = str;
	m_fismatch = filter.isInvert;
	UpdateData(FALSE);
}

void OtherParams::Onbtnsetemb() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	EmbededData_ST emdst;
	emdst.bank = m_ebank;
	emdst.bytecnt = m_mbytescnt;
	emdst.startaddr	= m_estart;
	unsigned char unpwd[50];
	if (m_mpwd.GetLength() == 0)
		emdst.accesspwd = NULL;
	else
	{
		memset(unpwd, 0, 50);
		Str2Hex(m_mpwd.GetBuffer(0), 8, unpwd);
		emdst.accesspwd = unpwd;
	}

	if (ParamSet(m_hReader, MTR_PARAM_TAG_EMBEDEDDATA, &emdst) != MT_OK_ERR)
	{
		MessageBox("设置失败");
		return;
	}
}

void OtherParams::Onbtngetemb() 
{
	// TODO: Add your control notification handler code here
	EmbededData_ST emdst;
	char pwdstr[8];
	unsigned char pwdbin[4];
	emdst.accesspwd = pwdbin;
	if (ParamGet(m_hReader, MTR_PARAM_TAG_EMBEDEDDATA, &emdst) != MT_OK_ERR)
	{
		MessageBox("获取失败");
		return;
	}
	m_ebank = emdst.bank;
	m_mbytescnt = emdst.bytecnt;
	m_estart = emdst.startaddr;
	if (m_mbytescnt != 0)
	{
		Hex2Str(emdst.accesspwd, 4, pwdstr);
		m_mpwd = pwdstr;
	}
	else
		m_mpwd = "";

	UpdateData(FALSE);
}

void OtherParams::Onbtnsetmval() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	int enc = 0;
	if (m_gen2enc == "")
	{
		MessageBox("请选择gen2编码");
		return;
	}
	else if (m_gen2enc == "FM0")
		enc = 0;
	else if (m_gen2enc == "M2")
		enc = 1;
	else if (m_gen2enc == "M4")
		enc = 2;
	else if (m_gen2enc == "M8")
		enc = 3;

	if (ParamSet(m_hReader, MTR_PARAM_POTL_GEN2_TAGENCODING, &enc) != MT_OK_ERR)
	{
		MessageBox("设置失败");
		return;
	}
}

void OtherParams::Onbtngetmval() 
{
	// TODO: Add your control notification handler code here
	int enc;
	if (ParamGet(m_hReader, MTR_PARAM_POTL_GEN2_TAGENCODING, &enc) != MT_OK_ERR)
	{
		MessageBox("获取失败");
		return;
	}
	if (enc == 0)
		m_gen2enc = "FM0";
	else if (enc == 1)
		m_gen2enc = "M2";
	else if (enc == 2)
		m_gen2enc = "M4";
	else if (enc == 3)
		m_gen2enc = "M8";

	UpdateData(FALSE);	
}

void OtherParams::Onbtnresetfilter() 
{
	// TODO: Add your control notification handler code here
	if (ParamSet(m_hReader, MTR_PARAM_TAG_FILTER, NULL) != MT_OK_ERR)
	{
		MessageBox("设置失败");
		return;
	}
}

void OtherParams::Onbtnresetemb() 
{
	// TODO: Add your control notification handler code here
	if (ParamSet(m_hReader, MTR_PARAM_TAG_EMBEDEDDATA, NULL) != MT_OK_ERR)
	{
		MessageBox("设置失败");
		return;
	}
}

void OtherParams::OnsetRegion() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	Region_Conf rg;
	if (m_selectregion == "")
	{
		MessageBox("请选择Region");
		return;
	}
	else if (m_selectregion == "北美")
		rg = RG_NA;
	else if (m_selectregion == "欧洲")
		rg = RG_EU;
	else if (m_selectregion == "欧洲2")
		rg = RG_EU2;
	else if (m_selectregion == "欧洲3")
		rg = RG_EU3;
	else if (m_selectregion == "韩国")
		rg = RG_KR;
	else if (m_selectregion == "中国(920-925)")
		rg = RG_PRC;
	else if (m_selectregion == "全频段")
		rg = RG_OPEN;
	else if (m_selectregion == "中国2(840-845)")
		rg = RG_PRC2;

	if (ParamSet(m_hReader,MTR_PARAM_FREQUENCY_REGION,&rg) != MT_OK_ERR)
	{
		MessageBox("设置Region失败");
		return;
	}
}

void OtherParams::OngetRegion() 
{
	// TODO: Add your control notification handler code here
	Region_Conf rg;
	if (ParamGet(m_hReader, MTR_PARAM_FREQUENCY_REGION, &rg) != MT_OK_ERR)
	{
		MessageBox("获取Region失败");
		return;
	}
	if (rg == RG_NA)
		m_selectregion = "北美";
	else if (rg == RG_EU)
		m_selectregion = "欧洲";
	else if (rg == RG_EU2)
		m_selectregion = "欧洲2";
	else if (rg == RG_EU3)
		m_selectregion = "欧洲3";
	else if (rg == RG_KR)
		m_selectregion = "韩国";
	else if (rg == RG_PRC)
		m_selectregion = "中国(920-925)";
	else if (rg == RG_OPEN)
		m_selectregion = "全频段";
	else if (rg == RG_PRC2)
		m_selectregion = "中国2(840-845)";

	UpdateData(false);
}

void OtherParams::Onbtngethtb() 
{
	// TODO: Add your control notification handler code here
	m_htb.DeleteAllItems();

	DWORD dwStyle = m_htb.GetExtendedStyle();
	dwStyle |= LVS_EX_FULLROWSELECT;//选中某行使整行高亮（只适用与report风格的listctrl）
	dwStyle |= LVS_EX_GRIDLINES;//网格线（只适用与report风格的listctrl）
	dwStyle |= LVS_EX_CHECKBOXES;//item前生成checkbox控件
	m_htb.SetExtendedStyle(dwStyle); //设置扩展风格

	CHeaderCtrl* pHeaderCtrl = m_htb.GetHeaderCtrl();
	int  nColumnCount = pHeaderCtrl->GetItemCount();
	if ((pHeaderCtrl != NULL) && (nColumnCount ==0))
	{
		m_htb.InsertColumn( 0, "FrequencyHop", LVCFMT_LEFT, 90);
	}

	HoptableData_ST hoptable;
	int i = 0;
	CString myString ;
	int aa = GetTickCount();
	if (ParamGet(m_hReader, MTR_PARAM_FREQUENCY_HOPTABLE, &hoptable) != MT_OK_ERR)
	{
		MessageBox("获取频率表失败");
		return;
	}
	int bb = GetTickCount();
	TRACE("bb - aa:%d\n", bb - aa);
	for(i; i<hoptable.lenhtb; i++)
	{
		myString.Format("%d",hoptable.htb[i]);
		m_htb.InsertItem(i, myString);
	}

	UpdateData(false);
}

void OtherParams::Onbtnsethtb() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);

	HoptableData_ST hoptable;
	int flagcnt = 0;

	for(int i=0; i<m_htb.GetItemCount(); i++)
	{
		if (m_htb.GetCheck(i))
		{
			hoptable.htb[flagcnt] = atoi(m_htb.GetItemText(i, 0));
			flagcnt++;
		}
	}
	hoptable.lenhtb = flagcnt;
	if (ParamSet(m_hReader, MTR_PARAM_FREQUENCY_HOPTABLE, &hoptable) != MT_OK_ERR)
	{
		MessageBox("获取频率表失败");
		return;
	}
	
}

void OtherParams::Onbtnsetgen2blf() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	if (ParamSet(m_hReader, MTR_PARAM_POTL_GEN2_BLF, &m_gen2blf) != MT_OK_ERR)
	{
		MessageBox("设置失败");
		return;
	}
}

void OtherParams::Onbtngetgen2blf() 
{
	// TODO: Add your control notification handler code here
	int err = ParamGet(m_hReader, MTR_PARAM_POTL_GEN2_BLF, &m_gen2blf);
	if (err != MT_OK_ERR)
	{
		MessageBox("设置失败");
		return;
	}
	UpdateData(false);
}

void OtherParams::Onbtnuniantget() 
{
	// TODO: Add your control notification handler code here
	int is;
	int err = ParamGet(m_hReader, MTR_PARAM_TAGDATA_UNIQUEBYANT, &is);
	if (err != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
	if (is == 0)
		m_uniant = "不唯一";
	else
		m_uniant = "唯一";
	UpdateData(false);
}

void OtherParams::Onbtnuniantset() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	int is = 0;
	if (m_uniant == "")
	{
		MessageBox("请选择是否唯一");
		return;
	}
	else if (m_uniant == "唯一")
		is = 1;
	else if (m_uniant == "不唯一")
		is = 0;
	if (ParamSet(m_hReader, MTR_PARAM_TAGDATA_UNIQUEBYANT, &is) != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
}

void OtherParams::Onbtnuniemdget() 
{
	// TODO: Add your control notification handler code here
	int is;
	int err = ParamGet(m_hReader, MTR_PARAM_TAGDATA_UNIQUEBYEMDDATA, &is);
	if (err != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
	if (is == 0)
		m_uniemd = "不唯一";
	else
		m_uniemd = "唯一";
	UpdateData(false);
}

void OtherParams::Onbtnuniemdset() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	int is = 0;
	if (m_uniemd == "")
	{
		MessageBox("请选择是否唯一");
		return;
	}
	else if (m_uniemd == "唯一")
		is = 1;
	else if (m_uniemd == "不唯一")
		is = 0;
	if (ParamSet(m_hReader, MTR_PARAM_TAGDATA_UNIQUEBYEMDDATA, &is) != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
}

void OtherParams::Onbtnrechrssiget() 
{
	// TODO: Add your control notification handler code here
	int is;
	int err = ParamGet(m_hReader, MTR_PARAM_TAGDATA_RECORDHIGHESTRSSI, &is);
	if (err != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
	if (is == 0)
		m_rechrssi = "不记录";
	else
		m_rechrssi = "记录";
	UpdateData(false);
}

void OtherParams::Onbtnrechrssiset() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	int is = 0;
	if (m_rechrssi == "")
	{
		MessageBox("请选择是否记录");
		return;
	}
	else if (m_rechrssi == "记录")
		is = 1;
	else if (m_rechrssi == "不记录")
		is = 0;
	if (ParamSet(m_hReader, MTR_PARAM_TAGDATA_RECORDHIGHESTRSSI, &is) != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
}

void OtherParams::Onbtngen2tariget() 
{
	// TODO: Add your control notification handler code here
	int tari;
	int err = ParamGet(m_hReader, MTR_PARAM_POTL_GEN2_TARI, &tari);
	if (err != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
	if (tari == 0)
		m_gen2tari = "25微妙";
	else if (tari == 1)
		m_gen2tari = "12.5微妙";
	else if (tari == 2)
		m_gen2tari = "6.25微妙";
	UpdateData(false);
}

void OtherParams::Onbtngen2tariset() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	int tari = 0;
	if (m_gen2tari == "")
	{
		MessageBox("请选择gen2tari");
		return;
	}
	else if (m_gen2tari == "25微妙")
		tari = 0;
	else if (m_gen2tari == "12.5微妙")
		tari = 1;
	else if (m_gen2tari == "6.25微妙")
		tari = 2;

	if (ParamSet(m_hReader, MTR_PARAM_POTL_GEN2_TARI, &tari) != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
}

void OtherParams::Onbtngen2targetget() 
{
	// TODO: Add your control notification handler code here
	int tg;
	int err = ParamGet(m_hReader, MTR_PARAM_POTL_GEN2_TARGET, &tg);
	if (err != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
	if (tg == 0)
		m_gen2target = "A";
	else if (tg == 1)
		m_gen2target = "B";
	else if (tg == 2)
		m_gen2target = "A->B";
	else if (tg == 3)
		m_gen2target = "B->A";
	UpdateData(false);
}

void OtherParams::Onbtngen2targetset() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	int tg = 0;
	if (m_gen2target == "")
	{
		MessageBox("请选择gen2target");
		return;
	}
	else if (m_gen2target == "A")
		tg = 0;
	else if (m_gen2target == "B")
		tg = 1;
	else if (m_gen2target == "A->B")
		tg = 2;
	else if (m_gen2target == "B->A")
		tg = 3;

	if (ParamSet(m_hReader, MTR_PARAM_POTL_GEN2_TARGET, &tg) != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
}

void OtherParams::Onbtnhoptimeget() 
{
	// TODO: Add your control notification handler code here
	int err = ParamGet(m_hReader, MTR_PARAM_RF_HOPTIME, &m_hoptime);
	if (err != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}

	UpdateData(false);
}

void OtherParams::Onbtnhoptimeset() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	int err = ParamSet(m_hReader, MTR_PARAM_RF_HOPTIME, &m_hoptime);
	if (err != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
	
}

void OtherParams::Onbtnlbtenbleget() 
{
	// TODO: Add your control notification handler code here
	int is;
	int err = ParamGet(m_hReader, MTR_PARAM_RF_LBT_ENABLE, &is);
	if (err != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
	if (is == 0)
		m_lbtenble = "不开启";
	else
		m_rechrssi = "开启";
	UpdateData(false);
}

void OtherParams::Onbtnlbtenbleset() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	int is = 0;
	if (m_lbtenble == "")
	{
		MessageBox("请选择是否开启lbt");
		return;
	}
	else if (m_lbtenble == "开启")
		is = 1;
	else if (m_lbtenble == "不开启")
		is = 0;
	if (ParamSet(m_hReader, MTR_PARAM_RF_LBT_ENABLE, &is) != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
}

void OtherParams::Onbtngen2wmodeget() 
{
	// TODO: Add your control notification handler code here
	int wmode;
	int err = ParamGet(m_hReader, MTR_PARAM_POTL_GEN2_WRITEMODE, &wmode);
	if (err != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
	if (wmode == 0)
		m_gen2wmode = "字写";
	else
		m_gen2wmode = "块写";
	UpdateData(false);
}

void OtherParams::Onbtngen2wmodeset() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	int wmode = 0;
	if (m_gen2wmode == "")
	{
		MessageBox("请选择写模式");
		return;
	}
	else if (m_gen2wmode == "字写")
		wmode = 0;
	else if (m_gen2wmode == "块写")
		wmode = 1;
	if (ParamSet(m_hReader, MTR_PARAM_POTL_GEN2_WRITEMODE, &wmode) != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
}

void OtherParams::Onbtn6bblfget() 
{
	// TODO: Add your control notification handler code here
	int err = ParamGet(m_hReader, MTR_PARAM_POTL_ISO180006B_BLF, &m_6bblf);
	if (err != MT_OK_ERR)
	{
		MessageBox("设置失败");
		return;
	}
	UpdateData(false);
}

void OtherParams::Onbtn6bblfset() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	if (ParamSet(m_hReader, MTR_PARAM_POTL_ISO180006B_BLF, &m_6bblf) != MT_OK_ERR)
	{
		MessageBox("设置失败");
		return;
	}
}


void OtherParams::Onbtnsetsecureread() 
{
	// TODO: Add your control notification handler code here
	UpdateData(true);
	EmbededSecureRead_ST esrst;
	if (m_pwdtype == -1)
	{
		MessageBox("请选择密码类型");
		return;
	}
	esrst.pwdtype = m_pwdtype;
	if (m_pwdtype == 1)
	{
		if (m_sracspwd.GetLength() != 8)
		{
			MessageBox("请填入正确访问密码，必须为8个16进制字符");
			return;
		}
		unsigned char srpwd[4];
		Str2Hex(m_sracspwd.GetBuffer(0), m_sracspwd.GetLength(), srpwd);
		esrst.accesspwd = (srpwd[0] << 24) | (srpwd[1] << 16) | (srpwd[2] << 8) | (srpwd[3] << 0);
	}
	if (m_tagtype == -1)
	{
		MessageBox("请选择标签类型");
		return;
	}
	esrst.tagtype = m_tagtype+1;
	if (m_pwdtype == 1)
	{
		if (m_indexbitaddr < 0 || m_indexbitaddr > 96)
		{
			MessageBox("索引起始bit非法");
			return;
		}
		if (m_indexbitnum <= 0 || m_indexbitnum > 96)
		{
			MessageBox("索引bit数非法");
			return;
		}
	}
	esrst.ApIndexStartBitsInEpc = m_indexbitaddr;
	esrst.ApIndexBitsNumInEpc = m_indexbitnum;
	if (m_srbank < 0 || m_srbank > 3)
	{
		MessageBox("bank 必须为0-3");
		return;
	}
	esrst.bank = m_srbank;
	esrst.address = m_sraddress;
	esrst.blkcnt = m_srblks;

	if (ParamSet(m_hReader, MTR_PARAM_TAG_EMDSECUREREAD, &esrst) != MT_OK_ERR)
	{
		MessageBox("设置失败");
		return;
	}
}

void OtherParams::Onbtngetsecureread() 
{
	// TODO: Add your control notification handler code here
	EmbededSecureRead_ST esrst;
	if (ParamGet(m_hReader, MTR_PARAM_TAG_EMDSECUREREAD, &esrst) != MT_OK_ERR)
	{
		MessageBox("获取失败");
		return;
	}
	m_pwdtype = esrst.pwdtype;
	m_tagtype = esrst.tagtype-1;
	m_indexbitnum = esrst.ApIndexBitsNumInEpc;
	m_indexbitaddr = esrst.ApIndexStartBitsInEpc;
	unsigned char pwd[4];
	pwd[0] = (esrst.accesspwd >> 24) & 0xff;
	pwd[1] = (esrst.accesspwd >> 16) & 0xff;
	pwd[2] = (esrst.accesspwd >> 8) & 0xff;
	pwd[3] = (esrst.accesspwd >> 0) & 0xff;
	char pwdstr[9];
	Hex2Str(pwd, 4, pwdstr);
	m_sracspwd = pwdstr;
	m_srblks = esrst.blkcnt;
	m_srbank = esrst.bank;
	m_sraddress = esrst.address;
	UpdateData(false);
}

void OtherParams::Onbtnflashwrite() 
{
	// TODO: Add your control notification handler code here
	UpdateData(true);
	unsigned char wdata[256];
	if (m_fwdata == "")
	{
		MessageBox("请输入写入数据");
		return;
	}
	Str2Hex(m_fwdata.GetBuffer(0), m_fwdata.GetLength(), wdata);
	if (EraseDataOnReader(m_hReader) != MT_OK_ERR)
	{
		MessageBox("写入失败");
		return;
	}
	if (SaveDataOnReader(m_hReader, m_fwaddr, wdata, m_fwdata.GetLength()/2) != MT_OK_ERR)
	{
		MessageBox("写入失败");
		return;
	}
}

void OtherParams::Onbtnresetsr() 
{
	// TODO: Add your control notification handler code here
	ParamSet(m_hReader, MTR_PARAM_TAG_EMDSECUREREAD, NULL);
}

void OtherParams::Onbtngettransmitmod() 
{
	// TODO: Add your control notification handler code here
	int mode;
	int err = ParamGet(m_hReader, MTR_PARAM_TRANSMIT_MODE, &mode);
	if (err != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
	if (mode == 0)
		m_transmitmode = "高性能";
	else if (mode == 1)
		m_transmitmode = "低电量";
	UpdateData(false);
}

void OtherParams::Onbtnsettransmitmod2() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	int mode = 0;
	if (m_transmitmode == "")
	{
		MessageBox("请选择发射模式");
		return;
	}
	else if (m_transmitmode == "高性能")
		mode = 0;
	else if (m_transmitmode == "低电量")
		mode = 1;
	
	if (ParamSet(m_hReader, MTR_PARAM_TRANSMIT_MODE, &mode) != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
}

void OtherParams::Onbtngetpowersavemode() 
{
	// TODO: Add your control notification handler code here
	int mode;
	int err = ParamGet(m_hReader, MTR_PARAM_POWERSAVE_MODE, &mode);
	if (err != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
	
	if (mode == 0)
		m_powersave = "不省电";
	else if (mode == 1)
		m_powersave = "一级省电";
	else if (mode == 2)
		m_powersave = "二级省电";
	else if (mode == 3)
		m_powersave = "三级省电";

	UpdateData(false);
}

void OtherParams::Onbtnsetpowersavemode() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	int mode = 0;
	if (m_powersave == "")
	{
		MessageBox("请选择省电模式");
		return;
	}
	else if (m_powersave == "不省电")
		mode = 0;
	else if (m_powersave == "一级省电")
		mode = 1;
	else if (m_powersave == "二级省电")
		mode = 2;
	else if (m_powersave == "三级省电")
		mode = 3;

	if (ParamSet(m_hReader, MTR_PARAM_POWERSAVE_MODE, &mode) != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
}

void OtherParams::Onbtngetinvmode() 
{
	// TODO: Add your control notification handler code here
	int mode;
	if (ParamGet(m_hReader, MTR_PARAM_TAG_SEARCH_MODE, &mode) != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
	m_invmode = mode;
	UpdateData(FALSE);
}

void OtherParams::Onbtnsetinvmode() 
{
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	if (ParamSet(m_hReader, MTR_PARAM_TAG_SEARCH_MODE, &m_invmode) != MT_OK_ERR)
	{
		MessageBox("操作失败");
		return;
	}
}

void OtherParams::OnBUTTONsavesettings() 
{
	// TODO: Add your control notification handler code here
	int val1=1;
	if(ParamSet(m_hReader,MTR_PARAM_SAVECONFIGURATION,&val1) ==MT_OK_ERR)
	{
		MessageBox("保存完成，请重新连接读写器");
		return;
	}
	else
	{
		MessageBox("保存失败");
	}
}

void OtherParams::OnBnClickedButtoneraseconf()
{
	int val1=0;
	if(ParamSet(m_hReader,MTR_PARAM_SAVECONFIGURATION,&val1) ==MT_OK_ERR)
	{
		MessageBox("擦除完成，读写器重新上电后完全生效");
		return;
	}
	else
	{
		MessageBox("擦除失败");
	}
	// TODO: 在此添加控件通知处理程序代码
}
