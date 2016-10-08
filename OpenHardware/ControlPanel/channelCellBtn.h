//
//  channelCellBtn.h
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/7.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    CHANNEL_ON = 1,
    CHANNEL_OFF
}ChannelStatus;

@interface channelCellBtn : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *labelText;

@property (nonatomic, assign) ChannelStatus status;

@property (nonatomic, assign) NSInteger index;

- (void)initialCellIndex:(NSIndexPath *)indexPath;

- (void)initialStatus;

- (void)updateChannelStatus;

@end
