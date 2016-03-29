#ifndef MYDL_H
#define MYDL_H

#include <QStyledItemDelegate>

class myDl : public QStyledItemDelegate
{
public:
    myDl();
    void paint(QPainter *painter,
               const QStyleOptionViewItem &option,
               const QModelIndex &index) ;

};

#endif // MYDL_H
