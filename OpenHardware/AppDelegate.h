//
//  AppDelegate.h
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/5.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GCDAsyncSocket *clientStock;

@property (strong, nonatomic) NSMutableDictionary *scheduleDic;

@end

