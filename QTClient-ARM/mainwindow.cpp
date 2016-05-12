#include "mainwindow.h"
#include"loading.h"
#include "ui_mainwindow.h"
#include <QMessageBox>
#include <QString>
#include <QByteArray>
#include <QTextDecoder>
#include <QtScript/QtScript>
#include<QNetworkRequest>
#include<QNetworkReply>
#include<QDebug>
#include<QComboBox>
#include <QTableWidget>
#include <QMap>
#include <gybutton.h>
#include<QtWebKit/QWebView>
#include <mycombox.h>
#include <borrowandreback.h>\
#include <QTimer>
MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
LightFlashCnt =0;
FirstInit = true;
FlashIsShowing   = false;
    ui->setupUi(this);
    HandlerURL = QString(WEB_URL) + "/AJAX/handler.ashx";

     ui->tableWidget->setColumnCount(6);
     ui->tableWidget->setHorizontalHeaderLabels(QStringList()<<QString("工具名")<<QString("件号")<<QString("可替代(最终选择)")<<QString("实际状态")<<QString("查看工具箱")<<QString("操作"));
     ui->tableWidget->setColumnWidth(ToolNameCOL,200);
     ui->tableWidget->setColumnWidth(ToolID,100);
     ui->tableWidget->setColumnWidth(ALTER,200);
     ui->tableWidget->setColumnWidth(REALSTATE,110);
     ui->tableWidget->setColumnWidth(LOOK,110);
     ui->tableWidget->setColumnWidth(OP,100);
     ui->tableWidget->setEditTriggers(QAbstractItemView::NoEditTriggers);
      ui->tableWidget->setSelectionMode(QAbstractItemView::SingleSelection);
      ui->tableWidget->setAlternatingRowColors(1);
      tbMap = NULL;
      brWin = new BorrowAndReBack();

    QPixmap pixmap("/home/img/logo.png");
    ui->label->setPixmap(pixmap);
    ui->label->show();
    ui->label->setScaledContents(true);

    lighttmr = new QTimer(this);
    connect(lighttmr,SIGNAL(timeout()),this,SLOT(LightFlash()));

   // Tmr = new QTimer(this);
    //connect( Tmr,SIGNAL(timeout()), this, SLOT(TmrOut()) );
   // Tmr->start(1000);
    skt_finger = new gyTcpSocket(this);
    skt_finger->devName = "指纹仪";
    skt_finger->devPort = 7900;
    skt_rfid = new gyTcpSocket(this);
    skt_rfid->devName = "RFID扫描仪";
    skt_rfid->devPort = 7901;
    skt_gpy = new gyTcpSocket(this);
    skt_gpy->devName = "高拍仪";
    skt_gpy->devPort = 7902;
    skt_light = new gyTcpSocket(this);
    skt_light->devName = "亮灯后台";
    skt_light->devPort = 7903;

    connect(skt_finger,SIGNAL(connected()),this,SLOT(finger_Srv_Connect()));
    connect(skt_finger,SIGNAL(disconnected()),this,SLOT(finger_Srv_disConnected()));
    connect(skt_finger,SIGNAL(readyRead()),this,SLOT(finger_ReadReady()));
    connect(skt_finger,SIGNAL(error(QAbstractSocket::SocketError)),this,SLOT(finger_error(QAbstractSocket::SocketError)));

    connect(skt_rfid,SIGNAL(connected()),this,SLOT(rfid_Srv_Connect()));
    connect(skt_rfid,SIGNAL(disconnected()),this,SLOT(rfid_Srv_disConnected()));
    connect(skt_rfid,SIGNAL(error(QAbstractSocket::SocketError)),this,SLOT(rfid_error(QAbstractSocket::SocketError)));

    connect(skt_gpy,SIGNAL(connected()),this,SLOT(gpy_Srv_Connect()));
    connect(skt_gpy,SIGNAL(disconnected()),this,SLOT(gpy_Srv_disConnected()));
    connect(skt_gpy,SIGNAL(error(QAbstractSocket::SocketError)),this,SLOT(gpy_error(QAbstractSocket::SocketError)));

    connect(skt_light,SIGNAL(connected()),this,SLOT(light_Srv_Connect()));
    connect(skt_light,SIGNAL(disconnected()),this,SLOT(light_Srv_disConnected()));
    connect(skt_light,SIGNAL(error(QAbstractSocket::SocketError)),this,SLOT(light_error(QAbstractSocket::SocketError)));


    connect(this,SIGNAL(Srv_Connect_msg(gyTcpSocket *)),this,SLOT(Srv_Connect(gyTcpSocket *)));
    connect(this,SIGNAL(Srv_disConnected_msg(gyTcpSocket *)),this,SLOT(Srv_disConnected(gyTcpSocket *)));
    connect(this,SIGNAL(ReadReady_msg(gyTcpSocket *)),this,SLOT(ReadReady(gyTcpSocket *skt)));
    connect(this,SIGNAL(error_msg(gyTcpSocket*,QAbstractSocket::SocketError)),this,SLOT(error(gyTcpSocket*,QAbstractSocket::SocketError)));

    //skt_finger->connectToHost("192.168.1.101",7900);
    //skt_finger->readAll();
    //SendCmd(skt_finger,"{\"cmd\":\"activeME\"}");
   // connect(skt_finger,SIGNAL(readyRead()),this,SLOT(finger_ReadReady()));


    //connect(skt_rfid,SIGNAL(readyRead()),this,SLOT(finger_ReadReady()));//RFID不需要其主动发信号过来
    flash = new Welcome(this);
    loadingWin = new Loading(this);

   CurTaskID="";
  // this->hide();
   //flash->exec();
  // flash->setModal(true);
 //  flash->show();
  // flash->exec();
    //ShowLoading("等待用户指纹....");
    //loadingWin
   // this->show();
  skt_finger->devAddr = GetHttpCmdContentByParam("{\"cmd\":\"devGetInfo\",\"type\":\"fingeraddr\"}","info");
  skt_rfid->devAddr = GetHttpCmdContentByParam("{\"cmd\":\"devGetInfo\",\"type\":\"rfidaddr\"}","info");
  skt_gpy->devAddr = GetHttpCmdContentByParam("{\"cmd\":\"devGetInfo\",\"type\":\"gpyaddr\"}","info");
  skt_light->devAddr = GetHttpCmdContentByParam("{\"cmd\":\"devGetInfo\",\"type\":\"lightaddr\"}","info");
  qDebug()<<"skt:"+skt_finger->devAddr;
  qDebug()<<"gpy:"+skt_gpy->devAddr;
  qDebug()<<"rfid:"+skt_rfid->devAddr;
    QString s="";
  if (skt_gpy->devAddr=="")
  {
        s+=" 高拍仪";
  }else if (skt_rfid->devAddr==""){
        s+=" RFID扫描器";
  }else if (skt_finger->devAddr=="")
  {
         s+=" 指纹仪器";
  }else if (skt_light->devAddr=="")
  {
       s+= " 亮灯后台 ";
  }
  if (s!=""){
    QMessageBox::information(this,"提示","无法获取"+s+"的IP地址，程序将退出!");
    QCoreApplication::exit();
  }
  ShowLoading("连接RFID扫描器....");
  skt_rfid->gyConnect();
    if (!skt_rfid->waitForConnected(10000))
    {
        QMessageBox::information(this,"提示","无法连接RFID扫描器的服务程序，程序将退出!");
          exit(-1);
    }

  ShowLoading("连接高拍仪....");
  skt_gpy->gyConnect();
  if (!skt_rfid->waitForConnected(10000))
  {
      QMessageBox::information(this,"提示","无法连接高拍仪的服务程序，程序将退出!");
    exit(-1);
  }

 ShowLoading("连接指纹仪....");
  skt_finger->gyConnect();
  if (!skt_finger->waitForConnected(10000))
  {
      QMessageBox::information(this,"提示","无法连接指纹仪器的服务程序，程序将退出!");
      exit(-1);
  }

  ShowLoading("连接亮灯后台....");
   skt_light->gyConnect();
   if (!skt_light->waitForConnected(10000))
   {
       QMessageBox::information(this,"提示","无法连接指亮灯后台的服务程序，程序将退出!");
       exit(-1);
   }
