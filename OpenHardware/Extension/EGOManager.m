//
//  EGOManager.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/22.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "EGOManager.h"

@implementation EGOManager

+ (NSString *)getSelectChannelType {

    return [[EGOCache globalCache] stringForKey:@"channelCount"];
}

+ (BOOL)getSelectisWifi {

    return [[[EGOCache globalCache] stringForKey:@"isWiFi"] isEqualToString:@"1"] ? YES:NO;
}

@end
