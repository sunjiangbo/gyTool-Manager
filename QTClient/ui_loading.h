/********************************************************************************
** Form generated from reading UI file 'loading.ui'
**
** Created by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_LOADING_H
#define UI_LOADING_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QDialog>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>

QT_BEGIN_NAMESPACE

class Ui_Loading
{
public:
    QLabel *label;
    QLabel *label_2;

    void setupUi(QDialog *Loading)
    {
        if (Loading->objectName().isEmpty())
            Loading->setObjectName(QString::fromUtf8("Loading"));
        Loading->resize(213, 120);
        label = new QLabel(Loading);
        label->setObjectName(QString::fromUtf8("label"));
        label->setGeometry(QRect(60, 30, 101, 81));
        label->setPixmap(QPixmap(QString::fromUtf8("img/loading.gif")));
        label_2 = new QLabel(Loading);
        label_2->setObjectName(QString::fromUtf8("label_2"));
        label_2->setGeometry(QRect(10, 0, 211, 31));

        retranslateUi(Loading);

        QMetaObject::connectSlotsByName(Loading);
    } // setupUi

    void retranslateUi(QDialog *Loading)
    {
        Loading->setWindowTitle(QApplication::translate("Loading", "Dialog", 0, QApplication::UnicodeUTF8));
        label->setText(QString());
        label_2->setText(QApplication::translate("Loading", "<html><head/><body><p><span style=\" font-size:14pt; color:#270bc8;\">\346\255\243\345\234\250\350\216\267\345\217\226\347\224\250\346\210\267\344\277\241\346\201\257\342\200\246\342\200\246</span></p></body></html>", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class Loading: public Ui_Loading {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_LOADING_H
