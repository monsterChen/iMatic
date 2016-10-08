//
//  baseTableViewController.m
//  iMatic
//
//  Created by Kingyeung.Chan on 16/6/12.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "baseTableViewController.h"

@interface baseTableViewController ()

@end

@implementation baseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationBar

- (void)hideNavigationBar {
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)showNavigationBar {
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 点击空白回收键盘
/**
 *  需要对应实现outKeyEvent事件
 */
- (void)recoveryOfKeyboard {
    
    UITapGestureRecognizer *keyGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(outKeyEvent)];
    keyGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:keyGesture];
}

#pragma mark - UITabBarController
#warning you have to change to your tabBarController
- (void)hideTabBar {
    
    /*
     UITabBarController *tab = [(AppDelegate *)[[UIApplication sharedApplication] delegate] tab];
     
     tab.tabBar.hidden = YES;
     */
    
    //do something
}

- (void)showTabBar {
    
    /*
     UITabBarController *tab = [(AppDelegate *)[[UIApplication sharedApplication] delegate] tab];
     
     tab.tabBar.hidden = NO;
     */
    
    //do something
}

#pragma mark - 导航栏标题titleView对象
- (void)genNavigationTitleView:(UIImage *)titleImage {
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 4, 50, 20)];
    [titleImageView setImage:titleImage];
    
    self.navigationItem.titleView = titleImageView;
}

#pragma mark - 生成导航栏左边按钮
- (UIBarButtonItem *)genUINavigationLeftBcakButton:(UIImage *)image {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backEvent:)];
    backButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backButton;
    return backButton;
}
/**
 *  导航栏左按钮默认返回上一界面
 *
 *  @param btn
 */
- (void)backEvent:(UIButton *)btn {
    
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  导航栏左按钮
 *
 *  @param pressEvent 点击事件
 *  @param image      图片
 *
 *  @return
 */
- (UIBarButtonItem *)genUINavigationLeftButton:(SEL)pressEvent andImage:(UIImage *)image {
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:pressEvent];
    backButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backButton;
    return backButton;
}

#pragma mark - 生成导航栏右边按钮
/**
 *  导航栏右按钮
 *
 *  @param title      标题
 *  @param pressEvent 点击事件
 *
 *  @return
 */
- (UIBarButtonItem *)genUINavigationRightButton:(NSString *)title andEvent:(SEL)pressEvent {
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle: title
                                                               style: UIBarButtonItemStylePlain
                                                              target: self
                                                              action: pressEvent];
    button.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = button;
    return button;
}
/**
 *  导航栏右按钮
 *
 *  @param bgImage    按钮图片
 *  @param size       按钮尺寸
 *  @param pressEvent 点击事件
 *
 *  @return
 */
- (UIBarButtonItem *)genUINavigationRightButton:(UIImage *)bgImage andSize:(CGSize)size andEvent:(SEL)pressEvent {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
    
    btn.frame =CGRectMake(0, 0, size.width, size.height);
    
    [btn addTarget: self action: pressEvent forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem* item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem=item;
    
    return  item;
}


- (NSString *)getFileFromDirectoriesInDomains:(NSString *)fileName {
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *path = [paths objectAtIndex:0];
    
    return [path stringByAppendingPathComponent:fileName];
    
}

- (NSString *)getFilePathForResource:(NSString *)fileName {
    
    return [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
