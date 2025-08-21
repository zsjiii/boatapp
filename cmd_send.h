#ifndef CMD_SEND_H
#define CMD_SEND_H

#include <QObject>
#include <QDebug>
#include <QDateTime>
#include <QTimer>
#include <math.h>
#include "define.h"
#include "crc16.h"
#include "udpmanager.h"
class CMD_Send : public QObject
{
    Q_OBJECT
public:
    explicit CMD_Send(QObject *parent = nullptr);
    int boatTYPE;
    //发送指令，协议CTRL_CMD
    Q_INVOKABLE void Ctrl_Cmd_Send(BYTE cmd_type, BYTE ctrl_cmd );
    //发送指令，协议CTRL_FLOAT
    Q_INVOKABLE void Ctrl_Float_Send(BYTE cmd_type, float ctrl_cmd);
    //发送指令，协议BOAT_PATH_SET
    Q_INVOKABLE void Boat_Path_Send(QVariant v);
    UdpManager* m_udpcmdsend;
signals:
    void udpOut_signal(uchar *pdata,qint16 size,int id);
};

#endif // CMD_SEND_H
