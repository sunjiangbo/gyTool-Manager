/****************************************************************************
** Meta object code from reading C++ file 'mainwindow.h'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.6)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "mainwindow.h"
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
      15,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       4,       // signalCount

 // signals: signature, parameters, type, tag, flags
      16,   12,   11,   11, 0x05,
      45,   12,   11,   11, 0x05,
      72,   12,   11,   11, 0x05,
     118,  106,   11,   11, 0x05,

 // slots: signature, parameters, type, tag, flags
     158,   11,   11,   11, 0x0a,
     179,   11,   11,   11, 0x0a,
     198,   11,   11,   11, 0x0a,
     224,  106,   11,   11, 0x0a,
     267,   12,   11,   11, 0x0a,
     292,   12,   11,   11, 0x0a,
     315,   12,   11,   11, 0x0a,
     345,  106,   11,   11, 0x0a,
     381,   11,   11,   11, 0x08,
     410,  405,   11,   11, 0x08,
     456,  444,   11,   11, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_MainWindow[] = {
    "MainWindow\0\0skt\0Srv_Connect_msg(QTcpSocket*)\0"
    "ReadReady_msg(QTcpSocket*)\0"
    "Srv_disConnected_msg(QTcpSocket*)\0"
    "socketError\0error_msg(QAbstractSocket::SocketError)\0"
    "finger_Srv_Connect()\0finger_ReadReady()\0"
    "finger_Srv_disConnected()\0"
    "finger_error(QAbstractSocket::SocketError)\0"
    "Srv_Connect(QTcpSocket*)\0"
    "ReadReady(QTcpSocket*)\0"
    "Srv_disConnected(QTcpSocket*)\0"
    "error(QAbstractSocket::SocketError)\0"
    "on_pushButton_clicked()\0arg1\0"
    "on_MainWindow_destroyed(QObject*)\0"
    "item,column\0on_treeWidget_itemClicked(QTreeWidgetItem*,int)\0"
};

void MainWindow::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        MainWindow *_t = static_cast<MainWindow *>(_o);
        switch (_id) {
        case 0: _t->Srv_Connect_msg((*reinterpret_cast< QTcpSocket*(*)>(_a[1]))); break;
        case 1: _t->ReadReady_msg((*reinterpret_cast< QTcpSocket*(*)>(_a[1]))); break;
        case 2: _t->Srv_disConnected_msg((*reinterpret_cast< QTcpSocket*(*)>(_a[1]))); break;
        case 3: _t->error_msg((*reinterpret_cast< QAbstractSocket::SocketError(*)>(_a[1]))); break;
        case 4: _t->finger_Srv_Connect(); break;
        case 5: _t->finger_ReadReady(); break;
        case 6: _t->finger_Srv_disConnected(); break;
        case 7: _t->finger_error((*reinterpret_cast< QAbstractSocket::SocketError(*)>(_a[1]))); break;
        case 8: _t->Srv_Connect((*reinterpret_cast< QTcpSocket*(*)>(_a[1]))); break;
        case 9: _t->ReadReady((*reinterpret_cast< QTcpSocket*(*)>(_a[1]))); break;
        case 10: _t->Srv_disConnected((*reinterpret_cast< QTcpSocket*(*)>(_a[1]))); break;
        case 11: _t->error((*reinterpret_cast< QAbstractSocket::SocketError(*)>(_a[1]))); break;
        case 12: _t->on_pushButton_clicked(); break;
        case 13: _t->on_MainWindow_destroyed((*reinterpret_cast< QObject*(*)>(_a[1]))); break;
        case 14: _t->on_treeWidget_itemClicked((*reinterpret_cast< QTreeWidgetItem*(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
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
        if (_id < 15)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 15;
    }
    return _id;
}

// SIGNAL 0
void MainWindow::Srv_Connect_msg(QTcpSocket * _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void MainWindow::ReadReady_msg(QTcpSocket * _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void MainWindow::Srv_disConnected_msg(QTcpSocket * _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}

// SIGNAL 3
void MainWindow::error_msg(QAbstractSocket::SocketError _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 3, _a);
}
QT_END_MOC_NAMESPACE