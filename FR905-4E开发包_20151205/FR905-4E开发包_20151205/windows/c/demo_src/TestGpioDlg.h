#if !defined(AFX_TESTGPIODLG_H__8D8904F5_11E9_43D7_B6E1_2F294EAC4AAA__INCLUDED_)
#define AFX_TESTGPIODLG_H__8D8904F5_11E9_43D7_B6E1_2F294EAC4AAA__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// TestGpioDlg.h : header file
//
#include "ModuleReaderManagerDlg.h"
/////////////////////////////////////////////////////////////////////////////
// TestGpioDlg dialog

class TestGpioDlg : public CDialog
{
// Construction
public:
	TestGpioDlg(CWnd* pParent, int reader,
		CModuleReaderManagerDlg *pdlg);   // standard constructor

// Dialog Data
	//{{AFX_DATA(TestGpioDlg)
	enum { IDD = IDD_TESTGPIODLG_DIALOG };
	BOOL	m_isgpi1;
	BOOL	m_isgpi2;
	BOOL	m_isgpi3;
	BOOL	m_isgpi4;
	BOOL	m_isgpo1;
	BOOL	m_isgpo2;
	BOOL	m_isgpo3;
	BOOL	m_isgpo4;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(TestGpioDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	CModuleReaderManagerDlg *m_pdlg;
	int m_hreader;
	// Generated message map functions
	//{{AFX_MSG(TestGpioDlg)
	afx_msg void Onbtngetgpi();
	afx_msg void Onbtnsetgpo();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedbtnexec();
	CString m_recvstr;
	CString m_sendstr;
	int m_psamslot;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_TESTGPIODLG_H__8D8904F5_11E9_43D7_B6E1_2F294EAC4AAA__INCLUDED_)
