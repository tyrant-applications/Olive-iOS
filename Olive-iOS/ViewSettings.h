//
//  ViewSettings.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 1..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewSettings : NSObject

+ (UIImage *)imageWithColor:(UIColor *)color;

+(CGFloat)getOliveKeyboardHeight;
+(CGFloat)getOliveTableViewHeight;

+(UIColor *)getMyTextColor;
+(UIColor *)getYourTextColor;
@end
