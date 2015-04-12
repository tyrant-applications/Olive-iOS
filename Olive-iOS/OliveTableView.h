//
//  OliveTableView.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 1..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OliveDetailView.h"

@interface OliveTableViewCell : UIControl{
    OLIVE_TYPE myType;
    UILabel *myText;
    UIImageView *myImage;
    NSString *myImageURLString;
    
    UIImageView *myLoc;
}
@property (nonatomic, retain) UILabel *myText;
@property (nonatomic, retain) UIImageView *myImage;
@property (nonatomic, retain) UIImageView *myLoc;
@property (nonatomic, copy) NSString *myImageURLString;
-(id)initWithIndex:(NSInteger)index myText:(BOOL)myText;
@end

@interface OliveTableView : UIScrollView{
    NSMutableArray *_messages;
}

@property (nonatomic, retain) NSMutableArray *_messages;
-(void)setOlives:(NSArray *)messages;
-(void)addOlive:(Messages *)message;
@end
