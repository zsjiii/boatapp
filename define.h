#ifndef DEFINE_H
#define DEFINE_H
#define THREAD_MAX_NUM    	200
#define XUXU_SIG		    35
#define BOATRUN_SIG   36
typedef unsigned long long  u64;
typedef unsigned int        u32;
typedef unsigned char       u8;
typedef unsigned short      u16;
#define BYTE			u8
#define USHORT			u16

#define LOCAL_IP		"192.168.18.35"

#define INFO_PORT		7000
#define INFO_IP		"192.168.18.27"

#define BD_PORT		7001
#define BD_IP			"192.168.18.58"

#define PC_PORT		10600
#define PC_IP			INFO_IP

#define BOX_PORT		7003
#define BOX_IP			"192.168.18.59"


#define  MS_TO_JIE		1.94386
#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <cstdint>
#pragma pack(1)
typedef struct _PARAM_INFO
{
    int 	ctid;
    int     cpu_num;
}PARAM_INFO;

typedef  struct  _DA_HEAD
{
    BYTE		head_begin[5];//0xF5F4F3F2F1
    BYTE		source_ip[4];
    BYTE		dest_ip[4];
    BYTE		cmd_type;
    BYTE		cfg_flg;
    BYTE		da_leng;
    BYTE		cfg_cmd;//群发命令时这里填写具体命令类型，点对点命令填0
    BYTE		reserve[3];
}DA_HEAD; //20 byte

typedef  struct  _DA_END
{
    USHORT		all_crc;
    USHORT		tail;//固定值 0x55AA
}DA_END; //4 byte


typedef  struct  _CTRL_CMD
{
    DA_HEAD		da_head;
    BYTE		ctrl_cmd;//
    DA_END		da_end;
} CTRL_CMD;//25 byte

typedef  struct  _CTRL_FLOAT
{
    DA_HEAD		da_head;
    float		f_param; //zhuanxiang , hangsu
    DA_END		da_end;
} CTRL_FLOAT;//28byte

typedef struct _FBD_Path_Header    //无人艇航路规划数据结构
{
    BYTE			b_pathIndex; //规划的路径编号，非编队时使用      1
    double			d_StartLon;//起始经度                          8
    double			d_StartLat;//起始纬度                          8
    double			d_GoalLon;//目的经度                           8
    double			d_GoalLat;//目的纬度                           8
    BYTE			b_NextGoalIndex;//下个标记点编号                 1
    float			f_ToNextGoalDistance;//与下个目标点距离：米     4
    USHORT			us_ReachTime; //到达下个目标点时间：秒   2 //all up 40

    uint32_t			ui_rev1;                            //     4
    uint32_t			ui_rev2;                            //     4
    uint32_t			ui_planPointNumber;  //标记点数量        4 //all up 52
}FBD_Path_Header;    //海图航路规划 非编队时使用

typedef struct _LonLatPoint
{
    double			lon; //经度                          8
    double			lat; //纬度                          8 //all up 16
}LonLatPoint;

typedef struct _BOAT_PATH_SET
{
    //DA_HEAD			da_head;//20
    //FBD_Path		b_path;//16* ui_planPointNumber+52
    DA_HEAD		da_head;
    FBD_Path_Header fbd_path_header;
    LonLatPoint		*p_path_pt;
    DA_END			da_end;//4
}BOAT_PATH_SET;//20+16* ui_planPointNumber+52+4=16* ui_planPointNumber+76 byte

typedef struct _XUDATIME
{
    USHORT		year;   //2
    BYTE		mon;   // 1
    BYTE		day;   //1
    BYTE		hour;  //1
    BYTE		min;   //1
    BYTE		sec;   //1
    BYTE		rev;   //1 ,�չ�ż�����ֽ�
}XUDATIME;		  // 8


