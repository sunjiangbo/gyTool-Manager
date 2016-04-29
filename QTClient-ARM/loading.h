#ifndef LOADING_H
#define LOADING_H

#include <QDialog>
  #include <QLabel>
  #include<QPainter>
  #include<QMovie>

namespace Ui {
class Loading;
}

class Loading : public QDialog
{
    Q_OBJECT

public:
    explicit Loading(QWidget *parent = 0);
    ~Loading();
    void setTitle(QString title);
private:
    Ui::Loading *ui;
    QMovie *movie;
        QLabel *label;
};

#endif // LOADING_H
