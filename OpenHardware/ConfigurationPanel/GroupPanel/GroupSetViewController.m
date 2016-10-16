//
//  GroupSetViewController.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/16.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "GroupSetViewController.h"

@interface GroupSetViewController ()

@end

@implementation GroupSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super genUINavigationLeftBcakButton:[UIImage imageNamed:@"back"]];
    
    [super genUINavigationRightButton:[UIImage imageNamed:@"save"] andSize:CGSizeMake(20, 20) andEvent:@selector(saveGroup)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveGroup {

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
