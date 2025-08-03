import QtQuick
import QtQuick.Window

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
            width: parent.width - parent.width/8
            height: parent.height/20
            //onCurrentIndexChanged: pages.pageIndex = currentIndex//这里链接着侧边栏图标和pages页面的切换
            backTopColor: mainWindow.backTopColor
            backBottomColor: mainWindow.backBottomColor
        }
        // 侧边栏
        Sidebar{
            id: sidebar
            width: sidebarChecked || mainWindow.visibility == mainWindow.Maximized || mainWindow.isHalfScreen ? 40 : 40
            height: parent.height - topbar.height
            anchors.top: topbar.bottom
            onCurrentIndexChanged: pages.pageIndex = currentIndex//这里链接着侧边栏图标和pages页面的切换
            backTopColor: mainWindow.backTopColor
            backBottomColor: mainWindow.backBottomColor
        }
        // 标题栏
        Item{
            id: titleBar
            anchors.left: topbar.right
            width: parent.width - topbar.width
            height: 50

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
            // 设置按钮
            Item{
                id: canshusetBtn
                width: titleBar.height
                height: titleBar.height
                //anchors.left: skinBtn.right

                Text {
                    anchors.fill: parent
                    text: "⚙️"
                    font.pixelSize: 20
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
            // 拖动条
            Item {
                anchors.left: canshusetBtn.right
                anchors.right: closeBtn.left
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
            anchors.left: sidebar.right
            //width: parent.width - sidebar.width
            //anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: titleBar.bottom
            anchors.bottom: parent.bottom
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
