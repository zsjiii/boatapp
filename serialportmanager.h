#include <QObject>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QDebug>
#include <QDateTime>
#include <QTimer>
#include <math.h>
#include "define.h"
#include "crc16.h"
#include "udpmanager.h"

#define g_ship_index 0
class SerialPortManager : public QObject
{
    Q_OBJECT
public:
    explicit SerialPortManager(QObject *parent = nullptr);
    ~SerialPortManager();

    Q_INVOKABLE bool openPort(const QString &portName, int baudRate);
    Q_INVOKABLE void closePort();
    Q_INVOKABLE bool sendData(const QString &data);
    Q_INVOKABLE QStringList availablePorts();
    void Sig_Send_t30info(UniRC* prevdata) ;
    void SetDrivingCtrl(uchar gearCmd, uchar accCmd, float steerAngle,float elevatorRudder , int shipLenght);
    void SetOtherCtrl(uchar onoffCmd, uchar stopCmd, uchar cruise_mode,uchar otherSwitches2,int shipLenght, uchar authorityControl);
    void SetCtrl_Premission(uchar handoff , int shipLenght);

signals:
    void dataReceived(const QVariantList& h16data);
    // 信号用于通知 QML 有新数据
    //Q_INVOKABLE void H16dataProcessed();
private slots:
    void onReadyRead();
    void timer_slot();
signals:
    void udpOut_signal(uchar *pdata,qint16 size,int id);
private:
    QSerialPort *m_serial;
    QByteArray m_data;
    UniRC revinfo;

    //zsj
    UdpManager *m_udpmode;
    uchar onoff=0;
    uchar cruise_mode=0;
    uchar gear=0x02;
    uchar handoff=0;
    uchar spare=0;
    uchar otherSwitches=0x80;
    uchar authorityControl=0;
    uchar old_cruise_mode=0;
    uchar old_onoffCmd=0;
    uchar old_authorityControl=0;
    uchar old_otherSwitches2=0;
    uchar old_stopCmd=0;
    uchar old_handoff=0;

    uchar old_gearCmd =0x02;
    uchar old_accCmd=0;
    float old_steerAngle=0;
    float old_elevatorRudder=0;
    int gear_id;
    int throttle_id;
    int steering_id;
    int elevator_rudder_id;
    int onoff_id;
    int stop_id;
    int cruise_mode_id;
    int otherSwitches2_id;
    int authority_Control_id;
    int handoff_id;

    uchar emergencyStop=0;//舱盖急停
    uchar old_emergencyStop=0;
    bool SurfaceButtonProcessed;
    bool shipstopProcessed;
    int HatchCmd=0;
    QDateTime lastCallTime;
    qint64 serialPortTime;          // 串口读取信息时间
    qint64 forwardThrottleTime=0;
    double precisionThrottle=0;       // 精确油门
    uchar gasPedaValue =0;
    qint64 reduceThrottleTime=0;

    QTimer* m_ptimer;
    bool m_control_snd_flg = false;
    bool m_terminal_snd_flg = false;
    bool m_other_snd_flg = false;
    int send_time=0;
    uchar   m_conctrlbuf[100];
    uchar   m_Terminalbuf[100];
    uchar   m_otherbuf[100];

    int     m_conctrlbuf_sndsize=0;
    int     m_Terminalbuf_sndsize =0;
    int     m_otherbuf_sndsize =0;
};
