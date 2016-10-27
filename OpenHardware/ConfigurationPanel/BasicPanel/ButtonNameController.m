//
//  ButtonNameController.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/16.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "ButtonNameController.h"
#import "DBManager.h"
#import "EGOCache.h"
#import "IdentifierValidator.h"
#import "EGOManager.h"


@interface ButtonNameController ()

@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation ButtonNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [super genUINavigationLeftBcakButton:[UIImage imageNamed:@"back"]];
    
    self.listArray = [[[DBManager shareInstance] queryChannelBtnName:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi]] mutableCopy];
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:242.0/255 green:243.0/255 blue:244.0/255 alpha:1.0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [self.listArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"btnNameCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [self.listArray objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //按钮名字设置弹出窗口
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"" message:@"Please input the button name" preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alertViewController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = cell.textLabel.text;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }];
    //ok button
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *btnName = alertViewController.textFields.firstObject;
        
        //NSLog(@"row->%ld, %@, wifi->%d", indexPath.row, btnName.text, [self getSelectisWifi]);
        
        [[DBManager shareInstance] updateChannelBtnNameWithType:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi] index:indexPath.row name:btnName.text];
        
        self.listArray = [[[DBManager shareInstance] queryChannelBtnName:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi]] mutableCopy];
        
        [self.tableView reloadData];
        
    }];
    
    okAction.enabled = NO;
    
    //cancel button
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertViewController addAction:okAction];
    [alertViewController addAction:cancelAction];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}

- (void)alertTextFieldDidChange:(NSNotification *)notification {
    
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    
    if (alertController) {
        
        UITextField *btnName = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.firstObject;
        
        okAction.enabled = btnName.text.length > 2;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
