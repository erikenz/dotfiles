pragma ComponentBehavior: Bound

import "root:/widgets"
import "root:/services"
import "root:/config"
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property ShellScreen screen
    required property HyprlandToplevel client

    // Layout.preferredWidth: preview.implicitWidth + Appearance.padding.large * 2
    Layout.preferredHeight: preview.implicitHeight + Appearance.padding.large * 2
    Layout.fillHeight: true

    StyledClippingRect {
        id: preview

        // anchors.horizontalCenter: parent.horizontalCenter
        // anchors.top: parent.top
        // anchors.bottom: label.top
        // anchors.topMargin: Appearance.padding.large
        // anchors.bottomMargin: Appearance.spacing.normal
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: label.left
            leftMargin: Appearance.padding.large
            rightMargin: Appearance.spacing.large
        }

        // implicitWidth: view.implicitWidth
        implicitHeight: view.implicitHeight

        color: Colours.palette.m3surfaceContainer
        radius: Appearance.rounding.small

        Loader {
            anchors.centerIn: parent
            active: !root.client
            asynchronous: true

            sourceComponent: ColumnLayout {
                spacing: 0

                MaterialIcon {
                    Layout.alignment: Qt.AlignHCenter
                    text: "web_asset_off"
                    color: Colours.palette.m3outline
                    font.pointSize: Appearance.font.size.extraLarge * 3
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: qsTr("No active client")
                    color: Colours.palette.m3outline
                    font.pointSize: Appearance.font.size.extraLarge
                    font.weight: 500
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: qsTr("Try switching to a window")
                    color: Colours.palette.m3outline
                    font.pointSize: Appearance.font.size.large
                }
            }
        }

        ScreencopyView {
            id: view

            anchors.centerIn: parent

            captureSource: root.client?.wayland ?? null
            live: true

            // constraintSize.width: root.client ? parent.height * Math.min(root.screen.width / root.screen.height, root.client?.lastIpcObject.size[0] / root.client?.lastIpcObject.size[1]) : parent.height
            // constraintSize.height: parent.height
            constraintSize.width: parent.width
            constraintSize.height: root.client ? parent.width * Math.min(root.screen.height / root.screen.width, root.client?.lastIpcObject.size[1] / root.client?.lastIpcObject.size[0]) : parent.width
        }
    }

    StyledText {
        id: label

        // anchors.horizontalCenter: parent.horizontalCenter
        // anchors.bottom: parent.bottom
        // anchors.bottomMargin: Appearance.padding.large
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: Appearance.padding.large
        }

        animate: true
        text: {
            const client = root.client;
            if (!client)
                return qsTr("No active client");

            const mon = client.monitor;
            return qsTr("%1 on monitor %2 at %3, %4").arg(client.title).arg(mon.name).arg(client.lastIpcObject.at[0]).arg(client.lastIpcObject.at[1]);
        }
    }
}
