//
//  TimeSetViewController.h
//  OpenHardware
//
//  Created by Kingyeung.Chan on 2016/11/1.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseViewController.h"

@interface TimeSetViewController : baseViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end