typedef  struct  _STATU_INFO1
{
    BYTE b_WorkState;      //工作状态 1
    float f_LeftRpm;      //左机转速  4
    float f_RightRpm;      //右机转速 4
    float f_LeftVol;      //左机电压  4
    float f_RightVol;      //右机电压  4 //all up 17

    short sh_LeftWaterTmp; //左机水温   2
    short sh_RightWaterTmp; //右机水温  2

    float f_LeftPSI;      //左机油压    4
    float f_RightPSI;      //右机油压   4

    float f_Rev1;    //预留1            4
    float f_Rev2;    //预留2            4  //all up 37

    float f_FreshWaterQ;  //淡水水量    4

    float f_LeftOilQ;      //左机油量   4
    float f_RightOilQ;      //右机油量  4

    float f_ToGroundVol;    //对地速度  4
    float f_ToWaterVol;     //对水速度  4  //all up 57
    float f_Rev3;    //预留3            4

    double d_Lon;      //经度           8
    double d_Lat;      //纬度           8  //all up 77
    float f_Height;    //高度           4

    float f_TAzimuth;   //艇艏向        4
    float f_TPitch;     //艇俯仰角      4
    float f_TRoll;      //艇横滚角      4

    float f_LeftOilConsumption;   //左机油耗     4  //all up 97
    float f_RightOilConsumption;    //右机油耗    4

    float f_LeftMotorRunTime;    //左机总运行时间   4
    float f_RightMotorRunTime;    //右机总运行时间  4

    BYTE b_LeftMotorWorkState;      //左发动机工作状态 1 -------all up 110
    BYTE b_Fire2DrainAlarm;      //消防及排水报警      1

    BYTE b_SwitchState1;      //灯及相关开关状态1      1
    BYTE b_SwitchState2;      //灯及相关开关状态2      1
    BYTE b_SwitchState3;      //灯及相关开关状态3      1  ------all up 114

    //UINT ui_DateAndTime;   //日期和时间        4 //all up 118，注意，处理时间需要用到CHAR_TIME-----------2023.8.12 梁取消
    XUDATIME ui_DateAndTime;//日期和时间       8 //all up 122----------------------------------------2024.9.29 梁取消
    BYTE b_RightMotorWorkState;      //右发动机工作状态 1

    BYTE b_AlarmInfo1;      //报警信息1                 1//all up 124
    BYTE b_AlarmInfo2;      //报警信息2                 1
    BYTE b_AlarmInfo3;      //报警信息3                 1

    float f_Rudder;    //舵角                           4
    BYTE b_LeftGear;      //左机档位                     1
    BYTE b_RightGear;      //右机档位                    1  ---new 10

    BYTE b_LeftGas;      //左机油门                      1
    BYTE b_RightGas;      //右机油门                     1//all up 134

    float f_LeftLift;      //左舵升降                    4
    float f_RightLift;      //右舵升降                   4------new 20

    float f_ToGroundYaw;  //对地航向                     4
    float f_WaterDepth;   //水深                         4
    float f_WindSpeed;    //风速                         4//all up 154
    float f_WindDir;      //风向                         4 -------------------new 36

    BYTE b_CtrlID;        //控制权ID                     1
    BYTE b_format_shape;   //预留字节1                   1
    BYTE b_navigation_status;   //预留字节2              1
    BYTE b_format_pos;   //当前无人艇在编队中的位置      1--------------------new 40
    BYTE b_rev4;   //预留字节4                           1

    double d_LonPk_1;      //经度Pk-1                    8
    double d_LatPk_1;      //纬度Pk-1                    8

    double d_LonPk;      //经度Pk                        8
    double d_LatPk;      //纬度Pk                        8---------------------new 73

    BYTE b_OperationID;  //指挥权 0-默认，1-岸基主显，2-上层显控，3-下层右显控，4-11.8显控  1 //all up 196
    BYTE c_CtrlSwitch1[5];  //控制开关1                                                     5
    BYTE c_CtrlSwitch2[7];  //控制开关2                                          7//all up 208----------------new 86 时间之后有86个字节
}STATU_INFO1;//208 byte

typedef struct _BOAT_INFO1
{
    DA_HEAD		da_head;
    STATU_INFO1		s_info1;
    DA_END			da_end;
}BOAT_INFO1;//208+20+4=232 byte

typedef struct _BD_GPFPS_INFO
{
    unsigned short		gps_week;
    double		gps_second;
    float		ph_jiao;
    float		fuyang_jiao;
    float		hgun_jiao;
    double		latitude;
    double		longtitude;
    float		height;
    float		pianliu_jiao;
    float		sheng_chen;
    float		dongxiang_speed;
    float		beixiang_speed;
    float		sky_speed;
    float		base_length;
    unsigned char		tianxian_num1;
    unsigned char		tianxian_num2;
    unsigned char		sys_status;
}BD_GPFPS_INFO;

typedef struct _BD_GTIMU_INFO
{
    USHORT		gps_week;
    double		gps_second;
    float		g_X;//x轴角速率
    float		g_Y;//y轴角速率
    float		g_Z;//z轴角速率

    float		a_X; //x轴加速度
    float		a_Y; //y轴加速度
    float		a_Z; //z轴加速度
    float		tpr;//温度

}BD_GTIMU_INFO;

typedef struct _B_CMD
{
    BYTE	bisai_cmd;		//比赛控制命令
    BYTE 	ctrl_quanxian;	//控制权限申请指令，发动机是否响应岸基控制，主要看此参数，权限在岸基，则响应岸基控制命令
    BYTE	dangwei;		//驾驶控制指令，档位
    BYTE	youmen;			//驾驶控制指令，油门
    BYTE	one_fadj_qit;	//其它控制指令，发动机启停，船上一台发动机情况
    BYTE	two_fadj_qit_l;	//其它控制指令，左发动机启停，船上两台发动机情况
    BYTE	two_fadj_qit_r;	//其它控制指令，右发动机启停，船上两台发动机情况
    BYTE	fadj_stop;		//其它控制指令，发动机紧急停止，通用
    BYTE	xunhang_mode;	//巡航模式： 0x00 有人操作模式（默认）；0x01 无人操作模式（遥控模式）；0x11:一键自动巡航模式，通用
}B_CMD;

typedef struct _F_CMD
{
    float	zhuanxiang;		//驾驶控制指令，转向 float
    float	hangsu;			//无人艇航速设定指令，通用 float
}F_CMD;

