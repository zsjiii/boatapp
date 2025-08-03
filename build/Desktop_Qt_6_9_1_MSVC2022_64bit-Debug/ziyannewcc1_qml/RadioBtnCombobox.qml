import QtQuick

// 单选按钮组
Rectangle{
    property ListModel listModel: ListModel{}
    property color checkColor: "green"

    id: root
    color: "#80444444"
    border.color: "white"
    radius: height / listModel.count / 2

    ListView{
        id: listView
        anchors.fill: parent

        model: root.listModel

        // 单选元素
        delegate: Item {
            width: root.width
            height: root.height / root.listModel.count

            // 圆点
            Item {
                id: btn
                width: parent.height
                height: width

                Rectangle{
                    anchors.centerIn: parent
                    width: parent.height * 0.6
                    height: width
                    radius: width / 2
                    color: "transparent"
                    border.color: listView.currentIndex === index ? root.checkColor : "gray"
                    border.width: width / 4

                    Behavior on border.color {
                        ColorAnimation {
                            duration: 500
                        }
                    }
                }
            }

            // 单选文字
            Text {
                anchors.left: btn.right
                height: parent.height
                text: labelText
                verticalAlignment: Text.AlignVCenter
                color: "white"
                // font.family: "华文彩云"
                style: Text.Outline
                styleColor: "steelblue"
                font.pixelSize: parent.height / 2
            }

            MouseArea{
                anchors.fill: parent
                onClicked: listView.currentIndex = index
            }
        }

        highlight: highlightComponent
        interactive: false // 不可滑动
    }

    // 高亮
    Component{
        id: highlightComponent

        Rectangle{
            width: root.width
            height: root.height / root.listModel.count
            color: "#40ffffff"
            radius: height / 2
        }
    }
}
