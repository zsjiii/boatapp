// Page1.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SerialPort 1.0
//import Network 1.0

Page {

    property var page2Object: null  // 用于接收Page2的实例

    background: Rectangle { color: "#f0f8ff" } // 淡蓝色背景

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20


        Column {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            width: parent.width * 0.8  // 添加宽度限制

            // 串口状态显示
            Text {
                id: statusText
                text: "串口状态: 未连接"
            }

            // 串口操作按钮
            Button {
                text: "打开串口"
                onClicked: {
                    var ports = serialPort.availablePorts()
                    if(ports.length > 0) {
                        if(serialPort.openPort("/dev/ttyHS3", 115200)) {
                            statusText.text = "串口状态: 已连接"
                            var hexData = "55 66 01 01 00 00 00 42 02 B5 C0"
                            var counter = 0
                            var timer = Qt.createQmlObject('import QtQuick 2.0; Timer { interval: 250; running: true; repeat: true }', parent)
                            timer.triggered.connect(function() {
                                if(counter < 3) {
                                    if(serialPort.sendData(hexData)) {
                                        console.log("数据发送成功", counter+1)
                                    } else {
                                        console.log("数据发送失败", counter)
                                    }
                                    counter++
                                } else {
                                    timer.stop()
                                    timer.destroy()
                                }
                            })
                        } else {
                            statusText.text = "串口状态: 连接失败"
                        }
                    } else {
                        statusText.text = "串口状态: 未找到可用串口"
                    }
                }
            }

            Button {
                text: "关闭串口"
                onClicked: {
                    var hexData = "55 66 01 01 00 00 00 42 00 F7 E0"
                    var counter = 0
                    var timer = Qt.createQmlObject('import QtQuick 2.0; Timer { interval: 250; running: true; repeat: true }', parent)
                    timer.triggered.connect(function() {
                        if(counter < 3) {
                            if(serialPort.sendData(hexData)) {
                                console.log("数据发送成功", counter+1)
                            } else {
                                console.log("数据发送失败", counter)
                            }
                            counter++
                        } else {
                            timer.stop()
                            timer.destroy()
                            serialPort.closePort()
                            statusText.text = "串口状态: 已关闭"
                        }
                    })
                }
            }

            // 网络状态显示
            Text {
                id: statusTextnet
                text: "网络状态: 未连接"
            }

            // UDP操作按钮
            Row {
                spacing: 10
                Button {
                    text: "绑定UDP端口"
                    width: 120  // 设置固定宽度
                    onClicked: {
                        if(udpManager.bind(12345)) {
                            statusTextnet.text = "网络状态: 已连接"
                            console.log("UDP端口绑定成功")
                        } else {
                            statusTextnet.text = "网络状态: 连接失败"
                            console.log("UDP端口绑定失败")
                        }
                    }
                }
                Button {
                    text: "发送UDP数据"
                    width: 120  // 设置固定宽度
                    onClicked: {
                        if(udpManager.sendData("测试数据", "192.168.1.100", 54321)) {
                            console.log("UDP数据发送成功")
                        } else {
                            console.log("UDP数据发送失败")
                        }
                    }
                }
            }
        }


        //添加UDP管理器实例
        Component.onCompleted: {
            // 连接信号（注意单例的信号需要这样连接）
            UdpManager.dataReceived.connect(function(data, sender, port) {
                console.log("收到UDP数据:", data, "来自:", sender, port)
            })
        }

        SerialPortManager {
            id: serialPort
            onDataReceived: {
                console.log("收到串口数据:", h16data)
                page2Object.updateChannelData(h16data,16)
                progressesPage.gasval = (h16data[1]-1500)/450*100
            }
            // onH16dataProcessed:
            // {
            //     //page2.updateChannelData(h16data,16)
            // }
        }
        // Image {
        //     source: "https://via.placeholder.com/300x200/1e90ff/ffffff?text=Page+1"
        //     Layout.alignment: Qt.AlignHCenter
        // }

        Button {
            text: "切换到页面二"
            Layout.alignment: Qt.AlignHCenter
            onClicked: tabBar.currentIndex = 1
        }
    }
}
