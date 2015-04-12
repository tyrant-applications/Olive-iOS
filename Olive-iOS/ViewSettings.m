//
//  ViewSettings.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 1..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "ViewSettings.h"

@implementation ViewSettings

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+(CGFloat)getOliveKeyboardHeight{
    return 240.0f + 44.0f;
}

+(CGFloat)getOliveTableViewHeight{
    return [UIScreen mainScreen].bounds.size.width/4.0f;
}


+(UIColor *)getYourTextColor{
    return RGB(217,217,217);
}
+(UIColor *)getMyTextColor{
    return RGB(211,236,253);
}
@end
