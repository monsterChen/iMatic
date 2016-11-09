//
//  CommandCode.h
//  OpenHardware
//
//  Created by Kingyeung.Chan on 2016/11/3.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"

static NSString *checkStateChannel_8 = @"FD0220FFFF5D";

static NSString *checkStateChannel_16 = @"5801100000000069";

static NSString *checkStateChannel_16_wifi = @"FD0220FFFF5D";

@interface CommandCode : NSObject 

+ (NSArray *)initCommaneCode_ON:(NSString *)channel isWifi:(BOOL)isWifi;

+ (NSArray *)initCommaneCode_OFF:(NSString *)channel isWifi:(BOOL)isWifi;

+ (NSData *)decode8:(NSString *)LED_Command;

+ (NSData *)decode16:(NSString *)LED_Command;

+ (NSData *)decodeWifi16:(NSString *)LED_Command;

+ (NSString *)decimalTOBinary:(uint16_t)tmpid backLength:(int)length;

@end
