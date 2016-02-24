; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=OtherParams
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "ModuleReaderManager.h"

ClassCount=8
Class1=CModuleReaderManagerApp
Class2=CModuleReaderManagerDlg
Class3=CAboutDlg

ResourceCount=8
Resource1=IDD_CUSTOMDLG_DIALOG
Resource2=IDR_MAINFRAME
Class4=CCustomDlg
Resource3=IDD_MODULEREADERMANAGER_DIALOG
Resource4=IDD_ABOUTBOX
Class5=ISO180006bOpDlg
Resource5=IDD_ISO180006BOPDLG_DIALOG
Class6=TestGpioDlg
Resource6=IDD_TESTGPIODLG_DIALOG
Class7=OtherParams
Resource7=IDD_OTHERPARAMS_DIALOG
Class8=Arm7_16AntSetDlg
Resource8=IDD_ARM7_16ANTSETDLG_DIALOG

[CLS:CModuleReaderManagerApp]
Type=0
HeaderFile=ModuleReaderManager.h
ImplementationFile=ModuleReaderManager.cpp
Filter=N
LastObject=CModuleReaderManagerApp

[CLS:CModuleReaderManagerDlg]
Type=0
HeaderFile=ModuleReaderManagerDlg.h
ImplementationFile=ModuleReaderManagerDlg.cpp
Filter=D
BaseClass=CDialog
VirtualFilter=dWC
LastObject=IDC_Chkasyncread

