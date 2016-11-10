//
//  TimeSetViewController.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 2016/11/1.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "TimeSetViewController.h"
#import "HSDatePickerViewController.h"
#import "ListTimeViewController.h"
#import "channelCellBtn.h"
#import "DBManager.h"
#import "EGOManager.h"
#import "timerModel.h"

#import "GCDAsyncSocket.h"
#import "AppDelegate.h"
#import "CommandCode.h"
#import "timerModel.h"

#define MakeItON    @"1"
#define MakeItOff   @"0"

@interface TimeSetViewController()<HSDatePickerViewControllerDelegate, GCDAsyncSocketDelegate> {

    NSArray *menuArray;
    
    NSString *nameStr;
    
    NSString *timeStr;
    
    GCDAsyncSocket *clientStock;
    
    NSTimer *_timer;
}

@property (strong, nonatomic) NSMutableArray *cellListAray;

@property (strong, nonatomic) NSMutableArray *buttonNameArray;


@property (strong, nonatomic) NSArray *commandCode_ON;

@property (strong, nonatomic) NSArray *commandCode_OFF;


@end

@implementation TimeSetViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self getGroupButtonArray];
    
    [self.collectionView reloadData];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    //[super genUINavigationLeftBcakButton:[UIImage imageNamed:@"back"]];
    [super genUINavigationLeftButton:@selector(back) andImage:[UIImage imageNamed:@"back"]];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:242.0/255 green:243.0/255 blue:244.0/255 alpha:1.0]];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:242.0/255 green:243.0/255 blue:244.0/255 alpha:1.0]];
    
    menuArray = [NSArray arrayWithObjects:@"Name", @"Time", @"Select Button", nil];
    
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:242.0/255 green:243.0/255 blue:244.0/255 alpha:1.0]];
    
    [self getGroupButtonArray];
}

- (void)back {
    
    
    if (timeStr != nil) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:timeStr];
        
        //获取当前时间
        NSDate *nowDate = [NSDate date];
        //计算时间差
        double interval = [date timeIntervalSinceDate:nowDate];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(scheduldSendCommand:) userInfo:[NSString stringWithFormat:@"%@", timeStr] repeats:NO];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        
        NSString *timeListKey = [NSString stringWithFormat:@"%@%d", [EGOManager getSelectChannelType], [EGOManager getSelectisWifi]];
        
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if ([app.scheduleDic valueForKey:timeListKey] == nil) {
            
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:_timer];
            
            [app.scheduleDic setObject:array forKey:timeListKey];
        }else {
            
            NSMutableArray *array = [app.scheduleDic objectForKey:timeListKey];
            [array addObject:_timer];
            
            [app.scheduleDic setObject:array forKey:timeListKey];
        }
        
    }

    /*
    timerModel *model = [[timerModel alloc] init];
    NSDictionary *tmp = @{@"index":@"1", @"object":self};
    [model start:2 info:tmp];
    */
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scheduldSendCommand:(NSTimer *)t {

    //NSLog(@"--->>>>>> %@", [t userInfo]);
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    clientStock = app.clientStock;
    [clientStock setDelegate:self];
    
    self.commandCode_ON = [CommandCode initCommaneCode_ON:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi]];
    
    self.commandCode_OFF = [CommandCode initCommaneCode_OFF:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi]];
    
    if (clientStock.isConnected ||clientStock.isDisconnected) {
        
        //[clientStock writeData:[CommandCode decode8:[self.commandCode_ON objectAtIndex:0]] withTimeout:1 tag:-1];
        //[clientStock readDataWithTimeout:1 tag:-1];
        
        //[clientStock connectToHost:@"192.168.1.4" onPort:30000 withTimeout:5 error:nil];
        
        NSArray *array = [[DBManager shareInstance] queryTimeButton:nameStr channel:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi]];
        
        for(GroupModel *model in array) {
            
            if (model.selectState == isSelect) {
                
                NSString *code;
                if (model.state == isOn) {
                    
                    code = [self.commandCode_ON objectAtIndex:model.index];
                }else if(model.state == isOFF) {
                    
                    code = [self.commandCode_OFF objectAtIndex:model.index];
                }
                
                if ([[EGOManager getSelectChannelType] isEqualToString:@"8"]) {
                    
                    [clientStock writeData:[CommandCode decode8:code] withTimeout:2 tag:-1];
                }else if ([[EGOManager getSelectChannelType] isEqualToString:@"16"]) {
                    
                    [clientStock writeData:[CommandCode decode16:code] withTimeout:2 tag:-1];
                }
            }
        }
    }

}

