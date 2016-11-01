//
//  timerModel.h
//  OpenHardware
//
//  Created by Kingyeung.Chan on 2016/10/31.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface timerModel : NSObject

- (void)start:(NSTimeInterval)time info:(NSDictionary *)info;

- (void)stop;

//- (void)doSomething;

@end
