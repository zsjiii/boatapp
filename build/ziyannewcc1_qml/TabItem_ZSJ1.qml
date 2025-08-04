import QtQuick

// 页面标签项组件
Item {
    id: tabItem
    width: root.itemwidth*2
    height: root.height
    property string tabTitle: "标签"
    property string tabIcon: "•"
    property string tabDescription: "描述"
    property bool isActive: true

    Rectangle {
        anchors.fill: parent
        color: isActive ? "#e9ecef" : "transparent"
        //radius: 5

        // 激活指示器
        Rectangle {
            width: parent.width
            height: 3
            color: "#3498db"
            anchors.bottom: parent.bottom
            visible: isActive
        }
    }

    Row {
        anchors.fill: parent
        //anchors.leftMargin: 15
        //spacing: 10

        Image {
            source: tabIcon

            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Text {
                text: tabTitle
                font.pixelSize: 14
                font.bold: true
                color: "#343a40"
            }

            Text {
                text: tabDescription
                font.pixelSize: 14
                color: "#6c757d"
            }
        }
    }

    // 鼠标区域
    MouseArea {
        anchors.fill: parent
        onClicked: {
            // 这里可以添加标签点击逻辑
        }
    }
}