typedef struct _UniRC
{
    USHORT STX;
    char   Ctrl;
    USHORT len;
    USHORT SEQ;
    char   CMD_ID;
    int16_t   DATA[16];//每个通道两个字节（默认1050~1950）
    USHORT CRC16;
}UniRC;


// typedef struct {        /* time struct */
//     time_t time;        /* time (s) expressed by standard time_t */
//     double sec;         /* fraction of second under 1 s */
// } gtime_t;
// struct _cdtime_type
// {
// 	unsigned b_year:   6;
// 	unsigned b_month:  4;
// 	unsigned b_second: 6;
// 	unsigned b_Minute: 6;
// 	unsigned b_Hour:   5;
// 	unsigned b_day:    5;
// };

// typedef union _UNION_CHAR_TIME      //处理时间信息四字节结构
// {
// 	struct _cdtime_type ctime;
// 	unsigned char buffer[4];
// 	unsigned int itime;
// }CHAR_TIME;


// typedef struct _XUDATIME
// {
// 	ushort		year;   //2
// 	u8		mon;   // 1
// 	BYTE		day;   //1
// 	BYTE		hour;  //1
// 	BYTE		min;   //1
// 	BYTE		sec;   //1
// 	BYTE		rev;   //1 ,凑够偶数个字节
// }XUDATIME;		  // 8

typedef struct _USVMotionState    //无人艇自主航行信息结构
{
    int whichShip; //标志是哪艘艇的信息
    int format_pos;   //无人艇在编队中的位置

    double shipLon;//船体经度
    double shipLat;//船体纬度

    double shipHeading;//艇艏向
    double shipPitchAngle;  //横倾角   俯仰
    double shipRollAngle;   //纵倾角   横滚

    double shipVol;//航速
    double shipCourse;//航向

    double rudder;//舵角
    double angleSpeed; //角速度

}USVMotionState;



typedef struct _BD_Path_Header    //编队无人艇航路规划数据结构
{
    BYTE b_pathIndex; //路径编号
    double d_StartLon;//起始经度
    double d_StartLat;//起始纬度
    double d_GoalLon;//目的经度
    double d_GoalLat;//目的纬度
    unsigned short us_BDBoatNumber; //编队艇数量
    BYTE b_BDForm; //编队队形
    float f_FormDistance;  //队形间距,编队时使用,非编队时预留
    BYTE b_NextGoalNo;//下个标记点编号
    float f_ToNextGoalDistance;//与下个目标点距离：米
    unsigned short us_ReachTime; //到达下个目标点时间：秒
    unsigned int ui_rev1;
    unsigned int ui_rev2;
    unsigned short us_planPointNumber;  //规划点数量

}BD_Path_Header;    //海图航路规划 编队时使用

typedef struct _BD_Path
{
    BD_Path_Header m_BD_Path_Header;
    std::vector<LonLatPoint> m_BD_Path_Points;
}BD_Path;

//定义自主航行时的走航点状态
typedef enum _PathTrackState
{
    InvalidTrackState,
    NotReceivePath,
    RunningToPoint,
    SwitchNextPoint,
    ArrivedDst
}PathTrackState;

typedef struct _GuidanceLawTestData
{
    int GuidanceLawFlag;  //采用何种导引率标志,1表示点对点，2表示直线跟踪，3表示绕圆跟踪
    double lon_Pk;
    double lat_Pk;
    double lon_Pk_1;
    double lat_Pk_1;
    double radius;
    double faiK;
    double epsilon;
    double thetaK;
    double failos;

}GuidanceLawTestData;


/*********************** 多字节和数据类型的转换联合注释开始**********************/
typedef union UN_I2
{
    short shdata;
    char  buffer[2];
}UN_I2;

typedef union UN_UI2
{
    unsigned short ushdata;
    unsigned char  buffer[2];
}UN_UI2;

typedef union UN_UI4
{
    unsigned int  uintdata;
    unsigned char  buffer[4];
}UN_UI4;

typedef union UN_I4
{
    int  intdata;
    unsigned char  buffer[4];
}UN_I4;


typedef union UN_F4
{
    float floatdata;
    char  buffer[4];
}UN_F4;

typedef union UN_I8
{
    uint64_t intdata;
    unsigned char  buffer[8];
}UN_I8;

typedef union UN_F8
{
    double doubledata;
    unsigned char  buffer[8];
}UN_F8;

typedef struct _common_bit_struct     //通用位域结构
{
    unsigned char b_bit0: 1;
    unsigned char b_bit1: 1;
    unsigned char b_bit2: 1;
    unsigned char b_bit3: 1;
    unsigned char b_bit4: 1;
    unsigned char b_bit5: 1;
    unsigned char b_bit6: 1;
    unsigned char b_bit7: 1;
} common_bit_struct, *pcommon_bit_struct;


typedef union _unin_byte2bits
{
    common_bit_struct m_bit;
    BYTE m_byte;

}union_byte2bits;
/*********************** 多字节和数据类型的转换联合注释结束**********************/

#pragma pack()

#endif // DEFINE_H
