/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>
#include <QtGui/QMainWindow>
#include <QtGui/QPushButton>
#include <QtGui/QTableWidget>
#include <QtGui/QTreeWidget>
#include <QtGui/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralWidget;
    QLabel *label;
    QLabel *uCorp;
    QLabel *label_3;
    QLabel *uName;
    QLabel *label_2;
    QTreeWidget *treeWidget;
    QTableWidget *tableWidget;
    QPushButton *pushButton_3;
    QLabel *label_4;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QString::fromUtf8("MainWindow"));
        MainWindow->resize(1024, 600);
        centralWidget = new QWidget(MainWindow);
        centralWidget->setObjectName(QString::fromUtf8("centralWidget"));
        label = new QLabel(centralWidget);
        label->setObjectName(QString::fromUtf8("label"));
        label->setGeometry(QRect(210, 10, 591, 81));
        label->setPixmap(QPixmap(QString::fromUtf8("img/logo.png")));
        uCorp = new QLabel(centralWidget);
        uCorp->setObjectName(QString::fromUtf8("uCorp"));
        uCorp->setGeometry(QRect(370, 110, 231, 31));
        label_3 = new QLabel(centralWidget);
        label_3->setObjectName(QString::fromUtf8("label_3"));
        label_3->setGeometry(QRect(280, 110, 71, 31));
        uName = new QLabel(centralWidget);
        uName->setObjectName(QString::fromUtf8("uName"));
        uName->setGeometry(QRect(160, 110, 91, 31));
        label_2 = new QLabel(centralWidget);
        label_2->setObjectName(QString::fromUtf8("label_2"));
        label_2->setGeometry(QRect(20, 110, 121, 31));
        treeWidget = new QTreeWidget(centralWidget);
        QTreeWidgetItem *__qtreewidgetitem = new QTreeWidgetItem();
        __qtreewidgetitem->setText(0, QString::fromUtf8("1"));
        treeWidget->setHeaderItem(__qtreewidgetitem);
        treeWidget->setObjectName(QString::fromUtf8("treeWidget"));
        treeWidget->setGeometry(QRect(20, 160, 241, 431));
        tableWidget = new QTableWidget(centralWidget);
        tableWidget->setObjectName(QString::fromUtf8("tableWidget"));
        tableWidget->setGeometry(QRect(270, 160, 741, 431));
        pushButton_3 = new QPushButton(centralWidget);
        pushButton_3->setObjectName(QString::fromUtf8("pushButton_3"));
        pushButton_3->setGeometry(QRect(702, 105, 101, 41));
        label_4 = new QLabel(centralWidget);
        label_4->setObjectName(QString::fromUtf8("label_4"));
        label_4->setGeometry(QRect(620, 110, 71, 31));
        MainWindow->setCentralWidget(centralWidget);

        retranslateUi(MainWindow);

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QApplication::translate("MainWindow", "\345\267\245\345\205\267\347\256\241\347\220\206\347\263\273\347\273\237", 0, QApplication::UnicodeUTF8));
        label->setText(QString());
        uCorp->setText(QApplication::translate("MainWindow", "<html><head/><body><p><span style=\" font-size:14pt; color:#0000ff;\">XXX</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        label_3->setText(QApplication::translate("MainWindow", "<html><head/><body><p><span style=\" font-size:14pt;\">\351\203\250\351\227\250\357\274\232</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        uName->setText(QApplication::translate("MainWindow", "<html><head/><body><p><span style=\" font-size:14pt; color:#3c23ff;\">XXX</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        label_2->setText(QApplication::translate("MainWindow", "<html><head/><body><p><span style=\" font-size:14pt;\">\345\275\223\345\211\215\347\224\250\346\210\267\357\274\232</span></p></body></html>", 0, QApplication::UnicodeUTF8));
        pushButton_3->setText(QApplication::translate("MainWindow", "\351\200\200\345\207\272\347\231\273\345\275\225", 0, QApplication::UnicodeUTF8));
        label_4->setText(QApplication::translate("MainWindow", "<html><head/><body><p><span style=\" font-size:14pt;\">\346\223\215\344\275\234\357\274\232</span></p></body></html>", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
