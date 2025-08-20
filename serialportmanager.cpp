#include "serialportmanager.h"
#include <QQmlApplicationEngine>
#include <cstdio>
extern BOAT_INFO1 zh_info;
extern QObject *page2;
int g_ctrl_id;
SerialPortManager::SerialPortManager(QObject *parent) : QObject(parent)
{
    m_udpmode = new UdpManager();
    m_serial = new QSerialPort(this);
    connect(m_serial, &QSerialPort::readyRead, this, &SerialPortManager::onReadyRead);
    connect(this,&SerialPortManager::udpOut_signal,m_udpmode,&UdpManager::slot_sendData);
    m_ptimer = new QTimer();
    connect(m_ptimer,SIGNAL(timeout()),this,SLOT(timer_slot()));
    //m_ptimer->start(1000);

    // 获取 Page2 对象
    // QQmlApplicationEngine engine;
    // QObject *rootObject = engine.rootObjects().first();
    // page2 = rootObject->findChild<QObject*>("page2");

    // if (!page2) {
    //     qWarning() << "Page2 object not found!";
    // }

}

SerialPortManager::~SerialPortManager()
{
    closePort();
    delete m_serial;
}

bool SerialPortManager::openPort(const QString &portName, int baudRate)
{
    if(m_serial->isOpen()) {
        m_serial->close();
    }

    m_serial->setPortName(portName);
    m_serial->setBaudRate(baudRate);
    m_serial->setDataBits(QSerialPort::Data8);
    m_serial->setParity(QSerialPort::NoParity);
    m_serial->setStopBits(QSerialPort::OneStop);
    m_serial->setFlowControl(QSerialPort::NoFlowControl);

    return m_serial->open(QIODevice::ReadWrite);
}

void SerialPortManager::closePort()
{
    if(m_serial->isOpen()) {
        m_serial->close();
    }
}

bool SerialPortManager::sendData(const QString &data)
{
    // if(!m_serial->isOpen()) {
    //     return false;
    // }
    
    qint64 bytesWritten = m_serial->write(data.toUtf8());
    return bytesWritten != -1;
}

QStringList SerialPortManager::availablePorts()
{
    QStringList ports;
    foreach(const QSerialPortInfo &info, QSerialPortInfo::availablePorts()) {
        ports << info.portName();
    }
    return ports;
}

void SerialPortManager::onReadyRead()
{
    QByteArray data = m_serial->readAll();
    quint16 len;
    if(data.length())
    {
        m_data += data;
    }
    while(m_data.length() >= 42)
    {
        if(m_data[0] == '\x55' && m_data[1] == '\x66')
        {
            //qDebug()<< QString::number(m_data[40],16)<<QString::number(m_data[41],16)<<Qt::endl;
            ushort revcrc = (unsigned short)(m_data[40] | m_data[41] << 8);
            uint32_t crcint;
            uint16_t crc = crc_check_16bites((unsigned char*)&m_data[0],40,&crcint);
            //qDebug()<< revcrc << crcint<<Qt::endl;
            if(revcrc == crcint && m_data[3] == '\x20')
            {

                //QByteArray ch = m_data.mid(5,64);//sbuf1 32 byte + sbuf2 32 byte
                memcpy(&revinfo,m_data.data(),sizeof(UniRC));

                //将数据转换为 QVariantList 并发送到 QML
                QVariantList list;
                for (const auto& value : revinfo.DATA) {
                    list.append(value);
                }
                //qDebug()<<"xuSerialThread::dataReceived()\n";
                emit dataReceived(list);

                //处理串口信息，变为具体指令信息
                Sig_Send_t30info(&revinfo);
                //Handle_t30info(revt30info);
            }
            else
            {
                qDebug()<<"xuSerialThread::slot_readyRead()::data leng error!\n";
            }
            m_data.remove(0,42);
        }
        else
        {   if(m_data.count())
                m_data.remove(0,1);
            else {
                qDebug()<<"no serial data"<<Qt::endl;
            }
        }
    }
    QString receivedData = QString::fromUtf8(data);
    qDebug() << "Received data:" << data.toHex();  // 添加调试输出
    //emit dataReceived(receivedData);
}

