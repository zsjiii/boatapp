import QtQuick
import QtQuick.Window 2.15
import QtWebView 1.15  // 使用WebView替代WebEngine
//import QtWebEngine 6.8
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtMultimedia 6.4
Item {
    // 地图显示区域
    WebView  {
        id: webView
        //z: -100
        //settings.localContentCanAccessRemoteUrls: true
        //settings.localContentCanAccessFileUrls: true
        // 如果加载的HTML需要访问其他本地文件，还需要设置
        //settings.allowWindowActivationFromJavaScript: true
        //settings.allowGeolocationOnInsecureOrigins: true
        anchors.fill: parent
        url: "file:///media/root/43550A4FB5A99DFE/lin3588/ziyanexe/bmap_offline_demo/demo01.html"  // 使用file协议和相对路径

        onLoadingChanged: {
            if (loadRequest.errorString)
                console.error("加载错误:", loadRequest.errorString)
        }
        //WebEngineProfile {
        //    id: mapProfile
        //    persistentStoragePath: "./webengine_cache"
        //    httpCacheType: WebEngineProfile.DiskHttpCache
        //    persistentCookiesPolicy: WebEngineProfile.AllowPersistentCookies
        //}
    }

    // 悬浮视频界面 - 覆盖在主界面上方
    Rectangle {
        id: videoOverlay
        x: window.width *4 / 5 //- 20
        y: window.height *2 / 3 //- 20
        width: 320
        height: 240
        color: "#1a1a1a"
        radius: 8
        border.color: "#3498db"
        border.width: 2

        // // 添加阴影效果
        // layer.enabled: true
        // layer.effect: DropShadow {
        //     radius: 8
        //     samples: 16
        //     color: "#80000000"
        // }

        // 拖动功能
        DragHandler {
            id: dragHandler
            target: videoOverlay
        }

        // 视频标题栏
        Rectangle {
            id: videoHeader
            width: parent.width
            height: 36
            color: "#3498db"
            radius: 8
            anchors.top: parent.top

            Text {
                text: "视频监控 - 通道1"
                color: "white"
                font.bold: true
                anchors.centerIn: parent
            }

            // 关闭按钮
            //Button {
            //    width: 30
            //    height: 30
            //    anchors {
            //        right: parent.right
            //        rightMargin: 5
            //        verticalCenter: parent.verticalCenter
            //    }
            //    background: Rectangle {
            //        color: "transparent"
            //        radius: 15
            //        border.color: "#e74c3c"
            //    }
            //    contentItem: Text {
            //        text: "×"
            //        color: "#e74c3c"
            //        font.pixelSize: 20
            //        font.bold: true
            //        anchors.centerIn: parent
            //    }
            //    onClicked: videoOverlay.visible = false
            //}
        }

        // 视频显示区域
        Rectangle {
            id: videoContainer
            width: parent.width - 10
            height: parent.height - videoHeader.height - controlBar.height - 15
            color: "#121212"
            anchors {
                top: videoHeader.bottom
                topMargin: 5
                horizontalCenter: parent.horizontalCenter
            }

            // 视频播放器
            MediaPlayer {
                id: videoPlayer
                source: "rtsp://192.168.0.104:554/live"
                autoPlay: true
                videoOutput: videoOutput
            }

            VideoOutput {
                id: videoOutput
                anchors.fill: parent
                //source: videoPlayer
                fillMode: VideoOutput.PreserveAspectFit
            }

            // 无信号提示
            Text {
                visible: !mediaPlayer.hasVideo
                text: "无视频信号"
                color: "#7f8c8d"
                anchors.centerIn: parent
            }
        }

        // 点击切换内容
        TapHandler {
            onTapped: {
                // 交换
            }
        }

        // 跟随主窗口移动
        property point relativePosition: Qt.point(x/mainWindow.width, y/mainWindow.height)

        // 统一处理位置变化
        onXChanged: {
            // 边界检查
            if (x < 0) x = 0
            if (x > mainWindow.width - width) x = mainWindow.width - width
            // 更新相对位置
            relativePosition = Qt.point(x/mainWindow.width, y/mainWindow.height)
        }
        
        onYChanged: {
            // 边界检查
            if (y < 0) y = 0
            if (y > mainWindow.height - height) y = mainWindow.height - height
            // 更新相对位置
            relativePosition = Qt.point(x/mainWindow.width, y/mainWindow.height)
        }

        //Connections {
        //    target: mainWindow
        //    function onWidthChanged() {
        //        videoOverlay.x = videoOverlay.relativePosition.x * mainWindow.width
        //    }
        //    function onHeightChanged() {
        //        videoOverlay.y = videoOverlay.relativePosition.y * mainWindow.height
        //    }
        //}
    }

}
