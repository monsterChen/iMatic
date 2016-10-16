//
//  ValidateFunction.h
//  ClothesPublic
//
//  Created by Kingyeung.Chan on 16/4/17.
//  Copyright © 2016年 golead. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdentifierValidator : NSObject

+ (BOOL)isValidateEmail:(NSString*)email;

+ (BOOL)isWhitespaceCharacter:(NSString *)str;

//+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

+ (BOOL)isPureInt:(NSString*)string;

+ (BOOL)isPureFloat:(NSString*)string;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (BOOL)isValidNumber:(NSString*)value;

@end