curRes = NULL;
   CloseLoading();
this->hide();
   FlashIsShowing = true;
flash->showFullScreen();
flash->exec();

}
//void MainWindow::TmrOut()
//{
 // Tmr->stop();
//}
void MainWindow::on_pushButton_clicked()
{

    QString userid = "24",txt;
    ShowLoading("加载用户信息....");

    txt = FillNameAndCorp(userid);
    if (txt != "OK"){//加载用户信息错误
       QMessageBox::information(0,"错误",txt);
       CloseLoading();
       return;
    }

    ShowLoading("加载用户任务列表....");
    txt = FillTaskList(userid);
    if (txt != "OK"){//加载用户信息错误
       QMessageBox::information(0,"错误",txt);
        CloseLoading();
       return;
    }
 CloseLoading();
}
void MainWindow::CloseLoading()
{
    loadingWin->close();
}

void MainWindow::ShowLoading(QString msg)
{
    loadingWin->setModal(true);
    loadingWin->setTitle(msg);
    loadingWin->show();
    //loadingWin->exec();
}
void MainWindow::DealJsonDat(QString jsonDat)
{

}
QString MainWindow::GetHttpCmdContentByParam(QString Cmd,QString param)
{
        QString Ret = httpSendCmd(Cmd);
        QScriptEngine engine;
        QScriptValue sc = engine.evaluate("("+Ret+")");
        return sc.property(param).toString();
}
QString MainWindow::httpSendCmd(QString Cmd)
{
    return httpsPostHelp(HandlerURL,Cmd);
}
const int TIMEOUT = (30 * 1000);
QString MainWindow::httpsPostHelp(const QString &url, const QString &data)
{
    QString _result;
    QNetworkRequest _request;
    QNetworkAccessManager * m_pNetworkManager = new QNetworkAccessManager(this);
    addMeToRes(m_pNetworkManager);
    _request.setUrl(QUrl(url));
    _request.setHeader(QNetworkRequest::ContentTypeHeader,
                       QString("application/x-www-form-urlencoded"));

    QNetworkReply *_reply = m_pNetworkManager->post(_request, data.toLatin1());
    _reply->ignoreSslErrors();


    QTime _t;
    _t.start();

    bool _timeout = false;

    while (!_reply->isFinished()) {
        QApplication::processEvents();
        if (_t.elapsed() >= TIMEOUT) {
            _timeout = true;
            break;
        }
    }

    if (!_timeout && _reply->error() == QNetworkReply::NoError) {
        _result = _reply->readAll();
    }else{
        return "";
    }

    _reply->deleteLater();

    return _result;

}

