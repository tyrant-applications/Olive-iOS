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
@synthesize delegate = _delegate;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        self._scrollView = [[OliveKeyboardScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-44.0f)];
        [self addSubview:self._scrollView];
        for(int i=0; i<3; i++){
            NSArray *btns = [[CoreDataManager manager] getAllKeyboardButtonsInPage:i];
            OliveKeyboardView *aView = [[OliveKeyboardView alloc] initWithFrame:CGRectMake(frame.size.width*i, 0, frame.size.width, frame.size.height) buttons:btns];
            
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
        border.frame = CGRectMake(0, 0, frame.size.width, 3.0f);
        [self.layer addSublayer:border];
        
        
        UIView *tri = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
        tri.center = CGPointMake(self.center.x, tri.center.y);
        tri.backgroundColor = OLIVE_DEFAULT_COLOR;
        [self addSubview:tri];
        
        // Build a triangular path
        UIBezierPath *path = [UIBezierPath new];
        [path moveToPoint:(CGPoint){0, 0}];
        [path addLineToPoint:(CGPoint){10, 10}];
        [path addLineToPoint:(CGPoint){20, 0}];
        [path addLineToPoint:(CGPoint){0, 0}];
        
        // Create a CAShapeLayer with this triangular path
        // Same size as the original imageView
        CAShapeLayer *mask = [CAShapeLayer new];
        mask.frame = tri.bounds;
        mask.path = path.CGPath;
        
        // Mask the imageView's layer with this shape
        tri.layer.mask = mask;

        
        [self setupBottomBar];
    }
    return self;
}

-(void)setupBottomBar{
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - TOOLBAR_HEIGHT, self.frame.size.width, TOOLBAR_HEIGHT)];
    bottom.backgroundColor = OLIVE_DEFAULT_COLOR;
    [self addSubview:bottom];
    
    NSArray *btnTitles = [NSArray arrayWithObjects:@"text",@"camera",@"gallery",@"locate", nil];
    CGFloat width = self.frame.size.width/4.0f;
    for(int i=0; i<4; i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bg_keypad_%@_normal.png",[btnTitles objectAtIndex:i]]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bg_keypad_%@_pressed.png",[btnTitles objectAtIndex:i]]] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(i*width, 0, width, TOOLBAR_HEIGHT);
        [bottom addSubview:btn];
    }
    
}

-(void)bottomBtnClicked:(UIButton *)sender{

    switch (sender.tag) {
        case 1:
            [_delegate openCamera];
            break;
        case 2:
            [_delegate openPhotoAlbum];
            break;
        case 3:
            [_delegate openMapViewController];
            break;
        default:
            break;
    }

}

@end
