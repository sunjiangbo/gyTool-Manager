/****************************************************************************
** Meta object code from reading C++ file 'borrowandreback.h'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.6)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../QTClient/borrowandreback.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'borrowandreback.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.6. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_BorrowAndReBack[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       8,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      17,   16,   16,   16, 0x0a,
      29,   16,   16,   16, 0x0a,
      60,   16,   16,   16, 0x0a,
      86,   79,   16,   16, 0x08,
     119,   16,   16,   16, 0x08,
     145,   16,   16,   16, 0x08,
     176,  168,   16,   16, 0x08,
     204,   16,   16,   16, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_BorrowAndReBack[] = {
    "BorrowAndReBack\0\0ScanTools()\0"
    "on_BorrowAndReBack_destroyed()\0"
    "on_opbtn_clicked()\0result\0"
    "on_BorrowAndReBack_finished(int)\0"
    "on_pushButton_2_clicked()\0"
    "on_lookphoto_clicked()\0checked\0"
    "on_pushButton_clicked(bool)\0"
    "on_pushButton_clicked()\0"
};

void BorrowAndReBack::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        BorrowAndReBack *_t = static_cast<BorrowAndReBack *>(_o);
        switch (_id) {
        case 0: _t->ScanTools(); break;
        case 1: _t->on_BorrowAndReBack_destroyed(); break;
        case 2: _t->on_opbtn_clicked(); break;
        case 3: _t->on_BorrowAndReBack_finished((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 4: _t->on_pushButton_2_clicked(); break;
        case 5: _t->on_lookphoto_clicked(); break;
        case 6: _t->on_pushButton_clicked((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 7: _t->on_pushButton_clicked(); break;
        default: ;
        }
    }
}

const QMetaObjectExtraData BorrowAndReBack::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject BorrowAndReBack::staticMetaObject = {
    { &QDialog::staticMetaObject, qt_meta_stringdata_BorrowAndReBack,
      qt_meta_data_BorrowAndReBack, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &BorrowAndReBack::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *BorrowAndReBack::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *BorrowAndReBack::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_BorrowAndReBack))
        return static_cast<void*>(const_cast< BorrowAndReBack*>(this));
    return QDialog::qt_metacast(_clname);
}

int BorrowAndReBack::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QDialog::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 8)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 8;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
