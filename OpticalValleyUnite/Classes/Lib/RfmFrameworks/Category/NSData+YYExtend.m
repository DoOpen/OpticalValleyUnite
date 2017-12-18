//
//  NSData+YYExtend.m
//  AccessController
//
//  Created by yeyufeng on 15/3/12.
//  Copyright (c) 2015年 REFORMER. All rights reserved.
//

#import "NSData+YYExtend.h"

@implementation NSData (YYExtend)

// 把一个 表示十六进制数的NSData 转为NSString
- (NSString *)dataToHexString
{
    NSUInteger len = [self length];
    char * chars = (char *)[self bytes];
    NSMutableString *hexString = [[NSMutableString alloc] init];
    
    for (NSUInteger i = 0; i < len; i++)
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    
    return hexString;
}

- (instancetype)initWithUint32_t:(uint32_t)dataInt
{
    Byte tmp[4];
    
    tmp[0] = dataInt>>24;
    tmp[1] = (dataInt>>16)&0xFF;
    tmp[2] = (dataInt>>8)&0xFF;
    tmp[3] = dataInt&0xFF;
    
    self = [[NSData alloc] initWithBytes:tmp length:4];
    return self;
}

@end
