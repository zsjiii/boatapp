import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

// 自定义组件：带标签的滑块
ColumnLayout {
    property string label: ""
    property real value: 0
    property real min: 0
    property real max: 100
    property string unit: ""

    //signal valueChanged(real newValue)

    Layout.fillWidth: true

    RowLayout {
        Layout.fillWidth: true

        Text {
            text: label
            color: "#7f8c8d"
            font.pixelSize: 14
            Layout.fillWidth: true
        }

        Text {
            text: value.toFixed(1) + " " + unit
            color: "#3498db"
            font.bold: true
        }
    }

    Slider {
        value: parent.value
        from: parent.min
        to: parent.max
        stepSize: 1
        onMoved: {
            parent.value = value;
            parent.valueChanged(value);
        }
        Layout.fillWidth: true

        background: Rectangle {
            x: parent.leftPadding
            y: parent.topPadding + parent.availableHeight / 2 - height / 2
            implicitWidth: 200
            implicitHeight: 4
            width: parent.availableWidth
            height: implicitHeight
            radius: 2
            color: "#e0e0e0"

            Rectangle {
                width: parent.width * (parent.parent.value - parent.parent.from) / (parent.parent.to - parent.parent.from)
                height: parent.height
                color: "#3498db"
                radius: 2
            }
        }

        handle: Rectangle {
            x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
            y: parent.topPadding + parent.availableHeight / 2 - height / 2
            implicitWidth: 20
            implicitHeight: 20
            radius: 10
            color: parent.pressed ? "#2980b9" : "#3498db"
            border.color: "white"
            border.width: 2
        }
    }
}