#include "borrowandreback.h"
#include "ui_borrowandreback.h"

BorrowAndReBack::BorrowAndReBack(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::BorrowAndReBack)
{
    ui->setupUi(this);
}

BorrowAndReBack::~BorrowAndReBack()
{
    delete ui;
}
