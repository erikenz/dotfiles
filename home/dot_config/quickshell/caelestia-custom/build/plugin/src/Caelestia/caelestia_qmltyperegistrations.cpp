/****************************************************************************
** Generated QML type registration code
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <QtQml/qqml.h>
#include <QtQml/qqmlmoduleregistration.h>

#if __has_include(<beattracker.hpp>)
#  include <beattracker.hpp>
#endif
#if __has_include(<cachingimagemanager.hpp>)
#  include <cachingimagemanager.hpp>
#endif
#if __has_include(<cutils.hpp>)
#  include <cutils.hpp>
#endif
#if __has_include(<filesystemmodel.hpp>)
#  include <filesystemmodel.hpp>
#endif
#if __has_include(<qalculator.hpp>)
#  include <qalculator.hpp>
#endif


#if !defined(QT_STATIC)
#define Q_QMLTYPE_EXPORT Q_DECL_EXPORT
#else
#define Q_QMLTYPE_EXPORT
#endif
Q_QMLTYPE_EXPORT void qml_register_types_Caelestia()
{
    qmlRegisterModule("Caelestia", 0, 0);
    QT_WARNING_PUSH QT_WARNING_DISABLE_DEPRECATED
    QMetaType::fromType<QAbstractItemModel *>().id();
    qmlRegisterEnum<QAbstractItemModel::LayoutChangeHint>("QAbstractItemModel::LayoutChangeHint");
    qmlRegisterEnum<QAbstractItemModel::CheckIndexOption>("QAbstractItemModel::CheckIndexOption");
    QMetaType::fromType<QAbstractListModel *>().id();
    qmlRegisterTypesAndRevisions<caelestia::BeatTracker>("Caelestia", 0);
    qmlRegisterTypesAndRevisions<caelestia::CUtils>("Caelestia", 0);
    qmlRegisterTypesAndRevisions<caelestia::CachingImageManager>("Caelestia", 0);
    qmlRegisterTypesAndRevisions<caelestia::FileSystemEntry>("Caelestia", 0);
    qmlRegisterTypesAndRevisions<caelestia::FileSystemModel>("Caelestia", 0);
    qmlRegisterEnum<caelestia::FileSystemModel::Filter>("caelestia::FileSystemModel::Filter");
    qmlRegisterTypesAndRevisions<caelestia::Qalculator>("Caelestia", 0);
    QT_WARNING_POP
    qmlRegisterModule("Caelestia", 0, 1);
}

static const QQmlModuleRegistration caelestiaRegistration("Caelestia", qml_register_types_Caelestia);