void SerialPortManager::timer_slot()
{
    if(m_control_snd_flg==true && send_time<5)
    {
        emit udpOut_signal(m_conctrlbuf,m_conctrlbuf_sndsize,g_ship_index);
        //emit udpOut_signal(m_Terminalbuf,m_Terminalbuf_sndsize);
        //emit udpOut_signal(m_otherbuf,m_otherbuf_sndsize);
        send_time++;
        if(send_time==1)
        {
            m_control_snd_flg = false;
        }
    }
    if(m_terminal_snd_flg==true && send_time<5)
    {
        //emit udpOut_signal(m_conctrlbuf,m_conctrlbuf_sndsize);
        //emit udpOut_signal(m_Terminalbuf,m_Terminalbuf_sndsize,g_ship_index);
        //emit udpOut_signal(m_otherbuf,m_otherbuf_sndsize);
        send_time++;
        if(send_time==1)
            m_terminal_snd_flg = false;
    }
    if(m_other_snd_flg==true && send_time<5)
    {
        //emit dpOut_signal(m_conctrlbuf,m_conctrlbuf_sndsize);
        //emit udpOut_signal(m_Terminalbuf,m_Terminalbuf_sndsize);
        emit udpOut_signal(m_otherbuf,m_otherbuf_sndsize,g_ship_index);
        send_time++;
        if(send_time==1)
            m_other_snd_flg = false;
    }

}

using GasPeda = uint8_t (*)(double, double, double, double, double); // 油门的线性映射命名空间声明
    GasPeda gasPeda = [](double value, double inMin, double inMax, double outMin, double outMax) -> uint8_t {
            double percentage = (value - inMin) / (inMax - inMin); // 将原始值映射到 0-1 范围内
            if (percentage < 0){
                return 0;
            }
            // 将百分比映射到目标范围内并转换为 uint8_t 类型
            uint8_t result = static_cast<uint8_t>(outMin + percentage * (outMax - outMin));
            // 确保结果在 uint8_t 取值范围内,超过边界值则取边界值
            uint8_t clampedResult = static_cast<uint8_t>(result > static_cast<uint8_t>(outMax) ? static_cast<uint8_t>(outMax) : (result < static_cast<uint8_t>(outMin) ? static_cast<uint8_t>(outMin) : result));
            return clampedResult;
        };


using AngleDen = float (*)(float, float, float, float, float); // 舵角的线性映射命名空间声明
    AngleDen angleDen = [](float value, float inMin, float inMax, float outMin, float outMax) -> float {
            float percentage = (value - inMin) / (inMax - inMin);// 将原始值映射到 0-1 范围内
            float result = outMin + percentage * (outMax - outMin);
            //return std::min(std::max(result, outMin), outMax);
            return std::min(std::max(result, outMin), outMax);
//            return 45;
        };
