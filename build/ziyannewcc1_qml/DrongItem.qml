import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15

Item {
    id: mainWindow
    width: 800
    height: 600
    visible: true
    // title: "飞机姿态显示仪表"

    // 姿态仪控件
    Item {
        id: attitudeIndicator
        width: Math.min(parent.width, parent.height) * 0.4
        height: width
        anchors.centerIn: parent

        // 外部圆形框架
        Shape {
            id: outerCircle
            anchors.fill: parent
            layer.enabled: true
            layer.samples: 8

            ShapePath {
                fillColor: "#2c3e50"
                strokeColor: "#3498db"
                strokeWidth: 4
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: attitudeIndicator.width / 2
                    centerY: attitudeIndicator.height / 2
                    radiusX: attitudeIndicator.width / 2 - 2
                    radiusY: attitudeIndicator.height / 2 - 2
                    startAngle: 0
                    sweepAngle: 360
                }
            }
        }

        // 滚转角指示器
        // Rectangle {
        //     id: rollIndicator
        //     width: attitudeIndicator.width * 0.95
        //     height: 30
        //     color: "transparent"
        //     border.color: "#e74c3c"
        //     border.width: 2
        //     radius: 15
        //     anchors.horizontalCenter: parent.horizontalCenter
        //     y: attitudeIndicator.height * 0.15

        //     // 滚转标记
        //     Rectangle {
        //         id: rollMarker
        //         width: 6
        //         height: 20
        //         color: "#e74c3c"
        //         anchors.verticalCenter: parent.verticalCenter
        //         x: parent.width / 2 - width / 2
        //     }

        //     // 刻度
        //     Repeater {
        //         model: 7
        //         Rectangle {
        //             width: 2
        //             height: 10
        //             color: "#e74c3c"
        //             anchors.verticalCenter: parent.verticalCenter
        //             x: (index - 3) * (rollIndicator.width / 7) + rollIndicator.width / 2 - width / 2
        //         }
        //     }

        //     Text {
        //         text: "ROLL"
        //         color: "#ecf0f1"
        //         font.pixelSize: 12
        //         anchors.bottom: parent.top
        //         anchors.bottomMargin: 5
        //         anchors.horizontalCenter: parent.horizontalCenter
        //     }
        // }

        // 内部姿态球
        Item {
            id: attitudeBall
            width: attitudeIndicator.width * 0.4
            height: width
            anchors.centerIn: parent

            // 天空部分
            Shape {
                id: sky
                anchors.fill: parent
                //layer.enabled: true
                //layer.samples: 8

                ShapePath {
                    fillColor: "green"
                    //strokeColor: "#3498db"
                    //strokeWidth: 4
                    //capStyle: ShapePath.RoundCap

                    PathAngleArc {
                        centerX: attitudeBall.width / 2
                        centerY: attitudeBall.height / 2
                        radiusX: attitudeBall.width / 2 - 2
                        radiusY: attitudeBall.height / 2 - 2
                        startAngle: 0
                        sweepAngle: 180
                    }
                }
                transform: Rotation {
                    origin.x: attitudeBall.width / 2
                    origin.y: attitudeBall.height / 2
                    angle: rollControl.value
                }
            }

            // 地面部分
            Shape {
                id: ground
                anchors.fill: parent
                //layer.enabled: true
                //layer.samples: 8

                ShapePath {
                    fillColor: "#8b4513"
                    // strokeColor: "#3498db"
                    // strokeWidth: 4
                    //capStyle: ShapePath.RoundCap

                    PathAngleArc {
                        centerX: attitudeBall.width / 2
                        centerY: attitudeBall.height / 2
                        radiusX: attitudeBall.width / 2 - 2
                        radiusY: attitudeBall.height / 2 - 2
                        startAngle: 180
                        sweepAngle: 180
                    }
                }
                transform: Rotation {
                    origin.x: attitudeBall.width / 2
                    origin.y: attitudeBall.height / 2
                    angle: rollControl.value
                }
            }

            // 地平线
            Rectangle {
                width: parent.width * 1.2
                height: 3
                color: "#f1c40f"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                transform: Rotation {
                    origin.x: attitudeBall.width / 2
                    origin.y: attitudeBall.height / 2
                    angle: rollControl.value
                }
            }

            // 俯仰刻度
            Repeater {
                model: 9
                Rectangle {
                    width: 40
                    height: 2
                    color: "#ecf0f1"
                    x: attitudeBall.width / 2 - width / 2
                    y: (index - 4) * 30 + (pitchControl.value * 10)
                    transform: Rotation {
                        origin.x: width / 2
                        origin.y: height / 2
                        angle: rollControl.value
                    }

                    Text {
                        text: Math.abs((index - 4) * 10)
                        color: "#ecf0f1"
                        font.pixelSize: 10
                        anchors.verticalCenter: parent.verticalCenter
                        x: parent.width + 5
                    }
                }
            }

            // 飞机标志
            Shape {
                anchors.centerIn: parent
                ShapePath {
                    strokeColor: "#e74c3c"
                    strokeWidth: 3
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap

                    PathMove { x: -40; y: 0 }
                    PathLine { x: -20; y: 0 }
                    PathMove { x: 40; y: 0 }
                    PathLine { x: 20; y: 0 }
                    PathMove { x: 0; y: -20 }
                    PathLine { x: 0; y: 20 }
                }
            }
        }

        // 偏航指示器
        Rectangle {
            id: yawIndicator
            width: attitudeIndicator.width * 0.2
            height: 30
            color: "#2c3e50"
            border.color: "#2ecc71"
            border.width: 2
            radius: 5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20

            Rectangle {
                width: 4
                height: parent.height
                color: "#2ecc71"
                x: parent.width / 2 + (yawControl.value * parent.width / 2 / 45) - width / 2
            }

            Text {
                text: "YAW"
                color: "#ecf0f1"
                font.pixelSize: 12
                anchors.bottom: parent.top
                anchors.bottomMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    // 控制面板
    Rectangle {
        width: parent.width
        height: 120
        color: "#2c3e50"
        anchors.bottom: parent.bottom

        Column {
            anchors.centerIn: parent
            spacing: 10

            Text {
                text: "飞机姿态控制"
                color: "#ecf0f1"
                font.bold: true
                font.pixelSize: 16
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                spacing: 30

                // 俯仰控制
                Column {
                    spacing: 5

                    Text {
                        text: "俯仰 (Pitch)"
                        color: "#ecf0f1"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Slider {
                        id: pitchControl
                        width: 150
                        from: -30
                        to: 30
                        value: 0
                    }

                    Text {
                        text: pitchControl.value.toFixed(1) + "°"
                        color: "#3498db"
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // 滚转控制
                Column {
                    spacing: 5

                    Text {
                        text: "滚转 (Roll)"
                        color: "#ecf0f1"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Slider {
                        id: rollControl
                        width: 150
                        from: -45
                        to: 45
                        value: 0
                    }

                    Text {
                        text: rollControl.value.toFixed(1) + "°"
                        color: "#e74c3c"
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // 偏航控制
                Column {
                    spacing: 5

                    Text {
                        text: "偏航 (Yaw)"
                        color: "#ecf0f1"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Slider {
                        id: yawControl
                        width: 150
                        from: -45
                        to: 45
                        value: 0
                    }

                    Text {
                        text: yawControl.value.toFixed(1) + "°"
                        color: "#2ecc71"
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            // 重置按钮
            Button {
                text: "重置姿态"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    pitchControl.value = 0
                    rollControl.value = 0
                    yawControl.value = 0
                }
                background: Rectangle {
                    color: "#e74c3c"
                    radius: 5
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    // 标题
    Text {
        text: "飞机姿态显示仪表"
        color: "#ecf0f1"
        font.pixelSize: 28
        font.bold: true
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
    }

    // 状态信息
    Text {
        text: "俯仰: " + pitchControl.value.toFixed(1) + "° | " +
              "滚转: " + rollControl.value.toFixed(1) + "° | " +
              "偏航: " + yawControl.value.toFixed(1) + "°"
        color: "#bdc3c7"
        font.pixelSize: 14
        anchors.bottom: attitudeIndicator.top
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
