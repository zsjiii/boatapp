import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtMultimedia 6.4

Page {
    id: videoPage
    background: Rectangle { color: "#ffffff" }

    // 顶部控制栏
    Rectangle {
        id: controlBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#1e1e1e"
        opacity: 0.9

        RowLayout {
            anchors.centerIn: parent
            spacing: 25

            // 6个功能按钮 - 使用自定义 IconButton
            Button_ZSJ1 {
                id: playBtn
                iconSource: "qrc:/res/radio.png"
                tooltipText: "播放"
                onClicked: {
                    mediaPlayer.play()
                }
            }

            Button_ZSJ1 {
                id: pauseBtn
                iconSource: "qrc:/prefix1/res/bilibili.png"
                tooltipText: "暂停"
                onClicked: mediaPlayer.pause()
            }

            Button_ZSJ1 {
                id: stopBtn
                iconSource: "qrc:/prefix1/res/close.png"
                tooltipText: "停止"
                onClicked: mediaPlayer.stop()
            }

            Button_ZSJ1 {
                id: fullscreenBtn
                iconSource: "qrc:/prefix1/res/switch.png"
                tooltipText: "全屏"
                onClicked: toggleFullscreen()
            }

            Button_ZSJ1 {
                id: snapshotBtn
                iconSource: "qrc:/prefix1/res/edit.png"
                tooltipText: "截图"
                onClicked: takeSnapshot()
            }

            Button_ZSJ1 {
                id: settingsBtn
                iconSource: "qrc:/prefix1/res/menu.png"
                tooltipText: "设置"
                onClicked: openSettings()
            }
        }

        // 流地址显示
        Text {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 20
            text: "rtsp://192.168.1.100:554/live/stream"
            color: "#80cbc4"
            font.pixelSize: 14
        }
    }

    // 视频显示区域
    Rectangle {
        id: videoContainer
        anchors.top: controlBar.bottom
        anchors.bottom: statusBar.top
        anchors.left: parent.left
        anchors.right: parent.right
        color: "black"

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

        // 加载指示器
        BusyIndicator {
            id: loadingIndicator
            anchors.centerIn: parent
            running: videoPlayer.status === MediaPlayer.Loading
            width: 60
            height: 60
        }

        // 错误提示
        Text {
            anchors.centerIn: parent
            text: "无法加载视频流"
            color: "white"
            font.pixelSize: 20
            visible: videoPlayer.error !== MediaPlayer.NoError
        }
    }



    // 功能函数
    function toggleFullscreen() {
        if (videoPage.parent instanceof Window) {
            videoPage.parent.visibility === Window.FullScreen ?
                videoPage.parent.showNormal() : videoPage.parent.showFullScreen();
        }
    }

    function takeSnapshot() {
        // 这里应该实现截图功能
        console.log("截图功能已触发");
    }

    function openSettings() {
        // 打开设置对话框
        settingsDialog.open();
    }

    function formatTime(milliseconds) {
        var seconds = Math.floor(milliseconds / 1000);
        var minutes = Math.floor(seconds / 60);
        seconds = seconds % 60;
        return minutes.toString().padStart(2, '0') + ":" + seconds.toString().padStart(2, '0');
    }

    // 设置对话框
    Dialog {
        id: settingsDialog
        title: "流媒体设置"
        anchors.centerIn: parent
        width: 400
        height: 300
        modal: true

        contentItem: ColumnLayout {
            spacing: 15

            Text {
                text: "视频源地址:"
                color: "white"
            }

            TextField {
                id: streamUrl
                Layout.fillWidth: true
                text: videoPlayer.source
                placeholderText: "输入RTSP/RTMP流地址"
            }

            Text {
                text: "连接选项:"
                color: "white"
            }

            RowLayout {
                CheckBox {
                    id: tcpCheckbox
                    text: "使用TCP传输"
                    checked: true
                }

                CheckBox {
                    id: audioCheckbox
                    text: "启用音频"
                    checked: true
                }
            }

            RowLayout {
                Button {
                    text: "应用"
                    onClicked: {
                        videoPlayer.source = streamUrl.text;
                        settingsDialog.close();
                    }
                }

                Button {
                    text: "取消"
                    onClicked: settingsDialog.close()
                }
            }
        }

        background: Rectangle {
            color: "#2d2d2d"
            radius: 5
        }
    }

    // 自定义图标按钮组件

}
