/********************************************************************************
** Form generated from reading UI file 'borrowandreback.ui'
**
** Created by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_BORROWANDREBACK_H
#define UI_BORROWANDREBACK_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QDialog>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>
#include <QtGui/QPushButton>

QT_BEGIN_NAMESPACE

class Ui_BorrowAndReBack
{
public:
    QLabel *lb1_2;
    QLabel *lb1_3;
    QLabel *scanlb;
    QLabel *oplb;
    QLabel *oplb_2;
    QLabel *lb1;
    QPushButton *opbtn;
    QLabel *oplb_3;
    QLabel *lb1_5;
    QPushButton *pushButton_2;

    void setupUi(QDialog *BorrowAndReBack)
    {
        if (BorrowAndReBack->objectName().isEmpty())
            BorrowAndReBack->setObjectName(QString::fromUtf8("BorrowAndReBack"));
        BorrowAndReBack->resize(469, 274);
        lb1_2 = new QLabel(BorrowAndReBack);
        lb1_2->setObjectName(QString::fromUtf8("lb1_2"));
        lb1_2->setGeometry(QRect(130, 60, 91, 41));
        QFont font;
        font.setFamily(QString::fromUtf8("Noto Sans [unknown]"));
        lb1_2->setFont(font);
        lb1_3 = new QLabel(BorrowAndReBack);
        lb1_3->setObjectName(QString::fromUtf8("lb1_3"));
        lb1_3->setGeometry(QRect(77, 140, 131, 41));
        lb1_3->setFont(font);
        scanlb = new QLabel(BorrowAndReBack);
        scanlb->setObjectName(QString::fromUtf8("scanlb"));
        scanlb->setGeometry(QRect(210, 140, 211, 41));
        scanlb->setFont(font);
        oplb = new QLabel(BorrowAndReBack);
        oplb->setObjectName(QString::fromUtf8("oplb"));
        oplb->setGeometry(QRect(220, 13, 151, 51));
        oplb_2 = new QLabel(BorrowAndReBack);
        oplb_2->setObjectName(QString::fromUtf8("oplb_2"));
        oplb_2->setGeometry(QRect(220, 53, 151, 51));
        lb1 = new QLabel(BorrowAndReBack);
        lb1->setObjectName(QString::fromUtf8("lb1"));
        lb1->setGeometry(QRect(130, 20, 91, 41));
        lb1->setFont(font);
        opbtn = new QPushButton(BorrowAndReBack);
        opbtn->setObjectName(QString::fromUtf8("opbtn"));
        opbtn->setGeometry(QRect(120, 210, 85, 27));
        oplb_3 = new QLabel(BorrowAndReBack);
        oplb_3->setObjectName(QString::fromUtf8("oplb_3"));
        oplb_3->setGeometry(QRect(220, 90, 151, 51));
        lb1_5 = new QLabel(BorrowAndReBack);
        lb1_5->setObjectName(QString::fromUtf8("lb1_5"));
        lb1_5->setGeometry(QRect(104, 97, 91, 41));
        lb1_5->setFont(font);
        pushButton_2 = new QPushButton(BorrowAndReBack);
        pushButton_2->setObjectName(QString::fromUtf8("pushButton_2"));
        pushButton_2->setGeometry(QRect(240, 210, 85, 27));

        retranslateUi(BorrowAndReBack);

        QMetaObject::connectSlotsByName(BorrowAndReBack);
    } // setupUi

    void retranslateUi(QDialog *BorrowAndReBack)
    {
        BorrowAndReBack->setWindowTitle(QApplication::translate("BorrowAndReBack", "Dialog", 0, QApplication::UnicodeUTF8));
        lb1_2->setText(QApplication::translate("BorrowAndReBack", "<html><head/><body><p><span style=\" font-size:20pt; color:#5500ff;\">\344\273\266\345\217\267:</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        lb1_3->setText(QApplication::translate("BorrowAndReBack", "<html><head/><body><p><span style=\" font-size:20pt; color:#5500ff;\">\346\243\200\346\265\213\347\212\266\346\200\201:</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        scanlb->setText(QApplication::translate("BorrowAndReBack", "<html><head/><body><p><span style=\" font-size:20pt; color:#0055ff;\">\345\267\245\345\205\267\346\211\253\346\217\217\344\270\255\342\200\246\342\200\246</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        oplb->setText(QApplication::translate("BorrowAndReBack", "<html><head/><body><p><span style=\" font-size:20pt; color:#ff0000;\">\345\200\237\347\224\250</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        oplb_2->setText(QApplication::translate("BorrowAndReBack", "<html><head/><body><p><span style=\" font-size:20pt; color:#ff0000;\">AA</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        lb1->setText(QApplication::translate("BorrowAndReBack", "<html><head/><body><p><span style=\" font-size:20pt; color:#5500ff;\">\346\223\215\344\275\234:</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        opbtn->setText(QApplication::translate("BorrowAndReBack", "\345\201\234\346\255\242\346\211\253\346\217\217", 0, QApplication::UnicodeUTF8));
        oplb_3->setText(QApplication::translate("BorrowAndReBack", "<html><head/><body><p><span style=\" font-size:20pt; color:#ff0000;\">50H\345\267\245\345\205\267\345\214\205</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        lb1_5->setText(QApplication::translate("BorrowAndReBack", "<html><head/><body><p><span style=\" font-size:20pt; color:#5500ff;\">\345\267\245\345\205\267\345\220\215:</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        pushButton_2->setText(QApplication::translate("BorrowAndReBack", "\351\200\200\345\207\272", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class BorrowAndReBack: public Ui_BorrowAndReBack {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_BORROWANDREBACK_H
