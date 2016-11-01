//
//  timerModel.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 2016/10/31.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "timerModel.h"

@implementation timerModel {

    NSTimer *timer;
}

- (instancetype)init {
    
    return [super init];
}

- (void)stop {

    [timer invalidate];
    timer = nil;
}

- (void)start:(NSTimeInterval)time info:(NSDictionary *)info{

    __weak timerModel *weakSelf = self;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:time target:weakSelf selector:@selector(doSomething:) userInfo:info repeats:NO];
}

- (void)doSomething:(NSTimer *)t {
    
    //[self.delegate sendCommand];
    NSLog(@"-->>>>>");
    
    NSLog(@"%@", [t userInfo]);
}

@end
