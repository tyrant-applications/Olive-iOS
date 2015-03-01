//
//  FriendsTableViewCell.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 1. 28..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "FriendsTableViewCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation FriendsTableViewCell
@synthesize img;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame = self.textLabel.frame;
    frame.origin.x = 70.0f;
    self.textLabel.frame = frame;

    
    if(thumb == nil){
        float thumbSize = 40.0f;
        thumb = [[UIImageView alloc] initWithFrame:CGRectMake(20, (self.frame.size.height - thumbSize)/2.0f, thumbSize, thumbSize)];
        thumb.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:thumb];
        
        CALayer *imageLayer = thumb.layer;
        [imageLayer setCornerRadius:thumbSize/2.0f];
        [imageLayer setMasksToBounds:YES];
        [imageLayer setBorderWidth:1];
        [imageLayer setBorderColor:RGB(0,0,0).CGColor];
        [imageLayer setMasksToBounds:YES];

    }
    
    thumb.image = [UIImage imageNamed:self.img];
}

@end
