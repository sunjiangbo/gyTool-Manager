#include "mainwindow.h"
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
    this->hide();
    flash->show();
    flash->exec();
    this->show();
}

void MainWindow::DealJsonDat(QString jsonDat)
{

}
QString MainWindow::httpSendCmd(QString Cmd)
{

    return "";
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
void MainWindow::DealMsg(QString *Msg)
{
    QScriptEngine engine;
    QScriptValue sc = engine.evaluate("("+*Msg+")");
    QString type =  sc.property("type").toString();

    qDebug("消息类型-->%s\n",sc.property("type").toString());

    if (type == "UserCapture")
    {
       // qDebug()<<"type-->"<<sc.property("type").toString();
        if(sc.property("userid").toString() != "null" )
        {


            qDebug()<<"进入msgbox";
            QMessageBox::information(0,"提示",QString("用户指纹->%1").arg(sc.property("userid").toString()));

            disconnect(skt_finger,SIGNAL(readyRead()),this,SLOT(finger_ReadReady()));
            flash->close();
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
  QString *str = SendCmd(skt_finger,"{cmd:333大方大方大方");

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
