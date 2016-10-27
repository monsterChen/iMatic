//
//  EGOManager.h
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/22.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EGOCache.h"

@interface EGOManager : NSObject

+ (NSString *)getSelectChannelType;

+ (BOOL)getSelectisWifi;

@end
