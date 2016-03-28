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
MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{


    ui->setupUi(this);
    HandlerURL = "http://127.0.0.1/AJAX/handler.ashx";
  /*  ui->tableWidget->setColumnCount(5);
    ui->tableWidget->setHorizontalHeaderLabels(QStringList()<<QString("Name")<<QString("Addr")<<QString("Tel")<<QString("btnCol"));
   QTableWidgetItem *item = new QTableWidgetItem(QIcon("/home/qt/1.ico"),"hello");
   ui->tableWidget->insertRow(0);
   ui->tableWidget->setItem(0,0,item);
    ui->tableWidget->setItem(0,1,new QTableWidgetItem("hello"));
    QComboBox *pComboBox = new QComboBox();
     pComboBox->addItem("a");
     pComboBox->addItem("b");
    ui->tableWidget->setCellWidget(0, 2, pComboBox );

    QPushButton *btn =  new QPushButton();

    btn->setText("OK");

    ui->tableWidget->setCellWidget(0,3,btn);
    connect(btn,SIGNAL(clicked()),this,SLOT(btnClk()));

    QLabel* label = new QLabel("<a href =www.cafuc.edu.cn>cafuc</a>",this);
    ui->tableWidget->setCellWidget(0,4,label);
      connect(label,SIGNAL(linkActivated(QString)),this,SLOT(openUrl(QString)));  //
*/
    QPixmap pixmap("E:\\gyTool-Manager\\QTClient\\img\\logo.png");
    ui->label->setPixmap(pixmap);
    ui->label->show();
    ui->label->setScaledContents(true);

    skt_finger = new QTcpSocket(this);
    connect(skt_finger,SIGNAL(connected()),this,SLOT(finger_Srv_Connect()));
    connect(skt_finger,SIGNAL(disconnected()),this,SLOT(finger_Srv_disConnected()));

    connect(skt_finger,SIGNAL(error(QAbstractSocket::SocketError)),this,SLOT(finger_error(QAbstractSocket::SocketError)));

    connect(this,SIGNAL(Srv_Connect_msg(QTcpSocket *)),this,SLOT(Srv_Connect(QTcpSocket *)));
    connect(this,SIGNAL(Srv_disConnected_msg(QTcpSocket *)),this,SLOT(Srv_disConnected(QTcpSocket *)));
    connect(this,SIGNAL(ReadReady_msg(QTcpSocket *skt)),this,SLOT(ReadReady(QTcpSocket *skt)));
    connect(this,SIGNAL(error_msg(QAbstractSocket::SocketError)),this,SLOT(error(QAbstractSocket::SocketError)));

    skt_finger->connectToHost("192.168.1.108",7900);
    //skt_finger->readAll();
    SendCmd(skt_finger,"{\"cmd\":\"activeME\"}");
    connect(skt_finger,SIGNAL(readyRead()),this,SLOT(finger_ReadReady()));
    flash = new Welcome(this);
    loadingWin = new Loading(this);


   this->hide();
   //flash->exec();
   flash->setModal(true);
   flash->show();
   flash->exec();
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

void MainWindow::finger_Srv_disConnected()
{
      emit Srv_disConnected(skt_finger);
}

void MainWindow::finger_ReadReady()
{
     emit ReadReady(skt_finger);
}

 void	MainWindow::finger_error (QAbstractSocket::SocketError socketError )
 {
        emit error_msg(socketError);
 }
 void MainWindow::Srv_Connect(QTcpSocket * skt)
 {
     qDebug("fingerok");
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
    qDebug("-->%s",cmdtxt);
    ui->treeWidget->clear();
    ui->treeWidget->setColumnCount(1);
    ui->treeWidget->setHeaderLabels(QStringList()<<"任务列表");
    if (sc.property("status").toString() !="success"){

    }
    /*
     *  if(sc.property("chi").isArray()) //解析数组
      {
      QScriptValueIterator it(sc.property("chi"));
              while (it.hasNext())
              {
                  it.next();
                  if(!it.value().property("a").toString().isEmpty())
                      qDebug() << it.value().property("a").toString();
              }
      }*/

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
    ui->treeWidget->addTopLevelItem(root);

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

     qDebug("%s\n",cmdret);
    return "OK";
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

    QString cmdtxt = "{\"cmd\":\"GetBorwTaskListBytUserID\",\"userid\":\"25\"}";
    //qDebug("%s\n",cmdtxt);

    QMessageBox::information(0,"提示",httpSendCmd(cmdtxt));

  //QString *str = SendCmd(skt_finger,"{cmd:333大方大方大方");

     /* QString str = "{\"name\":\"xiaotang\", \"age\":\"23\", \"chi\":[{\"a\":\"aa\", \"b\":\"bb\"}, {\"a\":\"aaa\", \"b\":\"bbb\"}]}";
      QScriptEngine engine;
      QScriptValue sc = engine.evaluate("("+str+")");
      qDebug() << sc.property("name").toString(); //解析字段
      if(sc.property("chi").isArray()) //解析数组
      {
      QScriptValueIterator it(sc.property("chi"));
              while (it.hasNext())
              {
                  it.next();
                  if(!it.value().property("a").toString().isEmpty())
                      qDebug() << it.value().property("a").toString();
              }
      }*/
  // QMessageBox::information(0,"ret",httpsPostHelp("http://211.83.128.180/index.php/addrobject/addAddrObjectOk","exs:{\"name\":\"test\",\"desc\":\"\",\"item\":[{\"type\":\"0\",\"host\":\"211.83.128.144\"}]}"));

    //printf("RECV->%s\n",str->data());
}

void MainWindow::on_MainWindow_destroyed(QObject *arg1)
{
    //this->destroy();
}

void MainWindow::on_treeWidget_itemClicked(QTreeWidgetItem *item, int column)
{
    if (item->data(0,Qt::UserRole).toString()!="root")
    {
        QMessageBox::information(0,"任务ID",item->data(0,Qt::UserRole).toString());
    }
}