QString * MainWindow::ReadMsg(gyTcpSocket *skt)
{
    QTextCodec *codec = QTextCodec::codecForName("UTF8");
    QTextDecoder *decoder = codec->makeDecoder();
    QByteArray datagram;
    QString *s= new QString("");
    addMeToRes(s);
    qDebug("收到%d字节消息",skt->bytesAvailable());
    datagram.resize(skt->bytesAvailable());

    skt->read(datagram.data(),datagram.size());
    *s = decoder->toUnicode(datagram.data());

    qDebug(s->toAscii().data());
    return s;
}
QString* MainWindow::SendCmd(gyTcpSocket *skt, char * Cmd)
{
     qint64 len = 0,size = strlen (Cmd) + 1,t;
     //发信号之前断开
     QString *s= new QString("");
     addMeToRes(s);
      if (skt->ConnectedState != QAbstractSocket::ConnectedState || sizeof(Cmd)==0){
            return (new QString(""));
      }
      qDebug("要发送命令->%s\n",Cmd);
      qDebug("进入waitForBytesWritten %d\n",skt->bytesAvailable());
        skt->waitForBytesWritten();
      do{
            t  =  skt->write(Cmd+len,size-len);
            len += t;
      }while(t!=-1&&len<size);

     qDebug("SendCmd-->waitForReadyRead");
      skt->waitForReadyRead();

     len =   0;

    QTextCodec *codec = QTextCodec::codecForName("UTF8");
    QTextDecoder *decoder = codec->makeDecoder();
    QByteArray datagram;
    qDebug("收到->%d",skt->bytesAvailable());
    datagram.resize(skt->bytesAvailable());

    skt->read(datagram.data(),datagram.size());
    *s = decoder->toUnicode(datagram.data());

    qDebug(s->toAscii().data());
    return s;
}
void MainWindow::finger_Srv_Connect()
{
    emit Srv_Connect_msg(skt_finger);
}
void MainWindow::rfid_Srv_Connect()
{
    emit Srv_Connect_msg(skt_rfid);
}
void MainWindow::finger_Srv_disConnected()
{
      emit Srv_disConnected_msg(skt_finger);
}
void MainWindow::rfid_Srv_disConnected()
{
      emit Srv_disConnected_msg(skt_rfid);
}
void MainWindow::gpy_error(QAbstractSocket::SocketError socketError)
{
    emit error_msg(skt_gpy,socketError);
}
void MainWindow::gpy_Srv_Connect()
{
    emit Srv_Connect_msg(skt_gpy);
}
void MainWindow::gpy_Srv_disConnected()
{
     emit Srv_disConnected_msg(skt_gpy);
}
void MainWindow::light_Srv_Connect()
{
    emit Srv_Connect_msg(skt_light);
}
void MainWindow::light_Srv_disConnected()
{
     emit Srv_disConnected_msg(skt_light);
}
void MainWindow::finger_ReadReady()
{
     emit ReadReady(skt_finger);
}
 void	MainWindow::finger_error (QAbstractSocket::SocketError socketError )
 {
        emit error_msg(skt_finger,socketError);
 }
 void	MainWindow::rfid_error (QAbstractSocket::SocketError socketError )
 {
        emit error_msg(skt_rfid,socketError);
 }
 void	MainWindow::light_error (QAbstractSocket::SocketError socketError )
 {
        emit error_msg(skt_light,socketError);
 }
 void MainWindow::Srv_Connect(gyTcpSocket * skt)
 {
    qDebug()<<skt->devName<<"连接成功!";
     skt->readAll();
     SendCmd(skt,"{\"cmd\":\"activeME\"}");
     if(FirstInit&&skt==skt_light)
     {
         qDebug()<<"lighttmr start!!!!";
               lighttmr->start(1000);
     }
 }
