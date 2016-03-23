#include "mainwindow.h"
#include "ui_mainwindow.h"
#include<QComboBox>
#include<QPushButton>
#include<QMessageBox>
#include<QLabel>
#include<QtWebKit/QWebView>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);


    ui->tableWidget->setColumnCount(5);
    ui->tableWidget->setHorizontalHeaderLabels(QStringList()<<QString("Name")<<QString("Addr")<<QString("Tel")<<QString("btnCol"));
   QTableWidgetItem *item = new QTableWidgetItem(QIcon("/home/qt/1.ico"),"hello");
   ui->tableWidget->insertRow(0);
   ui->tableWidget->setItem(0,0,item);
    ui->tableWidget->setItem(0,1,new QTableWidgetItem("hello"));
    QComboBox *pComboBox = new QComboBox();
     pComboBox->addItem("a");
     pComboBox->addItem("b");
    ui->tableWidget->setCellWidget(0, 2, pComboBox );

    QPushButton *btn =  new QPushButton();

    btn->setText("OK");

    ui->tableWidget->setCellWidget(0,3,btn);
    connect(btn,SIGNAL(clicked()),this,SLOT(btnClk()));

    QLabel* label = new QLabel("<a href =www.cafuc.edu.cn>cafuc</a>",this);
    ui->tableWidget->setCellWidget(0,4,label);
      connect(label,SIGNAL(linkActivated(QString)),this,SLOT(openUrl(QString)));  //

}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::btnClk()
{
    QMessageBox::information(0,"title","gyLinuxer");
}

void MainWindow::openUrl(QString url)
{
    QWebView *view = new QWebView();
        view->load(QUrl("http://172.16.74.61:8080"));
        view->show();
}
