#include "borrowandreback.h"
#include "ui_borrowandreback.h"
#include <QtScript/QtScript>
#include <QMessageBox>
#include<QNetworkRequest>
#include<QNetworkReply>

BorrowAndReBack::BorrowAndReBack(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::BorrowAndReBack)
{
    ui->setupUi(this);
    tmr = new QTimer(this);
    view =  new QWebView();
    connect(tmr,SIGNAL(timeout()),this,SLOT(ScanTools()));
    //tmr->start(500);
    //ui->opbtn->setText("停止扫描");
    //ui->scanlb->setText(SCANTEXT1);s
    Qt::WindowFlags flags = view->windowFlags();
    flags |=Qt::Dialog;
       view->setWindowFlags(flags);
}

BorrowAndReBack::~BorrowAndReBack()
{
    delete ui;
}
 #define WEB_URL          "http://172.16.74.61:8080"
QString BorrowAndReBack::httpSendCmd(QString Cmd)
{
    return httpsPostHelp(WEB_URL+QString("/Ajax/Handler.ashx"),Cmd);
}
const int TIMEOUT = (30 * 1000);
QString BorrowAndReBack::httpsPostHelp(const QString &url, const QString &data)
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
void BorrowAndReBack::ScanTools()
{

    if (!ScanOK)//还未扫描到工具
    {
            QString cmdTxt =  "{\"cmd\":\"isThisToolHere\",\"toolid\":\""+sToolID+"\"}";
            QString *sRet = SendCmd(skt_rfid,(cmdTxt.toLatin1()).data());
            if( *sRet == "OK")
            {
                ScanOK = true;
                //tmr->stop();
                ui->scanlb->setText(SCANOK1);
                ui->opbtn->setText("停止拍照");
                tmr->stop();
                tmr->start(1000);
            }else{
                if(ui->scanlb->text()==SCANTEXT1)
                {
                     ui->scanlb->setText(SCANTEXT2);
                }else{
                     ui->scanlb->setText(SCANTEXT1);
                }
            }

    }else//已扫描到该工具
    {
            if(!PhotoOK)
            {
                 ui->scanlb->setText(ui->scanlb->text()==SCANOK1?SCANOK2:SCANOK1);

                QString cmdTxt =  "{\"cmd\":\"TakePhoto\"}";
                QString *sRet = SendCmd(skt_gpy,(cmdTxt.toLatin1()).data());
                QScriptEngine engine;
                QScriptValue sc = engine.evaluate("("+*sRet+")");

                if(sc.property("status").toString()!="success")
                {
                     ui->scanlb->setText( "<html><head/><body><p><span style=\" font-size:20pt; color:#0055ff;\">"+sc.property("msg").toString()+"</span></p></body></html>");
                     return;
                }else{
                      PhotoOK =true;
                      tmr->stop();
                      PhotoURL = sc.property("msg").toString()+sc.property("reason").toString();
                      ui->scanlb->setText(PHOTOTAKEOK);
                      if(Borrow){
                              ui->opbtn->setText("确认借出");
                          }else{
                              ui->opbtn->setText("确认归还");
                          }
                }


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


void BorrowAndReBack::on_opbtn_clicked()
{
    QString btnText = ui->opbtn->text() ;
    if (btnText== "停止扫描")
    {
        tmr->stop();
        ui->opbtn->setText("开始扫描");
        ui->scanlb->setText(STOPSCAN);
    }else if(btnText == "开始扫描")
    {
         tmr->start(500);
         ui->opbtn->setText("停止扫描");
         ui->scanlb->setText(SCANTEXT1);
    }else if(btnText == "确认借出")
    {
           ui->scanlb->setText(BORROWBEFORE + QString("正在借出.......") + BORROWAFTER);
           QString cmdtxt = "{\"cmd\":\"BRTool\",\"userid\":\"" + UserID
                   + "\",\"username\":\""+UserName+"\""
                   +",\"appid\":\""+QString::number(AppID)+"\""
                     +",\"optype\":\"borrow\""
                     +",\"toolid\":\""+sToolID+"\""
                     +",\"toolname\":\""+sToolName+"\""
                     +",\"pic\":\""+PhotoURL+"\""
                   + "}";

           QString cmdret =  httpSendCmd(cmdtxt);
           QScriptEngine engine;
           QScriptValue sc = engine.evaluate("("+cmdret+")");
          qDebug()<<cmdret;
           if (sc.property("status").toString()=="success")
           {
               QMessageBox::information(this,"提示","工具借用成功!");
               this->close();
               return;
           }else{
               ui->scanlb->setText(BORROWBEFORE +sc.property("msg").toString()  + BORROWAFTER);
           }

    }else if(btnText == "确认归还")
    {
        ui->scanlb->setText(BORROWBEFORE + QString("正在归还.......") + BORROWAFTER);
        QString cmdtxt = "{\"cmd\":\"BRTool\",\"userid\":\"" + UserID
               + "\",\"username\":\""+UserName+"\""
                +",\"appid\":\""+QString::number(AppID)+"\""
                  +",\"optype\":\"refund\""
                  +",\"toolid\":\""+sToolID+"\""
                  +",\"toolname\":\""+sToolName+"\""
                  +",\"pic\":\""+PhotoURL+"\""
                + "}";

        QString cmdret =  httpSendCmd(cmdtxt);
        QScriptEngine engine;
        QScriptValue sc = engine.evaluate("("+cmdret+")");

        if (sc.property("status").toString()=="success")
        {
            QMessageBox::information(this,"提示","工具归还成功!");
            this->close();
            return;
        }else{
            ui->scanlb->setText(BORROWBEFORE +sc.property("msg").toString()  + BORROWAFTER);
        }


    }else if(btnText == "停止拍照")
    {
        tmr->stop();
        ui->scanlb->setText(STOPPHOTOTAKE);
        ui->opbtn->setText("开始拍照");
     }else if(btnText == "开始拍照")
    {
        tmr->start(1000);
    }
}

void BorrowAndReBack::on_BorrowAndReBack_finished(int result)
{

}

void BorrowAndReBack::closeEvent(QCloseEvent *event)
{
    tmr->stop();
}
void BorrowAndReBack::showEvent(QShowEvent *event)
{
    PhotoURL = "";
    ScanOK = false;
    PhotoOK = false;
    ui->opbtn->setText("停止扫描");
    ui->oplb->setText(LBBEFORE + QString(Borrow==true?"借用":"归还") + LBAFTER);
    ui->oplb_2->setText(LBBEFORE + QString(sToolID) + LBAFTER);
    ui->oplb_3->setText(LBBEFORE + QString(sToolName) + LBAFTER);
    ui->scanlb->setText(SCANTEXT1);
    tmr->start(500);
}
void BorrowAndReBack::on_pushButton_2_clicked()
{
    this->close();
}

void BorrowAndReBack::on_lookphoto_clicked()
{
    if (PhotoURL == "")
    {
        QMessageBox::information(this,"提示","拍照还未成功！");
        return;
    }
          view->load(QUrl( QString(PhotoURL)));
               view->show();
          //this->setModal(true);

}

void BorrowAndReBack::on_pushButton_clicked(bool checked)
{

}

void BorrowAndReBack::on_pushButton_clicked()
{
     if (!ScanOK)
     {
         QMessageBox::information(this,"提示","还未扫描到工具，不可拍照!");
         return;
     }

    if (tmr->isActive())
    {
        QMessageBox::information(this,"提示","其他操作正在执行，请稍后再试!");
        return;
    }

    PhotoOK = false;
    ui->scanlb->setText(SCANOK1);
    tmr->start(1000);
}

void BorrowAndReBack::on_BorrowAndReBack_destroyed()
{

}

void BorrowAndReBack::on_BorrowAndReBack_destroyed(QObject *arg1)
{

}

void BorrowAndReBack::on_pushButton_3_clicked()
{
    QString cmdtxt = "{\"cmd\":\"BRTool\",\"userid\":\"" + UserID
           + "\",\"username\":\""+UserName+"\""
            +",\"appid\":\""+QString::number(AppID)+"\""
              +",\"optype\":\"refund\""
              +",\"toolid\":\""+sToolID+"\""
              +",\"toolname\":\""+sToolName+"\""
              +",\"pic\":\""+PhotoURL+"\""
            + "}";

    QMessageBox::information(this,"提示", httpSendCmd(cmdtxt));
}