void MainWindow::addMeToRes(void * Res)
{
            resList * t = new resList();
            t->data = Res;
            t->next = curRes;
            curRes = t;
}
void MainWindow::deleteAllRes()
{
        resList  * t = curRes;

        while(curRes!=NULL)
        {
                   t = curRes;
                   curRes = curRes->next;
                   delete t->data;
                   delete t;
         }
}
 void MainWindow::Srv_disConnected(gyTcpSocket * skt)
 {
     qDebug()<<skt->devName<<"连接断开,开始重连";
     skt->connectToHost(skt->devAddr,skt->devPort);
 }
QString MainWindow::FillTaskList(QString userid)
{
    QString cmdtxt = "{\"cmd\":\"GetBorwTaskListBytUserID\",\"userid\":\"" + userid + "\"}";
    QString cmdret =  httpSendCmd(cmdtxt);
    QScriptEngine engine;
    QScriptValue sc = engine.evaluate("("+cmdret+")");
    //qDebug("-->%s",cmdtxt);
    ui->treeWidget->clear();
    ui->treeWidget->setColumnCount(1);
    ui->treeWidget->setHeaderLabels(QStringList()<<"任务列表");
    //ui->tableWidget->clear();
    //ui->tableWidget->setRowCount(0);
    ui->tableWidget->clearContents();
    ui->tableWidget->setRowCount(0);
    if (sc.property("status").toString() !="success"){

    }

    QTreeWidgetItem * root=new QTreeWidgetItem(QStringList()<<"TaskList");
    root->setData(0,Qt::UserRole,"root");
    addMeToRes(root);
    QScriptValueIterator it(sc.property("tasklist"));
    while (it.hasNext())
    {
        it.next();
       if(!it.value().property("showname").toString().isEmpty()){
           //qDebug() << it.value().property("a").toString();
            QTreeWidgetItem * chd=new QTreeWidgetItem( QStringList()<<it.value().property("showname").toString());
            addMeToRes(chd);
            chd->setData(0,Qt::UserRole,it.value().property("taskid").toString());
            root->addChild(chd);
       }

    }
    ui->treeWidget->addTopLevelItem(root);QPushButton *btn =  new QPushButton();

    btn->setText("OK");
 ui->treeWidget->expandAll();

    return "OK";

}
QString MainWindow::FillNameAndCorp(QString userid)
 {
     QString cmdtxt = "{\"cmd\":\"GetUserInfoByID\",\"userid\":\"" + userid + "\"}";
     QString cmdret =  httpSendCmd(cmdtxt);
     QScriptEngine engine;
     QScriptValue sc = engine.evaluate("("+cmdret+")");

     if(sc.property("status").toString()=="" || sc.property("status").toString()=="failed")
     {
         return "失败" + sc.property("msg").toString();
     }

     gUserID = userid;
     gUserName  =sc.property("name").toString();
     ui->uName->setText( "<html><head/><body><p><span style=\" font-size:14pt; color:#3c23ff;\">"+sc.property("name").toString()+"</span></p></body></html>");
     ui->uCorp->setText("<html><head/><body><p><span style=\" font-size:14pt; color:#3c23ff;\">"+sc.property("corpname").toString()+"</span></p></body></html>");

     //qDebug("%s\n",cmdret);
    return "OK";
 }
