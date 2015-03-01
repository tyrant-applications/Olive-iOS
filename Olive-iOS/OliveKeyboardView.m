//
//  OliveKeyboardView.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 1..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "OliveKeyboardView.h"

@implementation OliveKeyboardView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        //adding Buttons
        CGFloat width = frame.size.width / 5.0f;
        CGFloat height = (frame.size.height - 44.0f) / 4.0f;

        for(int row = 0; row<4; row++){
            for(int col = 0; col< 5; col++){
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
                [btn setTitle:[NSString stringWithFormat:@"%i",5*row+col] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn.frame = CGRectMake(col*width, row*height, width, height);
                [self addSubview:btn];
                
                CALayer *rightBorder = [CALayer layer];
                rightBorder.backgroundColor = OLIVE_DEFAULT_COLOR.CGColor;
                rightBorder.frame = CGRectMake(btn.frame.size.width, 0, 1.0f, btn.frame.size.height);
                [btn.layer addSublayer:rightBorder];

                CALayer *bottomBorder = [CALayer layer];
                bottomBorder.backgroundColor = OLIVE_DEFAULT_COLOR.CGColor;
                bottomBorder.frame = CGRectMake(0, btn.frame.size.height, btn.frame.size.width, 1.0f);
                [btn.layer addSublayer:bottomBorder];

            }
        }
        
    }
    return self;
}

@end
