/********************************************************************************
** Form generated from reading UI file 'welcome.ui'
**
** Created by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_WELCOME_H
#define UI_WELCOME_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QDialog>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>

QT_BEGIN_NAMESPACE

class Ui_Welcome
{
public:
    QLabel *label_3;
    QLabel *label_2;
    QLabel *label;

    void setupUi(QDialog *Welcome)
    {
        if (Welcome->objectName().isEmpty())
            Welcome->setObjectName(QString::fromUtf8("Welcome"));
        Welcome->resize(1024, 600);
        QFont font;
        font.setFamily(QString::fromUtf8("20 db"));
        font.setPointSize(16);
        Welcome->setFont(font);
        label_3 = new QLabel(Welcome);
        label_3->setObjectName(QString::fromUtf8("label_3"));
        label_3->setGeometry(QRect(250, 150, 671, 101));
        QFont font1;
        font1.setFamily(QString::fromUtf8("Noto Sans [unknown]"));
        font1.setPointSize(30);
        label_3->setFont(font1);
        label_2 = new QLabel(Welcome);
        label_2->setObjectName(QString::fromUtf8("label_2"));
        label_2->setGeometry(QRect(370, 320, 191, 201));
        label_2->setPixmap(QPixmap(QString::fromUtf8("img/zw1.png")));
        label = new QLabel(Welcome);
        label->setObjectName(QString::fromUtf8("label"));
        label->setGeometry(QRect(190, 20, 601, 91));
        label->setPixmap(QPixmap(QString::fromUtf8("img/logo.png")));

        retranslateUi(Welcome);

        QMetaObject::connectSlotsByName(Welcome);
    } // setupUi

    void retranslateUi(QDialog *Welcome)
    {
        Welcome->setWindowTitle(QApplication::translate("Welcome", "Dialog", 0, QApplication::UnicodeUTF8));
        label_3->setText(QApplication::translate("Welcome", "<html><head/><body><p><span style=\" font-size:36pt; color:#000000;\">\345\267\245\345\205\267\347\256\241\347\220\206\347\263\273\347\273\237 </span><span style=\" font-size:22pt; color:#000000;\">V1.0</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        label_2->setText(QString());
        label->setText(QString());
    } // retranslateUi

};

namespace Ui {
    class Welcome: public Ui_Welcome {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_WELCOME_H
