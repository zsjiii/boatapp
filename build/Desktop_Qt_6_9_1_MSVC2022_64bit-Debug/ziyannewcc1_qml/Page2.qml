// Page2.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
Page {
    background: Rectangle { color: "#fff0f5" }

    // 定义通道数据数组
    property var channelData: Array(16).fill(0) // 初始化为16个0

    // 更新通道数据的函数
    function updateChannelData(dataPtr, dataSize) {
        console.log("收到串口数据:", channelData[9],dataPtr[9])
        // 确保数据大小匹配
        if (dataSize !== 16) {
            console.error("Invalid data size. Expected 16, got", dataSize)
            return
        }

        // 更新通道数据
        for (var i = 0; i < dataSize; i++) {
            // 这里模拟从指针读取数据
            // 实际应用中，这里会通过C++接口读取指针数据
            // 为了演示，我们假设指针指向的数据是 i * 100 + dataOffset
            var dataOffset = Math.floor(Math.random() * 50) // 随机偏移量
            channelData[i] = dataPtr[i];
            console.log("收到串口数据:", channelData[i],dataPtr[i])
        }

        // 更新UI显示
        for (var j = 0; j < grid.children.length; j++) {
            var channelBox = grid.children[j]
            if (channelBox && channelBox.children[1]) {
                channelBox.children[1].children[0].text = channelData[j]
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        // 标题区域
        Text {
            text: "通道数据监控"
            font.pixelSize: 24
            font.bold: true
            color: "#ff69b4"
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
        }

        // 数字展示区域
        GridLayout {
            id: grid
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 20
            columns: 4
            rowSpacing: 15
            columnSpacing: 15

            // 创建16个数字框
            Repeater {
                model: 16

                ColumnLayout {
                    id: channelContainer
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 5

                    // 通道标签
                    Text {
                        text: "通道 " + (index + 1)
                        font.pixelSize: 14
                        font.bold: true
                        color: "#333"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    // 数字显示框
                    Rectangle {
                        id: numberBox
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        border {
                            width: 2
                            color: "black"
                        }
                        radius: 8
                        color: "white"

                        // 数字文本
                        Text {
                            id: valueText
                            anchors.centerIn: parent
                            text: channelData[index] // 绑定到通道数据
                            font.pixelSize: Math.min(parent.width, parent.height) * 0.4
                            font.bold: true
                            color: {
                                if (channelData[index] < 100) return "red"
                                else if (channelData[index] > 900) return "orange"
                                else return "#1e90ff"
                            }
                        }

                        // 鼠标悬停效果
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                numberBox.color = "#f0f8ff"
                                channelContainer.children[0].color = "#1e90ff"
                            }
                            onExited: {
                                numberBox.color = "white"
                                channelContainer.children[0].color = "#333"
                            }
                            onClicked: {
                                console.log("通道", index + 1, "值:", channelData[index])
                            }
                        }
                    }
                }
            }
        }


    }
}
