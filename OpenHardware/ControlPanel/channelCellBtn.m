//
//  channelCellBtn.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/7.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "channelCellBtn.h"

@implementation channelCellBtn

- (void)awakeFromNib {
    
    self.labelText.textColor = [UIColor colorWithRed:110.0/255 green:194.0/255 blue:198.0/255 alpha:1.0];
    self.status = CHANNEL_OFF;
}

- (void)initialStatus {

    [self.imageView setImage:[UIImage imageNamed:@"btn_off"]];
}

- (void)updateChannelStatus {

    if (self.status == CHANNEL_OFF) {
        
        self.status = CHANNEL_ON;
        [self.imageView setImage:[UIImage imageNamed:@"btn_on"]];
    }else if (self.status == CHANNEL_ON) {
        
        self.status = CHANNEL_OFF;
        [self.imageView setImage:[UIImage imageNamed:@"btn_off"]];
    }
}

- (void)setStatus:(ChannelStatus)status {

    _status = status;
    
    if (status == CHANNEL_ON) {
        [self.imageView setImage:[UIImage imageNamed:@"btn_on"]];
    }else {
        
        [self.imageView setImage:[UIImage imageNamed:@"btn_off"]];
    }
}

- (void)initialCellIndex:(NSIndexPath *)indexPath {

    self.index = indexPath.row;
}

@end
