#ifndef BORROWANDREBACK_H
#define BORROWANDREBACK_H

#include <QDialog>

namespace Ui {
class BorrowAndReBack;
}

class BorrowAndReBack : public QDialog
{
    Q_OBJECT

public:
    explicit BorrowAndReBack(QWidget *parent = 0);
    ~BorrowAndReBack();

private:
    Ui::BorrowAndReBack *ui;
};

#endif // BORROWANDREBACK_H
