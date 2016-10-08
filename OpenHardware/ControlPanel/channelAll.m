//
//  channelAll.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/8.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "channelAll.h"

@implementation channelAll

- (void)awakeFromNib {

    [self setBtnStatus:ALL_OFF];
    
    self.highlighted = NO;
    
    [self addTarget:self action:@selector(updateState) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateState {

    if(self.btnStatus == ALL_OFF) {
        
        self.btnStatus = ALL_ON;
    }else if(self.btnStatus == ALL_ON){
        
        self.btnStatus = ALL_OFF;
    }
}

- (void)setBtnStatus:(BTNStatus)btnStatus {

    if (btnStatus == ALL_OFF) {
        
        _btnStatus = ALL_OFF;
        [self setImage:[UIImage imageNamed:@"btn_all_off"] forState:UIControlStateNormal];
    }else if(btnStatus == ALL_ON) {
        
        _btnStatus = ALL_ON;
        [self setImage:[UIImage imageNamed:@"btn_all_on"] forState:UIControlStateNormal];
    }
}

@end
