/****************************************************************************
** Meta object code from reading C++ file 'filesystemmodel.hpp'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../plugin/src/Caelestia/filesystemmodel.hpp"
#include <QtCore/qmetatype.h>
#include <QtCore/QList>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'filesystemmodel.hpp' doesn't include <QObject>."
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
struct qt_meta_tag_ZN9caelestia15FileSystemEntryE_t {};
} // unnamed namespace

template <> constexpr inline auto caelestia::FileSystemEntry::qt_create_metaobjectdata<qt_meta_tag_ZN9caelestia15FileSystemEntryE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "caelestia::FileSystemEntry",
        "QML.Element",
        "auto",
        "QML.Creatable",
        "false",
        "QML.UncreatableReason",
        "FileSystemEntry instances can only be retrieved from a FileSystemM"
        "odel",
        "path",
        "relativePath",
        "name",
        "parentDir",
        "suffix",
        "size",
        "isDir",
        "isImage",
        "mimeType"
    };

    QtMocHelpers::UintData qt_methods {
    };
    QtMocHelpers::UintData qt_properties {
        // property 'path'
        QtMocHelpers::PropertyData<QString>(7, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Constant),
        // property 'relativePath'
        QtMocHelpers::PropertyData<QString>(8, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Constant),
        // property 'name'
        QtMocHelpers::PropertyData<QString>(9, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Constant),
        // property 'parentDir'
        QtMocHelpers::PropertyData<QString>(10, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Constant),
        // property 'suffix'
        QtMocHelpers::PropertyData<QString>(11, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Constant),
        // property 'size'
        QtMocHelpers::PropertyData<qint64>(12, QMetaType::LongLong, QMC::DefaultPropertyFlags | QMC::Constant),
        // property 'isDir'
        QtMocHelpers::PropertyData<bool>(13, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Constant),
        // property 'isImage'
        QtMocHelpers::PropertyData<bool>(14, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Constant),
        // property 'mimeType'
        QtMocHelpers::PropertyData<QString>(15, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Constant),
    };
    QtMocHelpers::UintData qt_enums {
    };
    QtMocHelpers::UintData qt_constructors {};
    QtMocHelpers::ClassInfos qt_classinfo({
            {    1,    2 },
            {    3,    4 },
            {    5,    6 },
    });
    return QtMocHelpers::metaObjectData<FileSystemEntry, void>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums, qt_constructors, qt_classinfo);
}
Q_CONSTINIT const QMetaObject caelestia::FileSystemEntry::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN9caelestia15FileSystemEntryE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN9caelestia15FileSystemEntryE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN9caelestia15FileSystemEntryE_t>.metaTypes,
    nullptr
} };

void caelestia::FileSystemEntry::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<FileSystemEntry *>(_o);
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QString*>(_v) = _t->path(); break;
        case 1: *reinterpret_cast<QString*>(_v) = _t->relativePath(); break;
        case 2: *reinterpret_cast<QString*>(_v) = _t->name(); break;
        case 3: *reinterpret_cast<QString*>(_v) = _t->parentDir(); break;
        case 4: *reinterpret_cast<QString*>(_v) = _t->suffix(); break;
        case 5: *reinterpret_cast<qint64*>(_v) = _t->size(); break;
        case 6: *reinterpret_cast<bool*>(_v) = _t->isDir(); break;
        case 7: *reinterpret_cast<bool*>(_v) = _t->isImage(); break;
        case 8: *reinterpret_cast<QString*>(_v) = _t->mimeType(); break;
        default: break;
        }
    }
}

const QMetaObject *caelestia::FileSystemEntry::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *caelestia::FileSystemEntry::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN9caelestia15FileSystemEntryE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int caelestia::FileSystemEntry::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 9;
    }
    return _id;
}
namespace {
struct qt_meta_tag_ZN9caelestia15FileSystemModelE_t {};
} // unnamed namespace

template <> constexpr inline auto caelestia::FileSystemModel::qt_create_metaobjectdata<qt_meta_tag_ZN9caelestia15FileSystemModelE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "caelestia::FileSystemModel",
        "QML.Element",
        "auto",
        "pathChanged",
        "",
        "recursiveChanged",
        "watchChangesChanged",
        "showHiddenChanged",
        "filterChanged",
        "entriesChanged",
        "added",
        "const FileSystemEntry*",
        "entry",
        "removed",
        "path",
        "recursive",
        "watchChanges",
        "showHidden",
        "filter",
        "Filter",
        "entries",
        "QList<FileSystemEntry*>",
        "NoFilter",
        "Images",
        "Files",
        "Dirs"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'pathChanged'
        QtMocHelpers::SignalData<void()>(3, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'recursiveChanged'
        QtMocHelpers::SignalData<void()>(5, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'watchChangesChanged'
        QtMocHelpers::SignalData<void()>(6, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'showHiddenChanged'
        QtMocHelpers::SignalData<void()>(7, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'filterChanged'
        QtMocHelpers::SignalData<void()>(8, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'entriesChanged'
        QtMocHelpers::SignalData<void()>(9, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'added'
        QtMocHelpers::SignalData<void(const FileSystemEntry *)>(10, 4, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 11, 12 },
        }}),
        // Signal 'removed'
        QtMocHelpers::SignalData<void(const QString &)>(13, 4, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'path'
        QtMocHelpers::PropertyData<QString>(14, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 0),
        // property 'recursive'
        QtMocHelpers::PropertyData<bool>(15, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'watchChanges'
        QtMocHelpers::PropertyData<bool>(16, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 2),
        // property 'showHidden'
        QtMocHelpers::PropertyData<bool>(17, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 3),
        // property 'filter'
        QtMocHelpers::PropertyData<enum Filter>(18, 0x80000000 | 19, QMC::DefaultPropertyFlags | QMC::Writable | QMC::EnumOrFlag | QMC::StdCppSet, 4),
        // property 'entries'
        QtMocHelpers::PropertyData<QList<FileSystemEntry*>>(20, 0x80000000 | 21, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 5),
    };
    QtMocHelpers::UintData qt_enums {
        // enum 'Filter'
        QtMocHelpers::EnumData<enum Filter>(19, 19, QMC::EnumFlags{}).add({
            {   22, Filter::NoFilter },
            {   23, Filter::Images },
            {   24, Filter::Files },
            {   25, Filter::Dirs },
        }),
    };
    QtMocHelpers::UintData qt_constructors {};
    QtMocHelpers::ClassInfos qt_classinfo({
            {    1,    2 },
    });
    return QtMocHelpers::metaObjectData<FileSystemModel, void>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums, qt_constructors, qt_classinfo);
}
Q_CONSTINIT const QMetaObject caelestia::FileSystemModel::staticMetaObject = { {
    QMetaObject::SuperData::link<QAbstractListModel::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN9caelestia15FileSystemModelE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN9caelestia15FileSystemModelE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN9caelestia15FileSystemModelE_t>.metaTypes,
    nullptr
} };

void caelestia::FileSystemModel::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<FileSystemModel *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->pathChanged(); break;
        case 1: _t->recursiveChanged(); break;
        case 2: _t->watchChangesChanged(); break;
        case 3: _t->showHiddenChanged(); break;
        case 4: _t->filterChanged(); break;
        case 5: _t->entriesChanged(); break;
        case 6: _t->added((*reinterpret_cast< std::add_pointer_t<const FileSystemEntry*>>(_a[1]))); break;
        case 7: _t->removed((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (FileSystemModel::*)()>(_a, &FileSystemModel::pathChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (FileSystemModel::*)()>(_a, &FileSystemModel::recursiveChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (FileSystemModel::*)()>(_a, &FileSystemModel::watchChangesChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (FileSystemModel::*)()>(_a, &FileSystemModel::showHiddenChanged, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (FileSystemModel::*)()>(_a, &FileSystemModel::filterChanged, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (FileSystemModel::*)()>(_a, &FileSystemModel::entriesChanged, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (FileSystemModel::*)(const FileSystemEntry * )>(_a, &FileSystemModel::added, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (FileSystemModel::*)(const QString & )>(_a, &FileSystemModel::removed, 7))
            return;
    }
    if (_c == QMetaObject::RegisterPropertyMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 5:
            *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QList<FileSystemEntry*> >(); break;
        }
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QString*>(_v) = _t->path(); break;
        case 1: *reinterpret_cast<bool*>(_v) = _t->recursive(); break;
        case 2: *reinterpret_cast<bool*>(_v) = _t->watchChanges(); break;
        case 3: *reinterpret_cast<bool*>(_v) = _t->showHidden(); break;
        case 4: *reinterpret_cast<enum Filter*>(_v) = _t->filter(); break;
        case 5: *reinterpret_cast<QList<FileSystemEntry*>*>(_v) = _t->entries(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setPath(*reinterpret_cast<QString*>(_v)); break;
        case 1: _t->setRecursive(*reinterpret_cast<bool*>(_v)); break;
        case 2: _t->setWatchChanges(*reinterpret_cast<bool*>(_v)); break;
        case 3: _t->setShowHidden(*reinterpret_cast<bool*>(_v)); break;
        case 4: _t->setFilter(*reinterpret_cast<enum Filter*>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *caelestia::FileSystemModel::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *caelestia::FileSystemModel::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN9caelestia15FileSystemModelE_t>.strings))
        return static_cast<void*>(this);
    return QAbstractListModel::qt_metacast(_clname);
}

int caelestia::FileSystemModel::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QAbstractListModel::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 8)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 8;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 8)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 8;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    }
    return _id;
}

// SIGNAL 0
void caelestia::FileSystemModel::pathChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void caelestia::FileSystemModel::recursiveChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void caelestia::FileSystemModel::watchChangesChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void caelestia::FileSystemModel::showHiddenChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void caelestia::FileSystemModel::filterChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void caelestia::FileSystemModel::entriesChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}

// SIGNAL 6
void caelestia::FileSystemModel::added(const FileSystemEntry * _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 6, nullptr, _t1);
}

// SIGNAL 7
void caelestia::FileSystemModel::removed(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 7, nullptr, _t1);
}
QT_WARNING_POP
