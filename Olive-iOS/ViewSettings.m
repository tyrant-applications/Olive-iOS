//
//  ViewSettings.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 1..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "ViewSettings.h"

@implementation ViewSettings

+(CGFloat)getOliveKeyboardHeight{
    return 216.0f + 44.0f;
}

+(CGFloat)getOliveTableViewHeight{
    return [UIScreen mainScreen].bounds.size.width/4.0f;
}
@end
