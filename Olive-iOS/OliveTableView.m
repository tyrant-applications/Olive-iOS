//
//  OliveTableView.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 1..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "OliveTableView.h"

@implementation OliveTableViewCell
+(CGFloat)getWidth{
    return [UIScreen mainScreen].bounds.size.width/4.0f;
}

-(id)initWithIndex:(NSInteger)index{
    self = [super init];
    if(self){
        self.frame = CGRectMake([OliveTableViewCell getWidth]*index,0, [OliveTableViewCell getWidth], [ViewSettings getOliveTableViewHeight]);
        
        if (index%2 == 1) self.backgroundColor = RGB(217,217,217);
        else self.backgroundColor = RGB(211,236,253);

        CALayer *border = [CALayer layer];
        border.backgroundColor = [UIColor whiteColor].CGColor;
        border.frame = CGRectMake(0, 0, 0.5, self.frame.size.height);
        [self.layer addSublayer:border];
        
        NSArray *texts = [NSArray arrayWithObjects:@"Eat",@"When?",@"Now",
                          @"Where?",@"Where you want!",@"I don't know, you decide.",@"OK",@"Hey",
                          @"Why?",@"Coffee?", nil];
        [self setText:[texts objectAtIndex:index]];
    }
    return self;
}

-(void)setText:(NSString *)text{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, self.frame.size.width-8, self.frame.size.height-8)];
    
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    [self addSubview:label];
}
@end

@implementation OliveTableView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        for(int i=0; i<10; i++){
            OliveTableViewCell *cell = [[OliveTableViewCell alloc] initWithIndex:i];
            NSLog(@"%@",NSStringFromCGRect(cell.frame));
            [self addSubview:cell];
        }
        
        self.bounces = NO;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.contentSize = CGSizeMake(10*[OliveTableViewCell getWidth], self.frame.size.height);
    }
    return self;
}
@end
