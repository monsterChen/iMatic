//
//  channelAll.h
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/8.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    ALL_ON = 1,
    ALL_OFF
}BTNStatus;

@interface channelAll : UIButton

@property (nonatomic, assign) BTNStatus btnStatus;

- (void)updateState;

@end
