//
//  FileUnitManager.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/9.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "FileUnitManager.h"

@implementation FileUnitManager

/**
 *  获取沙盒文件路径
 *
 *  @param fileName
 *
 *  @return 沙盒文件路径
 */
+ (NSString *)getFilePathFromDirectoriesInDomains:(NSString *)fileName {

    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *path = [paths objectAtIndex:0];
    
    return [path stringByAppendingPathComponent:fileName];
}

/**
 *  项目资源文件路径
 *
 *  @param fileName
 *
 *  @return 文件路径
 */
+ (NSString *)getFilePathForResource:(NSString *)fileName {
    
    return [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
}

@end
