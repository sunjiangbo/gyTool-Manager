#include "gytcpsocket.h"

gyTcpSocket::gyTcpSocket(QObject *parent) :
    QTcpSocket(parent)
{

}
void gyTcpSocket::gyConnect()
{
        this->connectToHost(devAddr,devPort);
}
