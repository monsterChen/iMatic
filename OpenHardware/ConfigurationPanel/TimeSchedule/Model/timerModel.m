//
//  timerModel.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 2016/10/31.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "timerModel.h"

@interface timerModel()<NSCoding>

@end

@implementation timerModel

- (id)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super init]) {
     
        self.time = [aDecoder decodeObjectForKey:@"time"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.time forKey:@"time"];
}


@end
