import "root:/widgets"
import "root:/services"
import "root:/config"
import "popouts" as BarPopouts
import "components"
import "components/workspaces"
import Quickshell
import QtQuick

Item {
    id: root

    required property ShellScreen screen
    required property PersistentProperties visibilities
    required property BarPopouts.Wrapper popouts

    // function checkPopout(y: real): void {
    //     const spacing = Appearance.spacing.small;
    //     const aw = activeWindow.child;
    //     const awy = activeWindow.y + aw.y;
    //
    //     const ty = tray.y;
    //     const th = tray.implicitHeight;
    //     const trayItems = tray.items;
    //
    //     const n = statusIconsInner.network;
    //     const ny = statusIcons.y + statusIconsInner.y + n.y - spacing / 2;
    //
    //     const bls = statusIcons.y + statusIconsInner.y + statusIconsInner.bs - spacing / 2;
    //     const ble = statusIcons.y + statusIconsInner.y + statusIconsInner.be + spacing / 2;
    //
    //     const b = statusIconsInner.battery;
    //     const by = statusIcons.y + statusIconsInner.y + b.y - spacing / 2;
    //
    //     if (y >= awy && y <= awy + aw.implicitHeight) {
    //         popouts.currentName = "activewindow";
    //         popouts.currentCenter = Qt.binding(() => activeWindow.y + aw.y + aw.implicitHeight / 2);
    //         popouts.hasCurrent = true;
    //     } else if (y > ty && y < ty + th) {
    //         const index = Math.floor(((y - ty) / th) * trayItems.count);
    //         const item = trayItems.itemAt(index);
    //
    //         popouts.currentName = `traymenu${index}`;
    //         popouts.currentCenter = Qt.binding(() => tray.y + item.y + item.implicitHeight / 2);
    //         popouts.hasCurrent = true;
    //     } else if (y >= ny && y <= ny + n.implicitHeight + spacing) {
    //         popouts.currentName = "network";
    //         popouts.currentCenter = Qt.binding(() => statusIcons.y + statusIconsInner.y + n.y + n.implicitHeight / 2);
    //         popouts.hasCurrent = true;
    //     } else if (y >= bls && y <= ble) {
    //         popouts.currentName = "bluetooth";
    //         popouts.currentCenter = Qt.binding(() => statusIcons.y + statusIconsInner.y + statusIconsInner.bs + (statusIconsInner.be - statusIconsInner.bs) / 2);
    //         popouts.hasCurrent = true;
    //     } else if (y >= by && y <= by + b.implicitHeight + spacing) {
    //         popouts.currentName = "battery";
    //         popouts.currentCenter = Qt.binding(() => statusIcons.y + statusIconsInner.y + b.y + b.implicitHeight / 2);
    //         popouts.hasCurrent = true;
    //     } else {
    //         popouts.hasCurrent = false;
    //     }
    // }
    function checkPopout(x: real): void {
        const spacing = Appearance.spacing.small;
        const aw = activeWindow.child;
        const awx = activeWindow.x + aw.x;

        const trayX = tray.x;
        const trayHeight = tray.implicitHeight;
        const trayItems = tray.items;

        const n = statusIconsInner.network;
        const nx = statusIcons.x + statusIconsInner.x + n.x - spacing / 2;

        const bls = statusIcons.x + statusIconsInner.x + statusIconsInner.bs - spacing / 2;
        const ble = statusIcons.x + statusIconsInner.x + statusIconsInner.be + spacing / 2;

        const b = statusIconsInner.battery;
        const bx = statusIcons.x + statusIconsInner.x + b.x - spacing / 2;

        if (x >= awx && x <= awx + aw.implicitWidth) {
            popouts.currentName = "activewindow";
            popouts.currentCenter = Qt.binding(() => activeWindow.x + aw.x + aw.implicitWidth / 2);
            popouts.hasCurrent = true;
        } else if (x > trayX && x < trayX + trayHeight) {
            const index = Math.floor(((x - trayX) / trayHeight) * trayItems.count);
            const item = trayItems.itemAt(index);

            popouts.currentName = `traymenu${index}`;
            popouts.currentCenter = Qt.binding(() => tray.x + item.x + item.implicitWidth / 2);
            popouts.hasCurrent = true;
        } else if (x >= nx && y <= nx + n.implicitWidth + spacing) {
            popouts.currentName = "network";
            popouts.currentCenter = Qt.binding(() => statusIcons.x + statusIconsInner.x + n.x + n.implicitWidth / 2);
            popouts.hasCurrent = true;
        } else if (x >= bls && x <= ble) {
            popouts.currentName = "bluetooth";
            popouts.currentCenter = Qt.binding(() => statusIcons.x + statusIconsInner.x + statusIconsInner.bs + (statusIconsInner.be - statusIconsInner.bs) / 2);
            popouts.hasCurrent = true;
        } else if (x >= bx && x <= bx + b.implicitWidth + spacing) {
            popouts.currentName = "battery";
            popouts.currentCenter = Qt.binding(() => statusIcons.x + statusIconsInner.x + b.x + b.implicitWidth / 2);
            popouts.hasCurrent = true;
        } else {
            popouts.hasCurrent = false;
        }
    }

    // anchors.top: parent.top
    // anchors.bottom: parent.bottom
    // anchors.left: parent.left
    anchors {
        left: parent.left
        right: parent.right
        top: parent.top
    }

    // implicitWidth: child.implicitWidth + Config.border.thickness * 2
    implicitHeight: child.implicitHeight + Config.border.thickness * 2

    Item {
        id: child

        // anchors.top: parent.top
        // anchors.bottom: parent.bottom
        // anchors.horizontalCenter: parent.horizontalCenter
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        // implicitWidth: Math.max(osIcon.implicitWidth, workspaces.implicitWidth, activeWindow.implicitWidth, tray.implicitWidth, clock.implicitWidth, statusIcons.implicitWidth, power.implicitWidth)
        implicitHeight: Math.max(osIcon.implicitHeight, workspaces.implicitHeight, activeWindow.implicitHeight, tray.implicitHeight, clock.implicitHeight, statusIcons.implicitHeight, power.implicitHeight)

        OsIcon {
            id: osIcon

            // anchors.horizontalCenter: parent.horizontalCenter
            // anchors.top: parent.top
            // anchors.topMargin: Appearance.padding.large
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: Appearance.padding.large
            }
        }

        StyledRect {
            id: workspaces

            // anchors.horizontalCenter: parent.horizontalCenter
            // anchors.top: osIcon.bottom
            // anchors.topMargin: Appearance.spacing.normal
            anchors {
                verticalCenter: parent.verticalCenter
                left: osIcon.right
                leftMargin: Appearance.spacing.normal
            }

            radius: Appearance.rounding.full
            color: Colours.palette.m3surfaceContainer

            implicitWidth: workspacesInner.implicitWidth + Appearance.padding.small * 2
            implicitHeight: workspacesInner.implicitHeight + Appearance.padding.small * 2

            CustomMouseArea {
                anchors.fill: parent
                anchors.leftMargin: -Config.border.thickness
                anchors.rightMargin: -Config.border.thickness

                function onWheel(event: WheelEvent): void {
                    const activeWs = Hyprland.activeToplevel?.workspace?.name;
                    if (activeWs?.startsWith("special:"))
                        Hyprland.dispatch(`togglespecialworkspace ${activeWs.slice(8)}`);
                    else if (event.angleDelta.y < 0 || Hyprland.activeWsId > 1)
                        Hyprland.dispatch(`workspace r${event.angleDelta.y > 0 ? "-" : "+"}1`);
                }
            }

            Workspaces {
                id: workspacesInner

                anchors.centerIn: parent
            }
        }

        ActiveWindow {
            id: activeWindow

            // anchors.horizontalCenter: parent.horizontalCenter
            // anchors.top: workspaces.bottom
            // anchors.bottom: tray.top
            // anchors.margins: Appearance.spacing.large
            anchors {
                left: workspaces.right
                verticalCenter: parent.verticalCenter
                right: tray.left
                margins: Appearance.spacing.large
            }

            monitor: Brightness.getMonitorForScreen(root.screen)
        }

        Tray {
            id: tray

            // anchors.horizontalCenter: parent.horizontalCenter
            // anchors.bottom: clock.top
            // anchors.bottomMargin: Appearance.spacing.larger
            anchors {
                verticalCenter: parent.verticalCenter
                right: clock.left
                rightMargin: Appearance.spacing.large
            }
        }

        Clock {
            id: clock

            // anchors.horizontalCenter: parent.horizontalCenter
            // anchors.bottom: statusIcons.top
            // anchors.bottomMargin: Appearance.spacing.normal
            anchors {
                verticalCenter: parent.verticalCenter
                right: statusIcons.left
                rightMargin: Appearance.spacing.normal
            }
        }

        StyledRect {
            id: statusIcons

            anchors {
                right: power.left
                rightMargin: Appearance.spacing.normal
                top: parent.top
                bottom: parent.bottom
            }
            // anchors.left: parent.left
            // anchors.right: parent.right
            // anchors.bottom: power.top
            // anchors.bottomMargin: Appearance.spacing.normal

            radius: Appearance.rounding.full
            color: Colours.palette.m3surfaceContainer

            // implicitHeight: statusIconsInner.implicitHeight + Appearance.padding.normal * 2
            implicitWidth: statusIconsInner.implicitWidth + Appearance.padding.normal * 2

            StatusIcons {
                id: statusIconsInner

                anchors.centerIn: parent
            }
        }

        Power {
            id: power

            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: Appearance.padding.large
            }
            // anchors.horizontalCenter: parent.horizontalCenter
            // anchors.bottom: parent.bottom
            // anchors.bottomMargin: Appearance.padding.large

            visibilities: root.visibilities
        }
    }
}