#pragma mark GCDAsyncSocket delegate
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {

    NSLog(@"Read");
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {

    NSLog(@"write");
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    
    NSLog(@"--->>>>%@", err);
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    
    NSLog(@"did connect");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getGroupButtonArray {
    
    self.cellListAray = [NSMutableArray array];
    
    NSArray *array = [[DBManager shareInstance] queryTimeButton:nameStr channel:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi]];
    
    for(GroupModel *model in array) {
        
        if (model.selectState == isSelect) {
            
            [self.cellListAray addObject:model];
        }
    }
    
    self.buttonNameArray = [NSMutableArray array];
    NSArray *tmp = [[[DBManager shareInstance] queryChannelBtnName:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi]] mutableCopy];
    
    for(GroupModel *model in self.cellListAray) {
        
        [self.buttonNameArray addObject:[tmp objectAtIndex:model.index]];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"ListTimeViewController"]) {
        
        ListTimeViewController *controller = segue.destinationViewController;
        [controller setGroupName:nameStr];
    }
}

#pragma mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timeCell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = [menuArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        
        cell.detailTextLabel.text = nameStr;
    }else if (indexPath.row == 1) {
        
        cell.detailTextLabel.text = timeStr;
    }else {
        
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Name" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.placeholder = nameStr;
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *placeholder = alertController.textFields.firstObject.placeholder;
            
            if (placeholder == nil || placeholder.length == 0) {
                //创建timeGroup
                if (! [[DBManager shareInstance] isTimeNameExists:alertController.textFields.firstObject.text channel:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi]]) {
                    
                    nameStr = alertController.textFields.firstObject.text;
                    [[DBManager shareInstance] createTime:nameStr channel:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi]];
                }else {
                    
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    [SVProgressHUD showErrorWithStatus:@"This Name was exist"];
                }
            }
            
            nameStr = alertController.textFields.firstObject.text;
            
            [self.tableView reloadData];
        }];
        
        okAction.enabled = NO;
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else if(indexPath.row == 1) {
        
        if (nameStr == nil || nameStr.length == 0) {
            
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showErrorWithStatus:@"Invalid name"];
        }else {
        
            if (timeStr == nil || timeStr.length == 0) {
            
                HSDatePickerViewController *hsdpvc = [[HSDatePickerViewController alloc] init];
                hsdpvc.delegate = self;
            
                [self presentViewController:hsdpvc animated:YES completion:nil];
            }
        }
        
    }else if(indexPath.row == 2) {
        
        if (nameStr == nil || nameStr.length == 0 || timeStr == nil || timeStr.length == 0) {
            
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showErrorWithStatus:@"Invalid time or name"];
        }else {
         
            [self performSegueWithIdentifier:@"ListTimeViewController" sender:self];
        }
    }
}

#pragma mark HSDatePickerViewController delegate

- (void)hsDatePickerPickedDate:(NSDate *)date {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDateStr = [formatter stringFromDate:date];
    
    //获取当前时间
    NSDate *nowDate = [NSDate date];
    //计算时间差
    double interval = [date timeIntervalSinceDate:nowDate];
    
    if (interval > 0) {
        
        timeStr = currentDateStr;
        
        [[DBManager shareInstance] updateTimeStr:timeStr channel:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi] groupName:nameStr];
        
        [self.tableView reloadData];
    }else {
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"Date Error"];
        
        timeStr = nil;
        
        [self.tableView reloadData];
    }
    
    //NSLog(@"time %@", currentDateStr);
}

/**
 *  检测 alertController 输入框
 *
 *  @param notification <#notification description#>
 */
- (void)alertTextFieldDidChange:(NSNotification *)notification {

    UIAlertController *alert = (UIAlertController *)self.presentedViewController;
    
    if (alert) {
        
        UITextField *btnName = alert.textFields.firstObject;
        UIAlertAction *okAction = alert.actions.firstObject;
        //输入长度大于的字符后，激活okAction按钮
        okAction.enabled = btnName.text.length > 2;
    }
}

#pragma mark UICollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.cellListAray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"channelCellBtn";
    
    channelCellBtn *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.labelText.text = [self.buttonNameArray objectAtIndex:indexPath.row];
    
    GroupModel *model = [self.cellListAray objectAtIndex:indexPath.row];
    if (model.state == isOn) {
        
        cell.status = CHANNEL_ON;
    }else {
        
        cell.status = CHANNEL_OFF;
    }
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    channelCellBtn *cell = (channelCellBtn *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [cell updateChannelStatus];
    
    NSString *mark = (cell.status == CHANNEL_ON ? MakeItON : MakeItOff);
    
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GroupModel *model = [self.cellListAray objectAtIndex:indexPath.row];
        //NSLog(@"%@", self.groupName);
        [[DBManager shareInstance] updateTimeButtonState:mark channel:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi] groupName:nameStr index:model.index];
    });
}

@end
