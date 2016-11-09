//
//  CommandCode.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 2016/11/3.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "CommandCode.h"

@implementation CommandCode

+ (NSArray *)initCommaneCode_ON:(NSString *)channel isWifi:(BOOL)isWifi {

    NSArray *channel8_ON = @[@"FD022001015D", @"FD022002015D", @"FD022003015D", @"FD022004015D", @"FD022005015D",
                    @"FD022006015D", @"FD022007015D", @"FD022008015D", @"FD0220F8885D"];
    
    
    NSArray *channel16_ON = @[@"580112000000016C", @"580112000000026D", @"580112000000036E", @"580112000000046F",
                     @"5801120000000570", @"5801120000000671", @"5801120000000772", @"5801120000000873",
                     @"5801120000000974", @"5801120000000A75", @"5801120000000B76", @"5801120000000C77",
                     @"5801120000000D78", @"5801120000000E79", @"5801120000000F7A", @"580112000000107B",
                     @"5801130000FFFF77"];
    
    
    NSArray *channel16_wifi_ON = @[@"FD022001015D", @"FD022002015D", @"FD022003015D", @"FD022004015D", @"FD022005015D",
                          @"FD022006015D", @"FD022007015D", @"FD022008015D", @"FD022009015D", @"FD02200A015D",
                          @"FD02200B015D", @"FD02200C015D", @"FD02200D015D", @"FD02200E015D", @"FD02200F015D",
                          @"FD022010015D", @"FD0220EFFF5D"];
    
    if ([channel isEqualToString:@"8"]) {
        
        return channel8_ON;
        
    }else if([channel isEqualToString:@"16"]) {
        
        if (isWifi) {
            
            return channel16_wifi_ON;
        }else {
            
            return channel16_ON;
        }
    }
    
    return nil;
}

+ (NSArray *)initCommaneCode_OFF:(NSString *)channel isWifi:(BOOL)isWifi {

    NSArray *channel8_OFF = @[@"FD022001005D", @"FD022002005D", @"FD022003005D", @"FD022004005D", @"FD022005005D",
                              @"FD022006005D", @"FD022007005D", @"FD022008005D", @"FD0220F8805D"];
    
    
    NSArray *channel16_OFF = @[@"580111000000016B", @"580111000000026C", @"580111000000036D", @"580111000000046E",
                               @"580111000000056F", @"5801110000000670", @"5801110000000771", @"5801110000000872",
                               @"5801110000000973", @"5801110000000A74", @"5801110000000B75", @"5801110000000C76",
                               @"5801110000000D77", @"5801110000000E78", @"5801110000000F79", @"580111000000107A",
                               @"580113000000007B"];
    
    NSArray *channel16_wifi_OFF = @[@"FD022001005D", @"FD022002005D", @"FD022003005D", @"FD022004005D", @"FD022005005D",
                                    @"FD022006005D", @"FD022007005D", @"FD022008005D", @"FD022009005D", @"FD02200A005D",
                                    @"FD02200B005D", @"FD02200C005D", @"FD02200D005D", @"FD02200E005D", @"FD02200F005D",
                                    @"FD022010005D", @"FD0220EF005D"];
    
    if ([channel isEqualToString:@"8"]) {
        
        return channel8_OFF;
        
    }else if([channel isEqualToString:@"16"]) {
        
        if (isWifi) {
            return channel16_wifi_OFF;
        }else {
            
            return channel16_OFF;
        }
    }
    
    return nil;
}

/**
 *  8路控制板命令解码
 *
 *  @param LED_Command 8路原始命令字符
 *
 *  @return
 */

+ (NSData *)decode8:(NSString *)LED_Command {
    
    Byte byte[6];
    
    for(int i=0; i<[LED_Command length]; i+=2) {
        
        NSString *str = [LED_Command substringWithRange:NSMakeRange(i, 2)];
        
        byte[i/2] = [[NSString stringWithFormat:@"%ld", strtoul([str UTF8String], 0, 16)] integerValue];
        
        if (byte[i/2] > 200) {
            byte[i/2] = byte[i/2] - 256;
        }
    }
    
    return [NSData dataWithBytes:byte length:6];
}


/**
 *  wifi16路控制板命令解码
 *
 *  @param LED_Command 16路远时命令字符
 *
 *  @return
 */
+ (NSData *)decodeWifi16:(NSString *)LED_Command {
    Byte byte[8];
    
    Byte sum = 0;
    for(int i=0; i<[LED_Command length]; i+=2) {
        
        NSString *str = [LED_Command substringWithRange:NSMakeRange(i, 2)];
        
        byte[i/2] = [[NSString stringWithFormat:@"%ld", strtoul([str UTF8String], 0, 16)] integerValue];
        
        if (byte[i/2] > 200) {
            byte[i/2] = byte[i/2] - 256;
        }
        
        sum += byte[i/2];
    }
    
    byte[7] = sum;
    //NSLog(@"%d-%d-%d-%d-%d-%d-%d-%d", byte[0], byte[1], byte[2], byte[3], byte[4], byte[5], byte[6], byte[7]);
    
    return [NSData dataWithBytes:byte length:8];
    
}


/**
 *  16路控制板命令解码
 *
 *  @param LED_Command 16路远时命令字符
 *
 *  @return
 */
+ (NSData *)decode16:(NSString *)LED_Command {
    
    Byte byte[8] ;//= {88, 1, 19, 0, 0, -1, -1, 106};
    
    Byte sum = 0;
    for(int i=0; i<[LED_Command length]-2; i+=2) {
        
        NSString *str = [LED_Command substringWithRange:NSMakeRange(i, 2)];
        
        byte[i/2] = [[NSString stringWithFormat:@"%ld", strtoul([str UTF8String], 0, 16)] integerValue];
        
        if (byte[i/2] > 200) {
            byte[i/2] = byte[i/2] - 256;
            //NSLog(@"->%d", byte[i/2]);
        }
        
        sum += byte[i/2];
    }
    
    byte[7] = sum;
    //NSLog(@"%d-%d-%d-%d-%d-%d-%d-%d", byte[0], byte[1], byte[2], byte[3], byte[4], byte[5], byte[6], byte[7]);
    
    return [NSData dataWithBytes:byte length:8];
}

/**
 *  返回的状态数据解码十进制转二进制
 *
 *  @param tmpid
 *  @param length
 *
 *  @return
 */
+ (NSString *)decimalTOBinary:(uint16_t)tmpid backLength:(int)length {
    
    NSString *a = @"";
    
    while (tmpid) {
        
        a = [[NSString stringWithFormat:@"%d",tmpid%2] stringByAppendingString:a];
        
        if (tmpid/2 < 1) {
            break;
        }
        tmpid = tmpid/2 ;
    }
    
    if (a.length <= length) {
        
        NSMutableString *b = [[NSMutableString alloc]init];
        
        for (int i = 0; i < length - a.length; i++) {
            [b appendString:@"0"];
        }
        
        a = [b stringByAppendingString:a];
    }
    
    return a;
    
}

@end
