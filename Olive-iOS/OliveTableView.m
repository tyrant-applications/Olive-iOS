//
//  OliveTableView.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 1..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "OliveTableView.h"
#import "SDWebImage/UIImageView+WebCache.h"

#define  CELLS_IN_SCREEN_WIDTH 4

@implementation OliveTableViewCell
@synthesize myText;
@synthesize myImage;
@synthesize myLoc;
@synthesize myImageURLString;

+(CGFloat)getWidth{
    return [UIScreen mainScreen].bounds.size.width/CELLS_IN_SCREEN_WIDTH;
}

-(id)initWithIndex:(NSInteger)index myText:(BOOL)isMyText{
    self = [super init];
    if(self){
        self.frame = CGRectMake([OliveTableViewCell getWidth]*index,0, [OliveTableViewCell getWidth], [ViewSettings getOliveTableViewHeight]);

        if (isMyText) self.backgroundColor = [ViewSettings getMyTextColor];
        else self.backgroundColor = [ViewSettings getYourTextColor];

        
        self.myText = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, self.frame.size.width-8, self.frame.size.height-8)];
        self.myText.textAlignment = NSTextAlignmentCenter;
        self.myText.backgroundColor = [UIColor clearColor];
        self.myText.font = [UIFont systemFontOfSize:12.0f];
        self.myText.numberOfLines = 0;
        self.myText.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:self.myText];
        
        self.myImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.myImage.contentMode = UIViewContentModeScaleAspectFill;
        self.myImage.clipsToBounds = YES;
        [self addSubview:self.myImage];
        
        UIImageView *imageOver = [[UIImageView alloc] initWithFrame:self.myImage.frame];
        imageOver.contentMode = UIViewContentModeCenter;
        imageOver.backgroundColor = RGBA(0, 0, 0, 0.3);
        [imageOver setImage:[UIImage imageNamed:@"img_overlay.png"]];
        [self.myImage addSubview:imageOver];

        self.myLoc = [[UIImageView alloc] initWithFrame:self.myImage.frame];
        self.myLoc.contentMode = UIViewContentModeCenter;
        self.myLoc.backgroundColor = RGBA(0, 0, 0, 0.3);
        [self.myLoc setImage:[UIImage imageNamed:@"loc_overlay.png"]];
        [self addSubview:self.myLoc];

        
        UIControl* overlay = [[UIControl alloc] initWithFrame:self.myImage.frame];
        
        [self addSubview:overlay];
        
        CAGradientLayer *shadow = [CAGradientLayer layer];
        shadow.frame = CGRectMake(0, 0, 5.0f, self.bounds.size.height);
        [shadow setStartPoint:CGPointMake(0.0, 0.5)];
        [shadow setEndPoint:CGPointMake(1.0, 0.5)];
        shadow.colors = [NSArray arrayWithObjects:(id)[RGBA(0, 0, 0, 0.25) CGColor], (id)[[UIColor clearColor] CGColor], nil];
        [overlay.layer addSublayer:shadow];
        
        CALayer *border = [CALayer layer];
        border.backgroundColor = RGBA(255, 255, 255, 0.75).CGColor;
        border.frame = CGRectMake(0, 0, 1, self.frame.size.height);
        [overlay.layer addSublayer:border];
        
        
        
        [overlay addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
        

    }
    return self;
}
-(void)tapped{
    
    NSDictionary *dict = nil;
    
    if(myType == OLIVE_TEXT){
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
         [NSNumber numberWithInt:myType],@"type",
                self.myText,@"contents", nil];
    }else if(myType == OLIVE_IMAGE){
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithInt:myType],@"type",
                self.myImageURLString,@"contents", nil];
    }else if(myType == OLIVE_LOCATION){
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithInt:myType],@"type",
                self.myText,@"contents", nil];
    }
    
    if(dict != nil)
        [[NSNotificationCenter defaultCenter] postNotificationName:OLIVE_TAPPED object:dict];

}

-(void)setContents:(NSString *)contents type:(NSNumber *)msg_type{
    self.myText.hidden= YES;
    self.myImage.hidden = YES;
    self.myLoc.hidden = YES;
    
    myType = [msg_type intValue];
    if(myType == OLIVE_TEXT){
        self.myText.hidden = NO;
        self.myText.text = contents;
    }else if(myType == OLIVE_IMAGE)
    {
        self.myImage.hidden = NO;
        self.myImageURLString = [NSString stringWithFormat:@"%@",contents];
        [self.myImage sd_setImageWithURL:[NSURL URLWithString:THUMB_URL_SIZE(self.myImageURLString,@"l")] placeholderImage:nil];
    }else if(myType == OLIVE_LOCATION){
        self.myLoc.hidden = NO;
        self.myText.text = contents;
    }
}

@end

@implementation OliveTableView
@synthesize _messages;
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self._messages = [[NSMutableArray alloc] init];
        /*
        for(int i=0; i<10; i++){
            OliveTableViewCell *cell = [[OliveTableViewCell alloc] initWithIndex:i];
            NSLog(@"%@",NSStringFromCGRect(cell.frame));
            [self addSubview:cell];
        }*/
        
        
        
        //self.bounces = NO;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}


-(void)setOlives:(NSArray *)messages{
    [self._messages removeAllObjects];
    [self._messages addObjectsFromArray:messages];
    
    int i=0;
    for(Messages *message in messages){
        BOOL myText = ([[[OLNetworkManager manager] getUsername] isEqualToString:message.author]);
        OliveTableViewCell *cell = [[OliveTableViewCell alloc] initWithIndex:i myText:myText];
        [cell setContents:message.contents type:message.msg_type];
//        NSLog(@"%@",NSStringFromCGRect(cell.frame));
        [self addSubview:cell];
        i++;
        
        if(i == [messages count]){
            [cell tapped];
        }
    }
    
    [self updateOliveTableView];
}

-(void)addOlive:(Messages *)message{
    if([self._messages containsObject:message]){
        return;
    }
    BOOL myText = ([[[OLNetworkManager manager] getUsername] isEqualToString:message.author]);
    OliveTableViewCell *cell = [[OliveTableViewCell alloc] initWithIndex:[self._messages count] myText:myText];
    [cell setContents:message.contents type:message.msg_type];
//    NSLog(@"%@",NSStringFromCGRect(cell.frame));
    [self addSubview:cell];
    
    [self._messages addObject:message];

    [self updateOliveTableView];
    
}

-(void)updateOliveTableView{
    self.contentSize = CGSizeMake([self._messages count]*[OliveTableViewCell getWidth], self.frame.size.height);
    
    int offset = ([self._messages count] - CELLS_IN_SCREEN_WIDTH);
    CGFloat offX = MAX(0, offset*[OliveTableViewCell getWidth]);
    [self setContentOffset:CGPointMake(offX, 0) animated:YES];
}

- (BOOL) touchesShouldCancelInContentView:(UIView *)view {
    return YES;
}

@end
