#ifndef BORROWANDREBACK_H
#define BORROWANDREBACK_H

#include <QDialog>
#include <QString>
#include<QTimer>
#include<QTcpSocket>
#include <QTextDecoder>
#include <QCloseEvent>
 #include <QtWebKit/QWebView>

namespace Ui {
class BorrowAndReBack;
}

class BorrowAndReBack : public QDialog
{
    Q_OBJECT

public:
    explicit BorrowAndReBack(QWidget *parent = 0);
    ~BorrowAndReBack();
    QString sToolID;
    QString sToolName;
    QString PhotoURL;
    bool       Borrow;
    bool       ScanOK;
    bool       PhotoOK;
    QTimer *tmr;
    QString* SendCmd(QTcpSocket *skt, char * Cmd);
    QTcpSocket * skt_rfid;
    QTcpSocket * skt_gpy;
    QWebView *view ;

#define SCANTEXT1  "<html><head/><body><p><span style=\" font-size:20pt; color:#0055ff;\">工具扫描中……</span></p></body></html>"
#define SCANTEXT2  "<html><head/><body><p><span style=\" font-size:20pt; color:#0055ff;\">工具扫描中…………</span></p></body></html>"
#define STOPSCAN   "<html><head/><body><p><span style=\" font-size:20pt; color:#0055ff;\">扫描被停止</span></p></body></html>"
#define SCANOK1      "<html><head/><body><p><span style=\" font-size:20pt; color:#0055ff;\">工具扫到，拍照中……</span></p></body></html>"
#define SCANOK2     "<html><head/><body><p><span style=\" font-size:20pt; color:#0055ff;\">工具扫到，拍照中…………</span></p></body></html>"
#define SCANOKANDPHOTOTAKED     "<html><head/><body><p><span style=\" font-size:20pt; color:#0055ff;\">工具扫到并拍照成功!</span></p></body></html>"
#define PHOTOTAKEOK     "<html><head/><body><p><span style=\" font-size:20pt; color:#0055ff;\">拍照成功,请继续操作!</span></p></body></html>"
#define STOPPHOTOTAKE     "<html><head/><body><p><span style=\" font-size:20pt; color:#0055ff;\">拍照被停止!</span></p></body></html>"
#define LBBEFORE "<html><head/><body><p><span style=\" font-size:20pt; color:#ff0000;\">"
#define LBAFTER "</span></p></body></html>"
private:
    Ui::BorrowAndReBack *ui;
public slots:
        void ScanTools();
   void on_BorrowAndReBack_destroyed();
   void on_opbtn_clicked();
private slots:
   void on_BorrowAndReBack_finished(int result);
   void on_pushButton_2_clicked();

   void on_lookphoto_clicked();

   void on_pushButton_clicked(bool checked);

   void on_pushButton_clicked();

   void on_BorrowAndReBack_destroyed(QObject *arg1);

protected:
     void closeEvent(QCloseEvent *event);
    void showEvent(QShowEvent *event);
};

#endif // BORROWANDREBACK_H
