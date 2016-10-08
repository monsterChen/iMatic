//
//  HWNavigationController.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/6.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "HWNavigationController.h"

@interface HWNavigationController ()

@end

@implementation HWNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super genBarTintColor:[UIColor blackColor]];
    [super setNabigationItemTintColor:[UIColor whiteColor]];
    [super genTitleTextAttributes:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
