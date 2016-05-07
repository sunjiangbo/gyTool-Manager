/********************************************************************************
** Form generated from reading UI file 'toolborrowandreturn.ui'
**
** Created by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_TOOLBORROWANDRETURN_H
#define UI_TOOLBORROWANDRETURN_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QDialog>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>
#include <QtGui/QPushButton>

QT_BEGIN_NAMESPACE

class Ui_ToolBorrowAndReturn
{
public:
    QLabel *oplb;
    QLabel *lb1_2;
    QLabel *lb1_5;
    QLabel *lb1_3;
    QLabel *lb1_4;
    QLabel *lb1;
    QLabel *oplb_2;
    QPushButton *pushButton_2;
    QPushButton *opbtn;
    QLabel *oplb_3;

    void setupUi(QDialog *ToolBorrowAndReturn)
    {
        if (ToolBorrowAndReturn->objectName().isEmpty())
            ToolBorrowAndReturn->setObjectName(QString::fromUtf8("ToolBorrowAndReturn"));
        ToolBorrowAndReturn->resize(440, 272);
        oplb = new QLabel(ToolBorrowAndReturn);
        oplb->setObjectName(QString::fromUtf8("oplb"));
        oplb->setGeometry(QRect(210, 23, 151, 51));
        lb1_2 = new QLabel(ToolBorrowAndReturn);
        lb1_2->setObjectName(QString::fromUtf8("lb1_2"));
        lb1_2->setGeometry(QRect(120, 70, 91, 41));
        QFont font;
        font.setFamily(QString::fromUtf8("Noto Sans [unknown]"));
        lb1_2->setFont(font);
        lb1_5 = new QLabel(ToolBorrowAndReturn);
        lb1_5->setObjectName(QString::fromUtf8("lb1_5"));
        lb1_5->setGeometry(QRect(94, 107, 91, 41));
        lb1_5->setFont(font);
        lb1_3 = new QLabel(ToolBorrowAndReturn);
        lb1_3->setObjectName(QString::fromUtf8("lb1_3"));
        lb1_3->setGeometry(QRect(67, 150, 131, 41));
        lb1_3->setFont(font);
        lb1_4 = new QLabel(ToolBorrowAndReturn);
        lb1_4->setObjectName(QString::fromUtf8("lb1_4"));
        lb1_4->setGeometry(QRect(200, 150, 211, 41));
        lb1_4->setFont(font);
        lb1 = new QLabel(ToolBorrowAndReturn);
        lb1->setObjectName(QString::fromUtf8("lb1"));
        lb1->setGeometry(QRect(120, 30, 91, 41));
        lb1->setFont(font);
        oplb_2 = new QLabel(ToolBorrowAndReturn);
        oplb_2->setObjectName(QString::fromUtf8("oplb_2"));
        oplb_2->setGeometry(QRect(210, 63, 151, 51));
        pushButton_2 = new QPushButton(ToolBorrowAndReturn);
        pushButton_2->setObjectName(QString::fromUtf8("pushButton_2"));
        pushButton_2->setGeometry(QRect(230, 220, 85, 27));
        opbtn = new QPushButton(ToolBorrowAndReturn);
        opbtn->setObjectName(QString::fromUtf8("opbtn"));
        opbtn->setGeometry(QRect(110, 220, 85, 27));
        oplb_3 = new QLabel(ToolBorrowAndReturn);
        oplb_3->setObjectName(QString::fromUtf8("oplb_3"));
        oplb_3->setGeometry(QRect(210, 100, 151, 51));

        retranslateUi(ToolBorrowAndReturn);

        QMetaObject::connectSlotsByName(ToolBorrowAndReturn);
    } // setupUi

    void retranslateUi(QDialog *ToolBorrowAndReturn)
    {
        ToolBorrowAndReturn->setWindowTitle(QApplication::translate("ToolBorrowAndReturn", "Dialog", 0, QApplication::UnicodeUTF8));
        oplb->setText(QApplication::translate("ToolBorrowAndReturn", "<html><head/><body><p><span style=\" font-size:20pt; color:#ff0000;\">\345\200\237\347\224\250</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        lb1_2->setText(QApplication::translate("ToolBorrowAndReturn", "<html><head/><body><p><span style=\" font-size:20pt; color:#5500ff;\">\344\273\266\345\217\267:</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        lb1_5->setText(QApplication::translate("ToolBorrowAndReturn", "<html><head/><body><p><span style=\" font-size:20pt; color:#5500ff;\">\345\267\245\345\205\267\345\220\215:</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        lb1_3->setText(QApplication::translate("ToolBorrowAndReturn", "<html><head/><body><p><span style=\" font-size:20pt; color:#5500ff;\">\346\243\200\346\265\213\347\212\266\346\200\201:</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        lb1_4->setText(QApplication::translate("ToolBorrowAndReturn", "<html><head/><body><p><span style=\" font-size:20pt; color:#0055ff;\">\345\267\245\345\205\267\346\211\253\346\217\217\344\270\255\342\200\246\342\200\246</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        lb1->setText(QApplication::translate("ToolBorrowAndReturn", "<html><head/><body><p><span style=\" font-size:20pt; color:#5500ff;\">\346\223\215\344\275\234:</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        oplb_2->setText(QApplication::translate("ToolBorrowAndReturn", "<html><head/><body><p><span style=\" font-size:20pt; color:#ff0000;\">AA</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        pushButton_2->setText(QApplication::translate("ToolBorrowAndReturn", "\351\200\200\345\207\272", 0, QApplication::UnicodeUTF8));
        opbtn->setText(QApplication::translate("ToolBorrowAndReturn", "\347\241\256\350\256\244\345\200\237\345\207\272", 0, QApplication::UnicodeUTF8));
        oplb_3->setText(QApplication::translate("ToolBorrowAndReturn", "<html><head/><body><p><span style=\" font-size:20pt; color:#ff0000;\">50H\345\267\245\345\205\267\345\214\205</span></p></body></html>", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class ToolBorrowAndReturn: public Ui_ToolBorrowAndReturn {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_TOOLBORROWANDRETURN_H
