//
//  settingCell.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/10.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "settingCell.h"

@implementation settingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.detailText.textColor = [UIColor grayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
