//
//  ListTimeViewController.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 2016/11/1.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "ListTimeViewController.h"

@interface ListTimeViewController()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ListTimeViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [super genUINavigationLeftBcakButton:[UIImage imageNamed:@"back"]];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:242.0/255 green:243.0/255 blue:244.0/255 alpha:1.0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UItableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"listCell";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
