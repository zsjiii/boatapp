import QtQuick

// 控制显示各个页面
Item {
    property int pageIndex: 0

    id: root
    // 表格页面
    Page_MAP{
        id:pageMAP
        //anchors.fill: parent
        anchors.top: root.top
        anchors.left: root.left
        //anchors.fill: parent
        width: root.width
        height: root.height
        //visible: root.pageIndex === 4

        // 进度条页面
        DrongItem{
            id:progressesPage
            anchors.fill: parent
            visible: root.pageIndex === 1
        }
        // 按钮页面
        BtnsPage{
            //anchors.fill: parent
            anchors.bottom:  root.bottom
            anchors.right: root.right
            //anchors.fill: parent
            width: root.width/4
            height: root.height/2
            visible: root.pageIndex === 0
        }
    }

    // 表格页面
    Page3{
        id:pagevideo
        //anchors.fill: parent
        anchors.top: root.top
        anchors.left: pageMAP.right
        //anchors.fill: parent
        width: root.width/4
        height: root.height/4
        //visible: root.pageIndex === 2
    }


    // 编辑页面
    Page1{
        id: page1
        page2Object: page2
        anchors.fill: parent
        visible: root.pageIndex === 5
    }

    // 表格页面
    Page2{
        id:page2
        anchors.fill: parent
        visible: root.pageIndex === 3
    }

}
