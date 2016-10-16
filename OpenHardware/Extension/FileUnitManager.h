//
//  FileUnitManager.h
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/9.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUnitManager : NSObject

+ (NSString *)getFilePathFromDirectoriesInDomains:(NSString *)fileName;

+ (NSString *)getFilePathForResource:(NSString *)fileName;

@end
