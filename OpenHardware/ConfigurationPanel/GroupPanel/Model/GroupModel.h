//
//  GroupModel.h
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/25.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {

    isOn = 1,
    isOFF
}GroupBtnState;

typedef enum {

    isSelect = 1,
    notSelect
}SelectState;

@interface GroupModel : NSObject

@property (nonatomic, assign) GroupBtnState state;

@property (nonatomic, assign) SelectState selectState;

@property (nonatomic, assign) NSInteger index;

- (instancetype)initGroup:(NSString *)str index:(NSInteger)index;

@end
