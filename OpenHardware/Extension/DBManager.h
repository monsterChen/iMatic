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

@interface DBManager : NSObject

@property (nonatomic, strong) FMDatabase *db;

+ (DBManager *)shareInstance;

- (void)getDateBase:(NSString *)dbName;

- (void)createTable;

- (NSMutableArray *)queryChannelBtnName:(NSString *)channelType isWifi:(BOOL)isWifi;

- (BOOL)updateChannelBtnNameWithType:(NSString *)channelType isWifi:(BOOL)isWifi index:(NSInteger)index name:(NSString *)name;

- (NSMutableArray *)queryIP_and_port:(NSString *)channelType isWifi:(BOOL)isWifi;

- (BOOL)updateIP_and_port:(NSString *)channelType isWifi:(BOOL)isWifi ip:(NSString *)ip port:(NSString *)port;

@end
