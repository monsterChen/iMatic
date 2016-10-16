//
//  ViewController.m
//  basePoj
//
//  Created by Kingyeung.Chan on 16/5/29.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "baseViewController.h"

@interface baseViewController ()

@end

@implementation baseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
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


@end
