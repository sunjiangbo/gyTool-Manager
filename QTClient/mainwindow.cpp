#include "mainwindow.h"
#include"loading.h"
#include "ui_mainwindow.h"
#include <QtNetwork/QTcpSocket>
#include<QtNetwork/QHostAddress>
#include <QMessageBox>
#include <QString>
#include <QByteArray>
#include <QTextDecoder>
#include <QtScript>
#include<QNetworkRequest>
#include<QNetworkReply>
#include<QDebug>
#include<QComboBox>
#include <QTableWidget>
#include <QMap>
#include <gybutton.h>
#include<QWebView>
#include <mycombox.h>
#include <borrowandreback.h>
MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{


    ui->setupUi(this);
    HandlerURL = QString(WEB_URL) + "/AJAX/handler.ashx";

    ui->tableWidget->setColumnCount(6);
     ui->tableWidget->setHorizontalHeaderLabels(QStringList()<<QString("工具名")<<QString("件号")<<QString("可替代(最终选择)")<<QString("实际状态")<<QString("查看工具箱")<<QString("操作"));
     ui->tableWidget->setColumnWidth(ToolName,200);
     ui->tableWidget->setColumnWidth(ToolID,100);
     ui->tableWidget->setColumnWidth(ALTER,200);

     ui->tableWidget->setColumnWidth(LOOK,100);
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

    skt_finger = new QTcpSocket(this);
    skt_rfid = new QTcpSocket(this);

    connect(skt_finger,SIGNAL(connected()),this,SLOT(finger_Srv_Connect()));
    connect(skt_finger,SIGNAL(disconnected()),this,SLOT(finger_Srv_disConnected()));
    connect(skt_finger,SIGNAL(error(QAbstractSocket::SocketError)),this,SLOT(finger_error(QAbstractSocket::SocketError)));

    connect(skt_rfid,SIGNAL(connected()),this,SLOT(rfid_Srv_Connect()));
    connect(skt_rfid,SIGNAL(disconnected()),this,SLOT(rfid_Srv_disConnected()));
    connect(skt_rfid,SIGNAL(error(QAbstractSocket::SocketError)),this,SLOT(rfid_error(QAbstractSocket::SocketError)));

    connect(this,SIGNAL(Srv_Connect_msg(QTcpSocket *)),this,SLOT(Srv_Connect(QTcpSocket *)));
    connect(this,SIGNAL(Srv_disConnected_msg(QTcpSocket *)),this,SLOT(Srv_disConnected(QTcpSocket *)));
    connect(this,SIGNAL(ReadReady_msg(QTcpSocket *skt)),this,SLOT(ReadReady(QTcpSocket *skt)));
    connect(this,SIGNAL(error_msg(QAbstractSocket::SocketError)),this,SLOT(error(QAbstractSocket::SocketError)));

    //skt_finger->connectToHost("192.168.1.101",7900);
    //skt_finger->readAll();
    //SendCmd(skt_finger,"{\"cmd\":\"activeME\"}");
   // connect(skt_finger,SIGNAL(readyRead()),this,SLOT(finger_ReadReady()));
    skt_rfid->connectToHost("192.168.1.151",7901);
    skt_rfid->readAll();
    SendCmd(skt_rfid,"{\"cmd\":\"activeME\"}");
    //connect(skt_rfid,SIGNAL(readyRead()),this,SLOT(finger_ReadReady()));//RFID不需要其主动发信号过来
    flash = new Welcome(this);
    loadingWin = new Loading(this);


  // this->hide();
   //flash->exec();
  // flash->setModal(true);
 //  flash->show();
  // flash->exec();
    //ShowLoading("等待用户指纹....");
    //loadingWin
   // this->show();
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

QString * MainWindow::ReadMsg(QTcpSocket *skt)
{
    QTextCodec *codec = QTextCodec::codecForName("UTF8");
    QTextDecoder *decoder = codec->makeDecoder();
    QByteArray datagram;
    QString *s= new QString("");

    qDebug("收到%d字节消息",skt->bytesAvailable());
    datagram.resize(skt->bytesAvailable());

    skt->read(datagram.data(),datagram.size());
    *s = decoder->toUnicode(datagram.data());

    qDebug(s->toAscii().data());
    return s;
}
QString* MainWindow::SendCmd(QTcpSocket *skt, char * Cmd)
{
     qint64 len = 0,size = strlen (Cmd) + 1,t;
     //发信号之前断开
     QString *s= new QString("");
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

     qDebug("waitForReadyRead");
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
    emit Srv_Connect(skt_finger);
}
void MainWindow::rfid_Srv_Connect()
{
    emit Srv_Connect(skt_rfid);
}
void MainWindow::finger_Srv_disConnected()
{
      emit Srv_disConnected(skt_finger);
}
void MainWindow::rfid_Srv_disConnected()
{
      emit Srv_disConnected(skt_rfid);
}

void MainWindow::finger_ReadReady()
{
     emit ReadReady(skt_finger);
}
 void	MainWindow::finger_error (QAbstractSocket::SocketError socketError )
 {
        emit error_msg(socketError);
 }
 void	MainWindow::rfid_error (QAbstractSocket::SocketError socketError )
 {
        emit error_msg(socketError);
 }
 void MainWindow::Srv_Connect(QTcpSocket * skt)
 {
     if (skt==skt_rfid){
             qDebug("rfid-->connected!");
     }else if (skt==skt_finger)
     {
            qDebug("finger-->connected!");
     }
 }

 void MainWindow::Srv_disConnected(QTcpSocket * skt)
 {
     qDebug("finger_disConnected");
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
    if (sc.property("status").toString() !="success"){

    }

    QTreeWidgetItem * root=new QTreeWidgetItem(QStringList()<<"TaskList");
    root->setData(0,Qt::UserRole,"root");

    QScriptValueIterator it(sc.property("tasklist"));
    while (it.hasNext())
    {
        it.next();
       if(!it.value().property("showname").toString().isEmpty()){
           //qDebug() << it.value().property("a").toString();
            QTreeWidgetItem * chd=new QTreeWidgetItem( QStringList()<<it.value().property("showname").toString());

            chd->setData(0,Qt::UserRole,it.value().property("taskid").toString());
            root->addChild(chd);
       }

    }
    ui->treeWidget->addTopLevelItem(root);QPushButton *btn =  new QPushButton();

    btn->setText("OK");


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

        view->show();


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

    QMap<QString, QString> map;
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
           tb->setItem(index,ToolName,new QTableWidgetItem(it.value().property("toolname").toString()));
           tb->setItem(index,ToolID,new QTableWidgetItem(it.value().property("toolid").toString()));
           gyButton *lkbtn =  new gyButton(index);
           lkbtn->setText("工具查看");

           connect(lkbtn,SIGNAL(clicked()),lkbtn,SLOT(Borowse_Clicked_slot()));
           connect(lkbtn,SIGNAL(BorowseClicked(int)),this,SLOT(look_tool_slot(int )));

            tb->setCellWidget(index,LOOK,lkbtn);

            AppState = it.value().property("appstate").toString();
            gyButton *btn =  new gyButton(index);

            tb->setCellWidget(index,OP,btn);

            connect(btn,SIGNAL(clicked()),btn,SLOT(Borrow_Clicked_slot()));
            connect(btn,SIGNAL(BorrowClicked(gyButton*)),this,SLOT(borrow_tool_click_slot(gyButton* )));
            myComBox *pComboBox = new myComBox();
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
                                            pComboBox->insert_coreid(pComboBox->count()-1,alter.value().property("coreid").toString());
                                            qDebug()<<pComboBox->currentIndex()<<alter.value().property("coreid").toString();
                                           if(!map.contains(alter.value().property("toolid").toString()) && alter.value().property("pvcount").toInt32() <=min_pvCount ){
                                                    min_pvCount= alter.value().property("pvcount").toInt32() ;
                                                    min_pvCount_index = pComboBox->count()-1;
                                                    map[alter.value().property("toolid").toString()]="true";
                                           }
                                   }
                          }

                       qDebug()<<"index-->"<<min_pvCount_index;
                       pComboBox->setCurrentIndex(min_pvCount_index);
                        btn->setText("借出");

             }else if (AppState=="1")//已借出待归还
            {
                        btn->setText("归还");
                        pComboBox->addItem(it.value().property("borrowedtoolid").toString());
                         pComboBox->setCurrentIndex(1);
                        tb->setItem(index,ToolName,new QTableWidgetItem(it.value().property("borrowedtoolname").toString()));

                        QTableWidgetItem *im = new QTableWidgetItem(it.value().property("borrowedtoolid").toString());
                        im->setBackgroundColor(QColor(0,255,0));
                        tb->setItem(index,ToolID,im);

            }else{//已归还
                        btn->hide();
                        pComboBox->addItem(it.value().property("borrowedtoolid").toString());
                        QTableWidgetItem *im = new QTableWidgetItem(it.value().property("borrowedtoolid").toString());
                        im->setBackgroundColor(QColor(0,255,0));
                         tb->setItem(index,ToolID,im);
            }


            tb->setCellWidget(index, ALTER, pComboBox );
      }

    }
   return  "OK";
}
void MainWindow::borrow_tool_click_slot(gyButton * btn)
{
    myComBox *box =  (myComBox*)ui->tableWidget->cellWidget(btn->index,ALTER);

    if(box->currentText()=="")
    {
        QMessageBox::information(0,"提示","请在下拉框中选择你要借用的工具!" );
        return;
    }

    brWin->sToolID = box->currentText();
    brWin->sToolName  = ui->tableWidget->item(btn->index,ToolName)->text();
    brWin->skt_rfid = skt_rfid;
    if (btn->AppState==0)
    {
            brWin->Borrow = true;//借
    }else if(btn->AppState==1)
    {
            brWin->Borrow = false;//还
    }else{
        //不会到这这里，因为appstate==2时,按钮被隐藏
    }
brWin->setModal(true);
brWin->show();
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


            disconnect(skt_finger,SIGNAL(readyRead()),this,SLOT(finger_ReadReady()));
            this->show();
            SendCmd(skt_finger,"{\"cmd\":\"DeactiveME\"}");
        }
         //
    }


    //if()
}
 void MainWindow::ReadReady(QTcpSocket *skt)
 {
       qDebug("finger_ReadReady");
       QString *Msg = ReadMsg(skt);
       if (*Msg=="" || Msg->isEmpty()){
           QMessageBox::information(0,"提示","收到空消息，可能连接断开");
       }else{
           DealMsg(Msg);
       }
 }

  void	MainWindow::error(QAbstractSocket::SocketError socketError )
  {
      qDebug("finger_socketError\n");

  }
MainWindow::~MainWindow()
{
    delete ui;
}

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

void MainWindow::on_MainWindow_destroyed(QObject *arg1)
{
    //this->destroy();
}

void MainWindow::on_treeWidget_itemClicked(QTreeWidgetItem *item, int column)
{
    if (item->data(0,Qt::UserRole).toString()!="root")
    {
       GetBorrowInfoByTaskID(item->data(0,Qt::UserRole).toString());
    }
}
