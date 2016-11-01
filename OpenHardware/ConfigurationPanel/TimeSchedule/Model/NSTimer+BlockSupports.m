//
//  NSTimer+BlockSupports.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 2016/10/31.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "NSTimer+BlockSupports.h"

@implementation NSTimer (BlockSupports)

+ (NSTimer *)eocScheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                         block:(void (^)())block
                                       repeats:(BOOL)repeat {

    return [self timerWithTimeInterval:timeInterval
                                target:self
                              selector:@selector(startTimer:)
                              userInfo:[block copy]
                               repeats:NO];
}

+(void)startTimer:(NSTimer *)timer {
    
    void(^block)() = timer.userInfo;
    NSLog(@"1");
    if (block) {
        NSLog(@"2");
        block();
    }
}

@end