void SerialPortManager::Sig_Send_t30info(UniRC* prevdata)
{
    // 基于波特率计算多少毫秒调用一次该函数
    QDateTime currentTime = QDateTime::currentDateTime();
    if (lastCallTime.isValid())
    {
        qint64 interval = lastCallTime.msecsTo(currentTime);
        serialPortTime = interval;
    }
    lastCallTime = currentTime;
    /************F1按钮处理逻辑********************/
    //控制权切换,0x04表示便携控制器请求切换；0x05表示艇端显控器切换
    handoff = 0x00;
    if (prevdata->DATA[13] == 200) // handoff按钮按下
    {
        handoff = 0x04;
    }
    /************F2按钮处理逻辑********************/
    //控制权切换,0x04表示便携控制器请求切换；0x05表示艇端显控器切换
    if (prevdata->DATA[14] == 200) // handoff按钮按下
    {
        handoff = 0x05;
    }
    if(g_ctrl_id == 0x01)
    {

        /************档位设置********************/
        //前进挡
        if(prevdata->DATA[6] == 1950 && zh_info.s_info1.b_LeftGas <= 5 && zh_info.s_info1.b_RightGas <=5)
        {
            gear = 0x01;
        }
        else if(prevdata->DATA[8] == 1950 && (zh_info.s_info1.b_LeftGas>5 || zh_info.s_info1.b_RightGas >5))
        {
            //qDebug()<<"请将油门置零后再进行换挡操作";
        }

        //空挡
        if(prevdata->DATA[8] == 1500)
        {
            gear = 0x02;
        }

        //后退挡
        if(prevdata->DATA[8] == 1050 && zh_info.s_info1.b_LeftGas <=5 && zh_info.s_info1.b_RightGas <=5)
        {
            gear = 0x03;
        }
        else if(prevdata->DATA[8] == 1050 && (zh_info.s_info1.b_LeftGas >5 || zh_info.s_info1.b_RightGas >5))
        {
            //qDebug()<<"请将油门置零后再进行换挡操作";
        }

        /************工作模式********************/

        if(prevdata->DATA[4] == 1000)          //有人
        {
            cruise_mode = 0x00;
        }
        else if(prevdata->DATA[4] == 1250)     //无人
        {
            cruise_mode = 0x01;
        }
        else if(prevdata->DATA[4] == 1425)    //自动巡航
        {
            cruise_mode = 0x11;
        }

        /************发动机的点火启动，熄火停车********************/
        onoff = 0x00;
        if(prevdata->DATA[7] == 1050)
        {
            if(zh_info.s_info1.b_LeftMotorWorkState == 0x04 || zh_info.s_info1.b_LeftMotorWorkState == 0x00)
                onoff = 0x01;
            else if(zh_info.s_info1.b_LeftMotorWorkState == 0x01)
                onoff = 0x04;
        }
        if(prevdata->DATA[7] == 1950)
        {
            if(zh_info.s_info1.b_LeftMotorWorkState == 0x04 || zh_info.s_info1.b_LeftMotorWorkState == 0x02)
                onoff = 0x01;
            else if(zh_info.s_info1.b_LeftMotorWorkState == 0x01)
                onoff = 0x04;
        }


    //    /************F6按钮舱盖急停********************/
    //    if (rev_info->sbus2[15] == 200 && !stopProcessed)
    //    {
    //        stopProcessed = true;
    //        emergencyStop = true;
    //        qDebug() <<"111";
    //    }
    //    else if (rev_info->sbus2[15] != 200 && stopProcessed)
    //    {
    //        stopProcessed = false;
    //        qDebug() <<"222";
    //    }

        // 下面为油门增减，输出值为gasPedaValue，实际值为precisionThrottle

        /************油门向上********************/
        int accelerationGear=0;
        if( prevdata->DATA[1] > 1500  && prevdata->DATA[1] < 1590 )
            accelerationGear =5;
        else if( prevdata->DATA[1] >= 1590  && prevdata->DATA[1] < 1680 )
            accelerationGear =4;
        else if( prevdata->DATA[1] >= 1680  && prevdata->DATA[1] < 1770 )
            accelerationGear =3;
        else if( prevdata->DATA[1] >= 1770  && prevdata->DATA[1] < 1860 )
            accelerationGear =2;
        else if( prevdata->DATA[1] >= 1860 )
            accelerationGear =1;

        if( prevdata->DATA[0] > 1505 )
        {
            forwardThrottleTime += serialPortTime;
            //qDebug() <<"前进计时"<<forwardThrottleTime;
            if(forwardThrottleTime >= 1000)
            {
                forwardThrottleTime =0;
                switch (accelerationGear)
                {
                    case 1:
                        precisionThrottle += 5;
                        gasPedaValue = static_cast<uint8_t>(precisionThrottle + 0.5);
                        break;
                    case 2:
                        precisionThrottle += 3.333;
                        gasPedaValue = static_cast<uint8_t>(precisionThrottle + 0.5); //
                        break;
                    case 3:
                        precisionThrottle += 2.857;
                        gasPedaValue = static_cast<uint8_t>(precisionThrottle + 0.5);//
                        break;
                    case 4:
                        precisionThrottle += 2.5;
                        gasPedaValue = static_cast<uint8_t>(precisionThrottle + 0.5);
                        break;
                    case 5:
                        precisionThrottle += 2;
                        gasPedaValue = static_cast<uint8_t>(precisionThrottle + 0.5);
                        break;
                }
            }
        }

        /************油门向下********************/
        if( prevdata->DATA[1] > 1400  && prevdata->DATA[1] <= 1495 )
            accelerationGear =6;
        else if( prevdata->DATA[1] > 1300  && prevdata->DATA[1] <= 1400 )
            accelerationGear =7;
        else if( prevdata->DATA[1] > 1200  && prevdata->DATA[1] <= 1300 )
            accelerationGear =8;
        else if( prevdata->DATA[1] > 1050  && prevdata->DATA[1] <= 1200 )
            accelerationGear =9;
        else if( prevdata->DATA[1] <= 1050 )
            accelerationGear =10;
        if( prevdata->DATA[1] < 1495 )
        {
            reduceThrottleTime += serialPortTime;
            if(reduceThrottleTime >= 1000)
            {
                reduceThrottleTime =0;
                switch (accelerationGear)
                {
                    case 10:
                        precisionThrottle -= 5;
                        if(precisionThrottle < 0){
                            gasPedaValue = 0;
                            precisionThrottle =0;
                        } else {
                            gasPedaValue = static_cast<uint8_t>(precisionThrottle + 0.5);
                        }
                        break;
                    case 9:
                        precisionThrottle -= 3.333;
                        if(precisionThrottle < 0){
                            gasPedaValue = 0;
                            precisionThrottle =0;
                        } else {
                            gasPedaValue = static_cast<uint8_t>(precisionThrottle + 0.5);
                        }
                        break;
                    case 8:
                        precisionThrottle -= 2.857;
                        if(precisionThrottle < 0){
                            gasPedaValue = 0;
                            precisionThrottle =0;
                        } else {
                            gasPedaValue = static_cast<uint8_t>(precisionThrottle + 0.5);
                        }
                        break;
                    case 7:
                        precisionThrottle -= 2.5;
                        if(precisionThrottle < 0){
                            gasPedaValue = 0;
                            precisionThrottle =0;
                        } else {
                            gasPedaValue = static_cast<uint8_t>(precisionThrottle + 0.5);
                        }
                        break;
                    case 6:
                        precisionThrottle -= 2;
                        if(precisionThrottle < 0){
                            gasPedaValue = 0;
                            precisionThrottle =0;
                        } else {
                            gasPedaValue = static_cast<uint8_t>(precisionThrottle + 0.5);
                        }
                        break;
                }
            }
        }
        if(gasPedaValue > 100)
        {
            gasPedaValue = 100;
        }
        if(gasPedaValue < 0)
        {
            gasPedaValue = 0;
        }

        /************油门向左********************/
        if(prevdata->DATA[0] < 1100)//油门快速归零
        {
            gasPedaValue = 0;
            precisionThrottle = 0;
        }
    //    else if(info->sbus1[1] < 700 && info->sbus1[1] >500 && throttleReturn)
    //    {
    //        throttleReturn = false;
    //    }

        /************F3按钮处理急停********************/
        if (prevdata->DATA[8] == 1950)
        {
            shipstopProcessed = true;
            spare = 0x01; // 切换急停状态
        }
        else if (prevdata->DATA[8] == 1050 && shipstopProcessed)
        {
            shipstopProcessed = false;
            spare = 0x00; // 切换急停状态
        }

        //float angleDenValue = angleDen(prevdata->DATA[3], 1050.0, 1950.0, -30, +30); //舵角
    }
    else if(g_ctrl_id == 0x05)
    {
        gasPedaValue = (int)angleDen(prevdata->DATA[1], 1050.0, 1950.0, 0, 200); //
    }
    //发动机/表面桨控制权切换，8.5m2和15m使用
//    if(my_groupcc->getComboBox()->currentText() == "8.5m1" ||
//       my_groupcc->getComboBox()->currentText() == "8.5m2" ||
//       my_groupcc->getComboBox()->currentText() == "11m"     )
    {

        float angleDenValue = angleDen(prevdata->DATA[3], 1050.0, 1950.0, -30, +30); //舵角
        SetDrivingCtrl( gear,  gasPedaValue,  angleDenValue,0, g_ship_index);
        SetCtrl_Premission( handoff ,g_ship_index);
        SetOtherCtrl( onoff,  spare,  cruise_mode, otherSwitches, g_ship_index, authorityControl);
    }

}

