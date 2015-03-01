//
//  OliveKeyboardView.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 1..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "OliveKeyboardContainerView.h"
#import "OliveKeyboardView.h"

#define TOOLBAR_HEIGHT 44.0f

@implementation OliveKeyboardScrollView
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if ( [view isKindOfClass:[UIButton class]] ) {
        return YES;
    }
    
    return [super touchesShouldCancelInContentView:view];
}
@end

@implementation OliveKeyboardContainerView
@synthesize _scrollView;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        self._scrollView = [[OliveKeyboardScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-44.0f)];
        [self addSubview:self._scrollView];
        for(int i=0; i<3; i++){
            OliveKeyboardView *aView = [[OliveKeyboardView alloc] initWithFrame:CGRectMake(frame.size.width*i, 0, frame.size.width, frame.size.height)];
            
            [self._scrollView addSubview:aView];
        }
        self._scrollView.canCancelContentTouches = YES;
        self._scrollView.showsHorizontalScrollIndicator = NO;
        self._scrollView.showsVerticalScrollIndicator = NO;
        self._scrollView.contentSize = CGSizeMake(frame.size.width*2.0f, frame.size.height-44.0f);
        self._scrollView.pagingEnabled = YES;
        self._scrollView.bounces = NO;
        
        CALayer *border = [CALayer layer];
        border.backgroundColor = OLIVE_DEFAULT_COLOR.CGColor;
        border.frame = CGRectMake(0, 0, frame.size.width, 1.0f);
        [self.layer addSublayer:border];
        
        [self setupBottomBar];
    }
    return self;
}

-(void)setupBottomBar{
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - TOOLBAR_HEIGHT, self.frame.size.width, TOOLBAR_HEIGHT)];
    bottom.backgroundColor = OLIVE_DEFAULT_COLOR;
    [self addSubview:bottom];
    
    NSArray *btnTitles = [NSArray arrayWithObjects:@"text",@"camera",@"gallery",@"voice",@"locate", nil];
    CGFloat width = self.frame.size.width/5.0f;
    for(int i=0; i<5; i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.contentMode = UIViewContentModeScaleAspectFit;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bg_keypad_%@_normal.png",[btnTitles objectAtIndex:i]]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bg_keypad_%@_pressed.png",[btnTitles objectAtIndex:i]]] forState:UIControlStateHighlighted];
        btn.frame = CGRectMake(i*width, 0, width, TOOLBAR_HEIGHT);
        [bottom addSubview:btn];
    }
    
}

@end
