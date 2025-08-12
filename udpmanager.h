#ifndef UDPMANAGER_H
#define UDPMANAGER_H

#include <QObject>
#include <QUdpSocket>
#include <QNetworkDatagram>

class UdpManager : public QObject
{
    Q_OBJECT
public:
    // 获取单例实例（线程安全）
    static UdpManager& instance();
    
    // 删除拷贝构造函数和赋值运算符
    UdpManager(const UdpManager&) = delete;
    UdpManager& operator=(const UdpManager&) = delete;
    UdpManager(UdpManager&&) = delete;
    UdpManager& operator=(UdpManager&&) = delete;

    //~UdpManager();

    Q_INVOKABLE bool bind(quint16 port);
    Q_INVOKABLE void close();
    Q_INVOKABLE bool sendData(const QString &data, const QString &address, quint16 port);
    void sig_DataRecv(QByteArray rcvdata);
public slots:
    void  slot_sendData(uchar *hdata,qint16 size,int id);
signals:
    void dataReceived(const QString &data, const QString &sender, quint16 port);

private slots:
    void onReadyRead();

private:
    explicit UdpManager(QObject *parent = nullptr);
    ~UdpManager() = default;
    QUdpSocket *m_udpSocket;
};

#endif // UDPMANAGER_H