void SerialPortManager::SetDrivingCtrl(uchar gearCmd, uchar accCmd, float steerAngle,float elevatorRudder , int shipLenght)
{
    static uint16_t DrivingCtrlHeartBeat = 0x00; // 心跳
    uchar tmbuf[500];
    CTRL_CMD drivingcmd;
    drivingcmd.da_head.head_begin[0] = 0XF5;       // 头部标志
    drivingcmd.da_head.head_begin[1] = 0XF4;       // 头部标志
    drivingcmd.da_head.head_begin[2] = 0XF3;       // 头部标志
    drivingcmd.da_head.head_begin[3] = 0XF2;       // 头部标志
    drivingcmd.da_head.head_begin[4] = 0XF1;       // 头部标志
    drivingcmd.da_head.da_leng = 25; // 数据长度
    drivingcmd.da_head.source_ip[0]= 192;
    drivingcmd.da_head.source_ip[1]= 168;
    drivingcmd.da_head.source_ip[2]= 18;
    drivingcmd.da_head.source_ip[3]= 35;//源地址，不同的无人船IP不同

    drivingcmd.da_head.dest_ip[0] = 192;
    drivingcmd.da_head.dest_ip[1] = 168;
    drivingcmd.da_head.dest_ip[2] = 18;
    if(851 ==shipLenght)
    {
        drivingcmd.da_head.dest_ip[3] = 27;       // 源节点编号
    }
    else if(852 ==shipLenght)
    {
        drivingcmd.da_head.dest_ip[3] = 27;       // 源节点编号
    }
    else if(11 ==shipLenght)
    {
        drivingcmd.da_head.dest_ip[3] = 27;       // 源节点编号
    }
    else if(15 ==shipLenght)
    {
        drivingcmd.da_head.dest_ip[3] = 27;       // 源节点编号
    }

    drivingcmd.da_head.cfg_flg = 0x01;//确认标志，1表示需要确认

    drivingcmd.da_head.da_leng = 25;    //数据头+数据+数据尾    20+1+4
    drivingcmd.da_head.cfg_cmd = 0;  //当 cmd_type 指令是群发时，这里填写具体的指令类型，单发命令时填0
    drivingcmd.da_head.reserve[0] = 0;
    drivingcmd.da_head.reserve[1] = 0;
    if(gearCmd != old_gearCmd)
    {
        drivingcmd.da_head.cmd_type = 0x06;//dangwei，参照《新方案》表2-3

        drivingcmd.ctrl_cmd =gearCmd;//0x00默认 0x02比赛开始 0x0E比赛结束
        memcpy(tmbuf,&drivingcmd,21);
        drivingcmd.da_end.all_crc = CrcCrt(tmbuf,21);
        drivingcmd.da_end.tail = 0x55AA;
        memcpy(m_otherbuf, &drivingcmd, sizeof(CTRL_CMD));
    }
    if(accCmd != old_accCmd)
    {
        drivingcmd.da_head.cmd_type = 0x08;//油门指令，油门的主要识别码，参照《新方案》表2-3

        drivingcmd.ctrl_cmd =gearCmd;//0x00默认 0x02比赛开始 0x0E比赛结束
        memcpy(tmbuf,&drivingcmd,21);
        drivingcmd.da_end.all_crc = CrcCrt(tmbuf,21);
        drivingcmd.da_end.tail = 0x55AA;
        memcpy(m_otherbuf, &drivingcmd, sizeof(CTRL_CMD));
    }
    if(abs(steerAngle - old_steerAngle) > 0)
    {
        CTRL_FLOAT		ctrl_fcmd;
        ctrl_fcmd.da_head.head_begin[0]=0xF5;
        ctrl_fcmd.da_head.head_begin[1]=0xF4;
        ctrl_fcmd.da_head.head_begin[2]=0xF3;
        ctrl_fcmd.da_head.head_begin[3]=0xF2;
        ctrl_fcmd.da_head.head_begin[4]=0xF1;//数据头，固定值

        ctrl_fcmd.da_head.source_ip[0]= 192;
        ctrl_fcmd.da_head.source_ip[1]= 168;
        ctrl_fcmd.da_head.source_ip[2]= 10;
        ctrl_fcmd.da_head.source_ip[3]= 1;//源地址，不同的无人船IP不同

        ctrl_fcmd.da_head.dest_ip[0] = 192;
        ctrl_fcmd.da_head.dest_ip[1] = 168;
        ctrl_fcmd.da_head.dest_ip[2] = 11;
        ctrl_fcmd.da_head.dest_ip[3] = 45;//目标地址，信息2的组播地址，固定值

        ctrl_fcmd.da_head.cmd_type = 0x0A;//转向指令，转向的主要识别码，参照《新方案》表2-3

        ctrl_fcmd.da_head.cfg_flg = 0x01;//确认标志，1表示需要确认

        ctrl_fcmd.da_head.da_leng = 28;    //数据头+数据+数据尾    20+4+4
        ctrl_fcmd.da_head.cfg_cmd = 0;  //当 cmd_type 指令是群发时，这里填写具体的指令类型，单发命令时填0
        ctrl_fcmd.da_head.reserve[0] = 0;
        ctrl_fcmd.da_head.reserve[1] = 0;
        ctrl_fcmd.da_head.reserve[2] = 0;

        ctrl_fcmd.da_head.cmd_type = 0x0A;//duojiao，参照《新方案》表2-3

        ctrl_fcmd.f_param =steerAngle;//
        memcpy(tmbuf,&drivingcmd,24);
        drivingcmd.da_end.all_crc = CrcCrt(tmbuf,24);
        drivingcmd.da_end.tail = 0x55AA;
        memcpy(m_otherbuf, &drivingcmd, sizeof(CTRL_FLOAT));
    }

//    if(std::abs(elevatorRudder - old_elevatorRudder) > 0){
//        if(elevator_rudder_id == 255){
//            elevator_rudder_id = 0;
//        }
//        else{
//            elevator_rudder_id++;
//        }
//    }
//zsj
//    if( std::abs(steerAngle - old_steerAngle)>0.5 )
//    {
////        qDebug()<<"SetZhuHaiControl";
////        emit (m_conctrlbuf,m_conctrlbuf_sndsize);
//          my_groupcc->setexpectrudderval(steerAngle);

//    }

//    if(  fabs(accCmd - old_accCmd)>=1 )
//    {

//          my_groupcc->setexpectgasval(accCmd);

//    }
    if( (gearCmd != old_gearCmd) || fabs(accCmd - old_accCmd)>=1 || abs(steerAngle - old_steerAngle)>0 || abs(elevatorRudder - old_elevatorRudder)>0)
    {
//        qDebug()<<"SetZhuHaiControl";
//        emit (m_conctrlbuf,m_conctrlbuf_sndsize);
//          my_groupcc->setexpectrudderval(steerAngle);
//          my_groupcc->setexpectgasval(accCmd);
        send_time = 0;
        m_control_snd_flg=true;
    }
    old_gearCmd = gearCmd;
    old_accCmd =accCmd;
    old_steerAngle =steerAngle;
    old_elevatorRudder = elevatorRudder;

}

