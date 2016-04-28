#ifndef MYCOMBOX_H
#define MYCOMBOX_H

#include <QObject>
#include<QComboBox>
#include<QMap>

class ToolNameAndCoreID{
       public :
       QString Name;
      QString CoreID;
};

class myComBox : public QComboBox
{
    Q_OBJECT
public:
    explicit myComBox();
    QString get_coreid();
    QString get_toolname();
    void insert_coreid(int i,QString ToolName,QString coreid);
signals:

public slots:


private:
    QMap<int ,ToolNameAndCoreID *> coreidmap;
};

#endif // MYCOMBOX_H
