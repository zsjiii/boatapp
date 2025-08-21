import QtQuick

Rectangle {
    id: root
    
    // 属性定义
    property color checkColor: "green"
    property bool isChecked: false
    property string labelTextoff: "关"
    property string labelTexton: "开"
    
    // 添加一个信号，用于通知外部按钮被点击
    signal clicked()
    
    radius: height / 2
    color: root.isChecked ? root.checkColor : "#606060"
    border.color: Qt.lighter(color)

    Behavior on color {
        ColorAnimation {
            duration: 500
        }
    }

    // 圆点
    Rectangle{
        id: buttoncircle
        anchors.verticalCenter: root.verticalCenter
        x: root.isChecked ? root.width - root.height * 0.9 : root.height * 0.1
        width: root.height * 0.8
        height: width
        radius: width / 2
        color: "white"

        Behavior on x{
            NumberAnimation{
                duration: 500
            }
        }
    }
    
    Item {
        anchors.left: root.isChecked ?  root.left : buttoncircle.right
        anchors.right: root.isChecked ?  buttoncircle.left : parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        Text {
            anchors.centerIn: parent
            color: root.isChecked ? "white" : "green"
            style: Text.Outline
            styleColor: "steelblue"
            font.pixelSize: root.height / 3
            text: root.isChecked ? root.labelTexton : root.labelTextoff
        }
    }
    
    MouseArea{
        anchors.fill: parent
        onClicked: {
            root.clicked() // 发出点击信号，让外部处理互斥逻辑
        }
    }
}