//
//  HomeTableViewController.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/6.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "HomeTableViewController.h"
#import "ControlPanelViewController.h"
#import "EGOCache.h"

@interface HomeTableViewController () {
    
    NSTimer *autoTimer;
}

@property (nonatomic, strong) NSArray *menuArray;

@property (assign, nonatomic) NSString *channelCount;

@property (assign, nonatomic) BOOL isWifi;

@property (assign, nonatomic) BOOL isBasic;

@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //self.tableView.backgroundColor = [UIColor darkGrayColor];
    
    self.menuArray = [NSArray arrayWithObjects:@"8 Channels", @"8 Channels with WiFi", @"16 Channels", @"16 Channels with WiFi", @"Buy It", nil];
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:242.0/255 green:243.0/255 blue:244.0/255 alpha:1.0]];
}

- (void)excute {

    if (autoTimer) {
        [autoTimer invalidate];
        autoTimer = nil;
    }
    
    autoTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(testPrint) userInfo:nil repeats:NO];
    
}

- (void)cancelTimer {

    if (autoTimer != nil) {
        [autoTimer invalidate];
        autoTimer = nil;
    }
    
    NSLog(@"cancel");
}

- (void)testPrint {

    NSLog(@"timer run");
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
    return [self.menuArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chennalTypeCell"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    cell.textLabel.text = [self.menuArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        
        self.channelCount = @"8";
    }else {
    
        self.channelCount = @"16";
    }
    
    if (indexPath.row == 0 || indexPath.row == 2) {
        self.isWifi = NO;
    }else {
        self.isWifi = YES;
    }
    
    if (indexPath.row != 4) {
        
        [self performSegueWithIdentifier:@"showControllerPanel" sender:self];
    }else {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.amazon.com/s/ref=nb_sb_noss_2?url=search-alias%3Daps&field-keywords=imatic"]];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    ControlPanelViewController *viewController = [segue destinationViewController];
    [viewController setIsWiFi:self.isWifi];
    [viewController setChannelCount:self.channelCount];
}

@end
