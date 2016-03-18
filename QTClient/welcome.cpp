#include "welcome.h"
#include "ui_welcome.h"
#include <QLabel>
#include <QMovie>

Welcome::Welcome(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Welcome)
{
    ui->setupUi(this);
    QPixmap map("/home/qt/gyTool-Manager/QTClient/img/zw.jpg");
    ui->label_2->setPixmap(map);
   ui->label_2->show();

    QPixmap pixmap("/home/qt/gyTool-Manager/QTClient/img/logo.png");
    ui->label->setPixmap(pixmap);
    ui->label->show();
}

Welcome::~Welcome()
{
    delete ui;
}
