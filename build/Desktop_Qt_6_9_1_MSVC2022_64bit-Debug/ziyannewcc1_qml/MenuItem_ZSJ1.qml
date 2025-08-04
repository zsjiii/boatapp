import QtQuick

// 菜单项组件
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: menuItem
    width: 120
    height: root.height
    property string menuText: "菜单项"
    property string menuIcon: "•"
    property color itemColor: "#3498db"
    property bool hasDropdown: false
    property bool isActive: false
    property bool showBackground: false
    property color textColor: "white"

    signal clicked()
    // 示例数据：支持多层级结构
    property var subModel: {
            "水果": {
                "国产": {
                    "苹果": ["红富士", "蛇果"],
                    "香蕉": ["小米蕉", "皇帝蕉"],
                    "橙子": ["脐橙", "血橙"]
                },
                "进口": {
                    "苹果": ["富士", "嘎啦"],
                    "香蕉": ["小香蕉", "大蕉"],
                    "橙子": ["血橙", "普通橙"]
                }
            },
            "蔬菜": {
                "国产": {
                    "土豆": ["黄心土豆", "紫土豆"],
                    "胡萝卜": ["红胡萝卜", "黄胡萝卜"],
                    "黄瓜": ["旱黄瓜", "水黄瓜"]
                },
                "进口": {
                    "土豆": ["外国土豆1", "外国土豆2"],
                    "胡萝卜": ["外国胡萝卜1", "外国胡萝卜2"],
                    "黄瓜": ["外国黄瓜1", "外国黄瓜2"]
                }
            },
            "1": {
                "A组": {
                    "11": ["111", "112"],
                    "12": ["121", "122"],
                    "13": ["131", "132"]
                },
                "B组": {
                    "11": ["211", "212"],
                    "12": ["221", "222"],
                    "13": ["231", "232"]
                }
            },
            "2": {
                "C组": {
                    "21": ["311", "312"],
                    "22": ["321", "322"],
                    "23": ["331", "332"]
                },
                "D组": {
                    "21": ["411", "412"],
                    "22": ["421", "422"],
                    "23": ["431", "432"]
                }
            }
    }

    // 当前选中的菜单项
    property string selectedSubItem: "设备责任人"

    // 用于存储所有已打开的动态菜单 Popup（索引即层级）
    property var openMenus: []

    // 关闭从指定层级开始的所有已打开菜单
    function closeDynamicMenus(level) {
        for (var i = openMenus.length - 1; i >= level; i--) {
            if (openMenus[i]) {
                openMenus[i].close();
                openMenus[i].destroy();
            }
            openMenus.splice(i, 1);
        }
    }

    // 在指定层级打开菜单
    // level：菜单层级（主菜单点击后，子菜单为 1 级，依此类推）
    // data：当前层级菜单数据
    // anchor：用于定位 Popup 的参照项
    function openDynamicMenu(level, data, anchor) {
        closeDynamicMenus(level);
        var menu = dynamicMenuComponent.createObject(root, { "menuData": data, "level": level });
        var pos = anchor.mapToItem(root, anchor.width, 0);
        menu.x = pos.x;
        menu.y = pos.y;
        menu.open();
        openMenus[level] = menu;
    }

    // 主按钮：显示当前选中项
    Rectangle {
        id: mainButton
        width: parent.width
        height: parent.height
        color: "lightgray"
        border.color: "gray"
        //radius: 5
        RowLayout {
            anchors.fill: parent
            spacing: 0
            Text {
                id: mainText
                //anchors.centerIn: parent
                text: menuItem.selectedSubItem
            }
            Text {
                id: xialatag
                //anchors.centerIn: parent
                text: "▼"
            }

        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                // 显示主菜单时，关闭所有子菜单
                mainListView.visible = true;
                closeDynamicMenus(0);
            }
        }
    }

    // 主菜单 ListView，显示最外层（第一层）的菜单项
    ListView {
        id: mainListView
        visible: false
        width: parent.width
        x: mainButton.x
        y: mainButton.y + mainButton.height
        // 根据内容高度动态调整，但最多200像素
        height: Math.min(mainListView.count * mainButton.height, 200)
        model: Object.keys(menuItem.subModel)
        delegate: Item {
            width: mainListView.width
            height: mainButton.height
            RowLayout {
                anchors.fill: parent
                spacing: 0
                // 左侧显示菜单文本
                Rectangle {
                    id: mainTextRect
                    Layout.preferredWidth: parent.width * 0.75
                    height: parent.height
                    color: "lightgray"
                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        verticalAlignment: Text.AlignVCenter
                        padding: 10
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {

                                mainListView.visible = false;
                                menuItem.selectedSubItem =modelData;
                            // var childData = mainListView.subModel[modelData];
                            // if (childData !== undefined &&
                            //    ((Array.isArray(childData) && childData.length > 0) ||
                            //     (typeof childData === "object" && Object.keys(childData).length > 0))) {
                            //     // 存在子菜单，打开下一级菜单（level 1）
                            //     openDynamicMenu(1, childData, mainTextRect);
                            //     parent.selectedSubItem = modelData;
                            //     mainText.text = modelData;
                            //     mainListView.visible = false;
                            //     mainListView.selectedSubItem =modelData;
                            //     closeDynamicMenus(0);

                            // } else {
                            //     // 叶子节点：更新选中并关闭所有菜单
                            //     parent.selectedSubItem = modelData;
                            //     mainText.text = modelData;
                            //     mainListView.visible = false;
                            //     closeDynamicMenus(0);
                            // }
                        }
                    }
                }
                // 右侧显示箭头：如果存在子菜单则显示 "▶"，否则为空
                Rectangle {
                    id: mainArrowRect
                    Layout.preferredWidth: parent.width * 0.25
                    height: parent.height
                    color: "lightgray"
                    Text {
                        anchors.centerIn: parent
                        color: "green"
                        text: {
                            var childData = parent.subModel[modelData];
                            if (childData !== undefined &&
                               ((Array.isArray(childData) && childData.length > 0) ||
                                (typeof childData === "object" && Object.keys(childData).length > 0))) {
                                return "▶";
                            }
                            return "";
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var childData = parent.subModel[modelData];
                            if (childData !== undefined &&
                               ((Array.isArray(childData) && childData.length > 0) ||
                                (typeof childData === "object" && Object.keys(childData).length > 0))) {
                                openDynamicMenu(1, childData, mainArrowRect);
                            }
                        }
                    }
                }
            }
        }
    }

    // 通用动态菜单 Popup 组件，用于构造任意层级的子菜单
    Component {
        id: dynamicMenuComponent
        Popup {
            id: dynPopup
            // 当前层级菜单数据（可以是数组或对象）
            property var menuData
            // 当前菜单层级，主菜单点击后生成的菜单 level 为 1，依次递增
            property int level: 0
            width: root.width*0.75
            padding: 1
            height: Math.min(listView.contentHeight, 200)
            background: Rectangle {
                color: "#ffffff"
                border.color: "#cccccc"
                radius: 5
            }
            ListView {
                id: listView
                anchors.fill: parent
                model: (typeof dynPopup.menuData === "object" && !Array.isArray(dynPopup.menuData))
                       ? Object.keys(dynPopup.menuData)
                       : dynPopup.menuData
                delegate: Item {
                    width: listView.width
                    height: root.height
                    RowLayout {
                        anchors.fill: parent
                        spacing: 0
                        Layout.margins: 0
                        // 左侧显示菜单项文本
                        Rectangle {
                            id: dynTextRect
                            Layout.fillWidth: true
                            Layout.preferredWidth: parent.width * 0.75
                            height: parent.height
                            color: "lightgray"
                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                verticalAlignment: Text.AlignVCenter
                                padding: 10
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    var childData;
                                    if (typeof dynPopup.menuData === "object" && !Array.isArray(dynPopup.menuData)) {
                                        childData = dynPopup.menuData[modelData];
                                    }
                                    if (childData !== undefined &&
                                       ((Array.isArray(childData) && childData.length > 0) ||
                                        (typeof childData === "object" && Object.keys(childData).length > 0))) {
                                        // 存在下一级子菜单，打开下一层
                                        // root.openDynamicMenu(dynPopup.level + 1, childData, dynTextRect);
                                        root.selectedSubItem = modelData;
                                        mainText.text = modelData;
                                        mainListView.visible = false;
                                        root.closeDynamicMenus(0);
                                    } else {
                                        // 叶子节点：更新选中并关闭所有菜单
                                        root.selectedSubItem = modelData;
                                        mainText.text = modelData;
                                        mainListView.visible = false;
                                        root.closeDynamicMenus(0);
                                    }
                                }
                            }
                        }
                        // 右侧箭头，若存在子菜单则显示，否则为空
                        Rectangle {
                            id: dynArrowRect
                             Layout.fillWidth: true
                            Layout.preferredWidth: parent.width * 0.25
                            height: parent.height
                            color: "lightgray"
                            Text {
                                anchors.centerIn: parent
                                color: "green"
                                text: {
                                    var childData;
                                    if (typeof dynPopup.menuData === "object" && !Array.isArray(dynPopup.menuData)) {
                                        childData = dynPopup.menuData[modelData];
                                    }
                                    if (childData !== undefined &&
                                       ((Array.isArray(childData) && childData.length > 0) ||
                                        (typeof childData === "object" && Object.keys(childData).length > 0))) {
                                        return "▶";
                                    }
                                    return "";
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    var childData;
                                    if (typeof dynPopup.menuData === "object" && !Array.isArray(dynPopup.menuData)) {
                                        childData = dynPopup.menuData[modelData];
                                    }
                                    if (childData !== undefined &&
                                       ((Array.isArray(childData) && childData.length > 0) ||
                                        (typeof childData === "object" && Object.keys(childData).length > 0))) {
                                        root.openDynamicMenu(dynPopup.level + 1, childData, dynArrowRect);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
