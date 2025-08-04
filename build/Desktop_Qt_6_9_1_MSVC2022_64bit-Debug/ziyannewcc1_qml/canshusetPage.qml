import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: mainWindow
    width: 1200
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

                    SidebarButton {
                        text: "网络参数配置"
                        icon: "📡"
                        isSelected: currentPageIndex === 1
                        onClicked: currentPageIndex = 1
                    }

                    SidebarButton {
                        text: "PID参数配置"
                        icon: "📊"
                        isSelected: currentPageIndex === 2
                        onClicked: currentPageIndex = 2
                    }
                }

                Item { Layout.fillHeight: true }

                // 底部信息
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 5

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#34495e"
                    }

                    Text {
                        text: "系统状态: 正常"
                        color: "#2ecc71"
                        font.pixelSize: 14
                    }

                    Text {
                        text: "连接状态: 已连接"
                        color: "#3498db"
                        font.pixelSize: 14
                    }

                    Text {
                        text: "版本: v1.0.0"
                        color: "#bdc3c7"
                        font.pixelSize: 12
                        Layout.bottomMargin: 10
                    }
                }
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
                        text: "保存配置"
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
                        text: "恢复默认"
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
                            text: "悬停点设置"
                            font.bold: true
                            font.pixelSize: 18
                            Layout.columnSpan: 2
                            Layout.bottomMargin: 10
                            color: "#2c3e50"
                        }

                        // 误差半径
                        LabeledSlider {
                            label: "误差半径"
                            value: basicParams.maxAltitude
                            min: 30
                            max: 500
                            unit: "米"
                            onValueChanged: basicParams.maxAltitude = value
                            Layout.fillWidth: true
                        }

                        // 最大速度
                        LabeledSlider {
                            label: "最大速度"
                            value: basicParams.maxSpeed
                            min: 5
                            max: 30
                            unit: "米/秒"
                            onValueChanged: basicParams.maxSpeed = value
                            Layout.fillWidth: true
                        }
                    }
                }

                // 网络参数配置页面
                ScrollView {
                    id: networkPage
                    clip: true

                    GridLayout {
                        width: networkPage.width
                        columns: 2
                        columnSpacing: 20
                        rowSpacing: 15
                        anchors.margins: 30

                        // 标题
                        Text {
                            text: "摄像头设置"
                            font.bold: true
                            font.pixelSize: 18
                            Layout.columnSpan: 2
                            Layout.bottomMargin: 10
                            color: "#2c3e50"
                        }

                        // WiFi SSID
                        LabeledInput {
                            label: "用户名"
                            value: networkParams.wifiSSID
                            onValueChanged: networkParams.wifiSSID = value
                            Layout.fillWidth: true
                        }

                        // WiFi密码
                        LabeledInput {
                            label: "密码"
                            value: networkParams.wifiPassword
                            echoMode: TextInput.Password
                            onValueChanged: networkParams.wifiPassword = value
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

                        // 网络参数标题
                        Text {
                            text: "网络参数"
                            font.bold: true
                            font.pixelSize: 18
                            Layout.columnSpan: 2
                            Layout.bottomMargin: 10
                            color: "#2c3e50"
                        }

                        // IP地址
                        LabeledInput {
                            label: "IP地址"
                            value: networkParams.ipAddress
                            validator: RegularExpressionValidator  { regularExpression: /^(\d{1,3}\.){3}\d{1,3}$/ }
                            onValueChanged: networkParams.ipAddress = value
                            Layout.fillWidth: true
                        }

                        // 子网掩码
                        LabeledInput {
                            label: "子网掩码"
                            value: networkParams.subnetMask
                            validator: RegularExpressionValidator { regularExpression: /^(\d{1,3}\.){3}\d{1,3}$/ }
                            onValueChanged: networkParams.subnetMask = value
                            Layout.fillWidth: true
                        }

                        // 网关
                        LabeledInput {
                            label: "网关"
                            value: networkParams.gateway
                            validator: RegularExpressionValidator { regularExpression: /^(\d{1,3}\.){3}\d{1,3}$/ }
                            onValueChanged: networkParams.gateway = value
                            Layout.fillWidth: true
                        }

                        // DNS服务器
                        LabeledInput {
                            label: "DNS服务器"
                            value: networkParams.dnsServer
                            validator: RegularExpressionValidator { regularExpression: /^(\d{1,3}\.){3}\d{1,3}$/ }
                            onValueChanged: networkParams.dnsServer = value
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

                        // 端口设置标题
                        Text {
                            text: "端口设置"
                            font.bold: true
                            font.pixelSize: 18
                            Layout.columnSpan: 2
                            Layout.bottomMargin: 10
                            color: "#2c3e50"
                        }

                        // RTSP端口
                        LabeledInput {
                            label: "RTSP端口"
                            value: networkParams.rtspPort
                            validator: IntValidator { bottom: 1; top: 65535 }
                            onValueChanged: networkParams.rtspPort = value
                            Layout.fillWidth: true
                        }

                        // UDP端口
                        LabeledInput {
                            label: "UDP端口"
                            value: networkParams.udpPort
                            validator: IntValidator { bottom: 1; top: 65535 }
                            onValueChanged: networkParams.udpPort = value
                            Layout.fillWidth: true
                        }
                    }
                }

                // PID参数配置页面
                ScrollView {
                    id: pidPage
                    clip: true

                    GridLayout {
                        width: pidPage.width
                        columns: 3
                        columnSpacing: 20
                        rowSpacing: 15
                        anchors.margins: 30

                        // 标题
                        Text {
                            text: "PID参数配置"
                            font.bold: true
                            font.pixelSize: 18
                            Layout.columnSpan: 3
                            Layout.bottomMargin: 10
                            color: "#2c3e50"
                        }

                        // 空单元格
                        Item { Layout.columnSpan: 3; height: 10 }

                        // 表头
                        Text { text: "参数"; font.bold: true; color: "#3498db" }
                        Text { text: "P值"; font.bold: true; color: "#3498db" }
                        Text { text: "I值"; font.bold: true; color: "#3498db" }
                        Text { text: "D值"; font.bold: true; color: "#3498db" }

                        // 速度PID
                        Text { text: "速度PID"; font.bold: true }
                        PidSlider { value: pidParams.rollP; onValueChanged: pidParams.rollP = value }
                        PidSlider { value: pidParams.rollI; onValueChanged: pidParams.rollI = value }
                        PidSlider { value: pidParams.rollD; onValueChanged: pidParams.rollD = value }

                        // 转向PID
                        Text { text: "转向PID"; font.bold: true }
                        PidSlider { value: pidParams.pitchP; onValueChanged: pidParams.pitchP = value }
                        PidSlider { value: pidParams.pitchI; onValueChanged: pidParams.pitchI = value }
                        PidSlider { value: pidParams.pitchD; onValueChanged: pidParams.pitchD = value }

                        // 分隔线
                        Rectangle {
                            height: 1
                            color: "#e0e0e0"
                            Layout.columnSpan: 4
                            Layout.fillWidth: true
                            Layout.topMargin: 20
                            Layout.bottomMargin: 10
                        }

                        // PID说明
                        Text {
                            text: "PID参数说明:"
                            font.bold: true
                            Layout.columnSpan: 3
                            color: "#2c3e50"
                        }

                        Text {
                            text: "• P(比例): 控制响应速度，值越大响应越快，但过大可能导致震荡\n" +
                                  "• I(积分): 消除静态误差，值越大消除误差越快，但过大可能导致超调\n" +
                                  "• D(微分): 抑制系统震荡，值越大抑制效果越强，但过大可能影响响应速度"
                            Layout.columnSpan: 3
                            color: "#7f8c8d"
                        }

                        // 预设按钮
                        Button {
                            text: "默认配置"
                            Layout.columnSpan: 3
                            Layout.alignment: Qt.AlignHCenter
                            Layout.topMargin: 20
                            onClicked: loadDefaultPid()
                        }
                    }
                }
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
            onTextChanged: parent.valueChanged(text)
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
    component LabeledSlider: ColumnLayout {
        property string label: ""
        property real value: 0
        property real min: 0
        property real max: 100
        property string unit: ""

        //signal valueChanged(real newValue)

        Layout.fillWidth: true

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: label
                color: "#7f8c8d"
                font.pixelSize: 14
                Layout.fillWidth: true
            }

            Text {
                text: value.toFixed(1) + " " + unit
                color: "#3498db"
                font.bold: true
            }
        }

        Slider {
            value: parent.value
            from: parent.min
            to: parent.max
            stepSize: 1
            onMoved: {
                parent.value = value;
                parent.valueChanged(value);
            }
            Layout.fillWidth: true

            background: Rectangle {
                x: parent.leftPadding
                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 4
                width: parent.availableWidth
                height: implicitHeight
                radius: 2
                color: "#e0e0e0"

                Rectangle {
                    width: parent.width * (parent.parent.value - parent.parent.from) / (parent.parent.to - parent.parent.from)
                    height: parent.height
                    color: "#3498db"
                    radius: 2
                }
            }

            handle: Rectangle {
                x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                implicitWidth: 20
                implicitHeight: 20
                radius: 10
                color: parent.pressed ? "#2980b9" : "#3498db"
                border.color: "white"
                border.width: 2
            }
        }
    }

    // 自定义组件：PID滑块
    component PidSlider: ColumnLayout {
        property real value: 0.5

        //signal valueChanged(real newValue)

        Layout.fillWidth: true

        Slider {
            value: parent.value
            from: 0.0
            to: 2.0
            stepSize: 0.01
            onMoved: {
                parent.value = value;
                parent.valueChanged(value);
            }
            Layout.fillWidth: true

            background: Rectangle {
                x: parent.leftPadding
                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 6
                width: parent.availableWidth
                height: implicitHeight
                radius: 3
                color: "#e0e0e0"

                Rectangle {
                    width: parent.width * (parent.parent.value - parent.parent.from) / (parent.parent.to - parent.parent.from)
                    height: parent.height
                    color: "#3498db"
                    radius: 3
                }
            }

            handle: Rectangle {
                x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                implicitWidth: 16
                implicitHeight: 16
                radius: 8
                color: parent.pressed ? "#2980b9" : "#3498db"
                border.color: "white"
                border.width: 2
            }
        }

        Text {
            text: value.toFixed(2)
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            color: "#3498db"
        }
    }
}
