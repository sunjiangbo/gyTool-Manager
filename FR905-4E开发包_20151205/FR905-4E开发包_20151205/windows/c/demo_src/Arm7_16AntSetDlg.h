#if !defined(AFX_ARM7_16ANTSETDLG_H__576A75E0_982B_4C37_81AB_258940D230C5__INCLUDED_)
#define AFX_ARM7_16ANTSETDLG_H__576A75E0_982B_4C37_81AB_258940D230C5__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// Arm7_16AntSetDlg.h : header file
//
#include "ModuleReaderManagerDlg.h"
/////////////////////////////////////////////////////////////////////////////
// Arm7_16AntSetDlg dialog

class Arm7_16AntSetDlg : public CDialog
{
// Construction
public:
	Arm7_16AntSetDlg(CModuleReaderManagerDlg *pmrm, int reader, CWnd* pParent = NULL);   // standard constructor
	CModuleReaderManagerDlg *pMrM;
	int m_reader;
	CButton *pants[17];
	ConnAnts_ST cst;
// Dialog Data
	//{{AFX_DATA(Arm7_16AntSetDlg)
	enum { IDD = IDD_ARM7_16ANTSETDLG_DIALOG };
	CButton	m_cant9;
	CButton	m_cant8;
	CButton	m_cant7;
	CButton	m_cant6;
	CButton	m_cant5;
	CButton	m_cant4;
	CButton	m_cant3;
	CButton	m_cant2;
	CButton	m_cant16;
	CButton	m_cant15;
	CButton	m_cant14;
	CButton	m_cant13;
	CButton	m_cant12;
	CButton	m_cant11;
	CButton	m_cant10;
	CButton	m_cant1;
	BOOL	m_isant1;
	BOOL	m_isant10;
	BOOL	m_isant11;
	BOOL	m_isant12;
	BOOL	m_isant13;
	BOOL	m_isant14;
	BOOL	m_isant15;
	BOOL	m_isant16;
	BOOL	m_isant2;
	BOOL	m_isant3;
	BOOL	m_isant4;
	BOOL	m_isant5;
	BOOL	m_isant6;
	BOOL	m_isant7;
	BOOL	m_isant8;
	BOOL	m_isant9;
	int		m_readpwr;
	int		m_writepwr;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(Arm7_16AntSetDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(Arm7_16AntSetDlg)
	afx_msg void Onbtnok();
	virtual BOOL OnInitDialog();
	afx_msg HBRUSH OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor);
	afx_msg void Onbtnset();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_ARM7_16ANTSETDLG_H__576A75E0_982B_4C37_81AB_258940D230C5__INCLUDED_)
