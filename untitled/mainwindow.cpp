#include "mainwindow.h"
#include "ui_mainwindow.h"
#include<QStandardItemModel>
#include<mydl.h>
MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    QStandardItemModel *student_model = new QStandardItemModel();
       student_model->setHorizontalHeaderItem(0, new QStandardItem(QObject::tr("Name")));
       student_model->setHorizontalHeaderItem(1, new QStandardItem(QObject::tr("NO.")));
       student_model->setHorizontalHeaderItem(2, new QStandardItem(QObject::tr("Sex")));
       student_model->setHorizontalHeaderItem(3, new QStandardItem(QObject::tr("Age")));
       student_model->setHorizontalHeaderItem(4, new QStandardItem(QObject::tr("College")));
       //利用setModel()方法将数据模型与QTableView绑定

       ui->tableView->setModel(student_model);//setEditTriggers (  )

       myDl *m = new myDl();

       ui->tableView->setItemDelegate(m);

       ui->tableView->setEditTriggers(QAbstractItemView::NoEditTriggers);

       student_model->setItem(0,0,new QStandardItem("213"));
        student_model->setItem(0,1,new QStandardItem("2133"));;
            student_model->setItem(0,2,new QStandardItem("21443"));
                student_model->setItem(0,3,new QStandardItem("21553"));
                    student_model->setItem(0,4,new QStandardItem("21223"));


       for (int row = 0; row <5; ++row) {
           for (int column =0; column < 5; column+=1) {
               QModelIndex index = student_model->index(row, column, QModelIndex());
               student_model->setData(index, QVariant((row+1) * (column+1)));
           }

       }
        ui->tableView->horizontalHeader()->setStretchLastSection(true);

}

MainWindow::~MainWindow()
{
    delete ui;
}
