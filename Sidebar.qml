import QtQuick

// 侧边栏
Item {
    property color backTopColor: "transparent"
    property color backBottomColor: "transparent"
    property bool sidebarChecked: false
    property int currentIndex: 0

    id: root

    Behavior on width{
        NumberAnimation{
            duration: 500
        }
    }

    // 背景
    Rectangle{
        id: background
        color: "transparent"
        //radius: 20
        width: root.width
        //anchors.right: root.right
        anchors.top: root.top
        anchors.bottom: root.bottom
        border.color: "transparent" //"#80ffffff"

        gradient: Gradient{
            GradientStop{position:0.0;color: root.backTopColor}
            GradientStop{position:1;color: root.backBottomColor}
        }
    }

    /*SidebarItem{
        id: menu
        width: root.width
        height: 40
        anchors.top: root.top
        //anchors.bottom: listView.top

        MouseArea{
            anchors.fill: parent
            onClicked: root.sidebarChecked = !root.sidebarChecked
        }
    }*/

    // 页面标签
    ListView{
        id: listView
        //anchors.centerIn: parent
        //anchors.right: root.right
        anchors.top: root.top//menu.bottom
        width: root.width
        height: root.height//Math.min(listView.count * 40, root.height)
        clip: true
        // focus: true

        // 标签信息
        model: ListModel{
            ListElement{labelText: "按钮"; labelIcon: "qrc:/image/res/switch.png"}
            ListElement{labelText: "进度条"; labelIcon: "qrc:/image/res/progress.png"}
            ListElement{labelText: "编辑"; labelIcon: "qrc:/image/res/edit.png"}
            ListElement{labelText: "表格"; labelIcon: "qrc:/image/res/table.png"}
            ListElement{labelText: "home点"; }
            ListElement{labelText: "航点设置"; }
            ListElement{labelText: "返航"; }
            ListElement{labelText: "任务暂停"; }
            ListElement{labelText: "任务删除"; }
            ListElement{labelText: "定速巡航"; }
        }

        // 侧边栏部件
        delegate: SidebarItem{
            id: siderbarItem
            width: root.width
            height: 40
            //anchors.left: root.left
            //anchors.leftMargin: 10
            text: labelText
            //iconSource: labelIcon

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    listView.currentIndex = index
                    root.currentIndex = index
                    siderbarItem.isHover = false
                }
                onEntered: if(listView.currentIndex !== index) siderbarItem.isHover = true
                onExited: siderbarItem.isHover = false
            }
        }

        highlight: Rectangle{
            color: "#40ffffff"
            radius: 20
        }

        onCurrentIndexChanged: root.currentIndex = listView.currentIndex
    }


    //
}
