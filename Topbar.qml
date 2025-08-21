import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
//import QtGraphicalEffects 1.15
import Qt5Compat.GraphicalEffects
Item {
    id: root
    // width: parent.width
    //height: 70

    // 背景属性
    property color backTopColor: "#2c3e50"
    property color backBottomColor: "#1a2530"
    property bool menuExpanded: false
    property int currentIndex: 0
    property int itemnum: 10
    property int itemwidth: width/(itemnum*2)

    // 菜单项数据
    property var menuItems: [
        {name: "仪表盘", icon: "📊", color: "#3498db", hasDropdown: false},
        {name: "消息", icon: "✉️", color: "#2ecc71", hasDropdown: false},
        {name: "日历", icon: "📅", color: "#e74c3c", hasDropdown: false},
        {name: "文件", icon: "📁", color: "#f39c12", hasDropdown: true},
        {name: "设置", icon: "⚙️", color: "#9b59b6", hasDropdown: true},
        {name: "帮助", icon: "❓", color: "#d35400", hasDropdown: false}
    ]

    // 下拉菜单内容
    property var fileDropdownItems: [
        {name: "所有文件", icon: "📄"},
        {name: "最近文档", icon: "🕒"},
        {name: "我的收藏", icon: "⭐"},
        {name: "回收站", icon: "🗑️"}
    ]

    property var settingsDropdownItems: [
        {name: "账户设置", icon: "👤"},
        {name: "主题设置", icon: "🎨"},
        {name: "通知设置", icon: "🔔"},
        {name: "隐私设置", icon: "🔒"}
    ]

    // 背景
    Rectangle {
        id: background
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: root.backTopColor }
            GradientStop { position: 1.0; color: root.backBottomColor }
        }

        // 底部阴影
        layer.enabled: true
        // layer.effect: DropShadow {
        //     verticalOffset: 3
        //     radius: 10
        //     samples: 16
        //     color: "#80000000"
        // }
    }

    RowLayout {
        id: mainLayout
        anchors.fill: parent
        spacing: 0  // 取消默认间距

        // 应用Logo和标题
        //Row {
        //    id: appHeader
        //    //width: itemwidth*2
        //    //anchors.left: parent.left
        //    Layout.preferredWidth:Math.max(itemwidth, 150)
        //    Layout.fillHeight: true
        //    //anchors.leftMargin: 20
        //    //anchors.verticalCenter: parent.verticalCenter
        //    //spacing: 0
        //    // 图标
        //    Image {
        //        id: logo
        //        height: parent.height
        //        width: parent.height//parent.width/2
        //        source: "qrc:/image/res/bilibili.png"
        //        // onStatusChanged: {
        //        //     if (status === Image.Ready) {
        //        //         console.log("Image loaded successfully");
        //        //     } else if (status === Image.Error) {
        //        //         console.log("Image failed to load:", icon.source);
        //        //         console.log("Error string:", icon.errorString());
        //        //     }
        //        // }
        //    }
        //    Text {
        //        text: "天宇智远"
        //        width:parent.width/2
        //        color: "white"
        //        font.pixelSize: 16
        //        font.bold: true
        //        //anchors.verticalCenter: parent.verticalCenter
        //    }
        //}

        //MenuItem_ZSJ1 {
        //    id: zsjcaidanceshi
        //    //anchors.left: appHeader.right
        //    //anchors.centerIn: parent
        //    //spacing: 10
        //    Layout.preferredWidth: itemwidth
        //    Layout.fillHeight: true
        //    selectedSubItem: "控制模式"
        //    // menuText: modelData.name
        //    // menuIcon: modelData.icon
        //    // itemColor: modelData.color
        //    // hasDropdown: modelData.hasDropdown
        //    isActive: false //index === root.currentIndex
        //}

        // // 用户区域
        // Row {
        //     id: userArea
        //     anchors.right: parent.right
        //     anchors.rightMargin: 20
        //     anchors.verticalCenter: parent.verticalCenter
        //     spacing: 15

        //     // 通知图标
        //     Rectangle {
        //         width: 36
        //         height: 36
        //         radius: 18
        //         color: "#34495e"

        //         Text {
        //             text: "🔔"
        //             font.pixelSize: 18
        //             anchors.centerIn: parent
        //         }

        //         // 通知标记
        //         Rectangle {
        //             width: 12
        //             height: 12
        //             radius: 6
        //             color: "#e74c3c"
        //             anchors.top: parent.top
        //             anchors.right: parent.right
        //             anchors.margins: -2
        //             visible: true
        //         }
        //     }

        //     // 用户头像
        //     Rectangle {
        //         width: 40
        //         height: 40
        //         radius: 20
        //         color: "#3498db"

        //         Image {
        //             source: "https://randomuser.me/api/portraits/men/32.jpg"
        //             anchors.fill: parent
        //             fillMode: Image.PreserveAspectCrop
        //             layer.enabled: true
        //             layer.effect: OpacityMask {
        //                 maskSource: Rectangle {
        //                     width: parent.width
        //                     height: parent.height
        //                     radius: width/2
        //                 }
        //             }
        //         }
        //     }

        //     // 用户名和下拉箭头
        //     Column {
        //         anchors.verticalCenter: parent.verticalCenter

        //         Text {
        //             text: "John Smith"
        //             color: "white"
        //             font.pixelSize: 14
        //         }

        //         Text {
        //             text: "管理员"
        //             color: "#bdc3c7"
        //             font.pixelSize: 12
        //         }
        //     }

        //     Text {
        //         text: "▼"
        //         color: "white"
        //         font.pixelSize: 12
        //         anchors.verticalCenter: parent.verticalCenter
        //     }
        // }

        Popup {
            id: modeSelectionPopup
            width: 400
            height: 500
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
            padding: 20

            background: Rectangle {
                color: "white"
                radius: 12
                border.color: "#ddd"
                border.width: 1
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 15

                // 标题
                Text {
                    text: "选择航行模式"
                    font.pixelSize: 22
                    font.bold: true
                    color: "#2c3e50"
                    Layout.alignment: Qt.AlignHCenter
                }

                // 分隔线
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#ecf0f1"
                }

                // 模式列表
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: 4
                    spacing: 10
                    clip: true

                    delegate: Rectangle {
                        width: ListView.view.width
                        height: 80
                        color: index === currentIndex ? 
                            (index === 3 ? "#fff3cd" : "#e3f2fd") : 
                            (mouseArea.containsMouse ? "#f8f9fa" : "white")
                        border.color: index === currentIndex ? 
                                    (index === 3 ? "#ffc107" : "#2196f3") : 
                                    "#e9ecef"
                        radius: 8

                        Row {
                            anchors.fill: parent
                            anchors.margins: 15
                            spacing: 15
                            anchors.verticalCenter: parent.verticalCenter

                            // 模式图标
                            Text {
                                text: modeIcons[index]
                                font.pixelSize: 28
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            // 模式信息
                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 5
                                width: parent.width - 70

                                Text {
                                    text: flightModes[index]
                                    font.pixelSize: 16
                                    font.bold: true
                                    color: index === currentIndex ? 
                                        (index === 3 ? "#856404" : "#1976d2") : 
                                        "#2c3e50"
                                }

                                Text {
                                    text: modeDescriptions[index]
                                    font.pixelSize: 12
                                    color: index === currentIndex ? 
                                        (index === 3 ? "#856404" : "#546e7a") : 
                                        "#7f8c8d"
                                    width: parent.width
                                    wrapMode: Text.WordWrap
                                }
                            }

                            // 选中标记
                            Text {
                                text: "✓"
                                visible: index === currentIndex
                                font.pixelSize: 18
                                color: index === 3 ? "#856404" : "#1976d2"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                            }
                        }

                        // 鼠标交互区域
                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                currentIndex = index
                                modeSelectionPopup.close()
                                modeChangePopup.open()
                                console.log("切换到模式:", flightModes[index])
                            }
                        }
                    }
                }

                // 分隔线
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#ecf0f1"
                }

                // 操作按钮
                Row {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 15

                    Button {
                        text: "确认"
                        onClicked: modeSelectionPopup.close()
                        background: Rectangle {
                            color: "#3498db"
                            radius: 6
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "white"
                        }
                    }

                    Button {
                        text: "取消"
                        onClicked: modeSelectionPopup.close()
                        flat: true
                    }
                }
            }
        }

        // 页面标签区域
        Rectangle {
            id: tabBar
            //anchors.left: zsjcaidanceshi.right
            //anchors.centerIn: parent
            Layout.preferredWidth:Math.max(itemwidth*3, 100)
            Layout.fillHeight: true
            //height: parent.height
            //anchors.top: background.top
            //anchors.bottom:  background.bottom
            color: "#f8f9fa"
            //visible: root.menuExpanded

            // 标签项
            Row {
                anchors.fill: parent
                //anchors.leftMargin: 20
                spacing: 0

                TabItem_ZSJ1 {
                    tabTitle: "解锁状态"
                    tabIcon: ""
                    tabDescription: "🔑"//🔑🔓
                    onClicked: {
                    // 显示数字选择弹窗
                       //unlockPopup.open()
                        cmdSed.Ctrl_Cmd_Send(0x04,0x01)
                        //cmdSed.Ctrl_Cmd_Send(0x04,0x02)
                    }
                }

                TabItem_ZSJ1 {
                    tabTitle: "航行状态"
                    tabIcon: ""
                    tabDescription: "悬停"
                    onClicked: {
                    // 显示数字选择弹窗
                        modeSelectionPopup.open()
                    }
                }

                //TabItem_ZSJ1 {
                //    tabTitle: "控制模式"
                //    tabIcon: ""
                //    tabDescription: "无人控制"
                //}

                TabItem_ZSJ1 {
                    tabTitle: "经纬度"
                    tabIcon: ""
                    tabDescription: "120"
                }

                TabItem_ZSJ1 {
                    tabTitle: "水深"
                    tabIcon: ""
                    tabDescription: "0"
                    isActive: true
                }

                TabItem_ZSJ1 {
                    tabTitle: "航速"
                    tabIcon: ""
                    tabDescription: "0"
                    isActive: true
                }

                TabItem_ZSJ1 {
                    tabTitle: "电量"
                    tabIcon: ""
                    tabDescription: "0"
                    isActive: true
                }

                TabItem_ZSJ1 {
                    tabTitle: "油量"
                    tabIcon: ""
                    tabDescription: "0"
                    isActive: true
                }

                TabItem_ZSJ1 {
                    tabTitle: "转速"
                    tabIcon: ""
                    tabDescription: "0"
                    isActive: true
                }

                TabItem_ZSJ1 {
                    tabTitle: "距离"
                    tabIcon: ""
                    tabDescription: "0"
                    isActive: true
                }

                TabItem_ZSJ1 {
                    tabTitle: "连接状态(地面站)"
                    tabIcon: ""
                    tabDescription: "正常"
                }

            }
        }
        // 4. 空白填充（可选）
        Item { Layout.fillWidth: true } // 如果不需要右侧拉伸可以删除
    }

    // 文件下拉菜单
    Menu {
        id: fileDropdown
        width: 200
        y: background.height

        background: Rectangle {
            color: "#34495e"
            radius: 5
            layer.enabled: true
            // layer.effect: DropShadow {
            //     verticalOffset: 2
            //     radius: 8
            //     samples: 16
            //     color: "#80000000"
            // }
        }

        Repeater {
            model: root.fileDropdownItems
            delegate: MenuItem_ZSJ1 {
                width: parent.width
                height: 40
                menuText: modelData.name
                menuIcon: modelData.icon
                itemColor: "#34495e"
                showBackground: true
                textColor: "white"
                anchors.left: parent.left
                anchors.right: parent.right
                onClicked: {
                    console.log("选择:", modelData.name)
                    fileDropdown.close()
                }
            }
        }
    }

    // 设置下拉菜单
    Menu {
        id: settingsDropdown
        width: 200
        y: background.height

        background: Rectangle {
            color: "#34495e"
            radius: 5
            layer.enabled: true
            layer.effect: DropShadow {
                verticalOffset: 2
                radius: 8
                samples: 16
                color: "#80000000"
            }
        }

        Repeater {
            model: root.settingsDropdownItems
            delegate: MenuItem_ZSJ1 {
                width: parent.width
                height: 40
                menuText: modelData.name
                menuIcon: modelData.icon
                itemColor: "#34495e"
                showBackground: true
                textColor: "white"
                anchors.left: parent.left
                anchors.right: parent.right
                onClicked: {
                    console.log("选择:", modelData.name)
                    settingsDropdown.close()
                }
            }
        }
    }

    // 折叠/展开按钮
    // Rectangle {
    //     width: 30
    //     height: 30
    //     radius: 15
    //     color: "#34495e"
    //     anchors.right: parent.right
    //     anchors.rightMargin: 20
    //     anchors.bottom: parent.bottom
    //     anchors.bottomMargin: 5

    //     MouseArea {
    //         anchors.fill: parent
    //         onClicked: {
    //             root.menuExpanded = !root.menuExpanded
    //         }
    //     }

    //     Text {
    //         text: root.menuExpanded ? "▲" : "▼"
    //         color: "white"
    //         font.pixelSize: 14
    //         anchors.centerIn: parent
    //     }
    // }
}




