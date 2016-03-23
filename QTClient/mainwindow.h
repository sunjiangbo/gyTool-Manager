#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "welcome.h"
#include <QMainWindow>
#include <QtNetwork/QTcpSocket>
#include<QtNetwork/QHostAddress>
namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
    QTcpSocket * skt_finger;
    QString *SendCmd(QTcpSocket* skt,char *Cmd);
    void DealJsonDat(QString jsonDat);
    QString httpsPostHelp(const QString &url, const QString &data);
private:
    Ui::MainWindow *ui;
    Welcome *flash;
signals:
    void Srv_Connect_msg(QTcpSocket *skt);
    void  ReadReady_msg(QTcpSocket *skt);
    void Srv_disConnected_msg(QTcpSocket *skt);
    void error_msg(QAbstractSocket::SocketError socketError);


  public slots:
    void finger_Srv_Connect();
    void finger_ReadReady();
    void finger_Srv_disConnected();
    void finger_error (QAbstractSocket::SocketError socketError );

    void Srv_Connect(QTcpSocket *skt);
    void ReadReady(QTcpSocket *skt);
    void Srv_disConnected(QTcpSocket *skt);
    void	error (QAbstractSocket::SocketError socketError );
private slots:
    void on_pushButton_clicked();
};

#endif // MAINWINDOW_H
