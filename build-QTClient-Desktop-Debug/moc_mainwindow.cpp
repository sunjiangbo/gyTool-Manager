/****************************************************************************
** Meta object code from reading C++ file 'mainwindow.h'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.6)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../QTClient/mainwindow.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'mainwindow.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.6. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_MainWindow[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
      25,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       4,       // signalCount

 // signals: signature, parameters, type, tag, flags
      16,   12,   11,   11, 0x05,
      46,   12,   11,   11, 0x05,
      74,   12,   11,   11, 0x05,
     125,  109,   11,   11, 0x05,

 // slots: signature, parameters, type, tag, flags
     178,   11,   11,   11, 0x0a,
     199,   11,   11,   11, 0x0a,
     218,   11,   11,   11, 0x0a,
     256,  244,   11,   11, 0x0a,
     299,   11,   11,   11, 0x0a,
     318,   11,   11,   11, 0x0a,
     342,  244,   11,   11, 0x0a,
     383,   11,   11,   11, 0x0a,
     401,   11,   11,   11, 0x0a,
     424,  244,   11,   11, 0x0a,
     464,   12,   11,   11, 0x0a,
     490,   12,   11,   11, 0x0a,
     514,   12,   11,   11, 0x0a,
     545,  109,   11,   11, 0x0a,
     596,  594,   11,   11, 0x0a,
     620,  616,   11,   11, 0x0a,
     654,   11,   11,   11, 0x08,
     683,  678,   11,   11, 0x08,
     729,  717,   11,   11, 0x08,
     777,   11,   11,   11, 0x08,
     803,   11,   11,   11, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_MainWindow[] = {
    "MainWindow\0\0skt\0Srv_Connect_msg(gyTcpSocket*)\0"
    "ReadReady_msg(gyTcpSocket*)\0"
    "Srv_disConnected_msg(gyTcpSocket*)\0"
    "skt,socketError\0"
    "error_msg(gyTcpSocket*,QAbstractSocket::SocketError)\0"
    "finger_Srv_Connect()\0finger_ReadReady()\0"
    "finger_Srv_disConnected()\0socketError\0"
    "finger_error(QAbstractSocket::SocketError)\0"
    "rfid_Srv_Connect()\0rfid_Srv_disConnected()\0"
    "rfid_error(QAbstractSocket::SocketError)\0"
    "gpy_Srv_Connect()\0gpy_Srv_disConnected()\0"
    "gpy_error(QAbstractSocket::SocketError)\0"
    "Srv_Connect(gyTcpSocket*)\0"
    "ReadReady(gyTcpSocket*)\0"
    "Srv_disConnected(gyTcpSocket*)\0"
    "error(gyTcpSocket*,QAbstractSocket::SocketError)\0"
    "i\0look_tool_slot(int)\0btn\0"
    "borrow_tool_click_slot(gyButton*)\0"
    "on_pushButton_clicked()\0arg1\0"
    "on_MainWindow_destroyed(QObject*)\0"
    "item,column\0on_treeWidget_itemClicked(QTreeWidgetItem*,int)\0"
    "on_pushButton_2_clicked()\0"
    "on_pushButton_3_clicked()\0"
};

void MainWindow::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        MainWindow *_t = static_cast<MainWindow *>(_o);
        switch (_id) {
        case 0: _t->Srv_Connect_msg((*reinterpret_cast< gyTcpSocket*(*)>(_a[1]))); break;
        case 1: _t->ReadReady_msg((*reinterpret_cast< gyTcpSocket*(*)>(_a[1]))); break;
        case 2: _t->Srv_disConnected_msg((*reinterpret_cast< gyTcpSocket*(*)>(_a[1]))); break;
        case 3: _t->error_msg((*reinterpret_cast< gyTcpSocket*(*)>(_a[1])),(*reinterpret_cast< QAbstractSocket::SocketError(*)>(_a[2]))); break;
        case 4: _t->finger_Srv_Connect(); break;
        case 5: _t->finger_ReadReady(); break;
        case 6: _t->finger_Srv_disConnected(); break;
        case 7: _t->finger_error((*reinterpret_cast< QAbstractSocket::SocketError(*)>(_a[1]))); break;
        case 8: _t->rfid_Srv_Connect(); break;
        case 9: _t->rfid_Srv_disConnected(); break;
        case 10: _t->rfid_error((*reinterpret_cast< QAbstractSocket::SocketError(*)>(_a[1]))); break;
        case 11: _t->gpy_Srv_Connect(); break;
        case 12: _t->gpy_Srv_disConnected(); break;
        case 13: _t->gpy_error((*reinterpret_cast< QAbstractSocket::SocketError(*)>(_a[1]))); break;
        case 14: _t->Srv_Connect((*reinterpret_cast< gyTcpSocket*(*)>(_a[1]))); break;
        case 15: _t->ReadReady((*reinterpret_cast< gyTcpSocket*(*)>(_a[1]))); break;
        case 16: _t->Srv_disConnected((*reinterpret_cast< gyTcpSocket*(*)>(_a[1]))); break;
        case 17: _t->error((*reinterpret_cast< gyTcpSocket*(*)>(_a[1])),(*reinterpret_cast< QAbstractSocket::SocketError(*)>(_a[2]))); break;
        case 18: _t->look_tool_slot((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 19: _t->borrow_tool_click_slot((*reinterpret_cast< gyButton*(*)>(_a[1]))); break;
        case 20: _t->on_pushButton_clicked(); break;
        case 21: _t->on_MainWindow_destroyed((*reinterpret_cast< QObject*(*)>(_a[1]))); break;
        case 22: _t->on_treeWidget_itemClicked((*reinterpret_cast< QTreeWidgetItem*(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 23: _t->on_pushButton_2_clicked(); break;
        case 24: _t->on_pushButton_3_clicked(); break;
        default: ;
        }
    }
}

const QMetaObjectExtraData MainWindow::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject MainWindow::staticMetaObject = {
    { &QMainWindow::staticMetaObject, qt_meta_stringdata_MainWindow,
      qt_meta_data_MainWindow, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &MainWindow::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *MainWindow::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *MainWindow::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_MainWindow))
        return static_cast<void*>(const_cast< MainWindow*>(this));
    return QMainWindow::qt_metacast(_clname);
}

int MainWindow::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QMainWindow::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 25)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 25;
    }
    return _id;
}

// SIGNAL 0
void MainWindow::Srv_Connect_msg(gyTcpSocket * _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void MainWindow::ReadReady_msg(gyTcpSocket * _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void MainWindow::Srv_disConnected_msg(gyTcpSocket * _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}

// SIGNAL 3
void MainWindow::error_msg(gyTcpSocket * _t1, QAbstractSocket::SocketError _t2)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 3, _a);
}
QT_END_MOC_NAMESPACE
