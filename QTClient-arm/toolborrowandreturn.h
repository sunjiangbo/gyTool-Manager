#ifndef TOOLBORROWANDRETURN_H
#define TOOLBORROWANDRETURN_H

#include <QDialog>
#include <QString>
namespace Ui {
class ToolBorrowAndReturn;
}

class ToolBorrowAndReturn : public QDialog
{
    Q_OBJECT

public:
    explicit ToolBorrowAndReturn(QWidget *parent = 0);
    ~ToolBorrowAndReturn();
#define Borrow 1
#define Return  2
    int OpType;
    QString ToolNum;
    QString ToolName;
private:
    Ui::ToolBorrowAndReturn *ui;
};

#endif // TOOLBORROWANDRETURN_H
