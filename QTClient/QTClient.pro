#-------------------------------------------------
#
# Project created by QtCreator 2016-03-17T10:33:00
#
#-------------------------------------------------

QT       += core gui
QT       += network
QT        += script
QT      += webkitwidgets
QT +=  webkit
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = QTClient
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp \
    welcome.cpp \
    codelib.cpp \
    loading.cpp

HEADERS  += mainwindow.h \
    welcome.h \
    codelib.h \
    loading.h

FORMS    += mainwindow.ui \
    welcome.ui \
    loading.ui