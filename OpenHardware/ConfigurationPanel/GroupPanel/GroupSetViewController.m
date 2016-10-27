//
//  GroupSetViewController.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/16.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "GroupSetViewController.h"
#import "DBManager.h"
#import "EGOManager.h"
#import "ListViewController.h"
#import "channelCellBtn.h"

#define MakeItON    @"1"
#define MakeItOff   @"0"

@interface GroupSetViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSMutableArray *cellListAray;

@property (strong, nonatomic) NSMutableArray *buttonNameArray;

@end

@implementation GroupSetViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self getGroupButtonArray];
    
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super genUINavigationLeftBcakButton:[UIImage imageNamed:@"back"]];
    
    [super genUINavigationRightButton:[UIImage imageNamed:@"save"] andSize:CGSizeMake(20, 20) andEvent:@selector(saveGroup)];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:242.0/255 green:243.0/255 blue:244.0/255 alpha:1.0]];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:242.0/255 green:243.0/255 blue:244.0/255 alpha:1.0]];
    
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:242.0/255 green:243.0/255 blue:244.0/255 alpha:1.0]];
    
    [self getGroupButtonArray];
}

- (void)getGroupButtonArray {

    self.cellListAray = [NSMutableArray array];
    
    NSArray *array = [[DBManager shareInstance] queryGroupButton:self.groupName channel:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi]];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveGroup {

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"ListViewController"]) {
        
        ListViewController *controller = segue.destinationViewController;
        [controller setGroupName:self.groupName];
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

    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
        cell.detailTextLabel.text = self.groupName;
    }else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"selectBtnCell" forIndexPath:indexPath];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        /**
         *  弹出输入组名字的UIAlertController
         */
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Group Name" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.placeholder = self.groupName;
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
            
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.groupName = alertController.textFields.firstObject.text;
            
            [self.tableView reloadData];
            
        }];
        //冻结okAction按钮
        okAction.enabled = NO;
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    if (indexPath.row == 1) {
        
        if (self.groupName == nil || self.groupName.length == 0) {
            
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showErrorWithStatus:@"Invalid GroupName"];
        }else {
            
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [[DBManager shareInstance] createGroup:self.groupName channel:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi]];
            });
            

            [self performSegueWithIdentifier:@"ListViewController" sender:self];
        }
    }
}

/**
 *  监听输入的组别名字
 *
 *  @param notification 
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

#pragma mark UICollection delegate
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
    
    GroupModel *model = [self.cellListAray objectAtIndex:indexPath.row];
    
    [[DBManager shareInstance] updateGroupButtonState:mark channel:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi] groupName:self.groupName index:model.index];
    
    /*
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
    });
    */
    //NSLog(@"--> %d", cell.status);
}

@end
