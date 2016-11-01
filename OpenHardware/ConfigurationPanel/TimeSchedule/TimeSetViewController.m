//
//  TimeSetViewController.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 2016/11/1.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "TimeSetViewController.h"
#import "HSDatePickerViewController.h"

@interface TimeSetViewController()<HSDatePickerViewControllerDelegate> {

    NSArray *menuArray;
    
    NSString *nameStr;
    
    NSString *timeStr;
}

@end

@implementation TimeSetViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [super genUINavigationLeftBcakButton:[UIImage imageNamed:@"back"]];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:242.0/255 green:243.0/255 blue:244.0/255 alpha:1.0]];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:242.0/255 green:243.0/255 blue:244.0/255 alpha:1.0]];
    
    menuArray = [NSArray arrayWithObjects:@"Name", @"Time", @"Select Button", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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
            
            nameStr = alertController.textFields.firstObject.text;
            
            [self.tableView reloadData];
        }];
        
        okAction.enabled = NO;
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else if(indexPath.row == 1) {
        
        HSDatePickerViewController *hsdpvc = [[HSDatePickerViewController alloc] init];
        hsdpvc.delegate = self;
        
        [self presentViewController:hsdpvc animated:YES completion:nil];
    }else if(indexPath.row == 2) {
        
        [self performSegueWithIdentifier:@"ListTimeViewController" sender:self];
    }
}

#pragma mark HSDatePickerViewController delegate

- (void)hsDatePickerPickedDate:(NSDate *)date {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDateStr = [formatter stringFromDate:date];
    
    timeStr = currentDateStr;
    
    [self.tableView reloadData];
    
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

@end
