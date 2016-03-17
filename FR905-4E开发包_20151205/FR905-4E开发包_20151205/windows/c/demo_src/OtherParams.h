#if !defined(AFX_OTHERPARAMS_H__7FF3F065_0B90_4748_A0E6_1E313A911A34__INCLUDED_)
#define AFX_OTHERPARAMS_H__7FF3F065_0B90_4748_A0E6_1E313A911A34__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// OtherParams.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// OtherParams dialog

class OtherParams : public CDialog
{
// Construction
public:
	OtherParams(CWnd* pParent, int reader);   // standard constructor

// Dialog Data
	//{{AFX_DATA(OtherParams)
	enum { IDD = IDD_OTHERPARAMS_DIALOG };
	CListCtrl	m_htb;
	int		m_ebank;
	int		m_estart;
	int		m_fbank;
	int		m_fbitstart;
	CString	m_fmdata;
	int		m_mbytescnt;
	CString	m_mpwd;
	int		m_qval;
	CString	m_ischk;
	int		m_fismatch;
	CString	m_selectregion;
	int		m_gen2blf;
	CString	m_uniant;
	CString	m_uniemd;
	CString	m_rechrssi;
	CString	m_gen2tari;
	CString	m_gen2target;
	int		m_hoptime;
	CString	m_lbtenble;
	CString	m_gen2wmode;
	CString	m_gen2enc;
	int		m_6bblf;
	CString	m_sracspwd;
	int		m_sraddress;
	int		m_srbank;
	int		m_srblks;
	CString	m_fwdata;
	int		m_indexbitaddr;
	int		m_indexbitnum;
	int		m_fwaddr;
	int		m_pwdtype;
	int		m_tagtype;
	CString	m_powersave;
	CString	m_transmitmode;
	int		m_invmode;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(OtherParams)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	int m_hReader;
	// Generated message map functions
	//{{AFX_MSG(OtherParams)
	afx_msg void Onbtnsetqval();
	afx_msg void Onbtngetqval();
	afx_msg void Onbtnsetchk();
	afx_msg void Onbtngetchk();
	afx_msg void Onbtnsetfilter();
	afx_msg void Onbtngetfilter();
	afx_msg void Onbtnsetemb();
	afx_msg void Onbtngetemb();
	afx_msg void Onbtnsetmval();
	afx_msg void Onbtngetmval();
	afx_msg void Onbtnresetfilter();
	afx_msg void Onbtnresetemb();
	afx_msg void OnsetRegion();
	afx_msg void OngetRegion();
	afx_msg void Onbtngethtb();
	afx_msg void Onbtnsethtb();
	afx_msg void Onbtnsetgen2blf();
	afx_msg void Onbtngetgen2blf();
	afx_msg void Onbtnuniantget();
	afx_msg void Onbtnuniantset();
	afx_msg void Onbtnuniemdget();
	afx_msg void Onbtnuniemdset();
	afx_msg void Onbtnrechrssiget();
	afx_msg void Onbtnrechrssiset();
	afx_msg void Onbtngen2tariget();
	afx_msg void Onbtngen2tariset();
	afx_msg void Onbtngen2targetget();
	afx_msg void Onbtngen2targetset();
	afx_msg void Onbtnhoptimeget();
	afx_msg void Onbtnhoptimeset();
	afx_msg void Onbtnlbtenbleget();
	afx_msg void Onbtnlbtenbleset();
	afx_msg void Onbtngen2wmodeget();
	afx_msg void Onbtngen2wmodeset();
 	afx_msg void Onbtn6bblfget();
 	afx_msg void Onbtn6bblfset();
	afx_msg void Onbtnsetsecureread();
	afx_msg void Onbtngetsecureread();
	afx_msg void Onbtnflashwrite();
	afx_msg void Onbtnresetsr();
	afx_msg void Onbtngettransmitmod();
	afx_msg void Onbtnsettransmitmod2();
	afx_msg void Onbtngetpowersavemode();
	afx_msg void Onbtnsetpowersavemode();
	afx_msg void Onbtngetinvmode();
	afx_msg void Onbtnsetinvmode();
	afx_msg void OnBUTTONsavesettings();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedButtoneraseconf();
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_OTHERPARAMS_H__7FF3F065_0B90_4748_A0E6_1E313A911A34__INCLUDED_)
