import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: mainWindow
    width: 1280
    height: 800
    visible: true
    title: "系统参数配置"
    color: "#f5f7fa"
    flags: Qt.Window | Qt.Dialog  // 设置为独立窗口

    // 当前选中的配置页面索引
    property int currentPageIndex: 0

    // 页面标题
    property string pageTitle: {
        switch(currentPageIndex) {
            case 0: return "基本参数配置";
            case 1: return "网络参数配置";
            case 2: return "PID参数配置";
            default: return "参数配置";
        }
    }

    // 配置数据模型
    property var basicParams: ({
        "deviceName": "无人机001",
        "serialNumber": "SN-2023-001",
        "firmwareVersion": "v2.1.5",
        "maxAltitude": 120,
        "maxSpeed": 15,
        "returnAltitude": 30,
        "lowBatteryWarning": 25
    })

    property var networkParams: ({
        "wifiSSID": "UAV_Network",
        "wifiPassword": "********",
        "ipAddress": "192.168.1.100",
        "subnetMask": "255.255.255.0",
        "gateway": "192.168.1.1",
        "dnsServer": "8.8.8.8",
        "rtspPort": 554,
        "udpPort": 14550
    })

    property var pidParams: ({
        "rollP": 0.85,
        "rollI": 0.12,
        "rollD": 0.05,
        "pitchP": 0.82,
        "pitchI": 0.10,
        "pitchD": 0.04,
        "yawP": 0.95,
        "yawI": 0.15,
        "yawD": 0.03,
        "altitudeP": 1.2,
        "altitudeI": 0.25,
        "altitudeD": 0.08
    })

    // 主布局
    RowLayout {
        anchors.fill: parent
        spacing: 0

        // 侧边栏
        Rectangle {
            id: sidebar
            width: 220
            Layout.fillHeight: true
            color: "#2c3e50"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5

                // 标题
                Text {
                    text: "参数配置"
                    color: "white"
                    font.bold: true
                    font.pixelSize: 24
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 20
                    Layout.bottomMargin: 30
                }

                // 导航菜单
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    SidebarButton {
                        text: "任务参数配置"
                        icon: "⚙️"
                        isSelected: currentPageIndex === 0
                        onClicked: currentPageIndex = 0
                    }
                }

                Item { Layout.fillHeight: true }

                // 底部信息
            }
        }

        // 主内容区域
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // 顶部标题栏
            Rectangle {
                id: header
                Layout.fillWidth: true
                height: 60
                color: "white"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20

                    Text {
                        text: pageTitle
                        font.bold: true
                        font.pixelSize: 22
                        color: "#2c3e50"
                    }

                    Item { Layout.fillWidth: true }

                    Button {
                        text: "任务上传"
                        highlighted: true
                        palette.button: "#3498db"
                        palette.buttonText: "white"
                        onClicked: saveConfig()

                        contentItem: Row {
                            spacing: 8
                            Text { text: parent.parent.text; color: "white" }
                            Text { text: "💾"; font.pixelSize: 16 }
                        }
                    }

                    Button {
                        text: "任务启动"
                        palette.button: "#e74c3c"
                        palette.buttonText: "white"
                        onClicked: resetConfig()
                    }
                }

                // 底部阴影
                Rectangle {
                    width: parent.width
                    height: 1
                    anchors.bottom: parent.bottom
                    color: "#e0e0e0"
                }
            }

            // 页面内容
            StackLayout {
                id: contentStack
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: currentPageIndex

                // 基本参数配置页面
                ScrollView {
                    id: basicPage
                    clip: true

                    GridLayout {
                        width: basicPage.width
                        columns: 2
                        columnSpacing: 20
                        rowSpacing: 15
                        anchors.margins: 30

                        // 标题
                        Text {
                            text: "任务信息"
                            font.bold: true
                            font.pixelSize: 18
                            Layout.columnSpan: 2
                            Layout.bottomMargin: 10
                            color: "#2c3e50"
                        }

                        // 任务类型
                        LabeledInput {
                            label: "任务类型"
                            value: basicParams.deviceName
                            onValueChanged: basicParams.deviceName = value
                            Layout.fillWidth: true
                        }

                        // 结束动作
                        LabeledInput {
                            label: "结束动作"
                            value: basicParams.serialNumber
                            onValueChanged: basicParams.serialNumber = value
                            Layout.fillWidth: true
                        }

                        // 返回点设置
                        LabeledInput {
                            label: "返回点设置"
                            value: basicParams.firmwareVersion
                            readOnly: true
                            Layout.fillWidth: true
                        }

                        // 分隔线
                        Rectangle {
                            height: 1
                            color: "#e0e0e0"
                            Layout.columnSpan: 2
                            Layout.fillWidth: true
                            Layout.topMargin: 10
                            Layout.bottomMargin: 10
                        }

                        // 悬停点设置
                        Text {
                            text: "失联设置"
                            font.bold: true
                            font.pixelSize: 18
                            Layout.columnSpan: 2
                            Layout.bottomMargin: 10
                            color: "#2c3e50"
                        }
                    }
                }

                // 网络参数配置页面

                // PID参数配置页面
            }
        }
    }

    // 保存配置函数
    function saveConfig() {
        console.log("保存配置...");
        console.log("基本参数:", JSON.stringify(basicParams));
        console.log("网络参数:", JSON.stringify(networkParams));
        console.log("PID参数:", JSON.stringify(pidParams));

        saveDialog.open();
    }

    // 重置配置函数
    function resetConfig() {
        console.log("恢复默认配置...");
        // 在实际应用中，这里应该重置为默认值
    }

    // 加载默认PID配置
    function loadDefaultPid() {
        pidParams.rollP = 0.8;
        pidParams.rollI = 0.12;
        pidParams.rollD = 0.05;
        pidParams.pitchP = 0.78;
        pidParams.pitchI = 0.10;
        pidParams.pitchD = 0.04;
        pidParams.yawP = 0.92;
        pidParams.yawI = 0.15;
        pidParams.yawD = 0.03;
        pidParams.altitudeP = 1.1;
        pidParams.altitudeI = 0.22;
        pidParams.altitudeD = 0.07;
    }

    // 保存成功对话框
    Dialog {
        id: saveDialog
        title: "配置保存成功"
        modal: true
        standardButtons: Dialog.Ok

        anchors.centerIn: parent
        width: 400

        Label {
            text: "所有配置参数已成功保存到设备。\n部分配置需要重启设备才能生效。"
            wrapMode: Text.Wrap
        }
    }

    // 自定义组件：侧边栏按钮
    component SidebarButton: Rectangle {
        property string text: ""
        property string icon: ""
        property bool isSelected: false

        signal clicked()

        width: parent.width
        height: 50
        radius: 5
        color: isSelected ? "#3498db" : "transparent"

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 15
            spacing: 10

            Text {
                text: icon
                font.pixelSize: 20
                color: isSelected ? "white" : "#bdc3c7"
            }

            Text {
                text: parent.parent.text
                color: isSelected ? "white" : "#ecf0f1"
                font.pixelSize: 16
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: parent.clicked()
            onEntered: {
                if (!isSelected) {
                    parent.color = "#34495e"
                }
            }
            onExited: {
                if (!isSelected) {
                    parent.color = "transparent"
                }
            }
        }
    }

    // 自定义组件：带标签的输入框
    component LabeledInput: ColumnLayout {
        property string label: ""
        property string value: ""
        property bool readOnly: false
        property int echoMode: TextInput.Normal
        property var validator: null

        //signal valueChanged(string newValue)

        Layout.fillWidth: true

        Text {
            text: label
            color: "#7f8c8d"
            font.pixelSize: 14
        }

        TextField {
            text: value
            readOnly: parent.readOnly
            echoMode: parent.echoMode
            validator: parent.validator
            onTextChanged: {
                if (text !== value){
                    value = text
                }
            }
            Layout.fillWidth: true

            background: Rectangle {
                implicitHeight: 40
                radius: 5
                border.width: 1
                border.color: parent.activeFocus ? "#3498db" : "#e0e0e0"
            }
        }
    }

    // 自定义组件：带标签的滑块

    // 自定义组件：PID滑块
}
