#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QtNetwork/QTcpSocket>
#include<QtNetwork/QHostAddress>
#include <QMessageBox>
#include <QString>
#include <QByteArray>
#include <QTextDecoder>
MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{


    ui->setupUi(this);
    skt_finger = new QTcpSocket(this);
    connect(skt_finger,SIGNAL(connected()),this,SLOT(finger_Srv_Connect()));
    connect(skt_finger,SIGNAL(disconnected()),this,SLOT(finger_Srv_disConnected()));
    connect(skt_finger,SIGNAL(readyRead()),this,SLOT(finger_ReadReady()));
    connect(skt_finger,SIGNAL(error(QAbstractSocket::SocketError)),this,SLOT(finger_error(QAbstractSocket::SocketError)));

    connect(this,SIGNAL(Srv_Connect_msg(QTcpSocket *)),this,SLOT(Srv_Connect(QTcpSocket *)));
    connect(this,SIGNAL(Srv_disConnected_msg(QTcpSocket *)),this,SLOT(Srv_disConnected(QTcpSocket *)));
    connect(this,SIGNAL(ReadReady_msg(QTcpSocket *skt)),this,SLOT(ReadReady(QTcpSocket *skt)));
    connect(this,SIGNAL(error_msg(QAbstractSocket::SocketError)),this,SLOT(error(QAbstractSocket::SocketError)));

    skt_finger->connectToHost("192.168.1.108",7900);
    flash = new Welcome(this);
    this->hide();
    flash->show();
    flash->exec();
    this->show();
}

QString* MainWindow::SendCmd(QTcpSocket *skt, char * Cmd)
{
     qint64 len = 0,size = strlen (Cmd) + 1,t;
     //发信号之前断开
     QString *s= new QString("");
      if (skt->ConnectedState != QAbstractSocket::ConnectedState && sizeof(Cmd)==0){
            return (new QString(""));
      }

      do{
            t  =  skt->write(Cmd+len,size-len);
            len += t;
      }while(t!=-1&&len<size);

     len =   0;

    QTextCodec *codec = QTextCodec::codecForName("UTF8");
    QTextDecoder *decoder = codec->makeDecoder();
    QByteArray datagram;
    datagram.resize(skt->bytesAvailable());
    skt->read(datagram.data(),datagram.size());
    *s = decoder->toUnicode(datagram.data());
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

 void MainWindow::ReadReady(QTcpSocket *skt)
 {
       qDebug("finger_ReadReady");
 }

  void	MainWindow::error(QAbstractSocket::SocketError socketError )
  {
      qDebug("finger_socketError");

  }
MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_pushButton_clicked()
{
    QString *str = SendCmd(skt_finger,"{cmd:333大方大方大方");
    //qDebug("收到->");
   qDebug(str->toAscii().data());
    //printf("RECV->%s\n",str->data());
}
