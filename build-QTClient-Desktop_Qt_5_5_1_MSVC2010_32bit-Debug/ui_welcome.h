/********************************************************************************
** Form generated from reading UI file 'welcome.ui'
**
** Created by: Qt User Interface Compiler version 5.5.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_WELCOME_H
#define UI_WELCOME_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QDialog>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>

QT_BEGIN_NAMESPACE

class Ui_Welcome
{
public:
    QLabel *label;
    QLabel *label_2;
    QLabel *label_3;

    void setupUi(QDialog *Welcome)
    {
        if (Welcome->objectName().isEmpty())
            Welcome->setObjectName(QStringLiteral("Welcome"));
        Welcome->resize(589, 334);
        label = new QLabel(Welcome);
        label->setObjectName(QStringLiteral("label"));
        label->setGeometry(QRect(0, 0, 591, 71));
        label->setPixmap(QPixmap(QString::fromUtf8("img/logo.png")));
        label_2 = new QLabel(Welcome);
        label_2->setObjectName(QStringLiteral("label_2"));
        label_2->setGeometry(QRect(200, 180, 171, 121));
        label_3 = new QLabel(Welcome);
        label_3->setObjectName(QStringLiteral("label_3"));
        label_3->setGeometry(QRect(100, 100, 411, 71));
        QFont font;
        font.setFamily(QString::fromUtf8("\346\226\271\346\255\243\344\271\246\345\256\213_GBK"));
        font.setPointSize(36);
        label_3->setFont(font);

        retranslateUi(Welcome);

        QMetaObject::connectSlotsByName(Welcome);
    } // setupUi

    void retranslateUi(QDialog *Welcome)
    {
        Welcome->setWindowTitle(QApplication::translate("Welcome", "Dialog", 0));
        label->setText(QString());
        label_2->setText(QApplication::translate("Welcome", "TextLabel", 0));
        label_3->setText(QApplication::translate("Welcome", "<html><head/><body><p><span style=\" color:#5833eb;\">\345\267\245\345\205\267\347\256\241\347\220\206\347\263\273\347\273\237 V1.0</span></p></body></html>", 0));
    } // retranslateUi

};

namespace Ui {
    class Welcome: public Ui_Welcome {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_WELCOME_H
