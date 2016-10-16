//
//  ViewController.h
//  basePoj
//
//  Created by Kingyeung.Chan on 16/5/29.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"

@interface baseViewController : UIViewController

@property(assign,nonatomic) BOOL isNavBarHide;

@property(assign,nonatomic) BOOL isTabBarHide;

//隐藏上方导航栏
- (void)hideNavigationBar;

//显示上方导航栏
- (void)showNavigationBar;

//隐藏下方Tab导航
- (void)hideTabBar;

//显示下方Tab导航
- (void)showTabBar;

//点击空白回收键盘
- (void)recoveryOfKeyboard;

//生成导航栏标题titleView对象
- (void)genNavigationTitleView:(UIImage *)titleImage;

//生成导航栏左边按钮
- (UIBarButtonItem *)genUINavigationLeftBcakButton:(UIImage *)image;

- (UIBarButtonItem *)genUINavigationLeftButton:(SEL)pressEvent andImage:(UIImage *)image;

//生成导航栏右边按钮
- (UIBarButtonItem *)genUINavigationRightButton:(NSString *)title andEvent: (SEL)pressEvent;

- (UIBarButtonItem *)genUINavigationRightButton:(UIImage *)bgImage andSize:(CGSize) size andEvent: (SEL)pressEvent;

- (NSString *)getFilePathFromDirectoriesInDomains:(NSString *)fileName;

- (NSString *)getFilePathForResource:(NSString *)fileName;

@end

