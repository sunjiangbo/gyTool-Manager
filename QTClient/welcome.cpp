#include "welcome.h"
#include "ui_welcome.h"
#include <QLabel>
#include <QMovie>
#include<QDir>

Welcome::Welcome(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Welcome)
{
   // Qt::WindowFlags flags = 0;
   // flags |= Qt::FramelessWindowHint;
    //this->setWindowFlags(Qt::FramelessWindowHint);
    //this->setFixedSize;

    //qDebug("当前路径%s",QDir::currentPath());
    ui->setupUi(this);
    QPixmap map("/home/img/zw1.png");
    ui->label_2->setPixmap(map);
    ui->label_2->show();
    ui->label_2->setScaledContents(true);

   QPixmap pixmap("/home/img/logo.png");
   ui->label->setPixmap(pixmap);
   ui->label->show();
    ui->label->setScaledContents(true);
}

Welcome::~Welcome()
{
    delete ui;
}
