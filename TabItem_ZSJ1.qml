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
    property int tabIndex: 0 // 新增：每个标签的索引标识

    // 添加clicked信号
    signal clicked(int index)

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

        Text { // 将Image改为Text显示图标
            text: tabIcon
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Text {
                text: tabTitle
                font.pixelSize: 14
                font.bold: isActive
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
            // 发出点击信号，携带当前标签的索引
            tabItem.clicked(tabIndex)
            // 这里可以添加标签点击逻辑
        }
    }
}
