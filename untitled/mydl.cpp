#include "mydl.h"
#include <QApplication>
#include<QStyledItemDelegate>
#include <QDebug>
myDl::myDl()
{
}

void myDl::paint(QPainter *painter, const QStyleOptionViewItem &option, const QModelIndex &index)
{
  //  if (index.column() == 1) {

            int progress = index.data().toInt();
            qDebug("now is ->%d\n",progress);
            QStyleOptionProgressBar progressBarOption;
            progressBarOption.rect = option.rect;
            progressBarOption.minimum = 0;
            progressBarOption.maximum = 100;
            progressBarOption.progress = progress;
            progressBarOption.text = QString::number(progress) + "%";
            progressBarOption.textVisible = true;

            QApplication::style()->drawControl(QStyle::CE_ProgressBar,
                                               &progressBarOption, painter);

       // } else
        //    QStyledItemDelegate::paint(painter, option, index);
}

