//
//  baseNavigationViewController.m
//  basePoj
//
//  Created by Kingyeung.Chan on 16/5/29.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "baseNavigationViewController.h"

@interface baseNavigationViewController ()

@end

@implementation baseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 设置返回按钮颜色
- (void)setNabigationItemTintColor:(UIColor *)color {
    
    [[UINavigationBar appearance] setTintColor:color];
}

#pragma mark - 设置navigationBar 颜色
- (void)genBarTintColor:(UIColor *)color {

    [self.navigationBar setBarTintColor:color];
}

#pragma mark - 设置navigationBar title字体颜色
- (void)genTitleTextAttributes:(UIColor *)color {

    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes = dict;
}

#pragma mark - 设置navigationBar 背景图片
- (void)genBackgroudImage:(UIImage *)image {

    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - 这是tabBarItem字体颜色
- (void)genTabBarItemNormalColor:(UIColor *)color {

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       color, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
}

- (void)genTabBarItemHighlightedColor:(UIColor *)color {

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       color, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
}

@end
