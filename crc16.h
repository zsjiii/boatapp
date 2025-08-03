
#pragma once

#ifndef CRC16_H
#define CRC16_H
#include <cstdint>
#include <QDebug>
unsigned short CrcCrt( unsigned char *ptr, int Len);
unsigned char CrcSum(unsigned char *data,int DataLen);
unsigned short CRC16(unsigned char *data, unsigned int datalen);
unsigned char CrcXor(unsigned char *buf, int DataLen);
unsigned char XorSum(unsigned char *data,int DataLen);
unsigned int CrcCheckNew(unsigned char *Array, unsigned int ArrayLen, unsigned int FirstPlace);
unsigned char SumCheck(unsigned char *Array, unsigned int ArrayLen, unsigned int FirstPlace);
unsigned short ModBusCrcData(unsigned char *buffer, unsigned short len);
uint16_t crc16_ccitt(const uint8_t *data, size_t length);
uint16_t CRC16_cal(uint8_t *ptr, uint32_t len, uint16_t crc_init);
uint8_t crc_check_16bites(uint8_t* pbuf, uint32_t len,uint32_t* p_result);
void InvertUint8(unsigned char *dBuf,unsigned char *srcBuf);
void InvertUint16(unsigned short *dBuf,unsigned short *srcBuf);
#endif // CRC16_H

