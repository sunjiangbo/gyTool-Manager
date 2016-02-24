// ModuleReaderManager.h : main header file for the MODULEREADERMANAGER application
//

#if !defined(AFX_MODULEREADERMANAGER_H__FF92CCB0_6855_46D0_8D0A_DA35AAC7A0B2__INCLUDED_)
#define AFX_MODULEREADERMANAGER_H__FF92CCB0_6855_46D0_8D0A_DA35AAC7A0B2__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CModuleReaderManagerApp:
// See ModuleReaderManager.cpp for the implementation of this class
//

class CModuleReaderManagerApp : public CWinApp
{
public:
	CModuleReaderManagerApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CModuleReaderManagerApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CModuleReaderManagerApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MODULEREADERMANAGER_H__FF92CCB0_6855_46D0_8D0A_DA35AAC7A0B2__INCLUDED_)
