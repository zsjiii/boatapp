import QtQuick
import QtQuick.Window
import QtQuick.Controls
//import QtQuick.Layouts 

// 自定义无边框窗口
/*
 * 感谢B站用户 辛归元 提出界面设计建议：
 * 窗口圆角化、添加边缘拖拽缩放窗口、双击状态栏最大化和正常化
 * 感谢B站用户 白白白狗子 提出的界面优化建议：
 * 致敬apple vision ui对整体的主题设计进行了优化
 * 感谢B站用户 一言不合就搞学习 提出的建议：
 * 窗口拖拽到屏幕上方边缘最大化，左右边缘半屏
*/
Window{
    property bool isBody: true // 主页面和皮肤页面切换
    property color backTopColor: "#c0444444" // 背景上方颜色
    property color backBottomColor: "#c0444444" // 背景下方颜色
    property real windowedWidth: width // 窗口化宽度
    property real windowedHeight: height // 窗口化高度
    property real windowedX: x // 窗口化x坐标
    property bool isHalfScreen: false // 是否半屏

    id: mainWindow
    width: 1920
    height: 1080
    // width: Screen.width
    // height: Screen.height
    flags: Qt.Window | Qt.FramelessWindowHint // 窗口 | 无边框窗口
    visible: true
    color: "transparent" // 背景透明方便圆角
    minimumWidth: 600 // 最小宽度
    minimumHeight: 400 // 最小高度

    function saveSize(){
        mainWindow.windowedWidth = mainWindow.width
        mainWindow.windowedHeight = mainWindow.height
    }



    // 全体界面
    Rectangle {
        id: window
        width: mainWindow.width
        height: mainWindow.height
        anchors.right: parent.right
        //radius: 25
        color: "transparent"
        border.color: "#80ffffff"
        clip: true

        // 背景渐变
        gradient: Gradient{
            GradientStop{position:1;color: mainWindow.backTopColor}
            GradientStop{position:1;color: mainWindow.backBottomColor}
        }

        //顶部菜单
        Topbar{
            id: topbar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5  // 添加这行，设置底部边距为5像素
            //width: parent.width - parent.width/8
            height: parent.height/20
            z: 1
            //onCurrentIndexChanged: pages.pageIndex = currentIndex//这里链接着侧边栏图标和pages页面的切换
            backTopColor: mainWindow.backTopColor
            backBottomColor: mainWindow.backBottomColor
        }
        // 侧边栏
        //Sidebar{
        //    id: sidebar
        //    width: 70// sidebarChecked || mainWindow.visibility == mainWindow.Maximized || mainWindow.isHalfScreen ? 40 : 40
        //    height: parent.height - topbar.height
        //    anchors.top: titleBar.bottom
        //    onCurrentIndexChanged: pages.pageIndex = currentIndex//这里链接着侧边栏图标和pages页面的切换
        //    backTopColor: "#ffffff00" //mainWindow.backTopColor #ffffff00
        //    backBottomColor: "#ffffff00" //mainWindow.backBottomColor
        //}
        // 标题栏
        Item{
            id: titleBar
            anchors.left: parent.left  // 左侧对齐 Sidebar 右侧
            anchors.right: parent.right  // 右侧对齐父项
            anchors.top: parent.top      // 顶部对齐父项（不再依赖 topbar）
            //width: parent.width - topbar.width
            height: 30

            // //主题
            // Item{
            //     id: skinBtn
            //     width: titleBar.height
            //     height: titleBar.height

            //     // 主题图标
            //     Image {
            //         anchors.fill: parent
            //         source: "qrc:/image/res/skin.png"
            //         onStatusChanged: {
            //             if (status === Image.Error) {
            //                 console.error("加载失败:", errorString)
            //             }
            //             console.log("Status:", status)
            //         }
            //     }

            //     MouseArea{
            //         anchors.fill: parent
            //         onClicked: mainWindow.isBody = !mainWindow.isBody
            //     }
            // }

            //下拉菜单
            //MenuItem_ZSJ1 {
            //    id: zsjcaidanceshi_titlebar
            //    anchors.left: parent.left
            //    //anchors.centerIn: parent
            //    //Layout.preferredWidth: itemwidth
            //    //Layout.fillHeight: true
            //    selectedSubItem: "控制模式"
            //    // menuText: modelData.name
            //    // menuIcon: modelData.icon
            //    // itemColor: modelData.color
            //    // hasDropdown: modelData.hasDropdown
            //    isActive: true //index === root.currentIndex
            //}

            Row {
                id: icon
                //width: itemwidth*2
                anchors.left: parent.left
                width:150
                height: parent.height
                //Layout.preferredWidth:Math.max(itemwidth, 150)
                //Layout.fillHeight: true
                //anchors.leftMargin: 20
                //anchors.verticalCenter: parent.verticalCenter
                //spacing: 0
                // 图标
                Image {
                    id: logo
                    height: titleBar.height //parent.height
                    width: titleBar.height //parent.height //parent.width/2
                    source: "qrc:/image/res/bilibili.png"
                    // onStatusChanged: {
                    //     if (status === Image.Ready) {
                    //         console.log("Image loaded successfully");
                    //     } else if (status === Image.Error) {
                    //         console.log("Image failed to load:", icon.source);
                    //         console.log("Error string:", icon.errorString());
                    //     }
                    // }
                }
                /*Text {
                    text: "天宇智远"
                    width:parent.width/2
                    color: "white"
                    font.pixelSize: 16
                    font.bold: true
                    //anchors.verticalCenter: parent.verticalCenter
                }*/
            }


            // 拖动条
            Item {
                //anchors.left: zsjcaidanceshi_titlebar.right
                anchors.left: icon.right
                anchors.right: canshusetBtn.left //closeBtn.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                DragHandler{
                    id: dragHandler
                    onActiveChanged: {
                        if (active){ // 按下并拖拽
                            if (mainWindow.isHalfScreen)
                            {
                                mainWindow.width = mainWindow.windowedWidth
                                mainWindow.height = mainWindow.windowedHeight
                                mainWindow.isHalfScreen = false
                            }
                            else
                            {
                                mainWindow.showNormal()
                            }

                            mainWindow.x = mainWindow.windowedX
                            mainWindow.startSystemMove()
                        }
                        else // 松开
                        {
                            var screenX = mainWindow.x + dragHandler.centroid.position.x + 80 + 50 // 侧边栏80 图标50
                            var screenY = mainWindow.y + dragHandler.centroid.position.y
                            // 备份修改前的窗口数据
                            mainWindow.saveSize()
                            mainWindow.windowedX = mainWindow.x

                            if (Math.abs(screenY) < 2){ // 上方最大化
                                mainWindow.windowedX = mainWindow.x
                                mainWindow.showMaximized()
                            }
                            else if (Math.abs(screenX) < 2){ // 左方半屏
                                mainWindow.windowedX = 0
                                mainWindow.width = screen.width / 2;
                                mainWindow.height = screen.height;
                                mainWindow.x = 0;
                                mainWindow.y = 0;
                                mainWindow.isHalfScreen = true
                            }
                            else if (screenX > Screen.width - 2){ // 右方半屏
                                mainWindow.windowedX = screen.width / 2;
                                mainWindow.width = screen.width / 2;
                                mainWindow.height = screen.height;
                                mainWindow.x = screen.width / 2;
                                mainWindow.y = 0;
                                mainWindow.isHalfScreen = true
                            }
                        }
                    }
                }

                // 双击最大化或正常化
                MouseArea{
                    anchors.fill: parent
                    onDoubleClicked: mainWindow.visibility == mainWindow.Maximized ? mainWindow.showNormal() : mainWindow.showMaximized()
                }
            }
            // 设置按钮
            Item{
                id: canshusetBtn
                width: titleBar.height
                height: titleBar.height
                anchors.right: closeBtn.left
                //anchors.left: skinBtn.right

                Text {
                    anchors.fill: parent
                    text: "⚙️"
                    font.pixelSize: 30
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        // 创建并显示设置窗口
                        var component = Qt.createComponent("canshusetPage.qml")
                        if (component.status === Component.Ready) {
                            let settingsWin = component.createObject(mainWindow)
                            settingsWin.show()
                        } else {
                            console.error("创建设置窗口错误:", component.errorString())
                        }
                    }

                }
            }

            // 关闭按钮
            Item{
                id: closeBtn
                width: titleBar.height
                height: titleBar.height
                anchors.right: parent.right

                Image {
                    anchors.fill: parent
                    source: "qrc:/image/res/close.png"
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: mainWindow.close()
                }
            }
        }

        Row {
            id: controlbar
            spacing: 30  // 控制菜单之间的间距
            anchors.left: parent.left  // 左侧对齐 Sidebar 右侧
            anchors.right: parent.right  // 右侧对齐父项
            anchors.bottom: topbar.top   // 顶部对齐父项（不再依赖 topbar）
            z: 1

            //启停按钮
            Column {
                id: starstop
                anchors.left: parent.left
                leftPadding: 5 // 添加左侧间距
                bottomPadding: 5
                spacing: 20

                SwitchBtn{
                    width: 100
                    height: 40
                    checkColor: "#80d080"
                    labelTextoff: "有人"
                    labelTexton: "无人"
                    onClicked: function(isChecked) {
                        if(isChecked){
                            cmdSend.Ctrl_Cmd_Send(0x14, 0x01); // 无人
                        } else {
                            cmdSend.Ctrl_Cmd_Send(0x14, 0x00); // 有人
                        }
                        // 注意：这里不需要再切换 isChecked，因为组件内部已经处理了
                    }
                } // 绿 有人：0x00 无人：0x01
                SwitchBtn{
                    width: 100
                    height: 40
                    checkColor: "#daa520"
                    labelTextoff: "停车"
                    labelTexton: "启动"
                    onClicked: function(isChecked) {
                        if(isChecked){
                            cmdSend.Ctrl_Cmd_Send(0x0c, 0x01); // 启动
                        } else {
                            cmdSend.Ctrl_Cmd_Send(0x0c, 0x04); // 停车
                        }
                        // 注意：这里不需要再切换 isChecked，因为组件内部已经处理了
                    }
                }
                SwitchBtn{
                    width: 100
                    height: 40
                    checkColor: "#87ceeb"
                    labelTextoff: "油机"
                    labelTexton: "电推"
                    onClicked: function(isChecked) {
                        if(isChecked){
                            cmdSend.Ctrl_Cmd_Send(0x14, 0x01); // 无人
                        } else {
                            cmdSend.Ctrl_Cmd_Send(0x14, 0x00); // 有人
                        }
                        // 注意：这里不需要再切换 isChecked，因为组件内部已经处理了
                    }
                }
                //SwitchBtn{width: 100; height: 40; checkColor: "#daa520"; labelTextoff: "停车"; labelTexton: "启动"} // 黄
                //SwitchBtn{width: 100; height: 40; checkColor: "#87ceeb"; labelTextoff: "油机"; labelTexton: "电推"} // 蓝
                //SwitchBtn{width: 100; height: 40; checkColor: "#ffd0d0"} // 粉
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
            }

            Column{
                anchors.left: starstop.right
                //anchors.centerIn: parent // 使用centerIn实现居中
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                leftPadding: 5 // 添加左侧间距
                bottomPadding: 5
                spacing: 5
                Instrument{
                    height: 90
                    width: height*2
                    //currentValue: 1
                }
                Row{
                    spacing: 0
                    Button {
                        id: throttleUp
                        text: "油机升"
                        width: 70
                        height: 60
                        font.pixelSize: 18
                        
                        background: Rectangle {
                            color: parent.pressed ? "#4CAF50" : "#8BC34A"
                            radius: 5
                        }
                        
                        onClicked: {
                            // 增加油门逻辑
                        }
                    }

                    Text{
                        text:"0"
                        width: 40
                        height: 60
                        font.pixelSize: 36
                        font.bold: true
                        color: "lightblue"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                
                    Button {
                        id: throttleDown
                        text: "油机降"
                        width: 70
                        height: 60
                        font.pixelSize: 18
                        
                        background: Rectangle {
                            color: parent.pressed ? "#F44336" : "#FF5722"
                            radius: 5
                        }
                        
                        onClicked: {
                            // 减少油门逻辑
                        }
                    }
                }
            }

            Column{
                anchors.horizontalCenter: parent.horizontalCenter // 水平居中
                //anchors.left: starstop.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                leftPadding: 5 // 添加左侧间距
                bottomPadding: 5
                spacing: 5
                Instrument{
                    height: 90
                    width: height*2
                    Component.onCompleted: {
                        currentValue = 50
                    }
                }
                Row{
                    spacing: 0
                    Button {
                        id: leftBtn
                        text: "左转"
                        width: 60
                        height: 60
                        font.pixelSize: 24
                        onClicked:{
                            cmdSend.Ctrl_Float_Send(0x0a,1)
                        }
                    }

                    Text{
                        text:"0"
                        width: 60
                        height: 60
                        font.pixelSize: 36
                        font.bold: true
                        color: "lightgreen"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Button {
                        id: rightBtn
                        text: "右转"
                        width: 60
                        height: 60
                        font.pixelSize: 24
                        onClicked:{
                            cmdSend.Ctrl_Float_Send(0x0a,1)
                        }
                    }
                }
            }

            Item {
                id: switchManager
                property var buttons: [switch1, switch2, switch3]
                property int currentIndex: 1

                Component.onCompleted: {
                    // 初始化状态，确保只有一个按钮被选中
                    for (var i = 0; i < buttons.length; i++) {
                        buttons[i].isChecked = (i === currentIndex)
                    }
                }
                
                // 当按钮被点击时调用
                function onButtonClicked(index) {
                    // 如果点击的不是当前选中的按钮，则切换到该按钮
                    if (currentIndex !== index) {
                        buttons[currentIndex].isChecked = false
                        buttons[index].isChecked = true
                        currentIndex = index
                    }
                    // 如果点击的是当前选中的按钮，什么都不做（保持选中状态）
                }
            }
            //RadioBtnCombobox{
            //    anchors.bottom: parent.bottom
            //    anchors.bottomMargin: 5
            //    anchors.right: throttle.left
            //    width: 300
            //    height: 100
            //    checkColor: "#ffd0d0"
            //    listModel: ListModel{
            //        ListElement{labelText: "前进"}
            //        ListElement{labelText: "空挡"}
            //        ListElement{labelText: "后退"}
            //    }
            //}

            Column {
                id: switchbtns
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.right: parent.right
                spacing: 20

                // 开关按钮1
                MuSwitchBtn {
                    id: switch1
                    width: 100; 
                    height: 40; 
                    checkColor: "#80d080"; 
                    labelTexton: "前进"
                    labelTextoff: ""
                    
                    onClicked: {
                        switchManager.onButtonClicked(0)
                        cmdSend.Ctrl_Cmd_Send(0x06, 0x01)
                    }
                }

                // 开关按钮2
                MuSwitchBtn {
                    id: switch2
                    width: 100; 
                    height: 40; 
                    checkColor: "#daa520";
                    labelTexton: "空档"
                    labelTextoff: ""
                    onClicked: {
                        switchManager.onButtonClicked(1)
                        cmdSend.Ctrl_Cmd_Send(0x06, 0x02)
                    }
                }

                // 开关按钮3
                MuSwitchBtn {
                    id: switch3
                    width: 100; 
                    height: 40; 
                    checkColor: "#87ceeb";
                    labelTexton: "后退"
                    labelTextoff: ""
                    
                    onClicked: {
                        switchManager.onButtonClicked(2)
                        cmdSend.Ctrl_Cmd_Send(0x06, 0x03)
                    }
                }
            }

            Column{
                id: throttle
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.right: switchbtns.left
                leftPadding: 5 // 添加左侧间距
                bottomPadding: 5
                spacing: 5
                Instrument{
                    height: 90
                    width: height*2
                    //currentValue: 1
                }
                Row{
                    spacing: 0
                    Button {
                        id: forwardBtn
                        text: "减油"
                        width: 60
                        height: 60
                        font.pixelSize: 24
                        onClicked:{
                            cmdSend.Ctrl_Cmd_Send(0x08,2)
                        }
                    }
                    Text{
                        text:"0"
                        width: 60
                        height: 60
                        font.pixelSize: 36
                        font.bold: true
                        color: "pink"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    Button {
                        id: backwardBtn
                        text: "加油"
                        width: 60
                        height: 60
                        font.pixelSize: 24
                        onClicked:{
                            cmdSend.Ctrl_Cmd_Send(0x08,2)
                        }
                    }
                }
            }

            // 无人控制切换菜单
            //Row {
            //    spacing: 10
            //    Label {
            //        text: "控制模式:"
            //        anchors.verticalCenter: parent.verticalCenter
            //    }
            //    ComboBox {
            //        id: controlModeCombo
            //        width: 150
            //        model: ["有人控制", "无人控制"]
            //        currentIndex: 0
            //        onCurrentIndexChanged: {
            //            console.log("控制模式更改为:", model[currentIndex])
            //        }
            //    }
            //}

            //// 动力类型切换菜单
            //Row {
            //    spacing: 10
            //    Label {
            //        text: "动力类型:"
            //        anchors.verticalCenter: parent.verticalCenter
            //    }
            //    ComboBox {
            //        id: powerTypeCombo
            //        width: 150
            //        model: ["电推", "油机"]
            //        currentIndex: 0
            //        onCurrentIndexChanged: {
            //            console.log("动力类型更改为:", model[currentIndex])
            //        }
            //    }
            //}

            //// 摄像头切换菜单
            //Row {
            //    spacing: 10
            //    Label {
            //        text: "摄像头:"
            //        anchors.verticalCenter: parent.verticalCenter
            //    }
            //    ComboBox {
            //        id: cameraCombo
            //        width: 150
            //        model: ["前", "后", "左", "右"]
            //        currentIndex: 0
            //        onCurrentIndexChanged: {
            //            console.log("摄像头切换为:", model[currentIndex])
            //        }
            //    }
            //}
        }

        // 主题页面
        // SkinPage{
        //     id: skin
        //     anchors.left: sidebar.right
        //     //width: parent.width - sidebar.width
        //     //anchors.left: parent.left
        //     anchors.right: parent.right
        //     anchors.top: titleBar.bottom
        //     anchors.bottom: parent.bottom
        //     visible: !mainWindow.isBody

        //     onCheckSkin: {
        //         mainWindow.backTopColor = backTopColor
        //         mainWindow.backBottomColor = backBottomColor
        //     }
        // }

        // 主体
        Pages{
            id: pages
            //z: -1
            anchors.left: parent.left
            //width: parent.width - sidebar.width
            //anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: titleBar.bottom
            anchors.bottom: topbar.bottom
            visible: mainWindow.isBody
            clip: true
        }

        // 界面缩放区域
        Item {
            anchors.fill: parent
            enabled:  mainWindow.visibility !== mainWindow.Maximized // 最大化时不可用

            // 上
            Item {
                height: 5
                width: parent.width

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.SizeVerCursor

                    onPressed: mainWindow.startSystemResize(Qt.TopEdge)
                    onReleased: mainWindow.saveSize()
                }
            }

            // 下
            Item {
                height: 5
                width: parent.width
                anchors.bottom: parent.bottom

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.SizeVerCursor

                    onPressed: mainWindow.startSystemResize(Qt.BottomEdge)
                    onReleased: mainWindow.saveSize()
                }
            }

            // 左
            Item {
                width: 5
                height: parent.height

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.SizeHorCursor

                    onPressed: mainWindow.startSystemResize(Qt.LeftEdge)
                    onReleased: mainWindow.saveSize()
                }
            }

            // 右
            Item {
                width: 5
                height: parent.height
                anchors.right: parent.right

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.SizeHorCursor

                    onPressed: mainWindow.startSystemResize(Qt.RightEdge)
                    onReleased: mainWindow.saveSize()
                }
            }

            // 左上
            Item {
                id: left_top
                width: 5
                height: 5

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.SizeFDiagCursor

                    onPressed: mainWindow.startSystemResize(Qt.LeftEdge | Qt.TopEdge)
                    onReleased: mainWindow.saveSize()
                }
            }

            // 右上
            Item {
                id: right_top
                width: 5
                height: 5
                anchors.right: parent.right

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.SizeBDiagCursor

                    onPressed: mainWindow.startSystemResize(Qt.RightEdge | Qt.TopEdge)
                    onReleased: mainWindow.saveSize()
                }
            }

            // 左下
            Item {
                id: left_bottom
                width: 5
                height: 5
                anchors.bottom: parent.bottom

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.SizeBDiagCursor

                    onPressed: mainWindow.startSystemResize(Qt.LeftEdge | Qt.BottomEdge)
                    onReleased: mainWindow.saveSize()
                }
            }

            // 右下
            Item {
                id: right_bottom
                width: 5
                height: 5
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.SizeFDiagCursor

                    onPressed: mainWindow.startSystemResize(Qt.RightEdge | Qt.BottomEdge)
                    onReleased: mainWindow.saveSize()
                }
            }
        }
    }
}
