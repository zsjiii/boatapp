#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <memory>
#include "serialportmanager.h"
#include "udpmanager.h"
#include "QFile"
#include <QDirIterator>
#include "cmd_send.h"

int main(int argc, char *argv[])
{
    // 强制使用特定 OpenGL 版本
    qputenv("QTWEBENGINE_CHROMIUM_FLAGS", "--no-sandbox");
    qputenv("QT_OPENGL", "desktop");
    QGuiApplication a(argc, argv);

    // Set up code that uses the Qt event loop here.
    // Call a.quit() or a.exit() to quit the application.
    // A not very useful example would be including
    // #include <QTimer>
    // near the top of the file and calling
    // QTimer::singleShot(5000, &a, &QCoreApplication::quit);
    // which quits the application after 5 seconds.

    // If you do not need a running Qt event loop, remove the call
    // to  exec() or use the Non-Qt Plain C++ Application template.

    //CMD_Send* p = new CMD_Send();
    std::unique_ptr<CMD_Send> p = std::make_unique<CMD_Send>();

    // 注册UDP管理器
    //qmlRegisterType<UdpManager>("Network", 1, 0, "UdpManager");
    // qmlRegisterSingletonType<UdpManager>("Network", 1, 0, "UdpManager", 
    // [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject* {
    //     Q_UNUSED(engine)
    //     Q_UNUSED(scriptEngine)
    //     return &UdpManager::instance();
    // });

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &a,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.rootContext()->setContextProperty("udpManager", p->m_udpcmdsend);
    engine.rootContext()->setContextProperty("cmdSend", p.get());


    // 检查屏幕数量
    qDebug() << "Available screens:" << QGuiApplication::screens().count();
    QString fileqrc;
    fileqrc.append( ":/image/res/skin.png");
    if(QFile::exists(fileqrc)) {
        qDebug() << "资源存在!";
    } else {
        qDebug() << "资源未找到!";
    }
    // QDirIterator it(":", QDirIterator::Subdirectories);
    // while (it.hasNext()) {
    //     qDebug() << "Resource path:" << it.next();
    // }
    // 获取 Page2 对象
    // QObject *rootObject = engine.rootObjects().first();
    // page2 = rootObject->findChild<QObject*>("Page2");

    // if (!page2) {
    //     qWarning() << "Page2 object not found!";
    //     return -1;
    // }
    // 注册串口管理器
    qmlRegisterType<SerialPortManager>("SerialPort", 1, 0, "SerialPortManager");

    engine.loadFromModule("ziyannewcc1_qml", "Main");

    // 打印生命周期标记
    // qDebug() << "Application running...";

    //UdpManager myudp(NULL);

    // qDebug() << "Application about to quit";

    // 在main()返回前添加
    // qDebug() << "----- Object Tree -----";
    // QObject *obj = new QObject();
    // obj->dumpObjectTree();  // 正确

    return a.exec();
}
