import QtQuick

// 滑块进度条
Rectangle {
    property color sliderColor: "green"
    property int maxVlaue: 100
    // property int value: circlePoint.x * 100 / (root.width - root.height)
    property int value: 0

    id: root
    radius: height / 2
    color: "gray"

    // 彩色条
    Rectangle{
        width: circlePoint.x + height
        height: root.height
        radius: height / 2
        color: root.sliderColor
    }

    // 圆点
    Rectangle{
        id: circlePoint
        x: root.value / root.maxVlaue * (root.width - root.height)
        width: root.height
        height: width
        radius: width / 2
        color: Qt.lighter(root.sliderColor)

        Text {
            anchors.centerIn: parent
            font.pixelSize: parent.width / 2
            color: Qt.darker(root.sliderColor)
            text: root.value
        }
    }

    MouseArea{
        anchors.fill: parent

        onClicked: {
            // if (mouseX < root.height / 2) circlePoint.x = 0
            // else if (mouseX > root.width - root.height / 2) circlePoint.x = root.width - root.height
            // else circlePoint.x = mouseX - root.height / 2
            if (mouseX < root.height / 2) root.value = 0
            else if (mouseX > root.width - root.height / 2) root.value = root.maxVlaue
            else root.value = (mouseX - root.height / 2) * root.maxVlaue / (root.width - root.height)
        }

        onPositionChanged: {
            // if (mouseX < root.height / 2) circlePoint.x = 0
            // else if (mouseX > root.width - root.height / 2) circlePoint.x = root.width - root.height
            // else circlePoint.x = mouseX - root.height / 2
            if (mouseX < root.height / 2) root.value = 0
            else if (mouseX > root.width - root.height / 2) root.value = root.maxVlaue
            else root.value = (mouseX - root.height / 2) * root.maxVlaue / (root.width - root.height)
        }
    }
}
