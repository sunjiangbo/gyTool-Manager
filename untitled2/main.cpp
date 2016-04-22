#include "mainwindow.h"
#include <QApplication>
#include <QTextCodec>
#include <QFontDatabase>
int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();

    QTextCodec::setCodecForTr(QTextCodec::codecForName("utf8"));
    QTextCodec::setCodecForCStrings(QTextCodec::codecForLocale());
    int fontID = QFontDatabase::addApplicationFont("/usr/share/fonts/myfonts/simsun.ttf");
    QString msyh = QFontDatabase::applicationFontFamilies(fontID).first();
    QFont font(msyh,16);
    QApplication::setFont(font);
    return a.exec();
}
