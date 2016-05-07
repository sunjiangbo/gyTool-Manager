#ifndef GYTCPSOCKET_H
#define GYTCPSOCKET_H

#include <QTcpSocket>
#include <QString>

class gyTcpSocket : public QTcpSocket
{
    Q_OBJECT
public:
    explicit gyTcpSocket(QObject *parent = 0);
    QString devName;
    QString devAddr;
    int devPort;
    void gyConnect();
    int ReConnectCount;
signals:

public slots:

};

#endif // GYTCPSOCKET_H
