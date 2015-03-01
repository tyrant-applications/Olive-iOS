//
//  OliveViewController.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 2. 22..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OliveTableView.h"
#import "OliveKeyboardContainerView.h"

@interface OliveViewController : UIViewController{
    NSString *_userID;
    
    OliveTableView *_tableView;
    OliveDetailView *_detailView;
    OliveKeyboardContainerView *_keyboardView;
}

@property (nonatomic, retain) NSString *_userID;

-(id)initWithUser:(NSString *)userid;

@end
