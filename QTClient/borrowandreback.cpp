#include "borrowandreback.h"
#include "ui_borrowandreback.h"

BorrowAndReBack::BorrowAndReBack(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::BorrowAndReBack)
{
    ui->setupUi(this);
    tmr = new QTimer(this);
    continue_scan = true;
    connect(tmr,SIGNAL(timeout()),this,SLOT(ScanTools()));
    //tmr->start(500);
    ui->opbtn->setText("停止扫描");
}

BorrowAndReBack::~BorrowAndReBack()
{
    delete ui;
}
void BorrowAndReBack::ScanTools()
{
    QString cmdTxt =  "{\"cmd\":\"isThisToolHere\",\"toolid\":\""+sToolID+"\"}";
    QString *sRet = SendCmd(skt_rfid,(cmdTxt.toLatin1()).data());
    if( *sRet == "ok" && continue_scan)
    {
        continue_scan = false;
        if(Borrow){
                ui->opbtn->setText("确认借出");
            }else{
                ui->opbtn->setText("确认归还");
            }
    }
}

QString *BorrowAndReBack::SendCmd(QTcpSocket *skt, char * Cmd)
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

         qDebug("rfid_waitForReadyRead");
          skt->waitForReadyRead();

         len =   0;

        QTextCodec *codec = QTextCodec::codecForName("UTF8");
        QTextDecoder *decoder = codec->makeDecoder();
        QByteArray datagram;
        qDebug("收到->%d字节",skt->bytesAvailable());
        datagram.resize(skt->bytesAvailable());

        skt->read(datagram.data(),datagram.size());
        *s = decoder->toUnicode(datagram.data());

        qDebug(s->toAscii().data());
        return s;
}

void BorrowAndReBack::on_BorrowAndReBack_destroyed()
{
    tmr->stop();
    delete tmr;
}

void BorrowAndReBack::on_opbtn_clicked()
{
    QString btnText = ui->opbtn->text() ;
    if (btnText== "停止扫描")
    {
        continue_scan = false;
        tmr->stop();
        ui->opbtn->setText("开始扫描");
    }else if(btnText == "开始扫描")
    {
        continue_scan = true;
         tmr->start(500);
        ui->opbtn->setText("停止扫描");
    }else if(btnText == "确认借出")
    {

    }else if(btnText == "确认归还")
    {

    }
}
