#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "welcome.h"
#include "loading.h"
#include <QMainWindow>
#include <QtNetwork/QTcpSocket>
#include<QtNetwork/QHostAddress>
#include<QTreeWidgetItem>\
#include<QMap>
#include<QPushButton>
#include <borrowandreback.h>
#include <gybutton.h>
#include<gytcpsocket.h>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
    gyTcpSocket * skt_finger;
    gyTcpSocket * skt_rfid;
    gyTcpSocket * skt_gpy;
    QString *SendCmd(gyTcpSocket* skt,char *Cmd);
    void DealJsonDat(QString jsonDat);
    QString httpsPostHelp(const QString &url, const QString &data);
    QString GetHttpCmdContentByParam(QString Cmd,QString param);
    QString httpSendCmd(QString Cmd);
    QString * ReadMsg(gyTcpSocket* skt);
    QString CurTaskID;
    void DealMsg(QString *Cmd);
    void ShowLoading(QString msg);
    void CloseLoading();
    QString FillNameAndCorp(QString userid);
    QString FillTaskList(QString userid);
    QString GetBorrowInfoByTaskID(QString TaskID);
    QString gUserID;
    QString gUserName;
    bool FlashIsShowing;
    QString gpyaddr;
    QString rfidaddr;
    QString fingeraddr;

#define ToolNameCOL          0
#define ToolID                1
#define ALTER                 2
 #define REALSTATE        3
#define LOOK                 4
#define OP                      5

 #define WEB_URL          "http://172.16.74.61:8080"
#define SCANTEXT1  "<html><head/><body><p><span style=\" font-size:20pt; color:#0055ff;\">工具扫描中……</span></p></body></html>"
private:
    Ui::MainWindow *ui;
    Welcome *flash;
    QString HandlerURL;
    Loading * loadingWin;
    QMap<QPushButton*,int> *tbMap;
    BorrowAndReBack * brWin;

signals:
    void Srv_Connect_msg(gyTcpSocket *skt);
    void  ReadReady_msg(gyTcpSocket *skt);
    void Srv_disConnected_msg(gyTcpSocket *skt);
    void error_msg(gyTcpSocket *skt,QAbstractSocket::SocketError socketError);


  public slots:
    void finger_Srv_Connect();
    void finger_ReadReady();
    void finger_Srv_disConnected();
    void finger_error (QAbstractSocket::SocketError socketError );

    void rfid_Srv_Connect();
    void rfid_Srv_disConnected();
    void rfid_error (QAbstractSocket::SocketError socketError );

    void gpy_Srv_Connect();
    void gpy_Srv_disConnected();
    void gpy_error (QAbstractSocket::SocketError socketError );

    void Srv_Connect(gyTcpSocket *skt);
    void ReadReady(gyTcpSocket *skt);
    void Srv_disConnected(gyTcpSocket *skt);
    void	error (gyTcpSocket *skt,QAbstractSocket::SocketError socketError );
//工具借用与查看按钮事件槽
    void look_tool_slot(int i);
    void borrow_tool_click_slot(gyButton* btn);
private slots:
    void on_pushButton_clicked();
    void on_MainWindow_destroyed(QObject *arg1);
    void on_treeWidget_itemClicked(QTreeWidgetItem *item, int column);

    void on_pushButton_2_clicked();
    void on_pushButton_3_clicked();
};

#endif // MAINWINDOW_H
