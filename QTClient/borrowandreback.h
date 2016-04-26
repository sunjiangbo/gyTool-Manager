#ifndef BORROWANDREBACK_H
#define BORROWANDREBACK_H

#include <QDialog>
#include <QString>
#include<QTimer>
#include<QTcpSocket>
#include <QTextDecoder>
#include <QCloseEvent>

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
    bool       Borrow;
    QTimer *tmr;
    QString* SendCmd(QTcpSocket *skt, char * Cmd);
    QTcpSocket * skt_rfid;
    bool continue_scan;
#define SCANTEXT1  "<html><head/><body><p><span style=\" font-size:20pt; color:#0055ff;\">工具扫描中……</span></p></body></html>"
#define SCANTEXT2  "<html><head/><body><p><span style=\" font-size:20pt; color:#0055ff;\">工具扫描中…………</span></p></body></html>"
#define STOPSCAN   "<html><head/><body><p><span style=\" font-size:20pt; color:#0055ff;\">扫描被停止</span></p></body></html>"
#define SCANOK      "<html><head/><body><p><span style=\" font-size:20pt; color:#0055ff;\">已扫描到该工具</span></p></body></html>"
private:
    Ui::BorrowAndReBack *ui;
public slots:
        void ScanTools();
   void on_BorrowAndReBack_destroyed();
   void on_opbtn_clicked();
private slots:
   void on_BorrowAndReBack_finished(int result);
   void on_pushButton_2_clicked();

protected:
     void closeEvent(QCloseEvent *event);
    void showEvent(QShowEvent *event);
};

#endif // BORROWANDREBACK_H