[CLS:CAboutDlg]
Type=0
HeaderFile=ModuleReaderManagerDlg.h
ImplementationFile=ModuleReaderManagerDlg.cpp
Filter=D
LastObject=CAboutDlg

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[DLG:IDD_MODULEREADERMANAGER_DIALOG]
Type=1
Class=CModuleReaderManagerDlg
ControlCount=117
Control1=IDC_STATIC,static,1342308352
Control2=IDC_tbsrcstr,edit,1350631552
Control3=IDC_btnconnect,button,1342242816
Control4=IDC_btnstart,button,1342242816
Control5=IDC_btnstop,button,1342242816
Control6=IDC_btnclear,button,1342242816
Control7=IDC_STATIC,static,1342308352
Control8=IDC_STATIC,static,1342308352
Control9=IDC_tbfaddr,edit,1350631552
Control10=IDC_STATIC,static,1342308352
Control11=IDC_tbfdata,edit,1350631552
Control12=IDC_STATIC,static,1342308352
Control13=IDC_tbaccesspwd,edit,1350631552
Control14=IDC_ccpwd,button,1342242819
Control15=IDC_ccfilter,button,1342242819
Control16=IDC_STATIC,static,1342308352
Control17=IDC_STATIC,static,1342308352
Control18=IDC_tbaddr,edit,1350631552
Control19=IDC_STATIC,static,1342308352
Control20=IDC_tbblocks,edit,1350631552
Control21=IDC_data,static,1342308352
Control22=IDC_btnread,button,1342242816
Control23=IDC_btnwrite,button,1342242816
Control24=IDC_btnlock,button,1342242816
Control25=IDC_STATIC,static,1342308352
Control26=IDC_STATIC,static,1342308352
Control27=IDC_ccInvert,button,1342242819
Control28=IDC_ccant1,button,1342242819
Control29=IDC_ccant2,button,1342242819
Control30=IDC_ccant3,button,1342242819
Control31=IDC_ccant4,button,1342242819
Control32=IDC_STATIC,static,1342308352
Control33=IDC_readertype,combobox,1342242819
Control34=IDC_STATIC,button,1342177287
Control35=IDC_fiterbank,combobox,1342242819
Control36=IDC_lockobj,combobox,1342242819
Control37=IDC_STATIC,button,1342177287
Control38=IDC_wrbank,combobox,1342242819
Control39=IDC_wrdata,RICHEDIT,1352728580
Control40=IDC_locktype,combobox,1342242819
Control41=IDC_STATIC,button,1342177287
Control42=IDC_STATIC,button,1342177287
Control43=IDC_STATIC,static,1342308352
Control44=IDC_repcnt,edit,1350631552
Control45=IDC_redloginfo,RICHEDIT,1352728580
Control46=IDC_repsirand,button,1342242819
Control47=IDC_STATIC,static,1342308352
Control48=IDC_reprandlen,edit,1350631552
Control49=IDC_STATIC,button,1342177287
Control50=IDC_STATIC,static,1342308352
Control51=IDC_repisrep,button,1342242819
Control52=IDC_STATIC,static,1342308352
Control53=IDC_timeout,edit,1350631552
Control54=IDC_btnstoptest,button,1342242816
Control55=IDC_STATIC,button,1342177287
Control56=IDC_STATIC,static,1342308352
Control57=IDC_tbebstartaddr,edit,1350631552
Control58=IDC_STATIC,static,1342308352
Control59=IDC_STATIC,static,1342308352
Control60=IDC_cbaddbank,combobox,1342242819
Control61=IDC_ckisaddtiondata,button,1342242819
Control62=IDC_STATIC,button,1342177287
Control63=IDC_STATIC,button,1342177287
Control64=IDC_STATIC,static,1342308352
Control65=IDC_tbant1rp,edit,1350631552
Control66=IDC_STATIC,static,1342308352
Control67=IDC_tbant2rp,edit,1350631552
Control68=IDC_STATIC,static,1342308352
Control69=IDC_tbant3rp,edit,1350631552
Control70=IDC_STATIC,static,1342308352
Control71=IDC_tbant4rp,edit,1350631552
Control72=IDC_STATIC,button,1342177287
Control73=IDC_STATIC,static,1342308352
Control74=IDC_STATIC,static,1342308352
Control75=IDC_STATIC,static,1342308352
Control76=IDC_STATIC,static,1342308352
Control77=IDC_tbant1wp,edit,1350631552
Control78=IDC_tbant2wp,edit,1350631552
Control79=IDC_tbant3wp,edit,1350631552
Control80=IDC_tbant4wp,edit,1350631552
Control81=IDC_STATIC,button,1342177287
Control82=IDC_STATIC,static,1342308352
Control83=IDC_tbip,edit,1350631552
Control84=IDC_STATIC,static,1342308352
Control85=IDC_tbgateway,edit,1350631552
Control86=IDC_STATIC,static,1342308352
Control87=IDC_tbsubnet,edit,1350631552
Control88=IDC_btnsetconf,button,1342242816
Control89=IDC_btngetconf,button,1342242816
Control90=IDC_STATIC,static,1342308352
Control91=IDC_cbsess,combobox,1342242819
Control92=IDC_btnCustomCmd,button,1342242816
Control93=IDC_btnwriteepc,button,1342242816
Control94=IDC_cbmaxepc,combobox,1342242819
Control95=IDC_STATIC,static,1342308352
Control96=IDC_CKGEN2,button,1342242819
Control97=IDC_CKISO180006B,button,1342242819
Control98=IDC_btn180006bop,button,1342242816
Control99=IDC_btntestgpio,button,1342242816
Control100=IDC_btnotherparam,button,1342242816
Control101=IDC_STATIC,static,1342308352
Control102=IDC_STATIC,static,1342308352
Control103=IDC_STATIC_boardtype,static,1342308352
Control104=IDC_STATIC_moduletype,static,1342308352
Control105=IDC_CKIPX64,button,1342242819
Control106=IDC_CKIPX256,button,1342242819
Control107=IDC_STATIC,static,1342308352
Control108=IDC_STATIC,static,1342308352
Control109=IDC_tbreaddur,edit,1350631552
Control110=IDC_tbsleepdur,edit,1350631552
Control111=IDC_listtags,SysListView32,1350631424
Control112=IDC_tbemdbytes,edit,1350631552
Control113=IDC_btn16antsset,button,1342242816
Control114=IDC_btnrandrw,button,1342242816
Control115=IDC_btnclearlog,button,1342242816
Control116=IDC_btnkill,button,1342242816
Control117=IDC_Chkasyncread,button,1342242819

