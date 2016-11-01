//
//  DBManager.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/9.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

+ (DBManager *)shareInstance {

    static DBManager *instance = nil;
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)getDateBase:(NSString *)dbName {

    NSString *fileName = [FileUnitManager getFilePathFromDirectoriesInDomains:dbName];
    NSLog(@"-->%@", fileName);
    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
    
    if ([db open]) {
        
        self.db = db;
        
        [self createTable];
    }
}

- (void)createTable {

    if (self.db) {
        
        [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS channel_info (type text, ip text, port text);"];
        
        [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS channel8_btnName (type text, btn_1 text, btn_2 text, btn_3 text,btn_4 text, btn_5 text, btn_6 text, btn_7 text, btn_8 text);"];
        
        [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS channel16_btnName (type text, btn_1 text, btn_2 text, btn_3 text, btn_4 text, btn_5 text, btn_6 text, btn_7 text, btn_8 text, btn_9 text, btn_10 text, btn_11 text, btn_12 text, btn_13 text, btn_14 text, btn_15 text, btn_16 text);"];
        
        FMResultSet *rs = [self.db executeQuery:@"SELECT COUNT(type) AS countNum FROM channel_info"];
        
        if ([rs next]) {
            NSInteger count = [rs intForColumn:@"countNum"];
            
            if (count == 0) {
                
                [self initialData];
            }
        }
        
        [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS group_16channel (name text,type text,btn_1 text DEFAULT '00', btn_2 text DEFAULT '00', btn_3 text DEFAULT '00', btn_4 text DEFAULT '00', btn_5 text DEFAULT '00', btn_6 text DEFAULT '00', btn_7 text DEFAULT '00', btn_8 text DEFAULT '00', btn_9 text DEFAULT '00', btn_10 text DEFAULT '00', btn_11 text DEFAULT '00', btn_12 text DEFAULT '00', btn_13 text DEFAULT '00', btn_14 text DEFAULT '00', btn_15 text DEFAULT '00', btn_16 text DEFAULT '00');"];
        
        [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS group_8channel (name text,type text,btn_1 text DEFAULT '00', btn_2 text DEFAULT '00', btn_3 text DEFAULT '00', btn_4 text DEFAULT '00', btn_5 text DEFAULT '00', btn_6 text DEFAULT '00', btn_7 text DEFAULT '00', btn_8 text DEFAULT '00');"];
    }
}

- (NSString *)setupGroupType:(BOOL)isWifi {

    return [NSString stringWithFormat:@"%@", (isWifi ? @"wifi" : @"")];
}

- (NSString *)setupGroupTable:(NSString *)channel {

    return [NSString stringWithFormat:@"group_%@channel", channel];
}
/**
 *  获取Group的按钮
 *
 *  @param name    group的名字
 *  @param channel 8或16
 *  @param isWifi  是否wifi
 *
 *  @return
 */
- (NSMutableArray *)queryGroupButton:(NSString *)name channel:(NSString *)channel isWifi:(BOOL)isWifi {

    NSString *type = [self setupGroupType:isWifi];
    
    NSString *groupTable = [self setupGroupTable:channel];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE name = '%@' and type = '%@'", groupTable, name, type];
    
    FMResultSet *rs = [self.db executeQuery:query];
    
    NSMutableArray *array = [NSMutableArray array];
    
    while (rs.next) {
        
        for(int i = 1; i <= [channel intValue]; i++) {
            
            NSString *btnColumn = [NSString stringWithFormat:@"btn_%d", i];
            [array addObject:[rs stringForColumn:btnColumn]];
        }
    }
    
    NSMutableArray *groupArray = [NSMutableArray array];
    
    for(int i = 0; i < [array count]; i++) {
        
        GroupModel *model = [[GroupModel alloc] initGroup:[array objectAtIndex:i] index:i];
        
        [groupArray addObject:model];
    }
    
    return groupArray;
}

- (BOOL)updateGroupButtonSelectState:(NSString *)Checkmark channel:(NSString *)channel isWifi:(BOOL)isWifi groupName:(NSString *)groupName index:(NSInteger)index{

    NSString *type = [self setupGroupType:isWifi];
    NSString *groupTable = [self setupGroupTable:channel];
    
    Checkmark = [Checkmark isEqualToString:@"1"] ? @"10" : @"00";
    
    NSString *update = [NSString stringWithFormat:@"UPDATE %@ SET btn_%ld = '%@' WHERE name = '%@' and type = '%@'", groupTable, index+1, Checkmark, groupName, type];
    
    return [self.db executeUpdate:update];
}

- (BOOL)updateGroupButtonState:(NSString *)mark channel:(NSString *)channel isWifi:(BOOL)isWifi groupName:(NSString *)groupName index:(NSInteger)index  {

    NSString *type = [self setupGroupType:isWifi];
    NSString *groupTable = [self setupGroupTable:channel];
    
    mark = [mark isEqualToString:@"1"] ? @"11" : @"10";
    
    NSString *update = [NSString stringWithFormat:@"UPDATE %@ SET btn_%ld = '%@' WHERE name = '%@' and type = '%@'", groupTable, index+1, mark, groupName, type];
    
    return [self.db executeUpdate:update];
}

/**
 *  列举group数组
 *
 *  @param channel <#channel description#>
 *  @param isWifi  <#isWifi description#>
 *
 *  @return <#return value description#>
 */
- (NSMutableArray *)queryGroupNameArray:(NSString *)channel isWifi:(BOOL)isWifi {

    NSString *type = [self setupGroupType:isWifi];
    
    NSString *groupTable = [self setupGroupTable:channel];
    
    NSString *query = [NSString stringWithFormat:@"SELECT name FROM %@ WHERE type = '%@'", groupTable, type];
    
    FMResultSet *rs = [self.db executeQuery:query];
    
    NSMutableArray *array = [NSMutableArray array];
    
    while (rs.next) {
        
        [array addObject:[rs stringForColumn:@"name"]];
    }
    
    return array;
}

/**
 *  删除指定group
 *
 *  @param name    <#name description#>
 *  @param channel <#channel description#>
 *  @param isWifi  <#isWifi description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)deleteGroupByName:(NSString *)name channel:(NSString *)channel isWifi:(BOOL)isWifi {

    NSString *type = [self setupGroupType:isWifi];
    
    NSString *groupTable = [self setupGroupTable:channel];
    
    NSString *delete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE name = '%@' and type = '%@'", groupTable, name, type];
    
    return [self.db executeUpdate:delete];
}

/**
 *  检测groupName是否已经存在
 *
 *  @param groupName <#groupName description#>
 *  @param channel   <#channel description#>
 *  @param isWifi    <#isWifi description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)isGroupNameExists:(NSString *)groupName channel:(NSString *)channel isWifi:(BOOL)isWifi {

    NSString *type = [self setupGroupType:isWifi];
    
    NSString *groupTable = [self setupGroupTable:channel];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE name = '%@' and type = '%@'", groupTable, groupName, type];
    
    FMResultSet *rs = [self.db executeQuery:query];
    
    if (rs.next) {
        
        return YES;
    }
    
    return NO;
}
/**
 *  更新groupName
 *
 *  @param groupName <#groupName description#>
 *  @param newName   <#newName description#>
 *  @param channel   <#channel description#>
 *  @param isWifi    <#isWifi description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)updateGroupName:(NSString *)groupName newGroupName:(NSString *)newName channel:(NSString *)channel isWifi:(BOOL)isWifi {

    if ([self isGroupNameExists:groupName channel:channel isWifi:isWifi]) {
        
        NSString *type = [self setupGroupType:isWifi];
        
        NSString *groupTable = [self setupGroupTable:channel];
        NSString *update = [NSString stringWithFormat:@"UPDATE %@ SET name = '%@' WHERE name = '%@' and type = '%@'", groupTable, newName, groupName, type];
        
        return [self.db executeUpdate:update];
    }
    
    return NO;
}

- (BOOL)createGroup:(NSString *)groupName channel:(NSString *)channel isWifi:(BOOL)isWifi {
    
    /*
    if (! [self isGroupNameExists:groupName channel:channel isWifi:isWifi]) {
        
        NSString *type = [self setupGroupType:isWifi];
        NSString *groupTable = [self setupGroupTable:channel];
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO %@ ", groupTable];
        insert = [insert stringByAppendingString:@"(name, type) VALUES (?,?);"];
        
        return [self.db executeUpdate:insert, groupName, type];
    }
    //NSLog(@"exit group");
    return NO;
     */
    NSString *type = [self setupGroupType:isWifi];
    NSString *groupTable = [self setupGroupTable:channel];
    NSString *insert = [NSString stringWithFormat:@"INSERT INTO %@ ", groupTable];
    insert = [insert stringByAppendingString:@"(name, type) VALUES (?,?);"];
    
    return [self.db executeUpdate:insert, groupName, type];
}


- (void)initialData {

    if (self.db) {
        /**
         *  写入默认的连接信息
         *
         *  @param type 设备类型，8路，8路wifi，16路，16路wifi
         *  @param ip   连接的ip地址
         *  @param port 连接端口
         *
         *  @return 
         */
        [self.db executeUpdate:@"INSERT INTO channel_info (type, ip, port) VALUES (?, ?, ?);", @"8", @"182.168.1.4", @"30000"];
        
        [self.db executeUpdate:@"INSERT INTO channel_info (type, ip, port) VALUES (?, ?, ?);", @"8_wifi", @"182.168.1.4", @"30000"];
        
        [self.db executeUpdate:@"INSERT INTO channel_info (type, ip, port) VALUES (?, ?, ?);", @"16", @"182.168.1.4", @"3000"];
        
        [self.db executeUpdate:@"INSERT INTO channel_info (type, ip, port) VALUES (?, ?, ?);", @"16_wifi", @"182.168.1.4", @"30000"];
        
        [self.db executeUpdate:@"INSERT INTO channel8_btnName (type) VALUES (?);", @"8"];
        [self.db executeUpdate:@"INSERT INTO channel8_btnName (type) VALUES (?);", @"8wifi"];
        [self.db executeUpdate:@"INSERT INTO channel16_btnName (type) VALUES (?);", @"16"];
        [self.db executeUpdate:@"INSERT INTO channel16_btnName (type) VALUES (?);", @"16wifi"];
        //8路控制器入按钮默认名字
        for (int i = 0; i < 8; i++) {
            
            NSString *data = [NSString stringWithFormat:@"RELAY0%d", i+1];
            NSString *insert = [NSString stringWithFormat:@"UPDATE channel8_btnName SET btn_%d = '%@' where type = '8';", i+1, data];
            [self.db executeUpdate:insert];
            
            //8 wifi
            insert = [NSString stringWithFormat:@"UPDATE channel8_btnName SET btn_%d = '%@' where type = '8wifi';", i+1, data];
            [self.db executeUpdate:insert];
        }
        //16路控制器默认名字
        for (int i = 0; i < 16; i++) {
            
            NSString *data = [NSString stringWithFormat:@"RELAY%d", (i+1 < 10 ? [[NSString stringWithFormat:@"0%d", i+1] intValue]:i+1)];
            NSString *insert = [NSString stringWithFormat:@"UPDATE channel16_btnName SET btn_%d = '%@' where type = '16';", i+1, data];
            [self.db executeUpdate:insert];
            
            //16 wifi
            insert = [NSString stringWithFormat:@"UPDATE channel16_btnName SET btn_%d = '%@' where type = '16wifi';", i+1, data];
            [self.db executeUpdate:insert];
        }
    }
}
//获取按钮名称列表数组
- (NSMutableArray *)queryChannelBtnName:(NSString *)channelType isWifi:(BOOL)isWifi {

    NSString *tableName = [NSString stringWithFormat:@"channel%@_btnName", channelType];
    NSString *type = [NSString stringWithFormat:@"%@%@", channelType, (isWifi ? @"wifi" : @"")];
    
    FMResultSet *resutlSet = [self.db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE type = '%@'", tableName, type]];
    NSMutableArray *invArray = [NSMutableArray array];
    
    while (resutlSet.next) {
        
        for (int i = 1; i < [resutlSet columnCount]; i++) {
            
            NSString *btnColumn = [NSString stringWithFormat:@"btn_%d", i];
            [invArray addObject:[resutlSet stringForColumn:btnColumn]];
        }
    }
    
    return invArray;
}
//更新按钮名字
- (BOOL)updateChannelBtnNameWithType:(NSString *)channelType isWifi:(BOOL)isWifi index:(NSInteger)index name:(NSString *)name {
    
    NSString *type = [channelType mutableCopy];
    if (isWifi) {
        type = [channelType stringByAppendingString:@"wifi"];
    }
    
    NSString *update = [NSString stringWithFormat:@"UPDATE channel%@_btnName SET btn_%ld = '%@' where type = '%@'", channelType, index+1, name, type];
    
    return [self.db executeUpdate:update];
}
//获取IP和端口信息
- (NSMutableArray *)queryIP_and_port:(NSString *)channelType isWifi:(BOOL)isWifi {
    
    if (isWifi) {
        channelType = [channelType stringByAppendingString:@"_wifi"];
    }
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM channel_info WHERE type = '%@'", channelType];
    
    FMResultSet *rs = [self.db executeQuery:query];
    
    NSMutableArray *invArray = [NSMutableArray array];
    
    while ([rs next]) {
        
        NSString *ip = [rs stringForColumn:@"ip"];
        NSString *port = [rs stringForColumn:@"port"];
        
        [invArray addObject:ip];
        [invArray addObject:port];
    }
    
    return invArray;
}
//更新ip或端口
- (BOOL)updateIP_and_port:(NSString *)channelType isWifi:(BOOL)isWifi ip:(NSString *)ip port:(NSString *)port {

    if (isWifi) {
        channelType = [channelType stringByAppendingString:@"_wifi"];
    }
    
    NSString *update = [NSString stringWithFormat:@"UPDATE channel_info SET ip = '%@', port = '%@' where type = '%@'", ip, port, channelType];
    
    return [self.db executeUpdate:update];
}

@end
