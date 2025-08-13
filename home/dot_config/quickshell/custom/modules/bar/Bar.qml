// import qs.services
// import qs.modules.common
// import qs.modules.common.widgets
// import qs.modules.common.functions
// import qs

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.UPower
import Quickshell.Wayland

Scope {
    id: bar

    Variants {
        model: Quickshell.screens

        delegate: Component {
            PanelWindow {
                // the screen from the screens list will be injected into this
                // property
                required property var modelData

                // we can then set the window's screen to the injected property
                screen: modelData
                implicitHeight: 30

                anchors {
                    top: true
                    left: true
                    right: true
                }

                Text {
                    id: clock

                    anchors.centerIn: parent

                    Process {
                        id: dateProc

                        command: ["date"]
                        running: true

                        stdout: StdioCollector {
                            onStreamFinished: clock.text = this.text
                        }

                    }

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: dateProc.running = true
                    }

                }

            }

        }

    }

}
