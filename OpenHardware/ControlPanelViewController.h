//
//  ViewController.h
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/5.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseViewController.h"

@interface ControlPanelViewController : baseViewController

@property (strong, nonatomic) NSString *channelCount;

@property (assign, nonatomic) BOOL isWiFi;

@property (assign, nonatomic) BOOL isBasic;

@end

