#-------------------------------------------------
#
# Project created by QtCreator 2016-03-17T10:33:00
#
#-------------------------------------------------

QT       += core gui
QT       += network
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = QTClient
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp \
    welcome.cpp \
    form.cpp

HEADERS  += mainwindow.h \
    welcome.h \
    form.h

FORMS    += mainwindow.ui \
    welcome.ui \
    form.ui
