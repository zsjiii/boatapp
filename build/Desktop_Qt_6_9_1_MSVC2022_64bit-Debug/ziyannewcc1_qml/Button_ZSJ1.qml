// IconButton.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
Button {
    id: root
    property alias iconSource: icon.source
    //property alias iconColor: colorOverlay.color
    property alias tooltipText: tooltip.text

    implicitWidth: 40
    implicitHeight: 40

    background: Rectangle {
        color: root.down ? "#37474f" : "transparent"
        radius: 5
        border.color: root.hovered ? "#4fc3f7" : "transparent"
        border.width: 1
    }

    contentItem: Item {
        Image {
            id: icon
            anchors.centerIn: parent
            sourceSize.width: 24
            sourceSize.height: 24
            layer.enabled: true
            // layer.effect: ColorOverlay {
            //     id: colorOverlay
            //     color: "#f0f0f0"
            // }
        }
    }

    ToolTip {
        id: tooltip
        visible: parent.hovered
        delay: 500
        timeout: 3000
    }

    // 悬停动画
    Behavior on scale {
        NumberAnimation { duration: 150 }
    }

    states: [
        State {
            name: "hovered"
            when: root.hovered
            PropertyChanges {
                target: root
                scale: 1.1
            }
        }
    ]
}
