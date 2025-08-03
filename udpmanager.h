#ifndef UDPMANAGER_H
#define UDPMANAGER_H

#include <QObject>
#include <QUdpSocket>
#include <QNetworkDatagram>

class UdpManager : public QObject
{
    Q_OBJECT
public:
    explicit UdpManager(QObject *parent = nullptr);

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
    QUdpSocket *m_udpSocket;
};

#endif // UDPMANAGER_H
