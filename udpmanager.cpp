#include "udpmanager.h"
#include <QDebug>
#include "define.h"
#include "crc16.h"
BOAT_INFO1 zh_info;

// C++11保证静态局部变量初始化是线程安全的
UdpManager& UdpManager::instance()
{
    static UdpManager instance;
    return instance;
}

UdpManager::UdpManager(QObject *parent) : QObject(parent) 
{
    m_udpSocket = new QUdpSocket(this);  // 关键：设置父对象
    connect(m_udpSocket, &QUdpSocket::readyRead, this, &UdpManager::onReadyRead);
}

bool UdpManager::bind(quint16 port)
{
    return m_udpSocket->bind(port);
}

void UdpManager::close()
{
    m_udpSocket->close();
}

bool UdpManager::sendData(const QString &data, const QString &address, quint16 port)
{
    qint64 ret = m_udpSocket->writeDatagram(data.toUtf8(), QHostAddress(address), port);
    return ret != -1;
}

void  UdpManager::slot_sendData(uchar *hdata,qint16 size,int id)
{
    m_udpSocket->writeDatagram((const char*)hdata,size,QHostAddress("192.168.18.87"),10600);
}

void UdpManager::onReadyRead()
{
    QByteArray datagram;
    if(m_udpSocket->hasPendingDatagrams())
    {
        datagram.clear();
        datagram.resize(m_udpSocket->pendingDatagramSize());
        m_udpSocket->readDatagram(datagram.data(),datagram.size());
        sig_DataRecv(datagram);
    }
    while (m_udpSocket->hasPendingDatagrams()) {
        QNetworkDatagram datagram = m_udpSocket->receiveDatagram();
        emit dataReceived(QString::fromUtf8(datagram.data().constData()),
                         datagram.senderAddress().toString(),
                         datagram.senderPort());
    }
}
void UdpManager::sig_DataRecv(QByteArray rcvdata)
{
    //qDebug()<<"revinfo1------";


    uchar pbuf[102];
    ushort  xu_crc=0;
    uint leng=rcvdata.size();

    if(leng>=sizeof(STATU_INFO1))
    {

        memcpy(&zh_info,rcvdata.data(),sizeof(STATU_INFO1));

        // 从报文中获取校验和
        ushort crc = static_cast<uchar>(rcvdata.at(leng - 3)) << 8 | static_cast<uchar>(rcvdata.at(leng - 2));
//        if (processedMessagesSet.contains(crc)) // 如果已经处理过，则直接返回
//        {
////            qDebug() << "获取报文重复";
//          //  return;
//        } else{
////            qDebug() << "新的报文";
//        }
//        // 否则记录下这个报文
//        processedMessages.enqueue(crc);
//        processedMessagesSet.insert(crc);
//        // 保持队列大小为20
//        if (processedMessages.size() > 20)
//        {
//            ushort oldestCrc = processedMessages.dequeue();
//            processedMessagesSet.remove(oldestCrc);
//        }

        if((zh_info.da_head.head_begin[0]==0xF5)&&(zh_info.da_head.head_begin[1]==0xF4)&&(zh_info.da_head.head_begin[2]==0xF3)
                &&(zh_info.da_head.head_begin[3]==0xF2)&&(zh_info.da_head.head_begin[4]==0xF1))
        {

            memcpy(&zh_info,rcvdata.data(),sizeof(BOAT_INFO1));
            uchar msg[500];
            memcpy(msg, rcvdata.data(), rcvdata.size());
            ushort crc_da= CrcCrt(msg,228);
            if((crc_da==zh_info.da_end.all_crc)&&(zh_info.da_head.cmd_type==0x01)&&(zh_info.da_end.tail==0x55AA))
            {
                //xianshi
            }
        }
    }
}
