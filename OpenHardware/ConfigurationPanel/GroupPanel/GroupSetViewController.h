//
//  GroupSetViewController.h
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/16.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseViewController.h"

@interface GroupSetViewController : baseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSString *groupName;

@end
