import "root:/widgets"
import "root:/services"
import "root:/utils"
import "root:/config"
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property Item wrapper

    implicitWidth: Hyprland.activeToplevel ? child.implicitWidth : -Appearance.padding.large * 2
    implicitHeight: child.implicitHeight
    // implicitWidth: child.implicitWidth
    // implicitHeight: Hyprland.activeToplevel ? child.implicitHeight : -Appearance.padding.large * 2

    Column {
        // Row {
        id: child

        anchors.centerIn: parent
        spacing: Appearance.spacing.normal

        RowLayout {
            // ColumnLayout {
            id: detailsRow

            anchors.left: parent.left
            anchors.right: parent.right
            // anchors {
            //     top: parent.top
            //     bottom: parent.bottom
            // }
            spacing: Appearance.spacing.normal

            IconImage {
                id: icon

                Layout.alignment: Qt.AlignVCenter
                // Layout.alignment: Qt.AlignHCenter
                implicitSize: details.implicitHeight
                // implicitSize: details.implicitWidth
                source: Icons.getAppIcon(Hyprland.activeToplevel?.lastIpcObject.class ?? "", "image-missing")
            }

            ColumnLayout {
                // RowLayout {
                id: details

                spacing: 0
                Layout.fillWidth: true

                StyledText {
                    Layout.fillWidth: true
                    text: Hyprland.activeToplevel?.title ?? ""
                    font.pointSize: Appearance.font.size.normal
                    elide: Text.ElideRight
                }

                StyledText {
                    Layout.fillWidth: true
                    text: Hyprland.activeToplevel?.lastIpcObject.class ?? ""
                    color: Colours.palette.m3onSurfaceVariant
                    elide: Text.ElideRight
                }
            }

            Item {
                implicitWidth: expandIcon.implicitHeight + Appearance.padding.small * 2
                implicitHeight: expandIcon.implicitHeight + Appearance.padding.small * 2

                Layout.alignment: Qt.AlignVCenter
                // Layout.alignment: Qt.AlignHCenter

                StateLayer {
                    radius: Appearance.rounding.normal

                    function onClicked(): void {
                        root.wrapper.detach("winfo");
                    }
                }

                MaterialIcon {
                    id: expandIcon

                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: font.pointSize * 0.05
                    // anchors.verticalCenterOffset: font.pointSize * 0.05

                    text: "chevron_right"

                    font.pointSize: Appearance.font.size.large
                }
            }
        }

        ClippingWrapperRectangle {
            color: "transparent"
            radius: Appearance.rounding.small

            ScreencopyView {
                id: preview

                captureSource: Hyprland.activeToplevel?.wayland ?? null
                live: visible

                constraintSize.width: Config.bar.sizes.windowPreviewSize
                constraintSize.height: Config.bar.sizes.windowPreviewSize
            }
        }
    }
}
