/****************************************************************************
** Meta object code from reading C++ file 'beattracker.hpp'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../plugin/src/Caelestia/beattracker.hpp"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'beattracker.hpp' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.9.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN9caelestia11BeatTrackerE_t {};
} // unnamed namespace

template <> constexpr inline auto caelestia::BeatTracker::qt_create_metaobjectdata<qt_meta_tag_ZN9caelestia11BeatTrackerE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "caelestia::BeatTracker",
        "QML.Element",
        "auto",
        "QML.Singleton",
        "true",
        "bpmChanged",
        "",
        "refCountChanged",
        "beat",
        "smpl_t",
        "bpm",
        "refCount"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'bpmChanged'
        QtMocHelpers::SignalData<void()>(5, 6, QMC::AccessPublic, QMetaType::Void),
        // Signal 'refCountChanged'
        QtMocHelpers::SignalData<void()>(7, 6, QMC::AccessPublic, QMetaType::Void),
        // Signal 'beat'
        QtMocHelpers::SignalData<void(smpl_t)>(8, 6, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 9, 10 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'bpm'
        QtMocHelpers::PropertyData<smpl_t>(10, 0x80000000 | 9, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 0),
        // property 'refCount'
        QtMocHelpers::PropertyData<int>(11, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
    };
    QtMocHelpers::UintData qt_enums {
    };
    QtMocHelpers::UintData qt_constructors {};
    QtMocHelpers::ClassInfos qt_classinfo({
            {    1,    2 },
            {    3,    4 },
    });
    return QtMocHelpers::metaObjectData<BeatTracker, void>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums, qt_constructors, qt_classinfo);
}
Q_CONSTINIT const QMetaObject caelestia::BeatTracker::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN9caelestia11BeatTrackerE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN9caelestia11BeatTrackerE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN9caelestia11BeatTrackerE_t>.metaTypes,
    nullptr
} };

void caelestia::BeatTracker::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<BeatTracker *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->bpmChanged(); break;
        case 1: _t->refCountChanged(); break;
        case 2: _t->beat((*reinterpret_cast< std::add_pointer_t<smpl_t>>(_a[1]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (BeatTracker::*)()>(_a, &BeatTracker::bpmChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (BeatTracker::*)()>(_a, &BeatTracker::refCountChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (BeatTracker::*)(smpl_t )>(_a, &BeatTracker::beat, 2))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<smpl_t*>(_v) = _t->bpm(); break;
        case 1: *reinterpret_cast<int*>(_v) = _t->refCount(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 1: _t->setRefCount(*reinterpret_cast<int*>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *caelestia::BeatTracker::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *caelestia::BeatTracker::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN9caelestia11BeatTrackerE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int caelestia::BeatTracker::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 3)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 3)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 3;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 2;
    }
    return _id;
}

// SIGNAL 0
void caelestia::BeatTracker::bpmChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void caelestia::BeatTracker::refCountChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void caelestia::BeatTracker::beat(smpl_t _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 2, nullptr, _t1);
}
QT_WARNING_POP
