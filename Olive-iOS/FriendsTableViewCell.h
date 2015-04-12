//
//  FriendsTableViewCell.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 1. 28..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsTableViewCell : UITableViewCell{
    NSString *img;
    
    UIImageView *thumb;
}

@property (nonatomic, retain) NSString *img;

@end

@interface FindFriendsTableViewCell : UITableViewCell{
    NSString *img;
    
    UIImageView *thumb;
}

@property (nonatomic, retain) NSString *img;

@end
