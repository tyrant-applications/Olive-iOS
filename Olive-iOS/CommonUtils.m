//
//  CommonUtils.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 21..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils

+(BOOL)checkEmpty:(NSString *)str{
    if(str == nil){
        return  YES;
    }else if([[CommonUtils removeWhiteSpacesString:str leading:YES tailing:YES] length] == 0){
        return YES;
    }
    return NO;
}


+ (NSString *)removeWhiteSpacesString:(NSString *)str leading:(BOOL)first tailing:(BOOL)last{
    NSString *result = [NSString stringWithString:str];
    if(first){
        NSRange range = [result rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
        result = [result stringByReplacingCharactersInRange:range withString:@""];
    }
    if(last){
        NSRange range = [result rangeOfString:@"\\s*$" options:NSRegularExpressionSearch];
        result = [result stringByReplacingCharactersInRange:range withString:@""];
    }
    return result;
}

@end
