#include "cmd_send.h"
#include <QJsonArray>
CMD_Send::CMD_Send(QObject *parent)
    : QObject{parent}
{
    m_udpcmdsend = new UdpManager();
    connect(this,&CMD_Send::udpOut_signal,m_udpcmdsend,&UdpManager::slot_sendData);
}

//发送指令，协议CTRL_CMD
void CMD_Send::Ctrl_Cmd_Send(BYTE cmd_type, BYTE ctrl_cmd )
{
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
    if(851 ==boatTYPE)
    {
        drivingcmd.da_head.dest_ip[3] = 27;       // 源节点编号
    }
    else if(852 ==boatTYPE)
    {
        drivingcmd.da_head.dest_ip[3] = 27;       // 源节点编号
    }
    else if(11 ==boatTYPE)
    {
        drivingcmd.da_head.dest_ip[3] = 27;       // 源节点编号
    }
    else if(15 ==boatTYPE)
    {
        drivingcmd.da_head.dest_ip[3] = 27;       // 源节点编号
    }

    drivingcmd.da_head.cfg_flg = 0x01;//确认标志，1表示需要确认

    drivingcmd.da_head.da_leng = 25;    //数据头+数据+数据尾    20+1+4
    drivingcmd.da_head.cfg_cmd = 0;  //当 cmd_type 指令是群发时，这里填写具体的指令类型，单发命令时填0
    drivingcmd.da_head.reserve[0] = 0;
    drivingcmd.da_head.reserve[1] = 0;
        drivingcmd.da_head.cmd_type = cmd_type;//dangwei，参照《新方案》表2-3

        drivingcmd.ctrl_cmd =ctrl_cmd;//0x00默认 0x02比赛开始 0x0E比赛结束
        memcpy(tmbuf,&drivingcmd,21);
        drivingcmd.da_end.all_crc = CrcCrt(tmbuf,21);
        drivingcmd.da_end.tail = 0x55AA;
        memcpy(tmbuf, &drivingcmd, sizeof(CTRL_CMD));
    emit udpOut_signal(tmbuf,sizeof(CTRL_CMD),boatTYPE);
}
//发送指令，协议CTRL_FLOAT
void CMD_Send::Ctrl_Float_Send(BYTE cmd_type, float ctrl_cmd)
{
    uchar tmbuf[500];
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

    ctrl_fcmd.da_head.cmd_type = cmd_type;//转向指令，转向的主要识别码，参照《新方案》表2-3

    ctrl_fcmd.da_head.cfg_flg = 0x01;//确认标志，1表示需要确认

    ctrl_fcmd.da_head.da_leng = 28;    //数据头+数据+数据尾    20+4+4
    ctrl_fcmd.da_head.cfg_cmd = 0;  //当 cmd_type 指令是群发时，这里填写具体的指令类型，单发命令时填0
    ctrl_fcmd.da_head.reserve[0] = 0;
    ctrl_fcmd.da_head.reserve[1] = 0;
    ctrl_fcmd.da_head.reserve[2] = 0;

    ctrl_fcmd.f_param =ctrl_cmd;//
    memcpy(tmbuf,&ctrl_fcmd,24);
    ctrl_fcmd.da_end.all_crc = CrcCrt(tmbuf,24);
    ctrl_fcmd.da_end.tail = 0x55AA;
    memcpy(tmbuf, &ctrl_fcmd, sizeof(CTRL_FLOAT));
    emit udpOut_signal(tmbuf,sizeof(CTRL_FLOAT),boatTYPE);

}
//发送指令，协议BOAT_PATH_SET
void CMD_Send::Boat_Path_Send(QVariant v)
{
    typedef struct _LONLAT
    {
        double          longitude;
        double          latitude;
    }LONLAT;
    std::vector<LONLAT> points;
    std::vector<int> num_waypoint;
    BOAT_PATH_SET      boat_p_set;
    QJsonArray ja = v.toJsonArray();
    int num=(ja.size()/2);
    num_waypoint.push_back(num);
    LONLAT point;
    for(int i=0;i<num;i++)
    {
        if ((i * 2 + 1) < ja.size() && (i * 2) < ja.size()) {
            point.latitude=ja.at(i * 2 + 1).toDouble();
            point.longitude=ja.at(i * 2).toDouble();
            points.push_back(point);
        }

    }
    uchar	crc_da[255];
    uchar	sbuf[1024];
    boat_p_set.xu_head.head_begin[0]=0xF5;//固定包头
    boat_p_set.xu_head.head_begin[1]=0xF4;
    boat_p_set.xu_head.head_begin[2]=0xF3;
    boat_p_set.xu_head.head_begin[3]=0xF2;
    boat_p_set.xu_head.head_begin[4]=0xF1;
    boat_p_set.xu_head.source_ip[0]= 192;//源地址
    boat_p_set.xu_head.source_ip[1]= 168;
    boat_p_set.xu_head.source_ip[2]= 10;
    boat_p_set.xu_head.source_ip[3]= 1;
    boat_p_set.xu_head.dest_ip[0]= 192;//目的地址，珠海11m192.168.11.10
    boat_p_set.xu_head.dest_ip[1]= 168;
    boat_p_set.xu_head.dest_ip[2]= 11;
    //if(ui->comboBox->currentText()==QString::number(31))
    {
        boat_p_set.xu_head.dest_ip[3]= 31;
    }
    //else if(ui->comboBox->currentText()==QString::number(45))
    {
        boat_p_set.xu_head.dest_ip[3]= 45;
    }
    boat_p_set.xu_head.cmd_type=0x16;//表示非编队路径规划信息分发
    boat_p_set.xu_head.cfg_flg=0x1;//表示需要确认

    boat_p_set.xu_head.cfg_cmd=0;
    boat_p_set.xu_head.reserve[0]=0;
    boat_p_set.xu_head.reserve[1]=0;
    boat_p_set.xu_head.reserve[2]=0;
    boat_p_set.fbd_path_header.b_pathIndex = 1;
    //     boat_p_set.xu_head.m_FBD_Path_Header.d_StartLon =nt_info.start_lonlat.longitude;
    //     boat_p_set.xu_head.m_FBD_Path_Header.d_StartLat =nt_info.start_lonlat.latitude;
    //     boat_p_set.xu_head.m_FBD_Path_Header.d_GoalLon =nt_info.aim_lonlat.longitude;
    //     boat_p_set.xu_head.m_FBD_Path_Header.d_GoalLat = nt_info.aim_lonlat.latitude;
    boat_p_set.fbd_path_header.b_NextGoalIndex =2;
    //boat_p_set.xu_head.m_FBD_Path_Header.f_ToNextGoalDistance=nt_info.boat_nextdot_dist=100;
    //boat_p_set.xu_head.m_FBD_Path_Header.us_ReachTime=nt_info.boat_nextdot_time=0;
    boat_p_set.fbd_path_header.ui_planPointNumber=num;
    boat_p_set.xu_head.da_leng = boat_p_set.fbd_path_header.ui_planPointNumber*16 + 72 +4;
    boat_p_set.p_path_pt = (LonLatPoint*)malloc(sizeof(LonLatPoint)*num);
    for(int iWapPos = 0; iWapPos < num; iWapPos ++)
    {
        boat_p_set.p_path_pt[iWapPos].lon = ja.at(iWapPos * 2).toDouble();//points[iWapPos].longitude;
        boat_p_set.p_path_pt[iWapPos].lat = ja.at(iWapPos * 2 + 1).toDouble();//points[iWapPos].latitude;

        qDebug("lon:%f lan:%f\r\n",boat_p_set.p_path_pt[iWapPos].lon,boat_p_set.p_path_pt[iWapPos].lat );//= points[iWapPos].latitude);
    }
    memcpy(sbuf,&boat_p_set,72);
    memcpy(&sbuf[72],boat_p_set.p_path_pt,16*boat_p_set.fbd_path_header.ui_planPointNumber);
    memcpy(crc_da,sbuf, boat_p_set.fbd_path_header.ui_planPointNumber*16 + 72);
    boat_p_set.da_end.all_crc=CrcCrt(crc_da,boat_p_set.fbd_path_header.ui_planPointNumber*16+72);//xuxu_crc(&crc_da[3],31);
    //crc
    //        memcpy(sbuf,&g_ntbw_cmd,61);
    //        memcpy(&sbuf[61],g_ntbw_cmd.plan_dot_lonlat,16*g_ntbw_cmd.plan_dot_num);
    //        memcpy(crc_da,sbuf,157);
    //        g_ntbw_cmd.crc=power_crc(&crc_da[1],g_ntbw_cmd.plan_dot_num+60);//xuxu_crc(&crc_da[3],31);
    memcpy(&sbuf[boat_p_set.fbd_path_header.ui_planPointNumber*16 + 72],&boat_p_set.da_end.all_crc,2);
    //ntbw_cmd.end=0xFF;
    sbuf[boat_p_set.fbd_path_header.ui_planPointNumber*16 + 74]=0xAA;
    sbuf[boat_p_set.fbd_path_header.ui_planPointNumber*16 + 75]=0x55;
    emit udpOut_signal(sbuf,boat_p_set.fbd_path_header.ui_planPointNumber*16+76,0);

    //sbuf[g_ntbw_cmd.plan_dot_num*16 + 73]=0xAA;
    qDebug()<<"Send hang xian gui hua!\n";
    //form_line->initline();
    //form_line->show();
    qDebug() << "j[0] = " << ja.at(0).toDouble();
}
