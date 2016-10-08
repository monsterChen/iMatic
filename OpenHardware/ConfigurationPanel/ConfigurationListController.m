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
    
    self.listArray = [[NSArray alloc] initWithObjects:@"Update IP & port", @"Basic", @"Group", @"Buy it", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}

@end