void MainWindow::look_tool_slot(int i)
{
   myComBox *box =  (myComBox*)ui->tableWidget->cellWidget(i,ALTER);

   if(box->get_coreid()=="")
   {
       QMessageBox::information(0,"提示","请在下拉框中选择你要查看的工具!" );
       return;
   }


 //QMessageBox::information(0,"提示","http://192.168.1.101/ToolBag.aspx?Type=2&BagID=" + box->get_coreid());
        QWebView *view =  new QWebView();

        view->load(QUrl( QString(WEB_URL) + "/ToolBag.aspx?Type=2&BagID=" + box->get_coreid()));
        view->showMaximized();


}
QString MainWindow::GetBorrowInfoByTaskID(QString TaskID)
{
    /*
#define ToolName          0
#define ToolID                1
#define ALTER                 2
#define LOOK                 3
#define OP                      4
   */

    if (TaskID=="")return "failed";

    QString cmdtext = "{\"cmd\":\"LightCtl\",\"lighton\":\"false\",\"posx\":\"0\",\"posy\":\"0\"}";
   SendCmd(skt_light,(cmdtext.toLatin1()).data());
    light_map.clear();

    QString cmdtxt = "{\"cmd\":\"GetBorrowInfoByTaskID\",\"taskid\":\"" + TaskID + "\"}",AppState="0";
    QString cmdret =  httpSendCmd(cmdtxt);
    QScriptEngine engine;
    QScriptValue sc = engine.evaluate("("+cmdret+")"),sc1;
    QTableWidget *tb = ui->tableWidget;
    int min_pvCount = 0,min_pvCount_index=0;

    if(sc.property("status").toString()=="" || sc.property("status").toString()=="failed")
    {
        return "失败" + sc.property("msg").toString();
    }

  tb->clearContents();
  tb->setRowCount(0);
    QScriptValueIterator it(sc.property("data"));

    while (it.hasNext())
    {
        it.next();
       if(!it.value().property("toolname").toString().isEmpty()){
           int index = tb->rowCount();
           tb->insertRow(index);
           QTableWidgetItem *item;
           item = new QTableWidgetItem(it.value().property("toolname").toString());
           addMeToRes(item);
           tb->setItem(index,ToolNameCOL,item);
            item = new QTableWidgetItem(it.value().property("toolid").toString());
            addMeToRes(item);
           tb->setItem(index,ToolID,item);
           gyButton *lkbtn =  new gyButton(index);
           addMeToRes(lkbtn);
           lkbtn->setText("工具查看");

           connect(lkbtn,SIGNAL(clicked()),lkbtn,SLOT(Borowse_Clicked_slot()));
           connect(lkbtn,SIGNAL(BorowseClicked(int)),this,SLOT(look_tool_slot(int )));

            tb->setCellWidget(index,LOOK,lkbtn);

            AppState = it.value().property("appstate").toString();
            gyButton *btn =  new gyButton(index);
            addMeToRes(btn);
            btn->AppState = AppState.toInt();
            btn->ToolAppID = it.value().property("appid").toInt32();
            tb->setCellWidget(index,OP,btn);

            connect(btn,SIGNAL(clicked()),btn,SLOT(Borrow_Clicked_slot()));
            connect(btn,SIGNAL(BorrowClicked(gyButton*)),this,SLOT(borrow_tool_click_slot(gyButton* )));
            myComBox *pComboBox = new myComBox();
            addMeToRes(pComboBox);
            pComboBox->addItem("");
            if(AppState == "0")//已提交
            {
                            sc1 = engine.evaluate("("+it.value().property("liketools").toString()+")");

                           QScriptValueIterator alter(sc1);
                           min_pvCount = 999999999;
                           min_pvCount_index = 0;

                           while(alter.hasNext()){

                                    alter.next();
                                   if(!alter.value().property("toolid").toString().isEmpty()){
                                            pComboBox->addItem(alter.value().property("toolid").toString());
                                            pComboBox->insert_coreid(pComboBox->count()-1,alter.value().property("toolname").toString(),alter.value().property("coreid").toString());
                                          //  qDebug()<<pComboBox->currentIndex()<<alter.value().property("coreid").toString();
                                            }
                          }

                        connect(pComboBox,SIGNAL(CBoxChange_Signal(QString,myComBox*)),this,SLOT(ComBoxItemChange(QString,myComBox*)));
                        pComboBox->curindex = tb->rowCount()-1;
                       qDebug()<<"index-->"<<min_pvCount_index;
                       ///pComboBox->setCurrentIndex(min_pvCount_index);
                        btn->setText("借出");

             }else if (AppState=="1")//已借出待归还
            {
                        btn->setText("归还");

                        pComboBox->addItem(it.value().property("borrowedtoolid").toString());
                        pComboBox->insert_coreid(pComboBox->count()-1,it.value().property("borrowedtoolname").toString(),it.value().property("borrowedtoolcoreid").toString());
                         pComboBox->setCurrentIndex(0);
                         item = new QTableWidgetItem(it.value().property("borrowedtoolname").toString());
                         addMeToRes(item);
                        tb->setItem(index,ToolNameCOL,item);
                        QTableWidgetItem *im = new QTableWidgetItem(it.value().property("borrowedtoolid").toString());
                        addMeToRes(im);
                        im->setBackgroundColor(QColor(255,0,0));
                        tb->setItem(index,ToolID,im);

            }else{//已归还
                        btn->hide();
                        btn->setText("已归还");
                        pComboBox->addItem(it.value().property("borrowedtoolid").toString());
                        QTableWidgetItem *im = new QTableWidgetItem(it.value().property("borrowedtoolid").toString());
                        addMeToRes(im);
                        im->setBackgroundColor(QColor(0,255,0));
                         tb->setItem(index,ToolID,im);
            }


            tb->setCellWidget(index, ALTER, pComboBox );
      }

    }
   return  "OK";
}
void MainWindow::LightFlash()
{
         if (FirstInit&&LightFlashCnt<8)
         {
             QString cmdtxt  = "{\"cmd\":\"LightCtl\",\"lighton\":\""+QString((LightFlashCnt%2)==0?"true":"false")+"\",\"posx\":\"0\",\"posy\":\"0\"}";
              SendCmd(skt_light,(cmdtxt.toLatin1()).data());
                    LightFlashCnt++;
         }else{
             FirstInit = false;
             lighttmr->stop();
         }
}
void MainWindow::ComBoxItemChange(QString toolid,myComBox * box)
{
    QString cmdtxt = "{\"cmd\":\"GetToolPos\",\"toolid\":\"" + toolid + "\"}";
    QString cmdret =  httpSendCmd(cmdtxt);
    QScriptEngine engine;
    QScriptValue sc = engine.evaluate("("+cmdret+")");
    QString PosX,PosY;
   // QMessageBox::information(this,"提示",cmdret);
    if(sc.property("status").toString()!="success")
    {
       // QMessageBox::information(this,"提示","获取工具实时位置失败!");
        return;
    }else{

    }

    PosX = sc.property("posx").toString();
    PosY = sc.property("posy").toString();


    QTableWidgetItem *im = new QTableWidgetItem(PosX+"号"+PosY+"层");
    addMeToRes(im);
    if (sc.property("realstate").toString()!="5"){
                 im->setBackgroundColor(QColor(255,0,0));
    }
    if (PosX!="X")
    {
              QString MapKey = QString ("%1%2").arg(PosX.toInt(),-3,10,QChar('0')).arg(PosY.toInt(),-3,10,QChar('0'));
              if (light_map.contains(MapKey)){
                    light_map[MapKey]++;
                    qDebug()<<"old light found (" + PosX + "," + PosY +")";
              }else{
                    light_map[MapKey]= 1;
                     QString cmdtxt  = "{\"cmd\":\"LightCtl\",\"lighton\":\"true\",\"posx\":\"" +PosX + "\",\"posy\":\""+PosY+"\"}";
                      QString *sRet =  SendCmd(skt_light,(cmdtxt.toLatin1()).data());
                      qDebug()<<"new light  (" + PosX + "," + PosY +")-->"<<*sRet;
              }
    }
    if (box->LastLightPosX!="")//此处要记住解决用户点击其他任务时，上个任务的灯遗留问题
    {
        QString MapKey = QString ("%1%2").arg( box->LastLightPosX .toInt(),-3,10,QChar('0')).arg( box->LastLightPosY.toInt(),-3,10,QChar('0'));
        if(light_map.contains(MapKey))
        {
            if(light_map[MapKey]==1){
                QString cmdtext = "{\"cmd\":\"LightCtl\",\"lighton\":\"false\",\"posx\":\"" + box->LastLightPosX + "\",\"posy\":\""+box->LastLightPosY+"\"}";
                QString *sRet =  SendCmd(skt_light,(cmdtext.toLatin1()).data());
                 qDebug()<<"close light  (" + box->LastLightPosX  + "," + box->LastLightPosY +")-->"<<*sRet;
                 light_map.remove(MapKey);
            }else{
                light_map[MapKey]--;
            }
        }

    }
    box->LastLightPosX = PosX;
    box->LastLightPosY = PosY;
    ui->tableWidget->setItem(box->curindex,REALSTATE,im);

}
void MainWindow::borrow_tool_click_slot(gyButton * btn)
{
    myComBox *box =  (myComBox*)ui->tableWidget->cellWidget(btn->index,ALTER);

    if (btn->text()=="已归还")
    {
        QMessageBox::information(0,"提示","该工具已经归还!" );
        return;
    }

    if(box->currentText()=="")
    {
        QMessageBox::information(0,"提示","请在下拉框中选择你要借用的工具!" );
        return;
    }
    qDebug()<< "工具编号:"<<box->currentText();
    brWin->sToolID = box->currentText();
    qDebug()<< "工具名称:"<<box->get_toolname();
    brWin->sToolName  = box->get_toolname();
    brWin->skt_rfid = skt_rfid;
    brWin->skt_gpy = skt_gpy;
    brWin->AppID = btn->ToolAppID;
    brWin->UserID = gUserID;
    brWin->UserName = gUserName;

    if (btn->AppState==0)
    {
            brWin->Borrow = true;//借
    }else if(btn->AppState==1)
    {
            brWin->Borrow = false;//还
    }else{
        //不会到这这里，因为appstate==2时,按钮被隐藏
    }
//brWin->setModal(true);

brWin->show();
brWin->exec();
GetBorrowInfoByTaskID(CurTaskID);
}
void MainWindow::DealMsg(QString *Msg)
{
    QScriptEngine engine;
    QScriptValue sc = engine.evaluate("("+*Msg+")");
    QString type =  sc.property("type").toString();
    QString txt;
    //qDebug("消息类型-->%s\n",sc.property("type").toString());

    if (type == "UserCapture")
    {
       // qDebug()<<"type-->"<<sc.property("type").toString();
        if(sc.property("userid").toString() != "null" )
        {
            //QString cmdtxt = "{\"cmd\":\"GetUserInfoByID\",\"userid\":\"" + sc.property("userid").toString() + "\"}";
            //qDebug("%s\n",cmdtxt);
            flash->close();
            FlashIsShowing = false;
            ShowLoading("加载用户信息....");

            txt = FillNameAndCorp(sc.property("userid").toString());
            if (txt != "OK"){//加载用户信息错误
               QMessageBox::information(0,"错误",txt);
               return;
            }

            ShowLoading("加载用户任务列表....");
            txt = FillTaskList(sc.property("userid").toString());
            if (txt != "OK"){//加载用户信息错误
               QMessageBox::information(0,"错误",txt);
               return;
            }

            CloseLoading();


           // disconnect(skt_finger,SIGNAL(readyRead()),this,SLOT(finger_ReadReady()));
            this->showFullScreen();

            SendCmd(skt_finger,"{\"cmd\":\"DeactiveME\"}");
        }
         //
    }


    //if()
}
 void MainWindow::ReadReady(gyTcpSocket *skt)
 {
       qDebug("finger_ReadReady");
       QString *Msg = ReadMsg(skt);
       if (*Msg=="" || Msg->isEmpty()){
           QMessageBox::information(0,"提示",skt->devName + "发来空消息。");
       }else{
           DealMsg(Msg);
       }
 }

  void	MainWindow::error(gyTcpSocket *skt ,QAbstractSocket::SocketError socketError )
  {
                qDebug()<<skt->devName<<"Error:"+socketError;

RE:
                if (skt->ReConnectCount>100)
                {
                    QMessageBox::warning(NULL,"错误",skt->devName + "发生错误:" + socketError+",重连100次均失败,程序将退出!");
                    exit(-1);
                }
                 skt->ReConnectCount++;
                QMessageBox::warning(NULL,"错误",skt->devName + "发生错误:" + socketError+",第"+skt->ReConnectCount+"次重连(10s)，共100次。");
                ShowLoading(skt->devName+" 重连中.....");
                skt->disconnectFromHost();
                skt->gyConnect();
                if(skt->waitForConnected(10000))
                {
                    if (skt==skt_finger && !FlashIsShowing)
                    {

                    }else
                    {
                        SendCmd(skt,"{\"cmd\":\"activeME\"}");
                    }
                    CloseLoading();
                     QMessageBox::information(NULL,"提示",skt->devName + "重新连接成功!");
                }else//重新连接失败
                {

                               goto RE;
                }

  }
MainWindow::~MainWindow()
{
    delete ui;
}


void MainWindow::on_MainWindow_destroyed(QObject *arg1)
{
    //this->destroy();
}

void MainWindow::on_treeWidget_itemClicked(QTreeWidgetItem *item, int column)
{
    if (item->data(0,Qt::UserRole).toString()!="root")
    {
        CurTaskID = item->data(0,Qt::UserRole).toString();
       GetBorrowInfoByTaskID(CurTaskID);
    }
}

void MainWindow::on_pushButton_2_clicked()
{
    QString cmdtxt = "{\"cmd\":\"LinuxTest\",\"name\":\"李光耀\"}";
    QString cmdret =  httpSendCmd(cmdtxt);
    QMessageBox::information(this,"结果",cmdret);
}

void MainWindow::on_pushButton_3_clicked()
{
        SendCmd(skt_finger,"{\"cmd\":\"activeME\"}");
        QString cmdtext = "{\"cmd\":\"LightCtl\",\"lighton\":\"false\",\"posx\":\"0\",\"posy\":\"0\"}";
       SendCmd(skt_light,(cmdtext.toLatin1()).data());
        light_map.clear();

        //deleteAllRes();
        this->hide();
        flash->showFullScreen();
}
