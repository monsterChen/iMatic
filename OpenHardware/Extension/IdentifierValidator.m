//
//  ValidateFunction.m
//  ClothesPublic
//
//  Created by Kingyeung.Chan on 16/4/17.
//  Copyright © 2016年 golead. All rights reserved.
//

#import "IdentifierValidator.h"

int getIndex (char ch);
BOOL isNumber (char ch);

/**
 *  判断字符是否是数字和字母以及下划线
 *
 *  @param ch 字符
 *
 *  @return YES or NO
 */
int getIndex (char ch) {
    
    if ((ch >= '0'&& ch <= '9')||(ch >= 'a'&& ch <= 'z')||
        (ch >= 'A' && ch <= 'Z')|| ch == '_') {
        return 0;
    }
    if (ch == '@') {
        return 1;
    }
    if (ch == '.') {
        return 2;
    }
    return -1;
}
/**
 *  判断字符是否为数字
 *
 *  @param ch 字符
 *
 *  @return YES or NO
 */
BOOL isNumber (char ch) {
    
    if (!(ch >= '0' && ch <= '9')) {
        return FALSE;
    }
    return TRUE;
}

@implementation IdentifierValidator

+ (BOOL)isValidateEmail:(NSString *)email {

    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isWhitespaceCharacter:(NSString *)str {

    return [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""];
}


+ (BOOL)isPureInt:(NSString*)string {

    NSScanner *scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)isPureFloat:(NSString*)string {

    NSScanner *scan = [NSScanner scannerWithString:string];
    
    float var;
    
    return [scan scanFloat:&var] && [scan isAtEnd];
}

/**
 *  判断是否数字
 *
 *  @param value NSString
 *
 *  @return YES or NO
 */
+ (BOOL)isValidNumber:(NSString*)value{
    
    const char *cvalue = [value UTF8String];
    int len = strlen(cvalue);
    for (int i = 0; i < len; i++) {
        if(!isNumber(cvalue[i])){
            return NO;
        }
    }
    return YES;
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum {

    if (! [IdentifierValidator isValidNumber:mobileNum]) {
        
        return NO;
    }
    
    if (mobileNum.length > 11 || mobileNum.length < 11) {
        return NO;
    }
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\\\d{8}$";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\\\d)\\\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    if (regextestmobile || regextestcm || regextestcu) {
        return YES;
    }else {
        return NO;
    }
}

+ (BOOL)isValidatIP:(NSString *)ipAddress {
    
    NSString  *urlRegEx =@"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:ipAddress];
}

+ (BOOL)isValidatPort:(NSString *)port {

    if (port.length == 0) {
        return NO;
    }
    
    return ![[port substringToIndex:1] isEqualToString:@"0"] && [self isPureInt:port];

}

@end
