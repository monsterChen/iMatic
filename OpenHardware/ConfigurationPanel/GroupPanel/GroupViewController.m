//
//  GroupViewController.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/16.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "GroupViewController.h"
#import "DBManager.h"
#import "EGOManager.h"
#import "GroupSetViewController.h"

@interface GroupViewController ()

@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, strong) NSString *groupName;

@end

@implementation GroupViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    self.listArray = [[DBManager shareInstance] queryGroupNameArray:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi]];
    
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
    
    self.listArray = [[DBManager shareInstance] queryGroupNameArray:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)addGroup {

}
*/

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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [self.listArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.groupName = [self.listArray objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"settingGroup" sender:self];
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
        
        [[DBManager shareInstance] deleteGroupByName:[self.listArray objectAtIndex:indexPath.row] channel:[EGOManager getSelectChannelType] isWifi:[EGOManager getSelectisWifi]];
        
        [self.listArray removeObjectAtIndex:indexPath.row];
        
        self.groupName = nil;
        
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"settingGroup"]) {
        
        GroupSetViewController *controller = [segue destinationViewController];
        [controller setGroupName:self.groupName];
    }
}

@end
