// ModuleReaderManagerDlg.h : header file
//

#if !defined(AFX_MODULEREADERMANAGERDLG_H__501C4CB9_55A5_48D9_AD61_79F55FFBB0D3__INCLUDED_)
#define AFX_MODULEREADERMANAGERDLG_H__501C4CB9_55A5_48D9_AD61_79F55FFBB0D3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "ModuleReader.h"
#include "afxwin.h"
/////////////////////////////////////////////////////////////////////////////
// CModuleReaderManagerDlg dialog

#define WM_MY_MSG_TAGINV (WM_USER+100)


class CModuleReaderManagerDlg : public CDialog
{
// Construction
public:
	CModuleReaderManagerDlg(CWnd* pParent = NULL);	// standard constructor
	
// Dialog Data
	//{{AFX_DATA(CModuleReaderManagerDlg)
	enum { IDD = IDD_MODULEREADERMANAGER_DIALOG };
	CButton	m_conisasyncread;
	CButton	m_btnkill;
	CButton	m_btnrandrw;
	CButton	m_writeepc;
	CButton	m_testgpio;
	CButton	m_otherparams;
	CButton	m_180006bop;
	CButton	m_16antsset;
	CListCtrl	m_listtags;
	CButton	m_cisIpx64;
	CButton	m_cisIpx256;
	CButton	m_cis180006b;
	CButton	m_cisgen2;
	CButton	m_btnCustcmd;
	CEdit	m_gatewayc;
	CEdit	m_subnetc;
	CEdit	m_ipc;
	CEdit	m_ant4wpc;
	CEdit	m_ant4rpc;
	CEdit	m_ant3wpc;
	CEdit	m_ant3rpc;
	CEdit	m_ant2wpc;
	CEdit	m_ant2rpc;
	CEdit	m_ant1wpc;
	CEdit	m_ant1rpc;
	CButton	m_setconf;
	CButton	m_getconf;
	CButton	m_stoptest;
	CButton	m_btnconnect;
	CButton	m_btnlock;
	CButton	m_btnwrite;
	CButton	m_btnstop;
	CButton	m_btnstart;
	CButton	m_btnread;
	CButton	m_ant4;
	CButton	m_ant3;
	CButton	m_ant2;
	CButton	m_ant1;
	CString	m_sourcestr;
	BOOL	m_isfilter;
	CString	m_fdata;
	CString	m_faddr;
	CString	m_addr;
	CString	m_blks;
	BOOL	m_ispwd;
	CString	m_accesspwd;
	BOOL	m_isMatch;
	BOOL	m_bant1;
	BOOL	m_bant2;
	BOOL	m_bant3;
	BOOL	m_bant4;
	int		m_filterbank;
	CString	m_wrdata;
	int		m_wrbank;
	int		m_lockobj;
	int		m_locktype;
	BOOL	m_repisrand;
	BOOL	m_repisrep;
	CString	logstr;
	CString	m_repcnt;
	CString	m_randlen;
	CString	m_timeout;
	int		m_addbytes;
	int		m_addbank;
	int		m_session;
	BOOL	m_isadddata;
	CString	m_ip;
	CString	m_subnet;
	CString	m_gateway;
	CString	m_ant1rp;
	CString	m_ant1wp;
	CString	m_ant2rp;
	CString	m_ant2wp;
	CString	m_ant3rp;
	CString	m_ant3wp;
	CString	m_ant4rp;
	CString	m_ant4wp;
	CString	m_ebstartaddr;
	int m_realreadertype;
	int		m_maxepc;
	BOOL	m_is180006b;
	BOOL	m_isGen2;
	int		m_ReaderIndex;
	CString	m_BoardType;
	CString	m_ModuleType;
	BOOL	m_isIpx256;
	BOOL	m_isIpx64;
	int		m_readdur;
	int		m_sleepdur;
	CString	m_emdbytecnt;
	BOOL	m_isasyncread;
	//}}AFX_DATA
	int m_reader;
	int selectants[16];
	int selcnts;

	HardwareDetails hwdtls;
	int m_readertype;
	CFont       m_font;
//	CBrush m_brush;

	TAGINFO m_tags[200];
	int m_tagscnt;

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CModuleReaderManagerDlg)
	public:
	virtual BOOL DestroyWindow();
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
	
public:
	int ValidHexStr(char *buf, int maxlen);
	int ValidHexStr(char *buf);
	int m_antscnt;
	static void OnReadTag(TAGINFO *tag, void* cookie);
protected:
	HICON m_hIcon;
	int SetFilter_();
	int ValidAntenna(int num);
	int Validaccpwd();
	int Validwdata();
	
	int ValidPower(CString &power, unsigned short Max, unsigned short Min,
												   unsigned short *pwrs, int pos);
	CString m__ip;
	CString m__subnet;
	CString m__gateway;

	int isInit;
	bool isGetIp;
	
	bool isIP;
	int opant();

	static	DWORD WINAPI StopAsyncReadingFunc( LPVOID lpParam );

	static	DWORD WINAPI ThreadReadTagData( LPVOID lpParam );
	static	DWORD WINAPI ThreadWriteTagData( LPVOID lpParam );

	static	DWORD WINAPI ThreadTagInventory( LPVOID lpParam );
	static  DWORD WINAPI ThreadRandReadAndWrite(LPVOID lpParam);
	HANDLE m_hTagInvTh;
	bool m_isTagInvRun;
	TAGINFO m_InvTags[1000];
	int m_InvTagCnt;
	HANDLE m_thread;
	bool isTestRun;
	bool ismachstoptest;
	bool isInventory;
	HANDLE m_hMutex;

	// Generated message map functions
	//{{AFX_MSG(CModuleReaderManagerDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void Onbtnconnect();
	afx_msg void Onbtnstart();
	afx_msg void Onbtnstop();
	afx_msg void Onbtnread();
	afx_msg void Onbtnwrite();
	afx_msg void Onbtnlock();
	afx_msg void Onbtnstoptest();
	afx_msg void OnClose();
	afx_msg void Onbtnsetconf();
	afx_msg void Onbtngetconf();
	afx_msg void OnbtnCustomCmd();
	afx_msg void Onbtnwriteepc();
	afx_msg void Onbtn180006bop();
	afx_msg void Onbtntestgpio();
	afx_msg void Onbtnotherparam();
	afx_msg LRESULT OnTagInv(WPARAM wParam, LPARAM lParam);
	afx_msg void Onbtnclear();
	afx_msg void Onbtn16antsset();
	afx_msg void Onbtnrandrw();
	afx_msg void Onbtnclearlog();
	afx_msg void Onbtnkill();
	afx_msg void OnButton7();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedButton4();
	afx_msg void OnBnClickedbtndisconnect();
	CButton m_btndisc;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MODULEREADERMANAGERDLG_H__501C4CB9_55A5_48D9_AD61_79F55FFBB0D3__INCLUDED_)
