//
//  baseNavigationViewController.h
//  basePoj
//
//  Created by Kingyeung.Chan on 16/5/29.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface baseNavigationViewController : UINavigationController

- (void)genTitleTextAttributes:(UIColor *)color;

- (void)genBarTintColor:(UIColor *)color;

- (void)genBackgroudImage:(UIImage *)image;

- (void)genTabBarItemNormalColor:(UIColor *)color;

- (void)genTabBarItemHighlightedColor:(UIColor *)color;

- (void)setNabigationItemTintColor:(UIColor *)color;

@end
