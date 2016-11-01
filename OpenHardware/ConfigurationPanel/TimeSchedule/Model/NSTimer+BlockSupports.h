//
//  NSTimer+BlockSupports.h
//  OpenHardware
//
//  Created by Kingyeung.Chan on 2016/10/31.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (BlockSupports)

+ (NSTimer *)eocScheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(void(^)()) block repeats:(BOOL)repeat;

@end
