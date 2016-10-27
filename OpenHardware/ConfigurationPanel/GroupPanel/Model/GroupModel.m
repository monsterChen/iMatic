//
//  GroupModel.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/25.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "GroupModel.h"

@implementation GroupModel

- (instancetype)initGroup:(NSString *)str index:(NSInteger)index{

    if (self = [super init]) {
        //NSLog(@"1 -> %@, 2 - > %@, total:%@", [str substringToIndex:1], [str substringFromIndex:1], str);
        if ([[str substringToIndex:1] isEqualToString:@"0"]) {
            
            self.selectState = notSelect;
        }else if ([[str substringToIndex:1] isEqualToString:@"1"]) {
            
            self.selectState = isSelect;
        }
        
        if ([[str substringFromIndex:1] isEqualToString:@"0"]) {
            
            self.state = isOFF;
        }else if([[str substringFromIndex:1] isEqualToString:@"1"]) {
            
            self.state = isOn;
        }
        
        self.index = index;
        
    }
    
    return self;
}

@end
