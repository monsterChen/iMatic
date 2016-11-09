//
//  TimeListController.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 2016/10/31.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "TimeListController.h"
#import "TimeSetViewController.h"
#import "timerModel.h"
#import "EGOManager.h"
#import "DBManager.h"

#import "AppDelegate.h"

@interface TimeListController ()

@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, strong) NSMutableArray *timeArr;

@property (nonatomic, strong) NSString *groupName;

@end

@implementation TimeListController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    NSArray *tmp = [[[DBManager shareInstance] queryTimeName:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi]] mutableCopy];
    
    self.array = [tmp objectAtIndex:0];
    
    self.timeArr = [tmp objectAtIndex:1];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [super genUINavigationLeftBcakButton:[UIImage imageNamed:@"back"]];
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:242.0/255 green:243.0/255 blue:244.0/255 alpha:1.0]];
    
    NSArray *tmp = [[[DBManager shareInstance] queryTimeName:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi]] mutableCopy];
    
    self.array = [tmp objectAtIndex:0];
    
    self.timeArr = [tmp objectAtIndex:1];
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
    return [self.array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timeListCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    
    cell.detailTextLabel.text = [self.timeArr objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
    if (indexPath.row == 0) {
        timerModel *model = [[timerModel alloc] init];
        
        NSDictionary *tmp = @{@"inOn":@"on", @"name":@"kevin"};
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:tmp forKey:@"info"];
        [dic setObject:[EGOManager getSelectChannelType] forKey:@"type"];
        [dic setObject:([EGOManager getSelectisWifi]? @"1":@"0") forKey:@"isWifi"];
        
        [model start:4 info:dic];
        
        [self.array addObject:model];
        
    }
    
    if (indexPath.row == 1) {
        NSLog(@"stop");
        timerModel *model = (timerModel *)[self.array objectAtIndex:0];
        
        [model stop];
    }
     */
    /*
    self.groupName = [self.array objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"seeDetail" sender:self];
     */
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        NSString *timeListKey = [NSString stringWithFormat:@"%@%d", [EGOManager getSelectChannelType], [EGOManager getSelectisWifi]];
        
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSMutableArray *array = [app.scheduleDic objectForKey:timeListKey];
        
        NSTimer *timer = (NSTimer *)[array objectAtIndex:indexPath.row];
        [timer invalidate];
        
        [array removeObjectAtIndex:indexPath.row];
        
        [app.scheduleDic setObject:array forKey:timeListKey];
        
        
        
        [[DBManager shareInstance] deleteTimeByName:[self.array objectAtIndex:indexPath.row] channel:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi]];
        
        [self.array removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }/*
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }  
      */
}

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


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}
*/
@end
