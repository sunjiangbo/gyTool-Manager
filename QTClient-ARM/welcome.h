#ifndef WELCOME_H
#define WELCOME_H

#include <QDialog>
  #include<QMovie>
namespace Ui {
class Welcome;
}

class Welcome : public QDialog
{
    Q_OBJECT

public:
    explicit Welcome(QWidget *parent = 0);
    ~Welcome();
   QMovie *movie;

private:
    Ui::Welcome *ui;
};

#endif // WELCOME_H