// 便携控制器其他控制指令,文档p42
void SerialPortManager::SetOtherCtrl(uchar onoffCmd, uchar stopCmd, uchar cruise_mode,uchar otherSwitches2,int shipLenght, uchar authorityControl)
{
    if(onoffCmd==0 && cruise_mode == old_cruise_mode && authorityControl == old_authorityControl && stopCmd == old_stopCmd && old_otherSwitches2 == otherSwitches2)
    {
        old_onoffCmd =0;
            return;
    }

    static uint16_t terminalOthHeartBeat = 0x00; // 心跳
    uchar tmbuf[500];
    CTRL_CMD drivingcmd;
    drivingcmd.da_head.head_begin[0] = 0XF5;       // 头部标志
    drivingcmd.da_head.head_begin[1] = 0XF4;       // 头部标志
    drivingcmd.da_head.head_begin[2] = 0XF3;       // 头部标志
    drivingcmd.da_head.head_begin[3] = 0XF2;       // 头部标志
    drivingcmd.da_head.head_begin[4] = 0XF1;       // 头部标志
    drivingcmd.da_head.da_leng = 25; // 数据长度
    drivingcmd.da_head.source_ip[0]= 192;
    drivingcmd.da_head.source_ip[1]= 168;
    drivingcmd.da_head.source_ip[2]= 18;
    drivingcmd.da_head.source_ip[3]= 35;//源地址，不同的无人船IP不同

    drivingcmd.da_head.dest_ip[0] = 192;
    drivingcmd.da_head.dest_ip[1] = 168;
    drivingcmd.da_head.dest_ip[2] = 18;
    if(851 ==shipLenght)
    {
        drivingcmd.da_head.dest_ip[3] = 27;       // 源节点编号
    }
    else if(852 ==shipLenght)
    {
        drivingcmd.da_head.dest_ip[3] = 27;       // 源节点编号
    }
    else if(11 ==shipLenght)
    {
        drivingcmd.da_head.dest_ip[3] = 27;       // 源节点编号
    }
    else if(15 ==shipLenght)
    {
        drivingcmd.da_head.dest_ip[3] = 27;       // 源节点编号
    }
    drivingcmd.da_head.cmd_type = 0x00;//

    drivingcmd.da_head.cfg_flg = 0x01;//确认标志，1表示需要确认

    drivingcmd.da_head.da_leng = 25;    //数据头+数据+数据尾    20+1+4
    drivingcmd.da_head.cfg_cmd = 0;  //当 cmd_type 指令是群发时，这里填写具体的指令类型，单发命令时填0
    drivingcmd.da_head.reserve[0] = 0;
    drivingcmd.da_head.reserve[1] = 0;
    drivingcmd.da_head.reserve[3] = 0;

    if(onoffCmd != old_onoffCmd && onoffCmd!=0)
    {
        drivingcmd.da_head.cmd_type = 0x0E;//两台发动机启动的主要识别码，参照《新方案》表2-3
        drivingcmd.ctrl_cmd = onoffCmd;////发动机启停控制，默认为0x00，0x01是启动，0x02是停车，0x03是点火，04是熄火
        memcpy(tmbuf,&drivingcmd,21);
        drivingcmd.da_end.all_crc = CrcCrt(tmbuf,21);
        drivingcmd.da_end.tail = 0x55AA;
    }
    if(stopCmd != old_stopCmd)
    {
        drivingcmd.da_head.cmd_type = 0x12;//两台发动机启动的主要识别码，参照《新方案》表2-3
        drivingcmd.ctrl_cmd = stopCmd;
        memcpy(tmbuf,&drivingcmd,21);
        drivingcmd.da_end.all_crc = CrcCrt(tmbuf,21);
        drivingcmd.da_end.tail = 0x55AA;
    }
    if(cruise_mode != old_cruise_mode)//续航模式
    {
        drivingcmd.da_head.cmd_type = 0x14;
        drivingcmd.ctrl_cmd = cruise_mode;
        memcpy(tmbuf,&drivingcmd,21);
        drivingcmd.da_end.all_crc = CrcCrt(tmbuf,21);
        drivingcmd.da_end.tail = 0x55AA;
    }
//    if(otherSwitches2 != old_otherSwitches2)
//    {
//        otherSwitches2_id++;
//        if(otherSwitches2_id>=255)
//            otherSwitches2_id = 0;
//    }
//    if(authorityControl != old_authorityControl)
//    {
//            authority_Control_id++;
//            if(authority_Control_id >= 255)
//                authority_Control_id = 0;
//    }

    memcpy(m_otherbuf, &drivingcmd, sizeof(CTRL_CMD));

    if (851 == shipLenght || 852 == shipLenght || 11 == shipLenght) {
        if((onoffCmd != old_onoffCmd) || (stopCmd != old_stopCmd) || (cruise_mode != old_cruise_mode) || (old_otherSwitches2 != otherSwitches2) || (authorityControl != old_authorityControl))
        {
            qDebug()<<"SetOTHERControl8";
            emit udpOut_signal(m_otherbuf,sizeof(CTRL_CMD),shipLenght);
            send_time = 0;
            m_other_snd_flg=true;

        }
    }
    old_onoffCmd = onoffCmd;
    old_stopCmd =stopCmd;
    old_cruise_mode =cruise_mode;
    old_otherSwitches2 = otherSwitches2;
    old_authorityControl = authorityControl;
}


