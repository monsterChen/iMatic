//
//  DBManager.h
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/9.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileUnitManager.h"
#import "FMDB.h"
#import "GroupModel.h"


@interface DBManager : NSObject

@property (nonatomic, strong) FMDatabase *db;

+ (DBManager *)shareInstance;

- (void)getDateBase:(NSString *)dbName;

- (void)createTable;

- (NSMutableArray *)queryChannelBtnName:(NSString *)channelType isWifi:(BOOL)isWifi;

- (BOOL)updateChannelBtnNameWithType:(NSString *)channelType isWifi:(BOOL)isWifi index:(NSInteger)index name:(NSString *)name;

- (NSMutableArray *)queryIP_and_port:(NSString *)channelType isWifi:(BOOL)isWifi;

- (BOOL)updateIP_and_port:(NSString *)channelType isWifi:(BOOL)isWifi ip:(NSString *)ip port:(NSString *)port;


- (NSMutableArray *)queryGroupNameArray:(NSString *)channel isWifi:(BOOL)isWifi;

- (BOOL)updateGroupButtonSelectState:(NSString *)Checkmark channel:(NSString *)channel isWifi:(BOOL)isWifi groupName:(NSString *)groupName index:(NSInteger)index;

- (BOOL)updateGroupButtonState:(NSString *)mark channel:(NSString *)channel isWifi:(BOOL)isWifi groupName:(NSString *)groupName index:(NSInteger)index;

- (BOOL)deleteGroupByName:(NSString *)name channel:(NSString *)channel isWifi:(BOOL)isWifi;;

- (NSMutableArray *)queryGroupButton:(NSString *)name channel:(NSString *)channel isWifi:(BOOL)isWifi;

- (BOOL)isGroupNameExists:(NSString *)groupName channel:(NSString *)channel isWifi:(BOOL)isWifi;

- (BOOL)updateGroupName:(NSString *)groupName newGroupName:(NSString *)newName channel:(NSString *)channel isWifi:(BOOL)isWifi;

- (BOOL)createGroup:(NSString *)groupName channel:(NSString *)channel isWifi:(BOOL)isWifi;



@end
