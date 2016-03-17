#if !defined(AFX_ISO180006BOPDLG_H__6D5C4FB3_C631_4550_AFD8_68252315C0DE__INCLUDED_)
#define AFX_ISO180006BOPDLG_H__6D5C4FB3_C631_4550_AFD8_68252315C0DE__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// ISO180006bOpDlg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// ISO180006bOpDlg dialog

class ISO180006bOpDlg : public CDialog
{
// Construction
public:
	ISO180006bOpDlg(CWnd* pParent, int hreader);   // standard constructor

// Dialog Data
	//{{AFX_DATA(ISO180006bOpDlg)
	enum { IDD = IDD_ISO180006BOPDLG_DIALOG };
	CListBox	m_lvtags;
	BOOL	m_isant1;
	BOOL	m_isant2;
	BOOL	m_isant3;
	BOOL	m_isant4;
	CString	m_datastr;
	int		m_staddr;
	UINT	m_blkscnt;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(ISO180006bOpDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	//}}AFX_VIRTUAL

// Implementation
protected:
	int m_hreader;
	int selectants[4];
	int selcnts;

	int ValidAntenna(int num);
	int opant();
	int Validwdata();
	// Generated message map functions
	//{{AFX_MSG(ISO180006bOpDlg)
	afx_msg void Onbtnstart();
	afx_msg void OnTimer(UINT nIDEvent);
	afx_msg void Onbtnstop();
	afx_msg void Onbtnread();
	afx_msg void Onbtnclear();
	afx_msg void Onbtnwrite();
	afx_msg void Onbtnlock();
	afx_msg void OnClose();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_ISO180006BOPDLG_H__6D5C4FB3_C631_4550_AFD8_68252315C0DE__INCLUDED_)
