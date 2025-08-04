cmake_minimum_required(VERSION 3.16)

project(ziyannewcc1_qml VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)  # 关键！启用 Qt 资源编译
set(CMAKE_BUILD_TYPE Debug)  # 确保为 Debug 构建
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0")  # 禁用优化，嵌入符号
# 查找基础 Qt 组件
set(CMAKE_PREFIX_PATH /usr/lib/x86_64-linux-gnu/qt6)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
find_package(Qt6 REQUIRED COMPONENTS Core Quick Network SerialPort Multimedia Core5Compat WebEngineWidgets WebEngineQuick WebEngineCore)
# find_package(Qt6 6.9.1 REQUIRED WebEngine WebEngineQuick WebEngineCore)
# target_link_libraries(appziyannewcc1_qml PRIVATE
#     Qt6::WebEngine
#     Qt6::WebEngineQuick
# )
# Android 特殊处理
# if(ANDROID)
#     find_package(Qt6 REQUIRED COMPONENTS AndroidCoreHelpers)
#     # 添加 Android 特定配置
#     add_library(native-lib SHARED native-lib.cpp)
#     target_link_libraries(native-lib Qt6::AndroidCoreHelpers)
# endif()
qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appziyannewcc1_qml
    main.cpp
    crc16.cpp crc16.h define.h serialportmanager.cpp serialportmanager.h udpmanager.cpp udpmanager.h

)
# 确保CMakeLists.txt包含资源
qt_add_resources(appziyannewcc1_qml
    PREFIX "/image"
    FILES
        qml.qrc
)
target_link_libraries(appziyannewcc1_qml PRIVATE ${PROJECT_RESOURCES})
qt_add_qml_module(appziyannewcc1_qml
    # RESOURCES qml.qrc
    URI ziyannewcc1_qml
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES Page1.qml
        QML_FILES Page2.qml
        QML_FILES Page3.qml
        QML_FILES Button_ZSJ1.qml
        QML_FILES AreaEdit.qml BtnsPage.qml CheckBtn.qml CircleProgress.qml ClickBtn.qml EditPage.qml Instrument.qml LineEdit.qml Pages.qml ProgressesPage.qml RadioBtnCombobox.qml RippleProgress.qml Sidebar.qml SidebarItem.qml SkinItem.qml SkinPage.qml SliderProgress.qml SwitchBtn.qml Table.qml TablePage.qml
        QML_FILES Page_MAP.qml
        QML_FILES Topbar.qml
        QML_FILES MenuItem_ZSJ1.qml
        QML_FILES TabItem_ZSJ1.qml
        QML_FILES DrongItem.qml
        QML_FILES canshusetPage.qml

)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appziyannewcc1_qml PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appziyannewcc1_qml
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE

)

target_link_libraries(appziyannewcc1_qml
    PRIVATE Qt6::Quick
    Qt6::Core
    Qt6::SerialPort
    Qt6::Multimedia
    Qt6::Core5Compat
)
include(GNUInstallDirs)
# install(TARGETS appziyannewcc1_qml
#     BUNDLE DESTINATION .
#     LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
#     RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
# )
