#if !defined(AFX_CUSTOMDLG_H__DB08EDE6_156A_4413_A788_9FB4B9FEF7CF__INCLUDED_)
#define AFX_CUSTOMDLG_H__DB08EDE6_156A_4413_A788_9FB4B9FEF7CF__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// CustomDlg.h : header file
//
#include "ModuleReaderManagerDlg.h"
/////////////////////////////////////////////////////////////////////////////
// CCustomDlg dialog

class CCustomDlg : public CDialog
{
// Construction
public:
	CCustomDlg(CWnd* pParent = NULL);   // standard constructor
	CModuleReaderManagerDlg *m_pdlg;
	int getAnt();
	int Validaccpwd();
	int SetFilter_();

// Dialog Data
	//{{AFX_DATA(CCustomDlg)
	enum { IDD = IDD_CUSTOMDLG_DIALOG };
	CEdit	m_tbblkrange;
	CEdit	m_tbstartblk;
	CString	m_EASDataStr;
	CString	m_accesspwd;
	int		m_ant;
	int		m_EASstate;
	BOOL	m_isblk1;
	BOOL	m_isblk2;
	BOOL	m_isblk3;
	BOOL	m_isblk4;
	BOOL	m_isblk5;
	BOOL	m_isblk6;
	BOOL	m_isblk7;
	BOOL	m_isblk8;
	int		m_filterbank;
	CString	m_faddr;
	CString	m_fdata;
	BOOL	m_isMatch;
	BOOL	m_isfilter;
	int		m_impinjqtcmdread;
	int		m_impinjqtmempublic;
	int		m_impinjpersistperm;
	int		m_impinjnear;
	BOOL	m_isperm1;
	BOOL	m_isperm2;
	BOOL	m_isperm3;
	BOOL	m_isperm4;
	BOOL	m_isperm5;
	BOOL	m_isperm6;
	BOOL	m_isperm7;
	BOOL	m_isperm8;
	int		m_blkrange;
	int		m_startblk;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CCustomDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CCustomDlg)
	afx_msg void OnbtnChangeEAS();
	afx_msg void OnbtnEASAlarm();
	virtual BOOL OnInitDialog();
	afx_msg void OnbtnBlockReadLock();
	afx_msg void Onbtnsetimpinjqt();
	afx_msg void Onbtnpermlockget();
	afx_msg void Onbtnpermlockset();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CUSTOMDLG_H__DB08EDE6_156A_4413_A788_9FB4B9FEF7CF__INCLUDED_)