[DLG:IDD_CUSTOMDLG_DIALOG]
Type=1
Class=CCustomDlg
ControlCount=64
Control1=IDC_STATIC,button,1342177287
Control2=IDC_btnChangeEAS,button,1342242816
Control3=IDC_btnEASAlarm,button,1342242816
Control4=IDC_STATIC,button,1342177287
Control5=IDC_rdset,button,1342308361
Control6=IDC_rdreset,button,1342177289
Control7=IDC_STATIC,button,1342177287
Control8=IDC_rdant1,button,1342308361
Control9=IDC_rdant2,button,1342177289
Control10=IDC_rdant3,button,1342177289
Control11=IDC_rdant4,button,1342177289
Control12=IDC_STATIC,button,1342177287
Control13=IDC_STATIC,static,1342308352
Control14=IDC_editpwd,edit,1350631552
Control15=IDC_STATIC,static,1342308352
Control16=IDC_statEASData,static,1342308352
Control17=IDC_STATIC,button,1342308359
Control18=IDC_btnBlockReadLock,button,1342242816
Control19=IDC_blkck1,button,1342242819
Control20=IDC_blkck2,button,1342242819
Control21=IDC_blkck3,button,1342242819
Control22=IDC_blkck4,button,1342242819
Control23=IDC_blkck5,button,1342242819
Control24=IDC_blkck6,button,1342242819
Control25=IDC_blkck7,button,1342242819
Control26=IDC_blkck8,button,1342242819
Control27=IDC_STATIC,static,1342308352
Control28=IDC_STATIC,static,1342308352
Control29=IDC_tbfaddr,edit,1350631552
Control30=IDC_STATIC,static,1342308352
Control31=IDC_tbfdata,edit,1350631552
Control32=IDC_ccfilter,button,1342242819
Control33=IDC_ccInvert,button,1342242819
Control34=IDC_STATIC,button,1342177287
Control35=IDC_fiterbank,combobox,1342242819
Control36=IDC_STATIC,button,1342177287
Control37=IDC_STATIC,button,1342177287
Control38=IDC_rbimpinjqtcmdtread,button,1342373897
Control39=IDC_rbimpinjqtcmdtwrite,button,1342242825
Control40=IDC_STATIC,button,1342177287
Control41=IDC_rbimpinjqtmemtpublic,button,1342373897
Control42=IDC_rbimpinjqtmemtprivate,button,1342242825
Control43=IDC_STATIC,button,1342177287
Control44=IDC_rbimpinjqtrangetnear,button,1342373897
Control45=IDC_rbimpinjqtrangetfar,button,1342242825
Control46=IDC_STATIC,button,1342308359
Control47=IDC_rbimpinjqtpersistperm,button,1342373897
Control48=IDC_rbimpinjqtpersisttemp,button,1342242825
Control49=IDC_btnsetimpinjqt,button,1342242816
Control50=IDC_STATIC,button,1342308359
Control51=IDC_ckperm1,button,1342242819
Control52=IDC_ckperm2,button,1342242819
Control53=IDC_ckperm3,button,1342242819
Control54=IDC_ckperm4,button,1342242819
Control55=IDC_ckperm5,button,1342242819
Control56=IDC_ckperm6,button,1342242819
Control57=IDC_ckperm7,button,1342242819
Control58=IDC_ckperm8,button,1342242819
Control59=IDC_STATIC,static,1342308352
Control60=IDC_tbstartblk,edit,1350631552
Control61=IDC_STATIC,static,1342308352
Control62=IDC_tbblkrange,edit,1350631552
Control63=IDC_btnpermlockget,button,1342242816
Control64=IDC_btnpermlockset,button,1342242816

[CLS:CCustomDlg]
Type=0
HeaderFile=CustomDlg.h
ImplementationFile=CustomDlg.cpp
BaseClass=CDialog
Filter=D
LastObject=CCustomDlg
VirtualFilter=dWC

[DLG:IDD_ISO180006BOPDLG_DIALOG]
Type=1
Class=ISO180006bOpDlg
ControlCount=16
Control1=IDC_ckant1,button,1342242819
Control2=IDC_ckant2,button,1342242819
Control3=IDC_ckant3,button,1342242819
Control4=IDC_ckant4,button,1342242819
Control5=IDC_listtag,listbox,1352728835
Control6=IDC_btnstart,button,1342242816
Control7=IDC_btnstop,button,1342242816
Control8=IDC_rtbdata,RICHEDIT,1350631428
Control9=IDC_STATIC,static,1342308352
Control10=IDC_tbstaddr,edit,1350631552
Control11=IDC_STATIC,static,1342308352
Control12=IDC_tbblks,edit,1350631552
Control13=IDC_btnread,button,1342242816
Control14=IDC_btnwrite,button,1342242816
Control15=IDC_btnlock,button,1342242816
Control16=IDC_btnclear,button,1342242816

[CLS:ISO180006bOpDlg]
Type=0
HeaderFile=ISO180006bOpDlg.h
ImplementationFile=ISO180006bOpDlg.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=ISO180006bOpDlg

[DLG:IDD_TESTGPIODLG_DIALOG]
Type=1
Class=TestGpioDlg
ControlCount=10
Control1=IDC_ckgpi1,button,1342242819
Control2=IDC_ckgpi2,button,1342242819
Control3=IDC_ckgpi3,button,1342242819
Control4=IDC_ckgpi4,button,1342242819
Control5=IDC_btngetgpi,button,1342242816
Control6=IDC_ckgpo1,button,1342242819
Control7=IDC_ckgpo2,button,1342242819
Control8=IDC_ckgpo3,button,1342242819
Control9=IDC_ckgpo4,button,1342242819
Control10=IDC_btnsetgpo,button,1342242816

