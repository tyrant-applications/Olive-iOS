//
//  OliveKeyboardView.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 1..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "OliveKeyboardView.h"

@implementation OliveButton
@synthesize myBtnInfo;

-(void)postOlive{
    [[NSNotificationCenter defaultCenter] postNotificationName:OLIVE_BUTTON_TAPPED object:self.myBtnInfo.contents];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit Button" message:self.myBtnInfo.contents delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == alertView.cancelButtonIndex){
        return;
    }
    self.myBtnInfo.contents = [[alertView textFieldAtIndex:0] text];
    [[CoreDataManager manager] save];
    
    [self setTitle:self.myBtnInfo.contents forState:UIControlStateNormal];

}
@end


@implementation OliveKeyboardView


#define KEYBOARD_ROWS 3
#define KEYBOARD_COLS 4

-(id)initWithFrame:(CGRect)frame buttons:(NSArray *)sets{
    self = [super initWithFrame:frame];
    if(self){
        //adding Buttons
        CGFloat width = frame.size.width / KEYBOARD_COLS;
        CGFloat height = (frame.size.height - 44.0f) / KEYBOARD_ROWS;
        
        for(int row = 0; row< KEYBOARD_ROWS; row++){
            for(int col = 0; col< KEYBOARD_COLS; col++){
                KeyboardButton *keyBtnInfo = (KeyboardButton *)[sets objectAtIndex: KEYBOARD_COLS*row+col];
                OliveButton *btn = [OliveButton buttonWithType:UIButtonTypeCustom];
                btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
                btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                btn.myBtnInfo = keyBtnInfo;
                [btn setTitle:keyBtnInfo.contents forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn addTarget:btn action:@selector(postOlive) forControlEvents:UIControlEventTouchUpInside];
                UILongPressGestureRecognizer *long_tap = [[UILongPressGestureRecognizer alloc]
                                                      initWithTarget:btn action:@selector(handleLongPress:)];
                [btn addGestureRecognizer:long_tap];

                [btn setBackgroundImage:[ViewSettings imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
                [btn setBackgroundImage:[ViewSettings imageWithColor:OLIVE_DEFAULT_COLOR_ALPHA] forState:UIControlStateHighlighted];

                
                btn.frame = CGRectMake(col*width, row*height, width, height);
                [self addSubview:btn];
                
                CALayer *rightBorder = [CALayer layer];
                rightBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
                rightBorder.frame = CGRectMake(btn.frame.size.width-.5f, 0, .5f, btn.frame.size.height);
                [btn.layer addSublayer:rightBorder];

                CALayer *bottomBorder = [CALayer layer];
                bottomBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
                bottomBorder.frame = CGRectMake(0, btn.frame.size.height-.5f, btn.frame.size.width, .5f);
                [btn.layer addSublayer:bottomBorder];

            }
        }
        
    }
    return self;
}

@end
