#include "toolborrowandreturn.h"
#include "ui_toolborrowandreturn.h"

ToolBorrowAndReturn::ToolBorrowAndReturn(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::ToolBorrowAndReturn)
{
    ui->setupUi(this);
}

ToolBorrowAndReturn::~ToolBorrowAndReturn()
{
    delete ui;
}
