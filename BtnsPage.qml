import QtQuick

// 按钮界面
Item {
    anchors.margins: 20
    property int throttle: 0
    property int rudder_angle: 0

    Column{

        Row{
            spacing: 20

            // 开关按钮
            Column{
                spacing: 20

                SwitchBtn{width: 100; height: 40; checkColor: "#80d080"} // 绿
                SwitchBtn{width: 100; height: 40; checkColor: "#daa520"} // 黄
                //SwitchBtn{width: 100; height: 40; checkColor: "#87ceeb"} // 蓝
                //SwitchBtn{width: 100; height: 40; checkColor: "#ffd0d0"} // 粉
            }

            // 复选按钮
            // Row{
            //     spacing: 20

            //     CheckBtn{width: 100; height: 40; labelText: "复选1"; checkColor: "#80d080"} // 绿
            //     CheckBtn{width: 100; height: 40; labelText: "复选2"; checkColor: "#daa520"} // 黄
            //     CheckBtn{width: 100; height: 40; labelText: "复选3"; checkColor: "#87ceeb"} // 蓝
            //     CheckBtn{width: 100; height: 40; labelText: "复选4"; checkColor: "#ffd0d0"} // 粉
            // }

            // 点击按钮
            // Row{
            //     spacing: 20

            //     ClickBtn{width: 100; height: 50; btnColor: "#80d080"; btnText: "btn1"}
            //     ClickBtn{width: 100; height: 50; btnColor: "#daa520"; btnText: "按钮2"}
            //     ClickBtn{width: 100; height: 50; btnColor: "#87ceeb"}
            //     ClickBtn{width: 100; height: 50; btnColor: "#ffd0d0"}
            // }

            // 单选按钮组
            Row{
                spacing: 20

                // RadioBtnCombobox{
                //     width: 340
                //     height: 300
                //     checkColor: "#80d080"
                //     listModel: ListModel{
                //         ListElement{labelText: "按钮1"}
                //         ListElement{labelText: "按钮2"}
                //         ListElement{labelText: "按钮3"}
                //     }
                // }
                RadioBtnCombobox{
                    width: 100
                    height: 300
                    checkColor: "#ffd0d0"
                    listModel: ListModel{
                        ListElement{labelText: "前进"}
                        ListElement{labelText: "空挡"}
                        ListElement{labelText: "后退"}
                    }
                }
            }
        }

        LabeledSlider {
            label: "油门"
            value: throttle
            min: 0
            max: 100
            unit: "%"
            onValueChanged: throttle = value
            //anchors.fill：
        }

        // 最大速度
        LabeledSlider {
            label: "舵角"
            value: rudder_angle
            min: -30
            max: 30
            unit: "°"
            onValueChanged: rudder_angle = value
            //anchors.fill
        }
    
    }
}
