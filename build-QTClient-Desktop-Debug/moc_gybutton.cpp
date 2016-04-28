/****************************************************************************
** Meta object code from reading C++ file 'gybutton.h'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.6)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../桌面/QTClient/gybutton.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'gybutton.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.6. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_gyButton[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       4,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       2,       // signalCount

 // signals: signature, parameters, type, tag, flags
      12,   10,    9,    9, 0x05,
      36,   32,    9,    9, 0x05,

 // slots: signature, parameters, type, tag, flags
      61,    9,    9,    9, 0x0a,
      84,    9,    9,    9, 0x0a,

       0        // eod
};

static const char qt_meta_stringdata_gyButton[] = {
    "gyButton\0\0i\0BorowseClicked(int)\0btn\0"
    "BorrowClicked(gyButton*)\0"
    "Borowse_Clicked_slot()\0Borrow_Clicked_slot()\0"
};

void gyButton::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        gyButton *_t = static_cast<gyButton *>(_o);
        switch (_id) {
        case 0: _t->BorowseClicked((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 1: _t->BorrowClicked((*reinterpret_cast< gyButton*(*)>(_a[1]))); break;
        case 2: _t->Borowse_Clicked_slot(); break;
        case 3: _t->Borrow_Clicked_slot(); break;
        default: ;
        }
    }
}

const QMetaObjectExtraData gyButton::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject gyButton::staticMetaObject = {
    { &QPushButton::staticMetaObject, qt_meta_stringdata_gyButton,
      qt_meta_data_gyButton, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &gyButton::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *gyButton::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *gyButton::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_gyButton))
        return static_cast<void*>(const_cast< gyButton*>(this));
    return QPushButton::qt_metacast(_clname);
}

int gyButton::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QPushButton::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 4)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    }
    return _id;
}

// SIGNAL 0
void gyButton::BorowseClicked(int _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void gyButton::BorrowClicked(gyButton * _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}
QT_END_MOC_NAMESPACE
