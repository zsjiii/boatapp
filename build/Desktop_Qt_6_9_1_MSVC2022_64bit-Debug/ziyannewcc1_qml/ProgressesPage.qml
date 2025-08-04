import QtQuick 2.0
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
// 进度条页面
Item {
    anchors.margins: 20
    property double gasval: 0

    // 水波进度条
    RippleProgress{
        id: rippleProgress1
        anchors.left: parent.left
        width: 50
        height: 50
        valueColor: "#ff4400" //
    }
    Instrument {
        id: speed_car
        anchors.left: rippleProgress1.right
        anchors.top: parent.top-80
        width: 200
        height: 200
        // width: parent.width/4
        // height: parent.height/4
        dial_addR: -6
        dial_longNum: 10
        dial_longLen: 15
        dial_lineWidth: 3
        currentValue: gasval
        top_startAngle: 150
        btm_endAngle: 360+30
        btm_startAngle: 150
        btm_r: speed_car.width/4
        top_r: speed_car.width/4

        Text {
            id: speed
            anchors.centerIn: parent
            width: parent.width/2
            height: parent.height/2
            text: slider.value
            style: Text.Normal
            font.weight: Font.ExtraBold
            font.capitalization: Font.MixedCase
            font.pixelSize: 40
            font.bold: true
            font.family: "Verdana"
            horizontalAlignment: Text.AlignHCenter
        }

        Label {
            id: speed_label
            anchors.top:  speed.top
            width: parent.width/2
            height: parent.height/2
            text: qsTr("Km/h")
            font.pointSize: 11
            font.bold: true
            verticalAlignment: Text.AlignBottom
        }
    }

    Slider {
        id: slider
        x: 220
        y: 367
        font.pointSize: 14
        stepSize: 1
        to: 200
        from: 0
        value: 0

        onValueChanged: {
            if(value<60) {
                speed.color = "green"
            }
            else if(value<120) {
                speed.color = "#f2ac28"
            }
            else {
                speed.color = "red"
            }
            speed_label.color = speed.color
        }
    }



}
