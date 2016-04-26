#ifndef BORROWANDREBACK_H
#define BORROWANDREBACK_H

#include <QDialog>
#include <QString>
#include<QTimer>
#include<QTcpSocket>
#include <QTextDecoder>

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

private:
    Ui::BorrowAndReBack *ui;
public slots:
        void ScanTools();
   void on_BorrowAndReBack_destroyed();
   void on_opbtn_clicked();
};

#endif // BORROWANDREBACK_H
