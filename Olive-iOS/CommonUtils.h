//
//  CommonUtils.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 21..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtils : NSObject

+ (NSString *)removeWhiteSpacesString:(NSString *)str leading:(BOOL)first tailing:(BOOL)last;
+(BOOL)checkEmpty:(NSString *)str;

@end
