//
//  ConfigurationListController.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/8.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "ConfigurationListController.h"

@interface ConfigurationListController()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *listArray;

@end


@implementation ConfigurationListController


- (void)viewDidLoad {

    [super viewDidLoad];
    
    [super genUINavigationLeftBcakButton:[UIImage imageNamed:@"back"]];
    
    self.listArray = [[NSArray alloc] initWithObjects:@"Update IP & port", @"Basic", @"Group", @"Time schedule",nil];
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:242.0/255 green:243.0/255 blue:244.0/255 alpha:1.0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    static NSString *identifier = @"listCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = [self.listArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        [self performSegueWithIdentifier:@"ip_and_port" sender:self];
    } else if(indexPath.row == 1) {
        
        [self performSegueWithIdentifier:@"buttonNameController" sender:self];
    } else if (indexPath.row == 2) {
        
        [self performSegueWithIdentifier:@"groupViewController" sender:self];
    } else if(indexPath.row == 3) {
        
        [self performSegueWithIdentifier:@"TimeListController" sender:self];
    }
}

@end
