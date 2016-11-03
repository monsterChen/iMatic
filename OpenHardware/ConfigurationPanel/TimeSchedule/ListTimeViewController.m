//
//  ListTimeViewController.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 2016/11/1.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "ListTimeViewController.h"
#import "DBManager.h"
#import "EGOManager.h"
#import "GroupModel.h"

#define IsCheckMark     @"1"
#define NotCheckMark    @"0"

@interface ListTimeViewController()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic ,strong) NSString *checkMark;

@property (nonatomic, strong) NSMutableArray *timeModelArray;

@end

@implementation ListTimeViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self loadArray];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [super genUINavigationLeftBcakButton:[UIImage imageNamed:@"back"]];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:242.0/255 green:243.0/255 blue:244.0/255 alpha:1.0]];
    
    self.listArray = [[[DBManager shareInstance] queryChannelBtnName:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi]] mutableCopy];
    
    self.checkMark = NotCheckMark;
    
    [self loadArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadArray {
    
    self.timeModelArray = [[[DBManager shareInstance] queryTimeButton:self.groupName channel:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi]] mutableCopy];
}

#pragma mark UItableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.listArray objectAtIndex:indexPath.row];
    
    GroupModel *model = [self.timeModelArray objectAtIndex:indexPath.row];
    
    if (model.selectState == isSelect) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else if (model.selectState == notSelect) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        
        self.checkMark = NotCheckMark;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else if (cell.accessoryType == UITableViewCellAccessoryNone) {
        
        self.checkMark = IsCheckMark;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[DBManager shareInstance] updateTimeButtonSelectState:self.checkMark channel:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi] groupName:self.groupName index:indexPath.row];
    });

}

@end
