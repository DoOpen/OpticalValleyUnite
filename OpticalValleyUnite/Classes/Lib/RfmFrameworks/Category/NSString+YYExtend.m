//
//  NSString+YYExtend.m
//  AccessController
//
//  Created by yeyufeng on 15/3/10.
//  Copyright (c) 2015年 REFORMER. All rights reserved.
//

#import "NSString+YYExtend.h"

@implementation NSString (YYExtend)

#pragma mark - 二进制
// 把一个 表示十六进制数的NSString 转为NSData
- (NSData *)stringToHexData
{
    unsigned long len = [self length] / 2; // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3];
    
    int i;
    for (i=0; i < [self length] / 2; i++)
    {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        byte_chars[2] = 0;
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    
    NSData *data = [NSData dataWithBytes:buf length:len];
    free(buf);
    return data;
}

@end
