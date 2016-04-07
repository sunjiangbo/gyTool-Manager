#ifndef MYCOMBOX_H
#define MYCOMBOX_H

#include <QObject>
#include<QComboBox>
#include<QMap>

class myComBox : public QComboBox
{
    Q_OBJECT
public:
    explicit myComBox();
    QString get_coreid();
    void insert_coreid(int i,QString coreid);
signals:

public slots:


private:
    QMap<int ,QString > coreidmap;
};

#endif // MYCOMBOX_H