[CLS:TestGpioDlg]
Type=0
HeaderFile=TestGpioDlg.h
ImplementationFile=TestGpioDlg.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=IDC_btngetgpi

[DLG:IDD_OTHERPARAMS_DIALOG]
Type=1
Class=OtherParams
ControlCount=121
Control1=IDC_btnsetqval,button,1342242816
Control2=IDC_STATIC,static,1342308352
Control3=IDC_btngetqval,button,1342242816
Control4=IDC_STATIC,button,1342177287
Control5=IDC_STATIC,button,1342177287
Control6=IDC_STATIC,static,1342308352
Control7=IDC_STATIC,static,1342308352
Control8=IDC_STATIC,static,1342308352
Control9=IDC_btnsetfilter,button,1342242816
Control10=IDC_btngetfilter,button,1342242816
Control11=IDC_STATIC,button,1342177287
Control12=IDC_btnsetemb,button,1342242816
Control13=IDC_btngetemb,button,1342242816
Control14=IDC_STATIC,static,1342308352
Control15=IDC_STATIC,static,1342308352
Control16=IDC_STATIC,static,1342308352
Control17=IDC_STATIC,static,1342308352
Control18=IDC_STATIC,static,1342308352
Control19=IDC_btnsetmval,button,1342242816
Control20=IDC_btngetmval,button,1342242816
Control21=IDC_EDITqval,edit,1350631552
Control22=IDC_EDITfbank,edit,1350631552
Control23=IDC_EDITfbitstart,edit,1350631552
Control24=IDC_EDITfmdata,edit,1350631552
Control25=IDC_EDITebank,edit,1350631552
Control26=IDC_EDITestart,edit,1350631552
Control27=IDC_EDITmbytescnt,edit,1350631552
Control28=IDC_EDITmpwd,edit,1350631552
Control29=IDC_cbchkant,combobox,1344340226
Control30=IDC_btnsetchk,button,1342242816
Control31=IDC_btngetchk,button,1342242816
Control32=IDC_STATIC,static,1342308352
Control33=IDC_EDITfmatch,edit,1350631552
Control34=IDC_btnresetfilter,button,1342242816
Control35=IDC_btnresetemb,button,1342242816
Control36=IDC_setRegion,button,1342242816
Control37=IDC_SelectRegion,combobox,1344340226
Control38=IDC_getRegion,button,1342242816
Control39=IDC_btngethtb,button,1342242816
Control40=IDC_listhtb,SysListView32,1350633489
Control41=IDC_btnsethtb,button,1342242816
Control42=IDC_STATIC,static,1342308352
Control43=IDC_tbgen2blf,edit,1350631552
Control44=IDC_btnsetgen2blf,button,1342242816
Control45=IDC_btngetgen2blf,button,1342242816
Control46=IDC_cbuniant,combobox,1344340227
Control47=IDC_STATIC,static,1342308352
Control48=IDC_btnuniantget,button,1342242816
Control49=IDC_btnuniantset,button,1342242816
Control50=IDC_STATIC,static,1342308352
Control51=IDC_cbuniemd,combobox,1344340227
Control52=IDC_btnuniemdget,button,1342242816
Control53=IDC_btnuniemdset,button,1342242816
Control54=IDC_STATIC,static,1342308352
Control55=IDC_cbrechrssi,combobox,1344340227
Control56=IDC_btnrechrssiget,button,1342242816
Control57=IDC_btnrechrssiset,button,1342242816
Control58=IDC_STATIC,static,1342308352
Control59=IDC_btngen2tariget,button,1342242816
Control60=IDC_btngen2tariset,button,1342242816
Control61=IDC_STATIC,static,1342308352
Control62=IDC_cbgen2target,combobox,1344340227
Control63=IDC_btngen2targetget,button,1342242816
Control64=IDC_btngen2targetset,button,1342242816
Control65=IDC_STATIC,static,1342308352
Control66=IDC_tbhoptime,edit,1350631552
Control67=IDC_btnhoptimeget,button,1342242816
Control68=IDC_btnhoptimeset,button,1342242816
Control69=IDC_STATIC,static,1342308352
Control70=IDC_btnlbtenbleget,button,1342242816
Control71=IDC_btnlbtenbleset,button,1342242816
Control72=IDC_cbgen2tari,combobox,1344340227
Control73=IDC_cblbtenable,combobox,1344340227
Control74=IDC_STATIC,static,1342308352
Control75=IDC_cbgen2wmode,combobox,1344340227
Control76=IDC_btngen2wmodeget,button,1342242816
Control77=IDC_btngen2wmodeset,button,1342242816
Control78=IDC_cbgen2enc,combobox,1344340227
Control79=IDC_STATIC,static,1342308352
Control80=IDC_tb6bblf,edit,1350631552
Control81=IDC_btn6bblfget,button,1342242816
Control82=IDC_btn6bblfset,button,1342242816
Control83=IDC_STATIC,button,1342177287
Control84=IDC_btnflashwrite,button,1342242816
Control85=IDC_STATIC,static,1342308352
Control86=IDC_STATIC,static,1342308352
Control87=IDC_tbflashwrtieaddr,edit,1350631552
Control88=IDC_tbflashwrtiedata,edit,1350631552
Control89=IDC_STATIC,button,1342177287
Control90=IDC_STATIC,static,1342308352
Control91=IDC_cbpwdtype,combobox,1344339971
Control92=IDC_STATIC,static,1342308352
Control93=IDC_cbtagtype,combobox,1344340227
Control94=IDC_STATIC,static,1342308352
Control95=IDC_tbsrbank,edit,1350631552
Control96=IDC_STATIC,static,1342308352
Control97=IDC_tbsraddress,edit,1350631552
Control98=IDC_STATIC,static,1342308352
Control99=IDC_tbsrblks,edit,1350631552
Control100=IDC_STATIC,static,1342308352
Control101=IDC_tbindexbitnum,edit,1350631552
Control102=IDC_STATIC,static,1342308352
Control103=IDC_tbindexbitaddr,edit,1350631552
Control104=IDC_STATIC,static,1342308352
Control105=IDC_tbsracspwd,edit,1350631552
Control106=IDC_btngetsecureread,button,1342242816
Control107=IDC_btnsetsecureread,button,1342242816
Control108=IDC_btnresetsr,button,1342242816
Control109=IDC_STATIC,static,1342308352
Control110=IDC_cbtransmitmode,combobox,1344339971
Control111=IDC_btngettransmitmod,button,1342242816
Control112=IDC_btnsettransmitmod2,button,1342242816
Control113=IDC_STATIC,static,1342308352
Control114=IDC_cbpowersave,combobox,1344339971
Control115=IDC_btngetpowersavemode,button,1342242816
Control116=IDC_btnsetpowersavemode,button,1342242816
Control117=IDC_Cbbinvmode,combobox,1344339971
Control118=IDC_STATIC,static,1342308352
Control119=IDC_btnsetinvmode,button,1342242816
Control120=IDC_btngetinvmode,button,1342242816
Control121=IDC_BUTTON_savesettings,button,1342242816

