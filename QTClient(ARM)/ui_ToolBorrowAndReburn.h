/********************************************************************************
** Form generated from reading UI file 'ToolBorrowAndReburn.ui'
**
** Created by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_TOOLBORROWANDREBURN_H
#define UI_TOOLBORROWANDREBURN_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QDialog>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>
#include <QtGui/QPushButton>

QT_BEGIN_NAMESPACE

class Ui_Dialog
{
public:
    QLabel *lb1;
    QLabel *oplb;
    QLabel *lb1_2;
    QLabel *oplb_2;
    QLabel *lb1_3;
    QLabel *lb1_4;
    QPushButton *opbtn;
    QPushButton *pushButton_2;
    QLabel *oplb_3;
    QLabel *lb1_5;

    void setupUi(QDialog *Dialog)
    {
        if (Dialog->objectName().isEmpty())
            Dialog->setObjectName(QString::fromUtf8("Dialog"));
        Dialog->resize(406, 284);
        lb1 = new QLabel(Dialog);
        lb1->setObjectName(QString::fromUtf8("lb1"));
        lb1->setGeometry(QRect(100, 30, 91, 41));
        QFont font;
        font.setFamily(QString::fromUtf8("Noto Sans [unknown]"));
        lb1->setFont(font);
        oplb = new QLabel(Dialog);
        oplb->setObjectName(QString::fromUtf8("oplb"));
        oplb->setGeometry(QRect(190, 23, 151, 51));
        lb1_2 = new QLabel(Dialog);
        lb1_2->setObjectName(QString::fromUtf8("lb1_2"));
        lb1_2->setGeometry(QRect(100, 70, 91, 41));
        lb1_2->setFont(font);
        oplb_2 = new QLabel(Dialog);
        oplb_2->setObjectName(QString::fromUtf8("oplb_2"));
        oplb_2->setGeometry(QRect(190, 63, 151, 51));
        lb1_3 = new QLabel(Dialog);
        lb1_3->setObjectName(QString::fromUtf8("lb1_3"));
        lb1_3->setGeometry(QRect(47, 150, 131, 41));
        lb1_3->setFont(font);
        lb1_4 = new QLabel(Dialog);
        lb1_4->setObjectName(QString::fromUtf8("lb1_4"));
        lb1_4->setGeometry(QRect(180, 150, 211, 41));
        lb1_4->setFont(font);
        opbtn = new QPushButton(Dialog);
        opbtn->setObjectName(QString::fromUtf8("opbtn"));
        opbtn->setGeometry(QRect(90, 220, 85, 27));
        pushButton_2 = new QPushButton(Dialog);
        pushButton_2->setObjectName(QString::fromUtf8("pushButton_2"));
        pushButton_2->setGeometry(QRect(210, 220, 85, 27));
        oplb_3 = new QLabel(Dialog);
        oplb_3->setObjectName(QString::fromUtf8("oplb_3"));
        oplb_3->setGeometry(QRect(190, 100, 151, 51));
        lb1_5 = new QLabel(Dialog);
        lb1_5->setObjectName(QString::fromUtf8("lb1_5"));
        lb1_5->setGeometry(QRect(74, 107, 91, 41));
        lb1_5->setFont(font);

        retranslateUi(Dialog);

        QMetaObject::connectSlotsByName(Dialog);
    } // setupUi

    void retranslateUi(QDialog *Dialog)
    {
        Dialog->setWindowTitle(QApplication::translate("Dialog", "Dialog", 0, QApplication::UnicodeUTF8));
        lb1->setText(QApplication::translate("Dialog", "<html><head/><body><p><span style=\" font-size:20pt; color:#5500ff;\">\346\223\215\344\275\234:</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        oplb->setText(QApplication::translate("Dialog", "<html><head/><body><p><span style=\" font-size:20pt; color:#ff0000;\">\345\200\237\347\224\250</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        lb1_2->setText(QApplication::translate("Dialog", "<html><head/><body><p><span style=\" font-size:20pt; color:#5500ff;\">\344\273\266\345\217\267:</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        oplb_2->setText(QApplication::translate("Dialog", "<html><head/><body><p><span style=\" font-size:20pt; color:#ff0000;\">AA</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        lb1_3->setText(QApplication::translate("Dialog", "<html><head/><body><p><span style=\" font-size:20pt; color:#5500ff;\">\346\243\200\346\265\213\347\212\266\346\200\201:</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        lb1_4->setText(QApplication::translate("Dialog", "<html><head/><body><p><span style=\" font-size:20pt; color:#0055ff;\">\345\267\245\345\205\267\346\211\253\346\217\217\344\270\255\342\200\246\342\200\246</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        opbtn->setText(QApplication::translate("Dialog", "\347\241\256\350\256\244\345\200\237\345\207\272", 0, QApplication::UnicodeUTF8));
        pushButton_2->setText(QApplication::translate("Dialog", "\351\200\200\345\207\272", 0, QApplication::UnicodeUTF8));
        oplb_3->setText(QApplication::translate("Dialog", "<html><head/><body><p><span style=\" font-size:20pt; color:#ff0000;\">50H\345\267\245\345\205\267\345\214\205</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        lb1_5->setText(QApplication::translate("Dialog", "<html><head/><body><p><span style=\" font-size:20pt; color:#5500ff;\">\345\267\245\345\205\267\345\220\215:</span></p></body></html>", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class Dialog: public Ui_Dialog {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_TOOLBORROWANDREBURN_H
