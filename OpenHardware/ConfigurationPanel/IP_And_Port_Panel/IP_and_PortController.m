//
//  IP_and_PortController.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/9.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "IP_and_PortController.h"
#import "settingCell.h"
#import "DBManager.h"
#import "EGOCache.h"
#import "IdentifierValidator.h"

#define Type_IP     0
#define Type_Port   1

@interface IP_and_PortController()

@property (strong, nonatomic) NSMutableArray *listArray;

@end

@implementation IP_and_PortController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [super genUINavigationLeftBcakButton:[UIImage imageNamed:@"back"]];
    
    self.listArray = [[[DBManager shareInstance] queryIP_and_port:[self getSelectChannelType] isWifi:[self getSelectisWifi]] mutableCopy];
    
    [super recoveryOfKeyboard];
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:242.0/255 green:243.0/255 blue:244.0/255 alpha:1.0]];
    
    [super genUINavigationRightButton:[UIImage imageNamed:@"save"] andSize:CGSizeMake(20, 20) andEvent:@selector(saveInfo)];
    
}

/**
 *  获取选择的控制器型号
 *
 *  @return
 */
- (NSString *)getSelectChannelType {

    return [[EGOCache globalCache] stringForKey:@"channelCount"];
}

/**
 *  获取选择的控制器型号
 *
 *  @return
 */
- (BOOL)getSelectisWifi {

    return [[[EGOCache globalCache] stringForKey:@"isWiFi"] isEqualToString:@"1"] ? YES:NO;
}

/**
 *  获取TableViewCell的UITextField
 *
 *  @param type 类型（ip、port）
 *
 *  @return
 */
- (UITextField *)getCellType:(NSInteger)type {

    settingCell *cellType = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:type inSection:0]];
    
    return cellType.detailText;
}

- (void)outKeyEvent {
    
    
    [[self getCellType:Type_IP] resignFirstResponder];
    
    [[self getCellType:Type_Port] resignFirstResponder];
}

- (void)saveInfo {

    //检测IP是否有效
    if (! [IdentifierValidator isValidatIP:[self getCellType:Type_IP].text]) {
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"Invalid IP"];
        
        return;
    }
    
    //检测端口是否有效
    if (! [IdentifierValidator isValidatPort:[self getCellType:Type_Port].text]) {
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"Invalid Port"];
        //[SVProgressHUD dismissWithDelay:1.5];
        
        return;
    }

    //执行更新
    if ([[DBManager shareInstance] updateIP_and_port:[self getSelectChannelType]
                                              isWifi:[self getSelectisWifi]
                                                  ip:[self getCellType:Type_IP].text
                                                port:[self getCellType:Type_Port].text]) {
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showSuccessWithStatus:@"Update Success"];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    settingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.nameText.text = @"IP";
    }else {
        cell.nameText.text = @"Port";
    }
    
    cell.detailText.text= [self.listArray objectAtIndex:indexPath.row];
    
    return cell;
}

@end