// 智能终端控制权切换指令 P26
void SerialPortManager::SetCtrl_Premission(uchar handoff , int shipLenght) // 指令序号别忘了改
{
    //获取当前船的状态信息
//    ZHUHAI_STATE_INFO zh_info;
//    my_groupcc->getShipInfo(&zh_info);
     static uint16_t controlTerminalHeartBeat = 0; // 心跳
     static uint16_t terminalOthHeartBeat = 0x00; // 心跳
     uchar tmbuf[500];
     CTRL_CMD drivingcmd;
     drivingcmd.da_head.head_begin[0] = 0XF5;       // 头部标志
     drivingcmd.da_head.head_begin[1] = 0XF4;       // 头部标志
     drivingcmd.da_head.head_begin[2] = 0XF3;       // 头部标志
     drivingcmd.da_head.head_begin[3] = 0XF2;       // 头部标志
     drivingcmd.da_head.head_begin[4] = 0XF1;       // 头部标志
     drivingcmd.da_head.da_leng = 25; // 数据长度
     drivingcmd.da_head.source_ip[0]= 192;
     drivingcmd.da_head.source_ip[1]= 168;
     drivingcmd.da_head.source_ip[2]= 18;
     drivingcmd.da_head.source_ip[3]= 35;//源地址，不同的无人船IP不同

     drivingcmd.da_head.dest_ip[0] = 192;
     drivingcmd.da_head.dest_ip[1] = 168;
     drivingcmd.da_head.dest_ip[2] = 18;
     if(851 ==shipLenght)
     {
         drivingcmd.da_head.dest_ip[3] = 27;       // 源节点编号
     }
     else if(852 ==shipLenght)
     {
         drivingcmd.da_head.dest_ip[3] = 27;       // 源节点编号
     }
     else if(11 ==shipLenght)
     {
         drivingcmd.da_head.dest_ip[3] = 27;       // 源节点编号
     }
     else if(15 ==shipLenght)
     {
         drivingcmd.da_head.dest_ip[3] = 27;       // 源节点编号
     }
     drivingcmd.da_head.cmd_type = 0x00;//

     drivingcmd.da_head.cfg_flg = 0x01;//确认标志，1表示需要确认

     drivingcmd.da_head.da_leng = 25;    //数据头+数据+数据尾    20+1+4
     drivingcmd.da_head.cfg_cmd = 0;  //当 cmd_type 指令是群发时，这里填写具体的指令类型，单发命令时填0
     drivingcmd.da_head.reserve[0] = 0;
     drivingcmd.da_head.reserve[1] = 0;
     drivingcmd.da_head.reserve[3] = 0;

    if(handoff != 0)
    {
        drivingcmd.da_head.cmd_type = 0x04;
        drivingcmd.ctrl_cmd = handoff;
        memcpy(tmbuf,&drivingcmd,21);
        drivingcmd.da_end.all_crc = CrcCrt(tmbuf,21);
        drivingcmd.da_end.tail = 0x55AA;
        //默认为0x00，0x01是船本地（船端），0x02是远程（岸基）
    }
    memcpy(m_Terminalbuf, &drivingcmd, sizeof(CTRL_CMD));

    if(handoff != 0 && handoff != old_handoff)
    {
        if(zh_info.s_info1.b_CtrlID ==0x03)
        {

            emit udpOut_signal(m_Terminalbuf,sizeof(CTRL_CMD),5);
        }
        else if(zh_info.s_info1.b_CtrlID == 0x02)
            emit udpOut_signal(m_Terminalbuf,sizeof(CTRL_CMD),4);
        send_time = 0;
        m_terminal_snd_flg = true;
    }
    old_handoff = handoff;


}
