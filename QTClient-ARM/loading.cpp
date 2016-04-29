#include "loading.h"
#include "ui_loading.h"

Loading::Loading(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Loading)
{
    ui->setupUi(this);
   label = ui->label;
            //this->setFixedSize(81,80);
            setWindowOpacity(0.9); //设置透明用；
            this->setWindowFlags(Qt::Dialog|Qt::CustomizeWindowHint);

            //取消对话框标题
            this->setWindowFlags(Qt::Dialog|Qt::FramelessWindowHint);

            //取消对话框标题和边框
            this->setAutoFillBackground(true);
           // this->setContentsMargins(0,0,0,0);
            //label->setContentsMargins(0,0,0,0);
            /*QPalettepalette;palette.setBrush(QPalette::Background,QBrush(QPixmap("E:/qml/imgdialog/loading.gif")));
            this->setPalette(palette)*/;
            movie = new QMovie("/home/img/loading.gif");
            label->setMovie(movie);
            movie->start();
}
void Loading::setTitle(QString title)
{
      ui->label_2->setAlignment(Qt::AlignHCenter);
      ui->label_2->setText("<html><head/><body><p><span style=\" font-size:14pt; color:#270bc8;\">"+title+"</span></p></body></html>");

}
Loading::~Loading()
{
    delete ui;
    delete label;
    delete movie;
}