[CLS:OtherParams]
Type=0
HeaderFile=OtherParams.h
ImplementationFile=OtherParams.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=IDC_Cbbinvmode

[DLG:IDD_ARM7_16ANTSETDLG_DIALOG]
Type=1
Class=Arm7_16AntSetDlg
ControlCount=22
Control1=IDC_ckant1,button,1342242819
Control2=IDC_ckant2,button,1342242819
Control3=IDC_ckant3,button,1342242819
Control4=IDC_ckant4,button,1342242819
Control5=IDC_ckant5,button,1342242819
Control6=IDC_ckant6,button,1342242819
Control7=IDC_ckant7,button,1342242819
Control8=IDC_ckant8,button,1342242819
Control9=IDC_ckant9,button,1342242819
Control10=IDC_ckant10,button,1342242819
Control11=IDC_ckant11,button,1342242819
Control12=IDC_ckant12,button,1342242819
Control13=IDC_ckant13,button,1342242819
Control14=IDC_ckant14,button,1342242819
Control15=IDC_ckant15,button,1342242819
Control16=IDC_ckant16,button,1342242819
Control17=IDC_btnok,button,1342242816
Control18=IDC_STATIC,static,1342308352
Control19=IDC_tbreadpwr,edit,1350631552
Control20=IDC_STATIC,static,1342308352
Control21=IDC_writepwr,edit,1350631552
Control22=IDC_btnset,button,1342242816

[CLS:Arm7_16AntSetDlg]
Type=0
HeaderFile=Arm7_16AntSetDlg.h
ImplementationFile=Arm7_16AntSetDlg.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=Arm7_16AntSetDlg

